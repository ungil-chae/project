package service;

import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import dao.RecommendationDao;
import dao.UserDao;
import dto.BookRecommendationResponse;
import dto.MbtiRecommendationListResponse;
import model.User;

/**
 * 도서 추천 관련 비즈니스 로직을 처리하는 서비스 클래스
 * MBTI 기반 협업 필터링 추천 기능을 제공합니다.
 */
public class RecommendationService {

    private static final int DEFAULT_RECOMMENDATION_LIMIT = 10;

    private final RecommendationDao recommendationDao;
    private final UserDao userDao;

    public RecommendationService() {
        this.recommendationDao = new RecommendationDao();
        this.userDao = new UserDao();
    }

    // 테스트용 생성자 (의존성 주입)
    public RecommendationService(RecommendationDao recommendationDao, UserDao userDao) {
        this.recommendationDao = recommendationDao;
        this.userDao = userDao;
    }

    /**
     * 사용자의 MBTI를 기반으로 도서를 추천합니다.
     *
     * 추천 알고리즘:
     * 1. 사용자의 MBTI 조회
     * 2. 같은 MBTI 사용자들이 찜한 책 중 본인이 찜하지 않은 책 조회
     * 3. 찜 횟수가 많은 순으로 정렬하여 반환
     *
     * @param userId 로그인한 사용자 ID
     * @return MBTI 기반 추천 목록 응답 DTO
     * @throws SQLException DB 오류 발생 시
     * @throws RecommendationException 추천 실패 시 (MBTI 미설정 등)
     */
    public MbtiRecommendationListResponse getMbtiBasedRecommendations(int userId)
            throws SQLException, RecommendationException {
        return getMbtiBasedRecommendations(userId, DEFAULT_RECOMMENDATION_LIMIT);
    }

    /**
     * 사용자의 MBTI를 기반으로 도서를 추천합니다. (개수 지정)
     *
     * @param userId 로그인한 사용자 ID
     * @param limit 추천받을 최대 책 개수
     * @return MBTI 기반 추천 목록 응답 DTO
     * @throws SQLException DB 오류 발생 시
     * @throws RecommendationException 추천 실패 시
     */
    public MbtiRecommendationListResponse getMbtiBasedRecommendations(int userId, int limit)
            throws SQLException, RecommendationException {

        // 1. 사용자 정보 조회
        User user = userDao.findByUserId(userId);
        if (user == null) {
            throw new RecommendationException("USER_NOT_FOUND", "사용자를 찾을 수 없습니다.");
        }

        // 2. MBTI 확인
        String mbti = user.getMbti();
        if (mbti == null || mbti.trim().isEmpty()) {
            throw new RecommendationException("MBTI_NOT_SET",
                "MBTI가 설정되지 않았습니다. 프로필에서 MBTI를 설정해주세요.");
        }

        // 3. 추천 도서 조회
        List<BookRecommendationResponse> recommendations =
            recommendationDao.getRecommendationsByMbti(mbti.toUpperCase(), userId, limit);

        // 4. 응답 생성
        return new MbtiRecommendationListResponse(mbti.toUpperCase(), recommendations);
    }

    /**
     * 추천 관련 예외 클래스
     */
    public static class RecommendationException extends Exception {
        private final String errorCode;

        public RecommendationException(String errorCode, String message) {
            super(message);
            this.errorCode = errorCode;
        }

        public String getErrorCode() {
            return errorCode;
        }
    }
}
