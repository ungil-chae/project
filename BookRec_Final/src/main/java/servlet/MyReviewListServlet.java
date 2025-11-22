package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDateTime; // LocalDateTime 사용을 위해 임포트
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;

import dto.ReviewListDisplayDTO;
import model.User;
import service.ReviewService;
import util.LocalDateTimeAdapter; // <<-- 이 줄을 추가합니다!

@WebServlet("/api/myReviews") // AJAX 요청을 받을 URL
public class MyReviewListServlet extends HttpServlet {
    private final ReviewService reviewService = new ReviewService();
    private final Gson gson = new GsonBuilder()
            // util.LocalDateTimeAdapter 클래스를 사용하도록 등록합니다.
            .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
            .create();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        User loggedInUser = (User) request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized
            out.print("{\"error\": \"로그인이 필요합니다.\"}");
            return;
        }

        int userId = loggedInUser.getUserId(); // 로그인한 사용자의 ID

        try {
            List<ReviewListDisplayDTO> myReviews = reviewService.getMyReviewsForDisplay(userId);
            String jsonResponse = gson.toJson(myReviews); // 리뷰 목록을 JSON으로 변환
            out.print(jsonResponse);
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
            out.print("{\"error\": \"리뷰 목록을 불러오는 중 데이터베이스 오류가 발생했습니다.\"}");
            System.err.println("Database error loading my reviews: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 500 Internal Server Error
            out.print("{\"error\": \"리뷰 목록을 불러오는 중 알 수 없는 오류가 발생했습니다.\"}");
            out.print(gson.toJson(new ErrorResponse("리뷰 목록을 불러오는 중 알 수 없는 오류가 발생했습니다."))); // 에러 응답도 JSON으로
            System.err.println("Unexpected error loading my reviews: " + e.getMessage());
            e.printStackTrace();
        }
    }

    // 에러 응답을 JSON으로 일관되게 반환하기 위한 헬퍼 클래스 (필요시 util 패키지에 분리 가능)
    private static class ErrorResponse {
        String error;
        public ErrorResponse(String error) {
            this.error = error;
        }
    }
}