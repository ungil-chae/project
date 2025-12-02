# 수정 완료 내역

## 수정된 3가지 문제

### 1. ✅ 회원가입 약관 동의 - 버튼 활성화 기능

**문제**: 약관에 모두 동의하지 않아도 가입하기 버튼이 활성화되어 있음

**해결**:
- 파일: `Welfare/src/main/webapp/project_register.jsp`
- 버튼 초기 색상: `#B8D4F1` (연한 파란색, 비활성화 상태)
- 모든 필수 약관 동의 완료 시: `#4A90E2` (진한 파란색, 활성화 상태)
- JavaScript로 약관 체크박스 상태를 실시간 모니터링하여 버튼 활성화/비활성화

**작동 방식**:
1. 페이지 로드 시 버튼은 연한 파란색 + disabled 상태
2. 사용자가 약관을 체크할 때마다 `updateSubmitButton()` 함수 실행
3. 3개의 필수 약관이 모두 체크되면 버튼 활성화
4. 하나라도 체크 해제되면 다시 비활성화

---

### 2. ✅ 주소 저장 문제 수정

**문제**: 주소를 검색하고 "변경사항 저장" 버튼을 눌러도 주소가 저장되지 않음. 다른 페이지로 이동 후 돌아오면 주소가 사라짐.

**원인**:
1. `MemberApiController.java`에서 `member.setEmail(userId)`가 누락되어 WHERE 조건 실패 (이전 수정에서 해결)
2. **주요 원인**: `ProjectMemberDaoImpl.java`의 `select()`와 `updateProfile()` 메서드에서 주소 필드를 처리하지 않음

**해결**:
- 파일: `Welfare/src/main/java/com/greenart/bdproject/dao/ProjectMemberDaoImpl.java`

1. **select() 메서드 수정** (62-85번째 줄):
   ```java
   // SQL에 주소 필드 추가
   String sql = "SELECT member_id, email, pwd, name, phone, role, status, birth, gender, " +
                "postcode, address, detail_address, " +  // ← 추가
                "kindness_temperature, ... " +
                "FROM member WHERE email = ? AND deleted_at IS NULL";

   // ResultSet에서 주소 데이터 추출
   m.setPostcode(rs.getString("postcode"));
   m.setAddress(rs.getString("address"));
   m.setDetailAddress(rs.getString("detail_address"));
   ```

2. **updateProfile() 메서드 수정** (317-329번째 줄):
   ```java
   // SQL에 주소 필드 업데이트 추가
   String sql = "UPDATE member SET name = ?, gender = ?, birth = ?, phone = ?, " +
                "postcode = ?, address = ?, detail_address = ?, updated_at = NOW() WHERE email = ?";

   // PreparedStatement에 주소 데이터 바인딩
   psmt.setString(5, m.getPostcode());
   psmt.setString(6, m.getAddress());
   psmt.setString(7, m.getDetailAddress());
   psmt.setString(8, m.getEmail());
   ```

**테스트 방법**:
1. 서버 재시작 (변경사항 적용)
2. 로그인 → 마이페이지 이동
3. "주소 검색" → 주소 선택 → 상세주소 입력
4. "변경사항 저장" 클릭
5. 다른 페이지로 이동했다가 마이페이지로 돌아오기
6. 주소가 올바르게 표시되는지 확인

---

### 3. ✅ 알림 기능 작동 확인 및 테스트 도구 추가

**문제**: 봉사 활동이나 정기 기부를 내일/당일로 신청했지만 알림이 오지 않음

**원인 분석**:
- 알림 기능은 이미 구현되어 있음
- **스케줄러가 매일 오전 9시에만 실행됨**
- 즉시 테스트할 수 있는 방법이 없었음

**해결**: 테스트 도구 3종 세트 추가

#### 1) 디버깅 SQL 스크립트
- 파일: `Welfare/DEBUG_NOTIFICATION.sql`
- 기능:
  - 사용자의 member_id와 email 확인
  - 정기 기부/봉사 신청 데이터 확인
  - 생성된 알림 확인
  - 문제 진단 및 해결 방법 제시

**사용 방법**:
```sql
-- 1. 파일 열기
-- 2. @my_member_id와 @my_email 변수를 본인 정보로 수정
SET @my_member_id = 1;  -- 본인의 member_id
SET @my_email = 'your-email@example.com';  -- 본인의 이메일

-- 3. 전체 스크립트 실행
-- 4. 각 단계별 결과 확인
```

