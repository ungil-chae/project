<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
  // 세션에서 사용자 정보 가져오기
  String username = (String) session.getAttribute("username");
  if (username == null || username.trim().isEmpty()) {
    username = "후원자"; // 기본값
  } else {
    username = username.trim(); // 공백 제거
  }

  // URL 파라미터에서 기부 정보 수신
  String donationAmount = request.getParameter("amount");
  String donationCategory = request.getParameter("category");
  String donationType = request.getParameter("type");

  // 파라미터가 있으면 첫 번째 단계를 건너뛰기
  boolean skipFirstStep = false;

  // 더 확실한 검증
  if (donationAmount != null) {
    String trimmedAmount = donationAmount.trim();
    if (trimmedAmount.length() > 0 && !trimmedAmount.equals("null") && !trimmedAmount.equals("")) {
      skipFirstStep = true;
    }
  }

  // 추가 검증: category나 type이 있어도 건너뛰기
  if (!skipFirstStep && donationCategory != null && !donationCategory.trim().isEmpty()) {
    skipFirstStep = true;
  }
  if (!skipFirstStep && donationType != null && !donationType.trim().isEmpty()) {
    skipFirstStep = true;
  }

  // 단계 표시기 클래스 변수들
  String step1NumberClass = "";
  String step1TextClass = "";
  String step2NumberClass = "";
  String step2TextClass = "";

  if (skipFirstStep) {
    step2NumberClass = " active";
    step2TextClass = " active";
  } else {
    step1NumberClass = " active";
    step1TextClass = " active";
  }
