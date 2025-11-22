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

import com.google.gson.Gson;
import com.google.gson.JsonObject; // JsonObject 임포트 추가
import com.google.gson.JsonParser; // JsonParser 임포트 추가 (Gson 버전에 따라 사용 방식 다를 수 있음)

import model.User;
import service.UserService;
import dao.UserDao;
import security.BCryptPasswordEncoder;
import security.PasswordEncoder;
import service.UserProfileException;

@WebServlet("/verifyPassword")
public class VerifyPasswordServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserService userService;
    private Gson gson;

    public void init() throws ServletException {
        UserDao userDao = new UserDao();
        PasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
        this.userService = new UserService(userDao, passwordEncoder);
        this.gson = new Gson();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        PrintWriter out = response.getWriter();
        String jsonResponse = "";
        
        // 1. 세션에서 현재 로그인된 사용자 정보 확인
        HttpSession session = request.getSession(false); // 세션이 없으면 새로 생성하지 않음
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized
            jsonResponse = gson.toJson(new ApiResponse(false, "로그인이 필요합니다."));
            out.print(jsonResponse);
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        int userIdFromSession = loggedInUser.getUserId(); // 세션에서 가져온 userId

        // 2. 요청 본문(JSON) 읽기 및 파싱
        String enteredPassword = null;
        try {
            // 요청의 InputStream으로부터 JSON 데이터를 읽어옵니다.
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            String jsonString = sb.toString();

            // Gson 2.8.x 이후 버전에서는 JsonParser.parseString() 사용
            // Gson 2.7 이하 버전에서는 new JsonParser().parse(jsonString) 사용
            JsonObject jsonObject = JsonParser.parseString(jsonString).getAsJsonObject();
            
            // "password" 키로 비밀번호 값을 가져옵니다.
            if (jsonObject.has("password")) {
                enteredPassword = jsonObject.get("password").getAsString();
            }

        } catch (com.google.gson.JsonSyntaxException e) {
            // JSON 파싱 오류
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse = gson.toJson(new ApiResponse(false, "요청 JSON 형식이 올바르지 않습니다."));
            out.print(jsonResponse);
            return;
        } catch (Exception e) {
            // 기타 요청 본문 읽기 오류
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse = gson.toJson(new ApiResponse(false, "잘못된 요청 형식입니다."));
            out.print(jsonResponse);
            return;
        }

        // 3. 입력된 비밀번호 유효성 검사 (비어있는지 확인)
        if (enteredPassword == null || enteredPassword.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 400 Bad Request
            jsonResponse = gson.toJson(new ApiResponse(false, "비밀번호를 입력해주세요."));
            out.print(jsonResponse);
            return;
        }

        try {
            // 4. UserService를 통해 비밀번호 검증 (세션에서 가져온 userId 사용)
            boolean isPasswordCorrect = userService.verifyPassword(userIdFromSession, enteredPassword);

            if (isPasswordCorrect) {
                jsonResponse = gson.toJson(new ApiResponse(true, "비밀번호가 확인되었습니다."));
                response.setStatus(HttpServletResponse.SC_OK); // 200 OK
            } else {
                jsonResponse = gson.toJson(new ApiResponse(false, "비밀번호가 올바르지 않습니다."));
                response.setStatus(HttpServletResponse.SC_OK); // 200 OK (비밀번호 불일치는 비즈니스 로직 상의 성공적인 처리)
            }
        } catch (UserProfileException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            jsonResponse = gson.toJson(new ApiResponse(false, e.getMessage()));
            System.err.println("UserProfileException during password verification: " + e.getMessage());
        } catch (SQLException e) { // DB 오류는 UserService에서 SQLException을 던질 수 있음
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse = gson.toJson(new ApiResponse(false, "데이터베이스 오류가 발생했습니다."));
            e.printStackTrace();
        } catch (Exception e) { // 예상치 못한 모든 예외
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            jsonResponse = gson.toJson(new ApiResponse(false, "알 수 없는 서버 오류가 발생했습니다."));
            e.printStackTrace();
        } finally {
            // 응답이 아직 커밋되지 않았다면 출력
            if (!response.isCommitted()) {
                out.print(jsonResponse);
            }
            out.flush();
        }
    }

    // JSON 응답을 위한 간단한 DTO 클래스
    private static class ApiResponse {
        boolean success;
        String message;

        public ApiResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }

    // ⭐ PasswordVerifyRequestDTO는 더 이상 필요하지 않습니다. (클라이언트에서 userId를 보내지 않으므로)
    //    이 클래스는 삭제하거나, 만약 다른 곳에서 userId와 password를 함께 받는 경우에만 유지하세요.
    // private static class PasswordVerifyRequestDTO {
    //     private int userId;
    //     private String password;
    //     public int getUserId() { return userId; }
    //     public String getPassword() { return password; }
    // }
}