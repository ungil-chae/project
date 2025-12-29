package com.greenart.bdproject.service;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.time.LocalDate;
import java.util.List;

import javax.sql.DataSource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.greenart.bdproject.dao.NotificationDao;
import com.greenart.bdproject.dao.NotificationSettingsDao;
import com.greenart.bdproject.dto.Notification;
import com.greenart.bdproject.dto.NotificationSettings;

/**
 * 알림 서비스 구현체
 */
@Service
public class NotificationServiceImpl implements NotificationService {

    private static final Logger logger = LoggerFactory.getLogger(NotificationServiceImpl.class);

    @Autowired
    private NotificationDao notificationDao;

    @Autowired
    private DataSource dataSource;

    @Autowired(required = false)
    private NotificationSettingsDao notificationSettingsDao;

    @Override
    public Long createNotification(Notification notification) {
        if (notification == null || notification.getUserId() == null) {
            logger.warn("알림 생성 실패 - notification 또는 userId가 없음");
            return null;
        }

        // 알림 설정 확인
        Long memberId = getMemberIdByUserId(notification.getUserId());
        if (memberId != null) {
            // 알림 타입을 설정 체크용 타입으로 변환
            String notificationType = getNotificationTypeForSetting(notification.getType());

            if (!isNotificationEnabled(memberId, notificationType)) {
                logger.info("알림이 비활성화되어 있어 생성하지 않음 - userId: {}, type: {}",
                           notification.getUserId(), notification.getType());
                return null;
            }
        }

        return notificationDao.create(notification);
    }

    /**
     * 알림 타입을 설정 확인용 타입으로 변환
     * @param type 알림 타입 (CALENDAR_EVENT, DONATION, VOLUNTEER, faq_answer 등)
     * @return 설정 타입 (event, donation, volunteer, faqAnswer)
     */
    private String getNotificationTypeForSetting(String type) {
        if (type == null) {
            return "unknown";
        }

        String lowerType = type.toLowerCase();

        // 캘린더/일정 알림
        if (lowerType.contains("calendar") || lowerType.contains("event") || lowerType.contains("schedule")) {
            return "calendar";
        }

        // 기부 알림
        if (lowerType.contains("donation")) {
            return "donation";
        }

        // 봉사 알림
        if (lowerType.contains("volunteer")) {
            return "volunteer";
        }

        // FAQ 알림
        if (lowerType.contains("faq") || lowerType.contains("answer") || lowerType.contains("question")) {
            return "faq";
        }

        return "unknown";
    }

    @Override
    public List<Notification> getNotificationsByUserId(String userId) {
        List<Notification> allNotifications = notificationDao.findByUserId(userId);

        // 알림 설정에 따라 필터링
        Long memberId = getMemberIdByUserId(userId);
        if (memberId == null || notificationSettingsDao == null) {
            return allNotifications;
        }

        try {
            NotificationSettings settings = notificationSettingsDao.selectByMemberId(memberId);

            // 설정이 없으면 모든 알림 반환 (기본값: 모두 활성화)
            if (settings == null) {
                return allNotifications;
            }

            // 설정에 따라 알림 필터링
            List<Notification> filteredNotifications = new java.util.ArrayList<>();
            for (Notification notification : allNotifications) {
                String notificationType = getNotificationTypeForSetting(notification.getType());

                boolean shouldShow = false;
                switch (notificationType) {
                    case "calendar":
                        // null이면 기본값 true (알림 표시)
                        shouldShow = settings.getEventNotification() == null || settings.getEventNotification();
                        break;
                    case "donation":
                        shouldShow = settings.getDonationNotification() == null || settings.getDonationNotification();
                        break;
                    case "volunteer":
                        shouldShow = settings.getVolunteerNotification() == null || settings.getVolunteerNotification();
                        break;
                    case "faq":
                        shouldShow = settings.getFaqAnswerNotification() == null || settings.getFaqAnswerNotification();
                        break;
                    default:
                        // 알 수 없는 타입은 표시
                        shouldShow = true;
                        break;
                }

                if (shouldShow) {
                    filteredNotifications.add(notification);
                } else {
                    logger.debug("알림 설정에 의해 필터링됨 - notificationId: {}, type: {}",
                                notification.getNotificationId(), notification.getType());
                }
            }

            logger.info("알림 필터링 완료 - 전체: {}, 필터링 후: {}",
                       allNotifications.size(), filteredNotifications.size());
            return filteredNotifications;

        } catch (Exception e) {
            logger.error("알림 필터링 중 오류 발생", e);
            return allNotifications; // 오류 시 전체 알림 반환
        }
    }

