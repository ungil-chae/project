package service;

import dao.ReviewBookDAO;
import dao.ReviewDAO;
import dao.ContentBlockDAO;
import model.Review;
import model.ReviewBook;
import model.ContentBlock; // ContentBlock 모델 임포트
import dto.ReviewListDisplayDTO;
import dto.ReviewDetailDisplayDTO;

import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

public class ReviewService {
	private final ReviewBookDAO reviewBookDAO = new ReviewBookDAO();
	private final ReviewDAO reviewDAO = new ReviewDAO();
	private final ContentBlockDAO contentBlockDAO = new ContentBlockDAO();

	/**
	 * 특정 사용자가 작성한 모든 리뷰와 그에 해당하는 책 정보를 가져옵니다. 마이페이지 '리뷰 관리' 섹션에서 사용됩니다.
	 * 
	 * @param userId 조회할 사용자의 ID
	 * @return ReviewListDisplayDTO 객체들의 리스트
	 * @throws SQLException DB 오류 시
	 */
	public List<ReviewListDisplayDTO> getMyReviewsForDisplay(int userId) throws SQLException {
		return reviewDAO.getReviewsByUserIdWithBookInfo(userId);
	}

	// (기존 submitReview, getAllReviewsForDisplay, getReviewDetailWithContentBlocks,
	// deleteReview 메서드들은 여기에 그대로 있다고 가정합니다.)

	/**
	 * 리뷰를 수정하는 서비스 메서드.
	 * 
	 * @param reviewId          수정할 리뷰의 ID
	 * @param callingUserId     수정을 요청한 사용자 ID (권한 확인용)
	 * @param updatedReviewText 수정된 리뷰 내용
	 * @param updatedRating     수정된 별점
	 * @return 수정 성공 여부 (true: 성공, false: 실패 또는 권한 없음)
	 * @throws SQLException DB 작업 중 오류 발생 시
	 */
	public boolean updateReview(int reviewId, int callingUserId, String updatedReviewText, int updatedRating)
			throws SQLException {
		// 1. 수정 권한 확인
		// 현재 리뷰의 작성자가 수정을 요청한 사용자인지 확인합니다.
		ReviewListDisplayDTO existingReview = reviewDAO.getReviewByIdWithBookInfo(reviewId);
		if (existingReview == null) {
			System.out.println("Review with ID " + reviewId + " not found for update.");
			return false; // 리뷰가 존재하지 않음
		}
		if (existingReview.getUserId() != callingUserId) {
			System.out.println("User " + callingUserId + " does not have permission to update review " + reviewId);
			return false; // 권한 없음
		}

		// 2. reviews 테이블 업데이트
		Review reviewToUpdate = new Review();
		reviewToUpdate.setReviewId(reviewId);
		reviewToUpdate.setReviewText(updatedReviewText);
		reviewToUpdate.setRating(updatedRating);
		// updated_at은 DAO에서 자동으로 설정됩니다.
		int updatedRows = reviewDAO.update(reviewToUpdate);

		if (updatedRows == 0) {
			System.out.println("Failed to update review entry in 'reviews' table for ID " + reviewId);
			return false; // 업데이트 실패
		}

		// 3. ContentBlock 업데이트 (간단하게 기존 블록 삭제 후 새 텍스트 블록 삽입)
		// 먼저 기존 ContentBlock들을 삭제합니다.
		int contentBlocksDeleted = contentBlockDAO.deleteByReviewId(reviewId);
		System.out.println(contentBlocksDeleted + " old content blocks deleted for review ID " + reviewId);

		// 새 ContentBlock (텍스트 타입)을 삽입합니다.
		ContentBlock newTextBlock = new ContentBlock();
		newTextBlock.setReviewId(reviewId);
		newTextBlock.setBlockType("text");
		newTextBlock.setBlockOrder(1); // 첫 번째 블록으로 설정
		newTextBlock.setTextContent(updatedReviewText);
		newTextBlock.setImageUrl(""); // 텍스트 블록이므로 이미지 URL은 비워둠

		int newBlockId = contentBlockDAO.insert(newTextBlock);
		if (newBlockId == -1) {
			// ContentBlock 삽입 실패 (심각한 경우, 리뷰 본체는 업데이트되었는데 블록이 없으면 문제)
			System.err.println("Failed to insert new text content block for review ID " + reviewId);
			// 이 경우, 트랜잭션을 사용하여 롤백하는 것이 이상적이지만, 현재는 간단히 처리합니다.
			return false;
		}
		System.out.println("New content block inserted for review ID " + reviewId + ", block_id: " + newBlockId);

		return true; // 최종 업데이트 성공
	}

