package com.greenart.bdproject.dao;

import java.util.List;
import com.greenart.bdproject.dto.UserDto;

public interface UserDao {

    /**
     * 로그인용 - 사용자명으로 조회
     * @param username 사용자명
     * @return UserDto 사용자 정보
     */
    UserDto selectByUsername(String username);

    /**
     * ID로 사용자 조회
     * @param userId 사용자 ID
     * @return UserDto 사용자 정보
     */
    UserDto selectById(Long userId);

    /**
     * 회원가입 - 사용자 등록
     * @param user 사용자 정보
     * @return int 등록된 행 수
     */
    int insert(UserDto user);

    /**
     * 사용자 정보 수정
     * @param user 수정할 사용자 정보
     * @return int 수정된 행 수
     */
    int update(UserDto user);

    /**
     * 사용자 삭제
     * @param userId 사용자 ID
     * @return int 삭제된 행 수
     */
    int deleteById(Long userId);

    /**
     * 전체 사용자 목록 조회
     * @return List<UserDto> 사용자 목록
     */
    List<UserDto> selectAll();
}
