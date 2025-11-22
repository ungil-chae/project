package com.greenart.bdproject.dao;

import java.util.List;
import com.greenart.bdproject.dto.FaqDto;

public interface FaqDao {

    /**
     * FAQ 등록
     * @param faq FAQ 정보
     * @return int 등록된 행 수
     */
    int insert(FaqDto faq);

    /**
     * ID로 FAQ 조회
     * @param faqId FAQ ID
     * @return FaqDto FAQ 정보
     */
    FaqDto selectById(Long faqId);

    /**
     * 전체 FAQ 목록 조회
     * @return List<FaqDto> FAQ 목록
     */
    List<FaqDto> selectAll();

    /**
     * 카테고리별 FAQ 조회
     * @param category 카테고리
     * @return List<FaqDto> FAQ 목록
     */
    List<FaqDto> selectByCategory(String category);

    /**
     * FAQ 수정
     * @param faq 수정할 FAQ 정보
     * @return int 수정된 행 수
     */
    int update(FaqDto faq);

    /**
     * FAQ 삭제
     * @param faqId FAQ ID
     * @return int 삭제된 행 수
     */
    int deleteById(Long faqId);

    /**
     * FAQ 검색 (질문 + 답변)
     * @param keyword 검색 키워드
     * @return List<FaqDto> 검색 결과
     */
    List<FaqDto> searchFaqs(String keyword);

    /**
     * FAQ 검색 with 카테고리 필터
     * @param keyword 검색 키워드
     * @param category 카테고리
     * @return List<FaqDto> 검색 결과
     */
    List<FaqDto> searchFaqsByCategory(String keyword, String category);
}
