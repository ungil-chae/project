package servlet;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;
import com.google.gson.JsonObject; // JsonObject 임포트 추가
import com.google.gson.JsonParser; // JsonParser 임포트 추가

import dao.UserDao;
import model.User;
import util.PasswordUtil;

@WebServlet("/withdrawUser")
public class WithdrawUser extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDao userDao;

    public WithdrawUser() {
        super();
        userDao = new UserDao();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");
        Gson gson = new Gson();

        HttpSession session = request.getSession();
        User loggedInUser = (User) session.getAttribute("loggedInUser");

        // 1. 로그인 여부 및 사용자 ID 유효성 검사
        if (loggedInUser == null || loggedInUser.getUserId() == 0) {
            response.getWriter().write(gson.toJson(new ApiResponse(false, "로그인 정보가 유효하지 않습니다. 다시 로그인해주세요.")));
            return;
        }

        int userId = loggedInUser.getUserId();
        String enteredPassword = null;
        String withdrawReason = null; // 탈퇴 사유를 받을 변수 추가

        // ⭐⭐ JSON 요청 바디 파싱 ⭐⭐
        try {
            // 요청의 InputStream으로부터 JSON 데이터를 읽어옵니다.
            StringBuilder sb = new StringBuilder();
            String line;
            while ((line = request.getReader().readLine()) != null) {
                sb.append(line);
            }
            String jsonString = sb.toString();

            // 읽어온 JSON 문자열을 JsonObject로 파싱합니다.
            JsonObject jsonObject = JsonParser.parseString(jsonString).getAsJsonObject();
            
            // "password" 키로 비밀번호 값을 가져옵니다.
            if (jsonObject.has("password")) {
                enteredPassword = jsonObject.get("password").getAsString();
            }
            // "reason" 키로 탈퇴 사유 값을 가져옵니다. (선택 사항)
            if (jsonObject.has("reason")) {
                withdrawReason = jsonObject.get("reason").getAsString();
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write(gson.toJson(new ApiResponse(false, "요청 데이터 파싱 중 오류가 발생했습니다.")));
            return;
        }

        // 2. 입력된 비밀번호 유효성 검사 (비어있는지 확인)
        if (enteredPassword == null || enteredPassword.trim().isEmpty()) {
            response.getWriter().write(gson.toJson(new ApiResponse(false, "비밀번호를 입력해주세요.")));
            return;
        }

        try {
            // 3. DB에서 사용자 정보 조회 (비밀번호 검증을 위해)
            User userInDb = userDao.findByUserId(userId);

            if (userInDb == null) {
                response.getWriter().write(gson.toJson(new ApiResponse(false, "사용자 정보를 찾을 수 없습니다.")));
                return;
            }
            
            // 4. 입력된 비밀번호와 DB에 저장된 해싱된 비밀번호 비교
            if (!PasswordUtil.checkPassword(enteredPassword, userInDb.getPassword())) {
                response.getWriter().write(gson.toJson(new ApiResponse(false, "비밀번호가 올바르지 않습니다.")));
                return;
            }

            // 5. 비밀번호가 일치하면 사용자 완전 삭제 (하드 삭제)
            boolean success = userDao.deleteUser(userId); 

            if (success) {
                // 탈퇴 성공 시 세션 무효화 (로그아웃 처리)
                session.invalidate();
                response.getWriter().write(gson.toJson(new ApiResponse(true, "회원 탈퇴가 완료되었습니다.")));
            } else {
                response.getWriter().write(gson.toJson(new ApiResponse(false, "회원 탈퇴 처리 중 오류가 발생했습니다.")));
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write(gson.toJson(new ApiResponse(false, "서버 오류가 발생했습니다.")));
        }
    }

    private static class ApiResponse {
        boolean success;
        String message;

        public ApiResponse(boolean success, String message) {
            this.success = success;
            this.message = message;
        }
    }
}