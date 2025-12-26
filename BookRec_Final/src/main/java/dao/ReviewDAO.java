package dao;

// import java.security.Timestamp; // <-- 이 줄을 삭제합니다!
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp; // <-- 이 줄을 추가합니다! (java.sql.Timestamp 임포트)
import java.time.LocalDateTime;
import java.time.ZoneId; // 이전에 추가한 ZoneId 임포트
import java.util.ArrayList;
import java.util.List;
import dto.ReviewListDisplayDTO;
import model.Review;
import util.DBUtil; // DB 연결 유틸리티 클래스 (가정)

public class ReviewDAO {
	
	 public List<ReviewListDisplayDTO> getReviewsByUserIdWithBookInfo(int userId) throws SQLException {
	        List<ReviewListDisplayDTO> userReviews = new ArrayList<>();
	        String sql = "SELECT r.review_id, r.user_id, r.review_text, r.rating, r.created_at, r.updated_at, " +
	                     "rb.book_id, rb.isbn, rb.title AS book_title, rb.author AS book_author, rb.cover_image_url AS book_cover_image_url " +
	                     "FROM reviews r JOIN books rb ON r.book_id = rb.book_id " +
	                     "WHERE r.user_id = ? " + // <-- user_id로 필터링
	                     "ORDER BY r.created_at DESC"; // 최신 리뷰부터 표시

	        try (Connection conn = DBUtil.getConnection();
	             PreparedStatement pstmt = conn.prepareStatement(sql)) {

	            pstmt.setInt(1, userId); // user_id 파라미터 설정

	            try (ResultSet rs = pstmt.executeQuery()) {
	                while (rs.next()) {
	                    ReviewListDisplayDTO dto = new ReviewListDisplayDTO();
	                    dto.setReviewId(rs.getInt("review_id"));
	                    dto.setUserId(rs.getInt("user_id"));
	                    dto.setReviewText(rs.getString("review_text"));
	                    dto.setRating(rs.getInt("rating"));
	                    dto.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
	                    dto.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

	                    dto.setBookId(rs.getInt("book_id"));
	                    dto.setIsbn(rs.getString("isbn"));
	                    dto.setBookTitle(rs.getString("book_title"));
	                    dto.setBookAuthor(rs.getString("book_author"));
	                    dto.setBookCoverImageUrl(rs.getString("book_cover_image_url"));

	                    userReviews.add(dto);
	                }
	            }
	        }
	        return userReviews;
	    }

	/**
	 * 리뷰 내용을 업데이트합니다. rating, review_text, updated_at 필드를 수정합니다.
	 * 
	 * @param review 업데이트할 Review 객체 (reviewId, reviewText, rating 필드 사용)
	 * @return 업데이트된 행의 수 (1이면 성공)
	 * @throws SQLException DB 작업 중 오류 발생 시
	 */
	public int update(Review review) throws SQLException {
		String sql = "UPDATE reviews SET review_text = ?, rating = ?, updated_at = ? WHERE review_id = ?";
		try (Connection conn = DBUtil.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setString(1, review.getReviewText());
			pstmt.setInt(2, review.getRating());
			// 여기를 수정합니다:
			pstmt.setTimestamp(3, Timestamp.from(LocalDateTime.now().atZone(ZoneId.systemDefault()).toInstant())); // LocalDateTime
																													// ->
																													// Timestamp
																													// 변환
			pstmt.setInt(4, review.getReviewId());

			return pstmt.executeUpdate();
		}
	}

