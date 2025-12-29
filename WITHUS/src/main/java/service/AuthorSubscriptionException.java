package service;
public class AuthorSubscriptionException extends Exception {
    private String code;
    public AuthorSubscriptionException(String code, String message) {
        super(message);
        this.code = code;
    }
    public String getCode() { return code; }
}