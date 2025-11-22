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
    <style type="text/css">
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }
        
        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
            background: #f8f9fa;
            color: #333;
        }

        .container {
            max-width: 800px;
            margin: 40px auto;
            padding: 0 20px;
        }
        
        .form-header {
            text-align: center;
            margin-bottom: 40px;
        }
        
        .form-title {
            font-size: 32px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 10px;
        }
        
        .form-subtitle {
            font-size: 16px;
            color: #6c757d;
            line-height: 1.5;
        }
        
        .form-card {
            background: white;
            border-radius: 15px;
            padding: 40px;
            box-shadow: 0 2px 15px rgba(0,0,0,0.1);
            margin-bottom: 30px;
        }
        
        .section-title {
            font-size: 20px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            padding-bottom: 10px;
            border-bottom: 2px solid #f8f9fa;
        }
        
        .form-grid {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }
        
        .form-grid.single {
            grid-template-columns: 1fr;
        }
        
        .form-group {
            margin-bottom: 25px;
        }
        
        .form-group.full-width {
            grid-column: 1 / -1;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            font-size: 14px;
            color: #495057;
        }
        
        label .required {
            color: #dc3545;
            font-weight: 700;
        }
        
        select, 
        input[type="number"], 
        input[type="text"] {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: border-color 0.2s ease;
            background: white;
        }
        
        select:focus, 
        input:focus {
            outline: none;
            border-color: #0061ff;
            box-shadow: 0 0 0 3px rgba(0, 97, 255, 0.1);
        }
        
        .date-group {
            display: grid;
            grid-template-columns: 1.5fr 1fr 1fr;
            gap: 12px;
        }
        
        .radio-group {
            display: flex;
            gap: 20px;
            flex-wrap: wrap;
        }
        
        .radio-item {
            display: flex;
            align-items: center;
            gap: 8px;
            padding: 8px 0;
        }
        
        .radio-item input[type="radio"] {
            width: auto;
            margin: 0;
        }
        
        .radio-item label {
            margin: 0;
            font-weight: normal;
            cursor: pointer;
        }
        
        .checkbox-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        
        .checkbox-item {
            display: flex;
            align-items: flex-start;
            gap: 10px;
            padding: 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            transition: all 0.2s ease;
            cursor: pointer;
        }
        
        .checkbox-item:hover {
            border-color: #0061ff;
            background: #f8f9ff;
        }
        
        .checkbox-item.checked {
            border-color: #0061ff;
            background: #f8f9ff;
        }
        
        .checkbox-item input[type="checkbox"] {
            margin-top: 2px;
            flex-shrink: 0;
        }
        
        .checkbox-item .checkbox-content {
            font-weight: 500;
            flex: 1;
        }
        
        .checkbox-item .description {
            font-size: 12px;
            color: #6c757d;
            margin-top: 2px;
            font-weight: normal;
        }
        
        .income-group {
            display: flex;
            align-items: center;
            gap: 10px;
        }
        
        .income-group input {
            flex: 1;
        }
        
        .income-unit {
            font-weight: 600;
            color: #495057;
            font-size: 14px;
        }
        
        .location-group {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 15px;
        }
        
        .help-text {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
            line-height: 1.4;
        }
        
        .btn-group {
            display: flex;
            gap: 15px;
            justify-content: center;
            margin-top: 40px;
        }
        
        .btn {
            padding: 15px 30px;
            border: none;
            border-radius: 8px;
            font-size: 16px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s ease;
            text-decoration: none;
            display: inline-block;
            text-align: center;
            min-width: 150px;
        }
        
        .btn-primary {
            background: #4A90E2;
            color: white;
        }

        .btn-primary:hover {
            background: #3a7bc8;
            transform: translateY(-1px);
        }
        
        .btn-secondary {
            background: #6c757d;
            color: white;
        }
        
        .btn-secondary:hover {
            background: #5a6268;
        }
        
        .info-box {
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            padding: 15px 20px;
            border-radius: 5px;
            margin-bottom: 30px;
        }
        
        .info-box h4 {
            color: #1976d2;
            font-size: 16px;
            margin-bottom: 8px;
        }
        
        .info-box p {
            color: #1565c0;
            font-size: 14px;
            line-height: 1.5;
            margin: 0;
        }
        
        /* 특별 상황 섹션 스타일 */
        .expandable-section {
            padding-top: 20px;
            border-top: 2px solid #e0e0e0; /* 더 뚜렷한 선으로 변경 */
            margin-top: 20px;
        }
        
        .section-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            cursor: pointer;
            padding: 10px 0;
            transition: all 0.2s ease;
        }
        
        .section-header:hover {
            color: #0061ff;
        }
        
        .expand-arrow {
            width: 20px;
            height: 20px;
            border: 2px solid #6c757d;
            border-radius: 50%;
            display: flex; /* Flexbox를 사용하여 내부 요소 중앙 정렬 */
            align-items: center;
            justify-content: center;
            transition: all 0.3s ease;
            /* position: relative;  제거 */
            /* transform: translateY(-50%); 제거 */
        }
        
        .expand-arrow::before {
            content: '';
            width: 8px;
            height: 8px;
            border-right: 2px solid #6c757d;
            border-bottom: 2px solid #6c757d;
            transform: rotate(45deg); /* translateY(-1px) 제거 */
            transition: all 0.3s ease;
        }
        
        .expand-arrow.expanded {
            border-color: #0061ff;
            background: #f8f9ff;
        }
        
        .expand-arrow.expanded::before {
            border-color: #0061ff;
            transform: rotate(-135deg); /* translateY(1px) 제거 */
        }
        
        .expandable-content {
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.3s ease, padding 0.3s ease;
            padding: 0;
        }
        
        .expandable-content.expanded {
            max-height: 1000px;
            padding: 20px 0 0 0;
        }

        .custom-radio-group { display: flex; flex-direction: column; gap: 15px; margin-top: 15px; }
        .custom-radio-item { display: flex; align-items: center; cursor: pointer; }
        .custom-radio-item input[type="radio"] { display: none; }
        .custom-radio-box { width: 22px; height: 22px; border: 2px solid #e9ecef; border-radius: 50%; margin-right: 12px; position: relative; transition: all 0.2s ease; }
        .custom-radio-item input[type="radio"]:checked + .custom-radio-box { border-color: #0061ff; }
        .custom-radio-item input[type="radio"]:checked + .custom-radio-box::after { content: ''; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); width: 12px; height: 12px; background: #0061ff; border-radius: 50%; }
        .custom-radio-item span { font-size: 14px; font-weight: 500; }

        .consent-details { max-height: 0; overflow: hidden; transition: max-height 0.4s ease, margin 0.4s ease; margin-top: 0; }
        .consent-details.expanded { max-height: 300px; margin-top: 20px; }
        
        .warning-box {
            max-height: 0;
            overflow: hidden;
            transition: all 0.4s ease;
            padding: 0;
            background: #e3f2fd;
            border-left: 4px solid #2196f3;
            border-radius: 5px;
            margin-top: 0;
            color: #1565c0;
            border: none;
        }
        .warning-box.expanded {
            max-height: 200px;
            padding: 15px 20px;
            margin-top: 15px;
        }
        .warning-box p {
            margin: 0;
            font-weight: 500;
            text-align: left;
        }
        
        .agreement-item { display: flex; align-items: center; margin-bottom: 15px; }
        .agreement-item label { display: flex; align-items: center; cursor: pointer; font-size: 14px; font-weight: normal; margin: 0; }
        .agreement-item input[type="checkbox"] { width: 20px; height: 20px; margin-right: 10px; }
        .agreement-item a { margin-left: auto; color: #6c757d; text-decoration: underline; font-size: 13px; cursor: pointer; }
        .agreement-item.all-agree label { font-weight: 600; font-size: 15px; }
        
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); z-index: 2000; display: none; align-items: center; justify-content: center; }
        .modal-overlay.active { display: flex; }
        .modal-content { background: white; padding: 40px; border-radius: 12px; width: 90%; max-width: 600px; max-height: 80vh; overflow-y: auto; position: relative; }
        .modal-title { font-size: 20px; font-weight: 600; margin-bottom: 20px; }
        .modal-body { font-size: 14px; line-height: 1.7; color: #444; }
        .modal-body h4 { font-size: 15px; margin: 15px 0 8px 0; }
        .modal-body p { margin-bottom: 10px; }
        .modal-close-btn { position: absolute; top: 15px; right: 15px; font-size: 24px; font-weight: bold; color: #888; cursor: pointer; border: none; background: none; }

        @media (max-width: 768px) {
            .form-grid, .date-group, .location-group, .checkbox-group { grid-template-columns: 1fr; }
            .radio-group { flex-direction: column; gap: 10px; }
            .btn-group { flex-direction: column; }
            .form-card { padding: 25px; }
        }
    </style>
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
            
            <div class="form-card">
                    <label style="font-weight: 600; font-size: 15px; color: #495057;">
                        진단 결과를 마이페이지에 저장하시겠습니까? (선택)
                    </label>
                    <div class="custom-radio-group">
                        <label class="custom-radio-item">
                            <input type="radio" name="consent_storage" value="yes" id="consent-yes-radio">
                            <span class="custom-radio-box"></span>
                            <span>예</span>
                        </label>
                        <label class="custom-radio-item">
                            <input type="radio" name="consent_storage" value="no" id="consent-no-radio">
                            <span class="custom-radio-box"></span>
                            <span>아니오</span>
                        </label>
                    </div>

                    <div class="consent-details" id="consent-details">
                        <div class="agreement-item all-agree">
                            <label>
                                <input type="checkbox" class="agreeAll">
                                개인정보 수집 및 이용에 모두 동의합니다.
                            </label>
                        </div>
                        <div class="agreement-item">
                            <label>
                                <input type="checkbox" class="agree-item" id="personal-info-collect">
                                개인정보 수집 및 이용 동의
                            </label>
                            <a class="view-details-btn" data-modal="modal1">상세보기</a>
                        </div>
                        <div class="agreement-item">
                            <label>
                                <input type="checkbox" class="agree-item" id="personal-info-provide">
                                제3자 제공 동의
                            </label>
                            <a class="view-details-btn" data-modal="modal2">상세보기</a>
                        </div>
                    </div>

                    <div class="warning-box" id="warning-box">
                        <p>저장하지 않으시면 진단 결과가 별도로 보관되지 않습니다.</p>
                    </div>
                </div>
            
            <div class="btn-group">
                <button type="button" class="btn btn-secondary" onclick="history.back()">이전으로</button>
                <button type="submit" class="btn btn-primary">복지 혜택 분석 시작</button>
            </div>
        </form>
    </div>
    
    <div id="modal1" class="modal-overlay">
        <div class="modal-content">
            <button class="modal-close-btn">&times;</button>
            <h3 class="modal-title">개인정보 및 고유식별정보 수집 및 이용 동의</h3>
            <div class="modal-body">
                <p>개인정보 및 고유식별정보 수집‧이용에 대한 동의를 거부할 권리가 있습니다. 단, 동의를 거부할 경우 복지서비스 신청 및 이력 확인, 사용자 서비스 등이 제한될 수 있습니다.</p>
                <h4>가. 개인정보 및 고유식별정보 수집‧이용 항목:</h4>
                <p>- 필수 항목: 성명, 생년월일, 성별, 연락처, 주소, 가구정보<br>
                - 선택 항목: 이메일, 특별상황 정보</p>
                <h4>나. 수집‧이용 목적:</h4>
                <p>복지서비스 관련 업무 (복지 혜택 매칭, 신청 지원, 맞춤형 서비스 제공 등)</p>
                <h4>다. 보유기간:</h4>
                <p>관계 법령에 의거 서비스 종료 후 3년간 보존 후 파기</p>
            </div>
        </div>
    </div>
    <div id="modal2" class="modal-overlay">
        <div class="modal-content">
            <button class="modal-close-btn">&times;</button>
            <h3 class="modal-title">개인정보 제3자 제공·이용 동의</h3>
            <div class="modal-body">
                <p>개인정보 제3자 제공‧이용에 대한 동의를 거부할 권리가 있습니다. 단, 동의를 거부할 경우 복지서비스 신청이 제한될 수 있습니다.</p>
                <h4>가. 제공받는 곳</h4>
                <p>- 복지로, 국민연금공단, 각 지자체, 복지서비스 제공기관</p>
                <h4>나. 제공 항목</h4>
                <p>- 성명, 생년월일, 성별, 주소, 가구정보<br>
                - 복지서비스 신청을 위한 필수 정보</p>
                <h4>다. 제공 목적</h4>
                <p>- 복지서비스 자격확인 및 신청 지원<br>
                - 맞춤형 복지 혜택 안내</p>
                <h4>라. 제공 기간</h4>
                <p>- 복지서비스 이용 중단시까지<br>
                - 개인정보 보유기간 내</p>
            </div>
        </div>
    </div>
       <%@ include file="footer.jsp" %>
    <script>
        // 생년월일 조합
        function combineDate() {
            const year = document.getElementById('year').value;
            const month = document.getElementById('month').value;
            const day = document.getElementById('day').value;
            console.log('combineDate 실행:', {year, month, day});
            if (!year || !month || !day) {
                console.log('생년월일이 선택되지 않음');
                return false;
            }
            const birthdate = year + '-' + month + '-' + day;
            document.getElementById('birthdate').value = birthdate;
            console.log('생년월일 설정됨:', birthdate);
            return true;
        }

        function convertIncomeToRange() {
            const amount = parseInt(document.getElementById('income_amount').value) || 0;
            let incomeRange;
            if (amount === 0) incomeRange = 'none';
            else if (amount < 100) incomeRange = 'under_100';
            else if (amount < 200) incomeRange = '100_200';
            else if (amount < 300) incomeRange = '200_300';
            else if (amount < 400) incomeRange = '300_400';
            else if (amount < 500) incomeRange = '400_500';
            else if (amount < 600) incomeRange = '500_600';
            else incomeRange = 'over_600';
            document.getElementById('income').value = incomeRange;
            return true;
        }

            // 월 변경시 일자 옵션 조정
            document.getElementById('month').addEventListener('change', function() {
                const month = parseInt(this.value);
                const year = parseInt(document.getElementById('year').value) || 2025;
                const daySelect = document.getElementById('day');
                const currentDay = daySelect.value;
                
                // 월이 선택되지 않았으면 원래 31일까지 다시 표시
                if (!month) {
                    daySelect.innerHTML = '<option value="">일</option>';
                    for (let d = 1; d <= 31; d++) {
                        const option = document.createElement('option');
                        option.value = String(d).padStart(2, '0');
                        option.textContent = d + '일';
                        daySelect.appendChild(option);
                    }
                    return;
                }
                
                let maxDays = 31;
                if ([4, 6, 9, 11].includes(month)) {
                    maxDays = 30;
                } else if (month === 2) {
                    maxDays = (year % 4 === 0 && (year % 100 !== 0 || year % 400 === 0)) ? 29 : 28;
                }
                
                daySelect.innerHTML = '<option value="">일</option>';
                for (let d = 1; d <= maxDays; d++) {
                    const option = document.createElement('option');
                    option.value = String(d).padStart(2, '0');
                    option.textContent = d + '일';
                    daySelect.appendChild(option);
                }
                
                if (currentDay && parseInt(currentDay) <= maxDays) {
                    daySelect.value = currentDay;
                }
            });

            // 전국 시/도 및 시/군/구 데이터 및 기능
            const regions = {
                "서울특별시": ["강남구", "강동구", "강북구", "강서구", "관악구", "광진구", "구로구", "금천구", "노원구", "도봉구", "동대문구", "동작구", "마포구", "서대문구", "서초구", "성동구", "성북구", "송파구", "양천구", "영등포구", "용산구", "은평구", "종로구", "중구", "중랑구"],
                "부산광역시": ["강서구", "금정구", "기장군", "남구", "동구", "동래구", "부산진구", "북구", "사상구", "사하구", "서구", "수영구", "연제구", "영도구", "중구", "해운대구"],
                "대구광역시": ["군위군", "남구", "달서구", "달성군", "동구", "북구", "서구", "수성구", "중구"],
                "인천광역시": ["강화군", "계양구", "남동구", "동구", "미추홀구", "부평구", "서구", "연수구", "옹진군", "중구"],
                "광주광역시": ["광산구", "남구", "동구", "북구", "서구"],
                "대전광역시": ["대덕구", "동구", "서구", "유성구", "중구"],
                "울산광역시": ["남구", "동구", "북구", "울주군", "중구"],
                "세종특별자치시": ["세종특별자치시"],
                "경기도": ["가평군", "고양시", "과천시", "광명시", "광주시", "구리시", "군포시", "김포시", "남양주시", "동두천시", "부천시", "성남시", "수원시", "시흥시", "안산시", "안성시", "안양시", "양주시", "양평군", "여주시", "연천군", "오산시", "용인시", "의왕시", "의정부시", "이천시", "파주시", "평택시", "포천시", "하남시", "화성시"],
                "강원특별자치도": ["강릉시", "고성군", "동해시", "삼척시", "속초시", "양구군", "양양군", "영월군", "원주시", "인제군", "정선군", "철원군", "춘천시", "태백시", "평창군", "홍천군", "화천군", "횡성군"],
                "충청북도": ["괴산군", "단양군", "보은군", "영동군", "옥천군", "음성군", "제천시", "증평군", "진천군", "청주시", "충주시"],
                "충청남도": ["계룡시", "공주시", "금산군", "논산시", "당진시", "보령시", "부여군", "서산시", "서천군", "아산시", "예산군", "천안시", "청양군", "태안군", "홍성군"],
                "전북특별자치도": ["고창군", "군산시", "김제시", "남원시", "무주군", "부안군", "순창군", "완주군", "익산시", "임실군", "장수군", "전주시", "정읍시", "진안군"],
                "전라남도": ["강진군", "고흥군", "곡성군", "광양시", "구례군", "나주시", "담양군", "목포시", "무안군", "보성군", "순천시", "신안군", "여수시", "영광군", "영암군", "완도군", "장성군", "장흥군", "진도군", "함평군", "해남군", "화순군"],
                "경상북도": ["경산시", "경주시", "고령군", "구미시", "김천시", "문경시", "봉화군", "상주시", "성주군", "안동시", "영덕군", "영양군", "영주시", "영천시", "예천군", "울릉군", "울진군", "의성군", "청도군", "청송군", "칠곡군", "포항시"],
                "경상남도": ["거제시", "거창군", "고성군", "김해시", "남해군", "밀양시", "사천시", "산청군", "양산시", "의령군", "진주시", "창녕군", "창원시", "통영시", "하동군", "함안군", "함양군", "합천군"],
                "제주특별자치도": ["서귀포시", "제주시"]
            };

            document.getElementById('sido').addEventListener('change', function() {
                const sigunguSelect = document.getElementById('sigungu');
                const selectedSido = this.value;
                
                sigunguSelect.innerHTML = ''; 
                
                const placeholder = document.createElement('option');
                placeholder.value = "";
                placeholder.textContent = "시/군/구 선택";
                sigunguSelect.appendChild(placeholder);
                
                if (regions[selectedSido]) {
                    regions[selectedSido].forEach(function(sigungu) {
                        const option = document.createElement('option');
                        option.value = sigungu;
                        option.textContent = sigungu;
                        sigunguSelect.appendChild(option);
                    });
                }
            });
            
            document.querySelectorAll('.checkbox-item input[type="checkbox"]').forEach(checkbox => {
                checkbox.addEventListener('change', () => {
                    checkbox.closest('.checkbox-item').classList.toggle('checked', checkbox.checked);
                });
            });

            const consentYesRadio = document.getElementById('consent-yes-radio');
            const consentNoRadio = document.getElementById('consent-no-radio');
            const consentDetails = document.getElementById('consent-details');
            const warningBox = document.getElementById('warning-box');
            
            function updateConsentUI() {
                if (consentYesRadio.checked) {
                    consentDetails.classList.add('expanded');
                    warningBox.classList.remove('expanded');
                } else if (consentNoRadio.checked) {
                    consentDetails.classList.remove('expanded');
                    warningBox.classList.add('expanded');
                } else {
                    consentDetails.classList.remove('expanded');
                    warningBox.classList.remove('expanded');
                }
            }
            
            consentYesRadio.addEventListener('change', updateConsentUI);
            consentNoRadio.addEventListener('change', updateConsentUI);
            
            updateConsentUI();

            const agreeAllCheckbox = consentDetails.querySelector('.agreeAll');
            const agreeItemCheckboxes = consentDetails.querySelectorAll('.agree-item');

            if (agreeAllCheckbox) {
                agreeAllCheckbox.addEventListener('change', e => {
                    agreeItemCheckboxes.forEach(checkbox => checkbox.checked = e.target.checked);
                });
            }
            agreeItemCheckboxes.forEach(checkbox => {
                checkbox.addEventListener('change', () => {
                    if (agreeAllCheckbox) {
                       agreeAllCheckbox.checked = [...agreeItemCheckboxes].every(item => item.checked);
                    }
                });
            });

            document.querySelectorAll('.view-details-btn').forEach(button => {
                button.addEventListener('click', () => {
                    const modal = document.getElementById(button.dataset.modal);
                    if(modal) modal.classList.add('active');
                });
            });
            document.querySelectorAll('.modal-close-btn').forEach(button => {
                button.addEventListener('click', () => {
                    button.closest('.modal-overlay').classList.remove('active');
                });
            });
            document.querySelectorAll('.modal-overlay').forEach(modal => {
                modal.addEventListener('click', e => {
                    if (e.target === modal) modal.classList.remove('active');
                });
            });

        // 폼 제출 처리 함수
        function handleSubmit(event) {
            console.log('handleSubmit 함수가 호출되었습니다.');
            event.preventDefault();
            
            if (!combineDate()) {
                alert('생년월일을 모두 선택해주세요.');
                return false;
            }
            
            if (!convertIncomeToRange()) {
                return false;
            }
            
            const consentStorage = document.querySelector('input[name="consent_storage"]:checked');
            if (consentStorage && consentStorage.value === 'yes') {
                if (!document.getElementById('personal-info-collect').checked || !document.getElementById('personal-info-provide').checked) {
                    alert('개인정보 저장에 동의하시려면 필수 약관에 동의해야 합니다.');
                    return false;
                }
            }
            
            showLoading();

            const formData = new FormData(document.getElementById('detailedDiagnosisForm'));
            const userData = {};
            
            for (let [key, value] of formData.entries()) {
                userData[key] = value;
            }

            // 체크되지 않은 체크박스들을 'false'로 설정
            ['isPregnant', 'isDisabled', 'isMulticultural', 'isVeteran', 'isSingleParent', 'isLowIncome'].forEach(name => {
                if (!userData[name]) userData[name] = 'false';
            });
            
            // 기본값 설정
            if (!userData.employment_status) userData.employment_status = 'other';
            if (!userData.children_count) userData.children_count = '0';
            if (!userData.household_size) userData.household_size = '1';
            if (!userData.marital_status) userData.marital_status = 'single';
            if (!userData.sido) userData.sido = '';
            if (!userData.sigungu) userData.sigungu = '';
            
            console.log("전송될 데이터:", JSON.stringify(userData, null, 2));

            // 서버로 AJAX 요청 전송 (URL-encoded form 데이터로 전송)
            const params = new URLSearchParams();
            Object.keys(userData).forEach(key => {
                params.append(key, userData[key] + "");
            });
            
            fetch('/bdproject/welfare/match', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => {
                if (!response.ok) {
                    throw new Error('서버 응답 오류');
                }
                return response.json();
            })
            .then(data => {
                // 결과 페이지로 이동 - project_result.jsp로 데이터 전달
                sessionStorage.setItem('welfareResults', JSON.stringify(data));
                sessionStorage.setItem('userInfo', JSON.stringify(userData));

                // 개인정보 저장 동의 시 진단 결과 저장
                const consentStorage = document.querySelector('input[name="consent_storage"]:checked');
                if (consentStorage && consentStorage.value === 'yes') {
                    console.log('진단 결과 저장 시작...');

                    // 필수 약관 동의 확인
                    const personalInfoCollect = document.getElementById('personal-info-collect');
                    const personalInfoProvide = document.getElementById('personal-info-provide');

                    if (!personalInfoCollect || !personalInfoCollect.checked || !personalInfoProvide || !personalInfoProvide.checked) {
                        console.warn('필수 약관 동의가 완료되지 않았습니다.');
                        alert('개인정보 저장을 위해서는 필수 약관에 모두 동의해야 합니다.');
                        return;
                    }

                    // 상위 10개 결과만 저장
                    const topResults = data.slice(0, 10);
                    const matchedServicesJson = JSON.stringify(topResults);

                    const saveFormData = new URLSearchParams();
                    saveFormData.append('birthdate', userData.birthdate);
                    saveFormData.append('gender', userData.gender);
                    saveFormData.append('household_size', userData.household_size || '1');
                    saveFormData.append('income', userData.income);
                    saveFormData.append('marital_status', userData.marital_status || 'single');
                    saveFormData.append('children_count', userData.children_count || '0');
                    saveFormData.append('employment_status', userData.employment_status || 'other');
                    saveFormData.append('sido', userData.sido || '');
                    saveFormData.append('sigungu', userData.sigungu || '');

                    // Boolean 값을 명시적으로 true/false로 변환
                    saveFormData.append('isPregnant', (userData.isPregnant === 'true' || userData.isPregnant === true) ? 'true' : 'false');
                    saveFormData.append('isDisabled', (userData.isDisabled === 'true' || userData.isDisabled === true) ? 'true' : 'false');
                    saveFormData.append('isMulticultural', (userData.isMulticultural === 'true' || userData.isMulticultural === true) ? 'true' : 'false');
                    saveFormData.append('isVeteran', (userData.isVeteran === 'true' || userData.isVeteran === true) ? 'true' : 'false');
                    saveFormData.append('isSingleParent', (userData.isSingleParent === 'true' || userData.isSingleParent === true) ? 'true' : 'false');

                    saveFormData.append('matchedServices', matchedServicesJson);
                    saveFormData.append('saveConsent', 'true');

                    console.log('저장 데이터:', {
                        birthdate: userData.birthdate,
                        gender: userData.gender,
                        household_size: userData.household_size,
                        income: userData.income,
                        resultsCount: topResults.length
                    });

                    // 비동기로 진단 결과 저장
                    fetch('/bdproject/api/welfare/diagnosis/save', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: saveFormData.toString()
                    })
                    .then(response => {
                        console.log('서버 응답 상태:', response.status);
                        return response.json();
                    })
                    .then(saveData => {
                        console.log('저장 응답:', saveData);
                        if (saveData.success) {
                            console.log('✅ 진단 결과가 마이페이지에 저장되었습니다!');
                            sessionStorage.setItem('diagnosisSaved', 'true');
                            sessionStorage.setItem('diagnosisSaveMessage', '진단 결과가 마이페이지에 저장되었습니다.');
                        } else {
                            console.error('❌ 진단 결과 저장 실패:', saveData.message);
                            sessionStorage.setItem('diagnosisSaved', 'false');
                            sessionStorage.setItem('diagnosisSaveMessage', saveData.message || '저장 실패');

                            // 로그인 필요 메시지
                            if (saveData.message && saveData.message.includes('로그인')) {
                                alert('진단 결과를 저장하려면 로그인이 필요합니다.\n로그인 후 다시 시도해주세요.');
                            }
                        }
                    })
                    .catch(error => {
                        console.error('❌ 진단 결과 저장 오류:', error);
                        sessionStorage.setItem('diagnosisSaved', 'false');
                        sessionStorage.setItem('diagnosisSaveMessage', '저장 중 오류 발생');
                    });
                }

                // POST 방식으로 데이터 전달
                var form = document.createElement('form');
                form.method = 'POST';
                form.action = '/bdproject/project_result.jsp';
                form.style.display = 'none';

                // 사용자 데이터를 폼으로 전달
                Object.keys(userData).forEach(function(key) {
                    var input = document.createElement('input');
                    input.type = 'hidden';
                    input.name = key;
                    input.value = userData[key];
                    form.appendChild(input);
                });

                document.body.appendChild(form);
                form.submit();
            })
            .catch(error => {
                hideLoading();
                alert('복지 혜택 분석 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요.');
                console.error('Error:', error);
            });
            
            return false;
        }

        // 회원 정보 자동 입력 (만약 있다면)
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

        function toggleExpandableSection(sectionId) {
            document.getElementById(sectionId + '-content').classList.toggle('expanded');
            document.getElementById(sectionId + '-arrow').classList.toggle('expanded');
        }

        function showLoading() {
            const loadingHtml = `<div id="loading-overlay" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(255, 255, 255, 0.9); display: flex; align-items: center; justify-content: center; z-index: 10000; flex-direction: column;"><div style="width: 60px; height: 60px; border: 4px solid #f3f3f3; border-top: 4px solid #0061ff; border-radius: 50%; animation: spin 1s linear infinite; margin-bottom: 20px;"></div><h3 style="color: #333; margin-bottom: 10px;">복지 혜택을 분석하고 있습니다</h3><p style="color: #666; text-align: center;">중앙부처 및 지자체 복지 서비스를 조회하고<br>맞춤 매칭 분석을 진행 중입니다...</p><style>@keyframes spin { 0% { transform: rotate(0deg); } 100% { transform: rotate(360deg); } }</style></div>`;
            document.body.insertAdjacentHTML('beforeend', loadingHtml);
        }
        function hideLoading() {
            const loadingOverlay = document.getElementById('loading-overlay');
            if (loadingOverlay) loadingOverlay.remove();
        }
    </script>
</body>
</html>