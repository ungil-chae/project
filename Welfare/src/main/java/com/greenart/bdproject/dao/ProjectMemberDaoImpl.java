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
        String sql = "INSERT INTO member(email, pwd, name, phone, role, status, birth, gender, security_question, security_answer) " +
                     "VALUES(?, ?, ?, ?, COALESCE(?, 'USER'), COALESCE(?, 'ACTIVE'), ?, ?, ?, ?)";

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
            psmt.setString(9, m.getSecurityQuestion());
            psmt.setString(10, m.getSecurityAnswer());

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
                     "security_question, security_answer, kindness_temperature, " +
                     "login_fail_count, last_login_fail_at, account_locked_until, " +
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
                m.setSecurityQuestion(rs.getString("security_question"));
                m.setSecurityAnswer(rs.getString("security_answer"));
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
        PreparedStatement psmt = null;

        // 소프트 삭제 (deleted_at 설정)
        String sql = "UPDATE member SET deleted_at = NOW() WHERE email = ?";

        int res = 0;
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
    public int update(Member m) {
        String sql = "UPDATE member SET pwd=?, name=?, phone=?, role=?, " +
                     "security_question=?, security_answer=?, updated_at=NOW() WHERE email=?";
        int res = 0;
        try(Connection con = ds.getConnection();
            PreparedStatement psmt = con.prepareStatement(sql)) {
            psmt.setString(1, m.getPwd());
            psmt.setString(2, m.getName());
            psmt.setString(3, m.getPhone());
            psmt.setString(4, m.getRole());
            psmt.setString(5, m.getSecurityQuestion());
            psmt.setString(6, m.getSecurityAnswer());
            psmt.setString(7, m.getEmail());

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
                     "security_question, security_answer, kindness_temperature, " +
                     "created_at, updated_at " +
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
                m.setSecurityQuestion(rs.getString("security_question"));
                m.setSecurityAnswer(rs.getString("security_answer"));
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
