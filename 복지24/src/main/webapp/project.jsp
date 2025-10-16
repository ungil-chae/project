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
        overflow-x: hidden;
        background-color: #e2f0f6; /* 전체 배경색 설정 */
      }
      * {
        box-sizing: border-box;
      }
      body {
        position: relative;
        background-color: #fafafa;
        color: #191918;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
          sans-serif;
      }
      #main-header {
        position: sticky;
        top: 0;
        z-index: 1000;
        background-color: white;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.05);
      }
      /* --- 4. 네비바 세로 길이 수정 --- */
      .navbar {
        background-color: transparent;
        padding: 0 40px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        height: 60px; /* 세로 길이 줄임 */
      }
      .navbar-left {
        flex-shrink: 0;
      }
      .nav-menu {
        display: flex;
        gap: 50px;
        align-items: center;
        justify-content: center;
        flex-grow: 1;
      }
      /* --- 4. 네비바 아이콘 추가 --- */
      .navbar-right {
        display: flex;
        align-items: center;
        gap: 20px;
      }
      .navbar-icon {
        width: 22px;
        height: 22px;
        cursor: pointer;
        color: #333;
      }

      /* 언어 드롭다운 스타일 */
      .language-selector {
        position: relative;
        display: inline-block;
      }

      .language-dropdown {
        position: absolute;
        top: 100%;
        right: 0;
        background: white;
        border: 1px solid #e0e0e0;
        border-radius: 8px;
        box-shadow: 0 4px 12px rgba(0, 0, 0, 0.1);
        padding: 8px 0;
        min-width: 160px;
        max-height: 300px;
        overflow-y: auto;
        z-index: 9999;
        margin-top: 5px;
        opacity: 0;
        visibility: hidden;
        transform: translateY(-10px);
        transition: all 0.2s ease;
      }

      .language-dropdown.active {
        opacity: 1;
        visibility: visible;
        transform: translateY(0);
      }

      .language-option {
        display: flex;
        flex-direction: column;
        align-items: flex-start;
        padding: 12px 16px;
        cursor: pointer;
        transition: background-color 0.2s ease;
        border-bottom: 1px solid #f0f0f0;
      }

      .language-option:last-child {
        border-bottom: none;
      }

      .language-option:hover {
        background-color: #f5f5f5;
      }

      .language-option.active {
        background-color: #e3f2fd;
      }

      .country-name {
        font-weight: 600;
        color: #333;
        font-size: 14px;
        margin-bottom: 2px;
      }

      .language-name {
        font-size: 12px;
        color: #666;
      }

      .logo {
        display: flex;
        align-items: center;
        gap: 8px;
        text-decoration: none;
        color: #333;
        width: fit-content;
        transition: opacity 0.2s ease;
      }
      .logo:hover {
        opacity: 0.7;
      }
      .logo-icon {
        width: 40px;
        height: 40px;
        background-image: url("resources/image/복지로고.png");
        background-size: contain;
        background-repeat: no-repeat;
        background-position: center;
      }
      .logo-text {
        font-size: 24px;
        font-weight: 700;
        color: #333;
      }

      .nav-item {
        height: 100%;
        display: flex;
        align-items: center;
      }

      /* --- 3. 네비바 메뉴 텍스트 진하게 --- */
      .nav-link {
        color: #333;
        text-decoration: none;
        font-size: 15px;
        font-weight: 600; /* 텍스트 진하게 */
        transition: all 0.2s ease;
        padding: 18px 15px; /* 패딩 조정 */
        border-radius: 8px;
      }
      .nav-link:hover,
      .nav-link.active {
        background-color: #f5f5f5;
        color: #333;
      }

      /* --- 1. 네비바 세부 메뉴 수정 --- */
      #mega-menu-wrapper {
        position: absolute;
        width: 100%;
        background-color: white;
        color: #333;
        left: 0;
        top: 60px; /* 네비바 높이에 맞게 조정 */
        max-height: 0;
        overflow: hidden;
        transition: max-height 0.4s ease-in-out, padding 0.4s ease-in-out,
          border-top 0.4s ease-in-out;
        border-top: 1px solid transparent;
        box-shadow: 0 8px 16px rgba(0, 0, 0, 0.05);
      }

      #mega-menu-wrapper.active {
        max-height: 500px;
        padding: 30px 0 40px 0;
        border-top: 1px solid #e0e0e0;
      }

      .mega-menu-content {
        max-width: 1000px; /* 너비 조정 */
        margin: 0 auto;
        padding: 0 40px;
        display: flex;
        justify-content: flex-start; /* 왼쪽 정렬 */
        gap: 60px;
      }

      .menu-column {
        display: none;
        flex-direction: column;
        gap: 25px; /* 간격 조정 */
      }

      .menu-column.active {
        display: flex;
      }

      .dropdown-link {
        color: #333;
        text-decoration: none;
        display: block;
      }
      .dropdown-link-title {
        font-weight: 700;
        font-size: 15px;
        display: inline-block;
        position: relative;
        padding-bottom: 5px;
        color: #000000;
      }
      .dropdown-link-title::after {
        content: "";
        position: absolute;
        bottom: 0;
        left: 0;
        width: 0;
        height: 2px;
        background-color: #000000;
        transition: width 0.3s ease;
      }
      .dropdown-link:hover .dropdown-link-title::after {
        width: 100%; /* 호버 시 진한 밑줄 */
      }
      .dropdown-link-desc {
        font-size: 13px;
        color: #555;
        margin-top: 6px;
        display: block;
      }
      /* --- 네비바 수정 끝 --- */

      /* --- 2. 배경색 설정 --- */
      .main-background-section {
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
        background-size: cover; /* ★★★ 수정됨 ★★★ */
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

      /* main-right와 donation 사이의 중간 섹션 - 웹앱 컨셉에 맞춘 깔끔한 디자인 */
      .middle-section {
        width: 100%;
        min-height: 650px;
        background: #f8f9fa;
        position: relative;
        z-index: 0;
        display: flex;
        flex-direction: column;
        align-items: center;
        padding: 80px 20px 100px;
      }

      .popular-welfare-title {
        font-size: 36px;
        font-weight: 700;
        color: #2c3e50;
        margin-bottom: 12px;
        text-align: center;
      }

      .popular-welfare-subtitle {
        font-size: 16px;
        color: #6c757d;
        margin-bottom: 50px;
        text-align: center;
        line-height: 1.5;
      }

      .popular-welfare-container {
        position: relative;
        max-width: 1200px;
        width: 100%;
        margin: 0 auto;
        padding: 0 60px;
      }

      .welfare-slider-wrapper {
        overflow: hidden;
        width: 100%;
      }

      .welfare-slider {
        display: flex;
        transition: transform 0.5s ease;
        gap: 20px;
      }

      .popular-welfare-item {
        background: white;
        border-radius: 15px;
        padding: 25px;
        box-shadow: 0 2px 15px rgba(0, 0, 0, 0.08);
        transition: all 0.3s ease;
        cursor: pointer;
        position: relative;
        flex: 0 0 calc(33.333% - 14px);
        min-width: 300px;
        border: 1px solid #e9ecef;
      }

      .popular-welfare-item:hover {
        transform: translateY(-5px);
        box-shadow: 0 8px 30px rgba(0, 97, 255, 0.15);
        border-color: #0061ff;
      }

      .welfare-rank {
        position: absolute;
        top: 20px;
        right: 20px;
        background: #0061ff;
        color: white;
        width: 36px;
        height: 36px;
        border-radius: 8px;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 700;
        font-size: 15px;
      }

      .welfare-rank.top-3 {
        background: #ff6b6b;
      }

      .welfare-info {
        margin-right: 45px;
      }

      .welfare-name {
        font-size: 17px;
        font-weight: 600;
        color: #2c3e50;
        margin-bottom: 12px;
        line-height: 1.5;
        display: -webkit-box;
        -webkit-line-clamp: 2;
        -webkit-box-orient: vertical;
        overflow: hidden;
        min-height: 48px;
      }

      .welfare-org {
        font-size: 13px;
        color: #6c757d;
        margin-bottom: 8px;
      }

      .welfare-views {
        font-size: 14px;
        color: #0061ff;
        font-weight: 600;
      }

      .welfare-source {
        display: inline-block;
        padding: 5px 12px;
        font-size: 11px;
        border-radius: 4px;
        font-weight: 600;
        margin-top: 10px;
      }

      .source-central {
        background: #e3f2fd;
        color: #1976d2;
      }

      .source-local {
        background: #f3e5f5;
        color: #7b1fa2;
      }

      .loading-popular {
        text-align: center;
        padding: 60px 40px;
        color: #6c757d;
        font-size: 16px;
      }

      .slider-nav-btn {
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        background: white;
        border: 1px solid #e9ecef;
        border-radius: 8px;
        width: 48px;
        height: 48px;
        display: flex;
        align-items: center;
        justify-content: center;
        cursor: pointer;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.1);
        z-index: 2;
        transition: all 0.2s ease;
        color: #495057;
        font-size: 22px;
        font-weight: bold;
      }

      .slider-nav-btn:hover {
        background: #0061ff;
        color: white;
        border-color: #0061ff;
        transform: translateY(-50%) scale(1.05);
      }

      .slider-nav-btn:disabled {
        opacity: 0.3;
        cursor: not-allowed;
        transform: translateY(-50%);
      }

      .slider-nav-btn:disabled:hover {
        background: white;
        color: #495057;
        border-color: #e9ecef;
        transform: translateY(-50%);
      }

      .slider-prev {
        left: 0;
      }

      .slider-next {
        right: 0;
      }

      .loading-spinner {
        width: 48px;
        height: 48px;
        border: 4px solid #e9ecef;
        border-top: 4px solid #0061ff;
        border-radius: 50%;
        animation: spin 1s linear infinite;
        margin: 0 auto 20px;
      }

      @keyframes spin {
        0% {
          transform: rotate(0deg);
        }
        100% {
          transform: rotate(360deg);
        }
      }

      #donation-container {
        position: relative;
        margin-top: 0; /* middle-section 바로 뒤에 위치 */
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

      /* Footer 스타일 */
      footer {
        position: relative;
        z-index: 10;
        background: #2c3e50;
        color: #ecf0f1;
        padding: 60px 20px 30px;
        margin-top: 80px;
      }
      .footer-container {
        max-width: 1400px;
        margin: 0 auto;
      }
      .footer-content {
        display: grid;
        grid-template-columns: 2fr 1fr 1fr 1fr 1.5fr;
        gap: 40px;
        margin-bottom: 40px;
      }
      .footer-section h3 {
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 20px;
        color: #fff;
      }
      .footer-about p {
        line-height: 1.8;
        color: #bdc3c7;
        margin-bottom: 15px;
        font-size: 14px;
      }
      .footer-links {
        list-style: none;
        padding: 0;
        margin: 0;
      }
      .footer-links li {
        margin-bottom: 12px;
      }
      .footer-links a {
        color: #bdc3c7;
        text-decoration: none;
        font-size: 14px;
        transition: color 0.3s ease;
      }
      .footer-links a:hover {
        color: #3498db;
      }
      .footer-contact p {
        color: #bdc3c7;
        margin-bottom: 12px;
        font-size: 14px;
        line-height: 1.8;
      }
      .footer-contact strong {
        color: #fff;
        display: block;
        margin-bottom: 5px;
      }
      .social-links {
        display: flex;
        gap: 15px;
        margin-top: 20px;
      }
      .social-icon {
        width: 40px;
        height: 40px;
        background: #34495e;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        color: #ecf0f1;
        text-decoration: none;
        font-size: 18px;
        transition: all 0.3s ease;
      }
      .social-icon:hover {
        background: #3498db;
        transform: translateY(-3px);
      }
      .footer-bottom {
        border-top: 1px solid #34495e;
        padding-top: 30px;
        text-align: center;
      }
      .footer-bottom-content {
        display: flex;
        flex-direction: column;
        gap: 15px;
        align-items: center;
      }
      .footer-bottom p {
        color: #95a5a6;
        font-size: 13px;
        margin: 5px 0;
      }
      .footer-legal-links {
        display: flex;
        gap: 20px;
        margin-top: 10px;
      }
      .footer-legal-links a {
        color: #95a5a6;
        text-decoration: none;
        font-size: 13px;
        transition: color 0.3s ease;
      }
      .footer-legal-links a:hover {
        color: #3498db;
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
        .footer-content {
          grid-template-columns: 1fr;
          gap: 30px;
        }
        .footer-legal-links {
          flex-direction: column;
          gap: 10px;
        }
      }
    </style>
  </head>
  <body>
    <div class="main-background-section"></div>

    <header id="main-header">
      <nav class="navbar">
        <div class="navbar-left">
          <a href="/bdproject/project.jsp" class="logo">
            <div class="logo-icon"></div>
            <span class="logo-text">복지24</span>
          </a>
        </div>
        <div class="nav-menu">
          <div class="nav-item">
            <a href="#" class="nav-link" data-menu="service">서비스</a>
          </div>
          <div class="nav-item">
            <a href="#" class="nav-link" data-menu="explore">살펴보기</a>
          </div>
          <div class="nav-item">
            <a href="#" class="nav-link" data-menu="volunteer">봉사하기</a>
          </div>
          <div class="nav-item">
            <a href="#" class="nav-link" data-menu="donate">기부하기</a>
          </div>
        </div>
        <div class="navbar-right">
          <div class="language-selector">
            <svg
              class="navbar-icon"
              id="languageToggle"
              xmlns="http://www.w3.org/2000/svg"
              viewBox="0 0 24 24"
              fill="currentColor"
            >
              <path
                d="M12 2C6.477 2 2 6.477 2 12s4.477 10 10 10 10-4.477 10-10S17.523 2 12 2zm6.93 6h-2.95a15.65 15.65 0 00-1.38-3.56A8.03 8.03 0 0118.93 8zM12 4.04c.83 1.2 1.48 2.53 1.91 3.96h-3.82c.43-1.43 1.08-2.76 1.91-3.96zM4.26 14C4.1 13.36 4 12.69 4 12s.1-1.36.26-2h3.38c-.08.66-.14 1.32-.14 2 0 .68.06 1.34.14 2H4.26zm.81 2h2.95c.32 1.25.78 2.45 1.38 3.56A7.987 7.987 0 015.07 16zm2.95-8H5.07a7.987 7.987 0 014.33-3.56A15.65 15.65 0 008.02 8zM12 19.96c-.83-1.2-1.48-2.53-1.91-3.96h3.82c-.43 1.43-1.08 2.76-1.91 3.96zM14.34 14H9.66c-.09-.66-.16-1.32-.16-2 0-.68.07-1.35.16-2h4.68c.09.65.16 1.32.16 2 0 .68-.07 1.34-.16 2zm.25 5.56c.6-1.11 1.06-2.31 1.38-3.56h2.95a8.03 8.03 0 01-4.33 3.56zM16.36 14c.08-.66.14-1.32.14-2 0-.68-.06-1.34-.14-2h3.38c.16.64.26 1.31.26 2s-.1 1.36-.26 2h-3.38z"
              ></path>
            </svg>
            <div class="language-dropdown" id="languageDropdown">
              <div class="language-option" data-lang="ko">
                <span class="country-name">대한민국</span>
                <span class="language-name">한국어</span>
              </div>
              <div class="language-option" data-lang="en">
                <span class="country-name">Australia</span>
                <span class="language-name">English</span>
              </div>
              <div class="language-option" data-lang="ja">
                <span class="country-name">日本</span>
                <span class="language-name">日本語</span>
              </div>
              <div class="language-option" data-lang="zh">
                <span class="country-name">中国</span>
                <span class="language-name">中文</span>
              </div>
              <div class="language-option" data-lang="es">
                <span class="country-name">España</span>
                <span class="language-name">Español</span>
              </div>
            </div>
          </div>
          <svg
            class="navbar-icon"
            id="userIcon"
            xmlns="http://www.w3.org/2000/svg"
            viewBox="0 0 24 24"
            fill="currentColor"
            style="cursor: pointer"
          >
            <path
              d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 4c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm0 14c-2.03 0-4.43-.82-6.14-2.88C7.55 15.8 9.68 15 12 15s4.45.8 6.14 2.12C16.43 19.18 14.03 20 12 20z"
            ></path>
          </svg>
        </div>
      </nav>
      <div id="mega-menu-wrapper">
        <div class="mega-menu-content">
          <div class="menu-column" data-menu-content="service">
            <a href="/bdproject/project_detail.jsp" class="dropdown-link">
              <span class="dropdown-link-title">복지 혜택 찾기</span>
              <span class="dropdown-link-desc"
                >나에게 맞는 복지 혜택을 찾아보세요.</span
              >
            </a>
            <a href="/bdproject/project_Map.jsp" class="dropdown-link">
              <span class="dropdown-link-title">복지 지도</span>
              <span class="dropdown-link-desc"
                >주변의 복지시설을 지도로 확인하세요.</span
              >
            </a>
          </div>
          <div class="menu-column" data-menu-content="explore">
            <a href="/bdproject/project_notice.jsp" class="dropdown-link">
              <span class="dropdown-link-title">공지사항</span>
              <span class="dropdown-link-desc"
                >새로운 복지 소식을 알려드립니다.</span
              >
            </a>
            <a href="/bdproject/project_faq.jsp" class="dropdown-link">
              <span class="dropdown-link-title">자주묻는 질문</span>
              <span class="dropdown-link-desc"
                >궁금한 점을 빠르게 해결하세요.</span
              >
            </a>
            <a href="/bdproject/project_about.jsp" class="dropdown-link">
              <span class="dropdown-link-title">소개</span>
              <span class="dropdown-link-desc">복지24에 대해 알아보세요.</span>
            </a>
          </div>
          <div class="menu-column" data-menu-content="volunteer">
            <a href="#" class="dropdown-link">
              <span class="dropdown-link-title">봉사 신청</span>
              <span class="dropdown-link-desc"
                >나에게 맞는 봉사활동을 찾아보세요.</span
              >
            </a>
            <a href="#" class="dropdown-link">
              <span class="dropdown-link-title">봉사 기록</span>
              <span class="dropdown-link-desc"
                >나의 봉사활동 내역을 확인하세요.</span
              >
            </a>
          </div>
          <div class="menu-column" data-menu-content="donate">
            <a href="/bdproject/project_Donation.jsp" class="dropdown-link">
              <span class="dropdown-link-title">기부하기</span>
              <span class="dropdown-link-desc"
                >따뜻한 나눔으로 세상을 변화시켜보세요.</span
              >
            </a>
            <a href="#" class="dropdown-link">
              <span class="dropdown-link-title">후원자 리뷰</span>
              <span class="dropdown-link-desc"
                >따뜻한 나눔 이야기를 들어보세요.</span
              >
            </a>
            <a href="#" class="dropdown-link">
              <span class="dropdown-link-title">기금 사용처</span>
              <span class="dropdown-link-desc"
                >후원금을 투명하게 운영합니다.</span
              >
            </a>
          </div>
        </div>
      </div>
    </header>

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

    <!-- main-right와 donation 사이의 중간 섹션 -->
    <div class="middle-section">
      <h2 class="popular-welfare-title">가장 많이 조회된 복지 혜택</h2>

      <div id="popular-welfare-list">
        <div class="loading-popular">
          <div class="loading-spinner"></div>
          <p>인기 복지 혜택을 불러오는 중...</p>
        </div>
      </div>
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
            <button class="next-btn" id="nextBtn" onclick="goToDonation()">후원자 정보 입력</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Footer -->
    <footer>
      <div class="footer-container">
        <div class="footer-content">
          <!-- 회사 소개 -->
          <div class="footer-section footer-about">
            <h3>복지24</h3>
            <p>
              국민 모두가 누려야 할 복지 혜택,<br />
              복지24가 찾아드립니다.
            </p>
            <p style="font-size: 13px; color: #95a5a6">
              보건복지부, 지방자치단체와 함께<br />
              국민의 복지 향상을 위해 노력합니다.
            </p>
          </div>

          <!-- 서비스 -->
          <div class="footer-section">
            <h3>서비스</h3>
            <ul class="footer-links">
              <li><a href="/bdproject/project_detail.jsp">복지 혜택 찾기</a></li>
              <li><a href="/bdproject/project_Map.jsp">복지 지도</a></li>
              <li><a href="/bdproject/project_information.jsp">상황 진단하기</a></li>
            </ul>
          </div>

          <!-- 참여하기 -->
          <div class="footer-section">
            <h3>참여하기</h3>
            <ul class="footer-links">
              <li><a href="#">봉사 신청</a></li>
              <li><a href="/bdproject/project_Donation.jsp">기부하기</a></li>
              <li><a href="#">후원자 리뷰</a></li>
            </ul>
          </div>

          <!-- 고객지원 -->
          <div class="footer-section">
            <h3>고객지원</h3>
            <ul class="footer-links">
              <li><a href="/bdproject/project_notice.jsp">공지사항</a></li>
              <li><a href="/bdproject/project_faq.jsp">자주묻는 질문</a></li>
              <li><a href="/bdproject/project_about.jsp">소개</a></li>
            </ul>
          </div>

          <!-- 문의 정보 -->
          <div class="footer-section footer-contact">
            <h3>고객센터</h3>
            <p>
              <strong>전화</strong>
              1234-5678
            </p>
            <p>
              <strong>운영시간</strong>
              평일 09:00 - 18:00<br />
              (주말 및 공휴일 휴무)
            </p>
            <p>
              <strong>이메일</strong>
              support@welfare24.com
            </p>
            <div class="social-links">
              <a href="#" class="social-icon" aria-label="Facebook">
                <i class="fab fa-facebook-f"></i>
              </a>
              <a href="#" class="social-icon" aria-label="Instagram">
                <i class="fab fa-instagram"></i>
              </a>
              <a href="#" class="social-icon" aria-label="YouTube">
                <i class="fab fa-youtube"></i>
              </a>
              <a href="#" class="social-icon" aria-label="Blog">
                <i class="fas fa-blog"></i>
              </a>
            </div>
          </div>
        </div>

        <!-- 하단 정보 -->
        <div class="footer-bottom">
          <div class="footer-bottom-content">
            <div class="footer-legal-links">
              <a href="#">이용약관</a>
              <a href="#" style="font-weight: 600; color: #3498db">개인정보처리방침</a>
              <a href="#">이메일무단수집거부</a>
            </div>
            <p>
              사업자등록번호: 123-45-67890 | 대표: 홍길동 | 통신판매업신고: 제2024-서울종로-0000호
            </p>
            <p>
              주소: 서울특별시 종로구 세종대로 209 (복지로 빌딩)
            </p>
            <p style="margin-top: 10px">
              Copyright &copy; 2024 복지24. All rights reserved.
            </p>
          </div>
        </div>
      </div>
    </footer>

    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
      // 다국어 지원 객체
      const translations = {
        ko: {
          // 네비바
          "nav-service": "서비스",
          "nav-explore": "살펴보기",
          "nav-volunteer": "봉사하기",
          "nav-donate": "기부하기",

          // 서비스 메뉴
          "service-welfare-search": "복지 혜택 찾기",
          "service-welfare-search-desc": "나에게 맞는 복지 혜택을 찾아보세요.",
          "service-welfare-map": "복지 지도",
          "service-welfare-map-desc": "주변의 복지시설을 지도로 확인하세요.",

          // 살펴보기 메뉴
          "explore-notice": "공지사항",
          "explore-notice-desc": "새로운 복지 소식을 알려드립니다.",
          "explore-faq": "자주묻는 질문",
          "explore-faq-desc": "궁금한 점을 빠르게 해결하세요.",
          "explore-about": "소개",
          "explore-about-desc": "복지24에 대해 알아보세요.",

          // 봉사하기 메뉴
          "volunteer-apply": "봉사 신청",
          "volunteer-apply-desc": "나에게 맞는 봉사활동을 찾아보세요.",
          "volunteer-record": "봉사 기록",
          "volunteer-record-desc": "나의 봉사활동 내역을 확인하세요.",

          // 기부하기 메뉴
          "donate-main": "기부하기",
          "donate-main-desc": "따뜻한 나눔으로 세상을 변화시켜보세요.",
          "donate-review": "후원자 리뷰",
          "donate-review-desc": "따뜻한 나눔 이야기를 들어보세요.",

          // 메인 콘텐츠
          "main-title": "나에게 맞는 정보,<br>한눈에 확인하세요.",
          "main-subtitle": "숨은 혜택을 찾아드립니다.",
          "main-cta-btn": "나의 상황 진단하기",

          // 기부하기 섹션
          "donation-title": "기부하기",
          "donation-subtitle": "당신의 나눔이 모두의 행복입니다.",
        },
        en: {
          // 네비바
          "nav-service": "Services",
          "nav-explore": "Explore",
          "nav-volunteer": "Volunteer",
          "nav-donate": "Donate",

          // 서비스 메뉴
          "service-welfare-search": "Find Welfare Benefits",
          "service-welfare-search-desc": "Find welfare benefits that suit you.",
          "service-welfare-map": "Welfare Map",
          "service-welfare-map-desc":
            "Check nearby welfare facilities on the map.",

          // 살펴보기 메뉴
          "explore-notice": "Notice",
          "explore-notice-desc": "Get the latest welfare news.",
          "explore-faq": "FAQ",
          "explore-faq-desc": "Quickly resolve your questions.",
          "explore-about": "About",
          "explore-about-desc": "Learn about Welfare24.",

          // 봉사하기 메뉴
          "volunteer-apply": "Apply for Volunteer",
          "volunteer-apply-desc": "Find volunteer activities that suit you.",
          "volunteer-record": "Volunteer Record",
          "volunteer-record-desc": "Check your volunteer activity history.",

          // 기부하기 메뉴
          "donate-main": "Donate",
          "donate-main-desc": "Change the world with warm sharing.",
          "donate-review": "Donor Reviews",
          "donate-review-desc": "Listen to warm sharing stories.",

          // 메인 콘텐츠
          "main-title": "Find the right information<br>for you at a glance.",
          "main-subtitle": "We help you find hidden benefits.",
          "main-cta-btn": "Diagnose My Situation",

          // 기부하기 섹션
          "donation-title": "Donation",
          "donation-subtitle": "Your sharing is everyone's happiness.",
        },
        ja: {
          // 네비바
          "nav-service": "サービス",
          "nav-explore": "探索",
          "nav-volunteer": "ボランティア",
          "nav-donate": "寄付",

          // 서비스 메뉴
          "service-welfare-search": "福祉給付を探す",
          "service-welfare-search-desc":
            "あなたに合った福祉給付を見つけましょう。",
          "service-welfare-map": "福祉マップ",
          "service-welfare-map-desc": "近くの福祉施設を地図で確認しましょう。",

          // 살펴보기 메뉴
          "explore-notice": "お知らせ",
          "explore-notice-desc": "最新の福祉ニュースをお届けします。",
          "explore-faq": "よくある質問",
          "explore-faq-desc": "疑問を素早く解決しましょう。",
          "explore-about": "概要",
          "explore-about-desc": "Welfare24について学びましょう。",

          // 봉사하기 메뉴
          "volunteer-apply": "ボランティア申請",
          "volunteer-apply-desc":
            "あなたに合ったボランティア活動を見つけましょう。",
          "volunteer-record": "ボランティア記録",
          "volunteer-record-desc":
            "あなたのボランティア活動履歴を確認しましょう。",

          // 기부하기 메뉴
          "donate-main": "寄付する",
          "donate-main-desc": "温かい分かち合いで世界を変えましょう。",
          "donate-review": "寄付者レビュー",
          "donate-review-desc": "温かい分かち合いの話を聞きましょう。",

          // 메인 콘텐츠
          "main-title": "あなたに合った情報を<br>一目で確認しましょう。",
          "main-subtitle": "隠れた給付を見つけます。",
          "main-cta-btn": "私の状況を診断",

          // 기부하기 섹션
          "donation-title": "寄付",
          "donation-subtitle": "あなたの分かち合いがみんなの幸せです。",
        },
        zh: {
          // 네비바
          "nav-service": "服务",
          "nav-explore": "浏览",
          "nav-volunteer": "志愿者",
          "nav-donate": "捐赠",

          // 서비스 메뉴
          "service-welfare-search": "查找福利补贴",
          "service-welfare-search-desc": "找到适合您的福利补贴。",
          "service-welfare-map": "福利地图",
          "service-welfare-map-desc": "在地图上查看附近的福利设施。",

          // 살펴보기 메뉴
          "explore-notice": "公告",
          "explore-notice-desc": "获取最新的福利消息。",
          "explore-faq": "常见问题",
          "explore-faq-desc": "快速解决您的疑问。",
          "explore-about": "关于",
          "explore-about-desc": "了解Welfare24。",

          // 봉사하기 메뉴
          "volunteer-apply": "申请志愿者",
          "volunteer-apply-desc": "找到适合您的志愿活动。",
          "volunteer-record": "志愿记录",
          "volunteer-record-desc": "查看您的志愿活动历史。",

          // 기부하기 메뉴
          "donate-main": "捐赠",
          "donate-main-desc": "用温暖的分享改变世界。",
          "donate-review": "捐赠者评价",
          "donate-review-desc": "聆听温暖的分享故事。",

          // 메인 콘텐츠
          "main-title": "一目了然地<br>查看适合您的信息。",
          "main-subtitle": "我们帮您找到隐藏的福利。",
          "main-cta-btn": "诊断我的情况",

          // 기부하기 섹션
          "donation-title": "捐赠",
          "donation-subtitle": "您的分享是大家的幸福。",
        },
        es: {
          // 네비바
          "nav-service": "Servicios",
          "nav-explore": "Explorar",
          "nav-volunteer": "Voluntario",
          "nav-donate": "Donar",

          // 서비스 메뉴
          "service-welfare-search": "Encontrar Beneficios Sociales",
          "service-welfare-search-desc":
            "Encuentra beneficios sociales que se adapten a ti.",
          "service-welfare-map": "Mapa de Bienestar",
          "service-welfare-map-desc":
            "Revisa las instalaciones de bienestar cercanas en el mapa.",

          // 살펴보기 메뉴
          "explore-notice": "Avisos",
          "explore-notice-desc": "Obtén las últimas noticias de bienestar.",
          "explore-faq": "Preguntas Frecuentes",
          "explore-faq-desc": "Resuelve rápidamente tus preguntas.",
          "explore-about": "Acerca de",
          "explore-about-desc": "Aprende sobre Welfare24.",

          // 봉사하기 메뉴
          "volunteer-apply": "Aplicar para Voluntario",
          "volunteer-apply-desc":
            "Encuentra actividades de voluntariado que se adapten a ti.",
          "volunteer-record": "Registro de Voluntario",
          "volunteer-record-desc":
            "Revisa tu historial de actividades de voluntariado.",

          // 기부하기 메뉴
          "donate-main": "Donar",
          "donate-main-desc": "Cambia el mundo con un compartir cálido.",
          "donate-review": "Reseñas de Donantes",
          "donate-review-desc": "Escucha historias cálidas de compartir.",

          // 메인 콘텐츠
          "main-title":
            "Encuentra la información correcta<br>para ti de un vistazo.",
          "main-subtitle": "Te ayudamos a encontrar beneficios ocultos.",
          "main-cta-btn": "Diagnosticar Mi Situación",

          // 기부하기 섹션
          "donation-title": "Donación",
          "donation-subtitle": "Tu compartir es la felicidad de todos.",
        },
      };

      let currentLanguage = localStorage.getItem("preferred-language") || "ko";

      // 언어 전환 함수

      // 페이지 언어 업데이트 함수
      function updatePageLanguage() {
        const t = translations[currentLanguage];

        // 네비바 메뉴 업데이트
        document.querySelector('[data-menu="service"]').textContent =
          t["nav-service"];
        document.querySelector('[data-menu="explore"]').textContent =
          t["nav-explore"];
        document.querySelector('[data-menu="volunteer"]').textContent =
          t["nav-volunteer"];
        document.querySelector('[data-menu="donate"]').textContent =
          t["nav-donate"];

        // 드롭다운 메뉴 업데이트 - 서비스
        const serviceMenu = document.querySelector(
          '[data-menu-content="service"]'
        );
        const serviceLinks = serviceMenu.querySelectorAll(".dropdown-link");
        serviceLinks[0].querySelector(".dropdown-link-title").textContent =
          t["service-welfare-search"];
        serviceLinks[0].querySelector(".dropdown-link-desc").textContent =
          t["service-welfare-search-desc"];
        serviceLinks[1].querySelector(".dropdown-link-title").textContent =
          t["service-welfare-map"];
        serviceLinks[1].querySelector(".dropdown-link-desc").textContent =
          t["service-welfare-map-desc"];

        // 드롭다운 메뉴 업데이트 - 살펴보기
        const exploreMenu = document.querySelector(
          '[data-menu-content="explore"]'
        );
        const exploreLinks = exploreMenu.querySelectorAll(".dropdown-link");
        exploreLinks[0].querySelector(".dropdown-link-title").textContent =
          t["explore-notice"];
        exploreLinks[0].querySelector(".dropdown-link-desc").textContent =
          t["explore-notice-desc"];
        exploreLinks[1].querySelector(".dropdown-link-title").textContent =
          t["explore-faq"];
        exploreLinks[1].querySelector(".dropdown-link-desc").textContent =
          t["explore-faq-desc"];
        exploreLinks[2].querySelector(".dropdown-link-title").textContent =
          t["explore-about"];
        exploreLinks[2].querySelector(".dropdown-link-desc").textContent =
          t["explore-about-desc"];

        // 드롭다운 메뉴 업데이트 - 봉사하기
        const volunteerMenu = document.querySelector(
          '[data-menu-content="volunteer"]'
        );
        const volunteerLinks = volunteerMenu.querySelectorAll(".dropdown-link");
        volunteerLinks[0].querySelector(".dropdown-link-title").textContent =
          t["volunteer-apply"];
        volunteerLinks[0].querySelector(".dropdown-link-desc").textContent =
          t["volunteer-apply-desc"];
        volunteerLinks[1].querySelector(".dropdown-link-title").textContent =
          t["volunteer-record"];
        volunteerLinks[1].querySelector(".dropdown-link-desc").textContent =
          t["volunteer-record-desc"];

        // 드롭다운 메뉴 업데이트 - 기부하기
        const donateMenu = document.querySelector(
          '[data-menu-content="donate"]'
        );
        const donateLinks = donateMenu.querySelectorAll(".dropdown-link");
        donateLinks[0].querySelector(".dropdown-link-title").textContent =
          t["donate-main"];
        donateLinks[0].querySelector(".dropdown-link-desc").textContent =
          t["donate-main-desc"];
        donateLinks[1].querySelector(".dropdown-link-title").textContent =
          t["donate-review"];
        donateLinks[1].querySelector(".dropdown-link-desc").textContent =
          t["donate-review-desc"];

        // 메인 콘텐츠 업데이트
        document.querySelector(".main-title").innerHTML = t["main-title"];
        document.querySelector(".main-subtitle").textContent =
          t["main-subtitle"];
        document.querySelector(".main-cta-btn").textContent = t["main-cta-btn"];

        // 기부하기 섹션 업데이트
        const donationTitle = document.querySelector(".donation-title");
        const donationSubtitle = document.querySelector(".donation-subtitle");
        if (donationTitle) donationTitle.textContent = t["donation-title"];
        if (donationSubtitle)
          donationSubtitle.textContent = t["donation-subtitle"];

        // 지구본 아이콘 툴팁 업데이트
        const globeIcon = document.querySelector(".navbar-icon:first-child");
        if (globeIcon) {
          globeIcon.title =
            currentLanguage === "ko" ? "Switch to English" : "한국어로 전환";
        }
      }

      document.addEventListener("DOMContentLoaded", () => {
        // --- 다국어 초기화 ---
        // 페이지 로드 시 저장된 언어 적용
        updatePageLanguage();

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

        // 지구본 아이콘 및 언어 드롭다운 이벤트 (5개 언어 지원)
        const globeIcon = document.getElementById("languageToggle");
        const languageDropdown = document.getElementById("languageDropdown");
        console.log("지구본 아이콘:", globeIcon);
        console.log("언어 드롭다운:", languageDropdown);

        if (globeIcon && languageDropdown) {
          console.log("지구본 아이콘과 드롭다운을 모두 찾았습니다.");

          // 지구본 아이콘 클릭 시 드롭다운 토글
          globeIcon.addEventListener("click", (e) => {
            e.preventDefault();
            e.stopPropagation();
            console.log("지구본 클릭됨! 드롭다운 토글");
            console.log(
              "현재 드롭다운 display 상태:",
              languageDropdown.style.display
            );

            const isVisible = languageDropdown.style.display === "block";

            if (isVisible) {
              // 드롭다운 숨기기
              languageDropdown.style.opacity = "0";
              languageDropdown.style.visibility = "hidden";
              languageDropdown.style.transform = "translateY(-10px)";
              setTimeout(() => {
                languageDropdown.style.display = "none";
              }, 200);
            } else {
              // 드롭다운 보이기
              languageDropdown.style.display = "block";
              setTimeout(() => {
                languageDropdown.style.opacity = "1";
                languageDropdown.style.visibility = "visible";
                languageDropdown.style.transform = "translateY(0)";
              }, 10);
            }

            console.log("드롭다운 상태 토글 완료");
          });

          // 언어 옵션 클릭 이벤트
          const languageOptions =
            languageDropdown.querySelectorAll(".language-option");
          languageOptions.forEach((option) => {
            option.addEventListener("click", (e) => {
              e.preventDefault();
              e.stopPropagation();
              const selectedLanguage = option.getAttribute("data-lang");
              console.log("선택된 언어:", selectedLanguage);

              // 언어 변경
              currentLanguage = selectedLanguage;
              localStorage.setItem("preferred-language", currentLanguage);
              updatePageLanguage();

              // 활성 언어 표시 업데이트
              updateActiveLanguage(selectedLanguage);

              // 드롭다운 닫기 (애니메이션 포함)
              languageDropdown.style.opacity = "0";
              languageDropdown.style.visibility = "hidden";
              languageDropdown.style.transform = "translateY(-10px)";
              setTimeout(() => {
                languageDropdown.style.display = "none";
              }, 200);
            });
          });

          // 다른 곳 클릭 시 드롭다운 닫기
          document.addEventListener("click", (e) => {
            if (
              !globeIcon.contains(e.target) &&
              !languageDropdown.contains(e.target)
            ) {
              if (languageDropdown.style.display === "block") {
                languageDropdown.style.opacity = "0";
                languageDropdown.style.visibility = "hidden";
                languageDropdown.style.transform = "translateY(-10px)";
                setTimeout(() => {
                  languageDropdown.style.display = "none";
                }, 200);
              }
            }
          });

          globeIcon.style.cursor = "pointer";
          globeIcon.title = "언어 선택 / Select Language";
          console.log("지구본 아이콘에 드롭다운 이벤트 리스너 추가 완료");

          // 초기 활성 언어 표시
          updateActiveLanguage(currentLanguage);
        } else {
          console.error("지구본 아이콘 또는 언어 드롭다운을 찾을 수 없습니다.");
          console.error("globeIcon:", globeIcon);
          console.error("languageDropdown:", languageDropdown);
        }

        // 활성 언어 표시 업데이트 함수
        function updateActiveLanguage(language) {
          const languageOptions = document.querySelectorAll(".language-option");
          languageOptions.forEach((option) => {
            if (option.getAttribute("data-lang") === language) {
              option.classList.add("active");
            } else {
              option.classList.remove("active");
            }
          });
        }

        // --- 네비바 드롭다운 메뉴 ---
        const header = document.getElementById("main-header");
        const navLinks = document.querySelectorAll(".nav-link[data-menu]");
        const megaMenuWrapper = document.getElementById("mega-menu-wrapper");
        const menuColumns = document.querySelectorAll(".menu-column");
        let menuTimeout;

        const showMenu = (targetMenu) => {
          clearTimeout(menuTimeout);
          megaMenuWrapper.classList.add("active");

          menuColumns.forEach((col) => {
            if (col.dataset.menuContent === targetMenu) {
              col.style.display = "flex";
            } else {
              col.style.display = "none";
            }
          });

          navLinks.forEach((link) => {
            if (link.dataset.menu === targetMenu) {
              link.classList.add("active");
            } else {
              link.classList.remove("active");
            }
          });
        };

        const hideMenu = () => {
          menuTimeout = setTimeout(() => {
            megaMenuWrapper.classList.remove("active");
            navLinks.forEach((link) => link.classList.remove("active"));
          }, 200);
        };

        navLinks.forEach((link) => {
          link.addEventListener("mouseenter", () => {
            showMenu(link.dataset.menu);
          });
        });

        header.addEventListener("mouseleave", () => {
          hideMenu();
        });
        // --- 네비바 로직 끝 ---

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
        window.goToDonation = function() {
          if (validateStep1()) {
            // 기부 금액 값 수집
            const amountInput = document.getElementById("amountInput");
            const selectedCategory = document.querySelector(".donation-category.selected");
            const donationType = document.querySelector(".donation-btn.active");

            const donationAmount = amountInput ? amountInput.value.replace(/,/g, '') : '';
            const category = selectedCategory ? selectedCategory.dataset.category : '';
            const type = donationType ? (donationType.id === 'regularBtn' ? 'regular' : 'onetime') : '';

            // 디버깅 로그
            console.log('Amount:', donationAmount, 'Category:', category, 'Type:', type);

            // URL 파라미터로 값 전달
            const params = new URLSearchParams();
            if (donationAmount) params.append('amount', donationAmount);
            if (category) params.append('category', category);
            if (type) params.append('type', type);

            const url = '/bdproject/project_Donation.jsp' + (params.toString() ? '?' + params.toString() : '');
            console.log('Generated URL:', url);
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

        // 인기 복지 혜택 로드
        loadPopularWelfareServices();
      });

      // 인기 복지 서비스 조회 함수
      function loadPopularWelfareServices() {
        console.log("인기 복지 서비스 로딩 시작");
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
            console.log(
              "데이터 타입:",
              typeof data,
              "배열 여부:",
              Array.isArray(data)
            );
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

      // 인기 복지 서비스 표시 함수
      function displayPopularWelfareServices(services) {
        const popularList = document.getElementById("popular-welfare-list");

        if (!services || services.length === 0) {
          popularList.innerHTML = `
                    <div class="loading-popular">
                        <p>표시할 복지 혜택이 없습니다.</p>
                    </div>
                `;
          return;
        }

        // 조회수 기준 정렬 후 상위 10개만 표시
        const sortedServices = services
          .sort((a, b) => {
            const aViews = parseInt(a.inqNum) || 0;
            const bViews = parseInt(b.inqNum) || 0;
            return bViews - aViews;
          })
          .slice(0, 10);

        // 슬라이더 컨테이너 생성
        const container = document.createElement("div");
        container.className = "popular-welfare-container";

        // 이전/다음 버튼 생성
        const prevBtn = document.createElement("button");
        prevBtn.className = "slider-nav-btn slider-prev";
        prevBtn.innerHTML = "‹";

        const nextBtn = document.createElement("button");
        nextBtn.className = "slider-nav-btn slider-next";
        nextBtn.innerHTML = "›";

        // 슬라이더 래퍼 생성
        const sliderWrapper = document.createElement("div");
        sliderWrapper.className = "welfare-slider-wrapper";

        // 슬라이더 생성
        const slider = document.createElement("div");
        slider.className = "welfare-slider";

        // 카드들 생성
        sortedServices.forEach((service, index) => {
          const rank = index + 1;
          const views = parseInt(service.inqNum) || 0;
          const isTop3 = rank <= 3;

          // JSP EL 충돌 방지를 위해 변수로 분리
          const rankClass = isTop3 ? "top-3" : "";
          const serviceName = service.servNm || "서비스명 없음";
          const jurMnofNm = service.jurMnofNm || "";
          const jurOrgNm = service.jurOrgNm || "";
          const sourceClass =
            service.source === "중앙부처" ? "source-central" : "source-local";
          const sourceText = service.source || "출처 불명";

          const item = document.createElement("div");
          item.className = "popular-welfare-item";
          item.innerHTML =
            '<div class="welfare-rank ' +
            rankClass +
            '">' +
            rank +
            "</div>" +
            '<div class="welfare-info">' +
            '<div class="welfare-name">' +
            serviceName +
            "</div>" +
            '<div class="welfare-org">' +
            jurMnofNm +
            " " +
            jurOrgNm +
            "</div>" +
            '<div class="welfare-views">조회수: ' +
            views.toLocaleString() +
            "회</div>" +
            '<span class="welfare-source ' +
            sourceClass +
            '">' +
            sourceText +
            "</span>" +
            "</div>";

          // 클릭 시 상세 정보 표시
          item.addEventListener("click", () => {
            if (service.servDtlLink) {
              window.open(service.servDtlLink, "_blank");
            } else {
              alert("해당 서비스의 상세 정보가 없습니다.");
            }
          });

          slider.appendChild(item);
        });

        // 슬라이더 변수
        let currentSlide = 0;
        const itemsPerSlide = 3;
        const totalSlides = Math.max(
          0,
          Math.ceil(sortedServices.length - itemsPerSlide + 1)
        );

        // 슬라이더 이동 함수
        function moveSlider(direction) {
          if (direction === "next" && currentSlide < totalSlides - 1) {
            currentSlide++;
          } else if (direction === "prev" && currentSlide > 0) {
            currentSlide--;
          }

          const translateX = currentSlide * (100 / itemsPerSlide);
          slider.style.transform = "translateX(-" + translateX + "%)";

          // 버튼 상태 업데이트
          prevBtn.disabled = currentSlide === 0;
          nextBtn.disabled = currentSlide >= totalSlides - 1;
        }

        // 버튼 이벤트 리스너
        prevBtn.addEventListener("click", () => moveSlider("prev"));
        nextBtn.addEventListener("click", () => moveSlider("next"));

        // 초기 버튼 상태 설정
        moveSlider();

        // DOM에 추가
        sliderWrapper.appendChild(slider);
        container.appendChild(prevBtn);
        container.appendChild(nextBtn);
        container.appendChild(sliderWrapper);

        popularList.innerHTML = "";
        popularList.appendChild(container);
      }

      // 사용자 아이콘 클릭 이벤트
      document.addEventListener("DOMContentLoaded", function () {
        // 사용자 아이콘 클릭 시 projectLogin.jsp로 이동
        const userIcon = document.getElementById("userIcon");
        if (userIcon) {
          userIcon.addEventListener("click", function (e) {
            e.preventDefault();
            window.location.href = "/bdproject/projectLogin.jsp";
          });
        }
      });
    </script>
  </body>
</html>
