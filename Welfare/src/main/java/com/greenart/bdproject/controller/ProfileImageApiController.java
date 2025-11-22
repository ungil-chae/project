package com.greenart.bdproject.controller;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardCopyOption;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

import com.greenart.bdproject.dao.ProjectMemberDao;
import com.greenart.bdproject.dto.Member;

/**
 * 프로필 이미지 업로드 API 컨트롤러
 */
@RestController
@RequestMapping("/api/profile")
public class ProfileImageApiController {

    private static final Logger logger = LoggerFactory.getLogger(ProfileImageApiController.class);

    // 업로드 디렉토리 (실제 서버 경로)
    private static final String UPLOAD_DIR = "C:/workspace/Study/Welfare/src/main/webapp/resources/uploads/profiles/";

    // 웹 접근 경로
    private static final String WEB_PATH = "/resources/uploads/profiles/";

    // 허용되는 파일 확장자
    private static final String[] ALLOWED_EXTENSIONS = {".jpg", ".jpeg", ".png", ".gif", ".webp"};

    // 최대 파일 크기 (5MB)
    private static final long MAX_FILE_SIZE = 5 * 1024 * 1024;

    @Autowired
    private ProjectMemberDao memberDao;

    /**
     * 프로필 이미지 업로드
     */
    @PostMapping("/upload-image")
    public Map<String, Object> uploadProfileImage(
            @RequestParam("image") MultipartFile file,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 로그인 확인
            String userEmail = (String) session.getAttribute("userId");
            if (userEmail == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            logger.info("프로필 이미지 업로드 시작: {}", userEmail);

            // 파일 검증
            if (file.isEmpty()) {
                response.put("success", false);
                response.put("message", "파일이 비어있습니다.");
                return response;
            }

            // 파일 크기 검증
            if (file.getSize() > MAX_FILE_SIZE) {
                response.put("success", false);
                response.put("message", "파일 크기는 5MB를 초과할 수 없습니다.");
                return response;
            }

            // 파일 확장자 검증
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();

            boolean validExtension = false;
            for (String ext : ALLOWED_EXTENSIONS) {
                if (extension.equals(ext)) {
                    validExtension = true;
                    break;
                }
            }

            if (!validExtension) {
                response.put("success", false);
                response.put("message", "허용되지 않는 파일 형식입니다. (jpg, jpeg, png, gif, webp만 가능)");
                return response;
            }

            // 업로드 디렉토리 생성
            File uploadDir = new File(UPLOAD_DIR);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
                logger.info("업로드 디렉토리 생성: {}", UPLOAD_DIR);
            }

            // 고유 파일명 생성 (UUID + 확장자)
            String newFilename = UUID.randomUUID().toString() + extension;
            Path filePath = Paths.get(UPLOAD_DIR + newFilename);

            // 파일 저장
            Files.copy(file.getInputStream(), filePath, StandardCopyOption.REPLACE_EXISTING);
            logger.info("파일 저장 완료: {}", filePath);

            // 웹 접근 URL 생성
            String imageUrl = WEB_PATH + newFilename;

            // DB 업데이트 (Member 테이블의 profile_image_url 컬럼)
            Member member = memberDao.select(userEmail);
            if (member == null) {
                response.put("success", false);
                response.put("message", "사용자 정보를 찾을 수 없습니다.");
                return response;
            }

            // 기존 이미지 삭제 (있다면)
            String oldImageUrl = member.getProfileImageUrl();
            if (oldImageUrl != null && !oldImageUrl.isEmpty()) {
                deleteOldImage(oldImageUrl);
            }

            // 새 이미지 URL 저장
            member.setProfileImageUrl(imageUrl);
            int result = memberDao.updateProfileImage(userEmail, imageUrl);

            if (result > 0) {
                response.put("success", true);
                response.put("imageUrl", imageUrl);
                response.put("message", "프로필 이미지가 업로드되었습니다.");
                logger.info("프로필 이미지 업데이트 성공: {} -> {}", userEmail, imageUrl);
            } else {
                response.put("success", false);
                response.put("message", "데이터베이스 업데이트에 실패했습니다.");
            }

        } catch (IOException e) {
            logger.error("파일 업로드 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "파일 업로드 중 오류가 발생했습니다.");
        } catch (Exception e) {
            logger.error("프로필 이미지 업로드 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "프로필 이미지 업로드에 실패했습니다.");
        }

        return response;
    }

    /**
     * 현재 프로필 이미지 조회
     */
    @GetMapping("/image")
    public Map<String, Object> getProfileImage(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userEmail = (String) session.getAttribute("userId");
            if (userEmail == null) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            Member member = memberDao.select(userEmail);
            if (member != null && member.getProfileImageUrl() != null) {
                response.put("success", true);
                response.put("imageUrl", member.getProfileImageUrl());
            } else {
                response.put("success", true);
                response.put("imageUrl", null);
            }

        } catch (Exception e) {
            logger.error("프로필 이미지 조회 중 오류 발생", e);
            response.put("success", false);
            response.put("message", "프로필 이미지 조회에 실패했습니다.");
        }

        return response;
    }

    /**
     * 기존 이미지 파일 삭제
     */
    private void deleteOldImage(String imageUrl) {
        try {
            if (imageUrl.startsWith(WEB_PATH)) {
                String filename = imageUrl.substring(WEB_PATH.length());
                Path oldFilePath = Paths.get(UPLOAD_DIR + filename);
                Files.deleteIfExists(oldFilePath);
                logger.info("기존 이미지 삭제: {}", oldFilePath);
            }
        } catch (IOException e) {
            logger.warn("기존 이미지 삭제 실패: {}", imageUrl, e);
        }
    }
}
