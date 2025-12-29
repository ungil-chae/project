package service;

import dao.CelebRecommendationsDao; // <-- 여기를 복수형으로 맞춰야 합니다.
import dao.CelebRecommendedBooksDao;
import model.CelebRecommendation;
import model.CelebRecommendedBook;
import dto.CelebRecommendationResponse;
import dto.CelebRecommendedBookResponse;
import java.sql.SQLException;
import java.util.List;
import java.util.stream.Collectors;

// CelebRecommendationException 클래스는 별도 파일에 public으로 정의되어 있어야 합니다.
// (예: /src/main/java/service/CelebRecommendationException.java)
/*
package service;
import java.io.Serializable;
public class CelebRecommendationException extends Exception implements Serializable {
    private static final long serialVersionUID = 1L;
    private String code;
    public CelebRecommendationException(String code, String message) {
        super(message);
        this.code = code;
    }
    public String getCode() { return code; }
}
*/

public class CelebRecommendationService {
    // 필드 선언 시 DAO 이름을 복수형으로 변경합니다.
    private CelebRecommendationsDao celebRecommendationDao; // <-- 여기가 핵심
    private CelebRecommendedBooksDao celebRecommendedBookDao;

    // 생성자 매개변수 타입도 DAO 이름을 복수형으로 변경합니다.
    public CelebRecommendationService(CelebRecommendationsDao celebRecommendationDao, // <-- 여기가 핵심
                                      CelebRecommendedBooksDao celebRecommendedBookDao) {
        this.celebRecommendationDao = celebRecommendationDao;
        this.celebRecommendedBookDao = celebRecommendedBookDao;
    }

    /**
     * 모든 셀럽 추천 목록을 조회합니다.
     * @return 셀럽 추천 응답 DTO 리스트
     * @throws SQLException DB 오류 시
     */
    public List<CelebRecommendationResponse> getAllCelebRecommendations() throws SQLException {
        // DAO가 model.CelebRecommendation을 반환한다고 가정합니다.
        List<CelebRecommendation> models = celebRecommendationDao.getAllCelebRecommendations();
        return models.stream()
                     .map(CelebRecommendationResponse::fromModel) // Model -> DTO 변환
                     .collect(Collectors.toList());
    }

    /**
     * 새로운 셀럽 추천 글과 포함된 책들을 생성합니다.
     * @param celeb Recommendation 모델 (이름, 설명, 이미지 URL)
     * @param recommendedBookIds 추천할 책 ID 리스트 (순서대로)
     * @return 생성된 셀럽 추천 응답 DTO
     * @throws SQLException DB 오류 시
     * @throws CelebRecommendationException 유효성 검증 실패 또는 생성 실패 시
     */
    public CelebRecommendationResponse createCelebRecommendation(
        CelebRecommendation celeb, List<Integer> recommendedBookIds)
        throws SQLException, CelebRecommendationException {

        // 1. 유효성 검증
        if (celeb.getCelebName() == null || celeb.getCelebName().trim().isEmpty() ||
            celeb.getCelebDescription() == null || celeb.getCelebDescription().trim().isEmpty()) {
            throw new CelebRecommendationException("INVALID_INPUT", "셀럽 이름과 설명은 필수입니다.");
        }
        if (recommendedBookIds == null || recommendedBookIds.isEmpty()) {
            throw new CelebRecommendationException("NO_BOOKS_RECOMMENDED", "추천할 책을 최소 1권 선택해야 합니다.");
        }

        // 2. 셀럽 추천 글 생성 (DAO 호출)
        CelebRecommendation createdCeleb = celebRecommendationDao.createCelebRecommendation(celeb);
        if (createdCeleb == null) {
            throw new CelebRecommendationException("CREATE_FAILED", "셀럽 추천 글 생성에 실패했습니다.");
        }

        // 3. 추천된 책들 추가 (CelebRecommendedBookDao 호출)
        int order = 1;
        for (Integer bookId : recommendedBookIds) {
            // CelebRecommendedBook 모델을 직접 생성하여 DAO에 전달
            CelebRecommendedBook recommendedBook = new CelebRecommendedBook(0, createdCeleb.getCelebRecId(), bookId, order++);
            boolean success = celebRecommendedBookDao.addRecommendedBook(recommendedBook);
            if (!success) {
                System.err.println("Warning: Failed to add recommended book " + bookId + " for celeb " + createdCeleb.getCelebRecId());
            }
        }

        return CelebRecommendationResponse.fromModel(createdCeleb);
    }

    /**
     * 특정 셀럽 추천의 상세 정보를 조회합니다.
     * @param celebRecId 조회할 셀럽 추천 ID
     * @return CelebRecommendation 모델 (DAO에서 직접 Model을 반환)
     * @throws SQLException DB 오류 시
     * @throws CelebRecommendationException 추천 글을 찾을 수 없을 때
     */
    public CelebRecommendation getCelebRecommendationDetail(int celebRecId) throws SQLException, CelebRecommendationException {
        CelebRecommendation celeb = celebRecommendationDao.getCelebRecommendationById(celebRecId);
        if (celeb == null) {
            throw new CelebRecommendationException("NOT_FOUND", "해당 셀럽 추천 글을 찾을 수 없습니다.");
        }
        return celeb;
    }

    /**
     * 특정 셀럽 추천에 포함된 책 목록을 조회합니다.
     * @param celebRecId 셀럽 추천 ID
     * @return 추천된 책 목록 DTO 리스트
     * @throws SQLException DB 오류 시
     */
    public List<CelebRecommendedBookResponse> getRecommendedBooksForCeleb(int celebRecId) throws SQLException {
        // DAO에서 이미 DTO로 변환하여 반환하므로 바로 리턴
        return celebRecommendedBookDao.getRecommendedBooksByCelebRecId(celebRecId);
    }

    /**
     * 특정 셀럽 추천 글을 삭제합니다.
     * @param celebRecId 삭제할 셀럽 추천 ID
     * @return 성공 시 true
     * @throws SQLException DB 오류 시
     * @throws CelebRecommendationException 글을 찾을 수 없거나 삭제 실패 시
     */
    public boolean deleteCelebRecommendation(int celebRecId) throws SQLException, CelebRecommendationException {
        CelebRecommendation existingCeleb = celebRecommendationDao.getCelebRecommendationById(celebRecId);
        if (existingCeleb == null) {
            throw new CelebRecommendationException("NOT_FOUND", "삭제할 셀럽 추천 글을 찾을 수 없습니다.");
        }

        boolean success = celebRecommendationDao.deleteCelebRecommendation(celebRecId);
        if (!success) {
            throw new CelebRecommendationException("DELETE_FAILED", "셀럽 추천 글 삭제에 실패했습니다.");
        }
        return true;
    }
}