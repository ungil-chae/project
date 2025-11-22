package com.greenart.bdproject.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.greenart.bdproject.dao.MemberDao;
import com.greenart.bdproject.dao.NoticeDao;
import com.greenart.bdproject.dto.Member;
import com.greenart.bdproject.dto.NoticeDto;

@Service
@Transactional
public class NoticeService {

    @Autowired
    private NoticeDao noticeDao;

    @Autowired
    private MemberDao memberDao;

    /**
     * 공지사항 등록 (관리자만 가능)
     * @param notice 공지사항 정보
     * @param userId 작성자 ID
     * @return 등록된 공지사항 정보
     * @throws Exception 관리자 권한이 없을 경우
     */
    public NoticeDto createNotice(NoticeDto notice, String userId) throws Exception {
        // 관리자 권한 체크
        Member member = memberDao.select(userId);
        if (member == null || !"ADMIN".equals(member.getRole())) {
            throw new Exception("공지사항 작성 권한이 없습니다. 관리자만 작성할 수 있습니다.");
        }

        notice.setAdminId(userId);
        int result = noticeDao.insert(notice);

        if (result > 0) {
            return noticeDao.selectById(notice.getNoticeId());
        }

        return null;
    }

    /**
     * 공지사항 조회 (조회수 자동 증가)
     * @param noticeId 공지사항 ID
     * @return 공지사항 정보
     */
    public NoticeDto getNoticeById(Long noticeId) {
        // 조회수 증가
        noticeDao.incrementViews(noticeId);

        return noticeDao.selectById(noticeId);
    }

    /**
     * 전체 공지사항 조회
     * @return 전체 공지사항 리스트
     */
    public List<NoticeDto> getAllNotices() {
        return noticeDao.selectAll();
    }

    /**
     * 상단 고정 공지사항 조회
     * @return 상단 고정 공지사항 리스트
     */
    public List<NoticeDto> getPinnedNotices() {
        return noticeDao.selectPinned();
    }

    /**
     * 공지사항 수정 (관리자만 가능)
     * @param notice 수정할 공지사항 정보
     * @param userId 수정 요청자 ID
     * @return 성공 여부
     * @throws Exception 관리자 권한이 없을 경우
     */
    public boolean updateNotice(NoticeDto notice, String userId) throws Exception {
        // 관리자 권한 체크
        Member member = memberDao.select(userId);
        if (member == null || !"ADMIN".equals(member.getRole())) {
            throw new Exception("공지사항 수정 권한이 없습니다. 관리자만 수정할 수 있습니다.");
        }

        int result = noticeDao.update(notice);
        return result > 0;
    }

    /**
     * 공지사항 삭제 (관리자만 가능)
     * @param noticeId 삭제할 공지사항 ID
     * @param userId 삭제 요청자 ID
     * @return 성공 여부
     * @throws Exception 관리자 권한이 없을 경우
     */
    public boolean deleteNotice(Long noticeId, String userId) throws Exception {
        // 관리자 권한 체크
        Member member = memberDao.select(userId);
        if (member == null || !"ADMIN".equals(member.getRole())) {
            throw new Exception("공지사항 삭제 권한이 없습니다. 관리자만 삭제할 수 있습니다.");
        }

        int result = noticeDao.deleteById(noticeId);
        return result > 0;
    }
}
