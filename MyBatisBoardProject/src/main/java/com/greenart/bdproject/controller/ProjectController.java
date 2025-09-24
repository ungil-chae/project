package com.greenart.bdproject.controller;

import java.util.*;
import java.io.StringReader;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;

@Controller
public class ProjectController {
    
    // API 정보
    private static final String GOVT_SERVICE_KEY = "5Zmolv%2Fd2cH1icO3c3x0NrGtNFn7unsoJ00Fllf8S6PKT6%2FzNvozPbIq1x8dyp1TasaRabGQSklygHZuVM79Bg%3D%3D";
    private static final String LOCAL_SERVICE_KEY = "5Zmolv%2Fd2cH1icO3c3x0NrGtNFn7unsoJ00Fllf8S6PKT6%2FzNvozPbIq1x8dyp1TasaRabGQSklygHZuVM79Bg%3D%3D";
    
    private static final String GOVT_API_URL = "https://api.odcloud.kr/api/gov24/v1/serviceList";
    private static final String LOCAL_API_URL = "https://api.odcloud.kr/api/localGov/v1/serviceList";
    
    private final RestTemplate restTemplate = new RestTemplate();
    
    @PostMapping("/project_result")
    public String projectResult(@RequestParam Map<String, String> params, Model model) {
        
        try {
            // 1. 정부 복지 데이터 가져오기
            List<Map<String, String>> govtServices = getGovtWelfareServices();
            
            // 2. 지자체 복지 데이터 가져오기 
            List<Map<String, String>> localServices = getLocalWelfareServices();
            
            // 3. 두 데이터 합치기
            List<Map<String, String>> allServices = new ArrayList<>();
            allServices.addAll(govtServices);
            allServices.addAll(localServices);
            
            // 4. JSP로 데이터 전달
            model.addAttribute("userData", params);
            model.addAttribute("welfareServices", allServices);
            model.addAttribute("totalServices", allServices.size());
            
        } catch (Exception e) {
            e.printStackTrace();
            model.addAttribute("error", "복지 데이터를 불러오는 중 오류가 발생했습니다: " + e.getMessage());
            model.addAttribute("welfareServices", new ArrayList<>());
        }
        
        return "project_result";
    }
    
    @GetMapping("/project_result")
    public String projectResultGet(Model model) {
        // GET 요청시에도 빈 데이터로 페이지 표시
        model.addAttribute("welfareServices", new ArrayList<>());
        return "project_result";
    }
    
    // 정부 복지 서비스 API 호출
    private List<Map<String, String>> getGovtWelfareServices() {
        List<Map<String, String>> services = new ArrayList<>();
        
        try {
            int pageNo = 1;
            int totalCount = 0;
            
            do {
                // API 파라미터 설정
                MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
                params.add("serviceKey", GOVT_SERVICE_KEY);
                params.add("callTp", "L");
                params.add("pageNo", String.valueOf(pageNo));
                params.add("numOfRows", "100");
                
                // HTTP 헤더 설정
                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
                
                HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
                
                // API 호출
                ResponseEntity<String> response = restTemplate.exchange(
                    GOVT_API_URL, 
                    HttpMethod.POST, 
                    request, 
                    String.class
                );
                
                // XML 파싱
                List<Map<String, String>> pageServices = parseWelfareXML(response.getBody(), "정부");
                services.addAll(pageServices);
                
                // totalCount가 0이면 첫 페이지에서 설정
                if (totalCount == 0) {
                    totalCount = getTotalCountFromXML(response.getBody());
                }
                
                pageNo++;
                
            } while (services.size() < totalCount && pageNo <= 10); // 최대 10페이지
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return services;
    }
    
    // 지자체 복지 서비스 API 호출
    private List<Map<String, String>> getLocalWelfareServices() {
        List<Map<String, String>> services = new ArrayList<>();
        
        try {
            int pageNo = 1;
            int totalCount = 0;
            
            do {
                MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
                params.add("serviceKey", LOCAL_SERVICE_KEY);
                params.add("callTp", "L");
                params.add("pageNo", String.valueOf(pageNo));
                params.add("numOfRows", "100");
                
                HttpHeaders headers = new HttpHeaders();
                headers.setContentType(MediaType.APPLICATION_FORM_URLENCODED);
                
                HttpEntity<MultiValueMap<String, String>> request = new HttpEntity<>(params, headers);
                
                ResponseEntity<String> response = restTemplate.exchange(
                    LOCAL_API_URL, 
                    HttpMethod.POST, 
                    request, 
                    String.class
                );
                
                List<Map<String, String>> pageServices = parseWelfareXML(response.getBody(), "지자체");
                services.addAll(pageServices);
                
                if (totalCount == 0) {
                    totalCount = getTotalCountFromXML(response.getBody());
                }
                
                pageNo++;
                
            } while (services.size() < totalCount && pageNo <= 10);
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return services;
    }
    
    // XML 파싱해서 복지 서비스 리스트로 변환
    private List<Map<String, String>> parseWelfareXML(String xmlString, String type) {
        List<Map<String, String>> services = new ArrayList<>();
        
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.parse(new InputSource(new StringReader(xmlString)));
            
            NodeList servList = doc.getElementsByTagName("servList");
            
            for (int i = 0; i < servList.getLength(); i++) {
                Element servElement = (Element) servList.item(i);
                
                Map<String, String> service = new HashMap<>();
                service.put("type", type); // 정부/지자체 구분
                service.put("servId", getElementText(servElement, "servId"));
                service.put("servNm", getElementText(servElement, "servNm"));
                service.put("jurMnofNm", getElementText(servElement, "jurMnofNm"));
                service.put("jurOrgNm", getElementText(servElement, "jurOrgNm"));
                service.put("servDgst", getElementText(servElement, "servDgst"));
                service.put("lifeArray", getElementText(servElement, "lifeArray"));
                service.put("trgterIndvdlArray", getElementText(servElement, "trgterIndvdlArray"));
                service.put("srvPvsnNm", getElementText(servElement, "srvPvsnNm"));
                service.put("intrsThemaArray", getElementText(servElement, "intrsThemaArray"));
                
                services.add(service);
            }
            
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        return services;
    }
    
    // XML에서 totalCount 추출
    private int getTotalCountFromXML(String xmlString) {
        try {
            DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
            DocumentBuilder builder = factory.newDocumentBuilder();
            Document doc = builder.parse(new InputSource(new StringReader(xmlString)));
            
            String totalCountText = getElementText(doc.getDocumentElement(), "totalCount");
            return totalCountText != null ? Integer.parseInt(totalCountText) : 0;
            
        } catch (Exception e) {
            return 0;
        }
    }
    
    // XML 요소에서 텍스트 추출
    private String getElementText(Element parent, String tagName) {
        try {
            NodeList nodeList = parent.getElementsByTagName(tagName);
            if (nodeList.getLength() > 0) {
                return nodeList.item(0).getTextContent();
            }
        } catch (Exception e) {
            // 무시
        }
        return "";
    }
}