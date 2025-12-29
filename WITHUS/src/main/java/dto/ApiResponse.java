package dto;

public class ApiResponse<T> {
    public static final String STATUS_SUCCESS = "success";
    public static final String STATUS_ERROR = "error";

    private final String status;
    private final T data;
    private final String message;
    private final String code;

    private ApiResponse(String status, T data, String message, String code) {
        this.status = status;
        this.data = data;
        this.message = message;
        this.code = code;
    }

    public static <T> ApiResponse<T> success(T data, String message) {
        return new ApiResponse<>(STATUS_SUCCESS, data, message, null);
    }

    public static ApiResponse<Void> success(String message) {
        return new ApiResponse<>(STATUS_SUCCESS, null, message, null);
    }

    public static <T> ApiResponse<T> error(String code, String message) {
        return new ApiResponse<>(STATUS_ERROR, null, message, code);
    }

    public String getStatus() { return status; }
    public T getData() { return data; }
    public String getMessage() { return message; }
    public String getCode() { return code; }

    @Override
    public String toString() {
        return "ApiResponse{" +
               "status='" + status + '\'' +
               ", data=" + data +
               ", message='" + message + '\'' +
               ", code='" + code + '\'' +
               '}';
    }
}