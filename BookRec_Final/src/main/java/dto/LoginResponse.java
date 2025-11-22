package dto;

//세션 기반 로그인 성공 시 클라이언트에게 보낼 응답 데이터
public class LoginResponse {
 private int userId;
 private String username;
 private String nickname;

 // 생성자 수정: accessToken 매개변수 제거
 public LoginResponse(int userId, String username, String nickname) {
     this.userId = userId;
     this.username = username;
     this.nickname = nickname;
 }

 // Getter 메서드 수정: getAccessToken() 메서드 제거
 public int getUserId() { return userId; }
 public String getUsername() { return username; }
 public String getNickname() { return nickname; }
}
