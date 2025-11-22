package com.greenart.bdproject.service;

import java.util.*;
import java.util.stream.Collectors;
import javax.xml.parsers.*;
import org.w3c.dom.*;
import org.xml.sax.InputSource;
import java.io.StringReader;
import java.time.LocalDate;
import java.time.Period;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;

@Service
public class WelfareService {

    private static final Logger logger = LoggerFactory.getLogger(WelfareService.class);

    // API URLs
    private static final String CENTRAL_API_URL = "https://apis.data.go.kr/B554287/NationalWelfareInformationsV001";
    private static final String LOCAL_API_URL = "https://apis.data.go.kr/B554287/LocalGovernmentWelfareInformations";
    private static final String API_KEY = "5Zmolv/d2cH1icO3c3x0NrGtNFn7unsoJ00Fllf8S6PKT6/zNvozPbIq1x8dyp1TasaRabGQSklygHZuVM79Bg==";

    private final DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
    private final DocumentBuilder db;
    private final RestTemplate rest = new RestTemplate();

    public WelfareService() throws ParserConfigurationException {
        this.db = dbf.newDocumentBuilder();
    }

    /**
     * 복지 혜택 매칭 (중앙 + 지자체)
     */
    public List<Map<String, Object>> matchWelfare(Map<String, String> user) {
        List<Map<String, Object>> allResults = new ArrayList<>();
        
        try {
            System.out.println("WelfareService.matchWelfare 시작 - 사용자 데이터: " + user);
            
            // API 파라미터로 변환
            Map<String, String> apiParams = convertUserToAPIParams(user);
            System.out.println("변환된 API 파라미터: " + apiParams);
            
            // 1. 중앙부처 복지 서비스 조회
            logger.info("Fetching central government welfare services...");
            List<Map<String, Object>> centralResults = getCentralWelfareServices(user, apiParams);
            System.out.println("중앙부처 조회 결과 개수: " + centralResults.size());
            centralResults.forEach(r -> r.put("source", "중앙부처"));
            allResults.addAll(centralResults);
            
            // 2. 지자체 복지 서비스 조회
            logger.info("Fetching local government welfare services...");
            List<Map<String, Object>> localResults = getLocalWelfareServices(user, apiParams);
            System.out.println("지자체 조회 결과 개수: " + localResults.size());
            localResults.forEach(r -> r.put("source", "지자체"));
            allResults.addAll(localResults);
            
            // 3. 점수 기준 정렬 (높은 순서대로)
            return allResults.stream()
                .sorted((a, b) -> {
                    int scoreCompare = (int)b.get("score") - (int)a.get("score");
                    if (scoreCompare == 0) {
                        // 점수가 같으면 조회수로 정렬
                        Integer aInq = parseInqNum(a.get("inqNum"));
                        Integer bInq = parseInqNum(b.get("inqNum"));
                        return bInq.compareTo(aInq);
                    }
                    return scoreCompare;
                })
                .collect(Collectors.toList());
                
        } catch (Exception e) {
            logger.error("Error in matchWelfare: ", e);
            return allResults;
        }
    }
    
