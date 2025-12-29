package com.greenart.bdproject.dao;

import com.greenart.bdproject.dto.CalendarEvent;
import java.sql.Date;
import java.util.List;

/**
 * 캘린더 일정 DAO 인터페이스
 */
public interface CalendarEventDao {

    /**
     * 일정 생성
     */
    Long insert(CalendarEvent event);

    /**
     * 일정 수정
     */
    int update(CalendarEvent event);

    /**
     * 일정 삭제
     */
    int delete(Long eventId);

    /**
     * 일정 조회 (ID)
     */
    CalendarEvent selectById(Long eventId);

    /**
     * 회원의 모든 일정 조회
     */
    List<CalendarEvent> selectByMemberId(Long memberId);

    /**
     * 회원의 특정 날짜 일정 조회
     */
    List<CalendarEvent> selectByMemberIdAndDate(Long memberId, Date eventDate);

    /**
     * 회원의 날짜 범위 일정 조회
     */
    List<CalendarEvent> selectByMemberIdAndDateRange(Long memberId, Date startDate, Date endDate);

    /**
     * 일정 상태 변경
     */
    int updateStatus(Long eventId, String status);

    /**
     * 회원의 모든 일정 삭제
     */
    int deleteAllByMemberId(Long memberId);
}
