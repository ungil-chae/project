// package service;

package service;

import java.io.Serializable; // 직렬화를 위해 필요 (Exception 클래스가 이미 구현)

// 사용자 로그인 관련 비즈니스 로직에서 발생할 수 있는 특정 예외를 정의합니다.
// public으로 선언하여 다른 패키지(예: servlet)에서 접근 가능하도록 합니다.
public class UserLoginException extends Exception implements Serializable {
    private static final long serialVersionUID = 1L; // 직렬화 버전 ID

    private String code; // 오류의 구체적인 코드를 담을 필드 (예: "INVALID_CREDENTIALS", "ACCOUNT_INACTIVE")

    public UserLoginException(String code, String message) {
        super(message); // Exception의 생성자를 호출하여 오류 메시지를 설정
        this.code = code; // 오류 코드 설정
    }

    // 오류 코드를 가져오는 Getter 메서드
    public String getCode() {
        return code;
    }
}