# 포트폴리오 완성을 위한 구현 가이드

## 📌 개요
이 문서는 복지24 프로젝트를 개발자 포트폴리오 수준으로 완성하기 위한 구현 가이드입니다.

---

## ✅ 이미 완료된 작업

### 1. 데이터베이스 스키마 업데이트
- ✅ `auto_login_tokens` 테이블 추가 (자동 로그인 기능)
- ✅ `email_verifications` 테이블 추가 (이메일 인증 기능)
- ✅ `CURDATE()` 함수 제거 (MySQL 8.x 호환성)

### 2. Maven 의존성 추가
- ✅ Spring Security Crypto (BCrypt 비밀번호 암호화)
- ✅ Commons FileUpload (파일 업로드)
- ✅ JavaMail (이메일 발송)
- ✅ Spring Context Support (이메일 템플릿)

---

## 🔴 필수 구현 사항 (High Priority)

### 1. BCrypt 비밀번호 암호화 적용

#### 1.1 PasswordEncoder Bean 등록
**파일**: `src/main/webapp/WEB-INF/spring/root-context.xml`

```xml
<!-- BCrypt PasswordEncoder Bean -->
<bean id="passwordEncoder" class="org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder" />
```

#### 1.2 AuthController 수정
**파일**: `src/main/java/com/greenart/bdproject/controller/AuthController.java`

```java
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@Controller
public class AuthController {

    @Autowired
    private MemberDao memberDao;

    @Autowired
    private BCryptPasswordEncoder passwordEncoder;

    // 비밀번호 재설정 시 암호화 적용
    @PostMapping("/api/auth/reset-password-security")
    @ResponseBody
    public Map<String, Object> resetPasswordWithSecurity(
            @RequestParam("username") String username,
            @RequestParam("securityAnswer") String securityAnswer,
            @RequestParam("newPassword") String newPassword) {

        Map<String, Object> response = new HashMap<>();

        try {
            // 비밀번호 유효성 검사
            if (newPassword == null || newPassword.length() < 8) {
                response.put("success", false);
                response.put("message", "비밀번호는 최소 8자 이상이어야 합니다.");
                return response;
            }

            Member member = memberDao.findByIdAndSecurityAnswer(username, securityAnswer);

            if (member == null) {
                response.put("success", false);
                response.put("message", "아이디 또는 보안 질문 답변이 일치하지 않습니다.");
                return response;
            }

            // 🔐 BCrypt로 암호화
            String encryptedPassword = passwordEncoder.encode(newPassword);
            member.setPwd(encryptedPassword);

            int result = memberDao.update(member);

            if (result > 0) {
                response.put("success", true);
                response.put("message", "비밀번호가 성공적으로 변경되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "비밀번호 변경에 실패했습니다.");
            }

        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "시스템 오류가 발생했습니다.");
            e.printStackTrace();
        }

        return response;
    }
}
```

#### 1.3 LoginController 수정
**파일**: `src/main/java/com/greenart/bdproject/controller/LoginController.java`

로그인 시 비밀번호 검증:
```java
@Autowired
private BCryptPasswordEncoder passwordEncoder;

// 로그인 검증
if (passwordEncoder.matches(inputPassword, member.getPwd())) {
    // 로그인 성공
} else {
    // 로그인 실패
}
```

---

### 2. 세션 타임아웃 및 자동 로그아웃 구현

#### 2.1 web.xml 세션 타임아웃 설정
**파일**: `src/main/webapp/WEB-INF/web.xml`

```xml
<!-- 세션 타임아웃 설정 (60분) -->
<session-config>
    <session-timeout>60</session-timeout>
</session-config>
```

#### 2.2 navbar.jsp에 타이머 추가
**파일**: `src/main/webapp/navbar.jsp`