    @Override
    public boolean markNotificationAsRead(Long notificationId) {
        return notificationDao.markAsRead(notificationId);
    }

    @Override
    public boolean markAllNotificationsAsRead(String userId) {
        return notificationDao.markAllAsRead(userId);
    }

    @Override
    public boolean deleteNotification(Long notificationId) {
        return notificationDao.delete(notificationId);
    }

    @Override
    public boolean deleteAllNotifications(String userId) {
        return notificationDao.deleteAll(userId);
    }

    @Override
    public int getUnreadCount(String userId) {
        return notificationDao.countUnread(userId);
    }

    @Override
    public Long createFaqAnswerNotification(String userId, Long questionId, String questionTitle) {
        if (userId == null || userId.isEmpty()) {
            logger.warn("FAQ 답변 알림 생성 실패 - userId가 없음");
            return null;
        }

        // 알림 설정 확인
        Long memberId = getMemberIdByUserId(userId);
        if (memberId != null && !isNotificationEnabled(memberId, "faqAnswer")) {
            logger.info("FAQ 답변 알림이 비활성화되어 있어 생성하지 않음 - userId: {}", userId);
            return null;
        }

        Notification notification = new Notification(
            userId,
            "FAQ_ANSWER",
            "질문에 답변이 등록되었습니다",
            "'" + questionTitle + "' 질문에 관리자의 답변이 등록되었습니다.",
            questionId,
            "/bdproject/project_mypage.jsp?viewQuestion=" + questionId
        );

        Long notificationId = notificationDao.create(notification);
        logger.info("FAQ 답변 알림 생성 완료 - userId: {}, questionId: {}", userId, questionId);
        logger.info("생성된 notificationId: {}", notificationId);

        return notificationId;
    }

    @Override
    public int generateAutoNotifications(String userId) {
        int count = 0;
        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = dataSource.getConnection();
            LocalDate today = LocalDate.now();
            LocalDate tomorrow = today.plusDays(1);

            logger.info("=== 알림 자동 생성 시작 - userId: {} ===", userId);
            logger.info("오늘 날짜: {}", today);
            logger.info("내일 날짜: {}", tomorrow);

            // 1. member_id 조회
            Long memberId = null;
            String memberSql = "SELECT member_id FROM member WHERE email = ?";
            pstmt = con.prepareStatement(memberSql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                memberId = rs.getLong("member_id");
            }
            rs.close();
            pstmt.close();

            if (memberId == null) {
                logger.warn("회원 ID를 찾을 수 없음 - userId: {}", userId);
                return 0;
            }

            // 2. 정기 기부 알림 생성
            count += generateDonationNotifications(con, userId, memberId, today, tomorrow);

            // 3. 봉사 활동 알림 생성 (주석 처리: 캘린더 일정 알림으로 통합)
            // 봉사 활동은 캘린더에도 자동 추가되므로 캘린더 알림만 사용
            // count += generateVolunteerNotifications(con, userId, memberId, today, tomorrow);

            // 4. 캘린더 일정 알림 생성
            try {
                count += generateCalendarEventNotifications(con, userId, memberId, today, tomorrow);
            } catch (Exception calendarError) {
                // calendar_events 테이블이 없을 경우 경고 로그만 출력하고 계속 진행
                logger.warn("캘린더 일정 알림 생성 실패 (테이블이 없을 수 있음): {}", calendarError.getMessage());
            }

            logger.info("=== 알림 자동 생성 완료 - 총 {}개 생성 ===", count);

        } catch (Exception e) {
            logger.error("알림 자동 생성 중 오류", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (Exception e) {
                logger.error("리소스 정리 중 오류", e);
            }
        }

        return count;
    }

    /**
     * 정기 기부 알림 생성
     */
    private int generateDonationNotifications(Connection con, String userId, Long memberId,
                                              LocalDate today, LocalDate tomorrow) throws Exception {
        int count = 0;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            logger.info("=== 정기 기부 알림 생성 시작 ===");
            logger.info("memberId: {}, today: {}", memberId, today);
            logger.info("tomorrow: {}", tomorrow);

            // 정기 기부 중 내일 또는 오늘이 시작일인 기부 조회
            String sql = "SELECT donation_id, regular_start_date, amount, category_id " +
                        "FROM donations " +
                        "WHERE member_id = ? " +
                        "AND donation_type = 'REGULAR' " +
                        "AND regular_start_date IN (?, ?) " +
                        "AND payment_status = 'COMPLETED'";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, memberId);
            pstmt.setString(2, tomorrow.toString());
            pstmt.setString(3, today.toString());

