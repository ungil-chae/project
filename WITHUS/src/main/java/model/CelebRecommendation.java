package model;

import java.time.LocalDateTime;
import java.util.Objects;

public class CelebRecommendation {
    private int celebRecId;
    private String celebName;
    private String celebDescription;
    private String celebImageUrl;
    private LocalDateTime recommendDate;

    public CelebRecommendation() {}

    public CelebRecommendation(int celebRecId, String celebName, String celebDescription,
                               String celebImageUrl, LocalDateTime recommendDate) {
        this.celebRecId = celebRecId;
        this.celebName = celebName;
        this.celebDescription = celebDescription;
        this.celebImageUrl = celebImageUrl;
        this.recommendDate = recommendDate;
    }

    // --- Getters ---
    public int getCelebRecId() { return celebRecId; }
    public String getCelebName() { return celebName; }
    public String getCelebDescription() { return celebDescription; }
    public String getCelebImageUrl() { return celebImageUrl; }
    public LocalDateTime getRecommendDate() { return recommendDate; }

    // --- Setters ---
    public void setCelebRecId(int celebRecId) { this.celebRecId = celebRecId; }
    public void setCelebName(String celebName) { this.celebName = celebName; }
    public void setCelebDescription(String celebDescription) { this.celebDescription = celebDescription; }
    public void setCelebImageUrl(String celebImageUrl) { this.celebImageUrl = celebImageUrl; }
    public void setRecommendDate(LocalDateTime recommendDate) { this.recommendDate = recommendDate; }

    @Override
    public String toString() {
        return "CelebRecommendation{" +
               "celebRecId=" + celebRecId +
               ", celebName='" + celebName + '\'' +
               ", celebDescription='" + (celebDescription != null && celebDescription.length() > 50 ? celebDescription.substring(0, 50) + "..." : celebDescription) + '\'' +
               ", celebImageUrl='" + celebImageUrl + '\'' +
               ", recommendDate=" + recommendDate +
               '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        CelebRecommendation that = (CelebRecommendation) o;
        return celebRecId == that.celebRecId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(celebRecId);
    }
}