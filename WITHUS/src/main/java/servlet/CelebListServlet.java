package servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import model.User;
import service.WishlistService;

@WebServlet("/celebList")
public class CelebListServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final WishlistService wishlistService = new WishlistService();
    
    // JSP에 표시할 셀럽 데이터를 하드코딩 (DB에서 관리하는 것이 더 좋지만, 현재 구조 유지)
    private static final List<Map<String, Object>> celebInfoList = new ArrayList<>();
    static {
        addCeleb(1, "박찬욱", "\"깐느박\", \"미장센의 제왕\" 박찬욱 추천", "./img/celeb/parkchanwook_thum.jpg");
        addCeleb(2, "아이유", "아이유가 직접 읽고 팬들에게 추천한 책", "./img/celeb/iu_thum.jpg");
        addCeleb(3, "문상훈", "빠더너스 문상훈이 사랑한 시집들", "./img/celeb/munsanghoon_thum.jpg");
        addCeleb(4, "페이커", "페이커 대상혁이 추천하는 책", "./img/celeb/faker_thum.jpg");
        addCeleb(5, "박정민", "출판사 '무제'대표 박정민의 책장", "./img/celeb/parkjungmin_thum.jpg");
        addCeleb(6, "RM", "방탄소년단 RM이 추천하는 인생책", "./img/celeb/rm_thum.jpg");
        addCeleb(7, "한강", "노벨문학상 한강 작가의 책장", "./img/celeb/hankang_thum.jpg");
        addCeleb(8, "홍경", "배우 홍경이 추천하는 책", "./img/celeb/hongkyung_thum.jpg");
    }
    private static void addCeleb(int id, String name, String desc, String imgUrl) {
        Map<String, Object> celeb = new HashMap<>();
        celeb.put("id", id);
        celeb.put("name", name);
        celeb.put("desc", desc);
        celeb.put("imgUrl", imgUrl);
        celebInfoList.add(celeb);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User loginUser = (session != null) ? (User) session.getAttribute("loggedInUser") : null;
        List<Map<String, Object>> celebDataForJsp = new ArrayList<>();

        try {
            for (Map<String, Object> celebInfo : celebInfoList) {
                Map<String, Object> data = new HashMap<>(celebInfo);
                boolean isFullyBookmarked = false;
                
                if (loginUser != null) {
                    int userId = loginUser.getUserId();
                    String celebName = (String) celebInfo.get("name");
                    // 서비스에서 해당 셀럽 이름으로 모든 책이 찜되었는지 확인
                    isFullyBookmarked = wishlistService.areAllCelebBooksWishlisted(userId, celebName);
                }
                data.put("isFullyBookmarked", isFullyBookmarked);
                celebDataForJsp.add(data);
            }
        } catch (SQLException e) {
            log("셀럽 리스트 전체 찜 상태 조회 실패", e);
        }

        req.setAttribute("celebList", celebDataForJsp);
        req.getRequestDispatcher("/celebList.jsp").forward(req, resp);
    }
}