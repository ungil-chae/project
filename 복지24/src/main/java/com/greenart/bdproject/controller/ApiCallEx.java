package com.greenart.bdproject.controller;

/* Java 1.8 샘플 코드 */
import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLEncoder;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import java.io.BufferedReader;
import java.io.IOException;

@Controller
public class ApiCallEx {

	@Value("${api.government.key}")
	private String apiKey;

	@ResponseBody
	@GetMapping(value = "/test-api", produces = "application/xml; charset=UTF-8")
    public String main(String[] args) throws IOException {
        String encodedKey = URLEncoder.encode(apiKey, "UTF-8");
        StringBuilder urlBuilder = new StringBuilder("https://apis.data.go.kr/B554287/NationalWelfareInformationsV001/NationalWelfarelistV001?serviceKey=" + encodedKey + "&callTp=L&pageNo=1&numOfRows=10&srchKeyCode=003&orderBy=popular"); /*URL*/
        URL url = new URL(urlBuilder.toString());
        HttpURLConnection conn = (HttpURLConnection) url.openConnection();
        conn.setRequestMethod("GET");
        conn.setRequestProperty("Content-type", "application/xml; charset=UTF-8");
        System.out.println("Response code: " + conn.getResponseCode());
        BufferedReader rd;
        if(conn.getResponseCode() >= 200 && conn.getResponseCode() <= 300) {
        	rd = new BufferedReader(new InputStreamReader(conn.getInputStream(), "UTF-8"));
        } else {
        	rd = new BufferedReader(new InputStreamReader(conn.getErrorStream(), "UTF-8"));
        }
        StringBuilder sb = new StringBuilder();
        String line;
        while ((line = rd.readLine()) != null) {
            sb.append(line);
        }
        rd.close();
        conn.disconnect();
        System.out.println(sb.toString());
        return sb.toString();
    }
}