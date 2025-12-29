package service;

import java.sql.SQLException;
import java.util.List;

import dao.BookDao;
import model.Book;

/**
 * 비즈니스 로직 계층. <br>
 *  - 트랜잭션 묶음이 필요하면 여기서 Connection 제어<br>
 *  - 지금은 단순 read-only 이라 DAO 호출만 래핑
 */
public class BookService {

    private final BookDao bookDao = new BookDao();

    /** 카테고리(장르) 목록 가져오기 */
    public List<Book> getBooksByCategory(String category) {
        try {
            return bookDao.findByCategory(category);
        } catch (SQLException e) {
            throw new RuntimeException("DB 오류: 카테고리 조회 실패", e);
        }
    }

    /** ID 여러 개로 조회 */
    public List<Book> getBooksByIds(List<Integer> ids) {
        try {
            return bookDao.findByIds(ids);
        } catch (SQLException e) {
            throw new RuntimeException("DB 오류: ID 다건 조회 실패", e);
        }
    }

    /** 단건 조회 */
    public Book getBookById(int bookId) {
        try {
            return bookDao.findById(bookId);
        } catch (SQLException e) {
            throw new RuntimeException("DB 오류: 단건 조회 실패", e);
        }
    }
}
