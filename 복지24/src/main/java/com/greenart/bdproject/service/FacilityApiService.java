package com.greenart.bdproject.service;

import java.net.URI;
import java.nio.charset.StandardCharsets;
import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.json.JSONArray;
import org.json.JSONObject;
import org.json.XML;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.StringHttpMessageConverter;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.util.UriComponentsBuilder;

@Service
public class FacilityApiService {

    private final String SERVICE_KEY = "5Zmolv/d2cH1icO3c3x0NrGtNFn7unsoJ00Fllf8S6PKT6/zNvozPbIq1x8dyp1TasaRabGQSklygHZuVM79Bg==";

    public List<Map<String, Object>> matchWelfare(Map<String, String> params) {
        System.out.println("matchWelfare 서비스가 호출되었습니다.");
        return Collections.emptyList();
    }

    public String getFacilities(String fcltKindCd, String jrsdSggCd, String fcltNm, int pageNo, int numOfRows) {
        // UTF-8 인코딩을 지원하는 RestTemplate 설정
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters()
                .add(0, new StringHttpMessageConverter(StandardCharsets.UTF_8));
        
        String endpoint = "https://apis.data.go.kr/B554287/sclWlfrFcltInfoInqirService1/getFcltListInfoInqire";
        
        // HTTP 헤더에 UTF-8 인코딩 명시
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_XML);
        headers.add("Accept-Charset", "UTF-8");
        
        try {
            // [수정] URL 인코딩 방식을 더 안전한 방식으로 변경합니다.
            UriComponentsBuilder builder = UriComponentsBuilder.fromUriString(endpoint)
                    .queryParam("serviceKey", SERVICE_KEY) // 서비스 키를 변수로 처리
                    .queryParam("pageNo", pageNo)
                    .queryParam("numOfRows", numOfRows);

            if (fcltKindCd != null && !fcltKindCd.isEmpty()) builder.queryParam("fcltKindCd", fcltKindCd);
            if (jrsdSggCd != null && !jrsdSggCd.isEmpty()) builder.queryParam("jrsdSggCd", jrsdSggCd);
            if (fcltNm != null && !fcltNm.isEmpty()) builder.queryParam("fcltNm", fcltNm);
            
            // buildAndExpand를 통해 서비스 키의 특수문자를 안전하게 인코딩합니다.
            URI uri = builder.buildAndExpand(SERVICE_KEY).toUri();
            System.out.println(uri);
            
            HttpEntity<?> entity = new HttpEntity<>(headers);
            ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);
            String xmlResponse = response.getBody();
            
            System.out.println("응답 :"+ xmlResponse);
            JSONObject jsonResponse = XML.toJSONObject(xmlResponse);
            System.out.println(jsonResponse);
            normalizeItemsToArray(jsonResponse);
            
            return xmlResponse; // XML 대신 JSON으로 반환하는 것이 더 적절

        } catch (Exception e) {
            System.err.println("[오류] getFacilities 처리 중 예외 발생: " + e.getMessage());
            // [수정] 오류 발생 시 안전한 JSON 형식으로 메시지를 생성하여 반환합니다.
            JSONObject errorJson = new JSONObject();
            errorJson.put("error", "API 호출 중 서버 오류 발생: " + e.getMessage());
            return errorJson.toString();
        }
    }

    public String getFacilityTypes() {
        // UTF-8 인코딩을 지원하는 RestTemplate 설정
        RestTemplate restTemplate = new RestTemplate();
        restTemplate.getMessageConverters()
                .add(0, new StringHttpMessageConverter(StandardCharsets.UTF_8));
        
        String endpoint = "https://apis.data.go.kr/B554287/sclWlfrFcltInfoInqirService1/getFcltListInfoInqire";
        
        try {
            // HTTP 헤더에 UTF-8 인코딩 명시
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_XML);
            headers.add("Accept-Charset", "UTF-8");
            
            URI uri = UriComponentsBuilder.fromUriString(endpoint)
                    .queryParam("serviceKey", SERVICE_KEY)
                    .queryParam("pageNo", 1)
                    .queryParam("numOfRows", 200)
                    .buildAndExpand(SERVICE_KEY)
                    .toUri();
            
            HttpEntity<?> entity = new HttpEntity<>(headers);
            ResponseEntity<String> response = restTemplate.exchange(uri, HttpMethod.GET, entity, String.class);
            String xmlResponse = response.getBody();
            
            System.out.println("응답 :"+ xmlResponse);
            JSONObject jsonResponse = XML.toJSONObject(xmlResponse);
            System.out.println(jsonResponse);
            normalizeItemsToArray(jsonResponse);

            return xmlResponse;

        } catch (Exception e) {
            System.err.println("[오류] getFacilityTypes 처리 중 오류 발생: " + e.getMessage());
            JSONObject errorJson = new JSONObject();
            errorJson.put("error", "API 호출 중 오류 사항 발생: " + e.getMessage());
            return errorJson.toString();
        }
    }

    private void normalizeItemsToArray(JSONObject root) {
        try {
            // API 응답 데이터가 'response' -> 'body' -> 'items' -> 'item' 구조로 되어 있는지 확인
            if (root.has("response") && root.get("response") instanceof JSONObject) {
                JSONObject response = root.getJSONObject("response");
                if (response.has("body") && response.get("body") instanceof JSONObject) {
                    JSONObject body = response.getJSONObject("body");
                    if (body.has("items") && body.get("items") instanceof JSONObject) {
                        JSONObject items = body.getJSONObject("items");
                        // 'item'이 단일 객체(결과가 1개)일 경우, 배열로 감싸줌
                        if (items.has("item") && items.get("item") instanceof JSONObject) {
                            JSONArray itemArray = new JSONArray();
                            itemArray.put(items.getJSONObject("item"));
                            items.put("item", itemArray);
                        }
                    }
                }
            }
        } catch (Exception e) {
            // 데이터 구조가 예상과 다르거나 items가 없는 경우(결과 0개)는 정상적인 상황이므로 오류를 출력하지 않음
        }
    }
}

