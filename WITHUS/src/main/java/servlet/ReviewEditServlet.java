package servlet;

import model.User;
import service.ReviewService;
import dto.ReviewDetailDisplayDTO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.net.URLEncoder;
import java.sql.SQLException;

@WebServlet("/editReview")
public class ReviewEditServlet extends HttpServlet {
    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String reviewIdParam = request.getParameter("id");
        if (reviewIdParam == null || reviewIdParam.isEmpty()) {
            response.sendRedirect(request.getContextPath() + "/reviewList?message=" + URLEncoder.encode("수정할 리뷰 ID가 필요합니다.", "UTF-8"));
            return;
        }

        int reviewId;
        try {
            reviewId = Integer.parseInt(reviewIdParam);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/reviewList?message=" + URLEncoder.encode("유효하지 않은 리뷰 ID 형식입니다.", "UTF-8"));
            return;
        }

        User loggedInUser = (User) request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null) {
            // 로그인되어 있지 않으면 로그인 페이지로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/login.jsp?message=" + URLEncoder.encode("리뷰를 수정하려면 로그인해주세요.", "UTF-8") + "&redirectUrl=" + URLEncoder.encode(request.getRequestURI() + "?" + request.getQueryString(), "UTF-8"));
            return;
        }
        int callingUserId = loggedInUser.getUserId();

        try {
            // 기존 리뷰 상세 정보를 가져옵니다 (책 정보와 ContentBlock 포함)
            ReviewDetailDisplayDTO reviewDetailToEdit = reviewService.getReviewDetailWithContentBlocks(reviewId);

            if (reviewDetailToEdit == null) {
                response.sendRedirect(request.getContextPath() + "/reviewList?message=" + URLEncoder.encode("수정할 리뷰를 찾을 수 없습니다.", "UTF-8"));
                return;
            }

            // 권한 확인: 리뷰 작성자와 요청자가 동일한지 확인
            if (reviewDetailToEdit.getUserId() != callingUserId) {
                response.sendRedirect(request.getContextPath() + "/reviewList?message=" + URLEncoder.encode("이 리뷰를 수정할 권한이 없습니다.", "UTF-8"));
                return;
            }

            // reviewForm.jsp에 기존 데이터를 전달하기 위해 request attribute에 설정
            request.setAttribute("reviewDetailToEdit", reviewDetailToEdit);

            // reviewForm.jsp로 포워딩하여 폼을 채웁니다.
            request.getRequestDispatcher("/reviewForm.jsp").forward(request, response);

        } catch (SQLException e) {
            System.err.println("Database error loading review for edit: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("리뷰 수정 폼을 불러오는 중 데이터베이스 오류가 발생했습니다.", e);
        } catch (Exception e) {
            System.err.println("Unexpected error loading review for edit: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("리뷰 수정 폼을 불러오는 중 알 수 없는 오류가 발생했습니다.", e);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        User loggedInUser = (User) request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?message=" + URLEncoder.encode("리뷰를 수정하려면 로그인해주세요.", "UTF-8"));
            return;
        }
        int callingUserId = loggedInUser.getUserId();

        // 폼에서 제출된 데이터 받기
        String reviewIdParam = request.getParameter("reviewId"); // 숨겨진 필드에서 reviewId를 가져옴
        String updatedReviewText = request.getParameter("reviewText");
        String updatedRatingStr = request.getParameter("rating");

        int reviewId;
        int updatedRating;

        try {
            reviewId = Integer.parseInt(reviewIdParam);
            updatedRating = Integer.parseInt(updatedRatingStr);
        } catch (NumberFormatException e) {
            response.sendRedirect(request.getContextPath() + "/reviewList?message=" + URLEncoder.encode("유효하지 않은 리뷰 ID 또는 별점 형식입니다.", "UTF-8"));
            return;
        }

        // 유효성 검사
        if (updatedReviewText == null || updatedReviewText.trim().isEmpty() || updatedRating < 1 || updatedRating > 5) {
            // 유효성 검사 실패 시, reviewForm.jsp로 다시 포워딩 (기존 데이터 유지)
            // 이때는 request attribute에 메시지와 기존 값을 넣어줘야 합니다.
            request.setAttribute("errorMessage", "모든 필수 정보를 입력하고 별점을 선택해주세요.");
            request.setAttribute("reviewIdToEdit", reviewId); // 다시 폼으로 돌아갈 때 reviewId 유지
            request.setAttribute("existingReviewText", updatedReviewText); // 사용자가 입력한 내용 유지
            request.setAttribute("existingRating", updatedRating); // 사용자가 입력한 별점 유지

            // 책 정보도 다시 전달해야 합니다. ReviewDetailDisplayDTO를 다시 생성하거나 조회하여 전달
            try {
                ReviewDetailDisplayDTO currentReviewData = reviewService.getReviewDetailWithContentBlocks(reviewId);
                if (currentReviewData != null) {
                    request.setAttribute("reviewDetailToEdit", currentReviewData); // 책 정보 포함
                }
            } catch (SQLException ex) {
                System.err.println("Error re-loading review data for form: " + ex.getMessage());
            }

            request.getRequestDispatcher("/reviewForm.jsp").forward(request, response);
            return;
        }

        try {
            boolean success = reviewService.updateReview(reviewId, callingUserId, updatedReviewText, updatedRating);

            if (success) {
                // 수정 성공 시 리뷰 상세 페이지로 리다이렉트
                response.sendRedirect(request.getContextPath() + "/reviewDetail?id=" + reviewId + "&message=" + URLEncoder.encode("리뷰가 성공적으로 수정되었습니다.", "UTF-8"));
            } else {
                // 수정 실패 (권한 없음 등)
                request.setAttribute("errorMessage", "리뷰 수정에 실패했거나 수정 권한이 없습니다.");
                // 실패 시에도 기존 폼 데이터 유지
                request.setAttribute("reviewIdToEdit", reviewId);
                request.setAttribute("existingReviewText", updatedReviewText);
                request.setAttribute("existingRating", updatedRating);
                try {
                    ReviewDetailDisplayDTO currentReviewData = reviewService.getReviewDetailWithContentBlocks(reviewId);
                    if (currentReviewData != null) {
                        request.setAttribute("reviewDetailToEdit", currentReviewData);
                    }
                } catch (SQLException ex) {
                    System.err.println("Error re-loading review data for form after update fail: " + ex.getMessage());
                }
                request.getRequestDispatcher("/reviewForm.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            System.err.println("Database error during review update: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("리뷰 수정 중 데이터베이스 오류가 발생했습니다.", e);
        } catch (Exception e) {
            System.err.println("Unexpected error during review update: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("리뷰 수정 중 알 수 없는 오류가 발생했습니다.", e);
        }
    }
}