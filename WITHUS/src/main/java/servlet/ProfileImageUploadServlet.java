package servlet;

import com.google.gson.Gson;
import dao.UserDao;
import model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.servlet.http.Part;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.nio.file.Paths;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * 프로필 이미지 업로드를 처리하는 서블릿
 * POST /api/uploadProfileImage
 */
@WebServlet("/api/uploadProfileImage")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1MB - 메모리에 저장할 최대 크기
    maxFileSize = 1024 * 1024 * 5,        // 5MB - 단일 파일 최대 크기
    maxRequestSize = 1024 * 1024 * 10     // 10MB - 전체 요청 최대 크기
)
public class ProfileImageUploadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private UserDao userDao;
    private Gson gson;

    // 허용되는 이미지 확장자
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"};

    @Override
    public void init() throws ServletException {
        super.init();
        this.userDao = new UserDao();
        this.gson = new Gson();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json; charset=UTF-8");
        PrintWriter out = response.getWriter();
        Map<String, Object> result = new HashMap<>();

        // 1. 로그인 확인
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loggedInUser") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            out.print(gson.toJson(result));
            return;
        }

        User loggedInUser = (User) session.getAttribute("loggedInUser");
        int userId = loggedInUser.getUserId();

        try {
            // 2. 파일 파트 가져오기
            Part filePart = request.getPart("profileImage");

            if (filePart == null || filePart.getSize() == 0) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                result.put("success", false);
                result.put("message", "이미지 파일을 선택해주세요.");
                out.print(gson.toJson(result));
                return;
            }

            // 3. 파일명 및 확장자 검증
            String originalFileName = getFileName(filePart);
            String extension = getFileExtension(originalFileName).toLowerCase();

            if (!isAllowedExtension(extension)) {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                result.put("success", false);
                result.put("message", "허용되지 않는 파일 형식입니다. (jpg, jpeg, png, gif, webp만 가능)");
                out.print(gson.toJson(result));
                return;
            }

            // 4. 저장 경로 설정
            String uploadDir = getServletContext().getRealPath("/uploads/profile");
            File uploadDirFile = new File(uploadDir);
            if (!uploadDirFile.exists()) {
                uploadDirFile.mkdirs();
            }

            // 5. 고유 파일명 생성 (UUID + 확장자)
            String newFileName = "profile_" + userId + "_" + UUID.randomUUID().toString().substring(0, 8) + extension;
            String filePath = uploadDir + File.separator + newFileName;

            // 6. 기존 프로필 이미지 삭제 (있는 경우)
            String oldProfileImage = loggedInUser.getProfileImage();
            if (oldProfileImage != null && !oldProfileImage.isEmpty()) {
                String oldFilePath = getServletContext().getRealPath("/" + oldProfileImage);
                File oldFile = new File(oldFilePath);
                if (oldFile.exists()) {
                    oldFile.delete();
                }
            }

            // 7. 파일 저장
            filePart.write(filePath);

            // 8. DB 업데이트 (상대 경로 저장)
            String dbPath = "uploads/profile/" + newFileName;
            boolean updated = userDao.updateProfileImage(userId, dbPath);

            if (updated) {
                // 9. 세션 업데이트
                loggedInUser.setProfileImage(dbPath);
                session.setAttribute("loggedInUser", loggedInUser);

                response.setStatus(HttpServletResponse.SC_OK);
                result.put("success", true);
                result.put("message", "프로필 이미지가 변경되었습니다.");
                result.put("imagePath", dbPath);
            } else {
                // 파일은 저장됐지만 DB 업데이트 실패 시 파일 삭제
                new File(filePath).delete();
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                result.put("success", false);
                result.put("message", "프로필 이미지 업데이트에 실패했습니다.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            result.put("success", false);
            result.put("message", "데이터베이스 오류가 발생했습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            result.put("success", false);
            result.put("message", "파일 업로드 중 오류가 발생했습니다.");
        }

        out.print(gson.toJson(result));
    }

    /**
     * Part에서 파일명 추출
     */
    private String getFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String token : contentDisposition.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf('=') + 1).trim().replace("\"", "");
            }
        }
        return "";
    }

    /**
     * 파일 확장자 추출
     */
    private String getFileExtension(String fileName) {
        int lastDotIndex = fileName.lastIndexOf('.');
        if (lastDotIndex > 0) {
            return fileName.substring(lastDotIndex);
        }
        return "";
    }

    /**
     * 허용된 확장자인지 확인
     */
    private boolean isAllowedExtension(String extension) {
        for (String allowed : ALLOWED_EXTENSIONS) {
            if (allowed.equalsIgnoreCase(extension)) {
                return true;
            }
        }
        return false;
    }
}
