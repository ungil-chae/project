<%@ page language="java" contentType="text/html; charset=UTF-8"%>
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
    <style>
      html,
      body {
        width: 100%;
        margin: 0;
        padding: 0;
        background-color: #e2f0f6; /* 전체 배경색 설정 */
      }
      * {
        box-sizing: border-box;
      }
      body {
        background-color: #fafafa;
        color: #191918;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
          sans-serif;
      }

      /* 2. 배경 위에 대각선 패널을 추가하는 부분 */
      .main-background-section::before {
        content: "";
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100vh;
        background: #f7f5f2; /* 왼쪽 패널 색상 */
        clip-path: polygon(0 0, 50% 0, 35% 100%, 0 100%); /* 대각선 모양 */
        z-index: -2;
      }

      /* 3. 텍스트를 담는 컨테이너 (이제 투명함) */
      .main-content {
        height: 100vh; /* ★★★ 수정됨 ★★★ */
        width: 100%;
        display: flex;
      }

      /* 4. 왼쪽 텍스트 영역 (이제 배경색과 모양이 없음) */
      .main-left {
        flex: 0 0 50%;
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: flex-start;
        padding-left: 100px;
      }

      /* 5. 오른쪽 영역 (공간만 차지하고 보이지 않음) */
      .main-right {
        position: fixed; /* 화면에 완전히 고정 */
        top: 0;
        left: 0;
        width: 100vw; /* 뷰포트 너비 사용 */
        height: 94vh; /* 세로 길이 줄임 */
        z-index: -1; /* 모든 콘텐츠 뒤에 위치 */
        background-image: url("resources/image/배경5.png");
        background-size: cover;
        background-repeat: no-repeat;
        background-position: center center;
        overflow: hidden; /* 스크롤 방지 */
        transform: translateZ(0); /* 하드웨어 가속으로 고정 효과 강화 */
        flex: 1;
      }
      .main-title {
        font-size: 48px;
        font-weight: 400;
        line-height: 1.2;
        margin-bottom: 15px;
        color: #1e1919;
        text-shadow: none;
        text-align: left;
      }

      .main-subtitle {
        font-size: 18px;
        font-weight: 600;
        color: rgba(82, 74, 62, 0.9); /* 색상도 조금 더 진하게 */
        margin-bottom: 30px;
        text-shadow: none;
        text-align: left;
      }

      .cta-buttons {
        display: flex;
        justify-content: flex-start;
      }

      .main-cta-btn {
        background-color: white;
        color: black;
        border: none;
        padding: 20px 20px;
        border-radius: 10px;
        font-size: 18px;
        font-weight: 600;
        cursor: pointer;
        transition: background-color 0.3s ease;
        display: inline-flex;
        align-items: center;
        gap: 12px;
      }
      .main-cta-btn::after {
        content: "→";
        font-size: 20px;
        transition: transform 0.3s ease;
      }
      .main-cta-btn:hover {
        background-color: #f0f0f0;
      }
      .main-cta-btn:hover::after {
        transform: translateX(5px);
      }

      /* 인기 복지 혜택 섹션 */
      .popular-welfare-section {
        width: 100%;
        background: #f7f5f2;
        padding: 50px 40px 100px 40px;
        position: relative;
      }

      .popular-welfare-header {
        max-width: 1400px;
        margin: 0 auto 60px;
        text-align: left;
      }

      .popular-welfare-title {
        font-size: 42px;
        font-weight: 600;
        color: #1e1919;
        margin-bottom: 12px;
        letter-spacing: -0.5px;
        text-align: left;
      }

      .popular-welfare-subtitle {
        font-size: 16px;
        color: rgba(82, 74, 62, 0.8);
        font-weight: 400;
        text-align: left;
      }

      .popular-welfare-container {
        max-width: 1400px;
        margin: 0 auto;
        position: relative;
      }

      .slider-navigation {
        position: absolute;
        top: -120px;
        right: 0;
        display: flex;
        gap: 12px;
        z-index: 2;
      }

      .slider-nav-btn {
        width: 48px;
        height: 48px;
        border-radius: 50%;
        background: white;
        border: 1px solid #ddd;
        color: #333;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 18px;
        transition: all 0.2s ease;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.08);
      }

      .slider-nav-btn:hover {
        background: #f5f5f5;
        border-color: #333;
      }

      .slider-nav-btn:disabled {
        opacity: 0.3;
        cursor: not-allowed;
        background: #f5f5f5;
      }

      .welfare-slider-container {
        overflow: hidden;
      }

      .welfare-slider {
        display: flex;
        transition: transform 0.4s ease;
        gap: 24px;
      }

      .popular-welfare-item {
        background: white;
        border-radius: 16px;
        padding: 32px;
        padding-top: 50px;
        flex: 0 0 calc(25% - 18px);
        box-shadow: 0 4px 16px rgba(0, 0, 0, 0.06);
        transition: all 0.3s ease;
        cursor: pointer;
        position: relative;
        min-height: 260px;
        display: flex;
        flex-direction: column;
        border: 1px solid #e8e8e8;
        overflow: hidden;
      }

      .popular-welfare-item:hover {
        transform: translateY(-6px);
        box-shadow: 0 12px 32px rgba(0, 0, 0, 0.15);
        border-color: #333;
      }

      .welfare-logo {
        position: absolute;
        top: 0;
        left: 0;
        width: 40px;
        height: 40px;
        background: #1e1919;
        border-radius: 0 0 12px 0;
        display: flex;
        align-items: center;
        justify-content: center;
        color: white;
        font-weight: 700;
        font-size: 16px;
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.2);
      }

      .welfare-views-badge {
        display: inline-flex;
        align-items: center;
        gap: 4px;
        background: #f5f5f5;
        color: #666;
        font-size: 11px;
        font-weight: 600;
        padding: 4px 10px;
        border-radius: 12px;
        border: 1px solid #e0e0e0;
      }

      .welfare-name {
        font-size: 17px;
        font-weight: 600;
        color: #1e1919;
        margin-bottom: 12px;
        line-height: 1.4;
        min-height: 48px;
        flex-grow: 1;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }

      .welfare-org {
        font-size: 13px;
        color: #666;
        margin-bottom: 12px;
        line-height: 1.4;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
      }

      .welfare-footer {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-top: auto;
        padding-top: 12px;
        border-top: 1px solid #f0f0f0;
      }

      .welfare-date {
        font-size: 12px;
        color: #999;
        display: flex;
        align-items: center;
        gap: 4px;
      }

      .slider-indicators {
        display: flex;
        justify-content: center;
        gap: 8px;
        margin-top: 48px;
      }

      .slider-indicator {
        width: 32px;
        height: 4px;
        background: #d0d0d0;
        border-radius: 2px;
        cursor: pointer;
        transition: all 0.3s ease;
      }

      .slider-indicator.active {
        background: #1e1919;
        width: 48px;
      }

      .loading-popular {
        text-align: center;
        padding: 80px 40px;
        color: #999;
        font-size: 16px;
      }

      .loading-spinner {
        width: 40px;
        height: 40px;
        border: 3px solid #e0e0e0;
        border-top: 3px solid #333;
        border-radius: 50%;
        animation: spin 0.8s linear infinite;
        margin: 0 auto 20px;
      }

      @keyframes spin {
        0% { transform: rotate(0deg); }
        100% { transform: rotate(360deg); }
      }

      @media (max-width: 900px) {
        .popular-welfare-item {
          flex: 0 0 calc(50% - 12px);
        }

        .welfare-slider {
          gap: 16px;
        }
      }

      @media (max-width: 768px) {
        .popular-welfare-section {
          padding: 60px 20px;
        }

        .popular-welfare-title {
          font-size: 32px;
        }

        .slider-navigation {
          top: -80px;
        }

        .slider-nav-btn {
          width: 40px;
          height: 40px;
          font-size: 16px;
        }

        .popular-welfare-item {
          flex: 0 0 100%;
        }
      }

      #donation-container {
        position: relative;
        margin-top: 0;
        width: 100%;
        max-width: 1400px;
        overflow: hidden;
        min-height: 700px;
        background-color: #fafafa;
        color: #191918;
        margin-left: auto;
        margin-right: auto;
        padding: 40px 20px;
        /* 스크롤 애니메이션 초기 상태 */
        opacity: 0;
        transform: translateX(100px);
        transition: all 0.8s ease-out;
      }

      /* 애니메이션이 실행되는 클래스 */
      #donation-container.animate-in {
        opacity: 1;
        transform: translateX(0);
      }

      /* 메인 콘텐츠 애니메이션이 실행되는 클래스 */
      .main-content.animate-in {
        opacity: 1;
        transform: translateX(0);
      }
      .donation-step {
        display: flex;
        width: 100%;
        transition: transform 0.5s ease-in-out, opacity 0.5s ease-in-out;
      }
      #donation-step1 {
        gap: 30px;
      }

      .donation-left-box {
        flex: 3;
        background: white;
        border-radius: 20px;
        padding: 40px;
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
      }
      .donation-right-box {
        flex: 7;
        background: white;
        border-radius: 20px;
        padding: 40px;
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
      }
      .donation-title {
        font-size: 28px;
        font-weight: 600;
        color: #333;
        margin-bottom: 15px;
      }
      .donation-subtitle {
        font-size: 14px;
        color: #666;
        margin-bottom: 30px;
        line-height: 1.5;
      }
      .donation-form {
        display: flex;
        flex-direction: column;
        gap: 20px;
      }
      .form-group {
        display: flex;
        flex-direction: column;
        gap: 10px;
      }
      .form-label {
        font-size: 18px;
        font-weight: 600;
        color: #333;
      }
      .form-select {
        width: 100%;
        padding: 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 15px;
        background: white;
        cursor: pointer;
        appearance: none;
        background-image: url("data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath fill='none' stroke='%23666' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3E%3C/svg%3E");
        background-repeat: no-repeat;
        background-position: right 15px center;
        background-size: 16px;
      }
      .form-input {
        width: 100%;
        padding: 15px;
        border: 1px solid #ddd;
        border-radius: 8px;
        font-size: 15px;
        outline: none;
      }
      .form-input:focus {
        border-color: #4a90e2;
        box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
      }
      .form-input.disabled,
      .form-input[readonly] {
        background-color: #f5f5f5;
        color: #999;
        cursor: not-allowed;
      }
      .donation-buttons {
        display: flex;
        gap: 12px;
        margin-top: 10px;
      }
      .donation-btn {
        flex: 1;
        padding: 16px 20px;
        border: 2px solid #ddd;
        border-radius: 8px;
        background: white;
        font-size: 15px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.4s ease;
      }
      .donation-btn:hover {
        background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
        color: white;
        border-color: #4a90e2;
      }
      .donation-btn.active {
        background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
        color: white;
        border-color: #4a90e2;
      }
      .donation-categories {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 15px;
      }
      .donation-category {
        display: flex;
        align-items: center;
        padding: 20px 15px;
        background: #f8f9fa;
        border-radius: 12px;
        transition: all 0.3s ease;
        cursor: pointer;
        border: 2px solid transparent;
      }
      .donation-category:hover {
        background: #e9ecef;
        transform: translateY(-2px);
      }
      .donation-category.selected {
        background: #e3f2fd;
        border-color: #4a90e2;
      }
      .category-icon {
        width: 50px;
        height: 50px;
        background: #fff;
        border-radius: 10px;
        margin-right: 12px;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 2px 6px rgba(0, 0, 0, 0.08);
        flex-shrink: 0;
      }
      .category-icon img {
        width: 30px;
        height: 30px;
        object-fit: contain;
      }
      .category-content {
        flex: 1;
        text-align: left;
      }
      .category-title {
        font-size: 14px;
        font-weight: 600;
        color: #333;
        margin-bottom: 4px;
      }
      .category-desc {
        font-size: 12px;
        color: #666;
        line-height: 1.3;
      }
      .donation-methods-title {
        font-size: 20px;
        font-weight: 600;
        color: #333;
        margin-bottom: 25px;
      }
      .next-btn-container {
        display: flex;
        justify-content: flex-end;
        margin-top: 25px;
      }
      .next-btn {
        background: #4a90e2;
        color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 8px;
        font-size: 15px;
        font-weight: 500;
        cursor: pointer;
        transition: background 0.3s ease;
      }
      .next-btn:hover {
        background: #357abd;
      }

      @media (max-width: 1200px) {
        #donation-step1 {
          flex-direction: column;
        }
        .donation-categories {
          grid-template-columns: repeat(2, 1fr);
        }
      }
      @media (max-width: 1024px) {
        .content-wrapper {
          flex-direction: column;
          gap: 60px;
          text-align: center;
        }
        .left-content {
          text-align: center;
        }
        .services-grid {
          display: grid;
          grid-template-columns: repeat(3, 1fr);
          gap: 20px;
        }
        .donation-categories {
          grid-template-columns: 1fr;
        }
      }
      @media (max-width: 768px) {
        .nav-menu {
          display: none;
        }
        .navbar {
          padding: 0 15px;
        }
        .main-content {
          height: 100vh;
          flex-direction: column;
        }
        .main-left {
          clip-path: polygon(0 0, 100% 0, 100% 70%, 0 50%);
          padding: 60px 20px;
          align-items: center;
          text-align: center;
        }
        .main-right {
          width: 100%;
          height: 100%;
        }
        .main-image {
          clip-path: polygon(0 50%, 100% 30%, 100% 100%, 0 100%);
          object-position: center;
        }
        .main-title {
          font-size: 32px;
          margin-bottom: 20px;
        }
        .content-wrapper {
          gap: 40px;
        }
        .search-container {
          max-width: 100%;
        }
        .services-grid {
          display: grid;
          grid-template-columns: repeat(2, 1fr);
          gap: 15px;
        }
        #donation-container {
          margin-top: 40px;
        }
        .donation-title {
          font-size: 24px;
        }
      }
    </style>
  </head>
  <body>
    <div class="main-background-section"></div>

    <%@ include file="navbar.jsp" %>

    <div class="main-content">
      <div class="main-left">
        <div class="main-title">나에게 맞는 정보,<br />한눈에 확인하세요.</div>
        <p class="main-subtitle">숨은 혜택을 찾아드립니다.</p>
        <div class="cta-buttons">
          <a
            href="/bdproject/project_information.jsp"
            class="main-cta-btn"
            style="text-decoration: none; display: inline-block"
            >나의 상황 진단하기</a
          >
        </div>
      </div>
      <div class="main-right"></div>
    </div>

    <div id="donation-container">
      <div id="donation-step1" class="donation-step">
        <div class="donation-left-box">
          <h2 class="donation-title">기부하기</h2>
          <p class="donation-subtitle">당신의 나눔이 모두의 행복입니다.</p>
          <form class="donation-form" id="donationForm">
            <div class="form-group">
              <label class="form-label">기부금액 선택</label
              ><select class="form-select" id="donationAmount">
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
              <label class="form-label">기부금액을 입력하세요</label
              ><input
                type="text"
                class="form-input"
                id="amountInput"
                placeholder="원"
              />
            </div>
            <div class="donation-buttons">
              <button type="button" class="donation-btn" id="regularBtn">
                정기기부</button
              ><button type="button" class="donation-btn" id="onetimeBtn">
                일시기부
              </button>
            </div>
          </form>
        </div>
        <div class="donation-right-box">
          <h3 class="donation-methods-title">기부 참여 분야</h3>
          <div class="donation-categories">
            <div class="donation-category" data-category="위기가정">
              <div class="category-icon">
                <i
                  class="fas fa-home"
                  style="color: #e74c3c; font-size: 20px"
                ></i>
              </div>
              <div class="category-content">
                <div class="category-title">위기가정</div>
                <div class="category-desc">
                  갑작스러운 어려움에 처한 가족이 다시 일어설 수 있도록
                  돕습니다.
                </div>
              </div>
            </div>
            <div class="donation-category" data-category="화재피해">
              <div class="category-icon">
                <i
                  class="fas fa-fire"
                  style="color: #e67e22; font-size: 20px"
                ></i>
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
                <i
                  class="fas fa-cloud-rain"
                  style="color: #3498db; font-size: 20px"
                ></i>
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
                <i
                  class="fas fa-heartbeat"
                  style="color: #e74c3c; font-size: 20px"
                ></i>
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
                <i
                  class="fas fa-shield-alt"
                  style="color: #9b59b6; font-size: 20px"
                ></i>
              </div>
              <div class="category-content">
                <div class="category-title">범죄 피해자 돕기</div>
                <div class="category-desc">
                  범죄로 인해 신체적, 정신적, 경제적 피해를 입은 사람들을
                  지원합니다.
                </div>
              </div>
            </div>
            <div class="donation-category" data-category="가정폭력">
              <div class="category-icon">
                <i
                  class="fas fa-hand-holding-heart"
                  style="color: #f39c12; font-size: 20px"
                ></i>
              </div>
              <div class="category-content">
                <div class="category-title">가정 폭력/학대 피해자 돕기</div>
                <div class="category-desc">
                  가정 내 폭력과 학대로 고통받는 이들에게 안전한 보호와 자립을
                  돕습니다.
                </div>
              </div>
            </div>
            <div class="donation-category" data-category="한부모">
              <div class="category-icon">
                <i
                  class="fas fa-baby"
                  style="color: #e91e63; font-size: 20px"
                ></i>
              </div>
              <div class="category-content">
                <div class="category-title">미혼 한부모 돕기</div>
                <div class="category-desc">
                  홀로 아이를 키우는 한부모가정이 안정적인 생활을 할 수 있도록
                  지원합니다.
                </div>
              </div>
            </div>
            <div class="donation-category" data-category="노숙인">
              <div class="category-icon">
                <i
                  class="fas fa-bed"
                  style="color: #795548; font-size: 20px"
                ></i>
              </div>
              <div class="category-content">
                <div class="category-title">노숙인 돕기</div>
                <div class="category-desc">
                  주거 불안정에 놓인 노숙인이 자활할 수 있도록 돕습니다.
                </div>
              </div>
            </div>
            <div class="donation-category" data-category="자살고위험">
              <div class="category-icon">
                <i
                  class="fas fa-hands-helping"
                  style="color: #2ecc71; font-size: 20px"
                ></i>
              </div>
              <div class="category-content">
                <div class="category-title">자살 고위험군 돕기</div>
                <div class="category-desc">
                  심리적 어려움을 겪는 사람들에게 전문적인 상담과 지원을
                  제공하여 삶을 지켜줍니다.
                </div>
              </div>
            </div>
          </div>
          <div class="next-btn-container">
            <button class="next-btn" id="nextBtn" onclick="goToDonation()">
              후원자 정보 입력
            </button>
          </div>
        </div>
      </div>
    </div>

    <!-- 인기 복지 혜택 섹션 -->
    <div class="popular-welfare-section">
      <div class="popular-welfare-header">
        <h2 class="popular-welfare-title">인기 복지 혜택</h2>
        <p class="popular-welfare-subtitle">많은 분들이 찾으시는 복지 서비스를 소개합니다.</p>
      </div>

      <div class="popular-welfare-container">
        <div class="slider-navigation">
          <button class="slider-nav-btn" id="prevBtn" onclick="moveSlide(-1)">
            <span>←</span>
          </button>
          <button class="slider-nav-btn" id="nextBtn" onclick="moveSlide(1)">
            <span>→</span>
          </button>
        </div>

        <div class="welfare-slider-container">
          <div id="popular-welfare-list" class="welfare-slider">
            <div class="loading-popular">
              <div class="loading-spinner"></div>
              <p>복지 서비스를 불러오는 중...</p>
            </div>
          </div>
        </div>

        <div class="slider-indicators" id="sliderIndicators"></div>
      </div>
    </div>

		<%@ include file="footer.jsp" %>
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
      document.addEventListener("DOMContentLoaded", () => {
        // 인기 복지 혜택 로드
        loadPopularWelfareServices();

        // --- 스크롤 애니메이션 ---
        // 공통 관찰자 옵션
        const observerOptions = {
          root: null,
          rootMargin: "0px 0px -20% 0px", // 20% 정도 올라왔을 때 애니메이션 시작
          threshold: 0.1,
        };

        // 공통 관찰자 콜백
        const observerCallback = (entries) => {
          entries.forEach((entry) => {
            if (entry.isIntersecting) {
              // 화면에 들어왔을 때 애니메이션 클래스 추가
              entry.target.classList.add("animate-in");
              console.log(`${entry.target.className} 섹션 나타남`);
            } else {
              // 화면에서 벗어났을 때 애니메이션 클래스 제거
              entry.target.classList.remove("animate-in");
              console.log(`${entry.target.className} 섹션 사라짐`);
            }
          });
        };

        const observer = new IntersectionObserver(
          observerCallback,
          observerOptions
        );

        // 메인 콘텐츠 애니메이션
        const mainContent = document.querySelector(".main-content");
        if (mainContent) {
          observer.observe(mainContent);
          console.log("Main content 스크롤 애니메이션 설정 완료");
        }

        // donation 컨테이너 애니메이션
        const donationContainer = document.getElementById("donation-container");
        if (donationContainer) {
          observer.observe(donationContainer);
          console.log("Donation container 스크롤 애니메이션 설정 완료");
        }

        // Google Translate 토글은 navbar.jsp에서 처리됨

        const donationFormContainer =
          document.getElementById("donation-container");
        if (!donationFormContainer) return;

        let donationData = {
          donationType: "",
          amount: "",
          selectedCategory: "",
        };

        const amountInput = document.getElementById("amountInput");
        const regularBtn = document.getElementById("regularBtn");
        const onetimeBtn = document.getElementById("onetimeBtn");
        const donationAmount = document.getElementById("donationAmount");
        const donationCategories =
          document.querySelectorAll(".donation-category");

        const validateStep1 = () => {
          const amountValue = amountInput.value.replace(/,/g, "");
          if (!donationData.donationType) {
            alert("기부 방식을 선택해주세요.");
            return false;
          }
          if (!amountValue || parseInt(amountValue) <= 0) {
            alert("기부 금액을 입력해주세요.");
            amountInput.focus();
            return false;
          }
          const selectedCategory = document.querySelector(
            ".donation-category.selected"
          );
          if (!selectedCategory) {
            alert("기부 참여 분야를 선택해주세요.");
            return false;
          }
          donationData.amount = amountValue;
          donationData.selectedCategory = selectedCategory.dataset.category;
          return true;
        };

        // 기부하기 페이지로 이동하는 함수
        window.goToDonation = function () {
          if (validateStep1()) {
            // 기부 금액 값 수집
            const amountInput = document.getElementById("amountInput");
            const selectedCategory = document.querySelector(
              ".donation-category.selected"
            );
            const donationType = document.querySelector(".donation-btn.active");

            const donationAmount = amountInput
              ? amountInput.value.replace(/,/g, "")
              : "";
            const category = selectedCategory
              ? selectedCategory.dataset.category
              : "";
            const type = donationType
              ? donationType.id === "regularBtn"
                ? "regular"
                : "onetime"
              : "";

            // 디버깅 로그
            console.log(
              "Amount:",
              donationAmount,
              "Category:",
              category,
              "Type:",
              type
            );

            // URL 파라미터로 값 전달
            const params = new URLSearchParams();
            if (donationAmount) params.append("amount", donationAmount);
            if (category) params.append("category", category);
            if (type) params.append("type", type);

            const url =
              "/bdproject/project_Donation.jsp" +
              (params.toString() ? "?" + params.toString() : "");
            console.log("Generated URL:", url);
            window.location.href = url;
          }
        };
        if (donationAmount)
          donationAmount.addEventListener("change", (e) => {
            const selectedValue = e.target.value;
            if (selectedValue) {
              amountInput.value =
                parseInt(selectedValue).toLocaleString("ko-KR");
              amountInput.readOnly = true;
              amountInput.classList.add("disabled");
            } else {
              amountInput.value = "";
              amountInput.readOnly = false;
              amountInput.classList.remove("disabled");
              amountInput.focus();
            }
          });
        if (amountInput)
          amountInput.addEventListener("input", (e) => {
            let value = e.target.value.replace(/[^0-9]/g, "");
            e.target.value = value
              ? parseInt(value, 10).toLocaleString("ko-KR")
              : "";
          });
        if (regularBtn)
          regularBtn.addEventListener("click", () => {
            regularBtn.classList.add("active");
            onetimeBtn.classList.remove("active");
            donationData.donationType = "regular";
          });
        if (onetimeBtn)
          onetimeBtn.addEventListener("click", () => {
            onetimeBtn.classList.add("active");
            regularBtn.classList.remove("active");
            donationData.donationType = "onetime";
          });
        if (donationCategories.length > 0) {
          donationCategories.forEach((category) => {
            category.addEventListener("click", () => {
              // 클릭된 카테고리가 이미 선택되어 있는지 확인
              if (category.classList.contains("selected")) {
                // 이미 선택된 경우 선택 해제 (토글)
                category.classList.remove("selected");
              } else {
                // 선택되지 않은 경우 다른 모든 카테고리 선택 해제하고 현재 카테고리 선택
                donationCategories.forEach((c) =>
                  c.classList.remove("selected")
                );
                category.classList.add("selected");
              }
            });
          });
        }
      });

      // 사용자 아이콘 클릭 이벤트
      document.addEventListener("DOMContentLoaded", function () {
        // 사용자 아이콘 클릭 시 로그인 상태 확인 후 마이페이지 또는 로그인 페이지로 이동
        const userIcon = document.getElementById("userIcon");
        if (userIcon) {
          userIcon.addEventListener("click", function (e) {
            e.preventDefault();

            // 로그인 상태 확인
            fetch("/bdproject/api/auth/check")
              .then(response => response.json())
              .then(data => {
                if (data.loggedIn) {
                  // 로그인 상태면 마이페이지로 이동
                  window.location.href = "/bdproject/project_mypage.jsp";
                } else {
                  // 로그인 안 되어 있으면 로그인 페이지로 이동
                  window.location.href = "/bdproject/projectLogin.jsp";
                }
              })
              .catch(error => {
                console.error("로그인 상태 확인 오류:", error);
                // 오류 시 기본적으로 로그인 페이지로 이동
                window.location.href = "/bdproject/projectLogin.jsp";
              });
          });
        }
      });

      // 인기 복지 서비스 조회 함수
      function loadPopularWelfareServices() {
        console.log("인기 복지 서비스 로딩 시작 (실시간 API)");
        const popularList = document.getElementById("popular-welfare-list");

        fetch("/bdproject/welfare/popular")
          .then((response) => {
            console.log("API 응답 상태:", response.status, response.statusText);
            if (!response.ok) {
              throw new Error("서버 응답 오류: " + response.status);
            }
            return response.json();
          })
          .then((data) => {
            console.log("받은 데이터:", data);
            displayPopularWelfareServices(data);
          })
          .catch((error) => {
            console.error("인기 복지 서비스 조회 오류:", error);
            popularList.innerHTML =
              '<div class="loading-popular">' +
              '<p style="color: #dc3545;">인기 복지 혜택을 불러올 수 없습니다.</p>' +
              '<p style="color: #666; font-size: 12px;">오류: ' +
              error.message +
              "</p>" +
              "</div>";
          });
      }

      // 슬라이더 상태 관리
      let currentSlide = 0;
      let totalSlides = 0;
      let welfareServices = [];
      const itemsPerSlide = 4;

      // 인기 복지 서비스 표시 함수
      function displayPopularWelfareServices(services) {
        console.log("displayPopularWelfareServices 호출됨, 데이터 개수:", services ? services.length : 0);
        const popularList = document.getElementById("popular-welfare-list");

        if (!services || services.length === 0) {
          popularList.innerHTML = '<div class="loading-popular"><p>표시할 복지 혜택이 없습니다.</p></div>';
          return;
        }

        // 조회수 기준 정렬 후 상위 12개만 표시
        welfareServices = services
          .sort((a, b) => {
            const aViews = parseInt(a.inqNum) || 0;
            const bViews = parseInt(b.inqNum) || 0;
            return bViews - aViews;
          })
          .slice(0, 12);

        console.log("정렬 후 서비스 개수:", welfareServices.length);

        // 슬라이더 초기화
        popularList.innerHTML = "";
        popularList.className = "welfare-slider";
        totalSlides = Math.ceil(welfareServices.length / itemsPerSlide);

        // 카드들 생성
        welfareServices.forEach((service, index) => {
          const serviceName = service.servNm || "서비스명 없음";
          const jurMnofNm = service.jurMnofNm || "";
          const jurOrgNm = service.jurOrgNm || "";
          const viewCount = parseInt(service.inqNum) || 0;
          const rank = index + 1;

          // 날짜 생성
          const daysAgo = Math.floor(Math.random() * 30);
          const date = new Date();
          date.setDate(date.getDate() - daysAgo);
          const dateStr = date.getFullYear() + "." +
            String(date.getMonth() + 1).padStart(2, "0") + "." +
            String(date.getDate()).padStart(2, "0");

          const item = document.createElement("div");
          item.className = "popular-welfare-item";

          // 조회수 포맷팅 (1000 이상이면 K로 표시)
          const formattedViews = viewCount >= 1000
            ? (viewCount / 1000).toFixed(1) + 'K'
            : viewCount.toLocaleString();

          item.innerHTML =
            '<div class="welfare-logo">' + rank + "</div>" +
            '<div class="welfare-name">' + serviceName + "</div>" +
            '<div class="welfare-org">' + (jurMnofNm + (jurOrgNm ? " " + jurOrgNm : "")) + "</div>" +
            '<div class="welfare-footer">' +
              '<div class="welfare-date">' +
                '<i class="far fa-calendar-alt"></i>' +
                dateStr +
              '</div>' +
              '<div class="welfare-views-badge">' +
                '<i class="far fa-eye"></i>' +
                formattedViews +
              '</div>' +
            '</div>';

          // 클릭 시 상세 정보 표시
          item.addEventListener("click", () => {
            if (service.servDtlLink) {
              window.open(service.servDtlLink, "_blank");
            } else {
              alert("해당 서비스의 상세 정보가 없습니다.");
            }
          });

          popularList.appendChild(item);
        });

        console.log("카드 생성 완료");

        // 인디케이터 생성
        createSliderIndicators();

        // 초기 슬라이드 설정
        currentSlide = 0;
        updateSlider();
        updateNavigationButtons();
      }

      // 슬라이더 인디케이터 생성
      function createSliderIndicators() {
        const indicatorsContainer = document.getElementById("sliderIndicators");
        if (!indicatorsContainer) return;

        indicatorsContainer.innerHTML = "";

        for (let i = 0; i < totalSlides; i++) {
          const indicator = document.createElement("div");
          indicator.className = "slider-indicator" + (i === 0 ? " active" : "");
          indicator.onclick = () => goToSlide(i);
          indicatorsContainer.appendChild(indicator);
        }
      }

      // 슬라이드 이동
      function moveSlide(direction) {
        currentSlide += direction;
        if (currentSlide < 0) currentSlide = 0;
        if (currentSlide >= totalSlides) currentSlide = totalSlides - 1;

        updateSlider();
        updateNavigationButtons();
        updateIndicators();
      }

      // 특정 슬라이드로 이동
      function goToSlide(index) {
        currentSlide = index;
        updateSlider();
        updateNavigationButtons();
        updateIndicators();
      }

      // 슬라이더 위치 업데이트
      function updateSlider() {
        const slider = document.getElementById("popular-welfare-list");
        if (!slider) return;

        const offset = currentSlide * 100;
        slider.style.transform = "translateX(-" + offset + "%)";
        console.log("슬라이더 이동:", currentSlide, "offset:", offset);
      }

      // 네비게이션 버튼 상태 업데이트
      function updateNavigationButtons() {
        const prevBtn = document.getElementById("prevBtn");
        const nextBtn = document.getElementById("nextBtn");

        if (prevBtn && nextBtn) {
          prevBtn.disabled = currentSlide === 0;
          nextBtn.disabled = currentSlide === totalSlides - 1;
        }
      }

      // 인디케이터 상태 업데이트
      function updateIndicators() {
        const indicators = document.querySelectorAll(".slider-indicator");
        indicators.forEach((indicator, index) => {
          if (index === currentSlide) {
            indicator.classList.add("active");
          } else {
            indicator.classList.remove("active");
          }
        });
      }
    </script>
  </body>
</html>