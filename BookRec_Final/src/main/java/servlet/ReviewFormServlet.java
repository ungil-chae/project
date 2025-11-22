package servlet;

import model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

/**
 * 리뷰 작성 페이지 접근 서블릿
 * 로그인한 사용자만 reviewForm.jsp로 접근할 수 있도록 처리합니다.
 */
@WebServlet("/review/new")
public class ReviewFormServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        User loggedInUser = null;
        if (session != null) {
            loggedInUser = (User) session.getAttribute("loggedInUser");
        }
        // 로그인 체크: 로그인이 안 되어 있으면 로그인 페이지로 리다이렉트
        if (loggedInUser == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        // 로그인된 경우 리뷰 작성 폼으로 포워드
        request.getRequestDispatcher("/reviewForm.jsp").forward(request, response);
    }
}
