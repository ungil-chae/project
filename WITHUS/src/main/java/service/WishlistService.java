package service;

import java.sql.SQLException;
import java.util.List;
import java.util.Set;

import dao.BookDao;
import dao.WishlistDao;
import dto.WishlistItemResponse;

/**
 * 위시리스트(찜) 관련 비즈니스 로직을 처리하는 서비스 클래스
 */
public class WishlistService {

    private final WishlistDao wishlistDao = new WishlistDao();
    private final BookDao bookDao = new BookDao(); // BookDao 인스턴스 추가
    
    /**
     * 사용자의 찜 상태를 토글합니다. (추가 또는 삭제)
     *
     * @param userId  로그인한 사용자 ID
     * @param bookId  대상 도서 ID
     * @return        토글 후의 찜 상태 (찜 된 상태면 true, 해제된 상태면 false)
     * @throws SQLException 데이터베이스 처리 중 발생하는 예외
     */
    public boolean toggleWishlist(int userId, int bookId) throws SQLException {
        // isBookInWishlist를 호출하여 이미 찜한 책인지 확인합니다.
        if (wishlistDao.isBookInWishlist(userId, bookId)) {
            wishlistDao.removeWishlist(userId, bookId);
            return false; // '해제됨'을 의미
        } else {
            wishlistDao.addWishlist(userId, bookId);
            return true;  // '추가됨'을 의미
        }
    }

    /**
     * 로그인 사용자의 전체 찜 목록을 상세 정보와 함께 조회합니다.
     *
     * @param userId 사용자 ID
     * @return       찜한 도서의 상세 정보가 담긴 WishlistItemResponse 리스트
     * @throws SQLException 데이터베이스 처리 중 발생하는 예외
     */
    public List<WishlistItemResponse> list(int userId) throws SQLException {
        // DAO에 요청을 그대로 위임하여 전체 찜 목록을 가져옵니다.
        return wishlistDao.getWishlistsByUserId(userId);
    }

    /**
     * 로그인 사용자의 찜 목록에 포함된 도서들의 ID만 조회합니다. (효율적인 찜 상태 확인용)
     *
     * @param userId 사용자 ID
     * @return       찜한 도서의 ID(book_id)가 담긴 Set
     * @throws SQLException 데이터베이스 처리 중 발생하는 예외
     */
    public Set<Integer> getWishlistBookIds(int userId) throws SQLException {
        // DAO에 요청을 그대로 위임하여 찜한 도서의 ID 목록만 가져옵니다.
        return wishlistDao.getWishlistBookIdsByUserId(userId);
    }

    /* --------------------------------------------------------------
       ⬇️  호환성 유지를 위한 @Deprecated 메서드입니다.
     -------------------------------------------------------------- */
    @Deprecated
    public boolean toggle(int userId, int bookId) throws SQLException {
        return toggleWishlist(userId, bookId);
    }
    
 // [추가] 특정 셀럽의 모든 책을 찜 목록에 추가합니다.
    public void addAllCelebBooksToWishlist(int userId, String celebCategory) throws SQLException {
        // 1. 셀럽 카테고리에 해당하는 책 ID 목록을 가져옵니다.
        List<Integer> bookIds = bookDao.findBookIdsByCategory(celebCategory);
        if (bookIds.isEmpty()) {
            return; // 추가할 책이 없으면 종료
        }
        // 2. 해당 책들을 일괄적으로 찜 목록에 추가합니다.
        wishlistDao.addBooksToWishlist(userId, bookIds);
    }

    // [추가] 특정 셀럽의 모든 책을 찜 목록에서 삭제합니다.
    public void removeAllCelebBooksFromWishlist(int userId, String celebCategory) throws SQLException {
        // 1. 셀럽 카테고리에 해당하는 책 ID 목록을 가져옵니다.
        List<Integer> bookIds = bookDao.findBookIdsByCategory(celebCategory);
        if (bookIds.isEmpty()) {
            return; // 삭제할 책이 없으면 종료
        }
        // 2. 해당 책들을 일괄적으로 찜 목록에서 삭제합니다.
        wishlistDao.removeBooksFromWishlist(userId, bookIds);
    }
    
    // [추가] 특정 셀럽의 모든 책이 찜 되었는지 확인합니다. (전체 북마크 상태 결정용)
    public boolean areAllCelebBooksWishlisted(int userId, String celebCategory) throws SQLException {
        List<Integer> bookIds = bookDao.findBookIdsByCategory(celebCategory);
        if (bookIds.isEmpty()) {
            return false; // 추천 책이 없으면 false
        }
        int wishlistedCount = wishlistDao.countWishlistedBooks(userId, bookIds);
        return wishlistedCount == bookIds.size(); // 찜한 개수와 전체 개수가 같으면 true
    }
}