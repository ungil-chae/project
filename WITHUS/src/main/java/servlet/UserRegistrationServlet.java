package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.time.LocalDate;
import java.time.LocalDateTime;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import com.google.gson.GsonBuilder;
import com.google.gson.JsonPrimitive;
import com.google.gson.JsonSerializer;
import com.google.gson.JsonSyntaxException;
import com.google.gson.reflect.TypeToken;

import dao.UserDao; // 직접 사용 대신 UserService에 주입
import dto.ApiResponse;
import dto.UserRegistrationRequest;
import dto.UserResponse;
import model.User;
import security.BCryptPasswordEncoder; // 직접 사용 대신 UserService에 주입
import service.UserRegistrationException; // UserService에서 정의한 회원가입 관련 예외 임포트
import service.UserService; // UserService 임포트 추가

import com.google.gson.reflect.TypeToken;
import java.lang.reflect.Type;

@WebServlet("/api/users")
public class UserRegistrationServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    // private UserDao userDao;           // UserService 사용으로 필요 없음
    // private PasswordEncoder passwordEncoder; // UserService 사용으로 필요 없음
    private UserService userService; // UserService 인스턴스

    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        // 서비스 계층을 초기화하고 의존성을 주입합니다.
        this.userService = new UserService(new UserDao(), new BCryptPasswordEncoder());
        this.gson = new GsonBuilder()
                .registerTypeAdapter(LocalDateTime.class,
                    (JsonSerializer<LocalDateTime>) (src, typeOfSrc, context) -> new JsonPrimitive(src.toString()))
                .registerTypeAdapter(LocalDate.class,
                    (JsonSerializer<LocalDate>) (src, typeOfSrc, context) -> new JsonPrimitive(src.toString()))
                .create();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        response.setCharacterEncoding("UTF-8");
        PrintWriter out = response.getWriter();

        try {
            UserRegistrationRequest reqDto = gson.fromJson(request.getReader(), UserRegistrationRequest.class);

            // 서비스 계층으로 회원가입 로직 위임 (유효성 검증, 중복 확인, 비밀번호 해싱, DB 저장 포함)
            User createdUser = userService.registerUser(reqDto);

            // 회원가입 성공 응답
            UserResponse userResponse = UserResponse.fromUser(createdUser);
            response.setStatus(HttpServletResponse.SC_CREATED); // 201 Created
            Type type = new TypeToken<ApiResponse<UserResponse>>() {}.getType();
            out.print(gson.toJson(ApiResponse.success(userResponse, "회원가입이 완료되었습니다."), type));
        } catch (JsonSyntaxException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(ApiResponse.error("INVALID_JSON", "요청 데이터의 JSON 형식이 올바르지 않습니다.")));
            e.printStackTrace();
        } catch (SQLException e) { // DB 관련 예외
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("DB_ERROR", "데이터베이스 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")));
            e.printStackTrace();
        } catch (UserRegistrationException e) { // UserService에서 발생시킨 회원가입 관련 비즈니스 예외
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST); // 유효성 검증 실패는 400 Bad Request
            out.print(gson.toJson(ApiResponse.error(e.getCode(), e.getMessage())));
            e.printStackTrace();
        } catch (Exception e) { // 그 외 예상치 못한 모든 예외
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("UNKNOWN_ERROR", "알 수 없는 오류가 발생했습니다.")));
            e.printStackTrace();
        }
    }
}