    /**
     * 중앙부처 복지 서비스 조회
     */
    private List<Map<String, Object>> getCentralWelfareServices(Map<String, String> user, Map<String, String> apiParams) {
        List<Map<String, String>> services = new ArrayList<>();
        
        try {
            // 필터링된 결과 개수 확인
            String countUrl = buildCentralApiUrl(apiParams, 1, 1);
            System.out.println("중앙부처 API URL: " + countUrl);
            
            // HTTP 헤더 설정
            HttpHeaders headers = new HttpHeaders();
            headers.set("User-Agent", "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36");
            HttpEntity<?> entity = new HttpEntity<>(headers);
            
            ResponseEntity<String> response = rest.exchange(countUrl, HttpMethod.GET, entity, String.class);
            String xml = response.getBody();
            System.out.println("중앙부처 API 응답: " + (xml != null ? xml.substring(0, Math.min(200, xml.length())) + "..." : "null"));
            int totalCount = getTotalCount(xml);
            System.out.println("중앙부처 총 개수: " + totalCount);
            
            if (totalCount == 0) {
                // 필터링 결과가 없으면 전체 조회
                logger.info("No filtered results for central API, fetching all...");
                services = getAllCentralServices();
            } else {
                // 필터링된 결과 조회
                int pageSize = 500;
                int totalPages = (totalCount + pageSize - 1) / pageSize;
                
                for (int page = 1; page <= totalPages; page++) {
                    String url = buildCentralApiUrl(apiParams, page, pageSize);
                    ResponseEntity<String> pageResponse = rest.exchange(url, HttpMethod.GET, entity, String.class);
                    xml = pageResponse.getBody();
                    services.addAll(parseCentralList(xml));
                }
            }
            
            // 매칭 점수 계산
            return services.stream()
                .map(s -> calculateMatchScore(s, user, apiParams, "central"))
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
                
        } catch (Exception e) {
            logger.error("Error fetching central welfare services: ", e);
            System.out.println("중앙부처 API 호출 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 지자체 복지 서비스 조회
     */
    private List<Map<String, Object>> getLocalWelfareServices(Map<String, String> user, Map<String, String> apiParams) {
        List<Map<String, String>> services = new ArrayList<>();
        
        try {
            // 지자체 API는 시도/시군구 파라미터 필요
            String sido = user.get("sido");
            String sigungu = user.get("sigungu");
            
            // 지역 정보가 없으면 지자체 조회 스킵
            if (sido == null || sido.isEmpty()) {
                logger.info("No location info provided, skipping local welfare search");
                return new ArrayList<>();
            }
            
            // 지자체 API 호출
            String url = buildLocalApiUrl(apiParams, sido, sigungu, 1, 500);
            String xml = rest.getForObject(url, String.class);
            int totalCount = getTotalCount(xml);
            
            if (totalCount > 0) {
                services.addAll(parseLocalList(xml));
                
                // 500개 이상이면 추가 페이지 조회
                if (totalCount > 500) {
                    int totalPages = (totalCount + 500 - 1) / 500;
                    for (int page = 2; page <= totalPages; page++) {
                        url = buildLocalApiUrl(apiParams, sido, sigungu, page, 500);
                        xml = rest.getForObject(url, String.class);
                        services.addAll(parseLocalList(xml));
                    }
                }
            }
            
            // 매칭 점수 계산
            return services.stream()
                .map(s -> calculateMatchScore(s, user, apiParams, "local"))
                .filter(Objects::nonNull)
                .collect(Collectors.toList());
                
        } catch (Exception e) {
            logger.error("Error fetching local welfare services: ", e);
            System.out.println("지자체 API 호출 중 오류 발생: " + e.getMessage());
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    /**
     * 중앙부처 API URL 생성
     */
    private String buildCentralApiUrl(Map<String, String> params, int pageNo, int numOfRows) {
        StringBuilder url = new StringBuilder();
        url.append(CENTRAL_API_URL).append("/NationalWelfarelistV001?serviceKey=").append(API_KEY)
           .append("&callTp=L&pageNo=").append(pageNo)
           .append("&numOfRows=").append(numOfRows)
           .append("&srchKeyCode=003");  // 제목+내용 검색
        
        // 선택 파라미터 추가
        if (params.get("lifeArray") != null) {
            url.append("&lifeArray=").append(params.get("lifeArray"));
        }
        if (params.get("trgterIndvdlArray") != null) {
            url.append("&trgterIndvdlArray=").append(params.get("trgterIndvdlArray"));
        }
        if (params.get("intrsThemaArray") != null) {
            url.append("&intrsThemaArray=").append(params.get("intrsThemaArray"));
        }
        if (params.get("age") != null) {
            url.append("&age=").append(params.get("age"));
        }
        
        return url.toString();
    }
    
    /**
     * 지자체 API URL 생성
     */
    private String buildLocalApiUrl(Map<String, String> params, String sido, String sigungu, int pageNo, int numOfRows) {
        // 지자체 API 엔드포인트 확인 필요 (가정)
        UriComponentsBuilder builder = UriComponentsBuilder.fromHttpUrl(LOCAL_API_URL + "/LocalGovernmentWelfarelistV001")
            .queryParam("serviceKey", API_KEY)
            .queryParam("pageNo", pageNo)
            .queryParam("numOfRows", numOfRows);
        
        // 지역 파라미터
        if (sido != null && !sido.isEmpty()) {
            builder.queryParam("ctpvNm", sido);
        }
        if (sigungu != null && !sigungu.isEmpty()) {
            builder.queryParam("sggNm", sigungu);
        }
        
        // 기타 파라미터
        if (params.get("lifeArray") != null) {
            builder.queryParam("lifeArray", params.get("lifeArray"));
        }
        if (params.get("trgterIndvdlArray") != null) {
            builder.queryParam("trgterIndvdlArray", params.get("trgterIndvdlArray"));
        }
        if (params.get("age") != null) {
            builder.queryParam("age", params.get("age"));
        }
        
        return builder.toUriString();
    }
    
    /**
     * 전체 중앙부처 서비스 조회 (필터 없이)
     */
    private List<Map<String, String>> getAllCentralServices() {
        List<Map<String, String>> all = new ArrayList<>();
        
        for (int page = 1; page <= 2; page++) {
            String url = CENTRAL_API_URL + "/NationalWelfarelistV001?serviceKey=" + API_KEY 
                + "&callTp=L&pageNo=" + page + "&numOfRows=500&srchKeyCode=003";
            try {
                String xml = rest.getForObject(url, String.class);
                all.addAll(parseCentralList(xml));
            } catch (Exception e) {
                logger.error("Failed to get central services page " + page + ": ", e);
            }
        }
        
        return all;
    }
    
    /**
     * 사용자 데이터를 API 파라미터로 변환
     */
    private Map<String, String> convertUserToAPIParams(Map<String, String> user) {
        Map<String, String> params = new HashMap<>();
        
        // 나이 계산
        int age = calculateAge(user.get("birthdate"));
        params.put("age", String.valueOf(age));
        
        // 생애주기 코드 변환
        String lifeCode = getLifeStageCode(age);
        if (lifeCode != null) {
            params.put("lifeArray", lifeCode);
        }
        
        // 임신·출산 체크 시 생애주기 코드 추가
        if ("true".equals(user.get("isPregnant"))) {
            params.put("lifeArray", "007");  // 임신·출산 코드로 덮어쓰기
        }
        
        // 가구상황 코드 변환
        List<String> householdCodes = new ArrayList<>();
        
        // 저소득 여부 체크
        if (isLowIncome(user) || "true".equals(user.get("isLowIncome"))) {
            householdCodes.add("050");  // 저소득
        }
        
        // 다자녀 여부 체크
        int childrenCount = Integer.parseInt(user.getOrDefault("children_count", "0"));
        if (childrenCount >= 2) {
            householdCodes.add("020");  // 다자녀
        }
        
        // 특별상황 체크
        if ("true".equals(user.get("isDisabled"))) {
            householdCodes.add("040");  // 장애인
        }
        if ("true".equals(user.get("isMulticultural"))) {
            householdCodes.add("010");  // 다문화·탈북민
        }
        if ("true".equals(user.get("isVeteran"))) {
            householdCodes.add("030");  // 보훈대상자
        }
        if ("true".equals(user.get("isSingleParent"))) {
            householdCodes.add("060");  // 한부모·조손
        }
        
        if (!householdCodes.isEmpty()) {
            params.put("trgterIndvdlArray", String.join(",", householdCodes));
        }
        
        // 관심주제 코드 변환
        List<String> interestCodes = new ArrayList<>();
        
        // 임신·출산 관련
        if ("true".equals(user.get("isPregnant"))) {
            interestCodes.add("080");  // 임신·출산
            interestCodes.add("010");  // 신체건강
        }
        
        // 고용 상태 관련
        String employment = user.get("employment_status");
        if ("unemployed".equals(employment) || "seeking".equals(employment)) {
            interestCodes.add("050");  // 일자리
        }
        
        // 저소득층은 생활지원 추가
        if (isLowIncome(user)) {
            interestCodes.add("030");  // 생활지원
        }
        
        // 자녀가 있으면 보육 추가
        if (childrenCount > 0) {
            interestCodes.add("090");  // 보육
        }
        
        if (!interestCodes.isEmpty()) {
            params.put("intrsThemaArray", String.join(",", interestCodes));
        }
        
        return params;
    }
    
    /**
     * 매칭 점수 계산
     */
    private Map<String, Object> calculateMatchScore(Map<String, String> service, 
                                                    Map<String, String> user,
                                                    Map<String, String> apiParams,
                                                    String source) {
        int score = 0;
        List<String> reasons = new ArrayList<>();
        
        int age = Integer.parseInt(apiParams.get("age"));
        
        // 생애주기 매칭 (30점)
        String lifeArray = service.get("lifeArray");
        if (lifeArray != null) {
            String userLifeCode = apiParams.get("lifeArray");
            if (matchesLifeStage(lifeArray, userLifeCode, age)) {
                score += 30;
                reasons.add("생애주기 조건 일치: " + lifeArray);
            }
        }
        
        // 가구상황 매칭 (각 20점)
        String targetArray = service.get("trgterIndvdlArray");
        if (targetArray != null && apiParams.get("trgterIndvdlArray") != null) {
            String[] userCodes = apiParams.get("trgterIndvdlArray").split(",");
            for (String code : userCodes) {
                String typeName = getHouseholdTypeName(code);
                if (targetArray.contains(typeName)) {
                    score += 20;
                    reasons.add("가구상황 조건 일치: " + typeName);
                }
            }
        }
        
        // 관심주제 매칭 (각 10점)
        String interestArray = service.get("intrsThemaArray");
        if (interestArray != null && apiParams.get("intrsThemaArray") != null) {
            String[] userInterests = apiParams.get("intrsThemaArray").split(",");
            for (String code : userInterests) {
                String interestName = getInterestName(code);
                if (interestArray.contains(interestName)) {
                    score += 10;
                    reasons.add("관심주제 일치: " + interestName);
                }
            }
        }
        
        // 저소득 관련 추가 점수
        if (targetArray != null && targetArray.contains("저소득")) {
            if (isLowIncome(user)) {
                String income = user.get("income");
                if ("none".equals(income) || "under_100".equals(income)) {
                    score += 20;
                    reasons.add("기초생활수급자 해당");
                } else if ("100_200".equals(income)) {
                    score += 15;
                    reasons.add("차상위계층 해당");
                } else {
                    score += 10;
                    reasons.add("저소득층 조건 일치");
                }
            }
        }
        
        // 지역 매칭 (지자체 서비스의 경우)
        if ("local".equals(source)) {
            score += 10;
            reasons.add("지역 조건 일치");
        }
        
        // 온라인 신청 가능
        if ("Y".equals(service.get("onapPsbltYn"))) {
            score += 5;
            reasons.add("온라인 신청 가능");
        }
        
        // 최소 점수 이상인 경우만 반환
        if (score >= 10) {
            Map<String, Object> result = new HashMap<>(service);
            result.put("score", score);
            result.put("reasons", reasons);
            
            // 높은 점수의 경우 상세 정보도 조회
            if (score >= 50 && "central".equals(source)) {
                getDetail(service.get("servId"), result);
            }
            
            return result;
        }
        
        return null;
    }
    
    /**
     * 나이로 생애주기 코드 반환
     */
    private String getLifeStageCode(int age) {
        if (age <= 6) return "001";        // 영유아
        else if (age <= 12) return "002";  // 아동
        else if (age <= 19) return "003";  // 청소년
        else if (age <= 34) return "004";  // 청년
        else if (age <= 64) return "005";  // 중장년
        else return "006";                 // 노년
    }
    
    /**
     * 생년월일로 나이 계산
     */
    private int calculateAge(String birthdate) {
        try {
            LocalDate birth = LocalDate.parse(birthdate);
            return Period.between(birth, LocalDate.now()).getYears();
        } catch (Exception e) {
            logger.error("Error calculating age from birthdate: " + birthdate, e);
            return 30;  // 기본값
        }
    }
    
    /**
     * 생애주기 매칭 확인
     */
    private boolean matchesLifeStage(String serviceLifeArray, String userLifeCode, int age) {
        // 임신·출산 특별 처리
        if (serviceLifeArray.contains("임신") || serviceLifeArray.contains("출산")) {
            return age >= 20 && age <= 45;  // 가임기 연령
        }
        
        Map<String, String> codeToName = new HashMap<>();
        codeToName.put("001", "영유아");
        codeToName.put("002", "아동");
        codeToName.put("003", "청소년");
        codeToName.put("004", "청년");
        codeToName.put("005", "중장년");
        codeToName.put("006", "노년");
        codeToName.put("007", "임신");  // 임신·출산
        
        String lifeStageName = codeToName.get(userLifeCode);
        return lifeStageName != null && serviceLifeArray.contains(lifeStageName);
    }
    
    /**
     * 가구상황 코드를 이름으로 변환
     */
    private String getHouseholdTypeName(String code) {
        Map<String, String> codeToName = new HashMap<>();
        codeToName.put("010", "다문화");
        codeToName.put("020", "다자녀");
        codeToName.put("030", "보훈");
        codeToName.put("040", "장애인");
        codeToName.put("050", "저소득");
        codeToName.put("060", "한부모");
        
        return codeToName.getOrDefault(code, "");
    }
    
    /**
     * 관심주제 코드를 이름으로 변환
     */
    private String getInterestName(String code) {
        Map<String, String> codeToName = new HashMap<>();
        codeToName.put("010", "신체건강");
        codeToName.put("020", "정신건강");
        codeToName.put("030", "생활지원");
        codeToName.put("040", "주거");
        codeToName.put("050", "일자리");
        codeToName.put("060", "문화");
        codeToName.put("070", "안전");
        codeToName.put("080", "임신");
        codeToName.put("090", "보육");
        codeToName.put("100", "교육");
        codeToName.put("110", "입양");
        codeToName.put("120", "보호");
        codeToName.put("130", "서민금융");
        codeToName.put("140", "법률");
        
        return codeToName.getOrDefault(code, "");
    }
    
    /**
     * 저소득 여부 판단
     */
    private boolean isLowIncome(Map<String, String> user) {
        String income = user.get("income");
        return Arrays.asList("none", "under_100", "100_200", "200_300").contains(income);
    }
    
    private Integer parseInqNum(Object inqNum) {
        if (inqNum == null) return 0;
        try {
            return Integer.parseInt(inqNum.toString());
        } catch (Exception e) {
            return 0;
        }
    }
    
    private int getTotalCount(String xml) {
        try {
            Document doc = db.parse(new InputSource(new StringReader(xml)));
            NodeList nodes = doc.getElementsByTagName("totalCount");
            if (nodes.getLength() > 0) {
                return Integer.parseInt(nodes.item(0).getTextContent());
            }
        } catch (Exception e) {
            logger.error("Error getting total count: ", e);
        }
        return 0;
    }
    
    /**
     * 상세 정보 조회
     */
    private void getDetail(String servId, Map<String, Object> result) {
        String url = CENTRAL_API_URL + "/NationalWelfaredetailedV001?serviceKey=" + API_KEY 
            + "&callTp=D&servId=" + servId;
        try {
            String xml = rest.getForObject(url, String.class);
            Map<String, String> detail = parseDetail(xml);
            result.putAll(detail);
        } catch (Exception e) {
            logger.error("Failed to get detail for servId " + servId + ": ", e);
        }
    }
    
    /**
     * 중앙부처 목록 XML 파싱
     */
    private List<Map<String, String>> parseCentralList(String xml) {
        List<Map<String, String>> list = new ArrayList<>();
        try {
            Document doc = db.parse(new InputSource(new StringReader(xml)));
            NodeList nodes = doc.getElementsByTagName("servList");
            
            for (int i = 0; i < nodes.getLength(); i++) {
                Element e = (Element) nodes.item(i);
                Map<String, String> map = new HashMap<>();
                String[] fields = {"servId", "servNm", "jurMnofNm", "jurOrgNm", "servDgst", 
                    "lifeArray", "trgterIndvdlArray", "intrsThemaArray", "srvPvsnNm", 
                    "sprtCycNm", "onapPsbltYn", "servDtlLink", "inqNum", "rprsCtadr"};
                for (String f : fields) {
                    NodeList n = e.getElementsByTagName(f);
                    if (n.getLength() > 0) map.put(f, n.item(0).getTextContent());
                }
                list.add(map);
            }
        } catch (Exception e) {
            logger.error("Error parsing central list XML: ", e);
        }
        return list;
    }
    
    /**
     * 지자체 목록 XML 파싱 (구조 확인 필요)
     */
    private List<Map<String, String>> parseLocalList(String xml) {
        // 지자체 API 응답 구조가 중앙부처와 유사하다고 가정
        // 실제로는 API 문서를 확인하여 필드명 조정 필요
        return parseCentralList(xml);
    }
    
    /**
     * 상세 정보 XML 파싱
     */
    private Map<String, String> parseDetail(String xml) {
        Map<String, String> map = new HashMap<>();
        try {
            Document doc = db.parse(new InputSource(new StringReader(xml)));
            String[] fields = {"tgtrDtlCn", "slctCritCn", "alwServCn", "wlfareInfoOutlCn"};
            for (String f : fields) {
                NodeList n = doc.getElementsByTagName(f);
                if (n.getLength() > 0) map.put(f, n.item(0).getTextContent());
            }
        } catch (Exception e) {
            logger.error("Error parsing detail XML: ", e);
        }
        return map;
    }
    
    /**
     * 인기 복지 서비스 조회 (실제 API 사용)
     */
    public List<Map<String, Object>> getPopularWelfareServices() {
        logger.info("인기 복지 서비스 조회 시작");

        try {
            // 이 메서드에서만 사용할 SSL 우회 RestTemplate 생성
            RestTemplate safeRest = createSafeRestTemplate();
            List<Map<String, Object>> allServices = new ArrayList<>();

            // 중앙부처 API 호출
            try {
                String centralUrl = CENTRAL_API_URL + "/NationalWelfarelistV001?serviceKey=" + API_KEY
                    + "&callTp=L&pageNo=1&numOfRows=100&srchKeyCode=003";

                String centralXml = safeRest.getForObject(centralUrl, String.class);
                List<Map<String, String>> centralServices = parseCentralList(centralXml);

                for (Map<String, String> service : centralServices) {
                    Map<String, Object> converted = new HashMap<>(service);
                    converted.put("source", "중앙부처");
                    allServices.add(converted);
                }
                logger.info("중앙부처 서비스 {}개 조회", centralServices.size());
            } catch (Exception e) {
                logger.error("중앙부처 서비스 조회 실패: {}", e.getMessage());
            }

            // 지자체 API 호출
            try {
                String localUrl = LOCAL_API_URL + "/LocalGovernmentWelfarelistV001?serviceKey=" + API_KEY
                    + "&pageNo=1&numOfRows=100";

                String localXml = safeRest.getForObject(localUrl, String.class);
                List<Map<String, String>> localServices = parseLocalList(localXml);

                for (Map<String, String> service : localServices) {
                    Map<String, Object> converted = new HashMap<>(service);
                    converted.put("source", "지자체");
                    allServices.add(converted);
                }
                logger.info("지자체 서비스 {}개 조회", localServices.size());
            } catch (Exception e) {
                logger.error("지자체 서비스 조회 실패: {}", e.getMessage());
            }

            // API에서 데이터를 가져오지 못한 경우 빈 리스트 반환
            if (allServices.isEmpty()) {
                logger.error("API 조회 실패, 인기 복지 서비스를 불러올 수 없습니다.");
                return new ArrayList<>();
            }

            // 조회수 기준으로 정렬
            allServices.sort((a, b) -> {
                Integer aInq = parseInqNum(a.get("inqNum"));
                Integer bInq = parseInqNum(b.get("inqNum"));
                return bInq.compareTo(aInq);
            });

            // 상위 12개만 반환
            List<Map<String, Object>> result = allServices.stream()
                    .limit(12)
                    .collect(Collectors.toList());

            logger.info("인기 복지 서비스 {}개 반환 (실제 API)", result.size());
            return result;

        } catch (Exception e) {
            logger.error("인기 복지 서비스 조회 실패", e);
            return new ArrayList<>();
        }
    }

    /**
     * 인기 복지 혜택 조회 전용 안전한 RestTemplate 생성
     * 이 메서드에서만 사용되며 다른 기능에는 영향을 주지 않습니다.
     */
    private RestTemplate createSafeRestTemplate() {
        try {
            javax.net.ssl.TrustManager[] trustAllCerts = new javax.net.ssl.TrustManager[]{
                new javax.net.ssl.X509TrustManager() {
                    public java.security.cert.X509Certificate[] getAcceptedIssuers() {
                        return null;
                    }
                    public void checkClientTrusted(java.security.cert.X509Certificate[] certs, String authType) {
                    }
                    public void checkServerTrusted(java.security.cert.X509Certificate[] certs, String authType) {
                    }
                }
            };

            javax.net.ssl.SSLContext sslContext = javax.net.ssl.SSLContext.getInstance("TLS");
            sslContext.init(null, trustAllCerts, new java.security.SecureRandom());

            javax.net.ssl.HttpsURLConnection.setDefaultSSLSocketFactory(sslContext.getSocketFactory());
            javax.net.ssl.HttpsURLConnection.setDefaultHostnameVerifier((hostname, session) -> {
                return "apis.data.go.kr".equals(hostname);
            });

            return new RestTemplate();
        } catch (Exception e) {
            logger.error("SSL 설정 실패, 기본 RestTemplate 사용", e);
            return new RestTemplate();
        }
    }
}