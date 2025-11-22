package dto;

import java.util.List;

/**
 * 리뷰 작성 폼 데이터를 담는 DTO
 */
public class ReviewRequest {
    private int rating;
    private String title;
    private String author;
    private String coverImageUrl;
    private String reviewText;
    private List<ContentBlockRequest> contentBlocks;
    private int userId;
    
    public ReviewRequest() {
    }

    public ReviewRequest(int rating, String title, String author,
                         String coverImageUrl, String reviewText,
                         List<ContentBlockRequest> contentBlocks) {
        this.rating = rating;
        this.title = title;
        this.author = author;
        this.coverImageUrl = coverImageUrl;
        this.reviewText = reviewText;
        this.contentBlocks = contentBlocks;
    }

    public int getRating() {
        return rating;
    }

    public void setRating(int rating) {
        this.rating = rating;
    }

    public String getTitle() {
        return title;
    }

    public void setTitle(String title) {
        this.title = title;
    }

    public String getAuthor() {
        return author;
    }

    public void setAuthor(String author) {
        this.author = author;
    }

    public String getCoverImageUrl() {
        return coverImageUrl;
    }

    public void setCoverImageUrl(String coverImageUrl) {
        this.coverImageUrl = coverImageUrl;
    }

    public String getReviewText() {
        return reviewText;
    }

    public void setReviewText(String reviewText) {
        this.reviewText = reviewText;
    }

    public List<ContentBlockRequest> getContentBlocks() {
        return contentBlocks;
    }

    public void setContentBlocks(List<ContentBlockRequest> contentBlocks) {
        this.contentBlocks = contentBlocks;
    }

    public int getUserId() {
        return userId;
    }
    
    public void setUserId(int userId) {
        this.userId = userId;
    }
    @Override
    public String toString() {
        return "ReviewRequest{" +
                "rating=" + rating +
                ", title='" + title + '\'' +
                ", author='" + author + '\'' +
                ", coverImageUrl='" + coverImageUrl + '\'' +
                ", reviewText='" + reviewText + '\'' +
                ", contentBlocks=" + contentBlocks +
                '}';
    }
}