네비바 우측에 세션 타이머 표시:
```html
<!-- 세션 타이머 (로그인 시에만 표시) -->
<div class="session-timer" id="sessionTimer" style="display: none;">
    <svg class="timer-icon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor">
        <path d="M15 1H9v2h6V1zm-4 13h2V8h-2v6zm8.03-6.61l1.42-1.42c-.43-.51-.9-.99-1.41-1.41l-1.42 1.42C16.07 4.74 14.12 4 12 4c-4.97 0-9 4.03-9 9s4.02 9 9 9 9-4.03 9-9c0-2.12-.74-4.07-1.97-5.61zM12 20c-3.87 0-7-3.13-7-7s3.13-7 7-7 7 3.13 7 7-3.13 7-7 7z"/>
    </svg>
    <span id="timerText">59:59</span>
</div>

<script>
// 세션 타이머 (1시간)
let sessionEndTime = null;
const SESSION_DURATION = 60 * 60 * 1000; // 1시간

// 로그인 시 호출 (LoginController에서 loginTime 세션 저장 필요)
function initSessionTimer(loginTime) {
    sessionEndTime = loginTime + SESSION_DURATION;

    setInterval(() => {
        const now = Date.now();
        const remaining = sessionEndTime - now;

        if (remaining <= 0) {
            alert('세션이 만료되었습니다. 다시 로그인해주세요.');
            window.location.href = '/bdproject/api/auth/logout';
            return;
        }

        const minutes = Math.floor(remaining / 60000);
        const seconds = Math.floor((remaining % 60000) / 1000);

        document.getElementById('timerText').textContent =
            String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');
    }, 1000);

    document.getElementById('sessionTimer').style.display = 'flex';
}
</script>
```

#### 2.3 로그아웃 API 추가
**파일**: `src/main/java/com/greenart/bdproject/controller/AuthController.java`

```java
@PostMapping("/api/auth/logout")
@ResponseBody
public Map<String, Object> logout(HttpSession session) {
    Map<String, Object> response = new HashMap<>();

    try {
        session.invalidate();
        response.put("success", true);
    } catch (Exception e) {
        response.put("success", false);
        response.put("message", "로그아웃 중 오류가 발생했습니다.");
    }

    return response;
}
```

---

### 3. 관리자 API 권한 검증

#### 3.1 AdminInterceptor 생성
**파일**: `src/main/java/com/greenart/bdproject/interceptor/AdminInterceptor.java` (새로 생성)

```java
package com.greenart.bdproject.interceptor;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.web.servlet.HandlerInterceptor;

import com.greenart.bdproject.dto.Member;

public class AdminInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);

        if (session == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"error\": \"로그인이 필요합니다.\"}");
            return false;
        }

        Member member = (Member) session.getAttribute("member");

        if (member == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"error\": \"로그인이 필요합니다.\"}");
            return false;
        }

        // 관리자 권한 확인
        if (!"ADMIN".equals(member.getRole())) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"error\": \"관리자 권한이 필요합니다.\"}");
            return false;
        }

        return true;
    }
}
```

#### 3.2 Interceptor 등록
**파일**: `src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml`

```xml
<!-- Interceptor 등록 -->
<beans:bean id="adminInterceptor" class="com.greenart.bdproject.interceptor.AdminInterceptor" />

<interceptors>
    <interceptor>
        <mapping path="/api/admin/**"/>
        <beans:ref bean="adminInterceptor"/>
    </interceptor>
</interceptors>
```

---

### 4. XSS 방어 적용

모든 JSP 파일에서 사용자 입력 출력 시 `<c:out>` 태그 사용:

**예시**: `project_notice.jsp`
```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!-- 나쁜 예 -->
<td>${notice.title}</td>

<!-- 좋은 예 -->
<td><c:out value="${notice.title}" escapeXml="true"/></td>
```

**적용 대상 파일**:
- `project_notice.jsp`
- `project_faq.jsp`
- `project_mypage.jsp`
- `project_admin.jsp`
- 기타 사용자 데이터 출력하는 모든 JSP 파일

---

## ⚡ 권장 구현 사항 (Medium Priority)

### 5. 자동 로그인 (Remember Me) 구현

#### 5.1 AutoLoginTokenDao 생성
**파일**: `src/main/java/com/greenart/bdproject/dao/AutoLoginTokenDao.java` (새로 생성)

