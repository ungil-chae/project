package dto;

import java.time.LocalDateTime; // <-- Date 대신 LocalDateTime 임포트

public class CelebRecommendations {
    private int celebRecId;          // celeb_rec_id -> celebRecId
    private String celebName;        // celeb_name -> celebName
    private String celebDescription; // celeb_description -> celebDescription
    private String celebImageUrl;    // celeb_image_url -> celebImageUrl
    private LocalDateTime recommendDate; // recommend_date -> recommendDate, Date -> LocalDateTime

    public CelebRecommendations() {
        // super(); // 불필요하므로 제거
    }

    public CelebRecommendations(int celebRecId, String celebName, String celebDescription, String celebImageUrl,
                                LocalDateTime recommendDate) { // <-- LocalDateTime으로 타입 변경
        // super(); // 불필요하므로 제거
        this.celebRecId = celebRecId;
        this.celebName = celebName;
        this.celebDescription = celebDescription;
        this.celebImageUrl = celebImageUrl;
        this.recommendDate = recommendDate;
    }

    // --- Getters (camelCase에 맞춰 변경) ---
    public int getCelebRecId() {
        return celebRecId;
    }
    public String getCelebName() {
        return celebName;
    }
    public String getCelebDescription() {
        return celebDescription;
    }
    public String getCelebImageUrl() {
        return celebImageUrl;
    }
    public LocalDateTime getRecommendDate() { // <-- LocalDateTime으로 타입 변경
        return recommendDate;
    }

    // --- Setters (camelCase에 맞춰 변경) ---
    public void setCelebRecId(int celebRecId) {
        this.celebRecId = celebRecId;
    }
    public void setCelebName(String celebName) {
        this.celebName = celebName;
    }
    public void setCelebDescription(String celebDescription) {
        this.celebDescription = celebDescription;
    }
    public void setCelebImageUrl(String celebImageUrl) {
        this.celebImageUrl = celebImageUrl;
    }
    public void setRecommendDate(LocalDateTime recommendDate) { // <-- LocalDateTime으로 타입 변경
        this.recommendDate = recommendDate;
    }

    @Override
    public String toString() {
        return "CelebRecommendations [celebRecId=" + celebRecId + ", celebName=" + celebName
                + ", celebDescription=" + celebDescription + ", celebImageUrl=" + celebImageUrl
                + ", recommendDate=" + recommendDate + "]";
    }
}