#### 2) 테스트 데이터 생성 스크립트
- 파일: `Welfare/TEST_NOTIFICATION_SETUP.sql` (이전에 생성됨)
- 기능: 내일/오늘 날짜의 정기 기부 및 봉사 신청 데이터 자동 생성

#### 3) 알림 즉시 생성 API
- 파일: `Welfare/src/main/java/com/greenart/bdproject/controller/NotificationTestController.java`
- 엔드포인트: `POST /bdproject/api/notification/test/generate`
- 기능: 스케줄러를 기다리지 않고 즉시 알림 생성

**사용 방법**:

**방법 A: 브라우저 콘솔에서 실행**
```javascript
// 1. 로그인한 상태에서 F12 → Console 탭
// 2. 다음 코드 실행
fetch('/bdproject/api/notification/test/generate', {
    method: 'POST',
    headers: { 'Content-Type': 'application/json' }
})
.then(response => response.json())
.then(data => {
    console.log('알림 생성 결과:', data);
    alert(data.message);
    if (data.success && data.count > 0) {
        location.reload();  // 페이지 새로고침하여 알림 확인
    }
});
```

**방법 B: Postman 또는 cURL 사용**
```bash
curl -X POST http://localhost:8080/bdproject/api/notification/test/generate \
     -H "Cookie: JSESSIONID=<세션ID>" \
     -H "Content-Type: application/json"
```

---

## 전체 테스트 순서

### 1단계: 테스트 데이터 생성
```sql
-- TEST_NOTIFICATION_SETUP.sql 실행
-- @test_member_id를 본인 member_id로 수정 후 실행
```

### 2단계: 데이터 확인
```sql
-- DEBUG_NOTIFICATION.sql 실행
-- "알림 대상 데이터 있음" 확인
```

### 3단계: 알림 생성 (3가지 방법 중 선택)

**방법 1: 즉시 테스트 (권장)**
- 브라우저 콘솔에서 `fetch` API 실행
- 즉시 알림이 생성되고 확인 가능

**방법 2: 스케줄러 대기**
- 오전 9시까지 대기
- 스케줄러가 자동으로 알림 생성
- 서버 로그 확인: "일일 알림 자동 생성 스케줄러 시작"

**방법 3: 테스트용 스케줄러 활성화**
```java
// NotificationScheduler.java:91 주석 해제
@Scheduled(cron = "0 * * * * *")  // 매분 실행
public void generateNotificationsEveryMinute() {
    // ...
}
```

### 4단계: 알림 확인
1. 웹 페이지 새로고침
2. 우측 상단 알림 아이콘 클릭
3. 생성된 알림 확인

---

## 알림 작동 원리

### 데이터 조건
**정기 기부 알림**:
- `donations` 테이블에서 조회
- 조건:
  - `member_id` = 로그인한 사용자
  - `donation_type` = 'REGULAR'
  - `regular_start_date` IN (오늘, 내일)
  - `payment_status` = 'COMPLETED'

**봉사 활동 알림**:
- `volunteer_applications` 테이블에서 조회
- 조건:
  - `member_id` = 로그인한 사용자
  - `volunteer_date` IN (오늘, 내일)
  - `status` IN ('APPLIED', 'CONFIRMED')

### 알림 메시지
- **내일**: "내일은 정기 기부 예정일입니다" / "내일은 봉사 활동 예정일입니다"
- **오늘**: "오늘은 정기 기부 예정일입니다" / "오늘은 봉사 활동일입니다"

### 중복 방지
- 같은 날짜에 동일한 `notification_type`과 `related_id`의 알림은 한 번만 생성
- 조건: `DATE(created_at) = CURDATE()`

---

## 문제 해결 (트러블슈팅)

### 주소가 여전히 저장되지 않는 경우

1. **브라우저 개발자 도구 확인**:
   - F12 → Network 탭
   - "변경사항 저장" 클릭
   - `/api/member/updateProfile` 요청 확인
   - 응답에서 `success: true` 확인

2. **데이터베이스 직접 확인**:
   ```sql
   SELECT postcode, address, detail_address
   FROM member
   WHERE email = 'your-email@example.com';
   ```

3. **서버 로그 확인**:
   ```
   프로필 수정 요청
   postcode: <값>, address: <값>, detailAddress: <값>
   프로필 업데이트 결과: 1
   ```

