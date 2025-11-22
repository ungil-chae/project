package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDateTime;

import model.User; // User 모델
import dto.UserProfileUpdateRequest; // UserProfileUpdateRequest DTO 임포트
import util.DBUtil; // DB 연결 유틸리티

public class UserDao {

    /**
     * 새로운 사용자를 데이터베이스에 추가합니다.
     * 'name', 'hobbies', 'status' 컬럼을 INSERT 쿼리에 명시적으로 포함합니다.
     * 'status'는 기본적으로 'active'로 설정됩니다.
     * 'reg_date'는 현재 시간으로, 'last_login_date'와 'deleted_at'은 null로 초기화됩니다.
     *
     * @param user 추가할 사용자 정보 객체 (password는 이미 해싱된 상태여야 함)
     * @return 데이터베이스에 저장된 사용자 정보 (user_id 포함) 또는 null (실패 시)
     * @throws SQLException 데이터베이스 작업 중 오류 발생 시
     */
    public User createUser(User user) throws SQLException {
        // 'name', 'hobbies' 필드 추가 및 'status', 'reg_date', 'last_login_date', 'deleted_at' 포함
        String sql = "INSERT INTO Users (username, password, nickname, email, gender, mbti, name, hobbies, reg_date, last_login_date, status, deleted_at) VALUES (?, ?, ?, ?, ?, ?, ?, ?, NOW(), NULL, 'active', NULL)";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getPassword());
            pstmt.setString(3, user.getNickname());
            pstmt.setString(4, user.getEmail());
            pstmt.setString(5, user.getGender());
            pstmt.setString(6, user.getMbti());
            pstmt.setString(7, user.getName());    // ✨ name 필드 추가
            pstmt.setString(8, user.getHobbies()); // ✨ hobbies 필드 추가

            int affectedRows = pstmt.executeUpdate();