```java
package com.greenart.bdproject.dao;

import com.greenart.bdproject.dto.AutoLoginToken;

public interface AutoLoginTokenDao {
    int insert(AutoLoginToken token);
    AutoLoginToken selectByToken(String token);
    int deleteByMemberId(Long memberId);
    int deleteExpiredTokens();
}
```

#### 5.2 AutoLoginToken DTO 생성
**파일**: `src/main/java/com/greenart/bdproject/dto/AutoLoginToken.java` (새로 생성)

```java
package com.greenart.bdproject.dto;

import java.sql.Timestamp;

public class AutoLoginToken {
    private Long tokenId;
    private Long memberId;
    private String token;
    private Timestamp expiresAt;
    private Timestamp createdAt;
    private Timestamp lastUsedAt;

    // Getters and Setters
}
```

#### 5.3 MyBatis Mapper XML
**파일**: `src/main/resources/mapper/AutoLoginTokenMapper.xml` (새로 생성)

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
"http://mybatis.org/dtd/mybatis-3-mapper.dtd">

<mapper namespace="com.greenart.bdproject.dao.AutoLoginTokenDao">

    <insert id="insert" parameterType="AutoLoginToken">
        INSERT INTO auto_login_tokens (member_id, token, expires_at)
        VALUES (#{memberId}, #{token}, #{expiresAt})
    </insert>

    <select id="selectByToken" parameterType="string" resultType="AutoLoginToken">
        SELECT * FROM auto_login_tokens
        WHERE token = #{token} AND expires_at > NOW()
    </select>

    <delete id="deleteByMemberId" parameterType="long">
        DELETE FROM auto_login_tokens WHERE member_id = #{memberId}
    </delete>

    <delete id="deleteExpiredTokens">
        DELETE FROM auto_login_tokens WHERE expires_at < NOW()
    </delete>

</mapper>
```

#### 5.4 로그인 시 자동 로그인 토큰 생성
```java
// 자동 로그인 체크박스가 체크된 경우
if (rememberMe) {
    String token = UUID.randomUUID().toString();
    AutoLoginToken autoToken = new AutoLoginToken();
    autoToken.setMemberId(member.getMemberId());
    autoToken.setToken(token);
    autoToken.setExpiresAt(new Timestamp(System.currentTimeMillis() + 7 * 24 * 60 * 60 * 1000)); // 7일

    autoLoginTokenDao.insert(autoToken);

    // 쿠키에 토큰 저장
    Cookie cookie = new Cookie("auto_login_token", token);
    cookie.setMaxAge(7 * 24 * 60 * 60); // 7일
    cookie.setPath("/");
    response.addCookie(cookie);
}
```

---

### 6. SLF4J 로깅 적용

**모든 Controller, Service, DAO 클래스에 적용**:

```java
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class AuthController {
    private static final Logger logger = LoggerFactory.getLogger(AuthController.class);

    @PostMapping("/api/auth/login")
    public String login() {
        logger.info("로그인 시도: {}", username);
        logger.error("로그인 실패: {}", e.getMessage(), e);
    }
}
```

**System.out.println() 제거**:
- `AuthController.java`의 모든 `System.out.println()` → `logger.info()`
- `LoginController.java`의 모든 `System.out.println()` → `logger.info()`

---

### 7. 트랜잭션 관리 강화

#### 7.1 root-context.xml에 트랜잭션 매니저 추가
**파일**: `src/main/webapp/WEB-INF/spring/root-context.xml`

```xml
<!-- 트랜잭션 매니저 -->
<bean id="transactionManager" class="org.springframework.jdbc.datasource.DataSourceTransactionManager">
    <property name="dataSource" ref="dataSource"/>
</bean>

<!-- @Transactional 어노테이션 활성화 -->
<tx:annotation-driven transaction-manager="transactionManager"/>
```

#### 7.2 Service 계층에 @Transactional 적용
```java
import org.springframework.transaction.annotation.Transactional;

@Service
public class DonationService {

    @Transactional
    public void processDonation(Donation donation) {
        // 기부 저장
        donationDao.insert(donation);

        // 회원 온도 업데이트
        memberDao.updateKindnessTemperature(donation.getMemberId(), 0.5);

        // 하나라도 실패하면 모두 롤백
    }
}
```

---

### 8. 프로필 이미지 업로드 구현

#### 8.1 servlet-context.xml에 MultipartResolver 추가
```xml
<!-- 파일 업로드 설정 (최대 10MB) -->
<beans:bean id="multipartResolver"
            class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
    <beans:property name="maxUploadSize" value="10485760" />
    <beans:property name="defaultEncoding" value="UTF-8" />
</beans:bean>
```

#### 8.2 FileUploadController 생성
```java
@Controller
public class FileUploadController {

    private static final Logger logger = LoggerFactory.getLogger(FileUploadController.class);
    private static final String UPLOAD_DIR = "C:/uploads/profiles/";

    @PostMapping("/api/upload/profile")
    @ResponseBody
    public Map<String, Object> uploadProfile(@RequestParam("file") MultipartFile file,
                                             HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        try {
            // 파일 검증
            if (file.isEmpty()) {
                response.put("success", false);
                response.put("message", "파일이 비어있습니다.");
                return response;
            }

            // 파일 크기 검증 (5MB)
            if (file.getSize() > 5 * 1024 * 1024) {
                response.put("success", false);
                response.put("message", "파일 크기는 5MB를 초과할 수 없습니다.");
                return response;
            }

            // 파일 확장자 검증
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf(".")).toLowerCase();

            if (!Arrays.asList(".jpg", ".jpeg", ".png", ".gif").contains(extension)) {
                response.put("success", false);
                response.put("message", "이미지 파일만 업로드 가능합니다.");
                return response;
            }

            // UUID로 파일명 생성
            String savedFilename = UUID.randomUUID().toString() + extension;
            File dest = new File(UPLOAD_DIR + savedFilename);

            // 디렉토리 생성
            dest.getParentFile().mkdirs();

            // 파일 저장
            file.transferTo(dest);

            // 파일 URL 반환
            String fileUrl = "/uploads/profiles/" + savedFilename;

            response.put("success", true);
            response.put("fileUrl", fileUrl);

            logger.info("프로필 이미지 업로드 성공: {}", savedFilename);

        } catch (Exception e) {
            logger.error("프로필 이미지 업로드 실패", e);
            response.put("success", false);
            response.put("message", "파일 업로드 중 오류가 발생했습니다.");
        }

        return response;
    }
}
```

---

## 💡 추가 기능 (Low Priority)

### 9. 이메일 인증 기능 구현

#### 9.1 이메일 설정 (Gmail 사용)
**파일**: `src/main/webapp/WEB-INF/spring/root-context.xml`

```xml
<!-- JavaMail 설정 -->
<bean id="mailSender" class="org.springframework.mail.javamail.JavaMailSenderImpl">
    <property name="host" value="smtp.gmail.com" />
    <property name="port" value="587" />
    <property name="username" value="your-email@gmail.com" />
    <property name="password" value="your-app-password" />
    <property name="javaMailProperties">
        <props>
            <prop key="mail.smtp.auth">true</prop>
            <prop key="mail.smtp.starttls.enable">true</prop>
        </props>
    </property>
