package com.greenart.bdproject.service;

import com.greenart.bdproject.dao.CalendarEventDao;
import com.greenart.bdproject.dto.CalendarEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.sql.Date;
import java.util.List;

/**
 * 캘린더 일정 서비스 구현체
 */
@Service
public class CalendarEventServiceImpl implements CalendarEventService {

    private static final Logger logger = LoggerFactory.getLogger(CalendarEventServiceImpl.class);

    @Autowired
    private CalendarEventDao calendarEventDao;

    @Override
    public Long createEvent(CalendarEvent event) {
        try {
            logger.info("일정 생성 요청 - title: {}, memberId: {}", event.getTitle(), event.getMemberId());
            return calendarEventDao.insert(event);
        } catch (Exception e) {
            logger.error("일정 생성 중 오류", e);
            return null;
        }
    }

    @Override
    public boolean updateEvent(CalendarEvent event) {
        try {
            logger.info("일정 수정 요청 - eventId: {}", event.getEventId());
            return calendarEventDao.update(event) > 0;
        } catch (Exception e) {
            logger.error("일정 수정 중 오류", e);
            return false;
        }
    }

    @Override
    public boolean deleteEvent(Long eventId) {
        try {
            logger.info("일정 삭제 요청 - eventId: {}", eventId);
            return calendarEventDao.delete(eventId) > 0;
        } catch (Exception e) {
            logger.error("일정 삭제 중 오류", e);
            return false;
        }
    }

    @Override
    public CalendarEvent getEventById(Long eventId) {
        try {
            return calendarEventDao.selectById(eventId);
        } catch (Exception e) {
            logger.error("일정 조회 중 오류", e);
            return null;
        }
    }

    @Override
    public List<CalendarEvent> getEventsByMemberId(Long memberId) {
        try {
            logger.info("회원 일정 조회 요청 - memberId: {}", memberId);
            return calendarEventDao.selectByMemberId(memberId);
        } catch (Exception e) {
            logger.error("회원 일정 조회 중 오류", e);
            return List.of();
        }
    }

    @Override
    public List<CalendarEvent> getEventsByMemberIdAndDate(Long memberId, Date eventDate) {
        try {
            return calendarEventDao.selectByMemberIdAndDate(memberId, eventDate);
        } catch (Exception e) {
            logger.error("특정 날짜 일정 조회 중 오류", e);
            return List.of();
        }
    }

    @Override
    public List<CalendarEvent> getEventsByMemberIdAndDateRange(Long memberId, Date startDate, Date endDate) {
        try {
            logger.info("날짜 범위 일정 조회 - memberId: {}, startDate: {}, endDate: {}",
                    new Object[]{memberId, startDate, endDate});
            return calendarEventDao.selectByMemberIdAndDateRange(memberId, startDate, endDate);
        } catch (Exception e) {
            logger.error("날짜 범위 일정 조회 중 오류", e);
            return List.of();
        }
    }

    @Override
    public boolean updateEventStatus(Long eventId, String status) {
        try {
            logger.info("일정 상태 변경 요청 - eventId: {}, status: {}", eventId, status);
            return calendarEventDao.updateStatus(eventId, status) > 0;
        } catch (Exception e) {
            logger.error("일정 상태 변경 중 오류", e);
            return false;
        }
    }

    @Override
    public int deleteAllEventsByMemberId(Long memberId) {
        try {
            logger.info("회원의 모든 일정 삭제 요청 - memberId: {}", memberId);
            return calendarEventDao.deleteAllByMemberId(memberId);
        } catch (Exception e) {
            logger.error("회원의 모든 일정 삭제 중 오류", e);
            return 0;
        }
    }
}
