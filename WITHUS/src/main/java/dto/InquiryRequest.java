package dto;

public class InquiryRequest {
    private String inquiryType;
    private String title;
    private String content;

    public InquiryRequest() {}

    public InquiryRequest(String inquiryType, String title, String content) {
        this.inquiryType = inquiryType;
        this.title = title;
        this.content = content;
    }

    // Getter 및 Setter 메서드
    public String getInquiryType() { return inquiryType; }
    public void setInquiryType(String inquiryType) { this.inquiryType = inquiryType; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    @Override
    public String toString() {
        return "InquiryRequest{" +
               "inquiryType='" + inquiryType + '\'' +
               ", title='" + title + '\'' +
               '}';
    }
}