%>
<!DOCTYPE html>
<html lang="ko">
  <head>
    <meta charset="UTF-8" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />
    <title>복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png" />
    <link
      rel="stylesheet"
      href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css"
    />
    <link rel="stylesheet" href="resources/css/project_Donation.css" />
  </head>
  <body>
    <%@ include file="navbar.jsp" %>

    <!-- 히어로 섹션 -->
    <section class="hero-section">
      <h1 class="hero-title">나눔으로 세상을 <span class="highlight">변화</span>시킵니다</h1>
      <p class="hero-subtitle">
        여러분의 작은 나눔이 누군가에게는 큰 희망이 됩니다. 복지24와 함께 따뜻한 사회를 만들어가세요.
      </p>
    </section>

    <!-- DEBUG: skipFirstStep=<%= skipFirstStep %> -->
    <!-- amount=[<%= donationAmount %>] len=<%= donationAmount != null ? donationAmount.length() : "null" %> -->
    <!-- category=[<%= donationCategory %>] type=[<%= donationType %>] -->
    <!-- step1Class=[<%= step1NumberClass %>] step2Class=[<%= step2NumberClass %>] -->

    <div id="donation-container"<%= skipFirstStep ? " class=\"view-step2\"" : "" %>>
      <!-- Step 1: Donation Form -->
      <% if (!skipFirstStep) { %>
      <div id="donation-step1" class="donation-step">
        <div class="donation-left-box">
          <h2 class="donation-title">기부하기</h2>
          <p class="donation-subtitle">당신의 나눔이 모두의 행복입니다.</p>
          <form class="donation-form" id="donationForm">
            <div class="form-group">
              <label class="form-label">기부금액 선택</label>
              <select class="form-select" id="donationAmount">
                <option value="">직접입력</option>
                <option value="5000">5,000원</option>
                <option value="10000">10,000원</option>
                <option value="20000">20,000원</option>
                <option value="30000">30,000원</option>
                <option value="50000">50,000원</option>
                <option value="100000">100,000원</option>
              </select>
            </div>
            <div class="form-group">
              <label class="form-label">기부금액을 입력하세요</label>
              <input
                type="text"
                class="form-input"
                id="amountInput"
                placeholder="원"
              />
            </div>
            <div class="donation-buttons">
              <button type="button" class="donation-btn" id="regularBtn">
                정기기부
              </button>
              <button type="button" class="donation-btn" id="onetimeBtn">
                일시기부
              </button>
            </div>
            <!-- 정기 기부 시작 날짜 선택 폼 (정기 기부 선택 시에만 표시) -->
            <div id="regularStartDateContainer" style="display: none; margin-top: 20px;">
              <label for="regularStartDateInput" style="display: block; margin-bottom: 8px; font-weight: 600; color: #333;">
                정기 기부 시작일 선택 <span style="color: #e74c3c;">*</span>
              </label>
              <input
                type="date"
                id="regularStartDateInput"
                class="form-input"
                style="width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 8px; font-size: 15px;"
                min="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>"
              />
              <p style="font-size: 13px; color: #666; margin-top: 8px;">
              </p>
            </div>
          </form>
        </div>
        <div class="donation-right-box">
          <h3 class="donation-methods-title">
            <span>기부 참여 분야</span>
            <!-- Step Indicator -->
            <div class="step-indicator">
              <div class="step">
                <div class="step-number<%= step1NumberClass %>" id="step1Number">1</div>
                <div class="step-text<%= step1TextClass %>" id="step1Text">기부하기</div>
              </div>
              <div class="step-connector"></div>
              <div class="step">
                <div class="step-number<%= step2NumberClass %>" id="step2Number">2</div>
                <div class="step-text<%= step2TextClass %>" id="step2Text">후원자 정보</div>
              </div>
              <div class="step-connector"></div>
              <div class="step">
                <div class="step-number" id="step3Number">3</div>
                <div class="step-text" id="step3Text">결제 수단</div>
              </div>
            </div>
          </h3>
          <div class="donation-categories">
            <div class="donation-category" data-category="위기가정">
              <div class="category-icon">
                <i class="fas fa-home" style="color: #e74c3c; font-size: 20px"></i>
              </div>
              <div class="category-content">
                <div class="category-title">위기가정</div>
                <div class="category-desc">
                  갑작스러운 어려움에 처한 가족이 다시 일어설 수 있도록 돕습니다.
                </div>
              </div>
            </div>
            <div class="donation-category" data-category="화재피해">
              <div class="category-icon">
                <i class="fas fa-fire" style="color: #e67e22; font-size: 20px"></i>
              </div>
              <div class="category-content">
                <div class="category-title">화재 피해 가정 돕기</div>
                <div class="category-desc">
                  화재로 삶의 터전을 잃은 이웃에게 희망을 전합니다.
                </div>
              </div>
            </div>
            <div class="donation-category" data-category="자연재해">
              <div class="category-icon">
                <i class="fas fa-cloud-rain" style="color: #3498db; font-size: 20px"></i>
              </div>
              <div class="category-content">
                <div class="category-title">자연재해 이재민 돕기</div>
                <div class="category-desc">
                  자연재해로 고통받는 사람들을 위해 긴급 구호 활동을 펼칩니다.
                </div>
              </div>
            </div>
            <div class="donation-category" data-category="의료비">
              <div class="category-icon">
                <i class="fas fa-heartbeat" style="color: #e74c3c; font-size: 20px"></i>
              </div>
              <div class="category-content">
                <div class="category-title">긴급 의료비 지원 돕기</div>
                <div class="category-desc">
                  치료가 시급하지만 비용 부담이 큰 환자들에게 도움을 줍니다.
                </div>
              </div>
            </div>
            <div class="donation-category" data-category="범죄피해">
              <div class="category-icon">
                <i class="fas fa-shield-alt" style="color: #9b59b6; font-size: 20px"></i>
              </div>
              <div class="category-content">
                <div class="category-title">범죄 피해자 돕기</div>
                <div class="category-desc">
                  범죄로 인해 신체적, 정신적, 경제적 피해를 입은 사람들을 지원합니다.
                </div>
              </div>
            </div>
            <div class="donation-category" data-category="가정폭력">
              <div class="category-icon">
                <i class="fas fa-hand-holding-heart" style="color: #f39c12; font-size: 20px"></i>
              </div>
              <div class="category-content">
                <div class="category-title">가정 폭력/학대 피해자 돕기</div>
                <div class="category-desc">
                  가정 내 폭력과 학대로 고통받는 이들에게 안전한 보호와 자립을 돕습니다.
                </div>
              </div>
            </div>
            <div class="donation-category" data-category="한부모">
              <div class="category-icon">
                <i class="fas fa-baby" style="color: #e91e63; font-size: 20px"></i>
              </div>
              <div class="category-content">
                <div class="category-title">미혼 한부모 돕기</div>
                <div class="category-desc">
                  홀로 아이를 키우는 한부모가정이 안정적인 생활을 할 수 있도록 지원합니다.
                </div>
              </div>
            </div>
            <div class="donation-category" data-category="노숙인">
              <div class="category-icon">
                <i class="fas fa-bed" style="color: #795548; font-size: 20px"></i>
              </div>
              <div class="category-content">
                <div class="category-title">노숙인 돕기</div>
                <div class="category-desc">
                  거리에서 생활하는 노숙인들에게 따뜻한 보금자리와 희망을 제공합니다.
                </div>
              </div>
            </div>
            <div class="donation-category" data-category="자살고위험군">
              <div class="category-icon">
                <i class="fas fa-hands-helping" style="color: #2ecc71; font-size: 20px"></i>
              </div>
              <div class="category-content">
                <div class="category-title">자살 고위험군 돕기</div>
                <div class="category-desc">
                  심리적 어려움을 겪는 사람들에게 전문적인 상담과 지원을 제공하여 삶을 지켜줍니다.
                </div>
              </div>
            </div>
          </div>

          <div class="next-btn-container">
            <button class="next-btn" id="nextBtn">후원자 정보 입력</button>
          </div>
        </div>
      </div>

      <!-- Gift Package Box - Separate Section -->
      <div class="gift-package-box">
        <div class="gift-package-section">
          <h3 class="gift-package-title">아동·청소년을 위한 맞춤형 후원 패키지</h3>
          <p class="gift-package-subtitle">여러분의 소중한 후원이 우리 아이들의 미래를 밝힙니다</p>
          <div class="gift-cards-container">
            <!-- Card 1: 따뜻한 겨울나기 -->
            <div class="gift-card blue">
              <div class="gift-card-icon">
                <i class="fas fa-snowflake" style="color: white; font-size: 50px;"></i>
              </div>
              <div class="gift-card-name">따뜻한 겨울나기</div>
              <div class="gift-card-price">95,000원</div>
              <ul class="gift-card-items">
                <li>겨울 패딩 점퍼 1벌</li>
                <li>방한 용품 세트 (목도리, 장갑, 모자)</li>
                <li>내복 2벌</li>
                <li>난방비 지원금</li>
              </ul>
              <button class="gift-card-button" onclick="selectGiftPackage('따뜻한 겨울나기', 95000)">후원하기</button>
            </div>

            <!-- Card 2: 건강한 성장 지원 -->
            <div class="gift-card green">
              <div class="gift-card-icon">
                <i class="fas fa-heartbeat" style="color: white; font-size: 50px;"></i>
              </div>
              <div class="gift-card-name">건강한 성장 지원</div>
              <div class="gift-card-price">150,000원</div>
              <ul class="gift-card-items">
                <li>종합 건강검진 1회</li>
                <li>치과 치료 지원</li>
                <li>성장기 영양제 3개월분</li>
                <li>건강 보조식품 (우유, 과일 등)</li>
                <li>안경 제작비 지원</li>
              </ul>
              <button class="gift-card-button" onclick="selectGiftPackage('건강한 성장 지원', 150000)">후원하기</button>
            </div>

            <!-- Card 3: 교육·문화 지원 -->
            <div class="gift-card orange">
              <div class="gift-card-icon">
                <i class="fas fa-book-reader" style="color: white; font-size: 50px;"></i>
              </div>
              <div class="gift-card-name">교육·문화 지원</div>
              <div class="gift-card-price">120,000원</div>
              <ul class="gift-card-items">
                <li>학용품 세트 (가방, 필기구, 공책)</li>
                <li>교육용 도서 10권</li>
                <li>온라인 학습 구독권 3개월</li>
                <li>문화 체험 티켓 (박물관, 공연 등)</li>
                <li>미술·음악 재능 교육비</li>
              </ul>
              <button class="gift-card-button" onclick="selectGiftPackage('교육·문화 지원', 120000)">후원하기</button>
            </div>
          </div>
        </div>
      </div>

      <!-- Donation Flow Section -->
      <div class="donation-flow-box">
        <h3 class="donation-flow-title">후원자님의 기부금은 이렇게 전달됩니다</h3>
        <p class="donation-flow-subtitle">후원 분야를 선택하고 복지24를 통해 도움이 필요한 분들에게 전달해 보세요</p>

        <div class="flow-timeline">
          <div class="flow-step">
            <div class="flow-icon">
              <i class="fas fa-hand-holding-heart"></i>
            </div>
            <h4 class="flow-step-title">후원</h4>
            <p class="flow-step-desc">9가지 분야 중 후원할 대상 선택</p>
          </div>

          <div class="flow-arrow">
            <i class="fas fa-arrow-right"></i>
          </div>

          <div class="flow-step">
            <div class="flow-icon">
              <i class="fas fa-clipboard-check"></i>
            </div>
            <h4 class="flow-step-title">접수</h4>
            <p class="flow-step-desc">복지24 중앙센터에서 후원금 접수 및 관리</p>
          </div>

          <div class="flow-arrow">
            <i class="fas fa-arrow-right"></i>
          </div>

          <div class="flow-step">
            <div class="flow-icon">
              <i class="fas fa-users"></i>
            </div>
            <h4 class="flow-step-title">대상자 선정</h4>
            <p class="flow-step-desc">지역 복지센터에서 지원 대상자 조사 및 선정</p>
          </div>

          <div class="flow-arrow">
            <i class="fas fa-arrow-right"></i>
          </div>

          <div class="flow-step">
            <div class="flow-icon">
              <i class="fas fa-truck"></i>
            </div>
            <h4 class="flow-step-title">전달</h4>
            <p class="flow-step-desc">사회복지사가 직접 방문하여 지원금·물품 전달</p>
          </div>
        </div>

        <div class="transparency-note">
          <div class="transparency-content">
            <h4>투명한 운영을 약속합니다</h4>
            <p>
              모든 후원금은 100% 도움이 필요한 분들을 위해 사용되며,
              분기별 사용 내역을 홈페이지를 통해 상세히 공개합니다.
              운영비는 별도의 기업 후원금으로 충당하고 있습니다.
            </p>
            <div class="transparency-stats">
              <div class="stat-item">
                <div class="stat-number">100%</div>
                <div class="stat-label">후원금 사용</div>
              </div>
              <div class="stat-item">
                <div class="stat-number">0원</div>
                <div class="stat-label">운영비 차감</div>
              </div>
              <div class="stat-item">
                <div class="stat-number">분기별</div>
                <div class="stat-label">사용 내역 공개</div>
              </div>
            </div>
          </div>
        </div>
      </div>
      <% } %>

      <!-- Step 2: Sponsor Info -->
      <div id="donation-step2" class="donation-step">
        <div class="sponsor-info-box">
          <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px;">
            <h2 class="donation-title" style="margin: 0;">후원자 정보</h2>
            <div class="step-indicator">
              <div class="step">
                <div class="step-number" id="step1Number2">1</div>
                <div class="step-text" id="step1Text2">기부하기</div>
              </div>
              <div class="step-connector"></div>
              <div class="step">
                <div class="step-number active" id="step2Number2">2</div>
                <div class="step-text active" id="step2Text2">후원자 정보</div>
              </div>
              <div class="step-connector"></div>
              <div class="step">
                <div class="step-number" id="step3Number2">3</div>
                <div class="step-text" id="step3Text2">결제 수단</div>
              </div>
            </div>
          </div>
          <% if (skipFirstStep) { %>
          <div style="background: #f8f9fa; padding: 20px; border-radius: 10px; margin-bottom: 20px;">
            <h4 style="margin-top: 0; color: #333;">선택하신 기부 정보</h4>
            <div style="display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 15px;">
              <div>
                <strong>기부 금액:</strong><br>
                <span style="color: #4a90e2; font-size: 16px;"><%= donationAmount != null ? String.format("%,d", Integer.parseInt(donationAmount)) + "원" : "미설정" %></span>
              </div>
              <div>
                <strong>기부 분야:</strong><br>
                <span style="color: #4a90e2; font-size: 16px;"><%= donationCategory != null ? donationCategory : "미설정" %></span>
              </div>
              <div>
                <strong>기부 유형:</strong><br>
                <span style="color: #4a90e2; font-size: 16px;"><%= donationType != null ? (donationType.equals("regular") ? "정기기부" : "일시기부") : "미설정" %></span>
              </div>
            </div>
          </div>
          <% } %>
          <form class="sponsor-form" id="sponsorForm">
            <div class="form-group">
              <label class="form-label" for="sponsorName">이름</label>
              <input
                type="text"
                id="sponsorName"
                class="form-input"
                placeholder="이름을 입력하세요"
              />
            </div>
            <div class="form-group">
              <label class="form-label" for="sponsorPhone">전화번호</label>
              <input
                type="text"
                id="sponsorPhone"
                class="form-input"
                placeholder="'-' 없이 숫자만 입력"
                maxlength="11"
              />
            </div>
            <div class="form-group">
              <label class="form-label" for="sponsorDob">생년월일</label>
              <input
                type="text"
                id="sponsorDob"
                class="form-input"
                placeholder="8자리 입력 (예: 19900101)"
                maxlength="8"
              />
            </div>
            <div class="form-group">
              <label class="form-label" for="emailUser">이메일</label>
              <div class="email-group">
                <input type="text" id="emailUser" class="form-input" />
                <span class="email-at">@</span>
                <input
                  type="text"
                  id="emailDomain"
                  class="form-input"
                  placeholder="직접입력"
                />
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
              <label class="form-label">주소</label>
              <div class="address-row">
                <div class="address-group">
                  <input
                    type="text"
                    id="postcode"
                    class="form-input"
                    placeholder="우편번호"
                    readonly
                  />
                  <button type="button" id="searchAddressBtn">주소검색</button>
                </div>
                <input
                  type="text"
                  id="address"
                  class="form-input"
                  placeholder="주소"
                  readonly
                />
              </div>
              <input
                type="text"
                id="detailAddress"
                class="form-input"
                placeholder="상세주소"
              />
            </div>
            <div class="form-group">
              <label class="form-label">소식 안내</label>
              <div class="custom-radio-group">
                <div>
                  <input
                    type="radio"
                    id="noti_mobile"
                    name="notifications"
                    value="mobile"
                  />
                  <label for="noti_mobile" class="radio-label">모바일</label>
                </div>
                <div>
                  <input
                    type="radio"
                    id="noti_email"
                    name="notifications"
                    value="email"
                  />
                  <label for="noti_email" class="radio-label">이메일</label>
                </div>
                <div>
                  <input
                    type="radio"
                    id="noti_post"
                    name="notifications"
                    value="post"
                  />
                  <label for="noti_post" class="radio-label">우편</label>
                </div>
              </div>
            </div>
          </form>
          <div class="form-navigation-btns">
            <button class="back-btn" id="backBtn">뒤로</button>
            <button class="next-btn" id="goToStep3Btn">다음</button>
          </div>
        </div>
      </div>

      <!-- Step 3: Payment Method -->
      <div id="donation-step3" class="donation-step">
        <div class="payment-info-box">
          <div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 20px;">
            <h2 class="donation-title" style="margin: 0;">결제 수단 선택</h2>
            <div class="step-indicator">
              <div class="step">
                <div class="step-number" id="step1Number3">1</div>
                <div class="step-text" id="step1Text3">기부하기</div>
              </div>
              <div class="step-connector"></div>
              <div class="step">
                <div class="step-number" id="step2Number3">2</div>
                <div class="step-text" id="step2Text3">후원자 정보</div>
              </div>
              <div class="step-connector"></div>
              <div class="step">
                <div class="step-number active" id="step3Number3">3</div>
                <div class="step-text active" id="step3Text3">결제 수단</div>
              </div>
            </div>
          </div>
          <div class="payment-method-group">
            <button
              type="button"
              class="payment-method-btn active"
              data-target="creditCardForm"
              data-method="CREDIT_CARD"
            >
              신용카드
            </button>
            <button
              type="button"
              class="payment-method-btn"
              data-target="bankTransferForm"
              data-method="BANK_TRANSFER"
            >
              계좌 이체
            </button>
            <button
              type="button"
              class="payment-method-btn"
              data-target="naverPayForm"
              data-method="NAVER_PAY"
            >
              네이버 페이
            </button>
          </div>

          <!-- Credit Card Form -->
          <div id="creditCardForm" class="payment-details-form">
            <div class="payment-form-grid">
              <div class="form-group grid-col-span-2">
                <label class="form-label">카드번호</label>
                <div class="input-group">
                  <input
                    type="text"
                    class="form-input"
                    maxlength="4"
                    placeholder="1234"
                  />
                  <span>-</span>
                  <input
                    type="text"
                    class="form-input"
                    maxlength="4"
                    placeholder="0000"
                  />
                  <span>-</span>
                  <input
                    type="text"
                    class="form-input"
                    maxlength="4"
                    placeholder="0000"
                  />
                  <span>-</span>
                  <input
                    type="text"
                    class="form-input"
                    maxlength="4"
                    placeholder="0000"
                  />
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">유효기간</label>
                <div class="input-group">
                  <input
                    type="text"
                    class="form-input"
                    maxlength="2"
                    placeholder="MM"
                  />
                  <span>/</span>
                  <input
                    type="text"
                    class="form-input"
                    maxlength="2"
                    placeholder="YY"
                  />
                </div>
              </div>
              <div class="form-group">
                <label class="form-label">CVC</label>
                <input
                  type="text"
                  class="form-input"
                  maxlength="3"
                  placeholder="123"
                />
              </div>
              <div class="form-group grid-col-span-2" style="display: flex; gap: 10px; align-items: start; margin-top: 20px;">
                <div class="signature-pad-wrapper" style="margin-top: 0;">
                  <div class="signature-container">
                    <label class="form-label" for="cardCanvas">서명</label>
                    <canvas
                      class="signature-pad"
                      id="cardCanvas"
                      width="400"
                      height="150"
                    ></canvas>
                    <button
                      type="button"
                      class="clear-signature-btn"
                      data-target="cardCanvas"
                    ></button>
                  </div>
                </div>
                <div style="flex-shrink: 0;">
                  <label class="form-label">기부금 영수증 발행</label>
                  <div class="custom-radio-group">
                    <div>
                      <input
                        type="radio"
                        id="receipt_yes_card"
                        name="receipt_card"
                        value="yes"
                      />
                      <label for="receipt_yes_card">예</label>
                    </div>
                    <div>
                      <input
                        type="radio"
                        id="receipt_no_card"
                        name="receipt_card"
                        value="no"
                      />
                      <label for="receipt_no_card">아니오</label>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="agreement-section">
              <div class="agreement-item all-agree">
                <label>
                  <input type="checkbox" class="agreeAll" />
                  개인정보 수집 및 이용에 모두 동의합니다.
                </label>
              </div>
              <div class="agreement-item">
                <label>
                  <input type="checkbox" class="agree-item" />
                  개인정보 수집 및 이용 동의
                </label>
                <a href="#" class="view-details-btn" data-modal="modal1">상세보기</a>
              </div>
              <div class="agreement-item">
                <label>
                  <input type="checkbox" class="agree-item" />
                  제3자 제공 동의
                </label>
                <a href="#" class="view-details-btn" data-modal="modal1">상세보기</a>
              </div>
            </div>
          </div>

          <!-- Bank Transfer Form -->
          <div id="bankTransferForm" class="payment-details-form hidden">
            <div class="payment-form-grid">
              <div class="form-group">
                <label class="form-label">은행 선택</label>
                <select class="form-select">
                  <option value="">은행을 선택하세요</option>
                  <option>KB국민은행</option>
                  <option>신한은행</option>
                  <option>우리은행</option>
                  <option>하나은행</option>
                  <option>IBK기업은행</option>
                  <option>SC제일은행</option>
                </select>
              </div>
              <div class="form-group">
                <label class="form-label">계좌번호</label>
                <input
                  type="text"
                  class="form-input"
                  placeholder="계좌번호를 입력하세요"
                />
              </div>
              <div class="form-group grid-col-span-2" style="display: flex; gap: 10px; align-items: start; margin-top: 20px;">
                <div class="signature-pad-wrapper" style="margin-top: 0;">
                  <div class="signature-container">
                    <label class="form-label" for="bankCanvas">서명</label>
                    <canvas
                      class="signature-pad"
                      id="bankCanvas"
                      width="400"
                      height="150"
                    ></canvas>
                    <button
                      type="button"
                      class="clear-signature-btn"
                      data-target="bankCanvas"
                    ></button>
                  </div>
                </div>
                <div style="flex-shrink: 0;">
                  <label class="form-label">기부금 영수증 발행</label>
                  <div class="custom-radio-group">
                    <div>
                      <input
                        type="radio"
                        id="receipt_yes_bank"
                        name="receipt_bank"
                        value="yes"
                      />
                      <label for="receipt_yes_bank">예</label>
                    </div>
                    <div>
                      <input
                        type="radio"
                        id="receipt_no_bank"
                        name="receipt_bank"
                        value="no"
                      />
                      <label for="receipt_no_bank">아니오</label>
                    </div>
                  </div>
                </div>
              </div>
            </div>
            <div class="agreement-section">
              <div class="agreement-item all-agree">
                <label>
                  <input type="checkbox" class="agreeAll" />
                  개인정보 수집 및 이용에 모두 동의합니다.
                </label>
              </div>
              <div class="agreement-item">
                <label>
                  <input type="checkbox" class="agree-item" />
                  개인정보 수집 및 이용 동의
                </label>
                <a href="#" class="view-details-btn" data-modal="modal1">상세보기</a>
              </div>
              <div class="agreement-item">
                <label>
                  <input type="checkbox" class="agree-item" />
                  제3자 제공 동의
                </label>
                <a href="#" class="view-details-btn" data-modal="modal1">상세보기</a>
              </div>
            </div>
          </div>

          <!-- Naver Pay Form -->
          <div id="naverPayForm" class="payment-details-form hidden">
            <div class="payment-form-grid">
              <div class="form-group grid-col-span-2">
                <label class="form-label">네이버 페이로 간편 결제</label>
                <p style="color: #666; margin: 10px 0;">네이버 페이 버튼을 클릭하여 결제를 진행해주세요.</p>
                <button type="button" id="naverPayBtn" style="background: #03C75A; color: white; border: none; padding: 15px 30px; border-radius: 8px; font-size: 16px; cursor: pointer;">
                  네이버 페이로 결제하기
                </button>
              </div>
              <div class="form-group grid-col-span-2">
                <label class="form-label">기부금 영수증 발행</label>
                <div class="custom-radio-group">
                  <div>
                    <input
                      type="radio"
                      id="receipt_yes_naver"
                      name="receipt_naver"
                      value="yes"
                    />
                    <label for="receipt_yes_naver">예</label>
                  </div>
                  <div>
                    <input
                      type="radio"
                      id="receipt_no_naver"
                      name="receipt_naver"
                      value="no"
                    />
                    <label for="receipt_no_naver">아니오</label>
                  </div>
                </div>
              </div>
            </div>
            <div class="agreement-section">
              <div class="agreement-item all-agree">
                <label>
                  <input type="checkbox" class="agreeAll" />
                  개인정보 수집 및 이용에 모두 동의합니다.
                </label>
              </div>
              <div class="agreement-item">
                <label>
                  <input type="checkbox" class="agree-item" />
                  개인정보 수집 및 이용 동의
                </label>
                <a href="#" class="view-details-btn" data-modal="modal1">상세보기</a>
              </div>
              <div class="agreement-item">
                <label>
                  <input type="checkbox" class="agree-item" />
                  제3자 제공 동의
                </label>
                <a href="#" class="view-details-btn" data-modal="modal1">상세보기</a>
              </div>
            </div>
          </div>

          <div class="form-navigation-btns">
            <button class="back-btn" id="backToStep2Btn">뒤로</button>
            <button class="next-btn" id="finalSubmitBtn">기부완료</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Modal for Privacy Policy -->
    <div id="modal1" class="modal-overlay">
      <div class="modal-content">
        <button class="modal-close-btn">&times;</button>
        <h3 class="modal-title">개인정보 및 고유식별정보 수집 및 이용 동의</h3>
        <div class="modal-body">
          <p>
            개인정보 및 고유식별정보 수집‧이용에 대한 동의를 거부할 권리가
            있습니다. 단, 동의를 거부할 경우 기부신청 및 이력 확인, 기부자
            서비스 등 기부신청이 거부될 수 있습니다.
          </p>
          <h4>가. 개인정보 및 고유식별정보 수집‧이용 항목:</h4>
          <p>
            - 고유식별정보: 주민등록번호 (기부영수증 신청 시)<br />- 필수 항목:
            성명, 생년월일, 연락처, 주소<br />(신용카드 기부방식) 카드번호,
            카드유효기간<br />(정기이체 기부방식) 계좌은행, 계좌번호, 예금주,
            전자서명<br />- 선택 항목: 이메일
          </p>
          <h4>나. 수집‧이용 목적:</h4>
          <p>
            모금회에서 처리하는 기부관련 업무 (기부신청, 기부내역확인, 확인서
            발급, 기부자서비스 등)
          </p>
          <h4>다. 보유기간 :</h4>
          <p>
            관계 법령에 의거 기부 종료 후 10년간 보존 후 파기<br />※ 개인정보의
            위탁회사 및 위탁업무의 구체적인 정보는 모금회 홈페이지
            [http://wwwchest.or.kr]에서 확인할 수 있습니다<br />※ 소득세법,
            상속세 및 증여세법에 따라 주민등록번호의 수집․이용이 가능하며,
            소득세법 시행령의 (기부금영수증 발급명세의 작성·보관의무)에 따라
            보유기간을 10년으로 합니다.
          </p>
        </div>
      </div>
    </div>

    <!-- Daum Postcode API for address search -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script src="resources/js/project_Donation.js"></script>
    <script>
      // 세션에서 사용자 정보 가져오기 (JSP 표현식)
      const currentUsername = '<%= username %>';
      const currentUserId = '<%= session.getAttribute("id") != null ? session.getAttribute("id") : "guest" %>';

      // URL 파라미터로 전달받은 기부 정보
      const donationParams = {
        amount: '<%= donationAmount != null ? donationAmount : "" %>',
        category: '<%= donationCategory != null ? donationCategory : "" %>',
        type: '<%= donationType != null ? donationType : "" %>',
        skipFirstStep: <%= skipFirstStep %>
      };

      // 페이지 로드 시 초기화
      document.addEventListener("DOMContentLoaded", function() {
        initDonationPage(donationParams, currentUserId);
      });
    </script>
    <%@ include file="footer.jsp" %>
  </body>
</html>