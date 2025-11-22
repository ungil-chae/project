package com.greenart.bdproject.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * 서버 상태 확인용 간단한 컨트롤러
 * 의존성 주입 없이 작동
 */
@RestController
@RequestMapping("/api/health")
public class HealthCheckController {

    @GetMapping
    public Map<String, Object> healthCheck() {
        Map<String, Object> response = new HashMap<>();
        response.put("status", "OK");
        response.put("message", "Server is running");
        response.put("timestamp", System.currentTimeMillis());
        return response;
    }

    @GetMapping("/ping")
    public String ping() {
        return "pong";
    }
}
