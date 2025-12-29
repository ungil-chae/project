package com.greenart.bdproject.controller;

import com.greenart.bdproject.dao.ProjectMemberDao;
import com.greenart.bdproject.dto.CalendarEvent;
import com.greenart.bdproject.dto.Member;
import com.greenart.bdproject.service.CalendarEventService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import javax.servlet.http.HttpSession;
import java.sql.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 캘린더 일정 API 컨트롤러
 * URL 패턴: /api/calendar/*
 */
@RestController
@RequestMapping("/api/calendar")
public class CalendarEventApiController {

    private static final Logger logger = LoggerFactory.getLogger(CalendarEventApiController.class);

    @Autowired
    private CalendarEventService calendarEventService;

    @Autowired
    private ProjectMemberDao memberDao;

    /**
     * 일정 생성
     * POST /api/calendar/events
     */
    @PostMapping("/events")
    public Map<String, Object> createEvent(@RequestBody CalendarEvent event, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            // 회원 정보 조회하여 member_id 가져오기
            Member member = memberDao.select(userId);
            if (member == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            event.setMemberId(member.getMemberId());

            // 일정 생성
            Long eventId = calendarEventService.createEvent(event);

            if (eventId != null) {
                event.setEventId(eventId);
                response.put("success", true);
                response.put("message", "일정이 저장되었습니다.");
                response.put("eventId", eventId);
                response.put("event", event);
                logger.info("일정 생성 성공 - userId: {}, eventId: {}", userId, eventId);
            } else {
                response.put("success", false);
                response.put("message", "일정 저장에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("일정 생성 중 오류", e);
            response.put("success", false);
            response.put("message", "일정 저장 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 일정 수정
     * PUT /api/calendar/events/{id}
     */
    @PutMapping("/events/{id}")
    public Map<String, Object> updateEvent(@PathVariable("id") Long eventId,
                                          @RequestBody CalendarEvent event,
                                          HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            event.setEventId(eventId);

            boolean result = calendarEventService.updateEvent(event);

            if (result) {
                response.put("success", true);
                response.put("message", "일정이 수정되었습니다.");
                logger.info("일정 수정 성공 - eventId: {}", eventId);
            } else {
                response.put("success", false);
                response.put("message", "일정 수정에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("일정 수정 중 오류", e);
            response.put("success", false);
            response.put("message", "일정 수정 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 일정 삭제
     * DELETE /api/calendar/events/{id}
     */
    @DeleteMapping("/events/{id}")
    public Map<String, Object> deleteEvent(@PathVariable("id") Long eventId, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            boolean result = calendarEventService.deleteEvent(eventId);

            if (result) {
                response.put("success", true);
                response.put("message", "일정이 삭제되었습니다.");
                logger.info("일정 삭제 성공 - eventId: {}", eventId);
            } else {
                response.put("success", false);
                response.put("message", "일정 삭제에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("일정 삭제 중 오류", e);
            response.put("success", false);
            response.put("message", "일정 삭제 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 회원의 모든 일정 조회
     * GET /api/calendar/events
     */
    @GetMapping("/events")
    public Map<String, Object> getEvents(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            Member member = memberDao.select(userId);
            if (member == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            List<CalendarEvent> events = calendarEventService.getEventsByMemberId(member.getMemberId());

            response.put("success", true);
            response.put("events", events);
            logger.info("일정 목록 조회 성공 - userId: {}, count: {}", userId, events.size());

        } catch (Exception e) {
            logger.error("일정 조회 중 오류", e);
            response.put("success", false);
            response.put("message", "일정 조회 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 특정 날짜의 일정 조회
     * GET /api/calendar/events/date/{date}
     */
    @GetMapping("/events/date/{date}")
    public Map<String, Object> getEventsByDate(@PathVariable("date") String dateStr, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            Member member = memberDao.select(userId);
            if (member == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            Date eventDate = Date.valueOf(dateStr);
            List<CalendarEvent> events = calendarEventService.getEventsByMemberIdAndDate(
                    member.getMemberId(), eventDate);

            response.put("success", true);
            response.put("events", events);

        } catch (Exception e) {
            logger.error("특정 날짜 일정 조회 중 오류", e);
            response.put("success", false);
            response.put("message", "일정 조회 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 날짜 범위의 일정 조회
     * GET /api/calendar/events/range?startDate=2025-01-01&endDate=2025-01-31
     */
    @GetMapping("/events/range")
    public Map<String, Object> getEventsByDateRange(
            @RequestParam("startDate") String startDateStr,
            @RequestParam("endDate") String endDateStr,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            Member member = memberDao.select(userId);
            if (member == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            Date startDate = Date.valueOf(startDateStr);
            Date endDate = Date.valueOf(endDateStr);

            List<CalendarEvent> events = calendarEventService.getEventsByMemberIdAndDateRange(
                    member.getMemberId(), startDate, endDate);

            response.put("success", true);
            response.put("events", events);

        } catch (Exception e) {
            logger.error("날짜 범위 일정 조회 중 오류", e);
            response.put("success", false);
            response.put("message", "일정 조회 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 일정 상태 변경
     * PATCH /api/calendar/events/{id}/status
     */
    @PatchMapping("/events/{id}/status")
    public Map<String, Object> updateEventStatus(
            @PathVariable("id") Long eventId,
            @RequestBody Map<String, String> requestData,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            String status = requestData.get("status");
            boolean result = calendarEventService.updateEventStatus(eventId, status);

            if (result) {
                response.put("success", true);
                response.put("message", "일정 상태가 변경되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "상태 변경에 실패했습니다.");
            }

        } catch (Exception e) {
            logger.error("일정 상태 변경 중 오류", e);
            response.put("success", false);
            response.put("message", "상태 변경 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }

    /**
     * 회원의 모든 일정 삭제
     * DELETE /api/calendar/events/all
     */
    @DeleteMapping("/events/all")
    public Map<String, Object> deleteAllEvents(HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            String userId = (String) session.getAttribute("id");
            if (userId == null || userId.isEmpty()) {
                response.put("success", false);
                response.put("message", "로그인이 필요합니다.");
                return response;
            }

            Member member = memberDao.select(userId);
            if (member == null) {
                response.put("success", false);
                response.put("message", "회원 정보를 찾을 수 없습니다.");
                return response;
            }

            int deletedCount = calendarEventService.deleteAllEventsByMemberId(member.getMemberId());

            response.put("success", true);
            response.put("message", deletedCount + "개의 일정이 삭제되었습니다.");
            response.put("deletedCount", deletedCount);
            logger.info("모든 일정 삭제 성공 - userId: {}, count: {}", userId, deletedCount);

        } catch (Exception e) {
            logger.error("모든 일정 삭제 중 오류", e);
            response.put("success", false);
            response.put("message", "일정 삭제 중 오류가 발생했습니다: " + e.getMessage());
        }

        return response;
    }
}
