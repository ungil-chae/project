package model;

import java.time.LocalDateTime;
import java.util.Objects;

public class User {
    private int userId;
    private String username;
    private String password; // 암호화된 비밀번호
    private String nickname;
    private String email;
    private String gender; // ENUM 'M', 'F', 'O'
    private String mbti;    // VARCHAR(10)
    private String name;    // ✨ 추가: 이름 필드
    private String hobbies; // ✨ 추가: 취미/관심사 필드 (콤마 등으로 구분된 문자열)
    private LocalDateTime regDate;
    private LocalDateTime lastLoginDate;
    private String status;
    private LocalDateTime deletedAt;

    // 기본 생성자
    public User() {}

    // 모든 필드를 초기화하는 생성자 (업데이트)
    public User(int userId, String username, String password, String nickname, String email, String gender, String mbti,
                String name, String hobbies, // ✨ 추가된 필드들
                LocalDateTime regDate, LocalDateTime lastLoginDate, String status, LocalDateTime deletedAt) {
        this.userId = userId;
        this.username = username;
        this.password = password;
        this.nickname = nickname;
        this.email = email;
        this.gender = gender;
        this.mbti = mbti;
        this.name = name;        // ✨ 초기화
        this.hobbies = hobbies;  // ✨ 초기화
        this.regDate = regDate;
        this.lastLoginDate = lastLoginDate;
        this.status = status;
        this.deletedAt = deletedAt;
    }

    // Getter와 Setter 메서드 (필수)
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getGender() { return gender; }
    public void setGender(String gender) { this.gender = gender; }

    public String getMbti() { return mbti; }
    public void setMbti(String mbti) { this.mbti = mbti; }

    public LocalDateTime getRegDate() { return regDate; }
    public void setRegDate(LocalDateTime regDate) { this.regDate = regDate; }

    public LocalDateTime getLastLoginDate() { return lastLoginDate; }
    public void setLastLoginDate(LocalDateTime lastLoginDate) { this.lastLoginDate = lastLoginDate; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public LocalDateTime getDeletedAt() { return deletedAt; }
    public void setDeletedAt(LocalDateTime deletedAt) { this.deletedAt = deletedAt; }

    // ✨ 추가: name 필드의 Getter 및 Setter
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    // ✨ 추가: hobbies 필드의 Getter 및 Setter
    public String getHobbies() { return hobbies; }
    public void setHobbies(String hobbies) { this.hobbies = hobbies; }

    @Override
    public String toString() {
        return "User{" +
                "userId=" + userId +
                ", username='" + username + '\'' +
                ", password='" + "[PROTECTED]" + '\'' + // 비밀번호는 출력하지 않는 것이 좋음
                ", nickname='" + nickname + '\'' +
                ", email='" + email + '\'' +
                ", gender='" + gender + '\'' +
                ", mbti='" + mbti + '\'' +
                ", name='" + name + '\'' +       // ✨ toString에도 추가
                ", hobbies='" + hobbies + '\'' + // ✨ toString에도 추가
                ", regDate=" + regDate +
                ", lastLoginDate=" + lastLoginDate +
                ", status='" + status + '\'' +
                ", deletedAt=" + deletedAt +
                '}';
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        User user = (User) o;
        return userId == user.userId;
    }

    @Override
    public int hashCode() {
        return Objects.hash(userId);
    }
}