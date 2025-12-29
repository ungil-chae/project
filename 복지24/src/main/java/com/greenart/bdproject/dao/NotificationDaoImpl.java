package com.greenart.bdproject.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.greenart.bdproject.dto.Notification;

/**
 * 알림 DAO 구현체
 */
@Repository
public class NotificationDaoImpl implements NotificationDao {

    private static final Logger logger = LoggerFactory.getLogger(NotificationDaoImpl.class);

    @Autowired
    private DataSource dataSource;

    @Override
    public Long create(Notification notification) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = dataSource.getConnection();

            // 새 스키마: member_id (BIGINT)를 사용
            // userId는 email이므로, member_id를 찾아서 저장해야 함
            String sql = "INSERT INTO notifications " +
                    "(member_id, notification_type, title, message, related_id, event_date, is_read) " +
                    "SELECT member_id, ?, ?, ?, ?, ?, false " +
                    "FROM member WHERE email = ?";

            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, notification.getType());
            pstmt.setString(2, notification.getTitle());
            pstmt.setString(3, notification.getContent());
            pstmt.setObject(4, notification.getRelatedId());
            pstmt.setDate(5, notification.getEventDate());  // event_date 추가
            pstmt.setString(6, notification.getUserId());  // email

            int result = pstmt.executeUpdate();

            if (result > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    Long id = rs.getLong(1);
                    logger.info("알림 생성 성공 - ID: {}", id);
                    return id;
                }
            }

        } catch (Exception e) {
            logger.error("알림 생성 중 오류", e);
        } finally {
            close(rs, pstmt, con);
        }

        return null;
    }

    @Override
    public List<Notification> findByUserId(String userId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        List<Notification> notifications = new ArrayList<>();

        try {
            con = dataSource.getConnection();

            // 새 스키마: member_id (BIGINT), email로 회원 식별
            // event_date가 NULL이거나 오늘 이전/당일인 알림만 조회
            // 소프트 삭제되지 않은 알림만 조회
            String sql = "SELECT n.notification_id, n.member_id, n.notification_type, n.title, n.message, " +
                    "n.related_id, n.event_date, n.is_read, n.read_at, n.created_at, " +
                    "m.email " +
                    "FROM notifications n " +
                    "JOIN member m ON n.member_id = m.member_id " +
                    "WHERE m.email = ? " +
                    "AND (n.event_date IS NULL OR n.event_date <= CURDATE()) " +
                    "AND n.deleted_at IS NULL " +
                    "ORDER BY n.created_at DESC";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);  // userId는 email

            rs = pstmt.executeQuery();

            while (rs.next()) {
                Notification notification = new Notification();
                notification.setNotificationId(rs.getLong("notification_id"));
                notification.setMemberId(rs.getLong("member_id"));
                notification.setUserId(rs.getString("email"));  // 호환성을 위해 email을 userId로 설정
                notification.setType(rs.getString("notification_type"));
                notification.setTitle(rs.getString("title"));
                notification.setContent(rs.getString("message"));
                notification.setRelatedId(rs.getObject("related_id", Long.class));
                notification.setEventDate(rs.getDate("event_date"));  // event_date 조회
                notification.setRead(rs.getBoolean("is_read"));
                notification.setReadAt(rs.getTimestamp("read_at"));
                notification.setCreatedAt(rs.getTimestamp("created_at"));

                notifications.add(notification);
            }

            logger.info("사용자 알림 조회 성공 - userId: {}, count: {}", userId, notifications.size());

        } catch (Exception e) {
            logger.error("알림 조회 중 오류", e);
        } finally {
            close(rs, pstmt, con);
        }

        return notifications;
    }

    @Override
    public boolean markAsRead(Long notificationId) {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dataSource.getConnection();

            // 새 스키마: read_at 컬럼도 업데이트
            String sql = "UPDATE notifications SET is_read = true, read_at = NOW() WHERE notification_id = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, notificationId);

            int result = pstmt.executeUpdate();

            logger.info("알림 읽음 처리 - ID: {}, result: {}", notificationId, result);
            return result > 0;

        } catch (Exception e) {
            logger.error("알림 읽음 처리 중 오류", e);
        } finally {
            close(null, pstmt, con);
        }

        return false;
    }

    @Override
    public boolean markAllAsRead(String userId) {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dataSource.getConnection();

            // 새 스키마: member_id 기반, email로 회원 식별
            String sql = "UPDATE notifications n " +
                    "JOIN member m ON n.member_id = m.member_id " +
                    "SET n.is_read = true, n.read_at = NOW() " +
                    "WHERE m.email = ? AND n.is_read = false";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);  // userId는 email

            int result = pstmt.executeUpdate();

            logger.info("모든 알림 읽음 처리 - userId: {}, count: {}", userId, result);
            return true;

        } catch (Exception e) {
            logger.error("모든 알림 읽음 처리 중 오류", e);
        } finally {
            close(null, pstmt, con);
        }

        return false;
    }

    @Override
    public boolean delete(Long notificationId) {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dataSource.getConnection();

            // 소프트 삭제: deleted_at을 현재 시간으로 설정
            String sql = "UPDATE notifications SET deleted_at = NOW() WHERE notification_id = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, notificationId);

            int result = pstmt.executeUpdate();

            logger.info("알림 소프트 삭제 - ID: {}, result: {}", notificationId, result);
            return result > 0;

        } catch (Exception e) {
            logger.error("알림 삭제 중 오류", e);
        } finally {
            close(null, pstmt, con);
        }

        return false;
    }

    @Override
    public boolean deleteAll(String userId) {
        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dataSource.getConnection();

            // 소프트 삭제: deleted_at을 현재 시간으로 설정
            String sql = "UPDATE notifications SET deleted_at = NOW() " +
                        "WHERE member_id = (SELECT member_id FROM member WHERE email = ?) " +
                        "AND deleted_at IS NULL";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);

            int result = pstmt.executeUpdate();

            logger.info("모든 알림 소프트 삭제 - userId: {}, count: {}", userId, result);
            return true;

        } catch (Exception e) {
            logger.error("모든 알림 삭제 중 오류", e);
        } finally {
            close(null, pstmt, con);
        }

        return false;
    }

    @Override
    public int countUnread(String userId) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = dataSource.getConnection();

            // 새 스키마: member_id 기반, email로 회원 식별
            // event_date가 NULL이거나 오늘 이전/당일인 알림만 카운트
            // 소프트 삭제되지 않은 알림만 카운트
            String sql = "SELECT COUNT(*) " +
                    "FROM notifications n " +
                    "JOIN member m ON n.member_id = m.member_id " +
                    "WHERE m.email = ? AND n.is_read = false " +
                    "AND (n.event_date IS NULL OR n.event_date <= CURDATE()) " +
                    "AND n.deleted_at IS NULL";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);  // userId는 email

            rs = pstmt.executeQuery();

            if (rs.next()) {
                int count = rs.getInt(1);
                logger.info("읽지 않은 알림 개수 - userId: {}, count: {}", userId, count);
                return count;
            }

        } catch (Exception e) {
            logger.error("읽지 않은 알림 개수 조회 중 오류", e);
        } finally {
            close(rs, pstmt, con);
        }

        return 0;
    }

    @Override
    public boolean existsByUserAndEventDate(String userId, String type, java.sql.Date eventDate, String title) {
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = dataSource.getConnection();

            // 같은 사용자, 같은 타입, 같은 이벤트 날짜, 같은 제목의 알림이 있는지 확인
            String sql = "SELECT COUNT(*) FROM notifications n " +
                    "JOIN member m ON n.member_id = m.member_id " +
                    "WHERE m.email = ? AND n.notification_type = ? AND n.event_date = ? AND n.title = ? " +
                    "AND n.deleted_at IS NULL";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, type);
            pstmt.setDate(3, eventDate);
            pstmt.setString(4, title);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                int count = rs.getInt(1);
                boolean exists = count > 0;
                logger.info("중복 알림 체크 - userId: {}, type: {}, eventDate: {}, exists: {}",
                           new Object[]{userId, type, eventDate, exists});
                return exists;
            }

        } catch (Exception e) {
            logger.error("중복 알림 체크 중 오류", e);
        } finally {
            close(rs, pstmt, con);
        }

        return false;
    }

    @Override
    public int deleteByUserIdAndTypes(String userId, java.util.List<String> notificationTypes) {
        if (notificationTypes == null || notificationTypes.isEmpty()) {
            return 0;
        }

        Connection con = null;
        PreparedStatement pstmt = null;

        try {
            con = dataSource.getConnection();

            // IN 절을 위한 ? 생성
            StringBuilder placeholders = new StringBuilder();
            for (int i = 0; i < notificationTypes.size(); i++) {
                if (i > 0) placeholders.append(", ");
                placeholders.append("?");
            }

            String sql = "UPDATE notifications n " +
                    "JOIN member m ON n.member_id = m.member_id " +
                    "SET n.deleted_at = NOW() " +
                    "WHERE m.email = ? AND n.notification_type IN (" + placeholders.toString() + ") " +
                    "AND n.deleted_at IS NULL";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);

            // 타입 파라미터 설정
            for (int i = 0; i < notificationTypes.size(); i++) {
                pstmt.setString(i + 2, notificationTypes.get(i));
            }

            int result = pstmt.executeUpdate();
            logger.info("타입별 알림 삭제 완료 - userId: {}, types: {}, count: {}",
                       new Object[]{userId, notificationTypes, result});
            return result;

        } catch (Exception e) {
            logger.error("타입별 알림 삭제 중 오류", e);
        } finally {
            close(null, pstmt, con);
        }

        return 0;
    }

    // 자원 해제
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
