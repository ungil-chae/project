package com.greenart.bdproject.dao;

import com.greenart.bdproject.dto.FavoriteWelfareServiceDto;
import java.util.List;

/**
 * 즐겨찾기 복지 서비스 DAO 인터페이스
 */
public interface FavoriteWelfareServiceDao {

    /**
     * 즐겨찾기 추가
     * @param favorite 즐겨찾기 정보
     * @return 추가된 행 수
     */
    int insert(FavoriteWelfareServiceDto favorite);

    /**
     * 즐겨찾기 삭제
     * @param memberId 회원 ID
     * @param serviceId 서비스 ID
     * @return 삭제된 행 수
     */
    int delete(Long memberId, String serviceId);

    /**
     * 회원의 모든 즐겨찾기 조회
     * @param memberId 회원 ID
     * @return 즐겨찾기 목록
     */
    List<FavoriteWelfareServiceDto> selectByMemberId(Long memberId);

    /**
     * 특정 서비스가 즐겨찾기에 있는지 확인
     * @param memberId 회원 ID
     * @param serviceId 서비스 ID
     * @return 존재 여부
     */
    boolean exists(Long memberId, String serviceId);

    /**
     * 회원의 즐겨찾기 개수 조회
     * @param memberId 회원 ID
     * @return 즐겨찾기 개수
     */
    int countByMemberId(Long memberId);
}
