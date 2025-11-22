package dto;

import javax.servlet.http.Part;

/**
 * 리뷰 작성 폼에서 전송되는 각 콘텐츠 블록 요청 데이터를 담는 DTO
 */
public class ContentBlockRequest {
    private String blockType;
    private int blockOrder;
    private String imageUrl;

    // text 블록인 경우
    private String textContent;

    // image 블록인 경우 (파일 업로드)
    private Part imagePart;

    // book 블록인 경우
    private String bookTitle;
    private String bookAuthor;
    private String bookPublisher;
    private String bookPubDate; // yyyy-MM-dd 형식
    private String bookImageUrl;
    private String bookLink;

    public ContentBlockRequest() {
    }

    // 기본 생성자는 필요에 따라 오버로드해서 사용 가능합니다.

    public String getBlockType() {
        return blockType;
    }

    public void setBlockType(String blockType) {
        this.blockType = blockType;
    }

    public int getBlockOrder() {
        return blockOrder;
    }

    public void setBlockOrder(int blockOrder) {
        this.blockOrder = blockOrder;
    }

    public String getTextContent() {
        return textContent;
    }

    public void setTextContent(String textContent) {
        this.textContent = textContent;
    }

    public Part getImagePart() {
        return imagePart;
    }

    public void setImagePart(Part imagePart) {
        this.imagePart = imagePart;
    }

    public String getBookTitle() {
        return bookTitle;
    }

    public void setBookTitle(String bookTitle) {
        this.bookTitle = bookTitle;
    }

    public String getBookAuthor() {
        return bookAuthor;
    }

    public void setBookAuthor(String bookAuthor) {
        this.bookAuthor = bookAuthor;
    }

    public String getBookPublisher() {
        return bookPublisher;
    }

    public void setBookPublisher(String bookPublisher) {
        this.bookPublisher = bookPublisher;
    }

    public String getBookPubDate() {
        return bookPubDate;
    }

    public void setBookPubDate(String bookPubDate) {
        this.bookPubDate = bookPubDate;
    }

    public String getBookImageUrl() {
        return bookImageUrl;
    }

    public void setBookImageUrl(String bookImageUrl) {
        this.bookImageUrl = bookImageUrl;
    }

    public String getBookLink() {
        return bookLink;
    }

    public void setBookLink(String bookLink) {
        this.bookLink = bookLink;
    }
    
    public String getImageUrl() {
        return imageUrl;
    }

    public void setImageUrl(String imageUrl) {
        this.imageUrl = imageUrl;
    }

    @Override
    public String toString() {
        return "ContentBlockRequest{" +
                "blockType='" + blockType + '\'' +
                ", blockOrder=" + blockOrder +
                ", textContent='" + textContent + '\'' +
                ", imagePart=" + (imagePart != null ? imagePart.getSubmittedFileName() : "null") +
                ", bookTitle='" + bookTitle + '\'' +
                ", bookAuthor='" + bookAuthor + '\'' +
                ", bookPublisher='" + bookPublisher + '\'' +
                ", bookPubDate='" + bookPubDate + '\'' +
                ", bookImageUrl='" + bookImageUrl + '\'' +
                ", bookLink='" + bookLink + '\'' +
                '}';
    }
}
