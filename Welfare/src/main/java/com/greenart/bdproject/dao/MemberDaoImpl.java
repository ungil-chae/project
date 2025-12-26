package com.greenart.bdproject.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.greenart.bdproject.dto.Member;

//@Repository // MemberDaoImpl2를 사용하므로 주석 처리
public class MemberDaoImpl implements MemberDao {
	@Autowired
	DataSource ds;
	
	
	@Override
	public int insert(Member m){
		Connection con = null;
		PreparedStatement psmt = null;

		// username을 id 컬럼에 저장 (기존 스키마 호환)
		String sql = "insert into member(id, pwd, name, email, phone, role, birth)"
				+ " values(?, ?, ?, ?, ?, ?, ?)";

		int res = 0;
		try {
			con = ds.getConnection();
			psmt = con.prepareStatement(sql);
			psmt.setString(1, m.getUsername());
			psmt.setString(2, m.getPwd());
			psmt.setString(3, m.getName());
			psmt.setString(4, m.getEmail());
			psmt.setString(5, m.getPhone());
			psmt.setString(6, m.getRole() != null ? m.getRole() : "USER");
			psmt.setDate(7, m.getBirth());

			res = psmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			close(psmt, con);
		}
		return res;
	}
	
	@Override
	public Member select(String id){
		Connection con = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		Member m = null;

		// sns, regDate 컬럼 제외 (새 스키마에서 제거됨)
		String sql = "select id, pwd, name, email, phone, role, birth from member where id = ?";
		try {
			con = ds.getConnection();
			psmt = con.prepareStatement(sql);
			psmt.setString(1, id);
			rs = psmt.executeQuery();
			if(rs.next()) {
				m = new Member();
				m.setUsername(rs.getString(1));
				m.setPwd(rs.getString(2));
				m.setName(rs.getString(3));
				m.setEmail(rs.getString(4));
				m.setPhone(rs.getString(5));
				m.setRole(rs.getString(6));
				m.setBirth(rs.getDate(7));
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			close(rs, psmt, con);
		}
		return m;
	}
	
	@Override
	public int delete(String id){
		Connection con = null;
		PreparedStatement psmt = null;
		
		String sql = "delete from member where id = ?";

		int res = 0;
		try {
			con = ds.getConnection();
			psmt = con.prepareStatement(sql);
			psmt.setString(1, id);
			res = psmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally {
			close(psmt, con);
		}
		return res;
	}
	
	@Override
	public int update(Member m) {
		// sns, regDate 컬럼 제외 (새 스키마에서 제거됨)
		String sql ="update member set pwd=?, name=?, email=? where id = ?";
		int res = 0;
		try(Connection con = ds.getConnection(); PreparedStatement psmt = con.prepareStatement(sql);) {
			psmt.setString(1, m.getPwd());
			psmt.setString(2, m.getName());
			psmt.setString(3, m.getEmail());
			psmt.setString(4, m.getUsername());

			res = psmt.executeUpdate();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
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
	
	public int deleteAll() throws SQLException{
		Connection con = ds.getConnection();
		String sql = "delete from member";
		PreparedStatement psmt = con.prepareStatement(sql);
		int res = psmt.executeUpdate();
		return res;
	}
	
	@Override
	public ArrayList<Member> selectList(){
		ArrayList<Member> mlist = new ArrayList<>();
		Connection con = null;
		PreparedStatement psmt = null;
		ResultSet rs = null;
		Member m = null;

		// sns, regDate 컬럼 제외 (새 스키마에서 제거됨)
		String sql = "select id, pwd, name, email, phone, role, birth from member";
		try {
			con = ds.getConnection();
			psmt = con.prepareStatement(sql);
			rs = psmt.executeQuery();
			while(rs.next()) {
				m = new Member();
				m.setUsername(rs.getString(1));
				m.setPwd(rs.getString(2));
				m.setName(rs.getString(3));
				m.setEmail(rs.getString(4));
				m.setPhone(rs.getString(5));
				m.setRole(rs.getString(6));
				m.setBirth(rs.getDate(7));

				mlist.add(m);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}finally{
			close(rs, psmt, con);
		}
		return mlist;
	}

	/**
	 * username으로 회원 조회 (member 테이블에서는 id가 username 역할)
	 */
	@Override
	public Member selectByUsername(String username) throws Exception {
		return select(username); // id로 조회하는 것과 동일
	}

	// ============ 아래 메서드들은 이 클래스가 비활성화되어 있어 stub 구현 ============
	// MemberDaoImpl2를 사용하므로 이 클래스는 @Repository 주석 처리됨

	@Override
	public BigDecimal getKindnessTemperature(String userId) throws Exception {
		throw new UnsupportedOperationException("MemberDaoImpl은 비활성화됨. MemberDaoImpl2 사용");
	}

	@Override
	public int updateKindnessTemperature(String userId, BigDecimal temperature) throws Exception {
		throw new UnsupportedOperationException("MemberDaoImpl은 비활성화됨. MemberDaoImpl2 사용");
	}

	@Override
	public int increaseKindnessTemperature(String userId, BigDecimal amount) throws Exception {
		throw new UnsupportedOperationException("MemberDaoImpl은 비활성화됨. MemberDaoImpl2 사용");
	}

	@Override
	public int decreaseKindnessTemperature(String userId, BigDecimal amount) throws Exception {
		throw new UnsupportedOperationException("MemberDaoImpl은 비활성화됨. MemberDaoImpl2 사용");
	}

	@Override
	public Member findByNameAndEmail(String name, String email) throws Exception {
		throw new UnsupportedOperationException("MemberDaoImpl은 비활성화됨. MemberDaoImpl2 사용");
	}

	@Override
	public Member findByNameAndPhone(String name, String phone) throws Exception {
		throw new UnsupportedOperationException("MemberDaoImpl은 비활성화됨. MemberDaoImpl2 사용");
	}

	@Override
	public Member findByIdAndSecurityAnswer(String id, String securityAnswer) throws Exception {
		throw new UnsupportedOperationException("MemberDaoImpl은 비활성화됨. MemberDaoImpl2 사용");
	}
}
