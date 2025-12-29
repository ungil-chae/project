package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.List;

import model.ContentBlock;
import util.DBUtil; // 데이터베이스 연결을 위한 유틸리티 클래스 (당신의 프로젝트에 맞춰야 함)

public class ContentBlockDAO {

	public int deleteByReviewId(int reviewId) throws SQLException {
		String sql = "DELETE FROM content_blocks WHERE review_id = ?";
		try (Connection conn = DBUtil.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, reviewId);
			return pstmt.executeUpdate(); // 삭제된 행의 수 반환
		}
	}

	/**
	 * 새로운 ContentBlock을 데이터베이스에 삽입합니다. 생성된 block_id를 반환합니다.
	 *
	 * @param block 삽입할 ContentBlock 객체 (review_id, block_type, block_order,
	 *              text_content, image_url 포함)
	 * @return 생성된 block_id 또는 -1 (실패 시)
	 * @throws SQLException DB 작업 중 오류 발생 시
	 */
	public int insert(ContentBlock block) throws SQLException {
		// SQL 쿼리는 content_blocks 테이블의 컬럼에 맞춰져 있습니다.
		// book_title, book_author 등 책 관련 컬럼은 더 이상 포함되지 않습니다.
		String sql = "INSERT INTO content_blocks (review_id, block_type, block_order, text_content, image_url, created_at, updated_at) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?)";
		int generatedId = -1;
		try (Connection conn = DBUtil.getConnection(); // DBUtil.getConnection()은 당신의 DB 연결 로직에 맞춰야 합니다.
				PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			pstmt.setInt(1, block.getReviewId());
			pstmt.setString(2, block.getBlockType());
			pstmt.setInt(3, block.getBlockOrder());
			pstmt.setString(4, block.getTextContent());
			pstmt.setString(5, block.getImageUrl());
			pstmt.setTimestamp(6, Timestamp.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant())); // created_at
			pstmt.setTimestamp(7, Timestamp.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant())); // updated_at
			// updated_at은 현재 시간으로 설정

			int affectedRows = pstmt.executeUpdate();
			if (affectedRows > 0) {
				try (ResultSet rs = pstmt.getGeneratedKeys()) {
					if (rs.next()) {
						generatedId = rs.getInt(1); // 생성된 block_id 반환
					}
				}
			}
		}
		return generatedId;
	}

	/**
	 * 특정 review_id에 해당하는 모든 ContentBlock들을 조회하여 리스트로 반환합니다. 블록 순서(block_order)에 따라
	 * 오름차순으로 정렬됩니다.
	 *
	 * @param reviewId 조회할 리뷰의 ID
	 * @return ContentBlock 객체들의 리스트 (해당 reviewId의 블록이 없으면 빈 리스트 반환)
	 * @throws SQLException DB 작업 중 오류 발생 시
	 */
	public List<ContentBlock> findByReviewId(int reviewId) throws SQLException {
		List<ContentBlock> blocks = new ArrayList<>();
		String sql = "SELECT block_id, review_id, block_type, block_order, text_content, image_url, created_at, updated_at "
				+ "FROM content_blocks WHERE review_id = ? ORDER BY block_order ASC";

		try (Connection conn = DBUtil.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, reviewId);
			try (ResultSet rs = pstmt.executeQuery()) {
				while (rs.next()) {
					ContentBlock block = new ContentBlock();
					block.setBlockId(rs.getInt("block_id"));
					block.setReviewId(rs.getInt("review_id"));
					block.setBlockType(rs.getString("block_type"));
					block.setBlockOrder(rs.getInt("block_order"));
					block.setTextContent(rs.getString("text_content"));
					block.setImageUrl(rs.getString("image_url"));
					block.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
					block.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());
					blocks.add(block);
				}
			}
		}
		return blocks;
	}

	// TODO: (선택 사항) ContentBlock의 업데이트 및 삭제 메서드를 여기에 추가할 수 있습니다.
	// 예를 들어, update(ContentBlock block) 또는 delete(int blockId) 등
}