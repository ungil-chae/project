package com.greenart.bdproject.service;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.greenart.bdproject.dao.FaqDao;
import com.greenart.bdproject.dto.FaqDto;
import com.greenart.bdproject.dto.SearchResultDto;

@Service
@Transactional
public class FaqService {

    @Autowired
    private FaqDao faqDao;

    /**
     * 전체 FAQ 조회
     * @return 전체 FAQ 리스트
     */
    public List<FaqDto> getAllFaqs() {
        return faqDao.selectAll();
    }

    /**
     * 활성화된 FAQ만 조회
     * @return 활성화된 FAQ 리스트
     */
    public List<FaqDto> getActiveFaqs() {
        return faqDao.selectActiveFaqs();
    }

    /**
     * 카테고리별 FAQ 조회
     * @param category 카테고리
     * @return 카테고리별 FAQ 리스트
     */
    public List<FaqDto> getFaqsByCategory(String category) {
        return faqDao.selectByCategory(category);
    }

    /**
     * FAQ ID로 조회
     * @param faqId FAQ ID
     * @return FAQ 정보
     */
    public FaqDto getFaqById(Long faqId) {
        return faqDao.selectById(faqId);
    }

    /**
     * FAQ 등록
     * @param faq FAQ 정보
     * @return 등록된 FAQ ID
     */
    public Long createFaq(FaqDto faq) {
        if (faq.getOrderNum() == null) {
            faq.setOrderNum(0);
        }
        if (faq.getIsActive() == null) {
            faq.setIsActive(true);
        }
        faqDao.insert(faq);
        return faq.getFaqId();
    }

    /**
     * FAQ 수정
     * @param faq FAQ 정보
     * @return 수정 성공 여부
     */
    public boolean updateFaq(FaqDto faq) {
        return faqDao.update(faq) > 0;
    }

    /**
     * FAQ 삭제
     * @param faqId FAQ ID
     * @return 삭제 성공 여부
     */
    public boolean deleteFaq(Long faqId) {
        return faqDao.deleteById(faqId) > 0;
    }

    /**
     * FAQ 검색 (고급 알고리즘 적용)
     * @param keyword 검색 키워드
     * @return 검색 결과 리스트 (점수 순 정렬)
     */
    public List<SearchResultDto> searchFaqs(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return new ArrayList<>();
        }

        String normalizedKeyword = keyword.trim().toLowerCase();
        List<FaqDto> faqs = faqDao.searchFaqs(normalizedKeyword);