### 알림이 생성되지 않는 경우

1. **데이터 확인**:
   ```sql
   -- DEBUG_NOTIFICATION.sql 실행
   -- "알림 대상 데이터 있음" 확인
   ```

2. **테스트 API 실행**:
   - 브라우저 콘솔에서 `fetch` API 실행
   - 응답 확인: `{success: true, count: N}`

3. **서버 로그 확인**:
   ```
   === 알림 자동 생성 시작 - userId: <email> ===
   정기 기부 조회 SQL 실행 완료
   정기 기부 발견 #1: donationId=X, startDate=YYYY-MM-DD
   ✅ 정기 기부 알림 생성 성공
   === 알림 자동 생성 완료 - 총 X개 생성 ===
   ```

4. **스케줄러 활성화 확인**:
   ```xml
   <!-- root-context.xml -->
   <task:annotation-driven />  <!-- 이 줄이 있어야 함 -->
   ```

### 약관 동의 버튼이 활성화되지 않는 경우

1. **브라우저 캐시 삭제**:
   - Ctrl+Shift+Delete → 캐시 삭제
   - 또는 Ctrl+F5 (강력 새로고침)

2. **JavaScript 콘솔 확인**:
   - F12 → Console 탭
   - 오류 메시지 확인

3. **체크박스 확인**:
   - 모든 필수 약관 체크 시 버튼 색상이 `#4A90E2`로 변경되어야 함
   - `disabled` 속성이 제거되어야 함

---

## 변경된 파일 목록

### 수정된 파일
1. ✏️ `Welfare/src/main/webapp/project_register.jsp`
   - 약관 동의 버튼 활성화 로직 추가

2. ✏️ `Welfare/src/main/java/com/greenart/bdproject/dao/ProjectMemberDaoImpl.java`
   - `select()` 메서드: 주소 필드 조회 추가
   - `updateProfile()` 메서드: 주소 필드 업데이트 추가

3. ✏️ `Welfare/src/main/java/com/greenart/bdproject/controller/MemberApiController.java`
   - (이전 수정) `member.setEmail(userId)` 추가

### 새로 생성된 파일
1. 🆕 `Welfare/DEBUG_NOTIFICATION.sql` - 알림 디버깅 스크립트
2. 🆕 `Welfare/src/main/java/com/greenart/bdproject/controller/NotificationTestController.java` - 알림 테스트 API
3. 🆕 `Welfare/FIXES_APPLIED.md` - 이 문서

### 기존 파일 (변경 없음, 확인만 함)
- `Welfare/TEST_NOTIFICATION_SETUP.sql` - 테스트 데이터 생성 스크립트
- `Welfare/src/main/java/com/greenart/bdproject/scheduler/NotificationScheduler.java`
- `Welfare/src/main/java/com/greenart/bdproject/service/NotificationServiceImpl.java`

---

## 다음 단계 (선택사항)

### 프로덕션 배포 전 확인사항

1. **테스트 컨트롤러 제거 또는 비활성화**:
   - `NotificationTestController.java` 삭제 또는 주석 처리
   - 보안상 프로덕션에서는 테스트 API를 노출하지 않는 것이 좋음

2. **스케줄러 실행 시간 조정** (필요 시):
   ```java
   // NotificationScheduler.java
   @Scheduled(cron = "0 0 9 * * *")  // 매일 오전 9시
   // 원하는 시간으로 변경 가능
   ```

3. **로그 레벨 조정**:
   - 프로덕션: INFO 레벨
   - 개발/테스트: DEBUG 레벨

4. **알림 설정 UI 추가** (선택):
   - 사용자가 알림 ON/OFF 설정
   - 알림 수신 시간 커스터마이징

---

## 요약

| 문제 | 원인 | 해결 방법 | 상태 |
|------|------|-----------|------|
| 약관 동의 버튼 활성화 | JavaScript 로직 없음 | 체크박스 상태 모니터링 로직 추가 | ✅ 완료 |
| 주소 저장 안 됨 | DAO에서 주소 필드 미처리 | select/updateProfile 메서드에 주소 필드 추가 | ✅ 완료 |
| 알림 생성 안 됨 | 스케줄러 오전 9시에만 실행 | 테스트 API 추가 (즉시 알림 생성 가능) | ✅ 완료 |

모든 수정사항을 적용하려면 **서버를 재시작**해야 합니다!