            rs = pstmt.executeQuery();

            logger.info("정기 기부 조회 SQL 실행 완료");

            int rowCount = 0;
            while (rs.next()) {
                rowCount++;
                LocalDate startDate = rs.getDate("regular_start_date").toLocalDate();
                Long donationId = rs.getLong("donation_id");
                double amount = rs.getDouble("amount");

                logger.info("정기 기부 발견 #{}: donationId={}", rowCount, donationId);
                logger.info("startDate: {}, amount: {}", startDate, amount);

                String title, message;
                LocalDate notificationDate = today;  // 알림은 항상 오늘 표시

                if (startDate.equals(tomorrow)) {
                    title = "내일은 정기 기부 예정일입니다";
                    message = String.format("내일 %.0f원의 정기 기부가 예정되어 있습니다. 감사합니다!", amount);
                } else {
                    title = "오늘은 정기 기부 예정일입니다";
                    message = String.format("오늘 %.0f원의 정기 기부가 진행됩니다. 따뜻한 나눔에 감사드립니다!", amount);
                }

                // 중복 알림 체크 (알림 표시일 + 제목 기준)
                boolean isDuplicate = isDuplicateNotificationWithTitle(con, userId, "DONATION_REMINDER", donationId, notificationDate, title);
                logger.info("중복 알림 체크 결과: {}", isDuplicate ? "중복됨 (생성 안 함)" : "중복 아님 (생성 진행)");

                if (!isDuplicate) {
                    Notification notification = new Notification(
                        userId,
                        "DONATION_REMINDER",
                        title,
                        message,
                        donationId,
                        "/bdproject/project_mypage.jsp"
                    );

                    // event_date 설정 (알림이 표시되는 날짜)
                    notification.setEventDate(java.sql.Date.valueOf(notificationDate));

                    Long notifId = notificationDao.create(notification);
                    if (notifId != null) {
                        count++;
                        logger.info("✅ 정기 기부 알림 생성 성공 - notificationId: {}, donationId: {}", notifId, donationId);
                        logger.info("date: {}", startDate);
                    } else {
                        logger.error("❌ 정기 기부 알림 생성 실패 - donationId: {}", donationId);
                    }
                } else {
                    logger.info("⏭️ 정기 기부 알림 스킵 (중복) - donationId: {}", donationId);
                }
            }

