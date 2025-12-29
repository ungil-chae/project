<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
    // 로그인 체크
    String userId = (String) session.getAttribute("id");
    if (userId == null || userId.isEmpty()) {
        // 로그인하지 않은 경우 로그인 페이지로 리다이렉트
        String currentPage = request.getRequestURI();
        response.sendRedirect(request.getContextPath() + "/projectLogin.jsp?toURL=" + currentPage);
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="resources/css/project_detail.css">
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <div class="container">
        <div class="form-header">
            <h1 class="form-title">상세 복지 혜택 진단</h1>
            <p class="form-subtitle">
                더 정확한 복지 혜택 매칭을 위해 상세 정보를 입력해주세요.<br>
                입력하신 정보는 안전하게 보호되며, 복지 혜택 추천에만 사용됩니다.
            </p>
        </div>
        
        <div class="info-box">
            <h4>정보 보안 안내</h4>
            <p>모든 개인정보는 암호화되어 저장되며, 복지 혜택 매칭 목적으로만 사용됩니다. 언제든지 개인정보 수정 및 삭제가 가능합니다.</p>
        </div>
        
        <form id="detailedDiagnosisForm" onsubmit="return handleSubmit(event)">
            <div class="form-card">
                <h3 class="section-title">기본 정보</h3>
                
                <div class="form-grid">
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
                </div>

                <div class="expandable-section">
                    <div class="section-header" onclick="toggleExpandableSection('special-situations')">
                        <h3 class="section-title" style="margin: 0; border: none; padding: 0;">특별 상황 (해당되는 항목을 선택해주세요)</h3>
                        <div class="expand-arrow" id="special-situations-arrow"></div>
                    </div>
                    <div class="expandable-content" id="special-situations-content">
                        <div class="checkbox-group">
                            <label class="checkbox-item">
                                <input type="checkbox" name="isPregnant" value="true">
                                <div class="checkbox-content">
                                    임신 중이거나 출산 예정
                                    <div class="description">임신·출산 관련 혜택을 받을 수 있습니다</div>
                                </div>
                            </label>
                            
                            <label class="checkbox-item">
                                <input type="checkbox" name="isDisabled" value="true">
                                <div class="checkbox-content">
                                    장애인 등록
                                    <div class="description">장애인 복지 혜택 대상입니다</div>
                                </div>
                            </label>
                            
                            <label class="checkbox-item">
                                <input type="checkbox" name="isMulticultural" value="true">
                                <div class="checkbox-content">
                                    다문화 가정
                                    <div class="description">다문화 가정 지원 정책 대상입니다</div>
                                </div>
                            </label>
                            
                            <label class="checkbox-item">
                                <input type="checkbox" name="isVeteran" value="true">
                                <div class="checkbox-content">
                                    보훈 대상자
                                    <div class="description">국가유공자, 보훈가족 등</div>
                                </div>
                            </label>
                            
                            <label class="checkbox-item">
                                <input type="checkbox" name="isSingleParent" value="true">
                                <div class="checkbox-content">
                                    한부모 가정
                                    <div class="description">한부모 가족 지원 대상입니다</div>
                                </div>
                            </label>
                            
                            <label class="checkbox-item">
                                <input type="checkbox" name="isLowIncome" value="true">
                                <div class="checkbox-content">
                                    기초생활수급자/차상위계층
                                    <div class="description">저소득층 지원 혜택 대상입니다</div>
                                </div>
                            </label>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="form-card">
                <h3 class="section-title">가구 정보</h3>
                
                <div class="form-grid">
                    <div class="form-group">
                        <label>가구원 수</label>
                        <select name="household_size">
                            <option value="">선택해주세요</option>
                            <option value="1">1명 (1인 가구)</option>
                            <option value="2">2명</option>
                            <option value="3">3명</option>
                            <option value="4">4명</option>
                            <option value="5">5명</option>
                            <option value="6">6명</option>
                            <option value="7">7명 이상</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>혼인 상태</label>
                        <select name="marital_status">
                            <option value="">선택해주세요</option>
                            <option value="single">미혼</option>
                            <option value="married">기혼</option>
                            <option value="divorced">이혼</option>
                            <option value="widowed">사별</option>
                            <option value="separated">별거</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>자녀 수 (18세 미만)</label>
                        <select name="children_count">
                            <option value="0">없음</option>
                            <option value="1">1명</option>
                            <option value="2">2명</option>
                            <option value="3">3명</option>
                            <option value="4">4명 이상</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>월 가구 소득</label>
                        <div class="income-group">
                            <input type="number" id="income_amount" min="0" max="9999" placeholder="0">
                            <span class="income-unit">만원</span>
                        </div>
                        <input type="hidden" name="income" id="income">
                        <div class="help-text">세전 가구 전체의 월 소득을 입력해주세요 (근로소득, 사업소득, 기타소득 포함)</div>
                    </div>
                </div>
            </div>
            
            <div class="form-card">
                <h3 class="section-title">경제활동 정보</h3>
                
                <div class="form-grid">
                    <div class="form-group">
                        <label>현재 직업 상태 <span class="required">*</span></label>
                        <select name="employment_status" required>
                            <option value="">선택해주세요</option>
                            <option value="employed">정규직 근로자</option>
                            <option value="part_time">비정규직/임시직</option>
                            <option value="self_employed">자영업</option>
                            <option value="unemployed">실업자</option>
                            <option value="seeking">구직중</option>
                            <option value="student">학생</option>
                            <option value="housewife">전업주부</option>
                            <option value="retired">은퇴</option>
                            <option value="other">기타</option>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>주거 형태</label>
                        <select name="housing_type">
                            <option value="">선택해주세요</option>
                            <option value="owned">자가</option>
                            <option value="jeonse">전세</option>
                            <option value="monthly_rent">월세</option>
                            <option value="public_rental">공공임대</option>
                            <option value="family">가족 소유</option>
                            <option value="other">기타</option>
                        </select>
                    </div>
                </div>
            </div>
            
            <div class="form-card">
                <h3 class="section-title">거주지 정보</h3>
                
                <div class="form-group">
                    <div class="location-group">
                        <div>
                            <label>시/도 <span class="required">*</span></label>
                            <select name="sido" id="sido" required>
                                <option value="">선택해주세요</option>
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
                        </div>
                        <div>
                            <label>시/군/구</label>
                            <select name="sigungu" id="sigungu">
                                <option value="">시/도를 먼저 선택해주세요</option>
                            </select>
                        </div>
                    </div>
                    <div class="help-text">지자체 복지 혜택 조회를 위해 정확한 주소를 입력해주세요</div>
                </div>
            </div>
            
            <div class="btn-group">
                <button type="button" class="btn btn-secondary" onclick="history.back()">이전으로</button>
                <button type="submit" class="btn btn-primary">복지 혜택 분석 시작</button>
            </div>
        </form>
    </div>
    
    <%@ include file="footer.jsp" %>
    <script src="resources/js/project_detail.js"></script>
    <script>
        // 회원 정보 자동 입력 (JSP 변수 처리)
        function autoFillMemberInfo() {
            <c:if test="${not empty memberInfo}">
                document.querySelector('input[name="gender"][value="${memberInfo.gender}"]').checked = true;
                const sidoElement = document.getElementById('sido');
                sidoElement.value = '${memberInfo.sido}' || '';
                sidoElement.dispatchEvent(new Event('change'));

                const birthdate = '${memberInfo.birthdate}';
                if (birthdate) {
                    const [year, month, day] = birthdate.split('-');
                    document.getElementById('year').value = year;
                    const monthElement = document.getElementById('month');
                    monthElement.value = month;
                    monthElement.dispatchEvent(new Event('change'));
                    setTimeout(() => {
                        document.getElementById('day').value = day;
                        // 시/도 선택 후 시/군/구 자동 선택 로직 추가
                        const sigunguElement = document.getElementById('sigungu');
                        if (sigunguElement && '${memberInfo.sigungu}') {
                            sigunguElement.value = '${memberInfo.sigungu}';
                        }
                    }, 100);
                }
            </c:if>
        }

        // 페이지 로드 시 회원 정보 자동 입력
        setTimeout(autoFillMemberInfo, 500);
    </script>
</body>
</html>