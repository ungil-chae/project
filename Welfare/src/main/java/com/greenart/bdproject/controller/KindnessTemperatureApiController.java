package com.greenart.bdproject.controller;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import com.greenart.bdproject.dao.MemberDao;

/**
 * 선행 온도 API 컨트롤러
 * URL 패턴: /api/kindness-temperature/*
 */
@RestController
@RequestMapping("/api/kindness-temperature")
public class KindnessTemperatureApiController {

    private static final Logger logger = LoggerFactory.getLogger(KindnessTemperatureApiController.class);

    @Autowired
    private MemberDao memberDao;

    /**
     * 현재 사용자의 선행 온도 조회
     * @GetMapping("/api/kindness-temperature")
     */
    @GetMapping("")
    public Map<String, Object> getTemperature(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");

            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            BigDecimal temperature = memberDao.getKindnessTemperature(userId);

            if (temperature == null) {
                temperature = new BigDecimal("36.50");
            }

            response.put("success", true);
            response.put("temperature", temperature);
            logger.info("선행 온도 조회 성공 - userId: {}, temperature: {}", userId, temperature);

        } catch (Exception e) {
            logger.error("선행 온도 조회 중 오류", e);
            response.put("success", false);
            response.put("message", "온도 조회 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 선행 온도 증가
     * @PostMapping("/api/kindness-temperature/increase")
     */
    @PostMapping("/increase")
    public Map<String, Object> increaseTemperature(
            @RequestParam("amount") BigDecimal amount,
            @RequestParam(value = "action", required = false) String action,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");

            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            // 온도 증가
            int result = memberDao.increaseKindnessTemperature(userId, amount);

            if (result > 0) {
                // 업데이트된 온도 조회
                BigDecimal newTemperature = memberDao.getKindnessTemperature(userId);

                response.put("success", true);
                response.put("temperature", newTemperature);
                response.put("increased", amount);
                response.put("message", "선행 온도가 " + amount + "도 올랐습니다!");

                logger.info("선행 온도 증가 - userId: {}, action: {}, amount: {}, newTemp: {}",
                           userId, action, amount, newTemperature);
            } else {
                response.put("success", false);
                response.put("message", "온도 업데이트에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("선행 온도 증가 중 오류", e);
            response.put("success", false);
            response.put("message", "온도 증가 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 선행 온도 업데이트 (절대값 설정)
     * @PostMapping("/api/kindness-temperature/update")
     */
    @PostMapping("/update")
    public Map<String, Object> updateTemperature(
            @RequestParam("temperature") BigDecimal temperature,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");

            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            // 온도 범위 체크 (0 ~ 100)
            if (temperature.compareTo(BigDecimal.ZERO) < 0 || temperature.compareTo(new BigDecimal("100")) > 0) {
                response.put("success", false);
                response.put("message", "온도는 0도에서 100도 사이여야 합니다.");
                return response;
            }

            int result = memberDao.updateKindnessTemperature(userId, temperature);

            if (result > 0) {
                response.put("success", true);
                response.put("temperature", temperature);
                response.put("message", "온도가 업데이트되었습니다.");
                logger.info("선행 온도 업데이트 - userId: {}, temperature: {}", userId, temperature);
            } else {
                response.put("success", false);
                response.put("message", "온도 업데이트에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("선행 온도 업데이트 중 오류", e);
            response.put("success", false);
            response.put("message", "온도 업데이트 중 오류가 발생했습니다.");
        }

        return response;
    }
}
