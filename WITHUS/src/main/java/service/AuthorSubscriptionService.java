// package service;

package service;

import dao.AuthorSubscriptionDao; // AuthorSubscriptionDao 임포트 추가
import dto.AuthorResponse;
import java.sql.SQLException;
import java.util.List;

public class AuthorSubscriptionService {
    private AuthorSubscriptionDao authorSubscriptionDao;

    // 생성자를 통한 의존성 주입
    public AuthorSubscriptionService(AuthorSubscriptionDao authorSubscriptionDao) {
        this.authorSubscriptionDao = authorSubscriptionDao;
    }

    /**
     * 사용자가 특정 작가를 구독합니다.
     *
     * @param userId 구독할 사용자 ID
     * @param authorId 구독할 작가 ID
     * @return 성공 시 true
     * @throws SQLException 데이터베이스 오류 발생 시
     * @throws AuthorSubscriptionException 이미 구독 중이거나 구독 실패 시
     */
    public boolean subscribeAuthor(int userId, int authorId) throws SQLException, AuthorSubscriptionException {
        // 1. 이미 구독 중인지 서비스 계층에서 확인 (DAO의 isAuthorSubscribed 메서드 사용)
        if (authorSubscriptionDao.isAuthorSubscribed(userId, authorId)) {
            throw new AuthorSubscriptionException("ALREADY_SUBSCRIBED", "이미 구독 중인 작가입니다.");
        }

        // 2. DAO를 통해 구독 추가 시도
        boolean success = authorSubscriptionDao.subscribeAuthor(userId, authorId);
        if (!success) {
            throw new AuthorSubscriptionException("SUBSCRIPTION_FAILED", "작가 구독에 실패했습니다.");
        }
        return true;
    }

    /**
     * 사용자가 특정 작가 구독을 취소합니다.
     *
     * @param userId 구독을 취소할 사용자 ID
     * @param authorId 구독 취소할 작가 ID
     * @return 성공 시 true
     * @throws SQLException 데이터베이스 오류 발생 시
     * @throws AuthorSubscriptionException 구독 중이지 않거나 취소 실패 시
     */
    public boolean unsubscribeAuthor(int userId, int authorId) throws SQLException, AuthorSubscriptionException {
        // 1. 구독 중인 작가인지 확인
        if (!authorSubscriptionDao.isAuthorSubscribed(userId, authorId)) {
            throw new AuthorSubscriptionException("NOT_SUBSCRIBED", "구독 중이지 않은 작가입니다.");
        }

        // 2. DAO를 통해 구독 취소 시도
        boolean success = authorSubscriptionDao.unsubscribeAuthor(userId, authorId);
        if (!success) {
            throw new AuthorSubscriptionException("UNSUBSCRIPTION_FAILED", "작가 구독 취소에 실패했습니다.");
        }
        return true;
    }

    /**
     * 특정 사용자가 구독 중인 작가 목록을 조회합니다.
     *
     * @param userId 조회할 사용자 ID
     * @return 구독 중인 작가 항목들의 리스트 (AuthorResponse DTO)
     * @throws SQLException 데이터베이스 오류 발생 시
     */
    public List<AuthorResponse> getMySubscriptions(int userId) throws SQLException {
        // DAO로부터 구독 작가 목록을 직접 반환받습니다.
        return authorSubscriptionDao.getSubscribedAuthorsByUserId(userId);
    }
}