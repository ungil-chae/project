package servlet;

import java.io.IOException;
import java.sql.SQLException; // SQLException 임포트
import java.util.Arrays;
import java.util.Collections; // Collections 임포트
import java.util.List;
import java.util.Set;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import model.Book;
import model.User;
import service.BookService;
import service.WishlistService;

/**
 * /playart – ‘문화/예술’ 플레이리스트 페이지를 보여주는 역할만 담당합니다.
 */
@WebServlet("/playart")
public class PlayArtServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final BookService      bookService      = new BookService();
    private final WishlistService  wishlistService  = new WishlistService();

    // 페이지에 표시할 책 ID 목록
    private static final List<Integer> ART_BOOK_IDS = Arrays.asList(
        101, 102, 103, 104, 105, 106, 107, 108, 109, 110,
        111, 112, 113, 114, 115, 116, 117, 118, 119, 120, 121, 122 // 누락된 ID 추가
    );

    /* ------------------------------------------------------------------ */
    /* GET  : JSP로 책 목록 + 찜 현황 전달
    /* ------------------------------------------------------------------ */
    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp) throws ServletException, IOException {

        // 1. JSP에 표시할 책 정보들을 가져옵니다.
        List<Book> books = bookService.getBooksByIds(ART_BOOK_IDS);
        req.setAttribute("books", books);

        // 2. 로그인한 사용자의 찜 상태를 확인합니다.
        User loginUser = (User) req.getSession().getAttribute("loggedInUser");
        Set<Integer> wishedIds = Collections.emptySet(); // 기본값으로 빈 Set을 준비합니다.

        if (loginUser != null) {
            try {
                // [수정] SQLException 예외 처리를 위해 try-catch 블록을 추가합니다.
                wishedIds = wishlistService.getWishlistBookIds(loginUser.getUserId());
            } catch (SQLException e) {
                System.err.println("찜 목록을 불러오는 중 DB 오류 발생");
                e.printStackTrace();
                // 필요 시, 에러 페이지로 전달할 수도 있습니다.
            }
        }
        req.setAttribute("wishedIds", wishedIds);

        // 3. JSP 페이지로 포워딩합니다.
        req.getRequestDispatcher("/playart.jsp").forward(req, resp);
    }

    /* ------------------------------------------------------------------ */
    /* [삭제] POST 메서드
    /* - 찜하기(토글) 기능은 WishlistServlet이 API(/api/users/me/wishlists)로
    /* 전담하므로, 이 서블릿에서는 해당 기능이 필요 없습니다.
    /* ------------------------------------------------------------------ */
    // @Override
    // protected void doPost(...) { ... }  <-- 이 부분을 삭제했습니다.
}