            logger.info("정기 기부 조회 완료 - 발견된 기부 수: {}, 생성된 알림 수: {}", rowCount, count);

        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }

        return count;
    }

    /**
     * 봉사 활동 알림 생성
     */
    private int generateVolunteerNotifications(Connection con, String userId, Long memberId,
                                               LocalDate today, LocalDate tomorrow) throws Exception {
        int count = 0;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            logger.info("=== 봉사 활동 알림 생성 시작 ===");
            logger.info("memberId: {}, today: {}", memberId, today);
            logger.info("tomorrow: {}", tomorrow);

            // 봉사 신청 중 내일 또는 오늘이 활동일인 봉사 조회
            // vol_date (일반 신청) 또는 activity_date (활동 기반 신청) 확인
            String sql = "SELECT va.apply_id AS application_id, va.act_id AS activity_id, va.vol_date AS volunteer_date, " +
                        "va.sel_cat AS selected_category, vact.activity_date, vact.activity_name " +
                        "FROM vol_apply va " +
                        "LEFT JOIN volunteer_activities vact ON va.act_id = vact.activity_id " +
                        "WHERE va.member_id = ? " +
                        "AND va.status IN ('APPLIED', 'CONFIRMED') " +
                        "AND (va.vol_date IN (?, ?) OR vact.activity_date IN (?, ?))";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, memberId);
            pstmt.setString(2, tomorrow.toString());
            pstmt.setString(3, today.toString());
            pstmt.setString(4, tomorrow.toString());
            pstmt.setString(5, today.toString());

            rs = pstmt.executeQuery();

            logger.info("봉사 활동 조회 SQL 실행 완료");

            int rowCount = 0;
            while (rs.next()) {
                rowCount++;
                // activity_date가 있으면 우선 사용, 없으면 volunteer_date 사용
                java.sql.Date activityDateSql = rs.getDate("activity_date");
                java.sql.Date volunteerDateSql = rs.getDate("volunteer_date");
                LocalDate activityDate = activityDateSql != null ? activityDateSql.toLocalDate() : volunteerDateSql.toLocalDate();

                Long applicationId = rs.getLong("application_id");
                String activityName = rs.getString("activity_name");
                if (activityName == null || activityName.isEmpty()) {
                    activityName = rs.getString("selected_category") + " 봉사";
                }

                logger.info("봉사 활동 발견 #{}: applicationId={}", rowCount, applicationId);
                logger.info("activityDate: {}, activityName: {}", activityDate, activityName);

                String title, message;
                LocalDate notificationDate = today;  // 알림은 항상 오늘 표시

                if (activityDate.equals(tomorrow)) {
                    // 내일 봉사 → 오늘 "내일 봉사 활동" 알림 표시
                    title = "내일 봉사 활동이 있습니다!";
                    message = String.format("내일 '%s' 봉사 활동이 예정되어 있습니다. 참여 준비해주세요!", activityName);
                } else if (activityDate.equals(today)) {
                    // 오늘 봉사 → 오늘 "오늘 봉사 활동" 알림 표시
                    title = "오늘 봉사 활동이 있습니다!";
                    message = String.format("오늘 '%s' 봉사 활동에 참여하실 시간입니다. 따뜻한 나눔 감사합니다!", activityName);
                } else {
                    // 오늘/내일이 아닌 경우 (발생하면 안 됨)
                    logger.warn("오늘/내일이 아닌 봉사 활동 발견 - activityDate: {}", activityDate);
                    continue; // 알림 생성 건너뛰기
                }

                // 중복 알림 체크 (알림 표시일 + 제목 기준)
                boolean isDuplicate = isDuplicateNotificationWithTitle(con, userId, "VOLUNTEER_REMINDER", applicationId, notificationDate, title);
                logger.info("중복 알림 체크 결과: {}", isDuplicate ? "중복됨 (생성 안 함)" : "중복 아님 (생성 진행)");

                if (!isDuplicate) {
                    Notification notification = new Notification(
                        userId,
                        "VOLUNTEER_REMINDER",
                        title,
                        message,
                        applicationId,
                        "/bdproject/project_mypage.jsp"
                    );

                    // event_date 설정 (알림이 표시되는 날짜)
                    notification.setEventDate(java.sql.Date.valueOf(notificationDate));

                    Long notifId = notificationDao.create(notification);
                    if (notifId != null) {
                        count++;
                        logger.info("✅ 봉사 활동 알림 생성 성공 - notificationId: {}, applicationId: {}", notifId, applicationId);
                        logger.info("date: {}", activityDate);
                    } else {
                        logger.error("❌ 봉사 활동 알림 생성 실패 - applicationId: {}", applicationId);
                    }
                } else {
                    logger.info("⏭️ 봉사 활동 알림 스킵 (중복) - applicationId: {}", applicationId);
                }
            }

            logger.info("봉사 활동 조회 완료 - 발견된 봉사 수: {}, 생성된 알림 수: {}", rowCount, count);

        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }

        return count;
    }

    /**
     * 캘린더 일정 알림 생성
     */
    private int generateCalendarEventNotifications(Connection con, String userId, Long memberId,
                                                   LocalDate today, LocalDate tomorrow) throws Exception {
        int count = 0;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // 알림 활성화된 캘린더 일정 중 내일 또는 오늘이 일정일인 일정 조회
            // remind_before_days를 고려하여 알림 생성
            String sql = "SELECT event_id, title, description, event_date, event_time, event_type, remind_before_days " +
                        "FROM calendar_events " +
                        "WHERE member_id = ? " +
                        "AND status = 'SCHEDULED' " +
                        "AND reminder_enabled = TRUE " +
                        "AND (event_date = ? OR event_date = ?)";

            pstmt = con.prepareStatement(sql);
            pstmt.setLong(1, memberId);
            pstmt.setString(2, tomorrow.toString());
            pstmt.setString(3, today.toString());

            rs = pstmt.executeQuery();

            while (rs.next()) {
                LocalDate eventDate = rs.getDate("event_date").toLocalDate();
                Long eventId = rs.getLong("event_id");
                String title = rs.getString("title");
                String eventType = rs.getString("event_type");
                String eventTime = rs.getTime("event_time") != null ? rs.getTime("event_time").toString() : "";

                String notificationTitle, notificationMessage;
                if (eventDate.equals(tomorrow)) {
                    notificationTitle = "내일은 일정이 있는 날입니다";
                    notificationMessage = String.format("내일 '%s' 일정이 예정되어 있습니다.", title);
                    if (!eventTime.isEmpty()) {
                        notificationMessage += String.format(" (시간: %s)", eventTime);
                    }
                } else {
                    notificationTitle = "오늘은 일정이 있는 날입니다";
                    notificationMessage = String.format("오늘 '%s' 일정이 있습니다. 잊지 마세요!", title);
                    if (!eventTime.isEmpty()) {
                        notificationMessage += String.format(" (시간: %s)", eventTime);
                    }
                }

                // 중복 알림 체크 (알림 표시일을 기준으로)
                // 내일 일정인 경우: 오늘 알림 표시 (event_date = today)
                // 오늘 일정인 경우: 오늘 알림 표시 (event_date = today)
                LocalDate notificationDate = today;  // 알림은 항상 오늘 표시

                if (!isDuplicateNotification(con, userId, "CALENDAR_EVENT", eventId, notificationDate)) {
                    Notification notification = new Notification(
                        userId,
                        "CALENDAR_EVENT",
                        notificationTitle,
                        notificationMessage,
                        eventId,
                        "/bdproject/project_mypage.jsp"
                    );

                    // event_date 설정 (알림이 표시되는 날짜)
                    notification.setEventDate(java.sql.Date.valueOf(notificationDate));

                    notificationDao.create(notification);
                    count++;
                    logger.info("캘린더 일정 알림 생성 - eventId: {}, notificationDate: {}",
                        eventId, notificationDate);
                }
            }

        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }

        return count;
    }

    /**
     * 중복 알림 체크
     */
    private boolean isDuplicateNotification(Connection con, String userId, String type,
                                           Long relatedId, LocalDate eventDate) throws Exception {
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // event_date를 기준으로 동일한 타입, 동일한 관련 ID의 알림이 있는지 확인
            // 삭제된 알림도 포함하여 체크 (중복 생성 방지)
            String sql = "SELECT COUNT(*) FROM notifications " +
                        "WHERE member_id = (SELECT member_id FROM member WHERE email = ?) " +
                        "AND notification_type = ? " +
                        "AND related_id = ? " +
                        "AND event_date = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, type);
            pstmt.setLong(3, relatedId);
            pstmt.setDate(4, java.sql.Date.valueOf(eventDate));

            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }

        return false;
    }

    /**
     * 중복 알림 체크 (제목 포함)
     * 같은 날에 "내일" 알림과 "오늘" 알림을 구분하기 위함
     */
    private boolean isDuplicateNotificationWithTitle(Connection con, String userId, String type,
                                           Long relatedId, LocalDate eventDate, String title) throws Exception {
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            // event_date + title을 기준으로 중복 체크
            // 삭제된 알림도 포함하여 체크 (중복 생성 방지)
            String sql = "SELECT COUNT(*) FROM notifications " +
                        "WHERE member_id = (SELECT member_id FROM member WHERE email = ?) " +
                        "AND notification_type = ? " +
                        "AND related_id = ? " +
                        "AND event_date = ? " +
                        "AND title = ?";

            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);
            pstmt.setString(2, type);
            pstmt.setLong(3, relatedId);
            pstmt.setDate(4, java.sql.Date.valueOf(eventDate));
            pstmt.setString(5, title);

            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getInt(1) > 0;
            }

        } finally {
            if (rs != null) rs.close();
            if (pstmt != null) pstmt.close();
        }

        return false;
    }

    @Override
    public int createVolunteerNotifications(String userId, Long applicationId, java.sql.Date volunteerDate, String category) {
        if (userId == null || userId.isEmpty()) {
            logger.warn("봉사활동 알림 생성 실패 - userId가 없음");
            return 0;
        }

        Connection con = null;
        int count = 0;

        try {
            con = dataSource.getConnection();

            // 1. member_id 조회
            Long memberId = null;
            String memberSql = "SELECT member_id FROM member WHERE email = ? AND deleted_at IS NULL";
            try (PreparedStatement memberPstmt = con.prepareStatement(memberSql)) {
                memberPstmt.setString(1, userId);
                try (ResultSet memberRs = memberPstmt.executeQuery()) {
                    if (memberRs.next()) {
                        memberId = memberRs.getLong("member_id");
                    }
                }
            }

            if (memberId == null) {
                logger.warn("봉사활동 알림 생성 실패 - member_id를 찾을 수 없음: {}", userId);
                return 0;
            }

            // 2. 알림 생성 SQL (중복 체크 포함)
            String checkDuplicateSql = "SELECT COUNT(*) FROM notifications " +
                    "WHERE member_id = ? " +
                    "AND notification_type = 'VOLUNTEER_REMINDER' " +
                    "AND related_id = ? " +
                    "AND DATE(created_at) = CURDATE()";

            String insertSql = "INSERT INTO notifications " +
                    "(member_id, notification_type, title, message, related_id, event_date, is_read, is_sent) " +
                    "VALUES (?, 'VOLUNTEER_REMINDER', ?, ?, ?, ?, FALSE, FALSE)";

            LocalDate volunteerLocalDate = volunteerDate.toLocalDate();
            LocalDate today = LocalDate.now();
            LocalDate oneDayBefore = volunteerLocalDate.minusDays(1);

            // 3. 하루 전 알림 생성 (하루 전이 오늘 이후인 경우만, 중복 체크 추가)
            if (!oneDayBefore.isBefore(today)) {
                // 중복 체크
                PreparedStatement checkPstmt = null;
                ResultSet checkRs = null;
                boolean isDuplicate = false;

                try {
                    checkPstmt = con.prepareStatement(checkDuplicateSql);
                    checkPstmt.setLong(1, memberId);
                    checkPstmt.setLong(2, applicationId);
                    checkRs = checkPstmt.executeQuery();
                    if (checkRs.next() && checkRs.getInt(1) > 0) {
                        isDuplicate = true;
                        logger.info("하루 전 알림 이미 존재 - applicationId: {}", applicationId);
                    }
                } finally {
                    if (checkRs != null) checkRs.close();
                    if (checkPstmt != null) checkPstmt.close();
                }

                if (!isDuplicate) {
                    PreparedStatement pstmt1 = null;
                    try {
                        pstmt1 = con.prepareStatement(insertSql);
                        pstmt1.setLong(1, memberId);
                        pstmt1.setString(2, "내일 봉사활동이 있습니다!");
                        pstmt1.setString(3, category + " 봉사활동이 내일(" + volunteerLocalDate + ") 예정되어 있습니다.");
                        pstmt1.setLong(4, applicationId);
                        pstmt1.setDate(5, java.sql.Date.valueOf(oneDayBefore));

                        int result1 = pstmt1.executeUpdate();
                        if (result1 > 0) count++;
                        logger.info("하루 전 알림 생성: {}", oneDayBefore);
                    } finally {
                        if (pstmt1 != null) pstmt1.close();
                    }
                }
            } else {
                logger.info("하루 전 날짜가 과거이므로 알림 생성 안 함: {}", oneDayBefore);
            }

            // 4. 당일 알림 생성 (당일이 오늘 이후인 경우만, 중복 체크 추가)
            if (!volunteerLocalDate.isBefore(today)) {
                // 중복 체크
                PreparedStatement checkPstmt = null;
                ResultSet checkRs = null;
                boolean isDuplicate = false;

                try {
                    checkPstmt = con.prepareStatement(checkDuplicateSql);
                    checkPstmt.setLong(1, memberId);
                    checkPstmt.setLong(2, applicationId);
                    checkRs = checkPstmt.executeQuery();
                    if (checkRs.next() && checkRs.getInt(1) > 0) {
                        isDuplicate = true;
                        logger.info("당일 알림 이미 존재 - applicationId: {}", applicationId);
                    }
                } finally {
                    if (checkRs != null) checkRs.close();
                    if (checkPstmt != null) checkPstmt.close();
                }

                if (!isDuplicate) {
                    PreparedStatement pstmt2 = null;
                    try {
                        pstmt2 = con.prepareStatement(insertSql);
                        pstmt2.setLong(1, memberId);
                        pstmt2.setString(2, "오늘 봉사활동이 있습니다!");
                        pstmt2.setString(3, "오늘 " + category + " 봉사활동이 예정되어 있습니다. 잊지 말고 참여해주세요!");
                        pstmt2.setLong(4, applicationId);
                        pstmt2.setDate(5, volunteerDate);

                        int result2 = pstmt2.executeUpdate();
                        if (result2 > 0) count++;
                        logger.info("당일 알림 생성: {}", volunteerLocalDate);
                    } finally {
                        if (pstmt2 != null) pstmt2.close();
                    }
                }
            } else {
                logger.info("당일 날짜가 과거이므로 알림 생성 안 함: {}", volunteerLocalDate);
            }

            logger.info("봉사활동 알림 생성 완료 - userId: {}, applicationId: {}", userId, applicationId);
            logger.info("생성된 알림 개수: {}", count);

        } catch (Exception e) {
            logger.error("봉사활동 알림 생성 중 오류 발생", e);
        } finally {
            try {
                if (con != null) con.close();
            } catch (Exception e) {
                logger.error("Connection close error", e);
            }
        }

        return count;
    }

    @Override
    public Long createVolunteerApprovalNotification(String userId, Long applicationId, String facilityName, String volunteerDate) {
        if (userId == null || userId.isEmpty()) {
            logger.warn("봉사활동 승인 알림 생성 실패 - userId가 없음");
            return null;
        }

        // 알림 설정 확인
        Long memberId = getMemberIdByUserId(userId);
        if (memberId != null && !isNotificationEnabled(memberId, "volunteer")) {
            logger.info("봉사활동 알림이 비활성화되어 있어 생성하지 않음 - userId: {}", userId);
            return null;
        }

        String title = "봉사활동 배정이 완료되었습니다!";
        String message = String.format("'%s'에서 %s 봉사활동이 승인되었습니다. 배정된 시설 정보를 확인해주세요.",
            facilityName, volunteerDate);

        Notification notification = new Notification(
            userId,
            "VOLUNTEER_APPROVED",
            title,
            message,
            applicationId,
            "/bdproject/project_mypage.jsp"
        );

        Long notificationId = notificationDao.create(notification);
        logger.info("봉사활동 승인 알림 생성 완료 - userId: {}, notificationId: {}", userId, notificationId);

        return notificationId;
    }

    /**
     * 알림 설정 확인 헬퍼 메소드
     * @param memberId 회원 ID
     * @param notificationType 알림 타입 (event, donation, volunteer, faqAnswer)
     * @return 알림 설정이 활성화되어 있으면 true
     */
    private boolean isNotificationEnabled(Long memberId, String notificationType) {
        if (notificationSettingsDao == null || memberId == null) {
            // DAO가 없거나 memberId가 없으면 기본값(true) 반환
            return true;
        }

        try {
            NotificationSettings settings = notificationSettingsDao.selectByMemberId(memberId);

            // 설정이 없으면 기본값(true) 반환
            if (settings == null) {
                return true;
            }

            // 타입별 설정 확인 (null이면 기본값 true로 처리)
            switch (notificationType) {
                case "event":
                case "calendar":
                    return settings.getEventNotification() == null || settings.getEventNotification();
                case "donation":
                    return settings.getDonationNotification() == null || settings.getDonationNotification();
                case "volunteer":
                    return settings.getVolunteerNotification() == null || settings.getVolunteerNotification();
                case "faqAnswer":
                case "faq":
                    return settings.getFaqAnswerNotification() == null || settings.getFaqAnswerNotification();
                default:
                    return true;
            }
        } catch (Exception e) {
            logger.error("알림 설정 확인 중 오류 발생", e);
            return true; // 오류 시 기본값 반환
        }
    }

    /**
     * userId로 memberId 조회 헬퍼 메소드
     * @param userId 사용자 이메일
     * @return memberId (없으면 null)
     */
    private Long getMemberIdByUserId(String userId) {
        if (userId == null || userId.isEmpty()) {
            return null;
        }

        Connection con = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            con = dataSource.getConnection();
            String sql = "SELECT member_id FROM member WHERE email = ?";
            pstmt = con.prepareStatement(sql);
            pstmt.setString(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                return rs.getLong("member_id");
            }
        } catch (Exception e) {
            logger.error("memberId 조회 중 오류 발생", e);
        } finally {
            try {
                if (rs != null) rs.close();
                if (pstmt != null) pstmt.close();
                if (con != null) con.close();
            } catch (Exception e) {
                logger.error("Resource close error", e);
            }
        }

        return null;
    }
}
