package servlet;

import com.google.gson.Gson;
import com.google.gson.JsonObject; // JSON 파싱을 위해 JsonObject 임포트
import com.google.gson.JsonSyntaxException;
import dao.UserDao;
import dto.ApiResponse;
import dto.PasswordChangeRequest;
import dto.UserProfileUpdateRequest;
import dto.UserResponse;
import model.User; // model.User 임포트
import security.BCryptPasswordEncoder;
import security.PasswordEncoder;
import service.UserService;
import service.UserProfileException; // UserProfileException 임포트 (UserService에서 던질 수 있는 예외)

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;

@WebServlet("/api/users/me/*") // /api/users/me, /api/users/me/profile, /api/users/me/password, /api/users/me/verify-password, /api/users/me/withdraw 등 처리
public class UserProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserService userService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        this.userService = new UserService(new UserDao(), new BCryptPasswordEncoder());
        this.gson = new Gson();
    }

    // 현재 로그인된 사용자 프로필 조회 (GET /api/users/me)
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(gson.toJson(ApiResponse.error("UNAUTHORIZED", "로그인이 필요합니다.")));
            return;
        }

        // 세션에서 User 객체를 가져와 userId를 얻습니다.
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        int userId = loggedInUser.getUserId();

        try {
            User user = userService.getUserProfile(userId);

            if (user == null) { // 이 경우는 세션에 User가 있는데 DB에 없는 비정상적인 상황
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(gson.toJson(ApiResponse.error("USER_NOT_FOUND", "사용자 정보를 찾을 수 없습니다.")));
                return;
            }

            // 계정 상태 확인
            if (!"active".equals(user.getStatus())) {
                response.setStatus(HttpServletResponse.SC_FORBIDDEN); // 403 Forbidden
                out.print(gson.toJson(ApiResponse.error("ACCOUNT_INACTIVE", "비활성화되거나 탈퇴한 계정입니다.")));
                return;
            }

            UserResponse userResponse = UserResponse.fromUser(user);
            response.setStatus(HttpServletResponse.SC_OK);
            out.print(gson.toJson(ApiResponse.success(userResponse, "프로필 정보 조회 성공")));

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("DB_ERROR", "데이터베이스 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")));
            e.printStackTrace();
        } catch (UserProfileException e) { // UserService에서 던질 수 있는 예외 (getUserProfile에서 USER_NOT_FOUND, ACCOUNT_INACTIVE)
            // USER_NOT_FOUND: 404, ACCOUNT_INACTIVE: 403
            response.setStatus("USER_NOT_FOUND".equals(e.getCode()) ? HttpServletResponse.SC_NOT_FOUND : HttpServletResponse.SC_FORBIDDEN);
            out.print(gson.toJson(ApiResponse.error(e.getCode(), e.getMessage())));
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("UNKNOWN_ERROR", "알 수 없는 오류가 발생했습니다.")));
            e.printStackTrace();
        }
    }


    // 마이페이지 비밀번호 확인 요청 처리 (POST /api/users/me/verify-password) 및 기타 POST 요청
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(gson.toJson(ApiResponse.error("UNAUTHORIZED", "로그인이 필요합니다.")));
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        int userId = loggedInUser.getUserId();

        String pathInfo = request.getPathInfo(); // "/verify-password" 일 것으로 예상

        try {
            if ("/verify-password".equals(pathInfo)) {
                // 비밀번호 확인 요청 처리
                JsonObject jsonRequest = gson.fromJson(request.getReader(), JsonObject.class);
                // 클라이언트에서 'password'라는 이름으로 전송한다고 가정
                String enteredPassword = jsonRequest.get("password").getAsString(); 

                if (enteredPassword == null || enteredPassword.trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(ApiResponse.error("INVALID_INPUT", "비밀번호를 입력해주세요.")));
                    return;
                }

                // 서비스 호출하여 비밀번호 검증
                boolean verified = userService.verifyPassword(userId, enteredPassword);

                // verifyPassword는 성공하면 true, 실패하면 UserProfileException을 던지므로
                // 이곳에 도달하면 무조건 성공한 경우
                response.setStatus(HttpServletResponse.SC_OK);
                out.print(gson.toJson(ApiResponse.success(null, "비밀번호가 확인되었습니다.")));
                

            } else {
                // 이 서블릿은 현재 /api/users/me/verify-password POST만 처리하도록 설계
                // 다른 POST 요청이 들어오면 404
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(gson.toJson(ApiResponse.error("NOT_FOUND", "요청하신 경로를 찾을 수 없습니다.")));
            }

        } catch (JsonSyntaxException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(ApiResponse.error("INVALID_JSON", "요청 데이터의 JSON 형식이 올바르지 않습니다.")));
            e.printStackTrace();
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("DB_ERROR", "데이터베이스 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")));
            e.printStackTrace();
        } catch (UserProfileException e) { // 서비스에서 발생시키는 비밀번호 불일치 예외
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 Unauthorized
            out.print(gson.toJson(ApiResponse.error(e.getCode(), e.getMessage())));
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("UNKNOWN_ERROR", "알 수 없는 오류가 발생했습니다.")));
            e.printStackTrace();
        }
    }

    // 프로필 정보 수정 (PUT /api/users/me/profile) 및 비밀번호 변경 (PUT /api/users/me/password)
    @Override
    protected void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(gson.toJson(ApiResponse.error("UNAUTHORIZED", "로그인이 필요합니다.")));
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        int userId = loggedInUser.getUserId();

        String pathInfo = request.getPathInfo();

        try {
            if ("/profile".equals(pathInfo)) {
                UserProfileUpdateRequest reqDto = gson.fromJson(request.getReader(), UserProfileUpdateRequest.class);
                if (reqDto == null || reqDto.getNickname() == null || reqDto.getEmail() == null ||
                    reqDto.getNickname().trim().isEmpty() || reqDto.getEmail().trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(ApiResponse.error("INVALID_INPUT", "닉네임과 이메일은 필수 입력값입니다.")));
                    return;
                }
                boolean success = userService.updateUserProfile(userId, reqDto);

                if (success) {
                    // 세션의 User 객체 업데이트: 프로필 변경 후 세션 정보도 최신화
                    loggedInUser = userService.getUserProfile(userId); // DB에서 최신 User 객체 다시 가져옴
                    session.setAttribute("loggedInUser", loggedInUser); // 세션 업데이트
                    response.setStatus(HttpServletResponse.SC_OK);
                    out.print(gson.toJson(ApiResponse.success(null, "프로필 정보가 성공적으로 수정되었습니다.")));
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    out.print(gson.toJson(ApiResponse.error("UPDATE_FAILED", "프로필 정보 수정에 실패했습니다.")));
                }

            } else if ("/password".equals(pathInfo)) {
                PasswordChangeRequest reqDto = gson.fromJson(request.getReader(), PasswordChangeRequest.class);
                if (reqDto == null || reqDto.getCurrentPassword() == null || reqDto.getNewPassword() == null ||
                    reqDto.getCurrentPassword().trim().isEmpty() || reqDto.getNewPassword().trim().isEmpty()) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(ApiResponse.error("INVALID_INPUT", "현재 비밀번호와 새 비밀번호를 모두 입력해주세요.")));
                    return;
                }
                if (reqDto.getNewPassword().length() < 8 || !reqDto.getNewPassword().matches(".*[!@#$%^&*()].*")) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(ApiResponse.error("INVALID_PASSWORD", "새 비밀번호는 최소 8자 이상이어야 하며 특수문자를 포함해야 합니다.")));
                    return;
                }

                // 현재 비밀번호 검증 (이 로직은 서비스의 changePassword에 이미 포함되어 있음)
                // boolean verified = userService.verifyPassword(userId, reqDto.getCurrentPassword()); // 불필요한 중복 호출
                boolean success = userService.changePassword(userId, reqDto.getNewPassword()); // reqDto.getCurrentPassword() 제거

                if (success) {
                    response.setStatus(HttpServletResponse.SC_OK);
                    out.print(gson.toJson(ApiResponse.success(null, "비밀번호가 성공적으로 변경되었습니다.")));
                } else {
                    response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 이 경우는 서비스에서 이미 예외 던짐
                    out.print(gson.toJson(ApiResponse.error("PASSWORD_CHANGE_FAILED", "비밀번호 변경에 실패했습니다.")));
                }

            } else {
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                out.print(gson.toJson(ApiResponse.error("NOT_FOUND", "요청하신 경로를 찾을 수 없습니다.")));
            }

        } catch (JsonSyntaxException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(ApiResponse.error("INVALID_JSON", "요청 데이터의 JSON 형식이 올바르지 않습니다.")));
            e.printStackTrace();
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("DB_ERROR", "데이터베이스 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")));
            e.printStackTrace();
        } catch (UserProfileException e) { // 서비스에서 발생시키는 예외
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED); // 401 (비밀번호 불일치), 400 (유효성 검증 실패), 404 (사용자 없음) 등
            if ("INVALID_PASSWORD".equals(e.getCode()) || "DUPLICATE_NICKNAME".equals(e.getCode()) || "DUPLICATE_EMAIL".equals(e.getCode())) {
                 response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 유효성 검증 실패는 400
            } else if ("USER_NOT_FOUND".equals(e.getCode())) {
                 response.setStatus(HttpServletResponse.SC_NOT_FOUND); // 사용자 없음은 404
            }
            out.print(gson.toJson(ApiResponse.error(e.getCode(), e.getMessage())));
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("UNKNOWN_ERROR", "알 수 없는 오류가 발생했습니다.")));
            e.printStackTrace();
        }
    }

    // 회원 탈퇴 (DELETE /api/users/me/withdraw)
    @Override
    protected void doDelete(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            out.print(gson.toJson(ApiResponse.error("UNAUTHORIZED", "로그인이 필요합니다.")));
            return;
        }
        User loggedInUser = (User) session.getAttribute("loggedInUser");
        int userId = loggedInUser.getUserId();

        String pathInfo = request.getPathInfo(); 

        if ("/withdraw".equals(pathInfo)) { // DELETE /api/users/me/withdraw 경로를 처리
            try {
                boolean success = userService.withdrawUser(userId);

                if (success) {
                    session.invalidate(); // 세션 무효화
                    response.setStatus(HttpServletResponse.SC_OK); // 또는 204 No Content
                    out.print(gson.toJson(ApiResponse.success(null, "회원 탈퇴가 성공적으로 처리되었습니다.")));
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    out.print(gson.toJson(ApiResponse.error("WITHDRAW_FAILED", "회원 탈퇴 처리 중 오류가 발생했습니다.")));
                }
            } catch (SQLException e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(ApiResponse.error("DB_ERROR", "데이터베이스 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")));
                e.printStackTrace();
            } catch (UserProfileException e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR); // 또는 적절한 상태 코드
                out.print(gson.toJson(ApiResponse.error(e.getCode(), e.getMessage())));
                e.printStackTrace();
            } catch (Exception e) {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(ApiResponse.error("UNKNOWN_ERROR", "알 수 없는 오류가 발생했습니다.")));
                e.printStackTrace();
            }
        } else {
            response.setStatus(HttpServletResponse.SC_NOT_FOUND);
            out.print(gson.toJson(ApiResponse.error("NOT_FOUND", "요청하신 경로를 찾을 수 없습니다.")));
        }
    }
}
