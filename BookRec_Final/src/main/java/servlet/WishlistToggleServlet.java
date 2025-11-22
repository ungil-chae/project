package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import service.WishlistService;

/**
 *  /wishlist/toggle  POST
 *  로그인 사용자가 도서 북마크 아이콘을 누를 때 호출되는 Ajax 엔드포인트.
 *  성공 시 200 + {"liked":true | false}
 *  미로그인 → 401,  잘못된 입력 → 400,  서버 오류 → 500
 */
public class WishlistToggleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final WishlistService wishlistService = new WishlistService();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        resp.setContentType("application/json; charset=UTF-8");
        PrintWriter out = resp.getWriter();

        /* ── 1. 로그인 체크 ─────────────────────────────────────────────── */
        HttpSession session = req.getSession(false);
        User loginUser = (session == null) ? null : (User) session.getAttribute("loggedInUser");
        if (loginUser == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);    // 401
            out.write("{\"message\":\"login required\"}");
            return;
        }
        int userId = loginUser.getUserId();

        /* ── 2. 파라미터 검증 ───────────────────────────────────────────── */
        String bookIdParam = req.getParameter("bookId");
        if (bookIdParam == null || !bookIdParam.matches("\\d+")) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);     // 400
            out.write("{\"message\":\"invalid bookId\"}");
            return;
        }
        int bookId = Integer.parseInt(bookIdParam);

        /* ── 3. 토글 수행 & 결과 출력 ────────────────────────────────────── */
        try {
            boolean liked = wishlistService.toggleWishlist(userId, bookId);
            out.write("{\"liked\":" + liked + "}");
        } catch (SQLException e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);  // 500
            out.write("{\"message\":\"server error\"}");
        }
    }
}