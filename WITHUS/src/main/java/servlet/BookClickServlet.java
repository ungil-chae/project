package servlet;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import dto.RecentBookDTO;

/**
 * 사용자가 책을 클릭했을 때 요청을 받아 세션에 "최근 본 책" 목록을 기록하는 서블릿.
 * 처리 후 원래 책 상세 페이지로 리다이렉트합니다.
 */
@WebServlet("/bookClick")
public class BookClickServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final int MAX_RECENT_BOOKS = 10; // 최근 본 책 목록의 최대 개수

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    private void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // 1. 요청 파라미터에서 책 정보 추출 (UTF-8 인코딩 설정)
        request.setCharacterEncoding("UTF-8");
        String id     = request.getParameter("id");
        String title  = request.getParameter("title");
        String author = request.getParameter("author");
        String image  = request.getParameter("image");
        String link   = request.getParameter("link");

        // 2. 필수 파라미터 검증
        if (id == null || id.isEmpty()
         || title == null || title.isEmpty()
         || image == null || image.isEmpty()
         || link == null || link.isEmpty()) {
            // 불완전할 경우 메인으로 리다이렉트
            response.sendRedirect(request.getContextPath() + "/main.jsp");
            return;
        }

        // 3. DTO 생성 (author는 옵션)
        RecentBookDTO newBook = new RecentBookDTO(
            id,
            title,
            (author != null ? author : ""),
            image,
            link
        );

        // 4. 세션에서 리스트 불러오기
        HttpSession session = request.getSession();
        @SuppressWarnings("unchecked")
        List<RecentBookDTO> recentBooks = (List<RecentBookDTO>) session.getAttribute("recentBooks");
        if (recentBooks == null) {
            recentBooks = new ArrayList<>();
        }

        // 5. 중복 제거 및 맨 앞에 삽입
        recentBooks.removeIf(b -> b.getId().equals(newBook.getId()));
        recentBooks.add(0, newBook);

        // 6. 최대 개수 제한
        while (recentBooks.size() > MAX_RECENT_BOOKS) {
            recentBooks.remove(recentBooks.size() - 1);
        }

        // 7. 세션에 저장
        session.setAttribute("recentBooks", recentBooks);

        // 8. 원래 외부 링크로 리다이렉트
        response.sendRedirect(link);
    }
}
