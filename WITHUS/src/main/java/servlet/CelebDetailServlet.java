package servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Collections;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import service.WishlistService;

@WebServlet("/celebDetail")
public class CelebDetailServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final WishlistService wishlistService = new WishlistService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        // 1. 로그인 사용자 정보 확인
        HttpSession session = req.getSession(false);
        User loginUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        Set<Integer> wishedBookIds = Collections.emptySet(); // 기본값은 빈 Set

        if (loginUser != null) {
            try {
                // 2. 로그인했다면, 해당 사용자의 찜 목록 ID들을 가져옵니다.
                wishedBookIds = wishlistService.getWishlistBookIds(loginUser.getUserId());
            } catch (SQLException e) {
                e.printStackTrace();
                // DB 오류가 발생해도 페이지는 보여주되, 찜 표시는 안 됩니다.
            }
        }
        
        // 3. 찜 목록 ID Set을 request에 담아 JSP로 전달합니다.
        req.setAttribute("wishedBookIds", wishedBookIds);
        
        // 4. 파라미터로 받은 id에 맞는 JSP 페이지로 포워딩합니다.
        String celebId = req.getParameter("id");
        req.getRequestDispatcher("/celebDetail" + celebId + ".jsp").forward(req, resp);
    }
}