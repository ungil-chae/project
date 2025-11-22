// /dto/UserResponse.java

package dto;

import model.User; // model.User 임포트
import java.time.LocalDateTime;

// 클라이언트에게 사용자 정보를 응답할 때 사용할 데이터 구조 (비밀번호 등 민감 정보 제외)
public class UserResponse {
    private int userId;
    private String username;
    private String nickname;
    private String email;
    private String gender;
    private String mbti;
    private String name;    // ✨ 1. 필드 추가
    private String hobbies; // ✨ 2. 필드 추가
    private String regDate;
    private String lastLoginDate;

    // ✨ 3. 생성자 파라미터 및 초기화 로직 업데이트
    public UserResponse(int userId, String username, String nickname, String email, String gender, String mbti,
                        String name, String hobbies, // 파라미터 추가
                        LocalDateTime regDate, LocalDateTime lastLoginDate) {
        this.userId = userId;
        this.username = username;
        this.nickname = nickname;
        this.email = email;
        this.gender = gender;
        this.mbti = mbti;
        this.name = name;         // 필드 초기화
        this.hobbies = hobbies;   // 필드 초기화
        this.regDate = regDate != null ? regDate.toString() : null;
        this.lastLoginDate = lastLoginDate != null ? lastLoginDate.toString() : null;
    }

    // ✨ 4. fromUser 헬퍼 메서드 업데이트
    // Model의 User 객체를 DTO의 UserResponse 객체로 변환하는 헬퍼 메서드
    public static UserResponse fromUser(User user) {
        return new UserResponse(
            user.getUserId(),
            user.getUsername(),
            user.getNickname(),
            user.getEmail(),
            user.getGender(),
            user.getMbti(),
            user.getName(),      // user 객체에서 name 전달
            user.getHobbies(),   // user 객체에서 hobbies 전달
            user.getRegDate(),
            user.getLastLoginDate()
        );
    }

    // Getter 메서드들 (name, hobbies 추가)
    public int getUserId() { return userId; }
    public String getUsername() { return username; }
    public String getNickname() { return nickname; }
    public String getEmail() { return email; }
    public String getGender() { return gender; }
    public String getMbti() { return mbti; }
    public String getName() { return name; }
    public String getHobbies() { return hobbies; }
    public String getRegDate() { return regDate; }
    public String getLastLoginDate() { return lastLoginDate; }
}