// package service;

package service;

import dao.InquiryDao;
import dto.InquiryRequest;
import dto.InquiryResponse;
import java.sql.SQLException;
import java.util.List;

// InquiryException 클래스 정의가 이 파일에서 제거되고 별도의 InquiryException.java 파일로 분리되었습니다.

public class InquiryService {
    private InquiryDao inquiryDao;

    // 생성자를 통한 의존성 주입
    public InquiryService(InquiryDao inquiryDao) {
        this.inquiryDao = inquiryDao;
    }

    /**
     * 새로운 문의를 생성합니다.
     *
     * @param userId 문의를 작성하는 사용자 ID
     * @param request 문의 요청 DTO (inquiryType, title, content)
     * @return 생성된 문의의 InquiryResponse 객체
     * @throws SQLException 데이터베이스 오류 발생 시
     * @throws InquiryException 유효성 검증 실패 또는 문의 생성 실패 시
     */
    public InquiryResponse createInquiry(int userId, InquiryRequest request) throws SQLException, InquiryException {
        // 1. DTO 필드 유효성 검증
        if (request.getInquiryType() == null || request.getInquiryType().trim().isEmpty() ||
            request.getTitle() == null || request.getTitle().trim().isEmpty() ||
            request.getContent() == null || request.getContent().trim().isEmpty()) {
            throw new InquiryException("INVALID_INPUT", "문의 유형, 제목, 내용을 모두 입력해주세요.");
        }

        // 선택적으로 문의 유형 유효성 검증 (DB의 ENUM과 일치하는지)
        String[] validInquiryTypes = {"일반", "오류", "제안", "기타"}; // DB의 ENUM 값과 일치해야 함
        boolean isValidType = false;
        for (String type : validInquiryTypes) {
            if (type.equals(request.getInquiryType())) {
                isValidType = true;
                break;
            }
        }
        if (!isValidType) {
            throw new InquiryException("INVALID_TYPE", "유효하지 않은 문의 유형입니다.");
        }

        // 2. DAO를 통해 문의 생성
        InquiryResponse createdInquiry = inquiryDao.createInquiry(userId, request);
        if (createdInquiry == null) {
            throw new InquiryException("CREATE_FAILED", "문의 생성에 실패했습니다. 잠시 후 다시 시도해주세요.");
        }
        return createdInquiry;
    }

    /**
     * 특정 사용자가 작성한 모든 문의 내역을 조회합니다.
     *
     * @param userId 조회할 사용자 ID
     * @return 문의 항목들의 리스트 (InquiryResponse DTO)
     * @throws SQLException 데이터베이스 오류 발생 시
     */
    public List<InquiryResponse> getMyInquiries(int userId) throws SQLException {
        return inquiryDao.getInquiriesByUserId(userId);
    }

    /**
     * 특정 사용자가 작성한 특정 문의의 상세 정보를 조회합니다.
     *
     * @param inquiryId 조회할 문의 ID
     * @param userId    조회할 문의의 사용자 ID (인가 검증용)
     * @return 해당 문의의 InquiryResponse 객체
     * @throws SQLException 데이터베이스 오류 발생 시
     * @throws InquiryException 문의를 찾을 수 없거나 접근 권한이 없을 경우
     */
    public InquiryResponse getMyInquiryDetail(int inquiryId, int userId) throws SQLException, InquiryException {
        InquiryResponse inquiry = inquiryDao.getInquiryByIdAndUserId(inquiryId, userId);
        if (inquiry == null) {
            throw new InquiryException("INQUIRY_NOT_FOUND", "해당 문의를 찾을 수 없거나 접근 권한이 없습니다.");
        }
        return inquiry;
    }
}