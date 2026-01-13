package com.greenart.bdproject.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.greenart.bdproject.dto.FaqDto;

@Mapper
public interface FaqMapper {

    int insert(FaqDto faq);

    FaqDto selectById(@Param("faqId") Long faqId);

    List<FaqDto> selectAll();

    List<FaqDto> selectActiveFaqs();

    List<FaqDto> selectByCategory(@Param("category") String category);

    int update(FaqDto faq);

    int deleteById(@Param("faqId") Long faqId);

    List<FaqDto> searchFaqs(@Param("keyword") String keyword);

    List<FaqDto> searchFaqsByCategory(@Param("keyword") String keyword, @Param("category") String category);
}
