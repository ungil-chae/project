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

import com.google.gson.Gson; // JSON 처리 라이브러리 (pom.xml에 추가 필요)
import model.User; // User 모델
import service.UserService; // UserService
import dao.UserDao; // UserDao
import security.BCryptPasswordEncoder; // BCryptPasswordEncoder
import security.PasswordEncoder; // PasswordEncoder 인터페이스
import dto.UserProfileUpdateRequest; // 새로 생성/확인한 DTO 임포트
import service.UserProfileException; // 사용자 프로필 관련 예외

@WebServlet("/updateUserProfile") // 이 URL로 클라이언트의 AJAX 요청이 들어올 것입니다.
public class UpdateUserProfileServlet extends HttpServlet {
 private static final long serialVersionUID = 1L;

 private UserService userService; // UserService 인스턴스
 private Gson gson; // Gson 인스턴스

 // 서블릿 초기화 메서드
 public void init() throws ServletException {
     UserDao userDao = new UserDao();
     // 비밀번호 인코더는 이 서블릿에서 직접 사용하지 않지만, UserService가 필요하므로 전달합니다.
     PasswordEncoder passwordEncoder = new BCryptPasswordEncoder(); 
     this.userService = new UserService(userDao, passwordEncoder);
     this.gson = new Gson();
 }

 // POST 요청 처리
 protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
     response.setContentType("application/json"); // JSON 응답 명시
     response.setCharacterEncoding("UTF-8"); // UTF-8 인코딩
     PrintWriter out = response.getWriter();

     ApiResponse apiResponse = null; // 응답 데이터 객체
     int httpStatus = HttpServletResponse.SC_OK; // HTTP 상태 코드 (기본 200 OK)

     try {
         // 요청 본문(JSON) 읽기
         StringBuilder sb = new StringBuilder();
         String line;
         while ((line = request.getReader().readLine()) != null) {
             sb.append(line);
         }
         String requestBody = sb.toString();
         System.out.println("Received requestBody for updateUserProfile: " + requestBody); // 디버깅 로그

         // JSON을 UserProfileUpdateRequest DTO로 파싱
         UserProfileUpdateRequest requestDto = gson.fromJson(requestBody, UserProfileUpdateRequest.class);
         
         // DTO 유효성 검사 (필수 필드 확인 등)
         if (requestDto == null || requestDto.getNickname() == null || requestDto.getNickname().trim().isEmpty() ||
             requestDto.getEmail() == null || requestDto.getEmail().trim().isEmpty()) {
             httpStatus = HttpServletResponse.SC_BAD_REQUEST; // 400 Bad Request
             apiResponse = new ApiResponse(false, "닉네임과 이메일은 필수 입력값입니다.");
         } else {
             // 보안 강화: 세션에서 현재 로그인된 사용자 ID를 가져와 사용합니다.
             HttpSession session = request.getSession(false);
             if (session == null || session.getAttribute("loggedInUser") == null) {
                 httpStatus = HttpServletResponse.SC_UNAUTHORIZED; // 401 Unauthorized
                 apiResponse = new ApiResponse(false, "로그인이 필요합니다.");
             } else {
                 User loggedInUser = (User) session.getAttribute("loggedInUser");
                 int userId = loggedInUser.getUserId(); // 세션의 ID를 사용 (클라이언트에서 보낸 ID 사용X)

                 // UserService를 호출하여 프로필 정보 업데이트
                 boolean updateSuccess = userService.updateUserProfile(userId, requestDto);

                 if (updateSuccess) {
                     // 프로필 정보 변경 후 세션의 User 객체도 최신 정보로 업데이트합니다.
                     // DB에서 사용자 정보를 다시 불러와 세션에 덮어쓰는 것이 가장 확실합니다.
                     User updatedUser = userService.getUserProfile(userId); 
                     if (updatedUser != null) {
                         session.setAttribute("loggedInUser", updatedUser); // 세션 업데이트
                     }

                     apiResponse = new ApiResponse(true, "프로필 정보가 성공적으로 업데이트되었습니다.");
                     httpStatus = HttpServletResponse.SC_OK; // 200 OK
                 } else {
                     apiResponse = new ApiResponse(false, "프로필 정보 업데이트에 실패했습니다.");
                     httpStatus = HttpServletResponse.SC_INTERNAL_SERVER_ERROR; // 500 Internal Server Error
                 }
             }
         }

     } catch (UserProfileException e) { // UserService에서 발생할 수 있는 비즈니스 로직 예외
         httpStatus = HttpServletResponse.SC_BAD_REQUEST; // 400 Bad Request (예: 닉네임/이메일 중복)
         apiResponse = new ApiResponse(false, e.getMessage());
         System.err.println("UserProfileException during profile update: " + e.getMessage());
     } catch (SQLException e) { // DB 오류
         httpStatus = HttpServletResponse.SC_INTERNAL_SERVER_ERROR; // 500 Internal Server Error
         apiResponse = new ApiResponse(false, "데이터베이스 오류가 발생했습니다.");
         e.printStackTrace();
     } catch (com.google.gson.JsonSyntaxException e) { // JSON 파싱 오류
         httpStatus = HttpServletResponse.SC_BAD_REQUEST;
         apiResponse = new ApiResponse(false, "요청 JSON 형식이 올바르지 않습니다.");
         System.err.println("JSON Syntax Error: " + e.getMessage());
     } catch (Exception e) { // 기타 예상치 못한 오류
         httpStatus = HttpServletResponse.SC_INTERNAL_SERVER_ERROR;
         apiResponse = new ApiResponse(false, "알 수 없는 서버 오류가 발생했습니다.");
         e.printStackTrace();
     } finally {
         response.setStatus(httpStatus); // HTTP 상태 코드 설정
         out.print(gson.toJson(apiResponse)); // JSON 응답 전송
         out.flush();
     }
 }

 // 클라이언트에게 보낼 JSON 응답의 표준 구조
 private static class ApiResponse {
     boolean success;
     String message;

     public ApiResponse(boolean success, String message) {
         this.success = success;
         this.message = message;
     }
 }
}