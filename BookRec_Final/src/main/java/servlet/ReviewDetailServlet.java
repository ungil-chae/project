package servlet;

import dto.ReviewDetailDisplayDTO; // ReviewDetailDisplayDTO 임포트
import service.ReviewService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/reviewDetail")
public class ReviewDetailServlet extends HttpServlet {
    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam == null || idParam.isEmpty()) {
            // reviewId가 없는 경우 BAD_REQUEST 응답
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing review id");
            return;
        }

        int reviewId;
        try {
            reviewId = Integer.parseInt(idParam); // reviewId를 int로 파싱
        } catch (NumberFormatException e) {
            // reviewId가 유효한 숫자가 아닐 경우 BAD_REQUEST 응답
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid review id format");
            return;
        }

        try {
            // ReviewService를 통해 ReviewDetailDisplayDTO 객체와 ContentBlock 리스트를 함께 가져옵니다.
            ReviewDetailDisplayDTO reviewDetailDisplay = reviewService.getReviewDetailWithContentBlocks(reviewId);

            if (reviewDetailDisplay == null) {
                // 해당 ID의 리뷰를 찾을 수 없을 때 NOT_FOUND (404) 응답
                response.sendError(HttpServletResponse.SC_NOT_FOUND, "Review not found with ID: " + reviewId);
                return;
            }

            // JSP에서 사용할 'reviewDetail' 이름으로 request attribute에 설정
            request.setAttribute("reviewDetail", reviewDetailDisplay);

            // reviewDetail.jsp로 포워딩하여 상세 정보 표시
            request.getRequestDispatcher("/reviewDetail.jsp").forward(request, response);
        } catch (SQLException e) {
            // 데이터베이스 작업 중 오류 발생 시 ServletException throw
            System.err.println("Database error retrieving review detail: " + e.getMessage());
            e.printStackTrace(); // 콘솔에 스택 트레이스 출력
            throw new ServletException("리뷰 상세 정보를 불러오는 중 데이터베이스 오류가 발생했습니다.", e);
        } catch (Exception e) {
            // 그 외 알 수 없는 오류 발생 시
            System.err.println("Unexpected error retrieving review detail: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("리뷰 상세 정보를 불러오는 중 알 수 없는 오류가 발생했습니다.", e);
        }
    }
}