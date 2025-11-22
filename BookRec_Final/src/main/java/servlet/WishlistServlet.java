package servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.time.LocalDateTime; // LocalDateTime 임포트 추가
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder; // GsonBuilder 임포트 추가

import dto.WishlistItemResponse;
import model.User;
import service.WishlistService;
import util.LocalDateTimeAdapter; // 방금 만든 어댑터 임포트

@WebServlet("/api/users/me/wishlists")
public class WishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final WishlistService wishlistService = new WishlistService();
    
    // [수정] Gson 객체 생성 방식을 변경합니다.
    private final Gson gson;

    public WishlistServlet() {
        // GsonBuilder를 사용하여 LocalDateTime을 처리할 커스텀 어댑터를 등록합니다.
        gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class, new LocalDateTimeAdapter())
                .create();
    }
    
    // doGet, doPost 메서드는 이전과 동일하게 유지합니다...
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User loginUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (loginUser == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
            return;
        }

        try {
            List<WishlistItemResponse> wishlist = wishlistService.list(loginUser.getUserId());
            // 이제 이 gson 객체는 LocalDateTime을 올바르게 처리할 수 있습니다.
            String jsonResponse = gson.toJson(wishlist);

            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().print(jsonResponse);

        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "데이터베이스 오류가 발생했습니다.");
        }
    }
    
    // doPost 메서드...

    /**
     * POST: 특정 책을 찜 목록에 추가하거나 삭제합니다. (토글)
     */
    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User loginUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null;

        if (loginUser == null) {
            resp.sendError(HttpServletResponse.SC_UNAUTHORIZED, "로그인이 필요합니다.");
            return;
        }

        String bookIdParam = req.getParameter("bookId");
        if (bookIdParam == null || bookIdParam.isEmpty()) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "bookId가 필요합니다.");
            return;
        }

        try {
            int bookId = Integer.parseInt(bookIdParam);
            boolean isAdded = wishlistService.toggleWishlist(loginUser.getUserId(), bookId);
            
            // JSON 응답 생성
            String status = isAdded ? "added" : "removed";
            String jsonResponse = String.format("{\"status\":\"%s\"}", status);

            resp.setContentType("application/json; charset=UTF-8");
            resp.getWriter().print(jsonResponse);

        } catch (NumberFormatException e) {
            resp.sendError(HttpServletResponse.SC_BAD_REQUEST, "유효하지 않은 bookId입니다.");
        } catch (SQLException e) {
            e.printStackTrace();
            resp.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "데이터베이스 오류가 발생했습니다.");
        }
    }
}