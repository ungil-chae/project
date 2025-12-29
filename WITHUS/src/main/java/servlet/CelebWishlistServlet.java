package servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import java.util.stream.Collectors;
import java.util.stream.Stream;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson; // Gson 임포트 추가
import model.User;
import service.WishlistService;

@WebServlet("/api/celebs/wishlists")
public class CelebWishlistServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private final WishlistService wishlistService = new WishlistService();
    private final Gson gson = new Gson(); // JSON 변환을 위한 Gson 객체

    private static final Map<Integer, String> celebIdToCategoryMap = Stream.of(new Object[][] {
        { 1, "박찬욱" }, { 2, "아이유" }, { 3, "문상훈" }, { 4, "페이커" },
        { 5, "박정민" }, { 6, "RM" },    { 7, "한강" },  { 8, "홍경" }
    }).collect(Collectors.toMap(data -> (Integer) data[0], data -> (String) data[1]));

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handleRequest(req, resp, "add");
    }

    @Override
    protected void doDelete(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        handleRequest(req, resp, "remove");
    }

    private void handleRequest(HttpServletRequest req, HttpServletResponse resp, String action) throws IOException {
        resp.setContentType("application/json; charset=UTF-8");

        HttpSession session = req.getSession(false);
        User loginUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null;
        if (loginUser == null) {
            resp.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            resp.getWriter().write(gson.toJson(Map.of("message", "로그인이 필요합니다.")));
            return;
        }

        String celebIdParam = req.getParameter("celebId");
        if (celebIdParam == null || !celebIdParam.matches("\\d+")) {
            resp.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            resp.getWriter().write(gson.toJson(Map.of("message", "유효하지 않은 셀럽 ID입니다.")));
            return;
        }
        
        int celebId = Integer.parseInt(celebIdParam);
        String celebCategory = celebIdToCategoryMap.get(celebId);
        if (celebCategory == null) {
            resp.setStatus(HttpServletResponse.SC_NOT_FOUND);
            resp.getWriter().write(gson.toJson(Map.of("message", "해당 셀럽을 찾을 수 없습니다.")));
            return;
        }

        try {
            if ("add".equals(action)) {
                wishlistService.addAllCelebBooksToWishlist(loginUser.getUserId(), celebCategory);
            } else if ("remove".equals(action)) {
                wishlistService.removeAllCelebBooksFromWishlist(loginUser.getUserId(), celebCategory);
            }
            
            resp.setStatus(HttpServletResponse.SC_OK);
            resp.getWriter().write(gson.toJson(Map.of("message", "정상 처리되었습니다.", "action", action)));

        } catch (SQLException e) {
            e.printStackTrace(); // 서버 콘솔에 에러 로그 기록
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write(gson.toJson(Map.of("message", "데이터베이스 처리 중 오류가 발생했습니다.")));
        } catch (Exception e) {
            e.printStackTrace();
            resp.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            resp.getWriter().write(gson.toJson(Map.of("message", "알 수 없는 오류가 발생했습니다.")));
        }
    }
}