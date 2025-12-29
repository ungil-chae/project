// package servlet;

package servlet;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import dao.InquiryDao;
import dto.ApiResponse;
import dto.InquiryRequest;
import dto.InquiryResponse;
import service.InquiryService;
import service.InquiryException; // <--- InquiryException 임포트 추가

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/api/users/me/inquiries/*") // /api/users/me/inquiries (GET, POST), /api/users/me/inquiries/{inquiryId} (GET)
public class InquiryServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private InquiryService inquiryService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        this.inquiryService = new InquiryService(new InquiryDao());
        this.gson = new Gson();
    }

    // 문의 목록 조회 (GET /api/users/me/inquiries) 또는 특정 문의 상세 조회 (GET /api/users/me/inquiries/{inquiryId})
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

        int userId = (int) session.getAttribute("loggedInUser");
        String pathInfo = request.getPathInfo(); // "/{inquiryId}" 또는 null

        try {
            if (pathInfo == null || "/".equals(pathInfo)) {
                // 전체 문의 목록 조회: GET /api/users/me/inquiries
                List<InquiryResponse> inquiries = inquiryService.getMyInquiries(userId);
                response.setStatus(HttpServletResponse.SC_OK);
                out.print(gson.toJson(ApiResponse.success(inquiries, "문의 목록 조회 성공")));
            } else {
                // 특정 문의 상세 조회: GET /api/users/me/inquiries/{inquiryId}
                int inquiryId;
                try {
                    inquiryId = Integer.parseInt(pathInfo.substring(1)); // "/123" -> "123"
                } catch (NumberFormatException e) {
                    response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                    out.print(gson.toJson(ApiResponse.error("INVALID_INQUIRY_ID", "유효하지 않은 문의 ID 형식입니다.")));
                    return;
                }

                InquiryResponse inquiry = inquiryService.getMyInquiryDetail(inquiryId, userId);
                response.setStatus(HttpServletResponse.SC_OK);
                out.print(gson.toJson(ApiResponse.success(inquiry, "문의 상세 조회 성공")));
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("DB_ERROR", "데이터베이스 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")));
            e.printStackTrace();
        } catch (InquiryException e) { // 비즈니스 로직 오류 (예: 문의를 찾을 수 없음)
            response.setStatus(HttpServletResponse.SC_NOT_FOUND); // 404 Not Found 또는 403 Forbidden
            out.print(gson.toJson(ApiResponse.error(e.getCode(), e.getMessage())));
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("UNKNOWN_ERROR", "알 수 없는 오류가 발생했습니다.")));
            e.printStackTrace();
        }
    }

    // 새로운 문의 생성 (POST /api/users/me/inquiries)
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

        int userId = (int) session.getAttribute("loggedInUser");

        try {
            InquiryRequest inquiryRequest = gson.fromJson(request.getReader(), InquiryRequest.class);

            // 서비스 호출
            InquiryResponse createdInquiry = inquiryService.createInquiry(userId, inquiryRequest);

            if (createdInquiry != null) {
                response.setStatus(HttpServletResponse.SC_CREATED); // 201 Created
                out.print(gson.toJson(ApiResponse.success(createdInquiry, "문의가 성공적으로 접수되었습니다.")));
            } else {
                // 이 블록은 InquiryService에서 예외를 던지므로 사실상 실행되지 않음
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                out.print(gson.toJson(ApiResponse.error("CREATE_FAILED", "문의 생성에 실패했습니다.")));
            }

        } catch (JsonSyntaxException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(ApiResponse.error("INVALID_JSON", "요청 데이터의 JSON 형식이 올바르지 않습니다.")));
            e.printStackTrace();
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("DB_ERROR", "데이터베이스 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")));
            e.printStackTrace();
        } catch (InquiryException e) { // 비즈니스 로직 오류 (예: 유효성 검증 실패)
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(ApiResponse.error(e.getCode(), e.getMessage())));
            e.printStackTrace();
        } catch (Exception e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("UNKNOWN_ERROR", "알 수 없는 오류가 발생했습니다.")));
            e.printStackTrace();
        }
    }
}