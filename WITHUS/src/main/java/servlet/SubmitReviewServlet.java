package servlet;

import model.ReviewBook;
import model.User;
import service.ReviewService;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Date; // java.sql.Date for pubdate if needed
import java.sql.SQLException;
import java.time.LocalDateTime;

@WebServlet("/submitReview")
public class SubmitReviewServlet extends HttpServlet {
    private final ReviewService reviewService = new ReviewService();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 인코딩 설정 (POST 요청은 필수)
        request.setCharacterEncoding("UTF-8");
        response.setCharacterEncoding("UTF-8");

        // 1. 로그인된 사용자 정보 확인
        User loggedInUser = (User) request.getSession().getAttribute("loggedInUser");
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp?message=리뷰를 작성하려면 로그인해주세요.");
            return;
        }
        int userId = loggedInUser.getUserId(); // User 모델의 userId가 String이라고 가정합니다.

        // 2. 폼에서 넘어온 책 정보 파라미터 받기
        String isbn = request.getParameter("isbn");
        String title = request.getParameter("title");
        String author = request.getParameter("author");
        String coverImageUrl = request.getParameter("coverImageUrl");
        String naverLink = request.getParameter("naverLink");
        // pubdate, publisher, description은 현재 reviewForm.jsp에서 받지 않으므로 null/빈 문자열로 초기화
        // ReviewBook 테이블 스키마에 따라 null 허용 여부 확인 필요
        String publisher = ""; // 현재 폼에서 받지 않음
        String description = ""; // 현재 폼에서 받지 않음
        Date pubdate = null; // 현재 폼에서 받지 않음, 필요시 파싱 로직 추가

        // 3. 폼에서 넘어온 리뷰 정보 파라미터 받기
        String reviewText = request.getParameter("reviewText");
        int rating = 0;
        try {
            rating = Integer.parseInt(request.getParameter("rating"));
        } catch (NumberFormatException e) {
            // 유효하지 않은 별점 값
            request.setAttribute("errorMessage", "별점 값이 올바르지 않습니다.");
            // 다시 reviewForm.jsp로 포워딩하거나 에러 페이지로 이동
            request.getRequestDispatcher("/reviewForm.jsp").forward(request, response);
            return;
        }

        // 유효성 검사 (간단하게)
        if (isbn == null || isbn.isEmpty() || title == null || title.isEmpty() ||
            author == null || author.isEmpty() || reviewText == null || reviewText.trim().isEmpty() ||
            rating < 1 || rating > 5) {
            request.setAttribute("errorMessage", "모든 필수 정보를 입력하고 별점을 선택해주세요.");
            // 현재 폼 정보를 다시 reviewForm.jsp로 전달하여 사용자가 재입력하도록 함
            // (이 부분은 reviewForm.jsp가 다시 파라미터를 받을 수 있도록 JSP 수정도 필요)
            response.sendRedirect(request.getContextPath() + "/reviewForm.jsp?isbn=" + isbn + "&title=" + title + "&author=" + author + "&coverImageUrl=" + coverImageUrl + "&naverLink=" + naverLink + "&rating=" + rating + "&reviewText=" + reviewText + "&errorMessage=모든 필수 정보를 입력하고 별점을 선택해주세요.");
            return;
        }

        try {
            // ReviewBook 객체 생성 (DAO/Service에 전달할 데이터)
            ReviewBook reviewBookData = new ReviewBook();
            reviewBookData.setIsbn(isbn);
            reviewBookData.setTitle(title);
            reviewBookData.setAuthor(author);
            reviewBookData.setCoverImageUrl(coverImageUrl);
            reviewBookData.setNaverLink(naverLink);
            reviewBookData.setPublisher(publisher); // 빈 문자열 또는 null
            reviewBookData.setDescription(description); // 빈 문자열 또는 null
            reviewBookData.setPubdate(pubdate); // null

            // 서비스 계층 호출하여 리뷰 저장
            int reviewId = reviewService.submitReview(userId, reviewBookData, reviewText, rating);

            if (reviewId > 0) {
                // 리뷰 저장 성공 -> 리뷰 상세 페이지 또는 리뷰 목록 페이지로 리다이렉트
                response.sendRedirect(request.getContextPath() + "/reviewDetail?id=" + reviewId);
            } else {
                // 리뷰 저장 실패 (DB 오류 등)
                request.setAttribute("errorMessage", "리뷰 저장에 실패했습니다. 다시 시도해주세요.");
                request.getRequestDispatcher("/reviewForm.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            System.err.println("Database error during review submission: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("리뷰 저장 중 데이터베이스 오류가 발생했습니다.", e);
        } catch (Exception e) {
            System.err.println("Error during review submission: " + e.getMessage());
            e.printStackTrace();
            throw new ServletException("리뷰 저장 중 알 수 없는 오류가 발생했습니다.", e);
        }
    }
}