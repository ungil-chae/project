// /servlet/LogoutServlet.java

package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet; // WebServlet 임포트 확인
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.google.gson.Gson;
import dto.ApiResponse;

// [수정] 누락된 @WebServlet 어노테이션을 추가하여 URL을 지정합니다.
@WebServlet("/doLogout")
public class LogoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private final Gson gson = new Gson();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // 1. 현재 세션을 가져옵니다. (없으면 새로 만들지 않음)
        HttpSession session = request.getSession(false); 

        // 2. 세션이 존재하면 세션을 무효화(로그아웃 처리)합니다.
        if (session != null) {
            session.invalidate();
        }

        // 3. 모든 처리가 끝난 후, 강제로 메인 페이지로 리다이렉트시킵니다.
        // JSON 응답 대신 페이지를 이동시켜버리는 가장 확실한 방법입니다.
        response.sendRedirect(request.getContextPath() + "/main.jsp");
    }
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}