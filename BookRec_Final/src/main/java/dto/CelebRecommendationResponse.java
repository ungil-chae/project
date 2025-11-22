package dto;

import java.time.LocalDateTime;

// 클라이언트에게 셀럽 추천 목록을 응답할 때 사용할 데이터 구조 (JSP의 celebList.jsp와 연관)
public class CelebRecommendationResponse {
    private final int celebRecId;
    private final String celebName;
    private final String celebDescription;
    private final String celebImageUrl;
    private final LocalDateTime recommendDate;

    // 모든 필드를 포함하는 생성자
    public CelebRecommendationResponse(int celebRecId, String celebName, String celebDescription,
                                     String celebImageUrl, LocalDateTime recommendDate) {
        this.celebRecId = celebRecId;
        this.celebName = celebName;
        this.celebDescription = celebDescription;
        this.celebImageUrl = celebImageUrl;
        this.recommendDate = recommendDate;
    }

    // Model.CelebRecommendation 객체를 DTO.CelebRecommendationResponse 객체로 변환하는 헬퍼 메서드
    // service.CelebRecommendationService 에서 사용됩니다.
    public static CelebRecommendationResponse fromModel(model.CelebRecommendation celeb) {
        // model.CelebRecommendation 이 존재하고 그 Getter 메서드들이 올바른지 확인해주세요.
        return new CelebRecommendationResponse(
            celeb.getCelebRecId(),
            celeb.getCelebName(),
            celeb.getCelebDescription(),
            celeb.getCelebImageUrl(),
            celeb.getRecommendDate()
        );
    }

    // --- Getter 메서드 (final 필드이므로 Setter는 보통 필요 없음) ---
    public int getCelebRecId() { return celebRecId; }
    public String getCelebName() { return celebName; }
    public String getCelebDescription() { return celebDescription; }
    public String getCelebImageUrl() { return celebImageUrl; }
    public LocalDateTime getRecommendDate() { return recommendDate; }

    @Override
    public String toString() {
        return "CelebRecommendationResponse{" +
               "celebRecId=" + celebRecId +
               ", celebName='" + celebName + '\'' +
               ", celebDescription='" + (celebDescription != null && celebDescription.length() > 50 ? celebDescription.substring(0, 50) + "..." : celebDescription) + '\'' +
               ", celebImageUrl='" + celebImageUrl + '\'' +
               ", recommendDate=" + recommendDate +
               '}';
    }
}