            if (affectedRows > 0) {
                rs = pstmt.getGeneratedKeys();
                if (rs.next()) {
                    user.setUserId(rs.getInt(1));
                    user.setRegDate(LocalDateTime.now());
                    user.setLastLoginDate(null); // DB와 동기화
                    user.setStatus("active"); // DB와 동기화
                    user.setDeletedAt(null); // DB와 동기화
                    return user;
                }
            }
            return null;
        } finally {
            DBUtil.close(rs);
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 사용자 이름으로 사용자를 조회합니다. (로그인 및 중복 확인용)
     * 'status', 'name', 'hobbies', 'deleted_at' 컬럼을 함께 조회하여 계정 상태 및 전체 정보를 확인할 수 있도록 합니다.
     *
     * @param username 조회할 사용자 이름
     * @return 해당 사용자 객체 또는 null (사용자가 없는 경우)
     * @throws SQLException 데이터베이스 작업 중 오류 발생 시
     */
    public User findByUsername(String username) throws SQLException {
        // 'name', 'hobbies', 'status', 'deleted_at' 컬럼 추가하여 조회
        String sql = "SELECT user_id, username, password, nickname, email, gender, mbti, name, hobbies, reg_date, last_login_date, status, deleted_at FROM Users WHERE username = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        User user = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setNickname(rs.getString("nickname"));
                user.setEmail(rs.getString("email"));
                user.setGender(rs.getString("gender"));
                user.setMbti(rs.getString("mbti"));
                user.setName(rs.getString("name"));        // ✨ name 필드 매핑
                user.setHobbies(rs.getString("hobbies"));  // ✨ hobbies 필드 매핑
                user.setRegDate(rs.getTimestamp("reg_date") != null ? rs.getTimestamp("reg_date").toLocalDateTime() : null);
                user.setLastLoginDate(rs.getTimestamp("last_login_date") != null ? rs.getTimestamp("last_login_date").toLocalDateTime() : null);
                user.setStatus(rs.getString("status"));
                user.setDeletedAt(rs.getTimestamp("deleted_at") != null ? rs.getTimestamp("deleted_at").toLocalDateTime() : null); // ✨ deleted_at 필드 매핑
            }
            return user;
        } finally {
            DBUtil.close(rs);
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 이메일로 사용자를 조회합니다. (중복 확인용)
     *
     * @param email 조회할 이메일
     * @return 이메일이 존재하는지 여부
     * @throws SQLException 데이터베이스 작업 중 오류 발생 시
     */
    public boolean isEmailTaken(String email) throws SQLException {
        // 'is_deleted' 또는 'status'가 'active'인 사용자만 고려하는 것이 일반적입니다.
        // 현재는 모든 이메일 중복을 확인하지만, 필요에 따라 활성 계정만 대상으로 변경할 수 있습니다.
        String sql = "SELECT COUNT(*) FROM Users WHERE email = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, email);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } finally {
            DBUtil.close(rs);
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 사용자 이름(username)이 이미 사용 중인지 확인합니다. (중복 확인용)
     *
     * @param username 확인할 사용자 이름
     * @return 사용자 이름이 이미 사용 중이면 true, 아니면 false
     * @throws SQLException 데이터베이스 작업 중 오류 발생 시
     */
    public boolean isUsernameTaken(String username) throws SQLException {
        // 'is_deleted' 또는 'status'가 'active'인 사용자만 고려하는 것이 일반적입니다.
        String sql = "SELECT COUNT(*) FROM Users WHERE username = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } finally {
            DBUtil.close(rs);
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 닉네임이 이미 사용 중인지 확인합니다. (중복 확인용)
     *
     * @param nickname 확인할 닉네임
     * @return 닉네임이 이미 사용 중이면 true, 아니면 false
     * @throws SQLException 데이터베이스 작업 중 오류 발생 시
     */
    public boolean isNicknameTaken(String nickname) throws SQLException {
        // 'is_deleted' 또는 'status'가 'active'인 사용자만 고려하는 것이 일반적입니다.
        String sql = "SELECT COUNT(*) FROM Users WHERE nickname = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, nickname);
            rs = pstmt.executeQuery();
            if (rs.next()) {
                return rs.getInt(1) > 0;
            }
            return false;
        } finally {
            DBUtil.close(rs);
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 사용자 로그인 시간 업데이트
     *
     * @param userId 로그인한 사용자 ID
     * @throws SQLException 데이터베이스 작업 중 오류 발생 시
     */
    public void updateLastLoginDate(int userId) throws SQLException {
        String sql = "UPDATE Users SET last_login_date = NOW() WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            pstmt.executeUpdate();
        } finally {
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 사용자 ID로 사용자를 조회합니다. (마이페이지 프로필 조회용)
     * 'status', 'name', 'hobbies', 'deleted_at' 컬럼을 함께 조회하여 사용자 상태 및 전체 정보를 확인할 수 있도록 합니다.
     *
     * @param userId 조회할 사용자 ID
     * @return 해당 사용자 객체 또는 null
     * @throws SQLException 데이터베이스 작업 중 오류 발생 시
     */
    public User findByUserId(int userId) throws SQLException {
        // 'name', 'hobbies', 'status', 'deleted_at' 컬럼 추가하여 조회
        String sql = "SELECT user_id, username, password, nickname, email, gender, mbti, name, hobbies, reg_date, last_login_date, status, deleted_at FROM Users WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        User user = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, userId);
            rs = pstmt.executeQuery();

            if (rs.next()) {
                user = new User();
                user.setUserId(rs.getInt("user_id"));
                user.setUsername(rs.getString("username"));
                user.setPassword(rs.getString("password"));
                user.setNickname(rs.getString("nickname"));
                user.setEmail(rs.getString("email"));
                user.setGender(rs.getString("gender"));
                user.setMbti(rs.getString("mbti"));
                user.setName(rs.getString("name"));        // ✨ name 필드 매핑
                user.setHobbies(rs.getString("hobbies"));  // ✨ hobbies 필드 매핑
                user.setRegDate(rs.getTimestamp("reg_date") != null ? rs.getTimestamp("reg_date").toLocalDateTime() : null);
                user.setLastLoginDate(rs.getTimestamp("last_login_date") != null ? rs.getTimestamp("last_login_date").toLocalDateTime() : null);
                user.setStatus(rs.getString("status"));
                user.setDeletedAt(rs.getTimestamp("deleted_at") != null ? rs.getTimestamp("deleted_at").toLocalDateTime() : null); // ✨ deleted_at 필드 매핑
            }
            return user;
        } finally {
            DBUtil.close(rs);
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 사용자 프로필 정보를 업데이트합니다.
     * (닉네임, 이메일, 성별, MBTI, 이름, 취미)
     * 이메일과 닉네임의 중복 확인은 서비스 계층에서 먼저 수행되어야 합니다.
     *
     * @param userId 사용자 ID
     * @param reqDto 업데이트할 프로필 정보 (UserProfileUpdateRequest DTO 사용)
     * @return 성공 시 true, 실패 시 false
     * @throws SQLException 데이터베이스 오류 발생 시
     */
    public boolean updateUserProfile(int userId, UserProfileUpdateRequest reqDto) throws SQLException {
        // SQL 쿼리에 name, hobbies 컬럼 추가
        String sql = "UPDATE Users SET nickname = ?, email = ?, gender = ?, mbti = ?, name = ?, hobbies = ? WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, reqDto.getNickname());
            pstmt.setString(2, reqDto.getEmail());
            pstmt.setString(3, reqDto.getGender());
            pstmt.setString(4, reqDto.getMbti());
            pstmt.setString(5, reqDto.getName()); // ✨ name 필드 추가
            pstmt.setString(6, reqDto.getHobbies()); // ✨ hobbies 필드 추가
            pstmt.setInt(7, userId);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } finally {
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 사용자의 비밀번호를 업데이트합니다. (해싱된 비밀번호)
     *
     * @param userId 사용자 ID
     * @param newHashedPassword 새로 해싱된 비밀번호
     * @return 성공 시 true, 실패 시 false
     * @throws SQLException 데이터베이스 오류 발생 시
     */
    public boolean updatePassword(int userId, String newHashedPassword) throws SQLException {
        String sql = "UPDATE Users SET password = ? WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, newHashedPassword);
            pstmt.setInt(2, userId);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } finally {
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 사용자의 상태를 업데이트합니다. (예: 'active', 'inactive', 'withdrawn')
     * 특히 'withdrawn' 상태로 변경 시 deleted_at 컬럼에 현재 시간을 기록합니다.
     *
     * @param userId 사용자 ID
     * @param status 변경할 상태 문자열 ('active', 'withdrawn', 'suspended' 등)
     * @return 성공 시 true, 실패 시 false
     * @throws SQLException 데이터베이스 오류 발생 시
     */
    public boolean updateUserStatus(int userId, String status) throws SQLException {
        // status가 'withdrawn'일 경우 deleted_at도 함께 업데이트
        String sql = "UPDATE Users SET status = ?, deleted_at = ? WHERE user_id = ?";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, status);
            
            // 상태가 'withdrawn'이면 현재 시간을, 아니면 null을 설정
            if ("withdrawn".equals(status)) {
                pstmt.setTimestamp(2, java.sql.Timestamp.valueOf(LocalDateTime.now()));
            } else {
                pstmt.setNull(2, java.sql.Types.TIMESTAMP); // 다른 상태로 변경 시 deleted_at 초기화
            }
            
            pstmt.setInt(3, userId);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } finally {
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }
}