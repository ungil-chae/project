package com.greenart.bdproject.service;

import com.greenart.bdproject.dto.CalendarEvent;
import java.sql.Date;
import java.util.List;

/**
 * 캘린더 일정 서비스 인터페이스
 */
public interface CalendarEventService {

    /**
     * 일정 생성
     */
    Long createEvent(CalendarEvent event);

    /**
     * 일정 수정
     */
    boolean updateEvent(CalendarEvent event);

    /**
     * 일정 삭제
     */
    boolean deleteEvent(Long eventId);

    /**
     * 일정 조회 (ID)
     */
    CalendarEvent getEventById(Long eventId);

    /**
     * 회원의 모든 일정 조회
     */
    List<CalendarEvent> getEventsByMemberId(Long memberId);

    /**
     * 회원의 특정 날짜 일정 조회
     */
    List<CalendarEvent> getEventsByMemberIdAndDate(Long memberId, Date eventDate);

    /**
     * 회원의 날짜 범위 일정 조회
     */
    List<CalendarEvent> getEventsByMemberIdAndDateRange(Long memberId, Date startDate, Date endDate);

    /**
     * 일정 상태 변경
     */
    boolean updateEventStatus(Long eventId, String status);

    /**
     * 회원의 모든 일정 삭제
     */
    int deleteAllEventsByMemberId(Long memberId);
}
