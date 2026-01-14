package servlet;

import java.io.IOException;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

import dto.MbtiRecommendationListResponse;
import model.User;
import service.RecommendationService;
import service.RecommendationService.RecommendationException;

/**
 * MBTI 기반 도서 추천 API 엔드포인트
 *
 * GET /api/recommendations/mbti
 * - 로그인 필요
 * - 같은 MBTI 사용자들이 찜한 책을 추천
 *
 * 쿼리 파라미터:
 * - limit (선택): 추천받을 책 개수 (기본값: 10, 최대: 50)
 */
@WebServlet("/api/recommendations/mbti")
public class MbtiRecommendationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int MAX_LIMIT = 50;

    private final RecommendationService recommendationService;
    private final Gson gson;

    public MbtiRecommendationServlet() {
        this.recommendationService = new RecommendationService();
        this.gson = new Gson();
    }

    /**
     * GET: MBTI 기반 추천 도서 목록을 반환합니다.
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        response.setContentType("application/json; charset=UTF-8");

        // 1. 로그인 확인
        HttpSession session = request.getSession(false);
        User loginUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (loginUser == null) {
            sendErrorResponse(response, HttpServletResponse.SC_UNAUTHORIZED,
                "LOGIN_REQUIRED", "로그인이 필요합니다.");
            return;
        }

        // 2. limit 파라미터 처리
        int limit = 10;
        String limitParam = request.getParameter("limit");
        if (limitParam != null && !limitParam.isEmpty()) {
            try {
                limit = Integer.parseInt(limitParam);
                if (limit < 1) limit = 10;
                if (limit > MAX_LIMIT) limit = MAX_LIMIT;
            } catch (NumberFormatException e) {
                // 잘못된 값이면 기본값 사용
            }
        }

        // 3. 추천 서비스 호출
        try {
            MbtiRecommendationListResponse result =
                recommendationService.getMbtiBasedRecommendations(loginUser.getUserId(), limit);

            String jsonResponse = gson.toJson(result);
            response.getWriter().print(jsonResponse);

        } catch (RecommendationException e) {
            // MBTI 미설정 등 비즈니스 예외
            int statusCode = "MBTI_NOT_SET".equals(e.getErrorCode())
                ? HttpServletResponse.SC_BAD_REQUEST
                : HttpServletResponse.SC_NOT_FOUND;

            sendErrorResponse(response, statusCode, e.getErrorCode(), e.getMessage());

        } catch (SQLException e) {
            e.printStackTrace();
            sendErrorResponse(response, HttpServletResponse.SC_INTERNAL_SERVER_ERROR,
                "DATABASE_ERROR", "데이터베이스 오류가 발생했습니다.");
        }
    }

    /**
     * JSON 형식의 에러 응답을 전송합니다.
     */
    private void sendErrorResponse(HttpServletResponse response, int statusCode,
                                   String errorCode, String message) throws IOException {
        response.setStatus(statusCode);
        String errorJson = String.format(
            "{\"error\":{\"code\":\"%s\",\"message\":\"%s\"}}",
            errorCode, message
        );
        response.getWriter().print(errorJson);
    }
}
