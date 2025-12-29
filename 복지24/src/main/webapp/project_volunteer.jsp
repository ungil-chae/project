<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>봉사 신청 - 복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="resources/css/project_volunteer.css">
</head>
<body>
    <%@ include file="navbar.jsp" %>

    <!-- 히어로 섹션 -->
    <section class="hero-section">
        <h1 class="hero-title">함께하는 <span class="highlight">봉사</span>, 더 따뜻한 세상</h1>
        <p class="hero-subtitle">
            여러분의 시간과 정성이 누군가에게는 큰 힘이 됩니다. 복지24와 함께 의미 있는 봉사활동을 시작하세요.
        </p>
    </section>

    <div id="volunteer-container">
        <!-- Step 1: Volunteer Activity Selection -->
        <div id="volunteer-step1" class="volunteer-step">
            <div class="volunteer-box">
                <h2 class="volunteer-title">
                    <span>봉사 활동 선택</span>
                    <!-- Step Indicator -->
                    <div class="step-indicator">
                        <div class="step">
                            <div class="step-number active" id="step1Number">1</div>
                            <div class="step-text active" id="step1Text">봉사 활동 선택</div>
                        </div>
                        <div class="step-connector"></div>
                        <div class="step">
                            <div class="step-number" id="step2Number">2</div>
                            <div class="step-text" id="step2Text">봉사자 정보</div>
                        </div>
                        <div class="step-connector"></div>
                        <div class="step">
                            <div class="step-number" id="step3Number">3</div>
                            <div class="step-text" id="step3Text">신청 완료</div>
                        </div>
                    </div>
                </h2>
                <p class="volunteer-subtitle">관심 있는 봉사 활동 분야를 선택해주세요.</p>

                <div class="volunteer-categories">
                    <div class="volunteer-category" data-category="노인돌봄">
                        <div class="category-icon">
                            <i class="fas fa-hands-helping" style="color: #e74c3c; font-size: 24px"></i>
                        </div>
                        <div class="category-title">노인 돌봄</div>
                        <div class="category-desc">어르신들과 함께하는 시간을 통해 따뜻한 마음을 나눠보세요.</div>
                    </div>

                    <div class="volunteer-category" data-category="환경보호">
                        <div class="category-icon">
                            <i class="fas fa-leaf" style="color: #2ecc71; font-size: 24px"></i>
                        </div>
                        <div class="category-title">환경 보호</div>
                        <div class="category-desc">깨끗한 환경을 위한 실천 활동에 동참해주세요.</div>
                    </div>

                    <div class="volunteer-category" data-category="아동교육">
                        <div class="category-icon">
                            <i class="fas fa-book-reader" style="color: #3498db; font-size: 24px"></i>
                        </div>
                        <div class="category-title">아동 교육</div>
                        <div class="category-desc">아이들의 꿈을 키워주는 교육 봉사에 참여하세요.</div>
                    </div>

                    <div class="volunteer-category" data-category="장애인지원">
                        <div class="category-icon">
                            <i class="fas fa-wheelchair" style="color: #9b59b6; font-size: 24px"></i>
                        </div>
                        <div class="category-title">장애인 지원</div>
                        <div class="category-desc">장애인의 일상을 돕고 함께 성장하는 시간을 가져보세요.</div>
                    </div>

                    <div class="volunteer-category" data-category="재능기부">
                        <div class="category-icon">
                            <i class="fas fa-palette" style="color: #f39c12; font-size: 24px"></i>
                        </div>
                        <div class="category-title">재능 기부</div>
                        <div class="category-desc">내 재능을 나누며 더 나은 사회를 만들어보세요.</div>
                    </div>

                    <div class="volunteer-category" data-category="반려동물">
                        <div class="category-icon">
                            <i class="fas fa-paw" style="color: #e67e22; font-size: 24px"></i>
                        </div>
                        <div class="category-title">반려동물 돌봄</div>
                        <div class="category-desc">유기동물 보호와 돌봄 활동에 함께해주세요.</div>
                    </div>
                </div>

                <div class="volunteer-form">
                    <div class="form-group">
                        <label class="form-label" for="region">지역 선택</label>
                        <select class="form-select" id="region" required>
                            <option value="">지역을 선택하세요</option>
                            <option value="서울">서울특별시</option>
                            <option value="경기">경기도</option>
                            <option value="인천">인천광역시</option>
                            <option value="부산">부산광역시</option>
                            <option value="대구">대구광역시</option>
                            <option value="광주">광주광역시</option>
                            <option value="대전">대전광역시</option>
                            <option value="울산">울산광역시</option>
                            <option value="세종">세종특별자치시</option>
                            <option value="강원">강원도</option>
                            <option value="충북">충청북도</option>
                            <option value="충남">충청남도</option>
                            <option value="전북">전라북도</option>
                            <option value="전남">전라남도</option>
                            <option value="경북">경상북도</option>
                            <option value="경남">경상남도</option>
                            <option value="제주">제주특별자치도</option>
                        </select>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="preferredDate">희망 봉사 기간</label>
                        <div class="date-time-group">
                            <input type="date" class="form-input" id="startDate" required>
                            <span style="display: flex; align-items: center;">~</span>
                            <input type="date" class="form-input" id="endDate" required>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label" for="availableTime">참여 가능 시간대</label>
                        <div class="radio-group">
                            <div>
                                <input type="radio" id="time_morning" name="availableTime" value="오전">
                                <label for="time_morning">오전 (09:00-12:00)</label>
                            </div>
                            <div>
                                <input type="radio" id="time_afternoon" name="availableTime" value="오후">
                                <label for="time_afternoon">오후 (13:00-18:00)</label>
                            </div>
                            <div>
                                <input type="radio" id="time_allday" name="availableTime" value="종일">
                                <label for="time_allday">종일</label>
                            </div>
                            <div>
                                <input type="radio" id="time_flexible" name="availableTime" value="조율가능">
                                <label for="time_flexible">조율 가능</label>
                            </div>
                        </div>
                    </div>
                </div>

                <div class="form-navigation-btns">
                    <div></div>
                    <button class="next-btn" id="nextBtn">다음</button>
                </div>
            </div>
        </div>

        <!-- Step 2: Volunteer Information -->
        <div id="volunteer-step2" class="volunteer-step">
            <div class="volunteer-box">
                <h2 class="volunteer-title">
                    <span>봉사자 정보</span>
                    <!-- Step Indicator -->
                    <div class="step-indicator">
                        <div class="step">
                            <div class="step-number" id="step1Number-s2">1</div>
                            <div class="step-text" id="step1Text-s2">봉사 활동 선택</div>
                        </div>
                        <div class="step-connector"></div>
                        <div class="step">
                            <div class="step-number active" id="step2Number-s2">2</div>
                            <div class="step-text active" id="step2Text-s2">봉사자 정보</div>
                        </div>
                        <div class="step-connector"></div>
                        <div class="step">
                            <div class="step-number" id="step3Number-s2">3</div>
                            <div class="step-text" id="step3Text-s2">신청 완료</div>
                        </div>
                    </div>
                </h2>
                <p class="volunteer-subtitle">봉사 활동을 위한 정보를 입력해주세요.</p>

                <form class="volunteer-form" id="volunteerForm">
                    <div class="form-group">
                        <label class="form-label" for="volunteerName">이름</label>
                        <input type="text" id="volunteerName" class="form-input" placeholder="이름을 입력하세요" oninput="lettersOnly(this)" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="volunteerPhone">전화번호</label>
                        <input type="text" id="volunteerPhone" class="form-input" placeholder="'-' 없이 숫자만 입력" maxlength="11" oninput="numbersOnly(this)" required>
                    </div>

                    <div class="form-group">
                        <label class="form-label">이메일</label>
                        <div class="email-group">
                            <input type="text" id="emailUser" class="form-input" placeholder="이메일 아이디" />
                            <span class="email-at">@</span>
                            <input type="text" id="emailDomain" class="form-input" placeholder="직접입력" />
                            <select id="emailDomainSelect" class="form-select">
                                <option value="">직접입력</option>
                                <option value="naver.com">naver.com</option>
                                <option value="gmail.com">gmail.com</option>
                                <option value="hanmail.net">hanmail.net</option>
                                <option value="daum.net">daum.net</option>
                                <option value="nate.com">nate.com</option>
                            </select>
                        </div>
                    </div>

                    <div class="form-group">
                        <label class="form-label" for="volunteerBirth">생년월일</label>
                        <input type="text" id="volunteerBirth" class="form-input" placeholder="8자리 입력 (예: 19900101)" maxlength="8" oninput="numbersOnly(this)" required>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label">주소</label>
                        <div class="address-row">
                            <div class="address-group">
                                <input type="text" id="postcode" class="form-input" placeholder="우편번호" readonly>
                                <button type="button" id="searchAddressBtn">주소검색</button>
                            </div>
                            <input type="text" id="address" class="form-input" placeholder="주소" readonly style="flex: 2;">
                        </div>
                        <input type="text" id="detailAddress" class="form-input" placeholder="상세주소">
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label" for="experience">봉사 경험</label>
                        <div class="radio-group">
                            <div>
                                <input type="radio" id="exp_none" name="experience" value="없음">
                                <label for="exp_none">없음</label>
                            </div>
                            <div>
                                <input type="radio" id="exp_beginner" name="experience" value="1년 미만">
                                <label for="exp_beginner">1년 미만</label>
                            </div>
                            <div>
                                <input type="radio" id="exp_intermediate" name="experience" value="1-3년">
                                <label for="exp_intermediate">1-3년</label>
                            </div>
                            <div>
                                <input type="radio" id="exp_expert" name="experience" value="3년 이상">
                                <label for="exp_expert">3년 이상</label>
                            </div>
                        </div>
                    </div>

                    <div class="form-group full-width">
                        <label class="form-label" for="motivation">지원 동기</label>
                        <textarea id="motivation" class="form-textarea" placeholder="봉사 활동에 참여하고자 하는 동기를 간단히 작성해주세요."></textarea>
                    </div>
                </form>

                <div class="form-navigation-btns">
                    <button class="back-btn" id="backBtn">뒤로</button>
                    <button class="next-btn" id="goToStep3Btn">다음</button>
                </div>
            </div>
        </div>

        <!-- Step 3: Confirmation -->
        <div id="volunteer-step3" class="volunteer-step">
            <div class="volunteer-box">
                <h2 class="volunteer-title">
                    <span>신청 정보 확인</span>
                    <!-- Step Indicator -->
                    <div class="step-indicator">
                        <div class="step">
                            <div class="step-number" id="step1Number-s3">1</div>
                            <div class="step-text" id="step1Text-s3">봉사 활동 선택</div>
                        </div>
                        <div class="step-connector"></div>
                        <div class="step">
                            <div class="step-number" id="step2Number-s3">2</div>
                            <div class="step-text" id="step2Text-s3">봉사자 정보</div>
                        </div>
                        <div class="step-connector"></div>
                        <div class="step">
                            <div class="step-number active" id="step3Number-s3">3</div>
                            <div class="step-text active" id="step3Text-s3">신청 완료</div>
                        </div>
                    </div>
                </h2>
                <p class="volunteer-subtitle">입력하신 정보를 확인해주세요.</p>

                <div class="summary-box">
                    <h3 class="summary-title">봉사 활동 정보</h3>
                    <div class="summary-item">
                        <span class="summary-label">선택한 봉사 활동</span>
                        <span class="summary-value" id="summary-category">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">지역</span>
                        <span class="summary-value" id="summary-region">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">봉사 기간</span>
                        <span class="summary-value" id="summary-date">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">참여 시간대</span>
                        <span class="summary-value" id="summary-time">-</span>
                    </div>
                </div>

                <div class="summary-box">
                    <h3 class="summary-title">봉사자 정보</h3>
                    <div class="summary-item">
                        <span class="summary-label">이름</span>
                        <span class="summary-value" id="summary-name">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">전화번호</span>
                        <span class="summary-value" id="summary-phone">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">이메일</span>
                        <span class="summary-value" id="summary-email">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">주소</span>
                        <span class="summary-value" id="summary-address">-</span>
                    </div>
                    <div class="summary-item">
                        <span class="summary-label">봉사 경험</span>
                        <span class="summary-value" id="summary-experience">-</span>
                    </div>
                </div>

                <div class="agreement-section">
                    <div class="agreement-item all-agree">
                        <label>
                            <input type="checkbox" id="agreeAll">
                            개인정보 수집 및 이용에 모두 동의합니다.
                        </label>
                    </div>
                    <div class="agreement-item">
                        <label>
                            <input type="checkbox" class="agree-item">
                            개인정보 수집 및 이용 동의 (필수)
                        </label>
                    </div>
                    <div class="agreement-item">
                        <label>
                            <input type="checkbox" class="agree-item">
                            봉사 활동 안내 및 알림 수신 동의 (선택)
                        </label>
                    </div>
                </div>

                <div class="form-navigation-btns">
                    <button class="back-btn" id="backToStep2Btn">뒤로</button>
                    <button class="next-btn" id="finalSubmitBtn">신청 완료</button>
                </div>
            </div>
        </div>
    </div>

    <!-- Daum Postcode API -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <!-- JSP 표현식으로 userId를 전달 -->
    <script>
        window.currentUserId = '<%= session.getAttribute("id") != null ? session.getAttribute("id") : "guest" %>';
    </script>

    <!-- 외부 JavaScript 파일 참조 -->
    <script src="resources/js/project_volunteer.js"></script>

        <%@ include file="footer.jsp" %>
</body>
</html>
