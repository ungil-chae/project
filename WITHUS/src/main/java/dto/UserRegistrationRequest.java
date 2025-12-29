package dto;

//클라이언트로부터 회원가입 요청을 받을 때 사용할 데이터 구조
public class UserRegistrationRequest {
    private String username;
    private String password;
    private String nickname;
    private String email;
    private String gender;
    private String mbti;
    private String name;    // ✨ 추가: 이름 필드
    private String hobbies; // ✨ 추가: 취미/관심사 필드 (콤마 등으로 구분된 문자열)

    public UserRegistrationRequest() {}

    // 모든 필드를 포함하는 생성자 (선택 사항)
    // 주의: 필드 추가 시 생성자 파라미터도 함께 업데이트해야 합니다.
    public UserRegistrationRequest(String username, String password, String nickname, String email, String gender, String mbti, String name, String hobbies) {
        this.username = username;
        this.password = password;
        this.nickname = nickname;
        this.email = email;
        this.gender = gender;
        this.mbti = mbti;
        this.name = name;      // ✨ 초기화
        this.hobbies = hobbies; // ✨ 초기화
    }

    // Getter 및 Setter 메서드
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

    // ✨ 추가: name 필드의 Getter 및 Setter
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    // ✨ 추가: hobbies 필드의 Getter 및 Setter
    public String getHobbies() { return hobbies; }
    public void setHobbies(String hobbies) { this.hobbies = hobbies; }
}