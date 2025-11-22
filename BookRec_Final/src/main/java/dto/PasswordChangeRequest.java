package dto;

public class PasswordChangeRequest {
    private String currentPassword;
    private String newPassword;

    public PasswordChangeRequest() {}

    public PasswordChangeRequest(String currentPassword, String newPassword) {
        this.currentPassword = currentPassword;
        this.newPassword = newPassword;
    }

    // Getter 및 Setter 메서드
    public String getCurrentPassword() { return currentPassword; }
    public void setCurrentPassword(String currentPassword) { this.currentPassword = currentPassword; }

    public String getNewPassword() { return newPassword; }
    public void setNewPassword(String newPassword) { this.newPassword = newPassword; }

    @Override
    public String toString() {
        return "PasswordChangeRequest{" +
               "currentPassword='[PROTECTED]'" + // 보안을 위해 로그에 출력 방지
               ", newPassword='[PROTECTED]'" +   // 보안을 위해 로그에 출력 방지
               '}';
    }
}