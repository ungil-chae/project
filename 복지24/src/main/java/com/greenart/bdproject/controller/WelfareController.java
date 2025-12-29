package com.greenart.bdproject.controller;

import com.greenart.bdproject.service.WelfareService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;
import com.fasterxml.jackson.databind.ObjectMapper;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/welfare")
public class WelfareController {

    private static final Logger logger = LoggerFactory.getLogger(WelfareController.class);

    @Autowired
    private WelfareService welfareService;

    @Autowired
    private DataSource dataSource;

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
            if (birthdate == null || birthdate.trim().isEmpty() || "--".equals(birthdate) || birthdate.contains("--")) {
                logger.error("생년월일이 올바르지 않습니다: {}", birthdate);
                String errorJson = "{\"error\":\"생년월일을 정확히 선택해주세요.\"}";
                return ResponseEntity.status(400)
                    .header("Content-Type", "application/json; charset=UTF-8")
                    .body(errorJson);
            }

            // WelfareService를 통해 복지 서비스 매칭 실행
            List<Map<String, Object>> matchedServices = welfareService.matchWelfare(userData);

            System.out.println("복지 매칭 완료: " + matchedServices.size() + "개 서비스 매칭됨");

            // 첫 번째 결과 서비스 로그
            if (!matchedServices.isEmpty()) {
                System.out.println("첫 번째 결과 서비스: " + matchedServices.get(0));
            }

            // 복지 진단 이용 로그 기록 (조회수 카운트)
            saveDiagnosisLog();

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
     * 복지 진단 이용 로그 저장 (조회수 카운트)
     */
    private void saveDiagnosisLog() {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dataSource.getConnection();
            String sql = "INSERT INTO welfare_diagnosis_log () VALUES ()";
            pstmt = con.prepareStatement(sql);
            pstmt.executeUpdate();
            logger.info("복지 진단 로그 저장 완료");

        } catch (Exception e) {
            logger.error("복지 진단 로그 저장 중 오류 발생", e);
        } finally {
            try {
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (Exception e) {
                logger.error("자원 해제 중 오류", e);
            }
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
     * 복지로 API에서 실시간으로 인기 복지 서비스 조회
     * 조회수 기준 상위 10개 반환
     */
    @GetMapping(value = "/popular", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public ResponseEntity<String> getPopularWelfareServices() {
        try {
            logger.info("인기 복지 서비스 조회 요청 (실시간 복지로 API)");

            // WelfareService를 통해 실시간으로 인기 서비스 조회
            List<Map<String, Object>> popularServices = welfareService.getPopularWelfareServices();

            logger.info("인기 복지 서비스 조회 완료: {}개", popularServices.size());

            // JSON 문자열로 변환
            String jsonResult = objectMapper.writeValueAsString(popularServices);

            return ResponseEntity.ok()
                .header("Content-Type", "application/json; charset=UTF-8")
                .body(jsonResult);

        } catch (Exception e) {
            logger.error("인기 복지 서비스 조회 중 오류 발생: ", e);
            return ResponseEntity.status(500)
                .body("{\"error\":\"인기 복지 서비스 조회 중 오류가 발생했습니다.\"}");
        }
    }

    /**
     * API 성능 벤치마크 테스트 엔드포인트
     * 순차 호출 vs 병렬 호출 성능 비교
     *
     * 사용법: GET /welfare/benchmark?sido=서울특별시&birthdate=1990-01-01&gender=male
     */
    @GetMapping(value = "/benchmark", produces = "application/json; charset=UTF-8")
    @ResponseBody
    public ResponseEntity<String> benchmarkApi(@RequestParam Map<String, String> userData) {
        try {
            System.out.println("========== 벤치마크 테스트 시작 ==========");

            // 기본값 설정 (테스트용)
            if (!userData.containsKey("birthdate")) {
                userData.put("birthdate", "1990-01-01");
            }
            if (!userData.containsKey("gender")) {
                userData.put("gender", "male");
            }
            if (!userData.containsKey("sido")) {
                userData.put("sido", "서울특별시");
            }

            Map<String, Object> benchmarkResult = welfareService.benchmarkApiCalls(userData);

            String jsonResult = objectMapper.writeValueAsString(benchmarkResult);
            return ResponseEntity.ok()
                .header("Content-Type", "application/json; charset=UTF-8")
                .body(jsonResult);

        } catch (Exception e) {
            logger.error("벤치마크 테스트 오류: ", e);
            return ResponseEntity.status(500).body("{\"error\": \"" + e.getMessage() + "\"}");
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