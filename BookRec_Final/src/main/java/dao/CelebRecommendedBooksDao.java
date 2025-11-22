package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

// import dto.CelebRecommendedBooks; // <-- 이 DTO는 더 이상 이 DAO에서 직접 사용하지 않습니다.
import model.CelebRecommendedBook; // <-- Model 객체를 다루도록 변경합니다.
import dto.CelebRecommendedBookResponse; // 클라이언트로 보낼 응답 DTO 임포트 (get 메서드에서 사용)
import util.DBUtil;

public class CelebRecommendedBooksDao {

    public CelebRecommendedBooksDao() {
        // DBUtil을 통해 Connection을 얻으므로, 생성자에서 Connection을 받을 필요가 없습니다.
    }

    /**
     * 특정 셀럽 추천에 책을 추가합니다.
     * 이 메서드는 `model.CelebRecommendedBook` 객체를 받아 DB에 삽입합니다.
     *
     * @param celebRecBook 추가할 `model.CelebRecommendedBook` 객체 (매개변수 타입 변경!)
     * @return 성공 시 true
     * @throws SQLException DB 오류 시
     */
    public boolean addRecommendedBook(CelebRecommendedBook celebRecBook) throws SQLException { // <-- 매개변수 타입 변경!
        String sql = "INSERT INTO CelebRecommendedBooks (celeb_rec_id, book_id, order_in_rec) VALUES (?, ?, ?)";
        Connection conn = null;
        PreparedStatement pstmt = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            // Model의 camelCase Getter에 맞춰 값을 설정
            pstmt.setInt(1, celebRecBook.getCelebRecId());
            pstmt.setInt(2, celebRecBook.getBookId());
            pstmt.setInt(3, celebRecBook.getOrderInRec());
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        } finally {
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
    }

    /**
     * 셀럽 ID로 추천한 책 목록을 가져옵니다.
     * 책 상세 정보(제목, 저자, 커버 이미지)를 포함하여 `CelebRecommendedBookResponse` DTO 리스트로 반환합니다.
     *
     * @param celebRecId 조회할 셀럽 추천 ID
     * @return 추천된 책 목록 (CelebRecommendedBookResponse DTO)
     * @throws SQLException DB 오류 시
     */
    public List<CelebRecommendedBookResponse> getRecommendedBooksByCelebRecId(int celebRecId) throws SQLException {
        List<CelebRecommendedBookResponse> list = new ArrayList<>();
        String sql = "SELECT crb.celeb_rec_book_id, crb.celeb_rec_id, crb.book_id, crb.order_in_rec, " +
                     "b.title, b.author, b.cover_image_url " +
                     "FROM CelebRecommendedBooks crb JOIN Books b ON crb.book_id = b.book_id " +
                     "WHERE crb.celeb_rec_id = ? ORDER BY crb.order_in_rec ASC";
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;

        try {
            conn = DBUtil.getConnection();
            pstmt = conn.prepareStatement(sql);
            pstmt.setInt(1, celebRecId);
            rs = pstmt.executeQuery();

            while (rs.next()) {
                int bookId = rs.getInt("book_id");
                String title = rs.getString("title");
                String author = rs.getString("author");
                String coverImageUrl = rs.getString("cover_image_url");
                int orderInRec = rs.getInt("order_in_rec");
                
                list.add(new CelebRecommendedBookResponse(bookId, title, author, coverImageUrl, orderInRec));
            }
        } finally {
            DBUtil.close(rs);
            DBUtil.close(pstmt);
            DBUtil.close(conn);
        }
        return list;
    }
}