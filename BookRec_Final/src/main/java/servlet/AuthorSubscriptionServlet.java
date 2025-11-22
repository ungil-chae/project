package servlet;

import com.google.gson.Gson;
import com.google.gson.JsonObject;
import com.google.gson.JsonSyntaxException;
import dao.AuthorSubscriptionDao;
import dto.ApiResponse;
import dto.AuthorResponse; // <--- 이 부분이 dto.AuthorSubscriptionResponse 에서 dto.AuthorResponse 로 변경되었습니다.
import service.AuthorSubscriptionService;
import service.AuthorSubscriptionException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/api/users/me/subscriptions/*") // /api/users/me/subscriptions (GET), /api/users/me/subscriptions/{authorId} (POST, DELETE)
public class AuthorSubscriptionServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private AuthorSubscriptionService authorSubscriptionService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        this.authorSubscriptionService = new AuthorSubscriptionService(new AuthorSubscriptionDao());
        this.gson = new Gson();
    }

    // 구독 중인 작가 목록 조회 (GET /api/users/me/subscriptions)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            // ApiResponse 팩토리 메서드 사용
            out.print(gson.toJson(ApiResponse.error("UNAUTHORIZED", "로그인이 필요합니다.")));
            return;
        }

        int userId = (int) session.getAttribute("loggedInUser");

        try {
            // <--- List<AuthorSubscriptionResponse> 에서 List<AuthorResponse> 로 변경되었습니다.
            List<AuthorResponse> subscriptions = authorSubscriptionService.getMySubscriptions(userId);
            response.setStatus(HttpServletResponse.SC_OK);
            // ApiResponse 팩토리 메서드 사용
            out.print(gson.toJson(ApiResponse.success(subscriptions, "구독 목록 조회 성공")));

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // ApiResponse 팩토리 메서드 사용
            out.print(gson.toJson(ApiResponse.error("DB_ERROR", "데이터베이스 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")));
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // ApiResponse 팩토리 메서드 사용
            out.print(gson.toJson(ApiResponse.error("UNKNOWN_ERROR", "알 수 없는 오류가 발생했습니다.")));
            e.printStackTrace();
        }
    }

    // 작가 구독 (POST /api/users/me/subscriptions)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            // ApiResponse 팩토리 메서드 사용
            out.print(gson.toJson(ApiResponse.error("UNAUTHORIZED", "로그인이 필요합니다.")));
            return;
        }

        int userId = (int) session.getAttribute("loggedInUser");

        try {
            // 요청 바디에서 authorId 파싱
            JsonObject jsonRequest = gson.fromJson(request.getReader(), JsonObject.class);
            if (jsonRequest == null || !jsonRequest.has("authorId")) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                // ApiResponse 팩토리 메서드 사용
                out.print(gson.toJson(ApiResponse.error("INVALID_INPUT", "작가 ID가 필요합니다.")));
                return;
            }
            int authorId = jsonRequest.get("authorId").getAsInt();

            boolean success = authorSubscriptionService.subscribeAuthor(userId, authorId);

            if (success) {
                response.setStatus(HttpServletResponse.SC_CREATED); // 201 Created
                // ApiResponse 팩토리 메서드 사용
                out.print(gson.toJson(ApiResponse.success("작가 구독이 완료되었습니다."))); // 데이터 없이 메시지만
            } else {
                // 이 블록은 AuthorSubscriptionService에서 예외를 던지므로 사실상 실행되지 않음
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                // ApiResponse 팩토리 메서드 사용
                out.print(gson.toJson(ApiResponse.error("SUBSCRIPTION_FAILED", "작가 구독에 실패했습니다.")));
            }

        } catch (JsonSyntaxException | NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            // ApiResponse 팩토리 메서드 사용
            out.print(gson.toJson(ApiResponse.error("INVALID_JSON_OR_AUTHOR_ID", "요청 데이터의 JSON 형식이 올바르지 않거나 작가 ID가 유효하지 않습니다.")));
            e.printStackTrace();
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // ApiResponse 팩토리 메서드 사용
            out.print(gson.toJson(ApiResponse.error("DB_ERROR", "데이터베이스 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")));
            e.printStackTrace();
        } catch (AuthorSubscriptionException e) { // 비즈니스 로직 오류 (예: 이미 구독 중)
            response.setStatus(HttpServletResponse.SC_CONFLICT); // 409 Conflict (리소스 충돌)
            // ApiResponse 팩토리 메서드 사용
            out.print(gson.toJson(ApiResponse.error(e.getCode(), e.getMessage())));
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // ApiResponse 팩토리 메서드 사용
            out.print(gson.toJson(ApiResponse.error("UNKNOWN_ERROR", "알 수 없는 오류가 발생했습니다.")));
            e.printStackTrace();
        }
    }

    // 작가 구독 취소 (DELETE /api/users/me/subscriptions/{authorId})
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            // ApiResponse 팩토리 메서드 사용
            out.print(gson.toJson(ApiResponse.error("UNAUTHORIZED", "로그인이 필요합니다.")));
            return;
        }

        int userId = (int) session.getAttribute("loggedInUser");

        // URL 경로에서 authorId 추출 (예: /api/users/me/subscriptions/456)
        String pathInfo = request.getPathInfo();
        int authorId;
        try {
            if (pathInfo == null || pathInfo.length() < 2) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                // ApiResponse 팩토리 메서드 사용
                out.print(gson.toJson(ApiResponse.error("INVALID_PATH", "취소할 작가 ID가 URL 경로에 포함되어야 합니다.")));
                return;
            }
            authorId = Integer.parseInt(pathInfo.substring(1)); // "/456" -> "456"
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            // ApiResponse 팩토리 메서드 사용
            out.print(gson.toJson(ApiResponse.error("INVALID_AUTHOR_ID", "유효하지 않은 작가 ID 형식입니다.")));
            return;
        }

        try {
            boolean success = authorSubscriptionService.unsubscribeAuthor(userId, authorId);

            if (success) {
                response.setStatus(HttpServletResponse.SC_NO_CONTENT); // 204 No Content (삭제 성공 시 본문 없음)
            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                // ApiResponse 팩토리 메서드 사용
                out.print(gson.toJson(ApiResponse.error("UNSUBSCRIPTION_FAILED", "작가 구독 취소에 실패했습니다.")));
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // ApiResponse 팩토리 메서드 사용
            out.print(gson.toJson(ApiResponse.error("DB_ERROR", "데이터베이스 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")));
            e.printStackTrace();
        } catch (AuthorSubscriptionException e) { // 비즈니스 로직 오류 (예: 구독 중이지 않음)
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            // ApiResponse 팩토리 메서드 사용
            out.print(gson.toJson(ApiResponse.error(e.getCode(), e.getMessage())));
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            // ApiResponse 팩토리 메서드 사용
            out.print(gson.toJson(ApiResponse.error("UNKNOWN_ERROR", "알 수 없는 오류가 발생했습니다.")));
            e.printStackTrace();
        }
    }
}