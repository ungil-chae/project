package com.greenart.bdproject.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.cache.annotation.CacheEvict;
import org.springframework.cache.annotation.Cacheable;
import org.springframework.cache.annotation.Caching;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.greenart.bdproject.mapper.MemberMapper;
import com.greenart.bdproject.mapper.NoticeMapper;
import com.greenart.bdproject.dto.Member;
import com.greenart.bdproject.dto.NoticeDto;

@Service
@Transactional
public class NoticeService {

    @Autowired
    private NoticeMapper noticeMapper;

    @Autowired
    private MemberMapper memberMapper;

    /**
     * 공지사항 등록 (관리자만 가능)
     * @param notice 공지사항 정보
     * @param userId 작성자 ID
     * @return 등록된 공지사항 정보
     * @throws Exception 관리자 권한이 없을 경우
     */
    @Caching(evict = {
        @CacheEvict(value = "allNotices", allEntries = true),
        @CacheEvict(value = "pinnedNotices", allEntries = true)
    })
    public NoticeDto createNotice(NoticeDto notice, String userId) throws Exception {
        // 관리자 권한 체크
        Member member = memberMapper.select(userId);
        if (member == null || !"ADMIN".equals(member.getRole())) {
            throw new Exception("공지사항 작성 권한이 없습니다. 관리자만 작성할 수 있습니다.");
        }

        notice.setAdminId(userId);
        int result = noticeMapper.insert(notice);

        if (result > 0) {
            return noticeMapper.selectById(notice.getNoticeId().intValue());
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
        noticeMapper.incrementViews(noticeId.intValue());

        return noticeMapper.selectById(noticeId.intValue());
    }

    /**
     * 전체 공지사항 조회 (캐시 적용)
     * @return 전체 공지사항 리스트
     */
    @Cacheable(value = "allNotices")
    public List<NoticeDto> getAllNotices() {
        return noticeMapper.selectAll();
    }

    /**
     * 상단 고정 공지사항 조회 (캐시 적용)
     * @return 상단 고정 공지사항 리스트
     */
    @Cacheable(value = "pinnedNotices")
    public List<NoticeDto> getPinnedNotices() {
        return noticeMapper.selectPinned();
    }

    /**
     * 공지사항 수정 (관리자만 가능)
     * @param notice 수정할 공지사항 정보
     * @param userId 수정 요청자 ID
     * @return 성공 여부
     * @throws Exception 관리자 권한이 없을 경우
     */
    @Caching(evict = {
        @CacheEvict(value = "allNotices", allEntries = true),
        @CacheEvict(value = "pinnedNotices", allEntries = true)
    })
    public boolean updateNotice(NoticeDto notice, String userId) throws Exception {
        // 관리자 권한 체크
        Member member = memberMapper.select(userId);
        if (member == null || !"ADMIN".equals(member.getRole())) {
            throw new Exception("공지사항 수정 권한이 없습니다. 관리자만 수정할 수 있습니다.");
        }

        int result = noticeMapper.update(notice);
        return result > 0;
    }

    /**
     * 공지사항 삭제 (관리자만 가능)
     * @param noticeId 삭제할 공지사항 ID
     * @param userId 삭제 요청자 ID
     * @return 성공 여부
     * @throws Exception 관리자 권한이 없을 경우
     */
    @Caching(evict = {
        @CacheEvict(value = "allNotices", allEntries = true),
        @CacheEvict(value = "pinnedNotices", allEntries = true)
    })
    public boolean deleteNotice(Long noticeId, String userId) throws Exception {
        // 관리자 권한 체크
        Member member = memberMapper.select(userId);
        if (member == null || !"ADMIN".equals(member.getRole())) {
            throw new Exception("공지사항 삭제 권한이 없습니다. 관리자만 삭제할 수 있습니다.");
        }

        int result = noticeMapper.deleteById(noticeId.intValue());
        return result > 0;
    }
}