	/**
	 * 특정 review_id에 해당하는 리뷰를 삭제합니다.
	 *
	 * @param reviewId 삭제할 리뷰 ID
	 * @return 삭제된 행의 수
	 * @throws SQLException DB 작업 중 오류 발생 시
	 */
	public int delete(int reviewId) throws SQLException {
		String sql = "DELETE FROM reviews WHERE review_id = ?";
		try (Connection conn = DBUtil.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {
			pstmt.setInt(1, reviewId);
			return pstmt.executeUpdate();
		}
	}// 삭제된 행의 수 반환
		// (기존 ReviewDAO의 다른 메서드들은 여기에 그대로 있다고 가정합니다.)

	// 새로운 리뷰를 삽입하는 메서드
	// reviews 테이블의 review_id는 자동 생성되므로, 생성된 review_id를 반환
	public int insert(Review review) throws SQLException {
		String sql = "INSERT INTO reviews (user_id, book_id, review_text, rating) VALUES (?, ?, ?, ?)";
		int generatedId = -1;
		try (Connection conn = DBUtil.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			// user_id는 String 타입이지만 DB에서는 INT일 수 있으므로 적절히 변환하거나 DB 타입을 따릅니다.
			// 현재 DB 스키마는 user_id INT NOT NULL 이므로, String -> Int 변환이 필요할 수 있습니다.
			// 여기서는 일단 String을 받아서 setString으로 처리합니다. (DB 컬럼이 VARCHAR라고 가정)
			// 만약 user_id가 INT라면, pstmt.setInt(1, Integer.parseInt(review.getUserId())); 로
			// 변경해야 합니다.
			pstmt.setInt(1, review.getUserId());
			pstmt.setInt(2, review.getBookId());
			pstmt.setString(3, review.getReviewText());
			pstmt.setInt(4, review.getRating());

			int affectedRows = pstmt.executeUpdate();
			if (affectedRows > 0) {
				try (ResultSet rs = pstmt.getGeneratedKeys()) {
					if (rs.next()) {
						generatedId = rs.getInt(1); // 생성된 review_id
					}
				}
			}
		}
		return generatedId;
	}

	// 모든 리뷰와 그에 해당하는 책 정보를 조회하여 ReviewListDisplayDTO 리스트로 반환합니다. (기존 내용)
	public List<ReviewListDisplayDTO> getAllReviewsWithBookInfo() throws SQLException {
		List<ReviewListDisplayDTO> reviews = new ArrayList<>();
		// SQL 쿼리의 SELECT 절에 'rb.isbn'을 추가해야 합니다!
		String sql = "SELECT r.review_id, r.user_id, r.review_text, r.rating, r.created_at, r.updated_at, "
				+ "rb.book_id, rb.isbn, rb.title AS book_title, rb.author AS book_author, rb.cover_image_url AS book_cover_image_url " // <<--
																																		// rb.isbn
																																		// 추가됨!
				+ "FROM reviews r JOIN books rb ON r.book_id = rb.book_id " + "ORDER BY r.created_at DESC";

		try (Connection conn = DBUtil.getConnection();
				PreparedStatement pstmt = conn.prepareStatement(sql);
				ResultSet rs = pstmt.executeQuery()) {

			while (rs.next()) {
				ReviewListDisplayDTO dto = new ReviewListDisplayDTO();
				dto.setReviewId(rs.getInt("review_id"));
				dto.setUserId(rs.getInt("user_id")); // <<-- int로 변경!
				dto.setReviewText(rs.getString("review_text"));
				dto.setRating(rs.getInt("rating"));
				dto.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
				dto.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

				dto.setBookId(rs.getInt("book_id"));
				dto.setIsbn(rs.getString("isbn"));
				dto.setBookTitle(rs.getString("book_title"));
				dto.setBookAuthor(rs.getString("book_author"));
				dto.setBookCoverImageUrl(rs.getString("book_cover_image_url"));

				reviews.add(dto);
			}
		}
		return reviews;
	}

	/**
	 * 특정 review_id에 해당하는 리뷰와 책 정보를 조회합니다. (기존 내용)
	 */
	public ReviewListDisplayDTO getReviewByIdWithBookInfo(int reviewId) throws SQLException {
		ReviewListDisplayDTO dto = null;
		String sql = "SELECT r.review_id, r.user_id, r.review_text, r.rating, r.created_at, r.updated_at, "
				+ "rb.book_id, rb.title AS book_title, rb.author AS book_author, rb.cover_image_url AS book_cover_image_url, "
				+ "rb.link, rb.isbn, rb.publisher, rb.description, rb.pub_date "
				+ "FROM reviews r JOIN books rb ON r.book_id = rb.book_id " + "WHERE r.review_id = ?";

		try (Connection conn = DBUtil.getConnection(); PreparedStatement pstmt = conn.prepareStatement(sql)) {

			pstmt.setInt(1, reviewId);
			try (ResultSet rs = pstmt.executeQuery()) {
				if (rs.next()) {
					dto = new ReviewListDisplayDTO();
					dto.setReviewId(rs.getInt("review_id"));
					dto.setUserId(rs.getInt("user_id")); // <<-- int로 변경!
					dto.setReviewText(rs.getString("review_text"));
					dto.setRating(rs.getInt("rating"));
					dto.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
					dto.setUpdatedAt(rs.getTimestamp("updated_at").toLocalDateTime());

					dto.setBookId(rs.getInt("book_id"));
					dto.setIsbn(rs.getString("isbn"));
					dto.setBookTitle(rs.getString("book_title"));
					dto.setBookAuthor(rs.getString("book_author"));
					dto.setBookCoverImageUrl(rs.getString("book_cover_image_url"));
					// ReviewListDisplayDTO에 naver_link 등 추가 필드를 넣었다면 여기서 설정
					// 예: dto.setNaverLink(rs.getString("naver_link"));
				}
			}
		}
		return dto;
	}
}