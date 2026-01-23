package com.greenart.bdproject.mapper;

import java.math.BigDecimal;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.greenart.bdproject.dto.Member;

/**
 * 회원 Mapper 인터페이스
 * MyBatis Mapper XML과 직접 연결
 */
@Mapper
public interface MemberMapper {

    // 회원 등록
    int insert(Member m);

    // 이메일로 회원 조회
    Member select(String email);

    // 회원 삭제 (소프트 삭제)
    int delete(String email);

    // 회원 정보 수정
    int update(Member m);

    // 전체 회원 삭제
    int deleteAll();

    // 전체 회원 조회
    List<Member> selectAll();

    // 선행 온도 조회
    BigDecimal getKindnessTemperature(String userId);

    // 선행 온도 업데이트
    int updateKindnessTemperature(@Param("userId") String userId, @Param("temperature") BigDecimal temperature);

    // 선행 온도 증가
    int increaseKindnessTemperature(@Param("userId") String userId, @Param("amount") BigDecimal amount);

    // 선행 온도 감소
    int decreaseKindnessTemperature(@Param("userId") String userId, @Param("amount") BigDecimal amount);

    // 이름과 이메일로 회원 찾기
    Member findByNameAndEmail(@Param("name") String name, @Param("email") String email);

    // 이름과 전화번호로 회원 찾기
    Member findByNameAndPhone(@Param("name") String name, @Param("phone") String phone);

    // 이메일로 회원 확인
    Member findByEmail(String email);

    // 이메일 중복 확인
    int countByEmail(String email);

    // 프로필 이미지 업데이트
    int updateProfileImage(@Param("email") String email, @Param("imageUrl") String imageUrl);

    // 프로필 정보 업데이트
    int updateProfile(Member m);

    // 이메일 존재 여부 확인 (활성 계정)
    boolean existsByEmail(String email);

    // 삭제된 계정 조회
    Member selectDeleted(String email);

    // 계정 재활성화
    int reactivateAccount(Member member);

    // 로그인 실패 횟수 초기화
    int resetLoginFailCount(String email);

    // 로그인 실패 횟수 증가
    int incrementLoginFailCount(String email);

    // 계정 잠금 (분 단위)
    int lockAccount(@Param("email") String email, @Param("minutes") int minutes);

    // 아이디와 보안 질문 답변으로 회원 찾기
    Member findByIdAndSecurityAnswer(@Param("email") String email, @Param("securityAnswer") String securityAnswer);

    // 이메일로 member_id 조회
    Long findMemberIdByEmail(String email);
}
