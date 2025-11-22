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
                    "(member_id, type, title, content, related_id, related_url, is_read) " +
                    "SELECT member_id, ?, ?, ?, ?, ?, false " +
                    "FROM member WHERE email = ?";

            pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, notification.getType());
            pstmt.setString(2, notification.getTitle());
            pstmt.setString(3, notification.getContent());
            pstmt.setObject(4, notification.getRelatedId());
            pstmt.setString(5, notification.getRelatedUrl());
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
            String sql = "SELECT n.notification_id, n.member_id, n.type, n.title, n.content, " +
                    "n.related_id, n.related_url, n.is_read, n.read_at, n.created_at, " +
                    "m.email " +
                    "FROM notifications n " +
                    "JOIN member m ON n.member_id = m.member_id " +
                    "WHERE m.email = ? " +
                    "ORDER BY n.created_at DESC";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);  // userId는 email

            rs = pstmt.executeQuery();

            while (rs.next()) {
                Notification notification = new Notification();
                notification.setNotificationId(rs.getLong("notification_id"));
                notification.setMemberId(rs.getLong("member_id"));
                notification.setUserId(rs.getString("email"));  // 호환성을 위해 email을 userId로 설정
                notification.setType(rs.getString("type"));
                notification.setTitle(rs.getString("title"));
                notification.setContent(rs.getString("content"));
                notification.setRelatedId(rs.getObject("related_id", Long.class));
                notification.setRelatedUrl(rs.getString("related_url"));
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

            String sql = "DELETE FROM notifications WHERE notification_id = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, notificationId);

            int result = pstmt.executeUpdate();

            logger.info("알림 삭제 - ID: {}, result: {}", notificationId, result);
            return result > 0;

        } catch (Exception e) {
            logger.error("알림 삭제 중 오류", e);
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
            String sql = "SELECT COUNT(*) " +
                    "FROM notifications n " +
                    "JOIN member m ON n.member_id = m.member_id " +
                    "WHERE m.email = ? AND n.is_read = false";

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
