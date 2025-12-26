package util;

import java.time.LocalDateTime;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement; // PreparedStatement를 닫기 위해 추가
import java.sql.ResultSet;         // ResultSet을 닫기 위해 추가
import java.sql.SQLException;

public class DBUtil {
    // 지금은 로컬 테스트를 위해 여기에 직접 입력
	private static final String JDBC_URL = "jdbc:mysql://localhost:3306/book_recommendation_db?serverTimezone=UTC&useSSL=false&characterEncoding=UTF-8&useUnicode=true&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "1709"; // 여러분의 실제 비밀번호

    // JDBC 드라이버 로드 (클래스가 로드될 때 한 번만 실행)
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("MySQL JDBC Driver loaded."); // 드라이버 로드 확인용
        } catch (ClassNotFoundException e) {
            System.err.println("MySQL JDBC Driver not found! Please check your JAR file in WEB-INF/lib.");
            e.printStackTrace();
            throw new RuntimeException("Failed to load MySQL JDBC Driver", e);
        }
    }

    /**
     * 데이터베이스 연결(Connection) 객체를 반환합니다.
     * @return 데이터베이스 연결 객체
     * @throws SQLException SQL 연결 중 오류 발생 시
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(JDBC_URL, USER, PASSWORD);
    }

    /**
     * JDBC 관련 자원(Connection)을 안전하게 닫습니다.
     * @param conn 닫을 Connection 객체
     */
    public static void close(Connection conn) {
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                System.err.println("Error closing connection: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    /**
     * JDBC 관련 자원(PreparedStatement)을 안전하게 닫습니다.
     * @param pstmt 닫을 PreparedStatement 객체
     */
    public static void close(PreparedStatement pstmt) {
        if (pstmt != null) {
            try {
                pstmt.close();
            } catch (SQLException e) {
                System.err.println("Error closing prepared statement: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    /**
     * JDBC 관련 자원(ResultSet)을 안전하게 닫습니다.
     * @param rs 닫을 ResultSet 객체
     */
    public static void close(ResultSet rs) {
        if (rs != null) {
            try {
                rs.close();
            } catch (SQLException e) {
                System.err.println("Error closing result set: " + e.getMessage());
                e.printStackTrace();
            }
        }
    }

    // DB 연결 테스트를 위한 main 메서드 (유지)
    public static void main(String[] args) {
        Connection conn = null;
        try {
            System.out.println("데이터베이스 연결을 시도합니다...");
            conn = DBUtil.getConnection(); // DBUtil의 getConnection() 호출
            if (conn != null) {
                System.out.println("데이터베이스 연결 성공!");
            } else {
                System.out.println("데이터베이스 연결 실패: Connection이 null입니다.");
            }
        } catch (SQLException e) {
            System.err.println("데이터베이스 연결 중 SQL 예외 발생: " + e.getMessage());
            e.printStackTrace();
        } catch (Exception e) {
            System.err.println("데이터베이스 연결 중 알 수 없는 예외 발생: " + e.getMessage());
            e.printStackTrace();
        } finally {
            DBUtil.close(conn); // 연결 자원 해제
            System.out.println("데이터베이스 연결 자원을 해제했습니다.");
        }
    }
}