package service;

// WishlistService.java에서 이 곳으로 옮겨온 코드입니다.
public class WishlistException extends Exception {
    private String code;
    public WishlistException(String code, String message) {
        super(message);
        this.code = code;
    }
    public String getCode() { return code; }
}