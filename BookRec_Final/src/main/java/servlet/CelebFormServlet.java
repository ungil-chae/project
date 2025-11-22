package servlet;

import com.google.gson.Gson;
import com.google.gson.JsonSyntaxException;
import dao.CelebRecommendationsDao; // DAO 임포트 (Service에 주입)
import dao.CelebRecommendedBooksDao; // DAO 임포트 (Service에 주입)
import dto.ApiResponse;
import dto.CelebRecommendationResponse;
import model.CelebRecommendation;
import service.CelebRecommendationService;
import service.CelebRecommendationException;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.annotation.MultipartConfig; // 파일 업로드를 위해 MultipartConfig 임포트
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part; // 파일 업로드 처리용
import javax.servlet.http.HttpSession; // 세션 관리를 위해 임포트

import java.io.File; // 파일 시스템 경로 처리를 위해 임포트
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors; // Java 8 스트림 API 사용 (만약 필요하다면)


// @WebServlet 어노테이션으로 URL 매핑
@WebServlet("/api/celeb/recommendations")
// @MultipartConfig 어노테이션은 파일 업로드를 처리할 때 필요합니다.
// location: 업로드된 파일이 임시로 저장될 경로 (서버의 실제 경로) - 필수 아님, 없으면 기본 임시 폴더 사용
// fileSizeThreshold: 램에 저장될 파일 크기 임계값 (이보다 작으면 램, 크면 디스크)
// maxFileSize: 단일 파일의 최대 크기
// maxRequestSize: 전체 요청(모든 파트)의 최대 크기
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,     // 10MB
    maxRequestSize = 1024 * 1024 * 50   // 50MB
)
public class CelebFormServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private CelebRecommendationService celebRecommendationService;
    private Gson gson;

    @Override
    public void init() throws ServletException {
        super.init();
        this.celebRecommendationService = new CelebRecommendationService(
            new CelebRecommendationsDao(), // DAO 인스턴스 주입 (복수형 DAO 이름 확인)
            new CelebRecommendedBooksDao()
        );
        this.gson = new Gson();
    }

    // 셀럽 추천 글 작성 폼 제출 처리 (POST 요청)
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();

        // 관리자 권한 확인 (선택 사항, 필요 시 구현)
        // HttpSession session = request.getSession(false);
        // if (session == null || session.getAttribute("loggedInUser") == null || !isAdmin(session)) {
        //     response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
        //     out.print(gson.toJson(ApiResponse.error("UNAUTHORIZED", "권한이 없습니다.")));
        //     return;
        // }

        try {
            // 폼 데이터 파싱 (Multipart/form-data 요청에서 파라미터 가져오기)
            String celebName = request.getParameter("celebName"); // celebForm.jsp의 input name="celebName"
            String celebDescription = request.getParameter("celebDescription"); // celebForm.jsp의 input name="celebDescription"
            Part thumbnailPart = request.getPart("thumbnail"); // celebForm.jsp의 input name="thumbnail"

            // 1. 필수 입력값 유효성 검증
            if (celebName == null || celebName.trim().isEmpty() ||
                celebDescription == null || celebDescription.trim().isEmpty()) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                out.print(gson.toJson(ApiResponse.error("INVALID_INPUT", "셀럽 이름과 설명을 입력해주세요.")));
                return;
            }

            // 2. 이미지 파일 저장 처리
            String celebImageUrl = null;
            if (thumbnailPart != null && thumbnailPart.getSize() > 0) {
                // 실제 파일 저장 경로 설정 (웹 애플리케이션의 img/celeb_thumbnails 폴더)
                String uploadPath = getServletContext().getRealPath("/img/celeb_thumbnails");
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdirs(); // 디렉토리가 없으면 생성
                }
                
                String fileName = getFileName(thumbnailPart); // 파일 이름 추출
                String filePath = uploadPath + File.separator + fileName; // 최종 저장될 파일 경로
                thumbnailPart.write(filePath); // 파일 저장
                celebImageUrl = "img/celeb_thumbnails/" + fileName; // DB에 저장할 상대 URL
            } else {
                // 썸네일 이미지는 필수가 아닐 수 있지만, 필수라면 여기서 에러 처리
                // throw new CelebRecommendationException("NO_IMAGE", "썸네일 이미지를 업로드해주세요.");
            }

            // 3. 추천할 책 ID 리스트 파싱
            // celebForm.jsp에 책 ID를 입력받는 폼 요소가 없으므로 현재는 하드코딩
            // 실제 구현에서는 JavaScript로 동적으로 추가된 책 ID들을 배열 형태로 전송받아야 합니다.
            // 예: List<Integer> recommendedBookIds = parseBookIdsFromRequest(request);
            List<Integer> recommendedBookIds = new ArrayList<>();
            recommendedBookIds.add(1); // 예시: book_id 1
            recommendedBookIds.add(2); // 예시: book_id 2
            // TODO: 실제 폼에서 책 ID를 받아오는 로직 구현 필요

            // 4. CelebRecommendation 모델 생성
            CelebRecommendation celeb = new CelebRecommendation();
            celeb.setCelebName(celebName);
            celeb.setCelebDescription(celebDescription);
            celeb.setCelebImageUrl(celebImageUrl); // 저장된 이미지 URL 설정

            // 5. 서비스 호출 (DB 저장)
            // 서비스에서 유효성 검증 및 추천 책 목록 저장까지 처리
            CelebRecommendationResponse responseDto = celebRecommendationService.createCelebRecommendation(celeb, recommendedBookIds);

            // 6. 성공 응답
            response.setStatus(HttpServletResponse.SC_CREATED); // 201 Created
            out.print(gson.toJson(ApiResponse.success(responseDto, "셀럽 추천 글이 성공적으로 작성되었습니다.")));

        } catch (JsonSyntaxException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(ApiResponse.error("INVALID_JSON", "요청 데이터 형식이 올바르지 않습니다.")));
            e.printStackTrace();
        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("DB_ERROR", "데이터베이스 오류가 발생했습니다. 잠시 후 다시 시도해주세요.")));
            e.printStackTrace();
        } catch (CelebRecommendationException e) { // 서비스에서 발생시키는 비즈니스 로직 오류
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            out.print(gson.toJson(ApiResponse.error(e.getCode(), e.getMessage())));
            e.printStackTrace();
        } catch (Exception e) { // 그 외 예상치 못한 모든 예외
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            out.print(gson.toJson(ApiResponse.error("UNKNOWN_ERROR", "알 수 없는 오류가 발생했습니다.")));
            e.printStackTrace();
        }
    }

    // Part 객체에서 파일 이름을 추출하는 헬퍼 메서드
    private String getFileName(Part part) {
        for (String content : part.getHeader("content-disposition").split(";")) {
            if (content.trim().startsWith("filename")) {
                return content.substring(content.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return null;
    }

    // 관리자 권한 확인 (현재 미구현, 필요 시 구현)
    // private boolean isAdmin(HttpSession session) { /* 관리자 권한 확인 로직 */ return true; }
}