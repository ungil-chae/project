# 📝 인코딩 설정 가이드

MyBatis Board Project에서 **텍스트 깨짐 현상을 방지**하기 위한 필수 설정 가이드입니다.

## 🚨 중요: 모든 팀원이 반드시 설정해야 함

### 1. Eclipse/STS 설정

#### 1-1. 워크스페이스 전체 UTF-8 설정
```
Window → Preferences → General → Workspace
→ Text file encoding: UTF-8 선택
```

#### 1-2. 웹 파일별 UTF-8 설정
```
Window → Preferences → Web → CSS Files
→ Encoding: UTF-8

Window → Preferences → Web → HTML Files
→ Encoding: UTF-8

Window → Preferences → Web → JSP Files
→ Encoding: UTF-8
```

#### 1-3. 프로젝트별 설정 확인
```
프로젝트 우클릭 → Properties → Resource
→ Text file encoding: UTF-8 확인
```

### 2. VS Code 설정

#### 2-1. settings.json 설정
```json
{
    "files.encoding": "utf8",
    "files.autoGuessEncoding": false,
    "files.autoSave": "afterDelay"
}
```

#### 2-2. 파일별 인코딩 확인
- 하단 상태바에서 인코딩 확인
- UTF-8이 아닌 경우 클릭하여 "Reopen with Encoding" → UTF-8 선택

## 🔧 프로젝트 설정 (이미 완료됨)

### ✅ Eclipse .settings 설정
- `.settings/org.eclipse.core.resources.prefs`에 UTF-8 설정 완료
- 전체 프로젝트 및 모든 소스 폴더 UTF-8 강제 적용

### ✅ Maven pom.xml 설정
- `project.build.sourceEncoding=UTF-8`
- `project.reporting.outputEncoding=UTF-8`
- `maven.compiler.encoding=UTF-8`

### ✅ Spring web.xml 설정
- CharacterEncodingFilter 설정 완료
- 모든 HTTP 요청/응답 UTF-8 강제 적용

## 🔍 기존 깨진 파일 복구 방법

### 방법 1: IDE에서 직접 복구
1. 깨진 파일을 **EUC-KR**로 다시 열기
2. 한글이 정상 표시되는지 확인
3. 파일을 **UTF-8로 저장**

### 방법 2: 명령어로 일괄 변환 (Windows)
```cmd
chcp 65001
type 파일명.java > 임시파일.java
copy 임시파일.java 파일명.java
```

## 📋 현재 깨진 파일 목록

**심각도 높음:**
- `WelfareService.java` - 복지 서비스 관련
- `AuthController.java` - 인증 관련
- `WelfareController.java` - 복지 컨트롤러

**심각도 중간:**
- `PageHandler.java` - 페이징 유틸
- `LoginController.java` - 로그인 관련
- `ApiCallEx.java` - API 샘플

## 🚫 주의사항

### 하지 말아야 할 것들
1. **CP949/EUC-KR로 파일 저장하지 말기**
2. **서로 다른 인코딩 혼용하지 말기**
3. **UTF-8 BOM 사용하지 말기** (Java에서 문제 발생)

### 권장사항
1. **모든 새 파일은 UTF-8로 생성**
2. **Git 커밋 전 인코딩 상태 확인**
3. **팀원 간 인코딩 설정 공유**

## 🔄 Git 설정 (권장)

### .gitattributes 파일 생성
```gitattributes
# 모든 텍스트 파일을 UTF-8로 처리
* text=auto eol=lf

# Java 파일들
*.java text eol=lf encoding=UTF-8
*.jsp text eol=lf encoding=UTF-8
*.xml text eol=lf encoding=UTF-8
*.properties text eol=lf encoding=UTF-8

# 웹 파일들
*.html text eol=lf encoding=UTF-8
*.css text eol=lf encoding=UTF-8
*.js text eol=lf encoding=UTF-8
```

## 📞 문제 발생 시

1. **새 파일 생성 시 깨짐**: IDE 인코딩 설정 확인
2. **기존 파일 열기 시 깨짐**: EUC-KR로 열어서 UTF-8로 저장
3. **웹에서 한글 깨짐**: CharacterEncodingFilter 설정 확인
4. **빌드 시 깨짐**: Maven 인코딩 설정 확인

---

⚠️ **이 가이드를 팀원 모두와 공유하여 일관된 인코딩 환경을 유지하세요!**