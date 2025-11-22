package dto;

//클라이언트로부터 로그인 요청을 받을 때 사용할 데이터 구조
public class LoginRequest {
 private String username; // 또는 email
 private String password;

 public LoginRequest() {}

 public LoginRequest(String username, String password) {
     this.username = username;
     this.password = password;
 }

 public String getUsername() { return username; }
 public void setUsername(String username) { this.username = username; }

 public String getPassword() { return password; }
 public void setPassword(String password) { this.password = password; }
}