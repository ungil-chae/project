package com.greenart.bdproject.controller;

import java.math.BigDecimal;
import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.greenart.bdproject.service.KindnessTemperatureService;

/**
 * 선행온도 API 컨트롤러
 */
@RestController
@RequestMapping("/api/kindness")
public class KindnessTemperatureController {

    private static final Logger logger = LoggerFactory.getLogger(KindnessTemperatureController.class);

    @Autowired(required = false)
    private KindnessTemperatureService temperatureService;

    /**
     * 현재 선행온도 조회
     * GET /api/kindness/temperature
     */
    @GetMapping("/temperature")
    public Map<String, Object> getTemperature(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            // 로그인 체크
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                userId = (String) session.getAttribute("userId");
            }

            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            // temperatureService가 없으면 기본값 반환
            if (temperatureService == null) {
                response.put("success", true);
                response.put("temperature", new BigDecimal("36.50"));
                response.put("temperatureStr", "36.5°C");
                response.put("level", "level-cool");
                response.put("message", "선행온도 시스템이 초기화 중입니다.");
                logger.warn("KindnessTemperatureService가 null입니다.");
                return response;
            }

            BigDecimal temperature = temperatureService.getCurrentTemperature(userId);

            response.put("success", true);
            response.put("temperature", temperature);
            response.put("temperatureStr", temperature.toString() + "°C");

            // 온도 레벨 계산 (프론트엔드 표시용)
            String level = getTemperatureLevel(temperature);
            response.put("level", level);
            response.put("message", getTemperatureMessage(temperature));

            logger.info("선행온도 조회 성공 - userId: {}, temperature: {}°C", userId, temperature);

        } catch (Exception e) {
            logger.error("선행온도 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "온도 조회 중 오류가 발생했습니다.");
        }

        return response;
    }

    /**
     * 온도 레벨 계산
     */
    private String getTemperatureLevel(BigDecimal temperature) {
        if (temperature.compareTo(new BigDecimal("40")) >= 0) {
            return "level-fire";  // 40도 이상
        } else if (temperature.compareTo(new BigDecimal("38.5")) >= 0) {
            return "level-hot";   // 38.5도 이상
        } else if (temperature.compareTo(new BigDecimal("37.5")) >= 0) {
            return "level-warm";  // 37.5도 이상
        } else if (temperature.compareTo(new BigDecimal("36.8")) >= 0) {
            return "level-cool";  // 36.8도 이상
        } else {
            return "level-cold";  // 36.8도 미만
        }
    }

    /**
     * 온도에 따른 메시지
     */
    private String getTemperatureMessage(BigDecimal temperature) {
        if (temperature.compareTo(new BigDecimal("40")) >= 0) {
            return "🔥 천사의 마음을 가지셨네요!";
        } else if (temperature.compareTo(new BigDecimal("38.5")) >= 0) {
            return "❤️ 따뜻한 나눔을 실천하고 계시네요!";
        } else if (temperature.compareTo(new BigDecimal("37.5")) >= 0) {
            return "😊 선행을 꾸준히 실천하고 계시네요!";
        } else if (temperature.compareTo(new BigDecimal("36.8")) >= 0) {
            return "🌱 선행의 첫 발을 내딛으셨네요!";
        } else {
            return "💙 작은 나눔부터 시작해보세요!";
        }
    }
}
