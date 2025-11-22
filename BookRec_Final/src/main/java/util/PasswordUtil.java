package util;

import org.mindrot.jbcrypt.BCrypt; // BCrypt 라이브러리 추가 필요

public class PasswordUtil {
    // 비밀번호 해싱 (회원가입 시 사용)
    public static String hashPassword(String plainPassword) {
        return BCrypt.hashpw(plainPassword, BCrypt.gensalt());
    }

    // 비밀번호 검증 (로그인, 회원탈퇴, 비밀번호 변경 시 사용)
    public static boolean checkPassword(String plainPassword, String hashedPassword) {
        // 입력된 평문 비밀번호와 저장된 해싱된 비밀번호를 비교
        return BCrypt.checkpw(plainPassword, hashedPassword);
    }
}