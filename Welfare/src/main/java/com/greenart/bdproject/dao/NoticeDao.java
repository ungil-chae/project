package com.greenart.bdproject.dao;

import java.util.List;
import com.greenart.bdproject.dto.NoticeDto;

public interface NoticeDao {

    /**
     * 공지사항 등록
     * @param notice 공지사항 정보
     * @return int 등록된 행 수
     */
    int insert(NoticeDto notice);

    /**
     * ID로 공지사항 조회
     * @param noticeId 공지사항 ID
     * @return NoticeDto 공지사항 정보
     */
    NoticeDto selectById(Long noticeId);

    /**
     * 전체 공지사항 목록 조회
     * @return List<NoticeDto> 공지사항 목록
     */
    List<NoticeDto> selectAll();

    /**
     * 상단 고정 공지사항 조회
     * @return List<NoticeDto> 고정 공지사항 목록
     */
    List<NoticeDto> selectPinned();

    /**
     * 공지사항 수정
     * @param notice 수정할 공지사항 정보
     * @return int 수정된 행 수
     */
    int update(NoticeDto notice);

    /**
     * 공지사항 삭제
     * @param noticeId 공지사항 ID
     * @return int 삭제된 행 수
     */
    int deleteById(Long noticeId);

    /**
     * 조회수 증가
     * @param noticeId 공지사항 ID
     * @return int 수정된 행 수
     */
    int incrementViews(Long noticeId);
}
