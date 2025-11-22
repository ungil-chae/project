// package service;

package service;

import java.io.Serializable;

// 문의 관련 비즈니스 로직에서 발생할 수 있는 특정 예외를 정의합니다.
// public으로 선언하고 별도 파일로 분리되어야 합니다.
public class InquiryException extends Exception implements Serializable {
    private static final long serialVersionUID = 1L; // 직렬화 버전 ID

    private String code;

    public InquiryException(String code, String message) {
        super(message);
        this.code = code;
    }

    public String getCode() {
        return code;
    }
}