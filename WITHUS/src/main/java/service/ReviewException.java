package service;
public class ReviewException extends Exception {
    private String code;
    public ReviewException(String code, String message) {
        super(message);
        this.code = code;
    }
    public String getCode() { return code; }
}