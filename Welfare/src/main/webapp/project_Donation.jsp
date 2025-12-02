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
    <style>
      html,
      body {
        width: 100%;
        margin: 0;
        padding: 0;
        min-height: 100vh;
        background-color: #fafafa;
        overflow-x: hidden;
      }
      * {
        box-sizing: border-box;
      }
      body {
        color: #191918;
        font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto,
          sans-serif;
      }

      /* 네비바 고정 스타일 */
      #main-header {
        position: sticky !important;
        top: 0 !important;
        z-index: 1000 !important;
        background-color: white !important;
        box-shadow: 0 2px 4px rgba(0,0,0,0.05) !important;
      }

      .navbar {
        background-color: transparent;
        padding: 0 40px;
        display: flex;
        align-items: center;
        justify-content: space-between;
        height: 60px;
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

      .nav-link {
        color: #333;
        text-decoration: none;
        font-size: 15px;
        font-weight: 600;
        transition: all 0.2s ease;
        padding: 18px 15px;
        border-radius: 8px;
      }
      .nav-link:hover,
      .nav-link.active {
        background-color: #f5f5f5;
        color: #333;
      }

      #mega-menu-wrapper {
        position: absolute;
        width: 100%;
        background-color: white;
        color: #333;
        left: 0;
        top: 60px;
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
        max-width: 1000px;
        margin: 0 auto;
        padding: 0 40px;
        display: flex;
        justify-content: flex-start;
        gap: 60px;
      }

      .menu-column {
        display: none;
        flex-direction: column;
        gap: 25px;
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
        width: 100%;
      }
      .dropdown-link-desc {
        font-size: 13px;
        color: #555;
        margin-top: 6px;
        display: block;
      }

      @media (max-width: 768px) {
        .nav-menu {
          display: none;
        }
        .navbar {
          padding: 0 15px;
        }
      }

      /* Donation Form Styles */
      .donation-step {
        display: flex;
        width: 100%;
        transition: transform 0.5s ease-in-out, opacity 0.5s ease-in-out;
      }
      #donation-step1 {
        gap: 30px;
        max-width: 1400px;
        margin: 10px auto 40px;
        padding: 20px 20px 40px;
        flex-wrap: wrap;
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
      .donation-form {
        display: flex;
        flex-direction: column;
        gap: 20px;
      }
      .donation-buttons {
        display: flex;
        gap: 10px;
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
        cursor: pointer;
        transition: all 0.3s ease;
        border: 2px solid transparent;
      }
      .donation-category:hover {
        background: #e3f2fd;
        border-color: #4a90e2;
      }
      .donation-category.active {
        background: #e3f2fd;
        border-color: #4a90e2;
        box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
        transform: translateY(-2px);
      }
      .category-icon {
        margin-right: 15px;
        flex-shrink: 0;
      }
      .category-content {
        flex: 1;
      }
      .category-title {
        font-size: 16px;
        font-weight: 600;
        color: #333;
        margin-bottom: 5px;
      }
      .category-desc {
        font-size: 13px;
        color: #666;
        line-height: 1.4;
      }
      .donation-methods-title {
        font-size: 20px;
        font-weight: 600;
        color: #333;
        margin-bottom: 25px;
        display: flex;
        align-items: center;
        justify-content: space-between;
      }
      .next-btn-container {
        display: flex;
        justify-content: flex-end;
        margin-top: 30px;
      }
      .next-btn {
        background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
        color: white;
        border: none;
        padding: 15px 40px;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
      }
      .next-btn:hover {
        transform: translateY(-2px);
        box-shadow: 0 8px 20px rgba(74, 144, 226, 0.3);
      }

      #donation-container {
        position: relative;
        width: 100%;
        max-width: 1400px;
        overflow: visible;
        min-height: 1200px;
        background-color: #fafafa;
        color: #191918;
        margin: 10px auto 40px auto;
        padding: 0 20px 100px 20px;
      }

      #donation-step1 {
        display: flex;
        gap: 30px;
        transition: all 0.5s ease-in-out;
      }

      #donation-step2,
      #donation-step3 {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        opacity: 0;
        visibility: hidden;
        transform: translateX(100%);
        transition: all 0.5s ease-in-out;
      }

      #donation-container.view-step2 #donation-step1,
      #donation-container.view-step3 #donation-step1 {
        opacity: 0;
        visibility: hidden;
        transform: translateX(-100%);
      }

      /* 히어로 섹션 */
      .hero-section {
        background: #f8f9fa;
        color: #333;
        padding: 60px 20px 0;
        text-align: left;
        margin-bottom: 0;
      }

      .hero-title {
        font-size: 48px;
        font-weight: 700;
        margin-bottom: 15px;
        max-width: 1400px;
        margin-left: auto;
        margin-right: auto;
        padding: 0 40px;
      }

      .hero-title .highlight {
        color: #4a90e2;
      }

      .hero-subtitle {
        font-size: 18px;
        max-width: 1400px;
        margin-left: auto;
        margin-right: auto;
        padding: 0 40px;
        line-height: 1.6;
        color: #495057;
      }

      /* 단계 표시기 기본 스타일 */
      .step-indicator {
        opacity: 1;
        visibility: visible;
        transform: none;
        position: relative;
        z-index: 500;
        display: flex;
        align-items: center;
        gap: 10px;
      }

      #donation-container.view-step2 #donation-step2,
      #donation-container.view-step3 #donation-step3 {
        opacity: 1;
        visibility: visible;
        transform: translateX(0);
      }

      #donation-container.view-step3 #donation-step2 {
        opacity: 0;
        visibility: hidden;
        transform: translateX(-100%);
      }

      .donation-step {
        display: flex;
        width: 100%;
        gap: 30px;
        transition: transform 0.5s ease-in-out, opacity 0.5s ease-in-out;
      }

      .sponsor-info-box,
      .payment-info-box {
        width: 100%;
        background: white;
        border-radius: 20px;
        padding: 40px;
        padding-bottom: 20px;
        min-height: auto;
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
      }

      .donation-title {
        font-size: 28px;
        font-weight: 600;
        color: #333;
        margin-bottom: 15px;
      }

      .sponsor-form {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 25px 40px;
        margin-top: 30px;
        align-items: start;
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

      .email-group {
        display: flex;
        align-items: center;
        gap: 10px;
        flex-wrap: nowrap;
      }

      .email-group #emailUser {
        flex: 1 1 50%;
      }

      .email-group #emailDomain {
        flex: 1 1 50%;
      }

      .email-group #emailDomainSelect {
        flex: 0 0 160px;
      }

      .email-at {
        font-size: 16px;
        color: #888;
      }

      .address-row {
        display: flex;
        gap: 10px;
        margin-bottom: 10px;
      }

      .address-row .address-group {
        flex: 1;
        margin-bottom: 0;
      }

      .address-row #address {
        flex: 2;
        margin-bottom: 0;
      }

      .address-group {
        display: flex;
        align-items: center;
        gap: 10px;
      }

      .address-group .form-input {
        flex: 1;
      }

      #searchAddressBtn {
        background: #4a90e2;
        color: white;
        border: none;
        padding: 15px 25px;
        border-radius: 8px;
        font-size: 15px;
        font-weight: 500;
        cursor: pointer;
        transition: background 0.3s ease;
      }

      /* 서명패드 스타일 */
      .signature-pad-container {
        margin-top: 15px;
      }

      #signatureCanvas {
        border: 2px solid #ddd;
        border-radius: 8px;
        cursor: crosshair;
        background: white;
        display: block;
        width: 100%;
        max-width: 500px;
      }

      .signature-buttons {
        display: flex;
        gap: 10px;
        margin-top: 10px;
      }

      .signature-clear-btn {
        background: #e74c3c;
        color: white;
        border: none;
        padding: 10px 20px;
        border-radius: 6px;
        font-size: 14px;
        font-weight: 500;
        cursor: pointer;
        transition: background 0.3s ease;
      }

      .signature-clear-btn:hover {
        background: #c0392b;
      }

      .custom-radio-group {
        display: flex;
        gap: 20px;
        align-items: center;
        flex-wrap: wrap;
      }

      .custom-radio-group div {
        display: flex;
        align-items: center;
        gap: 8px;
      }

      .custom-radio-group input[type="radio"] {
        margin: 0;
      }

      .custom-radio-group label {
        font-size: 15px;
        color: #333;
        cursor: pointer;
        margin: 0;
      }

      .form-navigation-btns {
        display: flex;
        justify-content: space-between;
        gap: 20px;
        margin-top: 40px;
        margin-bottom: 20px;
      }

      .back-btn {
        background: #6c757d;
        color: white;
        border: none;
        padding: 12px 30px;
        border-radius: 8px;
        font-size: 15px;
        font-weight: 500;
        cursor: pointer;
        transition: background 0.3s ease;
      }

      .back-btn:hover {
        background: #5a6268;
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

      /* Payment Method Styles */
      .payment-method-group {
        display: flex;
        width: 75%;
        margin: 0 auto 30px auto;
      }

      .payment-method-btn {
        flex: 1;
        padding: 15px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        border: 1px solid #4a90e2;
        background-color: white;
        color: #4a90e2;
        transition: all 0.3s ease;
        border-right-width: 0;
      }

      .payment-method-btn:first-child {
        border-radius: 8px 0 0 8px;
      }

      .payment-method-btn:last-child {
        border-radius: 0 8px 8px 0;
        border-right-width: 1px;
      }

      .payment-method-btn.active,
      .payment-method-btn:hover {
        background-color: #4a90e2;
        color: white;
      }

      .payment-details-form {
        margin-top: 30px;
      }

      .payment-details-form.hidden {
        display: none;
      }

      .payment-form-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 25px 40px;
      }

      .grid-col-span-2 {
        grid-column: span 2;
      }

      .input-group {
        display: flex;
        align-items: center;
        gap: 10px;
      }

      .input-group .form-input {
        text-align: center;
      }

      .input-group span {
        color: #888;
        font-size: 16px;
      }

      /* Agreement Section */
      .agreement-section {
        margin-top: 30px;
        padding: 20px;
        background: #f8f9fa;
        border-radius: 10px;
      }

      .agreement-item {
        display: flex;
        align-items: center;
        justify-content: space-between;
        margin-bottom: 12px;
        font-size: 14px;
      }

      .agreement-item label {
        display: flex;
        align-items: center;
        cursor: pointer;
        margin: 0;
        flex-grow: 1;
      }

      .agreement-item input[type="checkbox"] {
        margin-right: 10px;
      }

      .agreement-item a {
        margin-left: 8px;
        color: #888;
        text-decoration: underline;
        font-size: 14px;
        cursor: pointer;
      }

      .agreement-item.all-agree {
        font-weight: 600;
      }

      .step {
        display: flex;
        align-items: center;
        gap: 6px;
      }

      .step-number {
        width: 24px;
        height: 24px;
        border-radius: 50%;
        background: #ddd;
        color: #666;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 600;
        font-size: 12px;
      }

      .step-number.active {
        background: #4a90e2;
        color: white;
      }

      .step-text {
        font-size: 13px;
        color: #666;
        white-space: nowrap;
      }

      .step-text.active {
        color: #333;
        font-weight: 600;
      }

      .step-connector {
        width: 20px;
        height: 2px;
        background: #ddd;
      }

      @media (max-width: 1024px) {
        .sponsor-form,
        .payment-form-grid {
          grid-template-columns: 1fr;
        }
        .grid-col-span-2 {
          grid-column: span 1;
        }
      }

      @media (max-width: 1200px) {
        #donation-step1 {
          flex-direction: column;
        }
        .donation-categories {
          grid-template-columns: repeat(2, 1fr);
        }
      }

      @media (max-width: 768px) {
        .donation-title {
          font-size: 24px;
        }
        .custom-radio-group {
          flex-direction: column;
          align-items: flex-start;
          gap: 15px;
        }
        .email-group {
          flex-wrap: wrap;
        }
        .email-group #emailUser,
        .email-group #emailDomain {
          flex-basis: 45%;
        }
        .email-group #emailDomainSelect {
          flex-basis: 100%;
          margin-top: 10px;
        }
        .donation-categories {
          grid-template-columns: 1fr;
        }
      }

      /* Modal styles */
      .modal-overlay {
        position: fixed;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0, 0, 0, 0.6);
        z-index: 2000;
        display: none;
        align-items: center;
        justify-content: center;
      }
      .modal-overlay.active {
        display: flex;
      }
      .modal-content {
        background: white;
        padding: 40px;
        border-radius: 12px;
        width: 90%;
        max-width: 600px;
        max-height: 80vh;
        overflow-y: auto;
        position: relative;
      }
      .modal-title {
        font-size: 20px;
        font-weight: 600;
        margin-bottom: 20px;
      }
      .modal-body {
        font-size: 14px;
        line-height: 1.7;
      }
      .modal-body h4 {
        margin-top: 20px;
        margin-bottom: 10px;
        font-weight: 600;
      }
      .modal-close-btn {
        position: absolute;
        top: 15px;
        right: 20px;
        background: none;
        border: none;
        font-size: 24px;
        cursor: pointer;
        color: #666;
      }

      /* Signature pad styles */
      .signature-pad {
        border: 1px solid #ccc;
        border-radius: 8px;
        cursor: crosshair;
      }
      .signature-container {
        position: relative;
        display: inline-block;
      }
      .clear-signature-btn {
        position: absolute;
        top: 5px;
        right: 5px;
        width: 28px;
        height: 28px;
        border: none;
        background: rgba(255, 255, 255, 0.9);
        border-radius: 50%;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
        box-shadow: 0 2px 4px rgba(0, 0, 0, 0.1);
        transition: all 0.2s ease;
        z-index: 100;
      }
      .clear-signature-btn:hover {
        background: rgba(255, 255, 255, 1);
        box-shadow: 0 2px 8px rgba(0, 0, 0, 0.15);
        transform: scale(1.05);
      }
      .clear-signature-btn::before {
        content: "↻";
        font-size: 16px;
        color: #666;
        font-weight: bold;
      }
      .signature-pad-wrapper {
        margin-top: 40px;
      }
      .signature-pad-wrapper .form-label {
        margin-bottom: 0;
      }
      .signature-container .form-label {
        position: absolute;
        top: -25px;
        left: 0;
        font-size: 16px;
        font-weight: 600;
      }

      /* Gift Package Box Styles */
      .gift-package-box {
        flex-basis: 100%;
        width: 100%;
        background: white;
        border-radius: 20px;
        padding: 10px 20px 30px;
        box-shadow: 0 6px 20px rgba(0, 0, 0, 0.12);
      }

      /* Gift Package Section Styles */
      .gift-package-section {
        margin: 0;
      }

      .gift-package-title {
        font-size: 26px;
        font-weight: 700;
        color: #333;
        text-align: center;
        margin-bottom: 10px;
      }

      .gift-package-subtitle {
        font-size: 15px;
        color: #666;
        text-align: center;
        margin-bottom: 25px;
        line-height: 1.6;
      }

      .gift-cards-container {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 20px;
        margin-bottom: 0;
      }

      .gift-card {
        background: white;
        border-radius: 16px;
        padding: 25px 20px;
        box-shadow: 0 4px 15px rgba(0, 0, 0, 0.1);
        transition: all 0.3s ease;
        display: flex;
        flex-direction: column;
        border: 3px solid transparent;
      }

      .gift-card:hover {
        transform: translateY(-8px);
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.15);
      }

      .gift-card.blue {
        border-color: #4fc3f7;
        background: linear-gradient(to bottom, #e3f2fd 0%, white 40%);
      }

      .gift-card.green {
        border-color: #aed581;
        background: linear-gradient(to bottom, #f1f8e9 0%, white 40%);
      }

      .gift-card.orange {
        border-color: #ff9800;
        background: linear-gradient(to bottom, #fff3e0 0%, white 40%);
      }

      .gift-card-icon {
        text-align: center;
        margin-bottom: 15px;
        padding: 20px;
        border-radius: 12px;
      }

      .gift-card.blue .gift-card-icon {
        background: #4fc3f7;
      }

      .gift-card.green .gift-card-icon {
        background: #cddc39;
      }

      .gift-card.orange .gift-card-icon {
        background: #ff9800;
      }

      .gift-card-icon img {
        width: 80px;
        height: 80px;
        object-fit: contain;
      }

      .gift-card-name {
        font-size: 20px;
        font-weight: 700;
        color: #333;
        text-align: center;
        margin-bottom: 10px;
      }

      .gift-card-price {
        font-size: 24px;
        font-weight: 800;
        text-align: center;
        margin-bottom: 15px;
      }

      .gift-card.blue .gift-card-price {
        color: #1976d2;
      }

      .gift-card.green .gift-card-price {
        color: #689f38;
      }

      .gift-card.orange .gift-card-price {
        color: #e65100;
      }

      .gift-card-items {
        flex: 1;
        list-style: none;
        padding: 0;
        margin: 0 0 15px 0;
      }

      .gift-card-items li {
        padding: 6px 0;
        font-size: 14px;
        color: #555;
        border-bottom: 1px solid #f0f0f0;
        position: relative;
        padding-left: 20px;
      }

      .gift-card-items li:last-child {
        border-bottom: none;
      }

      .gift-card-items li:before {
        content: "✓";
        position: absolute;
        left: 0;
        color: #4caf50;
        font-weight: bold;
        font-size: 16px;
      }

      .gift-card-button {
        background: linear-gradient(135deg, #4a90e2 0%, #357abd 100%);
        color: white;
        border: none;
        padding: 14px 20px;
        border-radius: 8px;
        font-size: 16px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        width: 100%;
      }

      .gift-card-button:hover {
        transform: translateY(-2px);
        box-shadow: 0 6px 20px rgba(74, 144, 226, 0.4);
      }

      @media (max-width: 1024px) {
        .gift-cards-container {
          grid-template-columns: repeat(2, 1fr);
        }
      }

      @media (max-width: 768px) {
        .gift-cards-container {
          grid-template-columns: 1fr;
        }

        .gift-package-title {
          font-size: 22px;
        }
      }

      .donation-flow-box {
        width: 100%;
        background: #ffffff;
        border-radius: 20px;
        padding: 15px 30px 35px 30px;
        margin-top: 50px;
        box-shadow: 0 2px 10px rgba(0, 0, 0, 0.05);
      }

      .donation-flow-title {
        font-size: 28px;
        font-weight: 700;
        text-align: center;
        margin-bottom: 10px;
        color: #333;
      }

      .donation-flow-subtitle {
        font-size: 15px;
        text-align: center;
        margin-bottom: 35px;
        color: #666;
        line-height: 1.6;
      }

      .flow-timeline {
        display: flex;
        align-items: center;
        justify-content: center;
        margin-bottom: 35px;
        gap: 25px;
      }

      .flow-step {
        text-align: center;
        flex: 0 0 auto;
      }

      .flow-icon {
        width: 120px;
        height: 120px;
        background: #4a90e2;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 20px;
        transition: all 0.3s ease;
      }

      .flow-step:hover .flow-icon {
        transform: scale(1.05);
        box-shadow: 0 8px 20px rgba(74, 144, 226, 0.3);
      }

      .flow-icon i {
        font-size: 48px;
        color: white;
      }

      .flow-step-title {
        font-size: 18px;
        font-weight: 700;
        margin-bottom: 10px;
        color: #4a90e2;
      }

      .flow-step-desc {
        font-size: 13px;
        line-height: 1.6;
        color: #666;
        max-width: 200px;
        margin: 0 auto;
      }

      .flow-arrow {
        font-size: 28px;
        color: #ccc;
        flex-shrink: 0;
        margin: 0 10px;
      }

      .transparency-note {
        background: #f8f9fa;
        border-radius: 15px;
        padding: 30px;
        border: 1px solid #e9ecef;
      }

      .transparency-content {
        text-align: center;
      }

      .transparency-content h4 {
        font-size: 22px;
        font-weight: 700;
        margin-bottom: 12px;
        color: #333;
      }

      .transparency-content p {
        font-size: 14px;
        line-height: 1.8;
        color: #666;
        margin-bottom: 25px;
        max-width: 800px;
        margin-left: auto;
        margin-right: auto;
      }

      .transparency-stats {
        display: flex;
        gap: 40px;
        justify-content: center;
      }

      .stat-item {
        text-align: center;
      }

      .stat-number {
        font-size: 32px;
        font-weight: 700;
        color: #4a90e2;
        margin-bottom: 8px;
      }

      .stat-label {
        font-size: 14px;
        color: #666;
      }

      @media (max-width: 1024px) {
        .flow-timeline {
          gap: 20px;
        }

        .flow-icon {
          width: 100px;
          height: 100px;
        }

        .flow-icon i {
          font-size: 40px;
        }

        .flow-arrow {
          font-size: 24px;
        }
      }

      @media (max-width: 768px) {
        .donation-flow-box {
          padding: 40px 25px;
        }

        .donation-flow-title {
          font-size: 22px;
        }

        .flow-timeline {
          flex-direction: column;
          gap: 30px;
        }

        .flow-arrow {
          transform: rotate(90deg);
          margin: 10px 0;
        }

        .flow-icon {
          width: 90px;
          height: 90px;
        }

        .flow-icon i {
          font-size: 36px;
        }

        .transparency-note {
          padding: 30px 20px;
        }

        .transparency-stats {
          flex-direction: column;
          gap: 25px;
        }
      }

 
    </style>
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

    <script>
      // 세션에서 사용자 이름 가져오기
      const currentUsername = '<%= username %>';

      // URL 파라미터로 전달받은 기부 정보
      const donationParams = {
        amount: '<%= donationAmount != null ? donationAmount : "" %>',
        category: '<%= donationCategory != null ? donationCategory : "" %>',
        type: '<%= donationType != null ? donationType : "" %>',
        skipFirstStep: <%= skipFirstStep %>
      };

      // 파라미터가 있으면 강제로 단계 2를 활성화
      if (donationParams.skipFirstStep) {
        console.log('Forcing step 2 activation');
        setTimeout(() => {
          const step1Number = document.getElementById('step1Number');
          const step1Text = document.getElementById('step1Text');
          const step2Number = document.getElementById('step2Number');
          const step2Text = document.getElementById('step2Text');

          if (step1Number) step1Number.classList.remove('active');
          if (step1Text) step1Text.classList.remove('active');
          if (step2Number) step2Number.classList.add('active');
          if (step2Text) step2Text.classList.add('active');
        }, 100);
      }

      // 네비바 드롭다운 메뉴
      document.addEventListener("DOMContentLoaded", function() {
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

        // Prevent dropdown links from being blocked
        document.querySelectorAll('.dropdown-link').forEach(link => {
          link.addEventListener('click', function(e) {
            // Allow normal link navigation
            if (this.href && this.href !== '#') {
              window.location.href = this.href;
            }
          });
        });
      });

      // 언어 드롭다운 관련 JavaScript
      const languageToggle = document.getElementById("languageToggle");
      const languageDropdown = document.getElementById("languageDropdown");
      let currentLanguage = "ko";

      // null 체크 추가
      if (languageToggle && languageDropdown) {
        languageToggle.addEventListener("click", function(e) {
          e.preventDefault();
          languageDropdown.classList.toggle("active");
        });

        // 언어 선택
        document.querySelectorAll(".language-option").forEach(option => {
          option.addEventListener("click", function(e) {
            e.preventDefault();

            // 기존 active 클래스 제거
            document.querySelectorAll(".language-option").forEach(opt => {
              opt.classList.remove("active");
            });

            // 새로운 active 클래스 추가
            this.classList.add("active");

            // 현재 언어 업데이트
            currentLanguage = this.getAttribute("data-lang");

            // 드롭다운 닫기
            languageDropdown.classList.remove("active");

            updateLanguage();
          });
        });

        // 외부 클릭시 드롭다운 닫기
        document.addEventListener("click", function(e) {
          if (!languageToggle.contains(e.target) && !languageDropdown.contains(e.target)) {
            languageDropdown.classList.remove("active");
          }
        });
      }

      function updateLanguage() {
        // 지구본 아이콘 툴팁 업데이트
        const globeIcon = document.querySelector(".navbar-icon:first-child");
        if (globeIcon) {
          globeIcon.title =
            currentLanguage === "ko" ? "Switch to English" : "한국어로 전환";
        }
      }

      // Gift Package Selection Function
      let selectedPackageName = null; // 전역 변수로 패키지명 저장

      function selectGiftPackage(packageName, amount) {
        // 패키지명 저장
        selectedPackageName = packageName;

        // 금액 설정
        const amountInput = document.getElementById('amountInput');
        if (amountInput) {
          amountInput.value = amount.toLocaleString();
          amountInput.readOnly = true;
          amountInput.style.backgroundColor = '#f8f9fa';
        }

        // 금액 드롭다운 초기화
        const donationAmountSelect = document.getElementById('donationAmount');
        if (donationAmountSelect) {
          donationAmountSelect.value = '';
        }

        // 일시기부 버튼 활성화
        const onetimeBtn = document.getElementById('onetimeBtn');
        const regularBtn = document.getElementById('regularBtn');
        if (onetimeBtn && regularBtn) {
          onetimeBtn.classList.add('active');
          regularBtn.classList.remove('active');
        }

        // 알림 표시
        alert(packageName + ' 패키지를 선택하셨습니다. 후원자 정보를 입력해주세요.');

        // 후원자 정보 입력 단계로 자동 이동
        const donationContainer = document.getElementById('donation-container');
        if (donationContainer) {
          donationContainer.classList.add('view-step2');

          // 모든 단계 표시기 업데이트 (모든 step indicator 인스턴스)
          document.querySelectorAll('.step-number, .step-text').forEach(element => {
            element.classList.remove('active');
          });

          // Step 2의 모든 인스턴스에 active 클래스 추가
          ['step2Number', 'step2Number2', 'step2Number3'].forEach(id => {
            const el = document.getElementById(id);
            if (el) el.classList.add('active');
          });
          ['step2Text', 'step2Text2', 'step2Text3'].forEach(id => {
            const el = document.getElementById(id);
            if (el) el.classList.add('active');
          });
        }

        // 페이지 상단으로 스크롤
        window.scrollTo({ top: 0, behavior: 'smooth' });
      }

      // Main JavaScript functionality
      document.addEventListener("DOMContentLoaded", function() {
        // 회원 정보 로드 (마이페이지 주소 자동 입력)
        loadMemberInfoForDonation();

        function loadMemberInfoForDonation() {
          fetch('/bdproject/api/auth/check')
            .then(response => response.json())
            .then(data => {
              if (data.loggedIn) {
                // 로그인 상태라면 회원 정보 로드
                fetch('/bdproject/api/member/info')
                  .then(response => response.json())
                  .then(result => {
                    if (result.success && result.data) {
                      const memberData = result.data;
                      console.log('기부 페이지 - 회원 정보 로드:', memberData);

                      // 이름
                      const nameInput = document.getElementById('sponsorName');
                      if (nameInput && memberData.name) {
                        nameInput.value = memberData.name;
                      }
                      // 전화번호
                      const phoneInput = document.getElementById('sponsorPhone');
                      if (phoneInput && memberData.phone) {
                        phoneInput.value = memberData.phone;
                      }
                      // 생년월일 (YYYY-MM-DD 형식을 YYYYMMDD로 변환)
                      const dobInput = document.getElementById('sponsorDob');
                      if (dobInput && memberData.birth) {
                        const birthDate = memberData.birth.replace(/-/g, '');
                        dobInput.value = birthDate;
                      }
                      // 이메일 분리하여 입력
                      if (memberData.email) {
                        const emailParts = memberData.email.split('@');
                        if (emailParts.length === 2) {
                          const emailUserInput = document.getElementById('emailUser');
                          const emailDomainInput = document.getElementById('emailDomain');
                          if (emailUserInput) emailUserInput.value = emailParts[0];
                          if (emailDomainInput) emailDomainInput.value = emailParts[1];
                        }
                      }
                      // 주소 정보
                      const postcodeInput = document.getElementById('postcode');
                      if (postcodeInput && memberData.postcode) {
                        postcodeInput.value = memberData.postcode;
                      }
                      const addressInput = document.getElementById('address');
                      if (addressInput && memberData.address) {
                        addressInput.value = memberData.address;
                      }
                      const detailAddressInput = document.getElementById('detailAddress');
                      if (detailAddressInput && memberData.detailAddress) {
                        detailAddressInput.value = memberData.detailAddress;
                      }
                    }
                  })
                  .catch(error => {
                    console.error('회원 정보 로드 실패:', error);
                  });
              }
            })
            .catch(error => {
              console.error('로그인 상태 확인 실패:', error);
            });
        }

        // Step indicator update function
        function updateStepIndicator(currentStep) {
          // 모든 단계 표시기의 active 클래스 제거
          document.querySelectorAll('.step-number, .step-text').forEach(element => {
            element.classList.remove('active');
          });

          // Step 1의 모든 인스턴스 업데이트
          const step1Numbers = ['step1Number', 'step1Number2', 'step1Number3'];
          const step1Texts = ['step1Text', 'step1Text2', 'step1Text3'];

          if (currentStep === 1) {
            step1Numbers.forEach(id => {
              const element = document.getElementById(id);
              if (element) element.classList.add('active');
            });
            step1Texts.forEach(id => {
              const element = document.getElementById(id);
              if (element) element.classList.add('active');
            });
          }

          // Step 2의 모든 인스턴스 업데이트
          const step2Numbers = ['step2Number', 'step2Number2', 'step2Number3'];
          const step2Texts = ['step2Text', 'step2Text2', 'step2Text3'];

          if (currentStep === 2) {
            step2Numbers.forEach(id => {
              const element = document.getElementById(id);
              if (element) element.classList.add('active');
            });
            step2Texts.forEach(id => {
              const element = document.getElementById(id);
              if (element) element.classList.add('active');
            });
          }

          // Step 3의 모든 인스턴스 업데이트
          const step3Numbers = ['step3Number', 'step3Number2', 'step3Number3'];
          const step3Texts = ['step3Text', 'step3Text2', 'step3Text3'];

          if (currentStep === 3) {
            step3Numbers.forEach(id => {
              const element = document.getElementById(id);
              if (element) element.classList.add('active');
            });
            step3Texts.forEach(id => {
              const element = document.getElementById(id);
              if (element) element.classList.add('active');
            });
          }
        }

        // 사용자 활동 로그 저장 함수
        function logUserActivity(activity) {
          try {
            const userId = '<%= session.getAttribute("id") != null ? session.getAttribute("id") : "guest" %>';
            const activityLog = JSON.parse(localStorage.getItem('userActivityLog_' + userId) || '[]');

            activityLog.unshift(activity);

            if (activityLog.length > 100) {
              activityLog.splice(100);
            }

            localStorage.setItem('userActivityLog_' + userId, JSON.stringify(activityLog));
          } catch (error) {
            console.error('활동 로그 저장 오류:', error);
          }
        }

        // 정기기부/일시기부 버튼 기능
        const regularBtn = document.getElementById('regularBtn');
        const onetimeBtn = document.getElementById('onetimeBtn');
        const regularStartDateContainer = document.getElementById('regularStartDateContainer');

        if (regularBtn) {
          regularBtn.addEventListener('click', function() {
            regularBtn.classList.add('active');
            onetimeBtn.classList.remove('active');
            // 정기 기부 시작일 폼 표시
            if (regularStartDateContainer) {
              regularStartDateContainer.style.display = 'block';

              // 오늘 이후 날짜만 선택 가능하도록 설정
              const regularStartDateInput = document.getElementById('regularStartDateInput');
              if (regularStartDateInput) {
                const today = new Date();
                const year = today.getFullYear();
                const month = String(today.getMonth() + 1).padStart(2, '0');
                const day = String(today.getDate()).padStart(2, '0');
                const todayStr = year + '-' + month + '-' + day;
                regularStartDateInput.setAttribute('min', todayStr);
              }
            }
          });
        }

        if (onetimeBtn) {
          onetimeBtn.addEventListener('click', function() {
            onetimeBtn.classList.add('active');
            regularBtn.classList.remove('active');
            // 정기 기부 시작일 폼 숨김
            if (regularStartDateContainer) {
              regularStartDateContainer.style.display = 'none';
            }
          });
        }

        // 기부금액 드롭다운 선택 이벤트
        const donationAmountSelect = document.getElementById('donationAmount');
        const amountInput = document.getElementById('amountInput');

        if (donationAmountSelect && amountInput) {
          donationAmountSelect.addEventListener('change', function() {
            const selectedValue = this.value;
            if (selectedValue) {
              // 선택된 금액을 입력 필드에 설정 (쉼표 추가)
              amountInput.value = Number(selectedValue).toLocaleString();
              amountInput.readOnly = true;
              amountInput.style.backgroundColor = '#f8f9fa';
            } else {
              // 직접입력 선택 시 입력 필드 초기화
              amountInput.value = '';
              amountInput.readOnly = false;
              amountInput.style.backgroundColor = '';
              amountInput.focus();
            }
          });
        }

        // 기부 참여 분야 클릭 이벤트
        const donationCategories = document.querySelectorAll('.donation-category');
        donationCategories.forEach(category => {
          category.addEventListener('click', function() {
            donationCategories.forEach(cat => cat.classList.remove('active'));
            this.classList.add('active');
          });
        });

        // 단계 전환 기능
        const nextBtn = document.getElementById('nextBtn');
        const donationContainer = document.getElementById('donation-container');

        if (nextBtn && donationContainer) {
          nextBtn.addEventListener('click', function() {
            donationContainer.classList.add('view-step2');
            updateStepIndicator(2);
          });
        }

        // ===== 숫자만 입력 가능하도록 설정 =====
        function numbersOnly(input) {
          input.value = input.value.replace(/[^0-9]/g, '');
        }

        // ===== 문자만 입력 가능하도록 설정 (이름 필드용) =====
        function lettersOnly(input) {
          // 한글, 영문, 공백만 허용
          input.value = input.value.replace(/[^가-힣a-zA-Z\s]/g, '');
        }

        // 이름 필드 - 문자만 입력 (숫자 불가)
        // 한글 조합 문제 해결을 위해 compositionend 이벤트도 처리
        const sponsorNameInput = document.getElementById('sponsorName');
        if (sponsorNameInput) {
          let isComposing = false;

          sponsorNameInput.addEventListener('compositionstart', function() {
            isComposing = true;
          });

          sponsorNameInput.addEventListener('compositionend', function() {
            isComposing = false;
            lettersOnly(this);
          });

          sponsorNameInput.addEventListener('input', function() {
            if (!isComposing) {
              lettersOnly(this);
            }
          });
        }

        // 전화번호 필드 - 숫자만 입력
        const sponsorPhoneInput = document.getElementById('sponsorPhone');
        if (sponsorPhoneInput) {
          sponsorPhoneInput.addEventListener('input', function() {
            numbersOnly(this);
          });
        }

        // 생년월일 필드 - 숫자만 입력
        const sponsorDobInput = document.getElementById('sponsorDob');
        if (sponsorDobInput) {
          sponsorDobInput.addEventListener('input', function() {
            numbersOnly(this);
          });
        }

        // 신용카드 번호 필드들 - 숫자만 입력
        document.querySelectorAll('#creditCardForm .input-group input[type="text"]').forEach(function(input) {
          input.addEventListener('input', function() {
            numbersOnly(this);
          });
        });

        // CVC 필드 - 숫자만 입력
        const cvcInput = document.querySelector('#creditCardForm input[maxlength="3"]');
        if (cvcInput) {
          cvcInput.addEventListener('input', function() {
            numbersOnly(this);
          });
        }

        // 계좌번호 필드 - 숫자만 입력
        const accountInput = document.querySelector('#bankTransferForm input[placeholder="계좌번호를 입력하세요"]');
        if (accountInput) {
          accountInput.addEventListener('input', function() {
            numbersOnly(this);
          });
        }

        // 후원자 정보 -> 결제 수단
        const goToStep3Btn = document.getElementById('goToStep3Btn');
        if (goToStep3Btn && donationContainer) {
          goToStep3Btn.addEventListener('click', function() {
            const sponsorName = document.getElementById('sponsorName').value.trim();
            const sponsorPhone = document.getElementById('sponsorPhone').value.trim();
            const sponsorDob = document.getElementById('sponsorDob').value.trim();
            const emailUser = document.getElementById('emailUser').value.trim();
            const emailDomain = document.getElementById('emailDomain').value.trim();
            const address = document.getElementById('address').value.trim();

            // 이름 검증
            if (!sponsorName) {
              alert('이름을 입력해주세요.');
              document.getElementById('sponsorName').focus();
              return;
            }

            // 전화번호 검증 (10-11자리 숫자)
            if (!sponsorPhone) {
              alert('전화번호를 입력해주세요.');
              document.getElementById('sponsorPhone').focus();
              return;
            }
            if (!/^[0-9]{10,11}$/.test(sponsorPhone)) {
              alert('전화번호는 10~11자리 숫자만 입력해주세요.');
              document.getElementById('sponsorPhone').focus();
              return;
            }

            // 생년월일 검증 (8자리 숫자, YYYYMMDD)
            if (!sponsorDob) {
              alert('생년월일을 입력해주세요.');
              document.getElementById('sponsorDob').focus();
              return;
            }
            if (!/^[0-9]{8}$/.test(sponsorDob)) {
              alert('생년월일은 8자리 숫자로 입력해주세요. (예: 19900101)');
              document.getElementById('sponsorDob').focus();
              return;
            }
            // 유효한 날짜인지 검증
            const year = parseInt(sponsorDob.substring(0, 4));
            const month = parseInt(sponsorDob.substring(4, 6));
            const day = parseInt(sponsorDob.substring(6, 8));
            if (year < 1900 || year > new Date().getFullYear() || month < 1 || month > 12 || day < 1 || day > 31) {
              alert('올바른 생년월일을 입력해주세요.');
              document.getElementById('sponsorDob').focus();
              return;
            }

            // 이메일 검증
            if (!emailUser) {
              alert('이메일 아이디를 입력해주세요.');
              document.getElementById('emailUser').focus();
              return;
            }
            if (!emailDomain) {
              alert('이메일 도메인을 입력해주세요.');
              document.getElementById('emailDomain').focus();
              return;
            }
            const fullEmail = emailUser + '@' + emailDomain;
            const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            if (!emailRegex.test(fullEmail)) {
              alert('올바른 이메일 형식을 입력해주세요.');
              document.getElementById('emailUser').focus();
              return;
            }

            // 주소 검증
            if (!address) {
              alert('주소를 입력해주세요.');
              document.getElementById('searchAddressBtn').click();
              return;
            }

            console.log('Moving to step 3');
            donationContainer.classList.add('view-step3');
            updateStepIndicator(3);
            console.log('Step 3 classes:', donationContainer.className);
          });
        }

        // 뒤로 가기 버튼 (후원자 정보 -> 기부하기)
        const backBtn = document.getElementById('backBtn');
        if (backBtn && donationContainer) {
          backBtn.addEventListener('click', function() {
            donationContainer.classList.remove('view-step2');
            updateStepIndicator(1);
          });
        }

        // 뒤로 가기 버튼 (결제 수단 -> 후원자 정보)
        const backToStep2Btn = document.getElementById('backToStep2Btn');
        if (backToStep2Btn && donationContainer) {
          backToStep2Btn.addEventListener('click', function() {
            donationContainer.classList.remove('view-step3');
            updateStepIndicator(2);
          });
        }

        // 이메일 도메인 선택
        const emailDomainSelect = document.getElementById("emailDomainSelect");
        if (emailDomainSelect) {
          emailDomainSelect.addEventListener("change", (e) => {
            const selectedValue = e.target.value;
            const emailDomain = document.getElementById("emailDomain");
            emailDomain.value = selectedValue ? selectedValue : "";
            emailDomain.readOnly = !!selectedValue;
            emailDomain.classList.toggle("disabled", !!selectedValue);
            if (!selectedValue) emailDomain.focus();
          });
        }

        // 주소 검색
        const searchAddressBtn = document.getElementById("searchAddressBtn");
        if (searchAddressBtn) {
          searchAddressBtn.addEventListener("click", () => {
            new daum.Postcode({
              oncomplete: function (data) {
                document.getElementById("postcode").value = data.zonecode;
                document.getElementById("address").value = data.address;
                document.getElementById("detailAddress").focus();
              },
            }).open();
          });
        }

        // 결제 방법 선택
        const paymentMethodBtns = document.querySelectorAll(".payment-method-btn");
        paymentMethodBtns.forEach((btn) => {
          btn.addEventListener("click", () => {
            paymentMethodBtns.forEach((b) => b.classList.remove("active"));
            btn.classList.add("active");
            document.querySelectorAll(".payment-details-form").forEach((form) => form.classList.add("hidden"));
            document.getElementById(btn.dataset.target).classList.remove("hidden");
          });
        });

        // 동의 체크박스 기능
        document.querySelectorAll(".agreement-section").forEach((section) => {
          const agreeAll = section.querySelector(".agreeAll");
          const agreeItems = section.querySelectorAll(".agree-item");
          if (!agreeAll) return;

          agreeAll.addEventListener("change", (e) => {
            agreeItems.forEach((checkbox) => (checkbox.checked = e.target.checked));
          });

          agreeItems.forEach((checkbox) => {
            checkbox.addEventListener("change", () => {
              agreeAll.checked = [...agreeItems].every((item) => item.checked);
            });
          });
        });

        // 최종 기부 완료
        const finalSubmitBtn = document.getElementById("finalSubmitBtn");
        if (finalSubmitBtn) {
          finalSubmitBtn.addEventListener("click", function() {
            const activeForm = document.querySelector(".payment-details-form:not(.hidden)");
            const activeAgreement = activeForm.querySelector(".agreement-section .agreeAll");

            if (!activeAgreement || !activeAgreement.checked) {
              alert("개인정보 수집 및 이용에 모두 동의해야 기부가 가능합니다.");
              return;
            }

            // ===== 결제 정보 검증 =====
            const activePaymentMethod = document.querySelector('.payment-method-btn.active');
            const paymentType = activePaymentMethod ? activePaymentMethod.dataset.target : '';

            // 신용카드 결제 검증
            if (paymentType === 'creditCardForm') {
              const cardInputs = document.querySelectorAll('#creditCardForm .input-group input[maxlength="4"]');
              let cardNumber = '';
              let isCardValid = true;
              cardInputs.forEach(function(input) {
                if (!input.value || input.value.length !== 4 || !/^[0-9]{4}$/.test(input.value)) {
                  isCardValid = false;
                }
                cardNumber += input.value;
              });
              if (!isCardValid || cardNumber.length !== 16) {
                alert('카드번호 16자리를 정확히 입력해주세요.');
                return;
              }

              const expMonthInput = document.querySelector('#creditCardForm input[maxlength="2"][placeholder="MM"]');
              const expYearInput = document.querySelector('#creditCardForm input[maxlength="2"][placeholder="YY"]');
              if (!expMonthInput || !expMonthInput.value || !/^(0[1-9]|1[0-2])$/.test(expMonthInput.value)) {
                alert('유효기간(월)을 정확히 입력해주세요. (01~12)');
                if (expMonthInput) expMonthInput.focus();
                return;
              }
              if (!expYearInput || !expYearInput.value || !/^[0-9]{2}$/.test(expYearInput.value)) {
                alert('유효기간(년)을 정확히 입력해주세요. (YY)');
                if (expYearInput) expYearInput.focus();
                return;
              }

              const cvcInput = document.querySelector('#creditCardForm input[maxlength="3"]');
              if (!cvcInput || !cvcInput.value || !/^[0-9]{3}$/.test(cvcInput.value)) {
                alert('CVC 3자리를 정확히 입력해주세요.');
                if (cvcInput) cvcInput.focus();
                return;
              }
            }

            // 계좌이체 검증
            if (paymentType === 'bankTransferForm') {
              const bankSelect = document.querySelector('#bankTransferForm select');
              if (!bankSelect || !bankSelect.value) {
                alert('은행을 선택해주세요.');
                return;
              }
              const accountInput = document.querySelector('#bankTransferForm input[placeholder="계좌번호를 입력하세요"]');
              if (!accountInput || !accountInput.value || !/^[0-9]{10,16}$/.test(accountInput.value)) {
                alert('계좌번호를 정확히 입력해주세요. (10~16자리 숫자)');
                if (accountInput) accountInput.focus();
                return;
              }
            }

            // 기부 정보 수집
            const sponsorName = document.getElementById("sponsorName").value.trim();
            const sponsorPhone = document.getElementById("sponsorPhone").value.replace(/-/g, ''); // 하이픈 제거
            const amountInput = document.getElementById("amountInput").value;

            // 금액 파싱 (쉼표 제거)
            const amount = parseFloat(amountInput.replace(/,/g, ''));

            // 이메일 조합 (emailUser@emailDomain)
            const emailUser = document.getElementById("emailUser");
            const emailDomain = document.getElementById("emailDomain");
            let sponsorEmail = '';
            if (emailUser && emailDomain) {
              sponsorEmail = emailUser.value + '@' + emailDomain.value;
            }

            // 선택된 카테고리 가져오기
            const selectedCategory = document.querySelector('.donation-category.active');
            const category = selectedCategory ? selectedCategory.dataset.category : '일반기부';

            // 기부 타입 (정기/일시) - regularBtn 또는 onetimeBtn 확인
            let donationType = 'ONETIME'; // 기본값
            const regularBtn = document.getElementById('regularBtn');
            const onetimeBtn = document.getElementById('onetimeBtn');

            if (regularBtn && regularBtn.classList.contains('active')) {
              donationType = 'REGULAR';
            } else if (onetimeBtn && onetimeBtn.classList.contains('active')) {
              donationType = 'ONETIME';
            }

            // 검증
            if (!sponsorName) {
              alert('후원자명을 입력해주세요.');
              return;
            }
            if (!sponsorPhone) {
              alert('전화번호를 입력해주세요.');
              return;
            }
            if (!amount || isNaN(amount) || amount <= 0) {
              alert('올바른 기부 금액을 입력해주세요.');
              return;
            }

            // 정기 기부인 경우 시작일 필수 확인
            if (donationType === 'REGULAR') {
              const regularStartDateInput = document.getElementById('regularStartDateInput');
              if (!regularStartDateInput || !regularStartDateInput.value) {
                alert('정기 기부 시작일을 선택해주세요.');
                return;
              }

              // 시작일이 오늘 이후 또는 당일인지 확인
              const today = new Date();
              today.setHours(0, 0, 0, 0);
              const startDateObj = new Date(regularStartDateInput.value + 'T00:00:00');

              if (startDateObj < today) {
                alert('정기 기부 시작일은 오늘 또는 이후 날짜여야 합니다.');
                return;
              }
            }

            // 버튼 비활성화
            finalSubmitBtn.disabled = true;
            finalSubmitBtn.textContent = '처리 중...';

            // 서명 이미지 가져오기
            const signatureCanvas = document.getElementById('signatureCanvas');
            const signatureImage = signatureCanvas ? signatureCanvas.toDataURL('image/png') : '';

            // 결제 방법 가져오기 (선택된 버튼 찾기)
            const selectedPaymentBtn = document.querySelector('.payment-method-btn.active');
            const paymentMethod = selectedPaymentBtn ? selectedPaymentBtn.dataset.method || 'CREDIT_CARD' : 'CREDIT_CARD';

            // 정기 기부 시작일 가져오기
            const regularStartDateInput = document.getElementById('regularStartDateInput');
            const regularStartDate = (donationType === 'REGULAR' || donationType === 'regular') && regularStartDateInput ? regularStartDateInput.value : '';

            // 디버깅: 전송할 데이터 로그
            console.log('=== 기부 요청 데이터 ===');
            console.log('후원자명:', sponsorName);
            console.log('이메일:', sponsorEmail);
            console.log('전화번호:', sponsorPhone);
            console.log('금액:', amount);
            console.log('기부 유형:', donationType);
            console.log('카테고리:', category);
            console.log('결제 방법:', paymentMethod);
            console.log('정기 기부 시작일:', regularStartDate);
            console.log('서명 이미지 길이:', signatureImage.length);

            // API로 데이터 전송
            const formData = new URLSearchParams();
            formData.append('amount', amount);
            formData.append('donationType', donationType);
            formData.append('category', category);
            formData.append('packageName', selectedPackageName || ''); // 패키지명 추가
            formData.append('donorName', sponsorName);
            formData.append('donorEmail', sponsorEmail);
            formData.append('donorPhone', sponsorPhone);
            formData.append('message', ''); // 메시지 필드가 있다면 추가
            formData.append('signatureImage', signatureImage); // 서명 이미지 추가
            formData.append('paymentMethod', paymentMethod); // 결제 방법 추가
            if (regularStartDate) {
              formData.append('regularStartDate', regularStartDate); // 정기 기부 시작일 추가
            }

            fetch('/bdproject/api/donation/create', {
              method: 'POST',
              headers: {
                'Content-Type': 'application/x-www-form-urlencoded'
              },
              body: formData.toString()
            })
            .then(response => {
              console.log('=== API 응답 상태 ===');
              console.log('Status:', response.status);
              console.log('StatusText:', response.statusText);
              return response.json();
            })
            .then(data => {
              console.log('=== API 응답 데이터 ===');
              console.log(data);

              if (data.success) {
                // 활동 로그 저장
                const donationTypeText = donationType === 'REGULAR' || donationType === 'regular' ? '정기 기부' : '일시 기부';
                const today = new Date();
                const dateStr = today.getFullYear() + '년 ' + (today.getMonth() + 1) + '월 ' + today.getDate() + '일';

                logUserActivity({
                  type: donationType === 'REGULAR' || donationType === 'regular' ? 'donation_regular' : 'donation_onetime',
                  icon: 'fas fa-hand-holding-heart',
                  iconColor: '#e74c3c',
                  title: donationTypeText,
                  description: dateStr + '에 ' + Number(amount).toLocaleString() + '원 ' + donationTypeText + '를 신청했습니다.',
                  timestamp: new Date().toISOString()
                });

                alert('기부가 완료되었습니다. 감사합니다!');
                setTimeout(() => {
                  window.location.href = '/bdproject/project_mypage.jsp';
                }, 1500);
              } else {
                console.error('기부 실패:', data.message);
                alert('기부 처리 중 오류가 발생했습니다.\n' + (data.message || '다시 시도해주세요.'));
                finalSubmitBtn.disabled = false;
                finalSubmitBtn.textContent = '기부완료';
              }
            })
            .catch(error => {
              console.error('=== 기부 요청 오류 ===');
              console.error(error);
              alert('기부 처리 중 오류가 발생했습니다.\n다시 시도해주세요.');
              finalSubmitBtn.disabled = false;
              finalSubmitBtn.textContent = '기부완료';
            });
          });
        }

        // Signature pad functionality
        const initSignaturePad = (canvasId) => {
          const canvas = document.getElementById(canvasId);
          if (!canvas) return;
          const ctx = canvas.getContext("2d");
          let drawing = false;

          const startDrawing = (e) => {
            drawing = true;
            draw(e);
          };

          const stopDrawing = () => {
            drawing = false;
            ctx.beginPath();
          };

          const getPos = (e) => {
            const rect = canvas.getBoundingClientRect();
            const clientX = e.clientX || e.touches[0].clientX;
            const clientY = e.clientY || e.touches[0].clientY;
            return { x: clientX - rect.left, y: clientY - rect.top };
          };

          const draw = (e) => {
            if (!drawing) return;
            const pos = getPos(e);
            ctx.lineWidth = 2;
            ctx.lineCap = "round";
            ctx.strokeStyle = "#000";
            ctx.lineTo(pos.x, pos.y);
            ctx.stroke();
            ctx.beginPath();
            ctx.moveTo(pos.x, pos.y);
          };

          canvas.addEventListener("mousedown", startDrawing);
          canvas.addEventListener("mouseup", stopDrawing);
          canvas.addEventListener("mousemove", draw);
          canvas.addEventListener("mouseleave", stopDrawing);
          canvas.addEventListener("touchstart", startDrawing);
          canvas.addEventListener("touchend", stopDrawing);
          canvas.addEventListener("touchmove", draw);
        };

        initSignaturePad("cardCanvas");
        initSignaturePad("bankCanvas");

        document.querySelectorAll(".clear-signature-btn").forEach((button) => {
          button.addEventListener("click", () => {
            const canvas = document.getElementById(button.dataset.target);
            const ctx = canvas.getContext("2d");
            ctx.clearRect(0, 0, canvas.width, canvas.height);
          });
        });

        // Modal functionality
        const detailButtons = document.querySelectorAll(".view-details-btn");
        const modals = document.querySelectorAll(".modal-overlay");
        const closeButtons = document.querySelectorAll(".modal-close-btn");

        detailButtons.forEach((button) =>
          button.addEventListener("click", (e) => {
            e.preventDefault();
            document.getElementById(button.dataset.modal).classList.add("active");
          })
        );

        const closeModal = () =>
          modals.forEach((modal) => modal.classList.remove("active"));

        closeButtons.forEach((button) =>
          button.addEventListener("click", closeModal)
        );

        modals.forEach((modal) =>
          modal.addEventListener("click", (e) => {
            if (e.target === modal) closeModal();
          })
        );

        // User icon navigation
        const userIcon = document.getElementById("userIcon");
        if (userIcon) {
          userIcon.addEventListener("click", function() {
            window.location.href = '/bdproject/projectLogin.jsp';
          });
        }

        // 초기 설정
        updateStepIndicator(1);
      });
    </script>
        <%@ include file="footer.jsp" %>
  </body>
</html>