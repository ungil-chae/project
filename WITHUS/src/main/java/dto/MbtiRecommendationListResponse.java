package dto;

import java.util.List;

/**
 * MBTI 기반 추천 목록 응답 DTO
 * 사용자의 MBTI와 추천 도서 목록을 담습니다.
 */
public class MbtiRecommendationListResponse {
    private final String userMbti;
    private final int totalCount;
    private final List<BookRecommendationResponse> recommendations;

    public MbtiRecommendationListResponse(String userMbti, List<BookRecommendationResponse> recommendations) {
        this.userMbti = userMbti;
        this.totalCount = recommendations.size();
        this.recommendations = recommendations;
    }

    // Getter 메서드
    public String getUserMbti() { return userMbti; }
    public int getTotalCount() { return totalCount; }
    public List<BookRecommendationResponse> getRecommendations() { return recommendations; }

    @Override
    public String toString() {
        return "MbtiRecommendationListResponse{" +
                "userMbti='" + userMbti + '\'' +
                ", totalCount=" + totalCount +
                '}';
    }
}
