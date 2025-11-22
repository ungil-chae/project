package servlet;

import model.User;
import service.ReviewService;
import dto.ReviewListDisplayDTO; // 새로 만든 DTO 임포트

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/reviewList")
public class ReviewListServlet extends HttpServlet {
    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            // ReviewService에서 ReviewListDisplayDTO 리스트를 가져옵니다.
            List<ReviewListDisplayDTO> reviewsForDisplay = reviewService.getAllReviewsForDisplay();
            request.setAttribute("reviews", reviewsForDisplay); // JSP에서 사용할 이름은 'reviews' 그대로 유지

            // User 로그인 상태는 이미 reviewList.jsp에서 세션에서 가져오도록 되어 있으므로 별도 로직 불필요

            request.getRequestDispatcher("/reviewList.jsp").forward(request, response);
        } catch (SQLException e) {
            System.err.println("Database error retrieving review list: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("리뷰 목록을 불러오는 중 데이터베이스 오류가 발생했습니다.", e);
        }
    }
}