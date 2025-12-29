<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="resources/css/project_information.css">
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="container">
        <div class="form-card">
            <div class="form-header">
                <h2 class="form-title">간편 복지 진단</h2>
                <p class="form-subtitle">
                    기본 정보만으로 빠르게 복지 혜택을 확인해보세요.<br>
                    회원가입 없이 누구나 이용 가능합니다.
                </p>
            </div>
            
            <div class="info-box">
                <h4>간편 진단 안내</h4>
                <p>기본 정보로 대략적인 복지 혜택을 조회합니다. <br>더 정확한 결과를 원하시면 회원 가입 후 상세 진단을 이용해주세요.</p>
            </div>
            
            <form id="basicDiagnosisForm" onsubmit="return handleSubmit(event)">
                <div class="form-group">
                    <label>생년월일 <span class="required">*</span></label>
                    <div class="date-group">
                        <select id="year" required>
                            <option value="">연도 선택</option>
                            <% for(int y = 2025; y >= 1930; y--) { %>
                            <option value="<%=y%>"><%=y%>년</option>
                            <% } %>
                        </select>
                        <select id="month" required>
                            <option value="">월</option>
                            <% for(int m = 1; m <= 12; m++) { %>
                            <option value="<%=String.format("%02d", m)%>"><%=m%>월</option>
                            <% } %>
                        </select>
                        <select id="day" required>
                            <option value="">일</option>
                            <% for(int d = 1; d <= 31; d++) { %>
                            <option value="<%=String.format("%02d", d)%>"><%=d%>일</option>
                            <% } %>
                        </select>
                    </div>
                    <input type="hidden" name="birthdate" id="birthdate">
                </div>
                
                <div class="form-group">
                    <label>성별 <span class="required">*</span></label>
                    <div class="radio-group">
                        <div class="radio-item">
                            <input type="radio" name="gender" value="male" id="male" required>
                            <label for="male">남성</label>
                        </div>
                        <div class="radio-item">
                            <input type="radio" name="gender" value="female" id="female">
                            <label for="female">여성</label>
                        </div>
                    </div>
                </div>
                
                <div class="form-group">
                    <label>가구원 수 <span class="required">*</span></label>
                    <select name="household_size" required>
                        <option value="">선택해주세요</option>
                        <option value="1">1명 (1인 가구)</option>
                        <option value="2">2명</option>
                        <option value="3">3명</option>
                        <option value="4">4명</option>
                        <option value="5">5명 이상</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>월 소득 (가구 전체) <span class="required">*</span></label>
                    <div class="income-group">
                        <input type="number" id="income_amount" min="0" max="9999" placeholder="0" required>
                        <span class="income-unit">만원</span>
                    </div>
                    <input type="hidden" name="income" id="income">
                    <div class="help-text">세전 가구 전체의 월 소득을 입력해주세요</div>
                </div>
                
                <div class="form-group">
                    <label>자녀 수 (18세 미만)</label>
                    <select name="children_count">
                        <option value="0">없음</option>
                        <option value="1">1명</option>
                        <option value="2">2명</option>
                        <option value="3">3명 이상</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>직업 상태</label>
                    <select name="employment_status">
                        <option value="">선택해주세요</option>
                        <option value="EMPLOYED">재직중</option>
                        <option value="UNEMPLOYED">실업중</option>
                        <option value="SELF_EMPLOYED">자영업</option>
                        <option value="STUDENT">학생</option>
                        <option value="RETIRED">은퇴</option>
                        <option value="HOMEMAKER">주부/주부</option>
                    </select>
                </div>
                
                <div class="form-group">
                    <label>거주 지역</label>
                    <div class="location-group">
                        <select name="sido" id="sido">
                            <option value="">시/도 선택</option>
                            <option value="서울특별시">서울특별시</option>
                            <option value="부산광역시">부산광역시</option>
                            <option value="대구광역시">대구광역시</option>
                            <option value="인천광역시">인천광역시</option>
                            <option value="광주광역시">광주광역시</option>
                            <option value="대전광역시">대전광역시</option>
                            <option value="울산광역시">울산광역시</option>
                            <option value="세종특별자치시">세종특별자치시</option>
                            <option value="경기도">경기도</option>
                            <option value="강원특별자치도">강원특별자치도</option>
                            <option value="충청북도">충청북도</option>
                            <option value="충청남도">충청남도</option>
                            <option value="전북특별자치도">전북특별자치도</option>
                            <option value="전라남도">전라남도</option>
                            <option value="경상북도">경상북도</option>
                            <option value="경상남도">경상남도</option>
                            <option value="제주특별자치도">제주특별자치도</option>
                        </select>
                        <select name="sigungu" id="sigungu">
                            <option value="">시/군/구 선택</option>
                        </select>
                    </div>
                    <div class="help-text">지자체 복지 혜택 조회를 위해 지역을 선택해주세요 (선택사항)</div>
                </div>
                
                <!-- 기본값으로 설정될 숨겨진 필드들 -->
                <input type="hidden" name="marital_status" value="single">
                <input type="hidden" name="isPregnant" value="false">
                <input type="hidden" name="isDisabled" value="false">
                <input type="hidden" name="isMulticultural" value="false">
                <input type="hidden" name="isVeteran" value="false">
                <input type="hidden" name="isSingleParent" value="false">

                <div class="btn-group">
                    <button type="button" class="btn btn-secondary" onclick="history.back()">취소</button>
                    <button type="submit" class="btn btn-primary">복지 혜택 조회</button>
                </div>
            </form>
            
            <div class="upgrade-link">
                <p style="font-size: 14px; color: #6c757d; margin-bottom: 10px;">
                    더 정확한 결과를 원하시나요?
                </p>
                <a href="/welfare/diagnosis-detailed">회원가입 후 상세 진단 받기 →</a>
            </div>
        </div>
    </div>
       <%@ include file="footer.jsp" %>
    <script src="resources/js/project_information.js"></script>
</body>
</html>