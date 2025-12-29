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
    <link rel="stylesheet" href="resources/css/project.css" />
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
    <script src="resources/js/project.js"></script>
  </body>
</html>