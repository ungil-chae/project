package dto;

import java.util.List;
import model.Review;
import model.ContentBlock;

/**
 * 리뷰 상세 데이터를 담는 DTO
 * Review 엔티티와 ContentBlock 리스트를 함께 전달합니다.
 */
public class ReviewResponse {
    private Review review;
    private List<ContentBlock> contentBlocks;

    public ReviewResponse() {
    }

    public ReviewResponse(Review review, List<ContentBlock> contentBlocks) {
        this.review = review;
        this.contentBlocks = contentBlocks;
    }

    public Review getReview() {
        return review;
    }

    public void setReview(Review review) {
        this.review = review;
    }

    public List<ContentBlock> getContentBlocks() {
        return contentBlocks;
    }

    public void setContentBlocks(List<ContentBlock> contentBlocks) {
        this.contentBlocks = contentBlocks;
    }

    @Override
    public String toString() {
        return "ReviewResponse{" +
                "review=" + review +
                ", contentBlocks=" + contentBlocks +
                '}';
    }
}