	// (기존 submitReview, getAllReviewsForDisplay, getReviewDetailWithContentBlocks,
	// deleteReview 메서드들은 여기에 그대로 있다고 가정합니다.)
	public int submitReview(int userId, ReviewBook reviewBookData, String reviewText, int rating) throws SQLException {
		// ... (기존 submitReview 메서드 구현) ...
		int bookId;
		ReviewBook existingBook = reviewBookDAO.findByIsbn(reviewBookData.getIsbn());

		if (existingBook != null) {
			bookId = existingBook.getBookId();
		} else {
			bookId = reviewBookDAO.insert(reviewBookData);
			if (bookId == -1) {
				return -1;
			}
		}

		Review review = new Review();
		review.setUserId(userId);
		review.setBookId(bookId);
		review.setReviewText(reviewText);
		review.setRating(rating);
		review.setCreatedAt(LocalDateTime.now());
		review.setUpdatedAt(LocalDateTime.now());

		int reviewId = reviewDAO.insert(review);
		// submitReview에서 content_blocks에 저장하는 로직이 빠져 있었습니다. 여기서 추가합니다.
		if (reviewId > 0) {
			ContentBlock initialTextBlock = new ContentBlock();
			initialTextBlock.setReviewId(reviewId);
			initialTextBlock.setBlockType("text");
			initialTextBlock.setBlockOrder(1);
			initialTextBlock.setTextContent(reviewText);
			initialTextBlock.setImageUrl(""); // 초기 텍스트 블록이므로 이미지 없음

			int initialBlockId = contentBlockDAO.insert(initialTextBlock);
			if (initialBlockId == -1) {
				System.err.println("Initial content block insertion failed for new review ID: " + reviewId);
				// 이 경우, 리뷰 본체를 롤백하거나 (트랜잭션 필요), 관리자에게 알림 등의 처리가 필요합니다.
				// 현재는 간단히 오류로 반환합니다.
				// reviewDAO.delete(reviewId); // 삽입된 review 본체를 롤백하는 예시 (트랜잭션 없이)
				return -1;
			}
		}
		return reviewId;
	}

	public List<ReviewListDisplayDTO> getAllReviewsForDisplay() throws SQLException {
		return reviewDAO.getAllReviewsWithBookInfo();
	}

	public ReviewDetailDisplayDTO getReviewDetailWithContentBlocks(int reviewId) throws SQLException {
		ReviewListDisplayDTO listDisplayDto = reviewDAO.getReviewByIdWithBookInfo(reviewId);
		if (listDisplayDto == null) {
			return null;
		}
		List<ContentBlock> contentBlocks = contentBlockDAO.findByReviewId(reviewId);

		ReviewDetailDisplayDTO detailDto = new ReviewDetailDisplayDTO();
		detailDto.setReviewId(listDisplayDto.getReviewId());
		detailDto.setUserId(listDisplayDto.getUserId());
		detailDto.setReviewText(listDisplayDto.getReviewText()); // ReviewListDisplayDTO에는 reviewText가 있음
		detailDto.setRating(listDisplayDto.getRating());
		detailDto.setCreatedAt(listDisplayDto.getCreatedAt());
		detailDto.setUpdatedAt(listDisplayDto.getUpdatedAt());
		detailDto.setBookId(listDisplayDto.getBookId());
		detailDto.setIsbn(listDisplayDto.getIsbn());
		detailDto.setBookTitle(listDisplayDto.getBookTitle());
		detailDto.setBookAuthor(listDisplayDto.getBookAuthor());
		detailDto.setBookCoverImageUrl(listDisplayDto.getBookCoverImageUrl());

		detailDto.setContentBlocks(contentBlocks);

		return detailDto;
	}

	public boolean deleteReview(int reviewId, int callingUserId) throws SQLException {
		// ... (기존 deleteReview 메서드 구현) ...
		ReviewListDisplayDTO reviewToDelete = reviewDAO.getReviewByIdWithBookInfo(reviewId);
		if (reviewToDelete == null || reviewToDelete.getUserId() != callingUserId) {
			return false;
		}

		contentBlockDAO.deleteByReviewId(reviewId);
		int reviewsDeleted = reviewDAO.delete(reviewId);
		return reviewsDeleted > 0;
	}

	public ReviewListDisplayDTO getReviewDetailForDisplay(int reviewId) throws SQLException {
		return reviewDAO.getReviewByIdWithBookInfo(reviewId);
	}
}