        return faqs.stream()
                .map(faq -> enrichSearchResult(faq, normalizedKeyword))
                .filter(result -> result.getRelevanceScore() > 0)
                .sorted((a, b) -> Double.compare(b.getRelevanceScore(), a.getRelevanceScore()))
                .collect(Collectors.toList());
    }

    /**
     * 카테고리별 FAQ 검색
     * @param keyword 검색 키워드
     * @param category 카테고리
     * @return 검색 결과 리스트
     */
    public List<SearchResultDto> searchFaqsByCategory(String keyword, String category) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return new ArrayList<>();
        }

        String normalizedKeyword = keyword.trim().toLowerCase();
        List<FaqDto> faqs = faqDao.searchFaqsByCategory(normalizedKeyword, category);

        return faqs.stream()
                .map(faq -> enrichSearchResult(faq, normalizedKeyword))
                .filter(result -> result.getRelevanceScore() > 0)
                .sorted((a, b) -> Double.compare(b.getRelevanceScore(), a.getRelevanceScore()))
                .collect(Collectors.toList());
    }

    /**
     * 검색 결과에 점수, 하이라이팅 등 추가 정보 부여
     * @param faq FAQ 데이터
     * @param keyword 검색 키워드
     * @return SearchResultDto
     */
    private SearchResultDto enrichSearchResult(FaqDto faq, String keyword) {
        SearchResultDto result = new SearchResultDto(faq);

        // 1. 관련성 점수 계산
        double score = calculateRelevanceScore(faq, keyword);
        result.setRelevanceScore(score);

        // 2. 하이라이팅 적용
        String highlightedQuestion = highlightText(faq.getQuestion(), keyword);
        String highlightedAnswer = highlightText(faq.getAnswer(), keyword);
        result.setHighlightedQuestion(highlightedQuestion);
        result.setHighlightedAnswer(highlightedAnswer);

        // 3. 매칭된 단어 추출
        List<String> matchedTerms = extractMatchedTerms(faq, keyword);
        result.setMatchedTerms(matchedTerms);

        // 4. 매칭 타입 결정
        String matchType = determineMatchType(faq, keyword);
        result.setMatchType(matchType);

        return result;
    }

    /**
     * 관련성 점수 계산 (0.0 ~ 100.0)
     * TF-IDF 기반 스코어링
     */
    private double calculateRelevanceScore(FaqDto faq, String keyword) {
        double score = 0.0;

        String question = faq.getQuestion() != null ? faq.getQuestion().toLowerCase() : "";
        String answer = faq.getAnswer() != null ? faq.getAnswer().toLowerCase() : "";
        String category = faq.getCategory() != null ? faq.getCategory().toLowerCase() : "";

        // 1. 정확 매칭 (가장 높은 점수)
        if (question.equals(keyword)) {
            score += 50.0;
        } else if (question.contains(keyword)) {
            // 2. 질문에 포함 (위치에 따른 가중치)
            if (question.startsWith(keyword)) {
                score += 40.0; // 질문 시작 부분
            } else {
                score += 30.0; // 질문 중간
            }

            // 3. 빈도수 기반 점수 (여러 번 등장할수록 높음)
            int frequency = countOccurrences(question, keyword);
            score += Math.min(frequency * 5, 15); // 최대 15점
        }

        // 4. 답변에 포함
        if (answer.contains(keyword)) {
            int frequency = countOccurrences(answer, keyword);
            score += Math.min(10 + (frequency * 3), 20); // 최대 20점
        }

        // 5. 카테고리 매칭
        if (category.contains(keyword)) {
            score += 10.0;
        }

        // 6. 텍스트 길이 대비 키워드 밀도 (짧은 텍스트에서 매칭되면 더 관련성 높음)
        int totalLength = question.length() + answer.length();
        if (totalLength > 0) {
            double density = (double) keyword.length() / totalLength;
            score += density * 10; // 최대 10점
        }

        return Math.min(score, 100.0); // 최대 100점
    }

    /**
     * 텍스트에 하이라이팅 적용
     */
    private String highlightText(String text, String keyword) {
        if (text == null || keyword == null) {
            return text;
        }

        // 대소문자 무시 정규식으로 하이라이팅
        Pattern pattern = Pattern.compile(Pattern.quote(keyword), Pattern.CASE_INSENSITIVE);
        Matcher matcher = pattern.matcher(text);
        return matcher.replaceAll("<mark>$0</mark>");
    }

    /**
     * 매칭된 키워드 리스트 추출
     */
    private List<String> extractMatchedTerms(FaqDto faq, String keyword) {
        List<String> terms = new ArrayList<>();

        String question = faq.getQuestion() != null ? faq.getQuestion().toLowerCase() : "";
        String answer = faq.getAnswer() != null ? faq.getAnswer().toLowerCase() : "";

        // 공백 기준으로 키워드 분리
        String[] keywords = keyword.split("\\s+");

        for (String kw : keywords) {
            if (question.contains(kw) || answer.contains(kw)) {
                terms.add(kw);
            }
        }

        return terms.stream().distinct().collect(Collectors.toList());
    }

    /**
     * 매칭 타입 결정
     */
    private String determineMatchType(FaqDto faq, String keyword) {
        String question = faq.getQuestion() != null ? faq.getQuestion().toLowerCase() : "";

        if (question.equals(keyword)) {
            return "EXACT";
        } else if (question.contains(keyword)) {
            return "PARTIAL";
        } else {
            return "FUZZY";
        }
    }

    /**
     * 텍스트 내 키워드 출현 빈도 계산
     */
    private int countOccurrences(String text, String keyword) {
        if (text == null || keyword == null || keyword.isEmpty()) {
            return 0;
        }

        int count = 0;
        int index = 0;
        String lowerText = text.toLowerCase();
        String lowerKeyword = keyword.toLowerCase();

        while ((index = lowerText.indexOf(lowerKeyword, index)) != -1) {
            count++;
            index += lowerKeyword.length();
        }

        return count;
    }
}
