package com.greenart.bdproject.dto;

import java.util.Date;
import java.util.List;

/**
 * 검색 결과 DTO
 * FAQ 검색 시 점수, 하이라이팅 정보를 포함
 */
public class SearchResultDto {
    private Long faqId;
    private String category;
    private String question;
    private String answer;
    private Integer orderNum;
    private Boolean isActive;
    private Date createdAt;
    private Date updatedAt;

    // 검색 관련 필드
    private Double relevanceScore;      // 관련성 점수 (0.0 ~ 100.0)
    private String highlightedQuestion; // 하이라이트된 질문
    private String highlightedAnswer;   // 하이라이트된 답변
    private List<String> matchedTerms;  // 매칭된 검색어 리스트
    private String matchType;           // 매칭 타입 (EXACT, PARTIAL, FUZZY)

    public SearchResultDto() {
    }

    public SearchResultDto(FaqDto faq) {
        this.faqId = faq.getFaqId();
        this.category = faq.getCategory();
        this.question = faq.getQuestion();
        this.answer = faq.getAnswer();
        this.orderNum = faq.getOrderNum();
        this.isActive = faq.getIsActive();
        this.createdAt = faq.getCreatedAt();
        this.updatedAt = faq.getUpdatedAt();
        this.relevanceScore = 0.0;
    }

    // Getters and Setters
    public Long getFaqId() {
        return faqId;
    }

    public void setFaqId(Long faqId) {
        this.faqId = faqId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public String getQuestion() {
        return question;
    }

    public void setQuestion(String question) {
        this.question = question;
    }

    public String getAnswer() {
        return answer;
    }

    public void setAnswer(String answer) {
        this.answer = answer;
    }

    public Integer getOrderNum() {
        return orderNum;
    }

    public void setOrderNum(Integer orderNum) {
        this.orderNum = orderNum;
    }

    public Boolean getIsActive() {
        return isActive;
    }

    public void setIsActive(Boolean isActive) {
        this.isActive = isActive;
    }

    public Date getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Date createdAt) {
        this.createdAt = createdAt;
    }

    public Date getUpdatedAt() {
        return updatedAt;
    }

    public void setUpdatedAt(Date updatedAt) {
        this.updatedAt = updatedAt;
    }

    public Double getRelevanceScore() {
        return relevanceScore;
    }

    public void setRelevanceScore(Double relevanceScore) {
        this.relevanceScore = relevanceScore;
    }

    public String getHighlightedQuestion() {
        return highlightedQuestion;
    }

    public void setHighlightedQuestion(String highlightedQuestion) {
        this.highlightedQuestion = highlightedQuestion;
    }

    public String getHighlightedAnswer() {
        return highlightedAnswer;
    }

    public void setHighlightedAnswer(String highlightedAnswer) {
        this.highlightedAnswer = highlightedAnswer;
    }

    public List<String> getMatchedTerms() {
        return matchedTerms;
    }

    public void setMatchedTerms(List<String> matchedTerms) {
        this.matchedTerms = matchedTerms;
    }

    public String getMatchType() {
        return matchType;
    }

    public void setMatchType(String matchType) {
        this.matchType = matchType;
    }

    @Override
    public String toString() {
        return "SearchResultDto{" +
                "faqId=" + faqId +
                ", question='" + question + '\'' +
                ", relevanceScore=" + relevanceScore +
                ", matchType='" + matchType + '\'' +
                '}';
    }
}
