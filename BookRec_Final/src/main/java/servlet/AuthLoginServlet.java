package servlet;

import dao.UserDao; // UserService에 주입되므로 직접 사용 안 함
import dto.ApiResponse;
import dto.LoginRequest;
import dto.LoginResponse;
import model.User;
import security.BCryptPasswordEncoder; // UserService에 주입되므로 직접 사용 안 함
import security.PasswordEncoder; // UserService에 주입되므로 직접 사용 안 함
import service.UserService; // UserService 임포트 추가
import service.UserLoginException; // UserService에서 정의한 로그인 관련 예외 임포트

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/api/auth/login")
public class AuthLoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // private UserDao userDao;           // UserService 사용으로 직접 사용 안 함
    // private PasswordEncoder passwordEncoder; // UserService 사용으로 직접 사용 안 함
    private UserService userService; // UserService 인스턴스

    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        // 서비스 계층을 초기화하고 필요한 의존성을 주입합니다.
        this.userService = new UserService(new UserDao(), new BCryptPasswordEncoder());
        this.gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8"); // charset=UTF-8 추가
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            LoginRequest loginRequest = gson.fromJson(request.getReader(), LoginRequest.class);

            // 입력값 유효성 검증 (여기서 간단하게, 상세 검증은 서비스에서)
            if (loginRequest == null || loginRequest.getUsername() == null || loginRequest.getUsername().trim().isEmpty() ||
                loginRequest.getPassword() == null || loginRequest.getPassword().trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(ApiResponse.error("INVALID_INPUT", "사용자 이름과 비밀번호를 입력해주세요.")));
                return;
            }

            // --- 서비스 계층으로 로그인 로직 위임 ---
            User user = userService.login(loginRequest); // UserService.login()은 User 객체를 반환합니다.
            // --- 위임 끝 ---

            // 로그인 성공 시 세션 처리
            HttpSession session = request.getSession();
            session.setAttribute("loggedInUser", user); // user.getUserId() 대신 User 객체 전체를 저장
            session.setMaxInactiveInterval(30 * 60); // 30분 동안 세션 유지

            // 클라이언트에게 보낼 응답 DTO 생성
            LoginResponse loginResponse = new LoginResponse(user.getUserId(), user.getUsername(), user.getNickname());
            response.setStatus(HttpServletResponse.SC_OK);
            out.print(gson.toJson(ApiResponse.success(loginResponse, "로그인 성공")));

        } catch (JsonSyntaxException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(ApiResponse.error("INVALID_JSON", "요청 데이터의 JSON 형식이 올바르지 않습니다.")));
            e.printStackTrace();
        } catch (SQLException e) { // DB 관련 예외
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("DB_ERROR", "데이터베이스 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")));
            e.printStackTrace();
        } catch (UserLoginException e) { // UserService에서 발생시킨 로그인 관련 비즈니스 예외
            // 로그인 실패 (자격 증명 불일치, 계정 비활성 등)
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized
            // 계정 상태에 따른 403 Forbidden도 고려할 수 있습니다.
            // if ("ACCOUNT_INACTIVE".equals(e.getCode())) {
            //     response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            // }
            out.print(gson.toJson(ApiResponse.error(e.getCode(), e.getMessage())));
            e.printStackTrace();
        } catch (Exception e) { // 그 외 예상치 못한 모든 예외
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("UNKNOWN_ERROR", "알 수 없는 오류가 발생했습니다.")));
            e.printStackTrace();
        }
    }
}