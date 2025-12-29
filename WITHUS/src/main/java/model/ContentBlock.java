package model;

import java.time.LocalDateTime; // 생성/업데이트 시각용

public class ContentBlock {
    private int blockId;
    private int reviewId; // reviews 테이블의 review_id를 참조
    private String blockType; // ENUM('text','image') -> Java에서는 String
    private int blockOrder;
    private String textContent;
    private String imageUrl;
    private LocalDateTime createdAt; // DB 스키마에 새로 추가된 필드
    private LocalDateTime updatedAt; // DB 스키마에 새로 추가된 필드

    // 기본 생성자
    public ContentBlock() {}

    // 모든 필드를 포함하는 생성자 (필요에 따라 오버로드)
    public ContentBlock(int blockId, int reviewId, String blockType, int blockOrder,
                        String textContent, String imageUrl, LocalDateTime createdAt, LocalDateTime updatedAt) {
        this.blockId = blockId;
        this.reviewId = reviewId;
        this.blockType = blockType;
        this.blockOrder = blockOrder;
        this.textContent = textContent;
        this.imageUrl = imageUrl;
        this.createdAt = createdAt;
        this.updatedAt = updatedAt;
    }

    // Getter 및 Setter 메서드
    public int getBlockId() { return blockId; }
    public void setBlockId(int blockId) { this.blockId = blockId; }

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }

    public String getBlockType() { return blockType; }
    public void setBlockType(String blockType) { this.blockType = blockType; }

    public int getBlockOrder() { return blockOrder; }
    public void setBlockOrder(int blockOrder) { this.blockOrder = blockOrder; }

    public String getTextContent() { return textContent; }
    public void setTextContent(String textContent) { this.textContent = textContent; }

    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }

    @Override
    public String toString() {
        return "ContentBlock{" +
               "blockId=" + blockId +
               ", reviewId=" + reviewId +
               ", blockType='" + blockType + '\'' +
               ", blockOrder=" + blockOrder +
               ", textContent='" + textContent + '\'' +
               ", imageUrl='" + imageUrl + '\'' +
               ", createdAt=" + createdAt +
               ", updatedAt=" + updatedAt +
               '}';
    }
}