package com.greenart.bdproject.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.greenart.bdproject.dto.Member;

@Repository
public class ProjectMemberDaoImpl implements ProjectMemberDao {

    @Autowired
    DataSource ds;

    @Override
    public int insert(Member m) {
        Connection con = null;
        PreparedStatement psmt = null;

        // 새로운 스키마에 맞춤: email이 로그인 ID 역할
        String sql = "INSERT INTO member(email, pwd, name, phone, role, status, birth, gender) " +
                     "VALUES(?, ?, ?, ?, COALESCE(?, 'USER'), COALESCE(?, 'ACTIVE'), ?, ?)";

        int res = 0;
        try {
            con = ds.getConnection();
            psmt = con.prepareStatement(sql);
            psmt.setString(1, m.getEmail());
            psmt.setString(2, m.getPwd());
            psmt.setString(3, m.getName());
            psmt.setString(4, m.getPhone());
            psmt.setString(5, m.getRole());
            psmt.setString(6, m.getStatus());
            psmt.setDate(7, m.getBirth());
            psmt.setString(8, m.getGender());

            res = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(psmt, con);
        }
        return res;
    }

    @Override
    public Member select(String email) {
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;
        Member m = null;

        // email로 조회 (email이 로그인 ID)
        String sql = "SELECT member_id, email, pwd, name, phone, role, status, birth, gender, " +
                     "postcode, address, detail_address, " +
                     "kindness_temperature, login_fail_count, last_login_fail_at, account_locked_until, " +
                     "last_login_at, created_at, updated_at " +
                     "FROM member WHERE email = ? AND deleted_at IS NULL";
        try {
            con = ds.getConnection();
            psmt = con.prepareStatement(sql);
            psmt.setString(1, email);
            rs = psmt.executeQuery();
            if(rs.next()) {
                m = new Member();
                m.setMemberId(rs.getLong("member_id"));
                m.setEmail(rs.getString("email"));
                m.setPwd(rs.getString("pwd"));
                m.setName(rs.getString("name"));
                m.setPhone(rs.getString("phone"));
                m.setRole(rs.getString("role"));
                m.setStatus(rs.getString("status"));
                m.setBirth(rs.getDate("birth"));
                m.setGender(rs.getString("gender"));
                m.setPostcode(rs.getString("postcode"));
                m.setAddress(rs.getString("address"));
                m.setDetailAddress(rs.getString("detail_address"));
                m.setKindnessTemperature(rs.getBigDecimal("kindness_temperature"));
                m.setLoginFailCount(rs.getInt("login_fail_count"));
                m.setLastLoginFailAt(rs.getTimestamp("last_login_fail_at"));
                m.setAccountLockedUntil(rs.getTimestamp("account_locked_until"));
                m.setLastLoginAt(rs.getTimestamp("last_login_at"));
                m.setCreatedAt(rs.getTimestamp("created_at"));
                m.setUpdatedAt(rs.getTimestamp("updated_at"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, psmt, con);
        }
        return m;
    }

    @Override
    public int delete(String email) {
        Connection con = null;
        PreparedStatement deleteNotifications = null;
        PreparedStatement deleteAutoLoginTokens = null;
        PreparedStatement softDeleteMember = null;

        int res = 0;
        try {
            con = ds.getConnection();
            con.setAutoCommit(false); // 트랜잭션 시작

            // 1. 알림 삭제
            String deleteNotifSql = "DELETE FROM notifications WHERE member_id = (SELECT member_id FROM member WHERE email = ?)";
            deleteNotifications = con.prepareStatement(deleteNotifSql);
            deleteNotifications.setString(1, email);
            deleteNotifications.executeUpdate();

            // 2. 자동 로그인 토큰 삭제
            String deleteTokensSql = "DELETE FROM auto_login_tokens WHERE member_id = (SELECT member_id FROM member WHERE email = ?)";
            deleteAutoLoginTokens = con.prepareStatement(deleteTokensSql);
            deleteAutoLoginTokens.setString(1, email);
            deleteAutoLoginTokens.executeUpdate();

            // 3. 소프트 삭제 (deleted_at 설정)
            String softDeleteSql = "UPDATE member SET deleted_at = NOW() WHERE email = ?";
            softDeleteMember = con.prepareStatement(softDeleteSql);
            softDeleteMember.setString(1, email);
            res = softDeleteMember.executeUpdate();

            con.commit(); // 트랜잭션 커밋
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (con != null) con.rollback(); // 오류 시 롤백
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (con != null) con.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            close(deleteNotifications, deleteAutoLoginTokens, softDeleteMember, con);
        }
        return res;
    }

    @Override
    public int update(Member m) {
        String sql = "UPDATE member SET pwd=?, name=?, phone=?, role=?, updated_at=NOW() WHERE email=?";
        int res = 0;
        try(Connection con = ds.getConnection();
            PreparedStatement psmt = con.prepareStatement(sql)) {
            psmt.setString(1, m.getPwd());
            psmt.setString(2, m.getName());
            psmt.setString(3, m.getPhone());
            psmt.setString(4, m.getRole());
            psmt.setString(5, m.getEmail());

            res = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return res;
    }

    @Override
    public int deleteAll() {
        Connection con = null;
        PreparedStatement psmt = null;
        int res = 0;

        String sql = "DELETE FROM member";
        try {
            con = ds.getConnection();
            psmt = con.prepareStatement(sql);
            res = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(psmt, con);
        }
        return res;
    }

    @Override
    public List<Member> selectList() {
        List<Member> mlist = new ArrayList<>();
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;

        String sql = "SELECT member_id, email, pwd, name, phone, role, status, birth, gender, " +
                     "kindness_temperature, created_at, updated_at " +
                     "FROM member WHERE deleted_at IS NULL ORDER BY created_at DESC";
        try {
            con = ds.getConnection();
            psmt = con.prepareStatement(sql);
            rs = psmt.executeQuery();
            while(rs.next()) {
                Member m = new Member();
                m.setMemberId(rs.getLong("member_id"));
                m.setEmail(rs.getString("email"));
                m.setPwd(rs.getString("pwd"));
                m.setName(rs.getString("name"));
                m.setPhone(rs.getString("phone"));
                m.setRole(rs.getString("role"));
                m.setStatus(rs.getString("status"));
                m.setBirth(rs.getDate("birth"));
                m.setGender(rs.getString("gender"));
                m.setKindnessTemperature(rs.getBigDecimal("kindness_temperature"));
                m.setCreatedAt(rs.getTimestamp("created_at"));
                m.setUpdatedAt(rs.getTimestamp("updated_at"));

                mlist.add(m);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, psmt, con);
        }
        return mlist;
    }

    @Override
    public int countByEmail(String email) {
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;
        int count = 0;

        String sql = "SELECT COUNT(*) FROM member WHERE email = ? AND deleted_at IS NULL";
        try {
            con = ds.getConnection();
            psmt = con.prepareStatement(sql);
            psmt.setString(1, email);
            rs = psmt.executeQuery();
            if(rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, psmt, con);
        }
        return count;
    }

    @Override
    public boolean existsByEmail(String email) {
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;
        boolean exists = false;

        // 활성 계정만 체크 (탈퇴한 계정은 재가입 가능)
        String sql = "SELECT COUNT(*) FROM member WHERE email = ? AND deleted_at IS NULL";
        try {
            con = ds.getConnection();
            psmt = con.prepareStatement(sql);
            psmt.setString(1, email);
            rs = psmt.executeQuery();
            if(rs.next()) {
                exists = rs.getInt(1) > 0;
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, psmt, con);
        }
        return exists;
    }

    @Override
    public Member selectDeleted(String email) {
        Connection con = null;
        PreparedStatement psmt = null;
        ResultSet rs = null;
        Member m = null;

        // 삭제된 계정 조회
        String sql = "SELECT member_id, email FROM member WHERE email = ? AND deleted_at IS NOT NULL";
        try {
            con = ds.getConnection();
            psmt = con.prepareStatement(sql);
            psmt.setString(1, email);
            rs = psmt.executeQuery();
            if(rs.next()) {
                m = new Member();
                m.setMemberId(rs.getLong("member_id"));
                m.setEmail(rs.getString("email"));
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            close(rs, psmt, con);
        }
        return m;
    }

    @Override
    public int reactivateAccount(Member m) {
        Connection con = null;
        PreparedStatement psmt = null;
        PreparedStatement deleteNotifications = null;
        int res = 0;

        try {
            con = ds.getConnection();
            con.setAutoCommit(false); // 트랜잭션 시작

            // 1. 기존 알림 삭제
            String deleteNotifSql = "DELETE FROM notifications WHERE member_id = (SELECT member_id FROM member WHERE email = ?)";
            deleteNotifications = con.prepareStatement(deleteNotifSql);
            deleteNotifications.setString(1, m.getEmail());
            deleteNotifications.executeUpdate();

            // 2. 계정 재활성화 및 개인정보 초기화
            String sql = "UPDATE member SET " +
                         "pwd = ?, name = ?, phone = ?, birth = ?, gender = ?, " +
                         "status = 'ACTIVE', deleted_at = NULL, " +
                         "profile_image_url = NULL, " +  // 프로필 이미지 초기화
                         "kindness_temperature = 36.5, " +  // 온도 초기화
                         "postcode = NULL, address = NULL, detail_address = NULL, " +  // 주소 초기화
                         "login_fail_count = 0, last_login_fail_at = NULL, account_locked_until = NULL, " +
                         "last_login_at = NULL, " +
                         "created_at = NOW(), updated_at = NOW() " +
                         "WHERE email = ?";
            psmt = con.prepareStatement(sql);
            psmt.setString(1, m.getPwd());
            psmt.setString(2, m.getName());
            psmt.setString(3, m.getPhone());
            psmt.setDate(4, m.getBirth());
            psmt.setString(5, m.getGender());
            psmt.setString(6, m.getEmail());
            res = psmt.executeUpdate();

            con.commit(); // 트랜잭션 커밋
        } catch (SQLException e) {
            e.printStackTrace();
            try {
                if (con != null) con.rollback(); // 오류 시 롤백
            } catch (SQLException ex) {
                ex.printStackTrace();
            }
        } finally {
            try {
                if (con != null) con.setAutoCommit(true);
            } catch (SQLException e) {
                e.printStackTrace();
            }
            close(deleteNotifications, psmt, con);
        }
        return res;
    }

    @Override
    public int incrementLoginFailCount(String email) {
        Connection con = null;
        PreparedStatement psmt = null;
        int res = 0;

        String sql = "UPDATE member SET login_fail_count = login_fail_count + 1, " +
                     "last_login_fail_at = NOW() WHERE email = ?";
        try {
            con = ds.getConnection();
            psmt = con.prepareStatement(sql);
            psmt.setString(1, email);
            res = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(psmt, con);
        }
        return res;
    }

    @Override
    public int resetLoginFailCount(String email) {
        Connection con = null;
        PreparedStatement psmt = null;
        int res = 0;

        String sql = "UPDATE member SET login_fail_count = 0, " +
                     "last_login_fail_at = NULL, account_locked_until = NULL, " +
                     "last_login_at = NOW() WHERE email = ?";
        try {
            con = ds.getConnection();
            psmt = con.prepareStatement(sql);
            psmt.setString(1, email);
            res = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(psmt, con);
        }
        return res;
    }

    @Override
    public int lockAccount(String email, int minutes) {
        Connection con = null;
        PreparedStatement psmt = null;
        int res = 0;

        String sql = "UPDATE member SET account_locked_until = DATE_ADD(NOW(), INTERVAL ? MINUTE) " +
                     "WHERE email = ?";
        try {
            con = ds.getConnection();
            psmt = con.prepareStatement(sql);
            psmt.setInt(1, minutes);
            psmt.setString(2, email);
            res = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(psmt, con);
        }
        return res;
    }

    @Override
    public int updateProfileImage(String email, String imageUrl) {
        Connection con = null;
        PreparedStatement psmt = null;
        int res = 0;

        String sql = "UPDATE member SET profile_image_url = ?, updated_at = NOW() WHERE email = ?";
        try {
            con = ds.getConnection();
            psmt = con.prepareStatement(sql);
            psmt.setString(1, imageUrl);
            psmt.setString(2, email);
            res = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(psmt, con);
        }
        return res;
    }

    @Override
    public int updateProfile(Member m) {
        Connection con = null;
        PreparedStatement psmt = null;
        int res = 0;

        String sql = "UPDATE member SET name = ?, gender = ?, birth = ?, phone = ?, " +
                     "postcode = ?, address = ?, detail_address = ?, updated_at = NOW() WHERE email = ?";
        try {
            con = ds.getConnection();
            psmt = con.prepareStatement(sql);
            psmt.setString(1, m.getName());
            psmt.setString(2, m.getGender());
            psmt.setDate(3, m.getBirth());
            psmt.setString(4, m.getPhone());
            psmt.setString(5, m.getPostcode());
            psmt.setString(6, m.getAddress());
            psmt.setString(7, m.getDetailAddress());
            psmt.setString(8, m.getEmail());
            res = psmt.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        } finally {
            close(psmt, con);
        }
        return res;
    }

    private void close(AutoCloseable... acs) {
        for (AutoCloseable ac : acs) {
            try {
                if (ac != null) ac.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
