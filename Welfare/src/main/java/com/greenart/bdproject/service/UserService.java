package com.greenart.bdproject.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.greenart.bdproject.dao.UserDao;
import com.greenart.bdproject.dto.UserDto;

@Service
@Transactional
public class UserService {

    @Autowired
    private UserDao userDao;

    /**
     * 로그인 처리 (비밀번호 검증)
     * @param username 사용자명
     * @param password 비밀번호
     * @return 로그인 성공 시 UserDto, 실패 시 null
     */
    public UserDto login(String username, String password) {
        UserDto user = userDao.selectByUsername(username);

        if (user == null) {
            return null;
        }

        // 비밀번호 검증 (실제 프로젝트에서는 BCrypt 사용 권장)
        if (user.getPassword() != null && user.getPassword().equals(password)) {
            return user;
        }

        return null;
    }

    /**
     * 회원가입 처리
     * @param user 가입할 사용자 정보
     * @return 등록된 사용자 정보
     */
    public UserDto register(UserDto user) {
        int result = userDao.insert(user);

        if (result > 0) {
            return userDao.selectByUsername(user.getUsername());
        }

        return null;
    }

    /**
     * 사용자 ID로 조회
     * @param userId 사용자 ID
     * @return 사용자 정보
     */
    public UserDto getUserById(Long userId) {
        return userDao.selectById(userId);
    }

    /**
     * 사용자명으로 조회
     * @param username 사용자명
     * @return 사용자 정보
     */
    public UserDto getUserByUsername(String username) {
        return userDao.selectByUsername(username);
    }

    /**
     * 사용자 정보 수정
     * @param user 수정할 사용자 정보
     * @return 성공 여부
     */
    public boolean updateUser(UserDto user) {
        int result = userDao.update(user);
        return result > 0;
    }

    /**
     * 관리자 권한 체크
     * @param userId 사용자 ID
     * @return 관리자 여부
     */
    public boolean isAdmin(Long userId) {
        UserDto user = userDao.selectById(userId);

        if (user == null) {
            return false;
        }

        return "ADMIN".equals(user.getRole());
    }
}
