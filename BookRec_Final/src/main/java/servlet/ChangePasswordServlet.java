package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson; // Gson 라이브러리 사용을 가정 (pom.xml에 추가 필요)
import model.User; // User 모델 클래스 임포트
import service.UserService; // UserService 클래스 임포트
import dao.UserDao; // UserDao 클래스 임포트
import security.BCryptPasswordEncoder; // 비밀번호 해싱을 위한 PasswordEncoder 구현체 임포트
import security.PasswordEncoder; // PasswordEncoder 인터페이스 임포트
import service.UserProfileException; // 사용자 프로필 관련 예외 클래스 임포트

@WebServlet("/changePassword") // 이 어노테이션을 통해 "/changePassword" URL로 요청이 들어오면 이 서블릿이 처리됩니다.
public class ChangePasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L; // 서블릿 직렬화를 위한 ID

    private UserService userService; // UserService 인스턴스
    private Gson gson; // JSON 처리를 위한 Gson 인스턴스

    // 서블릿 초기화 메서드
    public void init() throws ServletException {
        // 실제 프로젝트에서는 의존성 주입(DI) 프레임워크를 사용하여 의존성을 관리하는 것이 좋습니다.
        // 여기서는 간단하게 직접 인스턴스를 생성합니다.
        UserDao userDao = new UserDao();
        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(); // BCrypt를 사용한 비밀번호 인코더
        this.userService = new UserService(userDao, passwordEncoder);
        this.gson = new Gson(); // Gson 객체 생성
    }

    // POST 요청을 처리하는 메서드
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // 응답의 Content-Type을 JSON으로 설정하고 문자 인코딩을 UTF-8로 설정합니다.
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter(); // 응답을 클라이언트에게 보낼 PrintWriter 객체

        ApiResponse apiResponse = null; // 클라이언트에게 보낼 JSON 응답 객체
        int httpStatus = HttpServletResponse.SC_OK; // HTTP 응답 상태 코드 (기본값: 200 OK)

        try {
            // 요청 본문(JSON)을 읽어옵니다.
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            String requestBody = sb.toString();

            // Gson을 사용하여 요청 본문 JSON을 ChangePasswordRequestDTO 객체로 파싱합니다.
            ChangePasswordRequestDTO requestDto = gson.fromJson(requestBody, ChangePasswordRequestDTO.class);
            
            // 요청 DTO의 유효성 검사
            if (requestDto == null || requestDto.getUserId() == 0 || requestDto.getNewPassword() == null || requestDto.getNewPassword().isEmpty()) {
                httpStatus = HttpServletResponse.SC_BAD_REQUEST; // 400 Bad Request
                apiResponse = new ApiResponse(false, "잘못된 요청 형식입니다. 사용자 ID와 새 비밀번호를 확인해주세요.");
            } else {
                int userId = requestDto.getUserId();
                String newPassword = requestDto.getNewPassword();

                // 보안 강화: 현재 로그인된 사용자의 ID와 요청으로 들어온 ID가 일치하는지 확인합니다.
                HttpSession session = request.getSession(false); // 세션이 없으면 새로 생성하지 않음
                if (session == null || session.getAttribute("loggedInUser") == null) {
                    httpStatus = HttpServletResponse.SC_UNAUTHORIZED; // 401 Unauthorized
                    apiResponse = new ApiResponse(false, "로그인이 필요합니다.");
                } else {
                    User loggedInUser = (User) session.getAttribute("loggedInUser");
                    if (loggedInUser.getUserId() != userId) {
                        httpStatus = HttpServletResponse.SC_FORBIDDEN; // 403 Forbidden
                        apiResponse = new ApiResponse(false, "유효하지 않은 사용자 ID입니다.");
                    } else {
                        // UserService를 호출하여 비밀번호 변경 로직을 수행합니다.
                        boolean changeSuccess = userService.changePassword(userId, newPassword);

                        if (changeSuccess) {
                            apiResponse = new ApiResponse(true, "비밀번호가 성공적으로 변경되었습니다.");
                            httpStatus = HttpServletResponse.SC_OK; // 200 OK
                        } else {
                            // 비밀번호 변경이 실패한 경우 (예: DB 업데이트 실패)
                            apiResponse = new ApiResponse(false, "비밀번호 변경에 실패했습니다.");
                            httpStatus = HttpServletResponse.SC_INTERNAL_SERVER_ERROR; // 500 Internal Server Error
                        }
                    }
                }
            }

        } catch (UserProfileException e) { // UserService에서 정의한 사용자 프로필 관련 예외 처리
            httpStatus = HttpServletResponse.SC_BAD_REQUEST; // 400 Bad Request
            apiResponse = new ApiResponse(false, e.getMessage()); // 예외 메시지를 클라이언트에 전달
            System.err.println("UserProfileException during password change: " + e.getMessage()); // 서버 로그 출력
        } catch (SQLException e) { // 데이터베이스 관련 예외 처리
            httpStatus = HttpServletResponse.SC_INTERNAL_SERVER_ERROR; // 500 Internal Server Error
            apiResponse = new ApiResponse(false, "데이터베이스 오류가 발생했습니다.");
            e.printStackTrace(); // 스택 트레이스 출력 (실제 서비스에서는 로깅 시스템 사용 권장)
        } catch (com.google.gson.JsonSyntaxException e) { // JSON 파싱 중 발생하는 예외 처리
            httpStatus = HttpServletResponse.SC_BAD_REQUEST; // 400 Bad Request
            apiResponse = new ApiResponse(false, "요청 JSON 형식이 올바르지 않습니다.");
            System.err.println("JSON Syntax Error: " + e.getMessage());
        } catch (Exception e) { // 그 외 모든 예상치 못한 예외 처리
            httpStatus = HttpServletResponse.SC_INTERNAL_SERVER_ERROR; // 500 Internal Server Error
            apiResponse = new ApiResponse(false, "알 수 없는 서버 오류가 발생했습니다.");
            e.printStackTrace();
        } finally {
            // 설정된 HTTP 상태 코드를 응답에 적용합니다.
            response.setStatus(httpStatus);
            // 최종 JSON 응답을 클라이언트에게 보냅니다.
            out.print(gson.toJson(apiResponse));
            out.flush(); // 버퍼를 비워 응답을 즉시 전송합니다.
        }
    }

    // 클라이언트에게 보낼 JSON 응답의 구조를 정의하는 내부 클래스
    private static class ApiResponse {
        boolean success; // 요청 성공 여부
        String message; // 응답 메시지

        public ApiResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }

    // 클라이언트로부터 받는 비밀번호 변경 요청의 JSON 구조를 정의하는 내부 클래스 (DTO)
    private static class ChangePasswordRequestDTO {
        private int userId; // 사용자 ID
        private String newPassword; // 새 비밀번호

        // Getter 메서드
        public int getUserId() { return userId; }
        public String getNewPassword() { return newPassword; }
    }
}