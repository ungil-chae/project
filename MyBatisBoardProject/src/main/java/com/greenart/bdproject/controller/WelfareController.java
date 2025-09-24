package com.greenart.bdproject.controller;

import com.greenart.bdproject.service.WelfareService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/welfare")
public class WelfareController {

    private static final Logger logger = LoggerFactory.getLogger(WelfareController.class);

    @Autowired
    private WelfareService welfareService;

    private final ObjectMapper objectMapper = new ObjectMapper();

    /**
     * 복지 진단 고급 페이지로 이동
     */
    @GetMapping("/diagnosis-advanced")
    public String diagnosisAdvanced() {
        return "welfare/diagnosis-advanced";
    }

    /**
     * 사용자 정보를 받아 복지 서비스 매칭 결과 반환
     * JSP에서 AJAX로 호출하는 API 엔드포인트
     */
    @PostMapping(value = "/match", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public ResponseEntity<String> matchWelfare(@RequestParam Map<String, String> userData) {
        System.out.println("post 요청 시작" + userData);
        try {
            System.out.println("복지 매칭 요청 시작: {}" + userData);

            // 필수 데이터 검증
            if (userData == null || userData.isEmpty()) {
                logger.error("사용자 데이터가 없습니다");
                return ResponseEntity.badRequest().build();
            }

            // 필수 필드 확인
            String birthdate = userData.get("birthdate");
            if (birthdate == null || birthdate.trim().isEmpty()) {
                logger.error("생년월일이 없습니다");
                return ResponseEntity.badRequest().build();
            }

            // WelfareService를 통해 복지 서비스 매칭 실행
            List<Map<String, Object>> matchedServices = welfareService.matchWelfare(userData);

            System.out.println("복지 매칭 완료: " + matchedServices.size() + "개 서비스 매칭됨");

            // 첫 번째 결과 서비스 로그
            if (!matchedServices.isEmpty()) {
                System.out.println("첫 번째 결과 서비스: " + matchedServices.get(0));
            }

            // JSON 문자열로 변환
            String jsonResult = objectMapper.writeValueAsString(matchedServices);
            System.out.println("JSON 변환 완료, 길이: " + jsonResult.length());

            return ResponseEntity.ok()
                .header("Content-Type", "application/json; charset=UTF-8")
                .body(jsonResult);

        } catch (Exception e) {
            System.out.println("복지 매칭 중 오류 발생: " + e);
            e.printStackTrace();
            return ResponseEntity.status(500).build();
        }
    }

    /**
     * 복지 서비스 상세 조회 (미구현)
     * 더 보기 버튼 클릭 시 호출
     */
    @GetMapping("/detail/{servId}")
    @ResponseBody
    public ResponseEntity<Map<String, String>> getWelfareDetail(@PathVariable String servId) {
        try {
            logger.info("복지 서비스 상세 정보 요청: {}", servId);

            // 추후에는 WelfareService에 상세 조회 메서드를 추가해야 함
            // Map<String, String> detail = welfareService.getWelfareDetail(servId);

            // 임시로 기본 응답
            Map<String, String> detail = Map.of(
                "servId", servId,
                "message", "상세 조회 기능은 WelfareService에 구현 필요"
            );

            return ResponseEntity.ok(detail);

        } catch (Exception e) {
            logger.error("복지 서비스 상세 조회 중 오류 발생: ", e);
            return ResponseEntity.status(500).build();
        }
    }

    /**
     * 기본 복지 진단 페이지로 이동 (미구현)
     */
    @GetMapping("/diagnosis-basic")
    public String diagnosisBasic() {
        return "welfare/diagnosis-basic";
    }

    /**
     * 조회수 기준 10개 인기 서비스 조회
     * 홈페이지에서 인기 복지 서비스 표시용
     */
    @GetMapping(value = "/popular", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public ResponseEntity<String> getPopularWelfareServices() {
        try {
            System.out.println("=== 인기 복지 서비스 조회 요청 시작 ===");
            logger.info("인기 복지 서비스 조회 요청");

            // 우선 더미 데이터로 테스트
            String testData = "[" +
                "{\"servNm\":\"기초생활보장 생계급여\",\"jurMnofNm\":\"보건복지부\",\"jurOrgNm\":\"기초생활보장과\",\"inqNum\":\"15423\",\"source\":\"중앙부처\",\"servDtlLink\":\"https://www.gov.kr/portal/service/serviceInfo/179010100000001\"}," +
                "{\"servNm\":\"차상위기초생활보장 의료급여\",\"jurMnofNm\":\"보건복지부\",\"jurOrgNm\":\"의료급여과\",\"inqNum\":\"12876\",\"source\":\"중앙부처\",\"servDtlLink\":\"https://www.gov.kr/portal/service/serviceInfo/179010100000002\"}," +
                "{\"servNm\":\"아동수당\",\"jurMnofNm\":\"보건복지부\",\"jurOrgNm\":\"아동정책총괄과\",\"inqNum\":\"11234\",\"source\":\"중앙부처\",\"servDtlLink\":\"https://www.gov.kr/portal/service/serviceInfo/179010100000003\"}," +
                "{\"servNm\":\"기초연금\",\"jurMnofNm\":\"보건복지부\",\"jurOrgNm\":\"기초연금과\",\"inqNum\":\"10987\",\"source\":\"중앙부처\",\"servDtlLink\":\"https://www.gov.kr/portal/service/serviceInfo/179010100000004\"}," +
                "{\"servNm\":\"장애인연금\",\"jurMnofNm\":\"보건복지부\",\"jurOrgNm\":\"장애인정책과\",\"inqNum\":\"9876\",\"source\":\"중앙부처\",\"servDtlLink\":\"https://www.gov.kr/portal/service/serviceInfo/179010100000005\"}," +
                "{\"servNm\":\"청년도약계좌\",\"jurMnofNm\":\"기획재정부\",\"jurOrgNm\":\"정책총괄과\",\"inqNum\":\"8765\",\"source\":\"중앙부처\",\"servDtlLink\":\"https://www.gov.kr/portal/service/serviceInfo/179010100000006\"}," +
                "{\"servNm\":\"한부모가족 아동양육비\",\"jurMnofNm\":\"여성가족부\",\"jurOrgNm\":\"가족정책과\",\"inqNum\":\"7654\",\"source\":\"중앙부처\",\"servDtlLink\":\"https://www.gov.kr/portal/service/serviceInfo/179010100000007\"}," +
                "{\"servNm\":\"국가장학금\",\"jurMnofNm\":\"교육부\",\"jurOrgNm\":\"대학재정과\",\"inqNum\":\"6543\",\"source\":\"중앙부처\",\"servDtlLink\":\"https://www.gov.kr/portal/service/serviceInfo/179010100000008\"}," +
                "{\"servNm\":\"청년내일 채움 특례보금자리\",\"jurMnofNm\":\"국토교통부\",\"jurOrgNm\":\"주거복지정책과\",\"inqNum\":\"5432\",\"source\":\"중앙부처\",\"servDtlLink\":\"https://www.gov.kr/portal/service/serviceInfo/179010100000009\"}," +
                "{\"servNm\":\"바로채용\",\"jurMnofNm\":\"고용청\",\"jurOrgNm\":\"고용정책총괄정보과\",\"inqNum\":\"4321\",\"source\":\"중앙부처\",\"servDtlLink\":\"https://www.gov.kr/portal/service/serviceInfo/179010100000010\"}" +
                "]";

            System.out.println("더미 데이터 반환: " + testData.length() + "자 길이");

            return ResponseEntity.ok()
                .header("Content-Type", "application/json; charset=UTF-8")
                .body(testData);

        } catch (Exception e) {
            System.out.println("에러 발생: " + e.getMessage());
            logger.error("인기 복지 서비스 조회 중 오류 발생: ", e);
            e.printStackTrace();
            return ResponseEntity.status(500).body("{\"error\":\"인기 복지 서비스 조회 중 오류가 발생했습니다.\"}");
        }
    }

    /**
     * 전역 예외처리 복지 오류 핸들러
     */
    @ExceptionHandler(Exception.class)
    @ResponseBody
    public ResponseEntity<Map<String, String>> handleException(Exception e) {
        logger.error("컨트롤러에서 처리되지 않은 오류 발생: ", e);

        Map<String, String> error = Map.of(
            "error", "복지 서비스 처리 중 오류가 발생했습니다.",
            "message", e.getMessage() != null ? e.getMessage() : "알 수 없는 오류"
        );

        return ResponseEntity.status(500).body(error);
    }
}