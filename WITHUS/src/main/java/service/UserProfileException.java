package service;

public class UserProfileException extends Exception {
    private String code;
    public UserProfileException(String code, String message) {
        super(message);
        this.code = code;
    }
    public String getCode() { return code; }
}