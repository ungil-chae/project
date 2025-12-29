package servlet;

import java.io.IOException;
import java.sql.SQLException;
import java.util.Arrays;
import java.util.Collections;
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
 * /playmystery – ‘미스테리/추리’ 플레이리스트 페이지를 보여주는 서블릿
 */
@WebServlet("/playmystery")
public class PlayMysteryServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private final BookService      bookService      = new BookService();
    private final WishlistService  wishlistService  = new WishlistService();

    // 페이지에 표시할 책 ID 목록 (미스테리/추리)
    private static final List<Integer> MYSTERY_BOOK_IDS = Arrays.asList(
        79, 80, 81, 82, 83, 84, 85, 86, 87, 88, 89, 90, 91,
        92, 93, 94, 95, 96, 97, 98, 99
    );

    @Override
    protected void doGet(HttpServletRequest req,
                         HttpServletResponse resp) throws ServletException, IOException {

        // 1. JSP에 표시할 책 정보들을 가져옵니다.
        List<Book> books = bookService.getBooksByIds(MYSTERY_BOOK_IDS);
        req.setAttribute("books", books);

        // 2. 로그인한 사용자의 찜 상태를 확인합니다.
        User loginUser = (User) req.getSession().getAttribute("loggedInUser");
        Set<Integer> wishedIds = Collections.emptySet();

        if (loginUser != null) {
            try {
                wishedIds = wishlistService.getWishlistBookIds(loginUser.getUserId());
            } catch (SQLException e) {
                System.err.println("찜 목록을 불러오는 중 DB 오류 발생");
                e.printStackTrace();
            }
        }
        req.setAttribute("wishedIds", wishedIds);

        // 3. JSP 페이지로 포워딩합니다.
        req.getRequestDispatcher("/playmystery.jsp").forward(req, resp);
    }
}