</bean>
```

#### 9.2 EmailService 생성
**파일**: `src/main/java/com/greenart/bdproject/service/EmailService.java`

```java
package com.greenart.bdproject.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import javax.mail.internet.MimeMessage;
import java.util.Random;

@Service
public class EmailService {

    @Autowired
    private JavaMailSender mailSender;

    public String sendVerificationCode(String toEmail) {
        try {
            // 6자리 인증 코드 생성
            String code = String.format("%06d", new Random().nextInt(999999));

            MimeMessage message = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

            helper.setTo(toEmail);
            helper.setSubject("[복지24] 이메일 인증 코드");
            helper.setText(
                "<h2>복지24 이메일 인증</h2>" +
                "<p>인증 코드: <strong style='font-size: 24px;'>" + code + "</strong></p>" +
                "<p>이 코드는 10분간 유효합니다.</p>",
                true
            );

            mailSender.send(message);

            return code;

        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }
}
```

#### 9.3 이메일 인증 API
```java
@PostMapping("/api/auth/send-verification")
@ResponseBody
public Map<String, Object> sendVerification(@RequestParam("email") String email) {
    Map<String, Object> response = new HashMap<>();

    try {
        // 인증 코드 생성 및 이메일 발송
        String code = emailService.sendVerificationCode(email);

        if (code == null) {
            response.put("success", false);
            response.put("message", "이메일 발송에 실패했습니다.");
            return response;
        }

        // DB에 인증 코드 저장
        EmailVerification verification = new EmailVerification();
        verification.setEmail(email);
        verification.setVerificationCode(code);
        verification.setVerificationType("SIGNUP");
        verification.setExpiresAt(new Timestamp(System.currentTimeMillis() + 10 * 60 * 1000)); // 10분

        emailVerificationDao.insert(verification);

        response.put("success", true);
        response.put("message", "인증 코드가 이메일로 발송되었습니다.");

    } catch (Exception e) {
        response.put("success", false);
        response.put("message", "인증 코드 발송 중 오류가 발생했습니다.");
    }

    return response;
}
```

---

## 📝 구현 체크리스트

### 필수 (High Priority)
- [ ] BCrypt 비밀번호 암호화 적용
- [ ] 세션 타임아웃 설정 (web.xml)
- [ ] 세션 타이머 UI 추가 (navbar.jsp)
- [ ] 관리자 API 권한 검증 (AdminInterceptor)
- [ ] XSS 방어 적용 (모든 JSP에서 `<c:out>` 사용)

### 권장 (Medium Priority)
- [ ] 자동 로그인 기능 구현
- [ ] SLF4J 로깅 적용
- [ ] 트랜잭션 관리 강화
- [ ] 프로필 이미지 업로드 구현

### 추가 (Low Priority)
- [ ] 이메일 인증 기능 구현

---

## 🚀 다음 단계

1. **데이터베이스 초기화**: MySQL에서 `schema.sql` 실행
2. **Maven 의존성 다운로드**: Eclipse/STS에서 프로젝트 → Maven → Update Project
3. **위 가이드대로 순차 구현**
4. **각 기능 테스트 후 커밋**

---

## 💼 포트폴리오 작성 팁

### README.md에 포함할 내용
- 프로젝트 개요 및 목적
- 기술 스택 (Spring MVC, MyBatis, MySQL, BCrypt, JavaMail 등)
- 주요 기능 (복지 서비스 매칭, 자동 로그인, 이메일 인증, 관리자 페이지 등)
- 보안 구현 사항 (BCrypt 암호화, XSS 방어, 권한 검증 등)
- ERD 다이어그램
- API 명세
- 실행 방법

### 면접 대비 예상 질문
1. **Q: BCrypt를 사용한 이유는?**
   - A: 단방향 해시 알고리즘으로 레인보우 테이블 공격에 안전하며, Salt를 자동으로 생성하여 동일한 비밀번호도 다른 해시값을 가집니다.

2. **Q: 세션 타임아웃을 1시간으로 설정한 이유는?**
   - A: 보안과 사용자 편의성의 균형을 고려했습니다. 금융권은 10분, 일반 서비스는 30분~1시간이 적절합니다.

3. **Q: XSS 공격을 어떻게 방어하나요?**
   - A: JSP에서 `<c:out>` 태그를 사용하여 HTML 특수문자를 이스케이프하고, 서버에서도 입력 검증을 수행합니다.

4. **Q: 파일 업로드 시 보안 고려사항은?**
   - A: 파일 확장자 검증, 파일 크기 제한, UUID로 파일명 변경, 실행 가능한 파일 업로드 차단 등을 적용했습니다.

5. **Q: 트랜잭션 관리를 왜 적용했나요?**
   - A: 기부 처리 시 기부 저장과 회원 온도 업데이트가 원자적으로 수행되어야 데이터 일관성이 유지됩니다.

---

**작성일**: 2025-01-15
**작성자**: Claude Code
**프로젝트**: 복지24 (Welfare24)
