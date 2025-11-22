package servlet;

import model.User;
import service.ReviewService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/deleteReview")
public class DeleteReviewServlet extends HttpServlet {
    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String reviewIdParam = request.getParameter("id");
        if (reviewIdParam == null || reviewIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/reviewList?message=" + java.net.URLEncoder.encode("삭제할 리뷰 ID가 필요합니다.", "UTF-8"));
            return;
        }

        int reviewId;
        try {
            reviewId = Integer.parseInt(reviewIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/reviewList?message=" + java.net.URLEncoder.encode("유효하지 않은 리뷰 ID 형식입니다.", "UTF-8"));
            return;
        }

        User loggedInUser = (User) request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null) {
            // 로그인되어 있지 않으면 로그인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/login.jsp?message=" + java.net.URLEncoder.encode("리뷰를 삭제하려면 로그인해주세요.", "UTF-8"));
            return;
        }
        int callingUserId = loggedInUser.getUserId(); // 삭제를 요청한 사용자 ID

        try {
            boolean success = reviewService.deleteReview(reviewId, callingUserId);

            if (success) {
                // 삭제 성공 시 리뷰 목록으로 리다이렉트
                response.sendRedirect(request.getContextPath() + "/reviewList?message=" + java.net.URLEncoder.encode("리뷰가 성공적으로 삭제되었습니다.", "UTF-8"));
            } else {
                // 삭제 실패 (권한 없음 또는 DB 오류)
                // ReviewService.deleteReview에서 권한 없음도 false로 반환하므로 메시지를 구체화할 필요가 있습니다.
                // 일단은 일반적인 실패 메시지
                response.sendRedirect(request.getContextPath() + "/reviewList?message=" + java.net.URLEncoder.encode("리뷰 삭제에 실패했거나 삭제 권한이 없습니다.", "UTF-8"));
            }
        } catch (SQLException e) {
            System.err.println("Database error during review deletion: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("리뷰 삭제 중 데이터베이스 오류가 발생했습니다.", e);
        } catch (Exception e) {
            System.err.println("Unexpected error during review deletion: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("리뷰 삭제 중 알 수 없는 오류가 발생했습니다.", e);
        }
    }

    // POST 요청도 처리하려면 doPost 메서드를 추가할 수 있습니다.
    // 하지만 JSP에서 <a href>로 GET 요청을 보내므로 doGet만 있어도 됩니다.
}