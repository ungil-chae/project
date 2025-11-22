# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## 프로젝트 개요
- **프로젝트명**: MyBatis Board Project
- **기술 스택**: Spring Framework 5.0.7, MyBatis 3.5.9, JSP, MySQL 8.3.0, Java 11
- **아키텍처**: Spring MVC 패턴 기반 웹 애플리케이션
- **패키징**: WAR (Web Application Archive)

## 빌드 및 개발 명령어

### Maven 명령어
```bash
# 프로젝트 컴파일
mvn compile

# 테스트 실행
mvn test

# WAR 파일 생성
mvn package

# 전체 빌드 (clean + compile + test + package)
mvn clean install
```

### 테스트 실행
```bash
# 모든 테스트 실행
mvn test

# 특정 테스트 클래스 실행
mvn test -Dtest=ConnectionTest
mvn test -Dtest=BoardDaoImplTest

# 특정 테스트 메서드 실행
mvn test -Dtest=ConnectionTest#testConnection
```

## 아키텍처 및 구조

### Spring MVC 계층 구조
```
Controller Layer (com.greenart.bdproject.controller)
├── HomeController - 메인 페이지 및 복지 진단 라우팅
├── WelfareController - 복지 서비스 API 처리 (/welfare/*)
├── BoardController - 게시판 CRUD 기능
├── AuthController - 인증 관련
├── LoginController - 로그인 처리
└── RegisterController - 회원가입 처리

Service Layer (com.greenart.bdproject.service)
├── WelfareService - 복지 서비스 매칭 및 외부 API 호출
├── BoardService - 게시판 비즈니스 로직
└── BoardServiceImpl

DAO Layer (com.greenart.bdproject.dao)
├── MemberDao/MemberDaoImpl - 회원 데이터 접근
├── BoardDao/BoardDaoImpl - 게시판 데이터 접근
└── ProjectMemberDao/ProjectMemberDaoImpl - 프로젝트 회원 관리

DTO Layer (com.greenart.bdproject.dto)
├── Member - 회원 정보 DTO
└── BoardDto - 게시판 DTO
```

### MyBatis 설정
- **설정 파일**: `src/main/resources/mybatis-config.xml`
- **매퍼 파일**: `src/main/resources/mapper/`
  - `MemberMapper.xml` - 회원 관련 SQL
  - `boardMapper.xml` - 게시판 관련 SQL
- **별칭 설정**: 
  - `BoardDto` → `com.greenart.bdproject.dto.BoardDto`
  - `Member` → `com.greenart.bdproject.dto.Member`

### Spring 설정
- **루트 컨텍스트**: `src/main/webapp/WEB-INF/spring/root-context.xml`
  - DataSource (MySQL 연결): `jdbc:mysql://localhost:3306/springmvc`
  - MyBatis SqlSessionFactory 설정
  - 트랜잭션 매니저 설정
- **서블릿 컨텍스트**: `src/main/webapp/WEB-INF/spring/appServlet/servlet-context.xml`
  - ViewResolver (JSP)
  - 정적 리소스 매핑 (/resources/**)
  - 컴포넌트 스캔 (`com.greenart.bdproject`)

### 데이터베이스
- **DBMS**: MySQL 8.3.0
- **연결 정보**: 
  - URL: `jdbc:mysql://localhost:3306/springmvc`
  - 사용자: `root` / 비밀번호: `1709`
- **드라이버**: `com.mysql.cj.jdbc.Driver`

## 복지 진단 시스템 (핵심 기능)

### API 통합 구조
복지 서비스는 공공데이터포털의 두 가지 API를 활용:

1. **중앙부처 복지서비스**: `NationalWelfareInformationsV001`
2. **지방자치단체 복지서비스**: `LocalGovernmentWelfareInformations`

### 매칭 알고리즘 (`WelfareService.java:336`)
```java
// 점수 기반 매칭 시스템
- 생애주기 매칭: 30점
- 가구유형 매칭: 40점 (저소득층 추가 가중치)
- 지역 서비스: 10점 추가
- 온라인 신청 가능: 5점 추가
- 최소 10점 이상만 결과에 포함
```

### 사용자 데이터 변환 (`WelfareService.java:271`)
- 생년월일 → 나이 계산 → 생애주기 코드 변환
- 소득 구간 → 저소득층 여부 판단
- 가구 특성 → API 파라미터 코드 변환

### 주요 엔드포인트
```
GET  / → HomeController.main() → "project"
GET  /diagnosis → HomeController.diagnosis() → "project_information"  
POST /diagnosis/result → HomeController.result() → "project_result"
POST /welfare/match → WelfareController.matchWelfare() (AJAX API)
```

## JSP 뷰 구조
```
src/main/webapp/WEB-INF/views/
├── project_information.jsp - 복지 진단 입력 폼
├── project_result.jsp - 복지 서비스 매칭 결과
├── index.jsp, home.jsp - 메인 페이지들
├── boardList.jsp, boardRead.jsp - 게시판
├── loginForm.jsp, registerForm.jsp - 인증
└── navi.jsp - 공통 네비게이션

src/main/webapp/resources/
├── css/project.css - 복지 진단 스타일
├── js/project_result.js - 결과 페이지 스크립트
└── image/ - 프로젝트 이미지 리소스
```

## 개발 시 주의사항

### 코딩 규칙
- 패키지 구조: `com.greenart.bdproject.{layer}`
- MyBatis 매퍼: XML 파일과 인터페이스 분리
- 예외 처리: 컨트롤러에서 try-catch 구문 활용
- 로깅: SLF4J + Log4j 사용

### 테스트 구조
- **연결 테스트**: `ConnectionTest.java` - 데이터베이스 연결 확인
- **DAO 테스트**: `*DaoImplTest.java` - 데이터 접근 계층 테스트
- **컨트롤러 테스트**: Spring Test 컨텍스트 활용

### API 키 관리
복지 서비스 API 키가 `WelfareService.java:30`에 하드코딩되어 있음. 프로덕션 환경에서는 외부 설정으로 분리 필요.

## 현재 개발 상태

### 완료된 기능
- ✅ 복지 진단 입력 폼 (`project_information.jsp`)
- ✅ 복지 서비스 매칭 API (`WelfareService`, `WelfareController`)
- ✅ 기본 Spring MVC 설정 및 데이터베이스 연동
- ✅ 게시판 CRUD 기능
- ✅ 회원 인증 시스템

### 개발 예정
- 🔄 복지 결과 페이지 UI 개선
- 🔄 지역별 복지 서비스 확장
- 🔄 사용자 맞춤 추천 알고리즘 고도화