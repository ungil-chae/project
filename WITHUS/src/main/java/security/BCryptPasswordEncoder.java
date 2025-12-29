package security;

import org.mindrot.jbcrypt.BCrypt; // jBCrypt 라이브러리 임포트

public class BCryptPasswordEncoder implements PasswordEncoder {

    /**
     * 비밀번호를 BCrypt 알고리즘으로 해싱합니다.
     * @param rawPassword 평문 비밀번호
     * @return 해싱된 비밀번호
     */
    @Override
    public String encode(CharSequence rawPassword) {
        // BCrypt.gensalt()는 솔트(salt)를 생성합니다. 솔트는 해시값마다 달라지게 하여 보안을 높입니다.
        // 기본 워크 팩터(strength)는 10입니다. 필요에 따라 변경할 수 있습니다.
        return BCrypt.hashpw(rawPassword.toString(), BCrypt.gensalt());
    }

    /**
     * 평문 비밀번호와 해싱된 비밀번호를 비교합니다.
     * @param rawPassword 평문 비밀번호
     * @param encodedPassword 데이터베이스에 저장된 해싱된 비밀번호
     * @return 비밀번호가 일치하면 true, 아니면 false
     */
    @Override
    public boolean matches(CharSequence rawPassword, String encodedPassword) {
        return BCrypt.checkpw(rawPassword.toString(), encodedPassword);
    }
}