<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        background-color: #e2f0f6;
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
        font-size: 28px;
        color: black;
        text-decoration: none;
      }
      .logo-icon {
        width: 50px;
        height: 50px;
        background-image: url("resources/image/복지로고.png");
        background-size: 80%;
        background-repeat: no-repeat;
        background-position: center;
        background-color: transparent;
        border-radius: 6px;
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
        margin: 40px auto;
        padding: 40px 20px;
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
      }
      .next-btn-container {
        margin-top: 30px;
        text-align: center;
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
        overflow: hidden;
        min-height: 700px;
        background-color: #fafafa;
        color: #191918;
        margin: 40px auto;
        padding: 40px 20px;
        display: none; /* Hide by default */
      }

      #donation-container.show {
        display: block;
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
        margin-top: 30px;
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

      .step-indicator {
        display: flex;
        justify-content: center;
        align-items: center;
        margin-bottom: 30px;
        gap: 20px;
      }

      .step {
        display: flex;
        align-items: center;
        gap: 10px;
      }

      .step-number {
        width: 30px;
        height: 30px;
        border-radius: 50%;
        background: #ddd;
        color: #666;
        display: flex;
        align-items: center;
        justify-content: center;
        font-weight: 600;
      }

      .step-number.active {
        background: #4a90e2;
        color: white;
      }

      .step-text {
        font-size: 14px;
        color: #666;
      }

      .step-text.active {
        color: #333;
        font-weight: 600;
      }

      .step-connector {
        width: 40px;
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
    </style>
  </head>
  <body>
    <header id="main-header">
      <nav class="navbar">
        <div class="navbar-left">
          <a href="/bdproject/project.jsp" class="logo"
            ><div class="logo-icon"></div>
            복지 24</a
          >
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
            <a href="#" class="dropdown-link">
              <span class="dropdown-link-title">공지사항</span>
              <span class="dropdown-link-desc"
                >새로운 복지 소식을 알려드립니다.</span
              >
            </a>
            <a href="#" class="dropdown-link">
              <span class="dropdown-link-title">자주묻는 질문</span>
              <span class="dropdown-link-desc"
                >궁금한 점을 빠르게 해결하세요.</span
              >
            </a>
            <a href="#" class="dropdown-link">
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

    <!-- Step 1: Donation Form -->
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
        </form>
      </div>
      <div class="donation-right-box">
        <h3 class="donation-methods-title">기부 참여 분야</h3>
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

    <div id="donation-container">
      <!-- Step Indicator -->
      <div class="step-indicator">
        <div class="step">
          <div class="step-number">1</div>
          <div class="step-text">기부하기</div>
        </div>
        <div class="step-connector"></div>
        <div class="step">
          <div class="step-number active">2</div>
          <div class="step-text active">후원자 정보</div>
        </div>
        <div class="step-connector"></div>
        <div class="step">
          <div class="step-number" id="step3Number">3</div>
          <div class="step-text" id="step3Text">결제 수단</div>
        </div>
      </div>

      <!-- Step 2: Sponsor Info -->
      <div id="donation-step2" class="donation-step">
        <div class="sponsor-info-box">
          <h2 class="donation-title">후원자 정보</h2>
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
            <button class="back-btn" id="backBtn" onclick="window.location.href='/bdproject/project.jsp'">뒤로</button>
            <button class="next-btn" id="goToStep3Btn">다음</button>
          </div>
        </div>
      </div>

      <!-- Step 3: Payment Method -->
      <div id="donation-step3" class="donation-step" style="display: none;">
        <div class="payment-info-box">
          <h2 class="donation-title">결제 수단 선택</h2>
          <div class="payment-method-group">
            <button
              type="button"
              class="payment-method-btn active"
              data-target="creditCardForm"
            >
              신용카드
            </button>
            <button
              type="button"
              class="payment-method-btn"
              data-target="bankTransferForm"
            >
              계좌 이체
            </button>
            <button
              type="button"
              class="payment-method-btn"
              data-target="naverPayForm"
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
              <div class="form-group grid-col-span-2">
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
              <div class="form-group grid-col-span-2">
                <div class="signature-pad-wrapper">
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
              <div class="form-group grid-col-span-2">
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
              <div class="form-group grid-col-span-2">
                <div class="signature-pad-wrapper">
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

      function updateLanguage() {
        // 지구본 아이콘 툴팁 업데이트
        const globeIcon = document.querySelector(".navbar-icon:first-child");
        if (globeIcon) {
          globeIcon.title =
            currentLanguage === "ko" ? "Switch to English" : "한국어로 전환";
        }
      }

      // 기부 폼 관련 JavaScript
      document.addEventListener("DOMContentLoaded", function() {
        const goToStep3Btn = document.getElementById("goToStep3Btn");
        const backToStep2Btn = document.getElementById("backToStep2Btn");
        const finalSubmitBtn = document.getElementById("finalSubmitBtn");
        const step3Number = document.getElementById("step3Number");
        const step3Text = document.getElementById("step3Text");
        const donationStep2 = document.getElementById("donation-step2");
        const donationStep3 = document.getElementById("donation-step3");

        // Step 3으로 이동
        goToStep3Btn.addEventListener("click", function() {
          // 필수 입력 확인
          const sponsorName = document.getElementById("sponsorName").value;
          const sponsorPhone = document.getElementById("sponsorPhone").value;
          const address = document.getElementById("address").value;

          if (!sponsorName) {
            alert("이름을 입력해주세요.");
            document.getElementById("sponsorName").focus();
            return;
          }

          if (!sponsorPhone) {
            alert("전화번호를 입력해주세요.");
            document.getElementById("sponsorPhone").focus();
            return;
          }

          if (!address) {
            alert("주소를 입력해주세요.");
            return;
          }

          // Step 2 숨기고 Step 3 보이기
          donationStep2.style.display = "none";
          donationStep3.style.display = "flex";

          // Step indicator 업데이트
          document.querySelector('.step-number.active').classList.remove('active');
          document.querySelector('.step-text.active').classList.remove('active');
          step3Number.classList.add('active');
          step3Text.classList.add('active');
        });

        // Step 2로 돌아가기
        backToStep2Btn.addEventListener("click", function() {
          donationStep3.style.display = "none";
          donationStep2.style.display = "flex";

          // Step indicator 업데이트
          step3Number.classList.remove('active');
          step3Text.classList.remove('active');
          document.querySelector('.step:nth-child(3) .step-number').classList.add('active');
          document.querySelector('.step:nth-child(3) .step-text').classList.add('active');
        });

        // 최종 기부 완료
        finalSubmitBtn.addEventListener("click", function() {
          const activeForm = document.querySelector(".payment-details-form:not(.hidden)");
          const activeAgreement = activeForm.querySelector(".agreement-section .agreeAll");

          if (!activeAgreement || !activeAgreement.checked) {
            alert("개인정보 수집 및 이용에 모두 동의해야 기부가 가능합니다.");
            return;
          }

          // 서명 패드 검증
          if (activeForm.id === "creditCardForm") {
            const signatureCanvas = document.getElementById("cardCanvas");
            const ctx = signatureCanvas.getContext("2d");
            const imageData = ctx.getImageData(0, 0, signatureCanvas.width, signatureCanvas.height);
            const hasSignature = imageData.data.some((channel, index) => index % 4 !== 3 && channel !== 0);

            if (!hasSignature) {
              alert("서명을 해주세요.");
              return;
            }
          } else if (activeForm.id === "bankTransferForm") {
            const bankSelect = activeForm.querySelector("select.form-select");
            const accountNumber = activeForm.querySelector('input[placeholder*="계좌번호"]');
            const signatureCanvas = document.getElementById("bankCanvas");

            if (!bankSelect.value) {
              alert("은행을 선택해주세요.");
              bankSelect.focus();
              return;
            }

            if (!accountNumber.value || accountNumber.value.trim() === "") {
              alert("계좌번호를 입력해주세요.");
              accountNumber.focus();
              return;
            }

            const ctx = signatureCanvas.getContext("2d");
            const imageData = ctx.getImageData(0, 0, signatureCanvas.width, signatureCanvas.height);
            const hasSignature = imageData.data.some((channel, index) => index % 4 !== 3 && channel !== 0);

            if (!hasSignature) {
              alert("서명을 해주세요.");
              return;
            }
          }

          const sponsorName = document.getElementById("sponsorName").value;
          alert(`${sponsorName}님, 기부가 완료되었습니다. 감사합니다!`);

          // 기부 완료 후 메인 페이지로 이동
          setTimeout(() => {
            window.location.href = '/bdproject/project.jsp';
          }, 2000);
        });

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

        // 이름 입력 유효성 검사 (숫자 입력 방지)
        const sponsorNameInput = document.getElementById("sponsorName");
        if (sponsorNameInput) {
          sponsorNameInput.addEventListener("keypress", function (e) {
            if (/[0-9]/.test(e.key)) {
              e.preventDefault();
            }
          });

          sponsorNameInput.addEventListener("input", function (e) {
            this.value = this.value.replace(/[0-9]/g, "");
          });
        }

        // 전화번호 입력 유효성 검사 (숫자만 입력)
        const sponsorPhoneInput = document.getElementById("sponsorPhone");
        if (sponsorPhoneInput) {
          sponsorPhoneInput.addEventListener("keypress", function (e) {
            if (!/[0-9]/.test(e.key) && !["Backspace", "Tab", "Enter", "Delete", "ArrowLeft", "ArrowRight"].includes(e.key)) {
              e.preventDefault();
            }
          });

          sponsorPhoneInput.addEventListener("input", function (e) {
            this.value = this.value.replace(/[^0-9]/g, "");
          });
        }

        // 생년월일 입력 유효성 검사
        const sponsorDobInput = document.getElementById("sponsorDob");
        if (sponsorDobInput) {
          sponsorDobInput.addEventListener("keypress", function (e) {
            if (!/[0-9]/.test(e.key) && !["Backspace", "Tab", "Enter", "Delete", "ArrowLeft", "ArrowRight", "ArrowUp", "ArrowDown"].includes(e.key)) {
              e.preventDefault();
            }
          });

          sponsorDobInput.addEventListener("input", function (e) {
            let value = this.value.replace(/[^0-9]/g, "");
            if (value.length > 8) {
              value = value.slice(0, 8);
            }
            this.value = value;
            this.validateBirthDate();
          });

          // 생년월일 유효성 검사 함수
          sponsorDobInput.validateBirthDate = function () {
            const value = this.value;
            let isValid = true;
            let errorMessage = "";

            if (value.length === 8) {
              const year = parseInt(value.substring(0, 4));
              const month = parseInt(value.substring(4, 6));
              const day = parseInt(value.substring(6, 8));

              if (year < 1900 || year > 2025) {
                isValid = false;
                errorMessage = "연도는 1900~2025년 사이여야 합니다.";
              } else if (month < 1 || month > 12) {
                isValid = false;
                errorMessage = "월은 01~12 사이여야 합니다.";
              } else if (day < 1 || day > 31) {
                isValid = false;
                errorMessage = "일은 01~31 사이여야 합니다.";
              } else {
                const daysInMonth = new Date(year, month, 0).getDate();
                if (day > daysInMonth) {
                  isValid = false;
                  errorMessage = year + "년 " + month + "월은 " + daysInMonth + "일까지만 있습니다.";
                }
              }

              let errorDiv = this.parentNode.querySelector(".error-message");
              if (!isValid) {
                if (!errorDiv) {
                  errorDiv = document.createElement("div");
                  errorDiv.className = "error-message";
                  errorDiv.style.color = "red";
                  errorDiv.style.fontSize = "12px";
                  errorDiv.style.marginTop = "5px";
                  this.parentNode.appendChild(errorDiv);
                }
                errorDiv.textContent = errorMessage;
                this.style.borderColor = "red";
              } else {
                if (errorDiv) {
                  errorDiv.remove();
                }
                this.style.borderColor = "";
              }
            } else {
              let errorDiv = this.parentNode.querySelector(".error-message");
              if (errorDiv) {
                errorDiv.remove();
              }
              this.style.borderColor = "";
            }
          };
        }

        // 카드번호 입력 유효성 검사 (숫자만)
        const cardInputs = document.querySelectorAll('#creditCardForm .input-group input[type="text"]');
        cardInputs.forEach((input, index) => {
          if (index < 4) { // 카드번호 4개 입력 필드
            input.addEventListener("keypress", function (e) {
              if (!/[0-9]/.test(e.key) && !["Backspace", "Tab", "Enter", "Delete", "ArrowLeft", "ArrowRight"].includes(e.key)) {
                e.preventDefault();
              }
            });

            input.addEventListener("input", function (e) {
              this.value = this.value.replace(/[^0-9]/g, "");
            });
          } else if (index < 6) { // 유효기간 MM/YY
            input.addEventListener("keypress", function (e) {
              if (!/[0-9]/.test(e.key) && !["Backspace", "Tab", "Enter", "Delete", "ArrowLeft", "ArrowRight"].includes(e.key)) {
                e.preventDefault();
              }
            });

            input.addEventListener("input", function (e) {
              this.value = this.value.replace(/[^0-9]/g, "");
            });
          }
        });

        // CVC 입력 유효성 검사
        const cvcInput = document.querySelector('#creditCardForm input[placeholder="123"]');
        if (cvcInput) {
          cvcInput.addEventListener("keypress", function (e) {
            if (!/[0-9]/.test(e.key) && !["Backspace", "Tab", "Enter", "Delete", "ArrowLeft", "ArrowRight"].includes(e.key)) {
              e.preventDefault();
            }
          });

          cvcInput.addEventListener("input", function (e) {
            this.value = this.value.replace(/[^0-9]/g, "");
          });
        }

        // Modal functionality
        const detailButtons = document.querySelectorAll(".view-details-btn");
        const modals = document.querySelectorAll(".modal-overlay");
        const closeButtons = document.querySelectorAll(".modal-close-btn");

        detailButtons.forEach((button) =>
          button.addEventListener("click", (e) => {
            e.preventDefault();
            document
              .getElementById(button.dataset.modal)
              .classList.add("active");
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

        // Naver Pay button functionality
        const naverPayBtn = document.getElementById("naverPayBtn");
        if (naverPayBtn) {
          naverPayBtn.addEventListener("click", function() {
            alert("네이버 로그인 페이지로 이동합니다.");
            window.open("https://nid.naver.com/nidlogin.login", "_blank");
          });
        }

        // User icon click to navigate to login page
        const userIcon = document.getElementById("userIcon");
        if (userIcon) {
          userIcon.addEventListener("click", function() {
            window.location.href = '/bdproject/projectLogin.jsp';
          });
        }

        // URL parameter handling for donation type
        const urlParams = new URLSearchParams(window.location.search);
        const donationType = urlParams.get('type');
        console.log('URL Parameter - type:', donationType); // Debug log

        const regularBtn = document.getElementById('regularBtn');
        const onetimeBtn = document.getElementById('onetimeBtn');

        if (donationType === 'regular' && regularBtn) {
          regularBtn.classList.add('active');
          console.log('Regular button activated'); // Debug log
        } else if (donationType === 'onetime' && onetimeBtn) {
          onetimeBtn.classList.add('active');
          console.log('Onetime button activated'); // Debug log
        }

        // Donation button functionality
        if (regularBtn) {
          regularBtn.addEventListener('click', function() {
            regularBtn.classList.add('active');
            onetimeBtn.classList.remove('active');
          });
        }

        if (onetimeBtn) {
          onetimeBtn.addEventListener('click', function() {
            onetimeBtn.classList.add('active');
            regularBtn.classList.remove('active');
          });
        }

        // Next button functionality
        const nextBtn = document.getElementById('nextBtn');
        if (nextBtn) {
          nextBtn.addEventListener('click', function() {
            // Show donation container (step 2) and scroll to it
            const donationContainer = document.getElementById('donation-container');
            donationContainer.classList.add('show');
            donationContainer.scrollIntoView({
              behavior: 'smooth',
              block: 'start'
            });
          });
        }
      });
    </script>
  </body>
</html>