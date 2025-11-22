// 이 줄이 반드시 있어야 합니다.
package service;

import java.io.Serializable; // 직렬화를 위한 임포트

// public 키워드가 반드시 있어야 합니다.
public class UserRegistrationException extends Exception implements Serializable {
    private static final long serialVersionUID = 1L; // 직렬화 버전 ID

    private String code;

    public UserRegistrationException(String code, String message) {
        super(message);
        this.code = code;
    }

    public String getCode() {
        return code;
    }
}