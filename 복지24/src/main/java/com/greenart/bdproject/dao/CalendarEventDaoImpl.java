package com.greenart.bdproject.dao;

import com.greenart.bdproject.dto.CalendarEvent;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import javax.sql.DataSource;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

/**
 * 캘린더 일정 DAO 구현체
 */
@Repository
public class CalendarEventDaoImpl implements CalendarEventDao {

    private static final Logger logger = LoggerFactory.getLogger(CalendarEventDaoImpl.class);

    @Autowired
    private DataSource dataSource;

    @Override
    public Long insert(CalendarEvent event) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = dataSource.getConnection();

            String sql = "INSERT INTO calendar_events " +
                    "(member_id, title, description, event_date, event_time, event_type, " +
                    "reminder_enabled, remind_before_days, status) " +
                    "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";

            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setLong(1, event.getMemberId());
            pstmt.setString(2, event.getTitle());
            pstmt.setString(3, event.getDescription());
            pstmt.setDate(4, event.getEventDate());
            pstmt.setTime(5, event.getEventTime());
            pstmt.setString(6, event.getEventType());
            pstmt.setBoolean(7, event.getReminderEnabled());
            pstmt.setInt(8, event.getRemindBeforeDays());
            pstmt.setString(9, event.getStatus());

            int result = pstmt.executeUpdate();

            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    Long eventId = rs.getLong(1);
                    logger.info("일정 생성 성공 - eventId: {}", eventId);
                    return eventId;
                }
            }

        } catch (Exception e) {
            logger.error("일정 생성 중 오류", e);
        } finally {
            close(rs, pstmt, con);
        }

        return null;
    }

    @Override
    public int update(CalendarEvent event) {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dataSource.getConnection();

            String sql = "UPDATE calendar_events SET " +
                    "title = ?, description = ?, event_date = ?, event_time = ?, " +
                    "event_type = ?, reminder_enabled = ?, remind_before_days = ?, status = ? " +
                    "WHERE event_id = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, event.getTitle());
            pstmt.setString(2, event.getDescription());
            pstmt.setDate(3, event.getEventDate());
            pstmt.setTime(4, event.getEventTime());
            pstmt.setString(5, event.getEventType());
            pstmt.setBoolean(6, event.getReminderEnabled());
            pstmt.setInt(7, event.getRemindBeforeDays());
            pstmt.setString(8, event.getStatus());
            pstmt.setLong(9, event.getEventId());

            int result = pstmt.executeUpdate();
            logger.info("일정 수정 - eventId: {}, result: {}", event.getEventId(), result);
            return result;

        } catch (Exception e) {
            logger.error("일정 수정 중 오류", e);
        } finally {
            close(null, pstmt, con);
        }

        return 0;
    }

    @Override
    public int delete(Long eventId) {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dataSource.getConnection();

            String sql = "DELETE FROM calendar_events WHERE event_id = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, eventId);

            int result = pstmt.executeUpdate();
            logger.info("일정 삭제 - eventId: {}, result: {}", eventId, result);
            return result;

        } catch (Exception e) {
            logger.error("일정 삭제 중 오류", e);
        } finally {
            close(null, pstmt, con);
        }

        return 0;
    }

    @Override
    public CalendarEvent selectById(Long eventId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = dataSource.getConnection();

            String sql = "SELECT * FROM calendar_events WHERE event_id = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, eventId);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                return mapResultSetToEvent(rs);
            }

        } catch (Exception e) {
            logger.error("일정 조회 중 오류", e);
        } finally {
            close(rs, pstmt, con);
        }

        return null;
    }

    @Override
    public List<CalendarEvent> selectByMemberId(Long memberId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<CalendarEvent> events = new ArrayList<>();

        try {
            con = dataSource.getConnection();

            String sql = "SELECT * FROM calendar_events WHERE member_id = ? ORDER BY event_date ASC";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, memberId);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }

            logger.info("회원 일정 조회 - memberId: {}, count: {}", memberId, events.size());

        } catch (Exception e) {
            logger.error("회원 일정 조회 중 오류", e);
        } finally {
            close(rs, pstmt, con);
        }

        return events;
    }

    @Override
    public List<CalendarEvent> selectByMemberIdAndDate(Long memberId, Date eventDate) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<CalendarEvent> events = new ArrayList<>();

        try {
            con = dataSource.getConnection();

            String sql = "SELECT * FROM calendar_events WHERE member_id = ? AND event_date = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, memberId);
            pstmt.setDate(2, eventDate);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }

        } catch (Exception e) {
            logger.error("특정 날짜 일정 조회 중 오류", e);
        } finally {
            close(rs, pstmt, con);
        }

        return events;
    }

    @Override
    public List<CalendarEvent> selectByMemberIdAndDateRange(Long memberId, Date startDate, Date endDate) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<CalendarEvent> events = new ArrayList<>();

        try {
            con = dataSource.getConnection();

            String sql = "SELECT * FROM calendar_events " +
                    "WHERE member_id = ? AND event_date BETWEEN ? AND ? " +
                    "ORDER BY event_date ASC";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, memberId);
            pstmt.setDate(2, startDate);
            pstmt.setDate(3, endDate);

            rs = pstmt.executeQuery();

            while (rs.next()) {
                events.add(mapResultSetToEvent(rs));
            }

        } catch (Exception e) {
            logger.error("날짜 범위 일정 조회 중 오류", e);
        } finally {
            close(rs, pstmt, con);
        }

        return events;
    }

    @Override
    public int updateStatus(Long eventId, String status) {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dataSource.getConnection();

            String sql = "UPDATE calendar_events SET status = ? WHERE event_id = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, status);
            pstmt.setLong(2, eventId);

            int result = pstmt.executeUpdate();
            logger.info("일정 상태 변경 - eventId: {}, status: {}", eventId, status);
            return result;

        } catch (Exception e) {
            logger.error("일정 상태 변경 중 오류", e);
        } finally {
            close(null, pstmt, con);
        }

        return 0;
    }

    @Override
    public int deleteAllByMemberId(Long memberId) {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dataSource.getConnection();

            String sql = "DELETE FROM calendar_events WHERE member_id = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, memberId);

            int result = pstmt.executeUpdate();
            logger.info("회원의 모든 일정 삭제 - memberId: {}, count: {}", memberId, result);
            return result;

        } catch (Exception e) {
            logger.error("회원의 모든 일정 삭제 중 오류", e);
        } finally {
            close(null, pstmt, con);
        }

        return 0;
    }

    /**
     * ResultSet을 CalendarEvent 객체로 매핑
     */
    private CalendarEvent mapResultSetToEvent(ResultSet rs) throws SQLException {
        CalendarEvent event = new CalendarEvent();
        event.setEventId(rs.getLong("event_id"));
        event.setMemberId(rs.getLong("member_id"));
        event.setTitle(rs.getString("title"));
        event.setDescription(rs.getString("description"));

        // 날짜를 문자열로 가져온 후 다시 변환 (시간대 문제 방지)
        String dateStr = rs.getString("event_date");
        if (dateStr != null && !dateStr.isEmpty()) {
            event.setEventDate(java.sql.Date.valueOf(dateStr));
        }

        event.setEventTime(rs.getTime("event_time"));
        event.setEventType(rs.getString("event_type"));
        event.setReminderEnabled(rs.getBoolean("reminder_enabled"));
        event.setRemindBeforeDays(rs.getInt("remind_before_days"));
        event.setStatus(rs.getString("status"));
        event.setCreatedAt(rs.getTimestamp("created_at"));
        event.setUpdatedAt(rs.getTimestamp("updated_at"));
        return event;
    }

    /**
     * 자원 해제
     */
    private void close(AutoCloseable... resources) {
        for (AutoCloseable resource : resources) {
            if (resource != null) {
                try {
                    resource.close();
                } catch (Exception e) {
                    logger.error("Resource close error", e);
                }
            }
        }
    }
}
