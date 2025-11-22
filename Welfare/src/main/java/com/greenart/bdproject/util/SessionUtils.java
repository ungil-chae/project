package com.greenart.bdproject.util;

import javax.servlet.http.HttpSession;

/**
 * 세션 관리 유틸리티 클래스
 * 사용자 인증 상태 확인 및 세션 관리를 위한 헬퍼 메서드 제공
 *
 * @author Welfare24 Team
 */
public class SessionUtils {

    // 세션 키 상수
    private static final String USER_ID_KEY = "id";
    private static final String ALT_USER_ID_KEY = "userId";
    private static final String USER_NAME_KEY = "name";
    private static final String USER_ROLE_KEY = "role";

    /**
     * 세션에서 사용자 ID 가져오기
     * 두 가지 키('id', 'userId')를 모두 확인
     *
     * @param session - HttpSession 객체
     * @return String - 사용자 ID (없으면 null)
     */
    public static String getUserId(HttpSession session) {
        if (session == null) {
            return null;
        }

        String userId = (String) session.getAttribute(USER_ID_KEY);
        if (userId == null || userId.isEmpty()) {
            userId = (String) session.getAttribute(ALT_USER_ID_KEY);
        }
        return userId;
    }

    /**
     * 로그인 여부 확인
     *
     * @param session - HttpSession 객체
     * @return boolean - 로그인되어 있으면 true
     */
    public static boolean isLoggedIn(HttpSession session) {
        String userId = getUserId(session);
        return userId != null && !userId.isEmpty();
    }

    /**
     * 로그인 필수 - 로그인되어 있지 않으면 예외 발생
     *
     * @param session - HttpSession 객체
     * @return String - 사용자 ID
     * @throws IllegalStateException - 로그인되어 있지 않을 때
     */
    public static String requireLogin(HttpSession session) {
        String userId = getUserId(session);
        if (userId == null || userId.isEmpty()) {
            throw new IllegalStateException("로그인이 필요합니다.");
        }
        return userId;
    }

    /**
     * 세션에 사용자 ID 설정 (로그인 시 사용)
     *
     * @param session - HttpSession 객체
     * @param userId - 사용자 ID
     */
    public static void setUserId(HttpSession session, String userId) {
        if (session != null && userId != null) {
            session.setAttribute(USER_ID_KEY, userId);
        }
    }

    /**
     * 세션에서 사용자 이름 가져오기
     *
     * @param session - HttpSession 객체
     * @return String - 사용자 이름 (없으면 null)
     */
    public static String getUserName(HttpSession session) {
        if (session == null) {
            return null;
        }
        return (String) session.getAttribute(USER_NAME_KEY);
    }

    /**
     * 세션에 사용자 이름 설정
     *
     * @param session - HttpSession 객체
     * @param userName - 사용자 이름
     */
    public static void setUserName(HttpSession session, String userName) {
        if (session != null && userName != null) {
            session.setAttribute(USER_NAME_KEY, userName);
        }
    }

    /**
     * 세션에서 사용자 역할 가져오기
     *
     * @param session - HttpSession 객체
     * @return String - 사용자 역할 (없으면 null)
     */
    public static String getUserRole(HttpSession session) {
        if (session == null) {
            return null;
        }
        return (String) session.getAttribute(USER_ROLE_KEY);
    }

    /**
     * 세션에 사용자 역할 설정
     *
     * @param session - HttpSession 객체
     * @param role - 사용자 역할
     */
    public static void setUserRole(HttpSession session, String role) {
        if (session != null && role != null) {
            session.setAttribute(USER_ROLE_KEY, role);
        }
    }

    /**
     * 관리자 권한 확인
     *
     * @param session - HttpSession 객체
     * @return boolean - 관리자이면 true
     */
    public static boolean isAdmin(HttpSession session) {
        String role = getUserRole(session);
        return "ADMIN".equals(role);
    }

    /**
     * 관리자 권한 필수 - 관리자가 아니면 예외 발생
     *
     * @param session - HttpSession 객체
     * @throws IllegalStateException - 관리자가 아닐 때
     */
    public static void requireAdmin(HttpSession session) {
        if (!isAdmin(session)) {
            throw new IllegalStateException("관리자 권한이 필요합니다.");
        }
    }

    /**
     * 세션 초기화 (로그아웃 시 사용)
     *
     * @param session - HttpSession 객체
     */
    public static void clearSession(HttpSession session) {
        if (session != null) {
            session.invalidate();
        }
    }

    /**
     * 특정 속성만 제거
     *
     * @param session - HttpSession 객체
     * @param key - 제거할 속성 키
     */
    public static void removeAttribute(HttpSession session, String key) {
        if (session != null && key != null) {
            session.removeAttribute(key);
        }
    }

    /**
     * 세션에 임의 속성 설정
     *
     * @param session - HttpSession 객체
     * @param key - 속성 키
     * @param value - 속성 값
     */
    public static void setAttribute(HttpSession session, String key, Object value) {
        if (session != null && key != null) {
            session.setAttribute(key, value);
        }
    }

    /**
     * 세션에서 임의 속성 가져오기
     *
     * @param session - HttpSession 객체
     * @param key - 속성 키
     * @return Object - 속성 값 (없으면 null)
     */
    public static Object getAttribute(HttpSession session, String key) {
        if (session == null || key == null) {
            return null;
        }
        return session.getAttribute(key);
    }

    /**
     * 사용자 정보를 한 번에 설정 (로그인 시 사용)
     *
     * @param session - HttpSession 객체
     * @param userId - 사용자 ID
     * @param userName - 사용자 이름
     * @param role - 사용자 역할
     */
    public static void setUserInfo(HttpSession session, String userId, String userName, String role) {
        if (session != null) {
            setUserId(session, userId);
            setUserName(session, userName);
            setUserRole(session, role);
        }
    }
}
