<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 로그인 체크 - 비로그인 시 로그인 페이지로 리다이렉트
    String userId = (String) session.getAttribute("id");
    if (userId == null || userId.isEmpty()) {
        userId = (String) session.getAttribute("userId");
    }
    if (userId == null || userId.isEmpty()) {
        response.sendRedirect("projectLogin.jsp?redirect=mypage");
        return;
    }

    // 관리자인 경우 관리자 페이지로 리다이렉트
    String userRole = (String) session.getAttribute("role");
    if ("ADMIN".equals(userRole)) {
        response.sendRedirect("/bdproject/project_admin.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>마이페이지 - 복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="<%=request.getContextPath()%>/resources/css/project_mypage.css">
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <!-- 메인 컨테이너 -->
    <div class="main-container">
        <!-- 사이드바 -->
        <aside class="sidebar">
            <div class="sidebar-header">
                <div class="user-profile">
                    <div class="user-avatar" id="userAvatar" onclick="document.getElementById('profileImageInput').click()">
                        <span id="avatarInitial"><%= session.getAttribute("username") != null ? ((String)session.getAttribute("username")).substring(0, 1) : "?" %></span>
                        <div class="avatar-upload-btn" title="프로필 사진 변경">
                            <i class="fas fa-plus"></i>
                        </div>
                    </div>
                    <input type="file" id="profileImageInput" accept="image/jpeg,image/jpg,image/png,image/gif,image/webp">
                    <div class="user-info">
                        <h3><%= session.getAttribute("username") != null ? session.getAttribute("username") : "게스트" %>님</h3>
                        <p><%= session.getAttribute("userId") != null ? session.getAttribute("userId") : "로그인이 필요합니다" %></p>
                    </div>
                </div>

                <!-- 온도 시스템 -->
                <div class="user-temperature">
                    <div class="temperature-header">
                        <div class="temperature-label">
                            <i class="fas fa-fire-alt"></i>
                            <span>선행 온도</span>
                        </div>
                        <div class="temperature-value" id="temperatureValue">
                            <span id="tempNumber">38.2</span>°C
                            <span class="temperature-icon" id="tempIcon">❄️</span>
                        </div>
                    </div>
                    <div class="temperature-bar-container">
                        <div class="temperature-bar" id="temperatureBar"></div>
                    </div>
                    <div class="temperature-message" id="temperatureMessage">
                        따뜻한 마음을 나눠주세요!
                    </div>
                </div>
            </div>

            <nav class="sidebar-menu">
                <div class="menu-section">
                    <a href="#" class="menu-item active" data-content="overview">
                        <i class="fas fa-home"></i>
                        <span>개요</span>
                    </a>
                </div>

                <div class="menu-section">
                    <div class="menu-section-title">복지 서비스</div>
                    <a href="#" class="menu-item" data-content="favorites">
                        <i class="fas fa-star"></i>
                        <span>관심 복지 서비스</span>
                    </a>
                </div>

                <div class="menu-section">
                    <div class="menu-section-title">참여 활동</div>
                    <a href="#" class="menu-item" data-content="volunteer">
                        <i class="fas fa-hands-helping"></i>
                        <span>봉사 활동</span>
                    </a>
                    <a href="#" class="menu-item" data-content="donation">
                        <i class="fas fa-hand-holding-heart"></i>
                        <span>기부 내역</span>
                    </a>
                </div>

                <div class="menu-section">
                    <div class="menu-section-title">계정</div>
                    <a href="#" class="menu-item" data-content="profile">
                        <i class="fas fa-user-cog"></i>
                        <span>내 정보 수정</span>
                    </a>
                    <a href="#" class="menu-item" data-content="notifications-list">
                        <i class="fas fa-clock"></i>
                        <span>최근 활동</span>
                    </a>
                    <a href="#" class="menu-item" data-content="settings">
                        <i class="fas fa-cog"></i>
                        <span>설정</span>
                    </a>
                    <a href="#" class="menu-item" id="logoutBtn" style="color: #dc3545; margin-top: 15px;">
                        <i class="fas fa-sign-out-alt"></i>
                        <span>로그아웃</span>
                    </a>
                </div>
            </nav>
        </aside>

        <!-- 메인 콘텐츠 -->
        <main class="main-content">
            <!-- 개요 페이지 -->
            <div id="content-overview" class="content-page">
                <div class="page-header">
                    <h1 class="page-title">대시보드</h1>
                    <p class="page-subtitle">나의 복지 활동을 한눈에 확인하세요</p>
                </div>

                <!-- 월별 캘린더 -->
                <div class="calendar-container">
                    <div class="calendar-header">
                        <div>
                            <h2 class="calendar-title" id="calendarTitle">2025년 1월</h2>
                            <div class="calendar-timezone">
                                <i class="fas fa-globe"></i>
                                <span id="userTimezone">로딩 중...</span>
                            </div>
                        </div>
                        <div class="calendar-nav-buttons">
                            <button class="calendar-nav-btn" onclick="previousMonth()">
                                <i class="fas fa-chevron-left"></i>
                            </button>
                            <button class="calendar-today-btn" onclick="goToToday()">오늘</button>
                            <button class="calendar-nav-btn" onclick="nextMonth()">
                                <i class="fas fa-chevron-right"></i>
                            </button>
                        </div>
                    </div>

                    <div class="calendar-weekdays">
                        <div class="calendar-weekday sunday">일</div>
                        <div class="calendar-weekday">월</div>
                        <div class="calendar-weekday">화</div>
                        <div class="calendar-weekday">수</div>
                        <div class="calendar-weekday">목</div>
                        <div class="calendar-weekday">금</div>
                        <div class="calendar-weekday saturday">토</div>
                    </div>

                    <div class="calendar-days" id="calendarDays">
                        <!-- JavaScript로 동적 생성 -->
                    </div>

                    <!-- 통계 카드 - 작은 버전 -->
                    <div class="stats-grid-small">
                        <div class="stat-card-small green">
                            <div class="stat-icon-small">
                                <i class="fas fa-hands-helping"></i>
                            </div>
                            <div class="stat-value-small" id="totalVolunteerHours">0건</div>
                            <div class="stat-label-small">봉사 신청</div>
                        </div>

                        <div class="stat-card-small red">
                            <div class="stat-icon-small">
                                <i class="fas fa-hand-holding-heart"></i>
                            </div>
                            <div class="stat-value-small" id="totalDonationAmount">0원</div>
                            <div class="stat-label-small">총 기부 금액</div>
                        </div>

                        <div class="stat-card-small orange">
                            <div class="stat-icon-small">
                                <i class="fas fa-star"></i>
                            </div>
                            <div class="stat-value-small" id="totalFavoriteServices">0개</div>
                            <div class="stat-label-small">관심 복지 서비스</div>
                        </div>
                    </div>
                </div>

                <!-- 알림 목록 -->
                <div class="content-section">
                    <h2 class="section-title">
                        <i class="fas fa-bell"></i>
                        알림
                    </h2>

                    <div class="notification-tabs" style="display: flex; gap: 10px; margin-bottom: 20px; flex-wrap: wrap; justify-content: space-between; align-items: center;">
                        <div style="display: flex; gap: 10px; flex-wrap: wrap;">
                            <button class="notification-filter-btn active" data-filter="all" onclick="filterNotifications('all')">
                                전체 <span class="badge-count" id="allCount">0</span>
                            </button>
                            <button class="notification-filter-btn" data-filter="unread" onclick="filterNotifications('unread')">
                                읽지 않음 <span class="badge-count" id="unreadCount">0</span>
                            </button>
                            <button class="notification-filter-btn" data-filter="faq_answer" onclick="filterNotifications('faq_answer')">
                                FAQ 답변
                            </button>
                            <button class="notification-filter-btn" data-filter="schedule" onclick="filterNotifications('schedule')">
                                일정
                            </button>
                            <button class="notification-filter-btn" data-filter="donation" onclick="filterNotifications('donation')">
                                기부
                            </button>
                            <button class="notification-filter-btn" data-filter="volunteer" onclick="filterNotifications('volunteer')">
                                봉사
                            </button>
                        </div>
                        <div style="display: flex; gap: 8px; align-items: center;">
                            <button onclick="markAllAsRead()" style="padding: 6px 12px; font-size: 13px; background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 4px; cursor: pointer; color: #495057; transition: all 0.2s;" onmouseover="this.style.background='#e9ecef'" onmouseout="this.style.background='#f8f9fa'">
                                <i class="fas fa-check-double"></i> 모두 읽음
                            </button>
                            <button onclick="deleteAllNotifications()" style="padding: 6px 12px; font-size: 13px; background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 4px; cursor: pointer; color: #dc3545; transition: all 0.2s;" onmouseover="this.style.background='#fee'; this.style.borderColor='#dc3545'" onmouseout="this.style.background='#f8f9fa'; this.style.borderColor='#dee2e6'">
                                <i class="fas fa-trash-alt"></i> 전체 삭제
                            </button>
                        </div>
                    </div>

                    <div class="notification-list" id="notificationList">
                        <div class="empty-state">
                            <i class="fas fa-bell"></i>
                            <p>받은 알림이 없습니다</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 내 정보 수정 페이지 -->
            <div id="content-profile" class="content-page" style="display: none;">
                <div class="page-header">
                    <h1 class="page-title">내 정보 수정</h1>
                    <p class="page-subtitle">회원 정보를 안전하게 관리하세요</p>
                </div>

                <!-- 기본 정보 -->
                <div class="content-section">
                    <h2 class="section-title">
                        <i class="fas fa-user"></i>
                        기본 정보
                    </h2>

                    <div class="alert alert-info">
                        <i class="fas fa-info-circle"></i>
                        <div>
                            <strong>정보 보호 안내</strong><br>
                            회원님의 개인정보는 안전하게 암호화되어 보관됩니다.
                        </div>
                    </div>

                    <form id="profileForm">
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">이름</label>
                                <input type="text" class="form-input" id="profileName" placeholder="이름을 입력하세요">
                            </div>
                            <div class="form-group">
                                <label class="form-label">성별</label>
                                <select class="form-select" id="profileGender">
                                    <option value="OTHER" selected>선택 안함</option>
                                    <option value="MALE">남성</option>
                                    <option value="FEMALE">여성</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">생년월일</label>
                                <input type="date" class="form-input" id="profileBirth">
                            </div>
                            <div class="form-group">
                                <label class="form-label">전화번호</label>
                                <input type="tel" class="form-input" id="profilePhone" placeholder="010-0000-0000">
                                <div class="form-help">'-' 포함하여 입력해주세요</div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">이메일</label>
                            <input type="email" class="form-input" id="profileEmail" placeholder="example@email.com" readonly>
                            <div class="form-help">로그인 및 알림 수신에 사용됩니다 (변경 불가)</div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">주소</label>
                            <div class="address-row">
                                <input type="text" class="form-input" id="profilePostcode" placeholder="우편번호" style="max-width: 150px;" readonly>
                                <button type="button" class="btn btn-outline" onclick="searchAddress()">주소 검색</button>
                            </div>
                            <input type="text" class="form-input" id="profileAddress" placeholder="기본 주소" readonly style="margin-bottom: 10px;">
                            <input type="text" class="form-input" id="profileDetailAddress" placeholder="상세 주소">
                        </div>

                        <div class="btn-group">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-save"></i>
                                변경사항 저장
                            </button>
                            <button type="button" class="btn btn-secondary" onclick="resetForm()">
                                <i class="fas fa-undo"></i>
                                취소
                            </button>
                        </div>
                    </form>
                </div>

                <!-- 비밀번호 변경 -->
                <div class="content-section">
                    <h2 class="section-title">
                        <i class="fas fa-lock"></i>
                        비밀번호 변경
                    </h2>

                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <div>
                            <strong>보안 필수사항</strong><br>
                            비밀번호는 8자 이상, 영문/숫자/특수문자를 모두 포함해야 합니다.
                        </div>
                    </div>

                    <form id="passwordForm">
                        <div class="form-group">
                            <label class="form-label">현재 비밀번호</label>
                            <input type="password" class="form-input" placeholder="현재 비밀번호를 입력하세요" id="currentPassword">
                        </div>

                        <div class="form-group">
                            <label class="form-label">새 비밀번호</label>
                            <input type="password" class="form-input" placeholder="새 비밀번호를 입력하세요" id="newPassword">
                            <div class="password-strength">
                                <div class="password-strength-bar" id="strengthBar"></div>
                            </div>
                            <div class="form-help" id="strengthText">비밀번호 강도: -</div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">새 비밀번호 확인</label>
                            <input type="password" class="form-input" placeholder="새 비밀번호를 다시 입력하세요" id="confirmPassword">
                            <div class="form-help" id="matchText"></div>
                        </div>

                        <div class="btn-group">
                            <button type="submit" class="btn btn-primary">
                                <i class="fas fa-key"></i>
                                비밀번호 변경
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <!-- 기타 콘텐츠 페이지들 -->

            <div id="content-favorites" class="content-page" style="display: none;">
                <div class="page-header">
                    <h1 class="page-title">관심 복지 서비스</h1>
                    <p class="page-subtitle">관심 등록한 복지 서비스 목록입니다</p>
                </div>
                <div id="favoriteListContainer">
                    <div class="empty-state">
                        <i class="fas fa-spinner fa-spin"></i>
                        <p>관심 서비스를 불러오는 중...</p>
                    </div>
                </div>
            </div>

            <div id="content-volunteer" class="content-page" style="display: none;">
                <div class="page-header">
                    <h1 class="page-title">봉사 활동</h1>
                    <p class="page-subtitle">참여한 봉사 활동 내역입니다</p>
                </div>
                <div class="content-section">
                    <h2 class="section-title">
                        <i class="fas fa-list"></i>
                        봉사 활동 내역
                    </h2>
                    <div id="volunteerListContainer">
                        <div class="empty-state">
                            <i class="fas fa-spinner fa-spin"></i>
                            <p>봉사 내역을 불러오는 중...</p>
                        </div>
                    </div>
                </div>
            </div>

            <div id="content-donation" class="content-page" style="display: none;">
                <div class="page-header">
                    <h1 class="page-title">기부 내역</h1>
                    <p class="page-subtitle">나눔의 따뜻한 발자취를 확인하세요</p>
                </div>
                <div class="content-section">
                    <h2 class="section-title">
                        <i class="fas fa-heart"></i>
                        기부 내역
                    </h2>
                    <div id="donationListContainer">
                        <div class="empty-state">
                            <i class="fas fa-spinner fa-spin"></i>
                            <p>기부 내역을 불러오는 중...</p>
                        </div>
                    </div>
                </div>
            </div>

            <!-- 최근 활동 페이지 -->
            <div id="content-notifications-list" class="content-page" style="display: none;">
                <div class="page-header">
                    <h1 class="page-title">최근 활동</h1>
                    <p class="page-subtitle">최근 활동 내역을 확인하세요</p>
                </div>

                <div class="content-section">
                    <div style="display: flex; justify-content: flex-end; margin-bottom: 15px;">
                        <button onclick="deleteAllRecentActivities()" style="padding: 6px 12px; font-size: 13px; background: #f8f9fa; border: 1px solid #dee2e6; border-radius: 4px; cursor: pointer; color: #dc3545; transition: all 0.2s;" onmouseover="this.style.background='#fee'; this.style.borderColor='#dc3545'" onmouseout="this.style.background='#f8f9fa'; this.style.borderColor='#dee2e6'">
                            <i class="fas fa-trash-alt"></i> 전체 삭제
                        </button>
                    </div>
                    <div id="recentActivityList">
                        <!-- 동적으로 생성됨 -->
                    </div>
                </div>
            </div>

            <!-- 설정 페이지 (알림 설정 + 보안 설정 통합) -->
            <div id="content-settings" class="content-page" style="display: none;">
                <div class="page-header">
                    <h1 class="page-title">설정</h1>
                    <p class="page-subtitle">알림, 보안 및 개인정보 설정을 관리하세요</p>
                </div>

                <!-- 알림 설정 섹션 -->
                <div class="content-section">
                    <h2 class="section-title">
                        <i class="fas fa-bell"></i>
                        알림 설정
                    </h2>
                    <div class="settings-item">
                        <div class="settings-label">
                            <i class="fas fa-calendar"></i>
                            <div>
                                <strong>일정 알림</strong>
                                <p class="settings-desc">등록된 일정 하루 전 알림</p>
                            </div>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" id="eventNotification" onchange="saveNotificationSettings()">
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                    <div class="settings-item">
                        <div class="settings-label">
                            <i class="fas fa-heart"></i>
                            <div>
                                <strong>기부 알림</strong>
                                <p class="settings-desc">정기 기부일 안내</p>
                            </div>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" id="donationNotification" onchange="saveNotificationSettings()">
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                    <div class="settings-item">
                        <div class="settings-label">
                            <i class="fas fa-hands-helping"></i>
                            <div>
                                <strong>봉사 활동 알림</strong>
                                <p class="settings-desc">예정된 봉사 활동 안내</p>
                            </div>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" id="volunteerNotification" onchange="saveNotificationSettings()">
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                    <div class="settings-item">
                        <div class="settings-label">
                            <i class="fas fa-comment-alt"></i>
                            <div>
                                <strong>FAQ 답변 알림</strong>
                                <p class="settings-desc">내가 작성한 질문에 답변이 달렸을 때 알림</p>
                            </div>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" id="faqAnswerNotification" onchange="saveNotificationSettings()">
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                </div>

                <div class="content-section">
                    <h2 class="section-title">
                        <i class="fas fa-user-shield"></i>
                        개인정보 관리
                    </h2>
                    <div class="settings-item">
                        <div class="settings-label">
                            <i class="fas fa-history"></i>
                            <div>
                                <strong>최근 활동 기록</strong>
                                <p class="settings-desc">대시보드에 최근 활동 내역 표시</p>
                            </div>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" id="activityHistoryEnabled" checked onchange="saveSecuritySettings()">
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                    <div class="settings-item">
                        <div class="settings-label">
                            <i class="fas fa-key"></i>
                            <div>
                                <strong>로그인 상태 유지</strong>
                                <p class="settings-desc">로그인 상태를 30일간 유지합니다 (자동 로그인)</p>
                            </div>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" id="autoLoginEnabled" onchange="toggleAutoLogin()">
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                </div>

                <div class="content-section">
                    <h2 class="section-title">
                        <i class="fas fa-user-times"></i>
                        회원 탈퇴
                    </h2>
                    <div class="list-item">
                        <div class="list-item-content">
                            <p style="color: #856404; background: #fff3cd; padding: 10px; border-radius: 4px; margin-bottom: 10px;">
                                <i class="fas fa-exclamation-triangle"></i>
                                경고: 탈퇴 시 모든 개인 정보 및 활동 내역이 영구적으로 삭제되며 복구할 수 없습니다.
                            </p>
                            <button class="btn-primary" onclick="showWithdrawModal()" style="margin-top: 10px; padding: 8px 16px; font-size: 14px; background: #dc3545; border-color: #dc3545; border-radius: 8px;">
                                회원 탈퇴
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
    </div>

    <!-- 회원 탈퇴 확인 모달 -->
    <div id="withdrawModal" style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0, 0, 0, 0.5); z-index: 10000; justify-content: center; align-items: center;">
        <div style="background: white; padding: 40px; border-radius: 16px; max-width: 450px; width: 90%; box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);">
            <div style="text-align: center; margin-bottom: 25px;">
                <div style="font-size: 50px; margin-bottom: 15px;">⚠️</div>
                <h2 style="font-size: 24px; font-weight: 700; color: #dc3545; margin-bottom: 10px;">회원 탈퇴</h2>
                <p style="font-size: 14px; color: #6c757d; line-height: 1.6;">
                    본인 확인을 위해 비밀번호를 입력해주세요.<br>
                    탈퇴 시 모든 정보가 영구적으로 삭제됩니다.
                </p>
            </div>

            <div style="margin-bottom: 20px;">
                <label style="display: block; font-size: 14px; font-weight: 600; color: #333; margin-bottom: 8px;">
                    비밀번호
                </label>
                <input
                    type="password"
                    id="withdrawPassword"
                    placeholder="현재 비밀번호를 입력하세요"
                    style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 14px;"
                    onkeypress="if(event.key === 'Enter') processWithdraw();"
                />
            </div>

            <div style="display: flex; gap: 10px;">
                <button
                    onclick="closeWithdrawModal()"
                    style="flex: 1; padding: 12px; background: #6c757d; color: white; border: none; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer; transition: all 0.2s;"
                    onmouseover="this.style.background='#5a6268'"
                    onmouseout="this.style.background='#6c757d'">
                    취소
                </button>
                <button
                    onclick="processWithdraw()"
                    style="flex: 1; padding: 12px; background: #dc3545; color: white; border: none; border-radius: 8px; font-size: 15px; font-weight: 600; cursor: pointer; transition: all 0.2s;"
                    onmouseover="this.style.background='#c82333'"
                    onmouseout="this.style.background='#dc3545'">
                    탈퇴하기
                </button>
            </div>
        </div>
    </div>

    <!-- 일정 추가/편집 모달 -->
    <div class="modal-overlay" id="eventModal">
        <div class="modal-container">
            <div class="modal-header">
                <h3>
                    <i class="fas fa-calendar-plus"></i>
                    <span id="modalTitle">일정 추가</span>
                </h3>
                <button class="modal-close" onclick="closeEventModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body">
                <div class="modal-date-info">
                    <h4 id="selectedDateDisplay"></h4>
                </div>

                <div class="date-selection-row">
                    <div class="date-box">
                        <label class="date-box-label">시작 날짜</label>
                        <div class="date-display" id="startDateDisplay">2025년 10월 2일</div>
                    </div>
                    <div class="date-box">
                        <label class="date-box-label">종료 날짜</label>
                        <input type="date" id="eventEndDate" class="date-input-field">
                    </div>
                </div>

                <form id="eventForm">
                    <div class="event-form-group">
                        <label class="event-form-label">일정 제목 <span style="color: #999; font-size: 12px;">(최대 12글자)</span></label>
                        <input type="text" id="eventTitle" class="event-form-input" placeholder="예: 복지관 봉사" maxlength="12" required>
                    </div>

                    <div class="event-form-group">
                        <label class="event-form-label">상세 내용</label>
                        <textarea id="eventDescription" class="event-form-textarea" placeholder="일정에 대한 상세 내용을 입력하세요"></textarea>
                    </div>
                </form>

                <div class="event-list">
                    <div class="event-list-title">
                        <i class="fas fa-list"></i>
                        등록된 일정
                    </div>
                    <div id="eventListContainer">
                        <div class="event-empty">
                            <i class="fas fa-calendar-alt"></i>
                            <p>등록된 일정이 없습니다</p>
                        </div>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="modal-btn modal-btn-secondary" onclick="closeEventModal()">닫기</button>
                <button type="button" class="modal-btn modal-btn-primary" onclick="saveEvent()">
                    <i class="fas fa-save"></i> 저장
                </button>
            </div>
        </div>
    </div>

    <!-- FAQ 질문/답변 상세 모달 -->
    <div class="modal-overlay" id="faqDetailModal" style="display: none;">
        <div class="modal-container" style="max-width: 600px;">
            <div class="modal-header">
                <h3 style="margin: 0; display: flex; align-items: center; gap: 10px;">
                    <i class="fas fa-question-circle" style="color: #9b59b6;"></i>
                    <span>질문/답변 상세</span>
                </h3>
                <button class="modal-close" onclick="closeFaqDetailModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="modal-body" style="padding: 20px;">
                <div id="faqDetailContent">
                    <div class="loading-spinner" style="text-align: center; padding: 40px;">
                        <i class="fas fa-spinner fa-spin fa-2x"></i>
                        <p>로딩 중...</p>
                    </div>
                </div>
            </div>
            <div class="modal-footer">
                <button type="button" class="modal-btn modal-btn-secondary" onclick="closeFaqDetailModal()">닫기</button>
            </div>
        </div>
    </div>

       <%@ include file="footer.jsp" %>
    <!-- Daum 주소 API -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>


    <script>
        // 전역 변수 (JSP 표현식)
        const contextPath = '<%= request.getContextPath() %>';
        let currentUserId = '<%= session.getAttribute("id") != null ? session.getAttribute("id") : "" %>';
    </script>
    <script src="<%=request.getContextPath()%>/resources/js/project_mypage.js"></script>

    <!-- 봉사 활동 상세 정보 모달 -->
    <div id="volunteerDetailModal" class="review-modal" style="display: none;">
        <div class="review-modal-content">
            <div class="review-modal-header">
                <h2>봉사 활동 상세 정보</h2>
                <button class="review-modal-close" onclick="closeVolunteerDetailModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="review-modal-body" id="volunteerDetailContent">
                <!-- 상세 정보가 동적으로 채워집니다 -->
            </div>
        </div>
    </div>

    <!-- 기부 상세 정보 모달 -->
    <div id="donationDetailModal" class="review-modal" style="display: none;">
        <div class="review-modal-content">
            <div class="review-modal-header">
                <h2>기부 상세 정보</h2>
                <button class="review-modal-close" onclick="closeDonationDetailModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="review-modal-body" id="donationDetailContent">
                <!-- 상세 정보가 동적으로 채워집니다 -->
            </div>
        </div>
    </div>

    <!-- 기부 리뷰 작성 모달 -->
    <div id="donationReviewModal" class="review-modal" style="display: none;">
        <div class="review-modal-content">
            <div class="review-modal-header">
                <h2>기부 후기 작성</h2>
                <button class="review-modal-close" onclick="closeDonationReviewModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="review-modal-body">
                <p class="review-activity-info">
                    <i class="fas fa-heart"></i>
                    <span id="donationReviewTitle"></span>
                    <span id="donationReviewAmount" style="margin-left: 10px; color: #666;"></span>
                </p>
                <input type="hidden" id="donationReviewDonationId">
                <form id="donationReviewForm">
                    <div class="review-form-group">
                        <label for="donationReviewTitleInput">제목</label>
                        <input type="text" id="donationReviewTitleInput" class="review-input" placeholder="후기 제목을 입력하세요" maxlength="100" required>
                    </div>
                    <div class="review-form-group">
                        <label for="donationReviewContent">내용</label>
                        <textarea id="donationReviewContent" class="review-textarea" placeholder="기부 경험을 자유롭게 작성해주세요. 다른 분들에게 기부 참여 동기가 될 수 있습니다." rows="8" required></textarea>
                    </div>
                    <div class="review-form-group">
                        <label for="donationReviewRating">만족도</label>
                        <select id="donationReviewRating" class="review-select">
                            <option value="5">⭐⭐⭐⭐⭐ 매우 만족</option>
                            <option value="4">⭐⭐⭐⭐ 만족</option>
                            <option value="3">⭐⭐⭐ 보통</option>
                            <option value="2">⭐⭐ 불만족</option>
                            <option value="1">⭐ 매우 불만족</option>
                        </select>
                    </div>
                    <div class="review-form-actions">
                        <button type="button" class="review-btn review-btn-cancel" onclick="closeDonationReviewModal()">취소</button>
                        <button type="submit" class="review-btn review-btn-submit">작성하기</button>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <!-- 봉사 후기 작성 모달 -->
    <div id="reviewModal" class="review-modal">
        <div class="review-modal-content">
            <div class="review-modal-header">
                <h2>봉사 후기 작성</h2>
                <button class="review-modal-close" onclick="closeReviewModal()">
                    <i class="fas fa-times"></i>
                </button>
            </div>
            <div class="review-modal-body">
                <p class="review-activity-info">
                    <i class="fas fa-hands-helping"></i>
                    <span id="reviewActivityName"></span>
                </p>
                <form id="reviewForm">
                    <div class="review-form-group">
                        <label for="reviewTitle">제목</label>
                        <input type="text" id="reviewTitle" class="review-input" placeholder="후기 제목을 입력하세요" maxlength="100" required>
                    </div>
                    <div class="review-form-group">
                        <label for="reviewContent">내용</label>
                        <textarea id="reviewContent" class="review-textarea" placeholder="봉사 활동 경험을 자유롭게 작성해주세요" rows="8" required></textarea>
                    </div>
                    <div class="review-form-group">
                        <label for="reviewRating">만족도 (선택)</label>
                        <select id="reviewRating" class="review-select">
                            <option value="">선택하지 않음</option>
                            <option value="5">⭐⭐⭐⭐⭐ 매우 만족</option>
                            <option value="4">⭐⭐⭐⭐ 만족</option>
                            <option value="3">⭐⭐⭐ 보통</option>
                            <option value="2">⭐⭐ 불만족</option>
                            <option value="1">⭐ 매우 불만족</option>
                        </select>
                    </div>
                    <div class="review-form-actions">
                        <button type="button" class="review-btn review-btn-cancel" onclick="closeReviewModal()">취소</button>
                        <button type="submit" class="review-btn review-btn-submit">작성하기</button>
                    </div>
                </form>
            </div>
        </div>
    </div>
</body>
</html>