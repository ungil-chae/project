<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <style>
html, body {
    width: 100%;
    margin: 0;
    padding: 0;
    overflow-x: hidden;
    background-color: #E2F0F6; /* 전체 배경색 설정 */
}
* {
    box-sizing: border-box;
}
body {
    position: relative;
    background-color: #FAFAFA;
    color: #191918;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif;
}
        #main-header {
            position: sticky;
            top: 0;
            z-index: 1000;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
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
        .navbar-left { flex-shrink: 0; }
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
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
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
        
        .logo { display: flex; align-items: center; gap: 8px; font-size: 28px; color: black; text-decoration: none; }
        .logo-icon { width: 50px; height: 50px; background-image: url('resources/image/복지로고.png'); background-size: 80%; background-repeat: no-repeat; background-position: center; background-color: transparent; border-radius: 6px; }
        
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
        .nav-link:hover, .nav-link.active { 
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
            transition: max-height 0.4s ease-in-out, padding 0.4s ease-in-out, border-top 0.4s ease-in-out;
            border-top: 1px solid transparent;
            box-shadow: 0 8px 16px rgba(0,0,0,0.05);
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
            content: '';
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
		    content: '';
		    position: absolute;
		    top: 0;
		    left: 0;
		    width: 100%;
		    height: 100%;
		    background: #F7F5F2; /* 왼쪽 패널 색상 */
		    clip-path: polygon(0 0, 50% 0, 35% 100%, 0 100%); /* 대각선 모양 */
		}
		
		/* 3. 텍스트를 담는 컨테이너 (이제 투명함) */
		.main-content {
		    height: 100vh;  /* ★★★ 수정됨 ★★★ */
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
		    background-image: url('resources/image/배경5.png');
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
            color: #1E1919;
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
            content: '→';
            font-size: 20px;
            transition: transform 0.3s ease;
        }
        .main-cta-btn:hover {
            background-color: #f0f0f0;
        }
        .main-cta-btn:hover::after {
            transform: translateX(5px);
        }
        
        /* main-right와 donation 사이의 중간 섹션 */
        .middle-section {
            width: 100%;
            height: 700px; /* donation의 margin-top과 동일 */
            background-color: #E2F0F6;
            position: relative;
            z-index: 0;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 60px 20px;
        }
        
        .popular-welfare-title {
            font-size: 32px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 10px;
            text-align: center;
        }
        
        .popular-welfare-subtitle {
            font-size: 16px;
            color: #6c757d;
            margin-bottom: 40px;
            text-align: center;
        }
        
        .popular-welfare-container {
            position: relative;
            max-width: 1200px;
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
            border-radius: 12px;
            padding: 20px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            cursor: pointer;
            position: relative;
            overflow: hidden;
            flex: 0 0 calc(33.333% - 14px);
            min-width: 300px;
        }
        
        .popular-welfare-item:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 20px rgba(0,0,0,0.12);
        }
        
        .welfare-rank {
            position: absolute;
            top: 15px;
            right: 15px;
            background: #0061ff;
            color: white;
            width: 30px;
            height: 30px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: 700;
            font-size: 14px;
        }
        
        .welfare-rank.top-3 {
            background: linear-gradient(135deg, #ffd700, #ffed4e);
            color: #333;
        }
        
        .welfare-info {
            margin-right: 40px;
        }
        
        .welfare-name {
            font-size: 16px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            line-height: 1.4;
            display: -webkit-box;
            -webkit-line-clamp: 2;
            -webkit-box-orient: vertical;
            overflow: hidden;
        }
        
        .welfare-org {
            font-size: 13px;
            color: #666;
            margin-bottom: 8px;
        }
        
        .welfare-views {
            font-size: 14px;
            color: #0061ff;
            font-weight: 600;
        }
        
        .welfare-source {
            display: inline-block;
            padding: 4px 8px;
            font-size: 11px;
            border-radius: 4px;
            font-weight: 500;
            margin-top: 8px;
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
            padding: 40px;
            color: #666;
        }
        
        .slider-nav-btn {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            background: white;
            border: none;
            border-radius: 50%;
            width: 50px;
            height: 50px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            box-shadow: 0 2px 10px rgba(0, 0, 0, 0.15);
            z-index: 2;
            transition: all 0.3s ease;
            color: #666;
            font-size: 20px;
        }
        
        .slider-nav-btn:hover {
            background: #f8f9fa;
            transform: translateY(-50%) scale(1.1);
            color: #333;
        }
        
        .slider-nav-btn:disabled {
            opacity: 0.3;
            cursor: not-allowed;
            transform: translateY(-50%);
        }
        
        .slider-prev {
            left: 10px;
        }
        
        .slider-next {
            right: 10px;
        }
        
        .slider-indicators {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin-top: 20px;
        }
        
        .slider-dot {
            width: 8px;
            height: 8px;
            border-radius: 50%;
            background: #ddd;
            cursor: pointer;
            transition: all 0.3s ease;
        }
        
        .slider-dot.active {
            background: #0061ff;
            transform: scale(1.2);
        }
        
        .loading-spinner {
            width: 40px;
            height: 40px;
            border: 3px solid #f3f3f3;
            border-top: 3px solid #0061ff;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 0 auto 20px;
        }
        
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        
        #donation-container {
            position: relative;
            margin-top: 0; /* middle-section 바로 뒤에 위치 */
            width: 100%;
            max-width: 1400px;
            overflow: hidden;
            min-height: 700px;
            background-color: #FAFAFA;
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
        .donation-step { display: flex; width: 100%; transition: transform 0.5s ease-in-out, opacity 0.5s ease-in-out; }
        #donation-step1 { gap: 30px; }

        #donation-step2, #donation-step3 { position: absolute; top: 0; left: 0; width:100%; opacity: 0; visibility: hidden; transform: translateX(100%); }
        #donation-container.view-step2 #donation-step1,
        #donation-container.view-step3 #donation-step1 { opacity: 0; visibility: hidden; transform: translateX(-100%); }
        #donation-container.view-step2 #donation-step2,
        #donation-container.view-step3 #donation-step3 { opacity: 1; visibility: visible; transform: translateX(0); }
        #donation-container.view-step3 #donation-step2 { opacity: 0; visibility: hidden; transform: translateX(-100%); }

        .donation-left-box { flex: 3; background: white; border-radius: 20px; padding: 40px; box-shadow: 0 6px 20px rgba(0,0,0,0.12); }
        .donation-right-box { flex: 7; background: white; border-radius: 20px; padding: 40px; box-shadow: 0 6px 20px rgba(0,0,0,0.12); }
        .donation-title { font-size: 28px; font-weight: 600; color: #333; margin-bottom: 15px; }
        .donation-subtitle { font-size: 14px; color: #666; margin-bottom: 30px; line-height: 1.5; }
        .donation-form { display: flex; flex-direction: column; gap: 20px; }
        .form-group { display: flex; flex-direction: column; gap: 10px; }
        .form-label { font-size: 18px; font-weight: 600; color: #333; }
        .form-select { width: 100%; padding: 15px; border: 1px solid #ddd; border-radius: 8px; font-size: 15px; background: white; cursor: pointer; appearance: none; background-image: url("data:image/svg+xml;charset=utf-8,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 16 16'%3E%3Cpath fill='none' stroke='%23666' stroke-linecap='round' stroke-linejoin='round' stroke-width='2' d='m2 5 6 6 6-6'/%3E%3C/svg%3E"); background-repeat: no-repeat; background-position: right 15px center; background-size: 16px; }
        .form-input { width: 100%; padding: 15px; border: 1px solid #ddd; border-radius: 8px; font-size: 15px; outline: none; }
        .form-input:focus { border-color: #4A90E2; box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1); }
        .form-input.disabled, .form-input[readonly] { background-color: #f5f5f5; color: #999; cursor: not-allowed; }
        .donation-buttons { display: flex; gap: 12px; margin-top: 10px; }
        .donation-btn { flex: 1; padding: 16px 20px; border: 2px solid #ddd; border-radius: 8px; background: white; font-size: 15px; font-weight: 600; cursor: pointer; transition: all 0.4s ease; }
        .donation-btn:hover { background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%); color: white; border-color: #4A90E2; }
        .donation-btn.active { background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%); color: white; border-color: #4A90E2; }
        .donation-categories { display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px; }
        .donation-category { display: flex; align-items: center; padding: 20px 15px; background: #f8f9fa; border-radius: 12px; transition: all 0.3s ease; cursor: pointer; border: 2px solid transparent; }
        .donation-category:hover { background: #e9ecef; transform: translateY(-2px); }
        .donation-category.selected { background: #e3f2fd; border-color: #4A90E2; }
        .category-icon { width: 50px; height: 50px; background: #fff; border-radius: 10px; margin-right: 12px; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 6px rgba(0,0,0,0.08); flex-shrink: 0; }
        .category-icon img { width: 30px; height: 30px; object-fit: contain; }
        .category-content { flex: 1; text-align: left; }
        .category-title { font-size: 14px; font-weight: 600; color: #333; margin-bottom: 4px; }
        .category-desc { font-size: 12px; color: #666; line-height: 1.3; }
        .donation-methods-title { font-size: 20px; font-weight: 600; color: #333; margin-bottom: 25px; }
        .next-btn-container { display: flex; justify-content: flex-end; margin-top: 25px; }
        .next-btn { background: #4A90E2; color: white; border: none; padding: 12px 30px; border-radius: 8px; font-size: 15px; font-weight: 500; cursor: pointer; transition: background 0.3s ease; }
        .next-btn:hover { background: #357ABD; }
        .sponsor-info-box, .payment-info-box { width: 100%; background: white; border-radius: 20px; padding: 40px; box-shadow: 0 6px 20px rgba(0,0,0,0.12); }
        .sponsor-form { display: grid; grid-template-columns: 1fr 1fr; gap: 25px 40px; margin-top: 30px; align-items: start; }
        .email-group { display: flex; align-items: center; gap: 10px; }
        .email-group #emailUser { flex: 1 1 50%; }
        .email-group #emailDomain { flex: 1 1 50%; }
        .email-group #emailDomainSelect { flex: 0 0 160px; }
        .email-at { font-size: 16px; color: #888; }
        .address-row { display: flex; gap: 10px; margin-bottom: 10px; }
        .address-row .address-group { flex: 1; margin-bottom: 0; }
        .address-row #address { flex: 2; margin-bottom: 0; }
        .address-group { display: flex; align-items: center; gap: 10px; }
        .address-group .form-input { flex: 1; }
        #searchAddressBtn { background: #4A90E2; color: white; border: none; padding: 15px 25px; border-radius: 8px; font-size: 15px; font-weight: 500; cursor: pointer; transition: background 0.3s ease; }
        #searchAddressBtn:hover { background: #357ABD; }
        .custom-radio-group { display: flex; align-items: center; gap: 30px; margin-top: 10px; }
        .custom-radio-group .radio-label { display: flex; align-items: center; font-size: 16px; cursor: pointer; }
        .custom-radio-group input[type="radio"] { display: none; }
        .custom-radio-group .custom-radio-box { width: 22px; height: 22px; border: 2px solid #ccc; border-radius: 4px; margin-right: 12px; position: relative; transition: all 0.2s ease; }
        .custom-radio-group input[type="radio"]:checked + .radio-label .custom-radio-box { background-color: #4A90E2; border-color: #4A90E2; }
        .custom-radio-group input[type="radio"]:checked + .radio-label .custom-radio-box::after { content: '✔'; color: white; font-size: 16px; position: absolute; top: 50%; left: 50%; transform: translate(-50%, -50%); }
        .form-navigation-btns { margin-top: 40px; display: flex; justify-content: space-between; align-items: center; }
        .back-btn { background: #6c757d; color: white; border: none; padding: 12px 30px; border-radius: 8px; font-size: 15px; font-weight: 500; cursor: pointer; transition: background 0.3s ease; }
        .back-btn:hover { background: #5a6268; }
        .payment-method-group { display: flex; width: 75%; margin: 0 auto 30px auto; }
        .payment-method-btn { flex: 1; padding: 15px; font-size: 16px; font-weight: 600; cursor: pointer; border: 1px solid #4A90E2; background-color: white; color: #4A90E2; transition: all 0.3s ease; border-right-width: 0; }
        .payment-method-btn:first-child { border-radius: 8px 0 0 8px; }
        .payment-method-btn:last-child { border-radius: 0 8px 8px 0; border-right-width: 1px; }
        .payment-method-btn.active, .payment-method-btn:hover { background-color: #4A90E2; color: white; }
        .payment-details-form { margin-top: 30px; }
        .payment-details-form.hidden { display: none; }
        .payment-form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 25px 40px; }
        .grid-col-span-2 { grid-column: span 2; }
        .form-group-half { width: 50%; }
        .input-group { display: flex; align-items: center; gap: 10px; }
        .input-group .form-input { text-align: center; }
        .input-group span { color: #888; font-size: 16px; flex-shrink: 0;}
        .agreement-section { margin-top: 30px; padding-top: 20px; border-top: 1px solid #eee;}
        .agreement-item { display: flex; align-items: center; margin-bottom: 15px; }
        .agreement-item label { display: flex; align-items: center; cursor: pointer; font-size: 16px; }
        .agreement-item input[type="checkbox"] { width: 20px; height: 20px; margin-right: 12px; }
        .agreement-item a { margin-left: 8px; color: #888; text-decoration: underline; font-size: 14px; cursor: pointer; }
        .agreement-item.all-agree { font-weight: 600; }
        .signature-pad { border: 1px solid #ccc; border-radius: 8px; cursor: crosshair; }
        .signature-container { position: relative; display: inline-block; }
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
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            transition: all 0.2s ease;
            z-index: 100;
        }
        .clear-signature-btn:hover {
            background: rgba(255, 255, 255, 1);
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            transform: scale(1.05);
        }
        .clear-signature-btn::before {
            content: '↻';
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
        .modal-overlay { position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); z-index: 2000; display: none; align-items: center; justify-content: center; }
        .modal-overlay.active { display: flex; }
        .modal-content { background: white; padding: 40px; border-radius: 12px; width: 90%; max-width: 600px; max-height: 80vh; overflow-y: auto; position: relative; }
        .modal-title { font-size: 20px; font-weight: 600; margin-bottom: 20px; }
        .modal-body { font-size: 14px; line-height: 1.7; color: #444; }
        .modal-body h4 { font-size: 15px; margin: 15px 0 8px 0; }
        .modal-body p { margin-bottom: 10px; }
        .modal-close-btn { position: absolute; top: 15px; right: 15px; font-size: 24px; font-weight: bold; color: #888; cursor: pointer; border: none; background: none; }

        @media (max-width: 1200px) { #donation-step1 { flex-direction: column; } .donation-categories { grid-template-columns: repeat(2, 1fr); } }
        @media (max-width: 1024px) {
            .content-wrapper { flex-direction: column; gap: 60px; text-align: center; }
            .left-content { text-align: center; }
            .services-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; }
            .donation-categories { grid-template-columns: 1fr; }
            .sponsor-form, .payment-form-grid { grid-template-columns: 1fr; }
            .grid-col-span-2 { grid-column: span 1; }
            .form-group-half { width: 100%; }
        }
        @media (max-width: 768px) {
            .nav-menu { display: none; }
            .navbar { padding: 0 15px; }
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
            .main-title { font-size: 32px; margin-bottom: 20px; }
            .content-wrapper { gap: 40px; }
            .search-container { max-width: 100%; }
            .services-grid { display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px; }
            #donation-container { margin-top: 40px; }
            .donation-title { font-size: 24px; }
            .custom-radio-group { flex-direction: column; align-items: flex-start; gap: 15px;}
            .email-group { flex-wrap: wrap; }
            .email-group #emailUser, .email-group #emailDomain { flex-basis: 45%; }
            .email-group #emailDomainSelect { flex-basis: 100%; margin-top: 10px; }
        }
    </style>
</head>
<body>
    <div class="main-background-section"></div>
    
    <header id="main-header">
        <nav class="navbar">
            <div class="navbar-left">
                <a href="/bdproject/project.jsp" class="logo"><div class="logo-icon"></div>복지 24</a>
            </div>
            <div class="nav-menu">
                <div class="nav-item"><a href="#" class="nav-link" data-menu="service">서비스</a></div>
                <div class="nav-item"><a href="#" class="nav-link" data-menu="explore">살펴보기</a></div>
                <div class="nav-item"><a href="#" class="nav-link" data-menu="volunteer">봉사하기</a></div>
                <div class="nav-item"><a href="#" class="nav-link" data-menu="donate">기부하기</a></div>
            </div>
            <div class="navbar-right">
                <div class="language-selector">
                    <svg class="navbar-icon" id="languageToggle" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor"><path d="M12 2C6.477 2 2 6.477 2 12s4.477 10 10 10 10-4.477 10-10S17.523 2 12 2zm6.93 6h-2.95a15.65 15.65 0 00-1.38-3.56A8.03 8.03 0 0118.93 8zM12 4.04c.83 1.2 1.48 2.53 1.91 3.96h-3.82c.43-1.43 1.08-2.76 1.91-3.96zM4.26 14C4.1 13.36 4 12.69 4 12s.1-1.36.26-2h3.38c-.08.66-.14 1.32-.14 2 0 .68.06 1.34.14 2H4.26zm.81 2h2.95c.32 1.25.78 2.45 1.38 3.56A7.987 7.987 0 015.07 16zm2.95-8H5.07a7.987 7.987 0 014.33-3.56A15.65 15.65 0 008.02 8zM12 19.96c-.83-1.2-1.48-2.53-1.91-3.96h3.82c-.43 1.43-1.08 2.76-1.91 3.96zM14.34 14H9.66c-.09-.66-.16-1.32-.16-2 0-.68.07-1.35.16-2h4.68c.09.65.16 1.32.16 2 0 .68-.07 1.34-.16 2zm.25 5.56c.6-1.11 1.06-2.31 1.38-3.56h2.95a8.03 8.03 0 01-4.33 3.56zM16.36 14c.08-.66.14-1.32.14-2 0-.68-.06-1.34-.14-2h3.38c.16.64.26 1.31.26 2s-.1 1.36-.26 2h-3.38z"></path></svg>
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
                <svg class="navbar-icon" id="userIcon" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" fill="currentColor" style="cursor: pointer;"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 4c1.93 0 3.5 1.57 3.5 3.5S13.93 13 12 13s-3.5-1.57-3.5-3.5S10.07 6 12 6zm0 14c-2.03 0-4.43-.82-6.14-2.88C7.55 15.8 9.68 15 12 15s4.45.8 6.14 2.12C16.43 19.18 14.03 20 12 20z"></path></svg>
            </div>
        </nav>
        <div id="mega-menu-wrapper">
            <div class="mega-menu-content">
                <div class="menu-column" data-menu-content="service">
                    <a href="/bdproject/project_detail.jsp" class="dropdown-link">
                        <span class="dropdown-link-title">복지 혜택 찾기</span>
                        <span class="dropdown-link-desc">나에게 맞는 복지 혜택을 찾아보세요.</span>
                    </a>
                    <a href="/bdproject/project_Map.jsp" class="dropdown-link">
                        <span class="dropdown-link-title">복지 지도</span>
                        <span class="dropdown-link-desc">주변의 복지시설을 지도로 확인하세요.</span>
                    </a>
                </div>
                <div class="menu-column" data-menu-content="explore">
                    <a href="#" class="dropdown-link">
                        <span class="dropdown-link-title">공지사항</span>
                        <span class="dropdown-link-desc">새로운 복지 소식을 알려드립니다.</span>
                    </a>
                     <a href="#" class="dropdown-link">
                        <span class="dropdown-link-title">자주묻는 질문</span>
                        <span class="dropdown-link-desc">궁금한 점을 빠르게 해결하세요.</span>
                    </a>
                     <a href="#" class="dropdown-link">
                        <span class="dropdown-link-title">소개</span>
                        <span class="dropdown-link-desc">복지24에 대해 알아보세요.</span>
                    </a>
                </div>
                <div class="menu-column" data-menu-content="volunteer">
                    <a href="#" class="dropdown-link">
                        <span class="dropdown-link-title">봉사 신청</span>
                        <span class="dropdown-link-desc">나에게 맞는 봉사활동을 찾아보세요.</span>
                    </a>
                    <a href="#" class="dropdown-link">
                        <span class="dropdown-link-title">봉사 기록</span>
                        <span class="dropdown-link-desc">나의 봉사활동 내역을 확인하세요.</span>
                    </a>
                </div>
                <div class="menu-column" data-menu-content="donate">
                    <a href="#" class="dropdown-link">
                        <span class="dropdown-link-title">정기 기부</span>
                        <span class="dropdown-link-desc">정기적인 후원으로 희망을 나누세요.</span>
                    </a>
                    <a href="#" class="dropdown-link">
                        <span class="dropdown-link-title">일시 기부</span>
                        <span class="dropdown-link-desc">따뜻한 마음을 한번에 전달하세요.</span>
                    </a>
                    <a href="#" class="dropdown-link">
                        <span class="dropdown-link-title">후원자 리뷰</span>
                        <span class="dropdown-link-desc">따뜻한 나눔 이야기를 들어보세요.</span>
                    </a>
                      <a href="#" class="dropdown-link">
                        <span class="dropdown-link-title">기금 사용처</span>
                        <span class="dropdown-link-desc">후원금을 투명하게 운영합니다.</span>
                    </a>
                </div>
            </div>
        </div>
    </header>

    <div class="main-content">
        <div class="main-left">
            <div class="main-title">나에게 맞는 정보,<br>한눈에 확인하세요.</div>
            <p class="main-subtitle">숨은 혜택을 찾아드립니다.</p>
            <div class="cta-buttons">
                <a href="/bdproject/project_information.jsp" class="main-cta-btn" style="text-decoration: none; display: inline-block;">나의 상황 진단하기</a>
            </div>
        </div>
       <div class="main-right">
    </div>
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
            <div class="donation-left-box"><h2 class="donation-title">기부하기</h2><p class="donation-subtitle">당신의 나눔이 모두의 행복입니다.</p><form class="donation-form" id="donationForm"><div class="form-group"><label class="form-label">기부금액 선택</label><select class="form-select" id="donationAmount"><option value="">직접입력</option><option value="5000">5,000원</option><option value="10000">10,000원</option><option value="20000">20,000원</option><option value="30000">30,000원</option><option value="50000">50,000원</option><option value="100000">100,000원</option></select></div><div class="form-group"><label class="form-label">기부금액을 입력하세요</label><input type="text" class="form-input" id="amountInput" placeholder="원" /></div><div class="donation-buttons"><button type="button" class="donation-btn" id="regularBtn">정기기부</button><button type="button" class="donation-btn" id="onetimeBtn">일시기부</button></div></form></div>
            <div class="donation-right-box"><h3 class="donation-methods-title">기부 참여 분야</h3><div class="donation-categories"><div class="donation-category" data-category="위기가정"><div class="category-icon"><i class="fas fa-home" style="color: #E74C3C; font-size: 20px;"></i></div><div class="category-content"><div class="category-title">위기가정</div><div class="category-desc">갑작스러운 어려움에 처한 가족이 다시 일어설 수 있도록 돕습니다.</div></div></div><div class="donation-category" data-category="화재피해"><div class="category-icon"><i class="fas fa-fire" style="color: #E67E22; font-size: 20px;"></i></div><div class="category-content"><div class="category-title">화재 피해 가정 돕기</div><div class="category-desc">화재로 삶의 터전을 잃은 이웃에게 희망을 전합니다.</div></div></div><div class="donation-category" data-category="자연재해"><div class="category-icon"><i class="fas fa-cloud-rain" style="color: #3498DB; font-size: 20px;"></i></div><div class="category-content"><div class="category-title">자연재해 이재민 돕기</div><div class="category-desc">자연재해로 고통받는 사람들을 위해 긴급 구호 활동을 펼칩니다.</div></div></div><div class="donation-category" data-category="의료비"><div class="category-icon"><i class="fas fa-heartbeat" style="color: #E74C3C; font-size: 20px;"></i></div><div class="category-content"><div class="category-title">긴급 의료비 지원 돕기</div><div class="category-desc">치료가 시급하지만 비용 부담이 큰 환자들에게 도움을 줍니다.</div></div></div><div class="donation-category" data-category="범죄피해"><div class="category-icon"><i class="fas fa-shield-alt" style="color: #9B59B6; font-size: 20px;"></i></div><div class="category-content"><div class="category-title">범죄 피해자 돕기</div><div class="category-desc"> 범죄로 인해 신체적, 정신적, 경제적 피해를 입은 사람들을 지원합니다.</div></div></div><div class="donation-category" data-category="가정폭력"><div class="category-icon"><i class="fas fa-hand-holding-heart" style="color: #F39C12; font-size: 20px;"></i></div><div class="category-content"><div class="category-title">가정 폭력/학대 피해자 돕기</div><div class="category-desc">가정 내 폭력과 학대로 고통받는 이들에게 안전한 보호와 자립을 돕습니다.</div></div></div><div class="donation-category" data-category="한부모"><div class="category-icon"><i class="fas fa-baby" style="color: #E91E63; font-size: 20px;"></i></div><div class="category-content"><div class="category-title">미혼 한부모 돕기</div><div class="category-desc">홀로 아이를 키우는 한부모가정이 안정적인 생활을 할 수 있도록 지원합니다.</div></div></div><div class="donation-category" data-category="노숙인"><div class="category-icon"><i class="fas fa-bed" style="color: #795548; font-size: 20px;"></i></div><div class="category-content"><div class="category-title">노숙인 돕기</div><div class="category-desc">주거 불안정에 놓인 노숙인이 자활할 수 있도록 돕습니다.</div></div></div><div class="donation-category" data-category="자살고위험"><div class="category-icon"><i class="fas fa-hands-helping" style="color: #2ECC71; font-size: 20px;"></i></div><div class="category-content"><div class="category-title">자살 고위험군 돕기</div><div class="category-desc">심리적 어려움을 겪는 사람들에게 전문적인 상담과 지원을 제공하여 삶을 지켜줍니다.</div></div></div></div><div class="next-btn-container"><button class="next-btn" id="nextBtn">후원자 정보 입력</button></div></div>
        </div>
        <div id="donation-step2" class="donation-step">
            <div class="sponsor-info-box">
                <h2 class="donation-title">후원자 정보</h2>
                <form class="sponsor-form" id="sponsorForm">
                    <div class="form-group"><label class="form-label" for="sponsorName">이름</label><input type="text" id="sponsorName" class="form-input" placeholder="이름을 입력하세요"></div>
                    <div class="form-group"><label class="form-label" for="sponsorPhone">전화번호</label><input type="text" id="sponsorPhone" class="form-input" placeholder="'-' 없이 숫자만 입력" maxlength="11"></div>
                    <div class="form-group"><label class="form-label" for="sponsorDob">생년월일</label><input type="text" id="sponsorDob" class="form-input" placeholder="8자리 입력 (예: 19900101)" maxlength="8"></div>
                    <div class="form-group"><label class="form-label" for="emailUser">이메일</label><div class="email-group"><input type="text" id="emailUser" class="form-input"><span class="email-at">@</span><input type="text" id="emailDomain" class="form-input" placeholder="직접입력"><select id="emailDomainSelect" class="form-select"><option value="">직접입력</option><option value="naver.com">naver.com</option><option value="gmail.com">gmail.com</option><option value="hanmail.net">hanmail.net</option><option value="daum.net">daum.net</option><option value="nate.com">nate.com</option></select></div></div>
                    <div class="form-group"><label class="form-label">주소</label><div class="address-row"><div class="address-group"><input type="text" id="postcode" class="form-input" placeholder="우편번호" readonly><button type="button" id="searchAddressBtn">주소검색</button></div><input type="text" id="address" class="form-input" placeholder="주소" readonly></div><input type="text" id="detailAddress" class="form-input" placeholder="상세주소"></div>
                    <div class="form-group"><label class="form-label">소식 안내</label><div class="custom-radio-group"><div><input type="radio" id="noti_mobile" name="notifications" value="mobile"><label for="noti_mobile" class="radio-label"><span class="custom-radio-box"></span> 모바일</label></div><div><input type="radio" id="noti_email" name="notifications" value="email"><label for="noti_email" class="radio-label"><span class="custom-radio-box"></span> 이메일</label></div><div><input type="radio" id="noti_post" name="notifications" value="post"><label for="noti_post" class="radio-label"><span class="custom-radio-box"></span> 우편</label></div></div></div>
                </form>
                <div class="form-navigation-btns">
                    <button class="back-btn" id="backBtn">뒤로</button>
                    <button class="next-btn" id="goToStep3Btn">다음</button>
                </div>
            </div>
        </div>
        <div id="donation-step3" class="donation-step">
            <div class="payment-info-box">
                <h2 class="donation-title">결제 수단 선택</h2>
                <div class="payment-method-group">
                    <button type="button" class="payment-method-btn active" data-target="creditCardForm">신용카드</button>
                    <button type="button" class="payment-method-btn" data-target="bankTransferForm">계좌 이체</button>
                    <button type="button" class="payment-method-btn" data-target="naverPayForm">네이버 페이</button>
                </div>

                <div id="creditCardForm" class="payment-details-form">
                    <div class="payment-form-grid">
                        <div class="form-group grid-col-span-2"><label class="form-label">카드번호</label><div class="input-group"><input type="text" class="form-input" maxlength="4" placeholder="1234"><span>-</span><input type="text" class="form-input" maxlength="4" placeholder="0000"><span>-</span><input type="text" class="form-input" maxlength="4" placeholder="0000"><span>-</span><input type="text" class="form-input" maxlength="4" placeholder="0000"></div></div>
                        <div class="form-group"><label class="form-label">유효기간</label><div class="input-group"><input type="text" class="form-input" maxlength="2" placeholder="MM"><span>/</span><input type="text" class="form-input" maxlength="2" placeholder="YY"></div></div>
                        <div class="form-group form-group-half" id="billingDateGroupCard"><label class="form-label">결제일</label><div class="input-group"><input type="text" class="billingDate form-input" placeholder="1~31"><span style="margin-left: -5px;">일</span></div></div>
                        <div class="form-group grid-col-span-2"><label class="form-label">기부금 영수증 발행</label><div class="custom-radio-group"><div><input type="radio" id="receipt_yes_card" name="receipt_card" value="yes"><label for="receipt_yes_card" class="radio-label"><span class="custom-radio-box"></span> 예</label></div><div><input type="radio" id="receipt_no_card" name="receipt_card" value="no"><label for="receipt_no_card" class="radio-label"><span class="custom-radio-box"></span> 아니오</label></div></div></div>
                    </div>
                    <div class="agreement-section" data-type="card"><div class="agreement-item all-agree"><label><input type="checkbox" class="agreeAll"> 개인정보 수집 및 이용에 모두 동의합니다.</label></div><div class="agreement-item"><label><input type="checkbox" class="agree-item"> 개인정보 수집 및 이용 동의</label><a class="view-details-btn" data-modal="modal1">상세보기</a></div><div class="agreement-item"><label><input type="checkbox" class="agree-item"> 제3자 제공 동의</label><a class="view-details-btn" data-modal="modal2">상세보기</a></div></div>
                </div>

                <div id="bankTransferForm" class="payment-details-form hidden">
                    <div class="payment-form-grid">
                       <div class="form-group"><label class="form-label">은행 선택</label><select class="form-select"><option value="">은행을 선택하세요</option><option>KB국민은행</option><option>신한은행</option><option>우리은행</option><option>하나은행</option><option>iM뱅크</option><option>SC제일은행</option><option>한국씨티은행</option><option>부산은행</option><option>경남은행</option><option>광주은행</option><option>전북은행</option><option>제주은행</option><option>NH농협은행</option><option>IBK기업은행</option><option>Sh수협은행</option><option>한국산업은행</option><option>한국수출입은행</option><option>카카오뱅크</option><option>케이뱅크</option><option>토스뱅크</option></select></div>
                       <div class="form-group"><label class="form-label">계좌번호</label><input type="text" class="form-input" placeholder="계좌번호 입력('-' 제외)"></div>
                       <div class="form-group form-group-half" id="billingDateGroupBank"><label class="form-label">결제일</label><div class="input-group"><input type="text" class="billingDate form-input" placeholder="1~31"><span>일</span></div></div>
                       <div class="form-group grid-col-span-2">
                            <div class="signature-pad-wrapper">
                                <div class="signature-container">
                                    <label class="form-label" for="bankCanvas">서명</label>
                                    <canvas class="signature-pad" id="bankCanvas" width="400" height="150"></canvas>
                                    <button type="button" class="clear-signature-btn" data-target="bankCanvas"></button>
                                </div>
                            </div>
                        </div>
                    </div>
                     <div class="agreement-section" data-type="bank"><div class="agreement-item all-agree"><label><input type="checkbox" class="agreeAll"> 개인정보 수집 및 이용에 모두 동의합니다.</label></div><div class="agreement-item"><label><input type="checkbox" class="agree-item"> 개인정보 수집 및 이용 동의</label><a class="view-details-btn" data-modal="modal1">상세보기</a></div><div class="agreement-item"><label><input type="checkbox" class="agree-item"> 제3자 제공 동의</label><a class="view-details-btn" data-modal="modal2">상세보기</a></div></div>
                </div>

                <div id="naverPayForm" class="payment-details-form hidden">
                    <div class="signature-pad-wrapper">
                        <div class="signature-container">
                            <label class="form-label" for="naverPayCanvas">서명</label>
                            <canvas class="signature-pad" id="naverPayCanvas" width="400" height="150"></canvas>
                            <button type="button" class="clear-signature-btn" data-target="naverPayCanvas"></button>
                        </div>
                    </div>
                    <div class="agreement-section" data-type="naver"><div class="agreement-item all-agree"><label><input type="checkbox" class="agreeAll"> 개인정보 수집 및 이용에 모두 동의합니다.</label></div><div class="agreement-item"><label><input type="checkbox" class="agree-item"> 개인정보 수집 및 이용 동의</label><a class="view-details-btn" data-modal="modal1">상세보기</a></div><div class="agreement-item"><label><input type="checkbox" class="agree-item"> 제3자 제공 동의</label><a class="view-details-btn" data-modal="modal2">상세보기</a></div></div>
                </div>

                <div class="form-navigation-btns">
                    <button class="back-btn" id="backToStep2Btn">뒤로</button>
                    <button class="next-btn" id="finalSubmitBtn">기부하기</button>
                </div>
            </div>
        </div>
    </div>

    <div id="modal1" class="modal-overlay"><div class="modal-content"><button class="modal-close-btn">&times;</button><h3 class="modal-title">개인정보 및 고유식별정보 수집 및 이용 동의</h3><div class="modal-body"><p>개인정보 및 고유식별정보 수집‧이용에 대한 동의를 거부할 권리가 있습니다. 단, 동의를 거부할 경우 기부신청 및 이력 확인, 기부자 서비스 등 기부신청이 거부될 수 있습니다.</p><h4>가. 개인정보 및 고유식별정보 수집‧이용 항목:</h4><p>- 고유식별정보: 주민등록번호 (기부영수증 신청 시)<br>- 필수 항목: 성명, 생년월일, 연락처, 주소<br>(신용카드 기부방식) 카드번호, 카드유효기간<br>(정기이체 기부방식) 계좌은행, 계좌번호, 예금주, 전자서명<br>- 선택 항목: 이메일</p><h4>나. 수집‧이용 목적:</h4><p>모금회에서 처리하는 기부관련 업무 (기부신청, 기부내역확인, 확인서 발급, 기부자서비스 등)</p><h4>다. 보유기간 :</h4><p>관계 법령에 의거 기부 종료 후 10년간 보존 후 파기<br>※ 개인정보의 위탁회사 및 위탁업무의 구체적인 정보는 모금회 홈페이지 [http://wwwchest.or.kr]에서 확인할 수 있습니다<br>※ 소득세법, 상속세 및 증여세법에 따라 주민등록번호의 수집․이용이 가능하며, 소득세법 시행령의 (기부금영수증 발급명세의 작성·보관의무)에 따라 보유기간을 10년으로 합니다.</p></div></div></div>
    <div id="modal2" class="modal-overlay"><div class="modal-content"><button class="modal-close-btn">&times;</button><h3 class="modal-title">개인정보 제3자 제공·이용 동의</h3><div class="modal-body"><p>개인정보 제3자 제공‧이용에 대한 동의를 거부할 권리가 있습니다. 단, 동의를 거부할 경우 기부금 신청이 거부될 수 있습니다.</p><h4>가. 제공받는 곳</h4><p>- NICE평가정보, 금융결제원, KG이니시스, 해당은행</p><h4>나. 제공 항목</h4><p>- (본인인증) 휴대전화번호<br>- (CMS 결제정보) 은행명, 계좌번호, 예금주, 생년월일<br>- (카드 결제정보) 카드번호, 유효기간, 소유주, 생년월일</p><h4>다. 제공 목적</h4><p>- 본인확인 및 기부금결제<br>- 기부안내를 위한 정보공유</p><h4>라. 제공 기간</h4><p>- 기부금결제 중단시 까지<br>- 사업종료시 까지</p></div></div></div>

    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script>
        // 다국어 지원 객체
        const translations = {
            ko: {
                // 네비바
                'nav-service': '서비스',
                'nav-explore': '살펴보기', 
                'nav-volunteer': '봉사하기',
                'nav-donate': '기부하기',
                
                // 서비스 메뉴
                'service-welfare-search': '복지 혜택 찾기',
                'service-welfare-search-desc': '나에게 맞는 복지 혜택을 찾아보세요.',
                'service-welfare-map': '복지 지도',
                'service-welfare-map-desc': '주변의 복지시설을 지도로 확인하세요.',
                
                // 살펴보기 메뉴
                'explore-notice': '공지사항',
                'explore-notice-desc': '새로운 복지 소식을 알려드립니다.',
                'explore-faq': '자주묻는 질문',
                'explore-faq-desc': '궁금한 점을 빠르게 해결하세요.',
                'explore-about': '소개',
                'explore-about-desc': '복지24에 대해 알아보세요.',
                
                // 봉사하기 메뉴
                'volunteer-apply': '봉사 신청',
                'volunteer-apply-desc': '나에게 맞는 봉사활동을 찾아보세요.',
                'volunteer-record': '봉사 기록',
                'volunteer-record-desc': '나의 봉사활동 내역을 확인하세요.',
                
                // 기부하기 메뉴
                'donate-regular': '정기 기부',
                'donate-regular-desc': '정기적인 후원으로 희망을 나누세요.',
                'donate-onetime': '일시 기부',
                'donate-onetime-desc': '따뜻한 마음을 한번에 전달하세요.',
                'donate-review': '후원자 리뷰',
                'donate-review-desc': '따뜻한 나눔 이야기를 들어보세요.',
                
                // 메인 콘텐츠
                'main-title': '나에게 맞는 정보,<br>한눈에 확인하세요.',
                'main-subtitle': '숨은 혜택을 찾아드립니다.',
                'main-cta-btn': '나의 상황 진단하기',
                
                // 기부하기 섹션
                'donation-title': '기부하기',
                'donation-subtitle': '당신의 나눔이 모두의 행복입니다.'
            },
            en: {
                // 네비바
                'nav-service': 'Services',
                'nav-explore': 'Explore',
                'nav-volunteer': 'Volunteer',
                'nav-donate': 'Donate',
                
                // 서비스 메뉴
                'service-welfare-search': 'Find Welfare Benefits',
                'service-welfare-search-desc': 'Find welfare benefits that suit you.',
                'service-welfare-map': 'Welfare Map',
                'service-welfare-map-desc': 'Check nearby welfare facilities on the map.',
                
                // 살펴보기 메뉴
                'explore-notice': 'Notice',
                'explore-notice-desc': 'Get the latest welfare news.',
                'explore-faq': 'FAQ',
                'explore-faq-desc': 'Quickly resolve your questions.',
                'explore-about': 'About',
                'explore-about-desc': 'Learn about Welfare24.',
                
                // 봉사하기 메뉴
                'volunteer-apply': 'Apply for Volunteer',
                'volunteer-apply-desc': 'Find volunteer activities that suit you.',
                'volunteer-record': 'Volunteer Record',
                'volunteer-record-desc': 'Check your volunteer activity history.',
                
                // 기부하기 메뉴
                'donate-regular': 'Regular Donation',
                'donate-regular-desc': 'Share hope through regular donations.',
                'donate-onetime': 'One-time Donation',
                'donate-onetime-desc': 'Share your warm heart at once.',
                'donate-review': 'Donor Reviews',
                'donate-review-desc': 'Listen to warm sharing stories.',
                
                // 메인 콘텐츠
                'main-title': 'Find the right information<br>for you at a glance.',
                'main-subtitle': 'We help you find hidden benefits.',
                'main-cta-btn': 'Diagnose My Situation',
                
                // 기부하기 섹션
                'donation-title': 'Donation',
                'donation-subtitle': 'Your sharing is everyone\'s happiness.'
            },
            ja: {
                // 네비바
                'nav-service': 'サービス',
                'nav-explore': '探索',
                'nav-volunteer': 'ボランティア',
                'nav-donate': '寄付',
                
                // 서비스 메뉴
                'service-welfare-search': '福祉給付を探す',
                'service-welfare-search-desc': 'あなたに合った福祉給付を見つけましょう。',
                'service-welfare-map': '福祉マップ',
                'service-welfare-map-desc': '近くの福祉施設を地図で確認しましょう。',
                
                // 살펴보기 메뉴
                'explore-notice': 'お知らせ',
                'explore-notice-desc': '最新の福祉ニュースをお届けします。',
                'explore-faq': 'よくある質問',
                'explore-faq-desc': '疑問を素早く解決しましょう。',
                'explore-about': '概要',
                'explore-about-desc': 'Welfare24について学びましょう。',
                
                // 봉사하기 메뉴
                'volunteer-apply': 'ボランティア申請',
                'volunteer-apply-desc': 'あなたに合ったボランティア活動を見つけましょう。',
                'volunteer-record': 'ボランティア記録',
                'volunteer-record-desc': 'あなたのボランティア活動履歴を確認しましょう。',
                
                // 기부하기 메뉴
                'donate-regular': '定期寄付',
                'donate-regular-desc': '定期的な支援で希望を分かち合いましょう。',
                'donate-onetime': '一時寄付',
                'donate-onetime-desc': '温かい心を一度に届けましょう。',
                'donate-review': '寄付者レビュー',
                'donate-review-desc': '温かい分かち合いの話を聞きましょう。',
                
                // 메인 콘텐츠
                'main-title': 'あなたに合った情報を<br>一目で確認しましょう。',
                'main-subtitle': '隠れた給付を見つけます。',
                'main-cta-btn': '私の状況を診断',
                
                // 기부하기 섹션
                'donation-title': '寄付',
                'donation-subtitle': 'あなたの分かち合いがみんなの幸せです。'
            },
            zh: {
                // 네비바
                'nav-service': '服务',
                'nav-explore': '浏览',
                'nav-volunteer': '志愿者',
                'nav-donate': '捐赠',
                
                // 서비스 메뉴
                'service-welfare-search': '查找福利补贴',
                'service-welfare-search-desc': '找到适合您的福利补贴。',
                'service-welfare-map': '福利地图',
                'service-welfare-map-desc': '在地图上查看附近的福利设施。',
                
                // 살펴보기 메뉴
                'explore-notice': '公告',
                'explore-notice-desc': '获取最新的福利消息。',
                'explore-faq': '常见问题',
                'explore-faq-desc': '快速解决您的疑问。',
                'explore-about': '关于',
                'explore-about-desc': '了解Welfare24。',
                
                // 봉사하기 메뉴
                'volunteer-apply': '申请志愿者',
                'volunteer-apply-desc': '找到适合您的志愿活动。',
                'volunteer-record': '志愿记录',
                'volunteer-record-desc': '查看您的志愿活动历史。',
                
                // 기부하기 메뉴
                'donate-regular': '定期捐赠',
                'donate-regular-desc': '通过定期捐赠分享希望。',
                'donate-onetime': '一次性捐赠',
                'donate-onetime-desc': '一次性传递温暖的心意。',
                'donate-review': '捐赠者评价',
                'donate-review-desc': '聆听温暖的分享故事。',
                
                // 메인 콘텐츠
                'main-title': '一目了然地<br>查看适合您的信息。',
                'main-subtitle': '我们帮您找到隐藏的福利。',
                'main-cta-btn': '诊断我的情况',
                
                // 기부하기 섹션
                'donation-title': '捐赠',
                'donation-subtitle': '您的分享是大家的幸福。'
            },
            es: {
                // 네비바
                'nav-service': 'Servicios',
                'nav-explore': 'Explorar',
                'nav-volunteer': 'Voluntario',
                'nav-donate': 'Donar',
                
                // 서비스 메뉴
                'service-welfare-search': 'Encontrar Beneficios Sociales',
                'service-welfare-search-desc': 'Encuentra beneficios sociales que se adapten a ti.',
                'service-welfare-map': 'Mapa de Bienestar',
                'service-welfare-map-desc': 'Revisa las instalaciones de bienestar cercanas en el mapa.',
                
                // 살펴보기 메뉴
                'explore-notice': 'Avisos',
                'explore-notice-desc': 'Obtén las últimas noticias de bienestar.',
                'explore-faq': 'Preguntas Frecuentes',
                'explore-faq-desc': 'Resuelve rápidamente tus preguntas.',
                'explore-about': 'Acerca de',
                'explore-about-desc': 'Aprende sobre Welfare24.',
                
                // 봉사하기 메뉴
                'volunteer-apply': 'Aplicar para Voluntario',
                'volunteer-apply-desc': 'Encuentra actividades de voluntariado que se adapten a ti.',
                'volunteer-record': 'Registro de Voluntario',
                'volunteer-record-desc': 'Revisa tu historial de actividades de voluntariado.',
                
                // 기부하기 메뉴
                'donate-regular': 'Donación Regular',
                'donate-regular-desc': 'Comparte esperanza a través de donaciones regulares.',
                'donate-onetime': 'Donación Única',
                'donate-onetime-desc': 'Comparte tu corazón cálido de una vez.',
                'donate-review': 'Reseñas de Donantes',
                'donate-review-desc': 'Escucha historias cálidas de compartir.',
                
                // 메인 콘텐츠
                'main-title': 'Encuentra la información correcta<br>para ti de un vistazo.',
                'main-subtitle': 'Te ayudamos a encontrar beneficios ocultos.',
                'main-cta-btn': 'Diagnosticar Mi Situación',
                
                // 기부하기 섹션
                'donation-title': 'Donación',
                'donation-subtitle': 'Tu compartir es la felicidad de todos.'
            }
        };

        let currentLanguage = localStorage.getItem('preferred-language') || 'ko';

        // 언어 전환 함수

        // 페이지 언어 업데이트 함수
        function updatePageLanguage() {
            const t = translations[currentLanguage];
            
            // 네비바 메뉴 업데이트
            document.querySelector('[data-menu="service"]').textContent = t['nav-service'];
            document.querySelector('[data-menu="explore"]').textContent = t['nav-explore'];
            document.querySelector('[data-menu="volunteer"]').textContent = t['nav-volunteer'];
            document.querySelector('[data-menu="donate"]').textContent = t['nav-donate'];
            
            // 드롭다운 메뉴 업데이트 - 서비스
            const serviceMenu = document.querySelector('[data-menu-content="service"]');
            const serviceLinks = serviceMenu.querySelectorAll('.dropdown-link');
            serviceLinks[0].querySelector('.dropdown-link-title').textContent = t['service-welfare-search'];
            serviceLinks[0].querySelector('.dropdown-link-desc').textContent = t['service-welfare-search-desc'];
            serviceLinks[1].querySelector('.dropdown-link-title').textContent = t['service-welfare-map'];
            serviceLinks[1].querySelector('.dropdown-link-desc').textContent = t['service-welfare-map-desc'];
            
            // 드롭다운 메뉴 업데이트 - 살펴보기
            const exploreMenu = document.querySelector('[data-menu-content="explore"]');
            const exploreLinks = exploreMenu.querySelectorAll('.dropdown-link');
            exploreLinks[0].querySelector('.dropdown-link-title').textContent = t['explore-notice'];
            exploreLinks[0].querySelector('.dropdown-link-desc').textContent = t['explore-notice-desc'];
            exploreLinks[1].querySelector('.dropdown-link-title').textContent = t['explore-faq'];
            exploreLinks[1].querySelector('.dropdown-link-desc').textContent = t['explore-faq-desc'];
            exploreLinks[2].querySelector('.dropdown-link-title').textContent = t['explore-about'];
            exploreLinks[2].querySelector('.dropdown-link-desc').textContent = t['explore-about-desc'];
            
            // 드롭다운 메뉴 업데이트 - 봉사하기
            const volunteerMenu = document.querySelector('[data-menu-content="volunteer"]');
            const volunteerLinks = volunteerMenu.querySelectorAll('.dropdown-link');
            volunteerLinks[0].querySelector('.dropdown-link-title').textContent = t['volunteer-apply'];
            volunteerLinks[0].querySelector('.dropdown-link-desc').textContent = t['volunteer-apply-desc'];
            volunteerLinks[1].querySelector('.dropdown-link-title').textContent = t['volunteer-record'];
            volunteerLinks[1].querySelector('.dropdown-link-desc').textContent = t['volunteer-record-desc'];
            
            // 드롭다운 메뉴 업데이트 - 기부하기
            const donateMenu = document.querySelector('[data-menu-content="donate"]');
            const donateLinks = donateMenu.querySelectorAll('.dropdown-link');
            donateLinks[0].querySelector('.dropdown-link-title').textContent = t['donate-regular'];
            donateLinks[0].querySelector('.dropdown-link-desc').textContent = t['donate-regular-desc'];
            donateLinks[1].querySelector('.dropdown-link-title').textContent = t['donate-onetime'];
            donateLinks[1].querySelector('.dropdown-link-desc').textContent = t['donate-onetime-desc'];
            donateLinks[2].querySelector('.dropdown-link-title').textContent = t['donate-review'];
            donateLinks[2].querySelector('.dropdown-link-desc').textContent = t['donate-review-desc'];
            
            // 메인 콘텐츠 업데이트
            document.querySelector('.main-title').innerHTML = t['main-title'];
            document.querySelector('.main-subtitle').textContent = t['main-subtitle'];
            document.querySelector('.main-cta-btn').textContent = t['main-cta-btn'];
            
            // 기부하기 섹션 업데이트
            const donationTitle = document.querySelector('.donation-title');
            const donationSubtitle = document.querySelector('.donation-subtitle');
            if (donationTitle) donationTitle.textContent = t['donation-title'];
            if (donationSubtitle) donationSubtitle.textContent = t['donation-subtitle'];
            
            // 지구본 아이콘 툴팁 업데이트
            const globeIcon = document.querySelector('.navbar-icon:first-child');
            if (globeIcon) {
                globeIcon.title = currentLanguage === 'ko' ? 'Switch to English' : '한국어로 전환';
            }
        }

        document.addEventListener('DOMContentLoaded', () => {
            
            // --- 다국어 초기화 ---
            // 페이지 로드 시 저장된 언어 적용
            updatePageLanguage();
            
            // --- 스크롤 애니메이션 ---
            // 공통 관찰자 옵션
            const observerOptions = {
                root: null,
                rootMargin: '0px 0px -20% 0px', // 20% 정도 올라왔을 때 애니메이션 시작
                threshold: 0.1
            };
            
            // 공통 관찰자 콜백
            const observerCallback = (entries) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        // 화면에 들어왔을 때 애니메이션 클래스 추가
                        entry.target.classList.add('animate-in');
                        console.log(`${entry.target.className} 섹션 나타남`);
                    } else {
                        // 화면에서 벗어났을 때 애니메이션 클래스 제거
                        entry.target.classList.remove('animate-in');
                        console.log(`${entry.target.className} 섹션 사라짐`);
                    }
                });
            };
            
            const observer = new IntersectionObserver(observerCallback, observerOptions);
            
            // 메인 콘텐츠 애니메이션
            const mainContent = document.querySelector('.main-content');
            if (mainContent) {
                observer.observe(mainContent);
                console.log('Main content 스크롤 애니메이션 설정 완료');
            }
            
            // donation 컨테이너 애니메이션
            const donationContainer = document.getElementById('donation-container');
            if (donationContainer) {
                observer.observe(donationContainer);
                console.log('Donation container 스크롤 애니메이션 설정 완료');
            }
            
            // 지구본 아이콘 및 언어 드롭다운 이벤트 (5개 언어 지원)
            const globeIcon = document.getElementById('languageToggle');
            const languageDropdown = document.getElementById('languageDropdown');
            console.log('지구본 아이콘:', globeIcon);
            console.log('언어 드롭다운:', languageDropdown);
            
            if (globeIcon && languageDropdown) {
                console.log('지구본 아이콘과 드롭다운을 모두 찾았습니다.');
                
                // 지구본 아이콘 클릭 시 드롭다운 토글
                globeIcon.addEventListener('click', (e) => {
                    e.preventDefault();
                    e.stopPropagation();
                    console.log('지구본 클릭됨! 드롭다운 토글');
                    console.log('현재 드롭다운 display 상태:', languageDropdown.style.display);
                    
                    const isVisible = languageDropdown.style.display === 'block';
                    
                    if (isVisible) {
                        // 드롭다운 숨기기
                        languageDropdown.style.opacity = '0';
                        languageDropdown.style.visibility = 'hidden';
                        languageDropdown.style.transform = 'translateY(-10px)';
                        setTimeout(() => {
                            languageDropdown.style.display = 'none';
                        }, 200);
                    } else {
                        // 드롭다운 보이기
                        languageDropdown.style.display = 'block';
                        setTimeout(() => {
                            languageDropdown.style.opacity = '1';
                            languageDropdown.style.visibility = 'visible';
                            languageDropdown.style.transform = 'translateY(0)';
                        }, 10);
                    }
                    
                    console.log('드롭다운 상태 토글 완료');
                    
                });
                
                // 언어 옵션 클릭 이벤트
                const languageOptions = languageDropdown.querySelectorAll('.language-option');
                languageOptions.forEach(option => {
                    option.addEventListener('click', (e) => {
                        e.preventDefault();
                        e.stopPropagation();
                        const selectedLanguage = option.getAttribute('data-lang');
                        console.log('선택된 언어:', selectedLanguage);
                        
                        // 언어 변경
                        currentLanguage = selectedLanguage;
                        localStorage.setItem('preferred-language', currentLanguage);
                        updatePageLanguage();
                        
                        // 활성 언어 표시 업데이트
                        updateActiveLanguage(selectedLanguage);
                        
                        // 드롭다운 닫기 (애니메이션 포함)
                        languageDropdown.style.opacity = '0';
                        languageDropdown.style.visibility = 'hidden';
                        languageDropdown.style.transform = 'translateY(-10px)';
                        setTimeout(() => {
                            languageDropdown.style.display = 'none';
                        }, 200);
                    });
                });
                
                // 다른 곳 클릭 시 드롭다운 닫기
                document.addEventListener('click', (e) => {
                    if (!globeIcon.contains(e.target) && !languageDropdown.contains(e.target)) {
                        if (languageDropdown.style.display === 'block') {
                            languageDropdown.style.opacity = '0';
                            languageDropdown.style.visibility = 'hidden';
                            languageDropdown.style.transform = 'translateY(-10px)';
                            setTimeout(() => {
                                languageDropdown.style.display = 'none';
                            }, 200);
                        }
                    }
                });
                
                globeIcon.style.cursor = 'pointer';
                globeIcon.title = '언어 선택 / Select Language';
                console.log('지구본 아이콘에 드롭다운 이벤트 리스너 추가 완료');
                
                // 초기 활성 언어 표시
                updateActiveLanguage(currentLanguage);
            } else {
                console.error('지구본 아이콘 또는 언어 드롭다운을 찾을 수 없습니다.');
                console.error('globeIcon:', globeIcon);
                console.error('languageDropdown:', languageDropdown);
            }
            
            // 활성 언어 표시 업데이트 함수
            function updateActiveLanguage(language) {
                const languageOptions = document.querySelectorAll('.language-option');
                languageOptions.forEach(option => {
                    if (option.getAttribute('data-lang') === language) {
                        option.classList.add('active');
                    } else {
                        option.classList.remove('active');
                    }
                });
            }
            
            // --- 네비바 드롭다운 메뉴 ---
            const header = document.getElementById('main-header');
            const navLinks = document.querySelectorAll('.nav-link[data-menu]');
            const megaMenuWrapper = document.getElementById('mega-menu-wrapper');
            const menuColumns = document.querySelectorAll('.menu-column');
            let menuTimeout;

            const showMenu = (targetMenu) => {
                clearTimeout(menuTimeout);
                megaMenuWrapper.classList.add('active');
                
                menuColumns.forEach(col => {
                    if (col.dataset.menuContent === targetMenu) {
                        col.style.display = 'flex';
                    } else {
                        col.style.display = 'none';
                    }
                });

                navLinks.forEach(link => {
                    if (link.dataset.menu === targetMenu) {
                        link.classList.add('active');
                    } else {
                        link.classList.remove('active');
                    }
                });
            };

            const hideMenu = () => {
                menuTimeout = setTimeout(() => {
                    megaMenuWrapper.classList.remove('active');
                    navLinks.forEach(link => link.classList.remove('active'));
                }, 200);
            };

            navLinks.forEach(link => {
                link.addEventListener('mouseenter', () => {
                    showMenu(link.dataset.menu);
                });
            });

            header.addEventListener('mouseleave', () => {
                hideMenu();
            });
            // --- 네비바 로직 끝 ---


            const donationFormContainer = document.getElementById('donation-container');
            if (!donationFormContainer) return;

            let donationData = { donationType: '', amount: '', selectedCategory: '' };

            const initSignaturePad = (canvasId) => {
                const canvas = document.getElementById(canvasId);
                if (!canvas) return;
                const ctx = canvas.getContext('2d');
                let drawing = false;
                const startDrawing = (e) => { drawing = true; draw(e); };
                const stopDrawing = () => { drawing = false; ctx.beginPath(); };
                const getPos = (e) => {
                    const rect = canvas.getBoundingClientRect();
                    const clientX = e.clientX || e.touches[0].clientX;
                    const clientY = e.clientY || e.touches[0].clientY;
                    return { x: clientX - rect.left, y: clientY - rect.top };
                };
                const draw = (e) => {
                    if (!drawing) return;
                    e.preventDefault();
                    const { x, y } = getPos(e);
                    ctx.lineWidth = 2;
                    ctx.lineCap = 'round';
                    ctx.strokeStyle = '#000';
                    ctx.lineTo(x, y);
                    ctx.stroke();
                    ctx.beginPath();
                    ctx.moveTo(x, y);
                };
                canvas.addEventListener('mousedown', startDrawing);
                canvas.addEventListener('mouseup', stopDrawing);
                canvas.addEventListener('mousemove', draw);
                canvas.addEventListener('mouseleave', stopDrawing);
                canvas.addEventListener('touchstart', startDrawing);
                canvas.addEventListener('touchend', stopDrawing);
                canvas.addEventListener('touchmove', draw);
            };
            initSignaturePad('bankCanvas');
            initSignaturePad('naverPayCanvas');

            document.querySelectorAll('.clear-signature-btn').forEach(button => {
                button.addEventListener('click', () => {
                    const canvas = document.getElementById(button.dataset.target);
                    const ctx = canvas.getContext('2d');
                    ctx.clearRect(0, 0, canvas.width, canvas.height);
                });
            });

            document.querySelectorAll('.billingDate').forEach(input => {
                input.addEventListener('input', (e) => {
                    let value = e.target.value.replace(/[^0-9]/g, '');
                    if (value > 31) value = 31;
                    e.target.value = value;
                });
            });

            document.querySelectorAll('.agreement-section').forEach(section => {
                const agreeAll = section.querySelector('.agreeAll');
                const agreeItems = section.querySelectorAll('.agree-item');
                if(!agreeAll) return;
                agreeAll.addEventListener('change', (e) => {
                    agreeItems.forEach(checkbox => checkbox.checked = e.target.checked);
                });
                agreeItems.forEach(checkbox => {
                    checkbox.addEventListener('change', () => {
                        agreeAll.checked = [...agreeItems].every(item => item.checked);
                    });
                });
            });

            const detailButtons = document.querySelectorAll('.view-details-btn');
            const modals = document.querySelectorAll('.modal-overlay');
            const closeButtons = document.querySelectorAll('.modal-close-btn');
            detailButtons.forEach(button => button.addEventListener('click', () => {
                document.getElementById(button.dataset.modal).classList.add('active');
            }));
            const closeModal = () => modals.forEach(modal => modal.classList.remove('active'));
            closeButtons.forEach(button => button.addEventListener('click', closeModal));
            modals.forEach(modal => modal.addEventListener('click', (e) => {
                if (e.target === modal) closeModal();
            }));

            const amountInput = document.getElementById('amountInput');
            const regularBtn = document.getElementById('regularBtn');
            const onetimeBtn = document.getElementById('onetimeBtn');
            const goToStep3Btn = document.getElementById('goToStep3Btn');

            if(regularBtn) regularBtn.addEventListener('click', () => { donationData.donationType = 'regular'; });
            if(onetimeBtn) onetimeBtn.addEventListener('click', () => { donationData.donationType = 'onetime'; });

            if(goToStep3Btn) goToStep3Btn.addEventListener('click', () => {
                const addressValue = document.getElementById('address').value;
                if (!document.getElementById('sponsorName').value || !document.getElementById('sponsorPhone').value) { alert('이름과 전화번호는 필수 입력 항목입니다.'); return; }
                if (!addressValue) { alert('주소를 입력해주세요.'); return; }

                document.querySelectorAll('#billingDateGroupCard, #billingDateGroupBank').forEach(group => {
                    group.style.display = donationData.donationType === 'regular' ? 'flex' : 'none';
                });
                donationFormContainer.classList.remove('view-step2');
                donationFormContainer.classList.add('view-step3');
            });

            const finalSubmitBtn = document.getElementById('finalSubmitBtn');
            if(finalSubmitBtn) finalSubmitBtn.addEventListener('click', () => {
                const activeForm = document.querySelector('.payment-details-form:not(.hidden)');
                const activeAgreement = activeForm.querySelector('.agreement-section .agreeAll');

                if (!activeAgreement || !activeAgreement.checked) {
                    alert('개인정보 수집 및 이용에 모두 동의해야 기부가 가능합니다.');
                    return;
                }

                if (activeForm.id === 'creditCardForm') {
                    const cardNumbers = activeForm.querySelectorAll('.input-group input[type="text"]');
                    const cardInputs = Array.from(cardNumbers).slice(0, 4);
                    const expMonth = Array.from(cardNumbers)[4];
                    const expYear = Array.from(cardNumbers)[5];

                    for (let i = 0; i < 4; i++) {
                        if (!cardInputs[i].value || cardInputs[i].value.length !== 4) {
                            alert('카드번호를 정확히 입력해주세요.');
                            cardInputs[i].focus();
                            return;
                        }
                    }

                    if (!expMonth.value || expMonth.value.length !== 2) {
                        alert('유효기간 월을 정확히 입력해주세요 (MM).');
                        expMonth.focus();
                        return;
                    }
                    if (!expYear.value || expYear.value.length !== 2) {
                        alert('유효기간 년을 정확히 입력해주세요 (YY).');
                        expYear.focus();
                        return;
                    }
                    const monthNum = parseInt(expMonth.value);
                    if (monthNum < 1 || monthNum > 12) {
                        alert('유효기간 월은 01~12 사이의 값이어야 합니다.');
                        expMonth.focus();
                        return;
                    }
                }
                else if (activeForm.id === 'bankTransferForm') {
                    const bankSelect = activeForm.querySelector('select.form-select');
                    const accountNumber = activeForm.querySelector('input[placeholder*="계좌번호"]');
                    const signatureCanvas = document.getElementById('bankCanvas');

                    if (!bankSelect.value) {
                        alert('은행을 선택해주세요.');
                        bankSelect.focus();
                        return;
                    }

                    if (!accountNumber.value || accountNumber.value.trim() === '') {
                        alert('계좌번호를 입력해주세요.');
                        accountNumber.focus();
                        return;
                    }
                    
                    const ctx = signatureCanvas.getContext('2d');
                    const imageData = ctx.getImageData(0, 0, signatureCanvas.width, signatureCanvas.height);
                    const hasSignature = imageData.data.some((channel, index) => index % 4 !== 3 && channel !== 0);

                    if (!hasSignature) {
                        alert('서명을 해주세요.');
                        return;
                    }
                }
                else if (activeForm.id === 'naverPayForm') {
                    const signatureCanvas = document.getElementById('naverPayCanvas');
                    const ctx = signatureCanvas.getContext('2d');
                    const imageData = ctx.getImageData(0, 0, signatureCanvas.width, signatureCanvas.height);
                    const hasSignature = imageData.data.some((channel, index) => index % 4 !== 3 && channel !== 0);

                    if (!hasSignature) {
                        alert('서명을 해주세요.');
                        return;
                    }
                    
                    alert('네이버 로그인 페이지로 이동합니다.');
                    window.open('https://nid.naver.com/nidlogin.login', '_blank');
                    return;
                }

                alert(`${document.getElementById('sponsorName').value}님, 기부가 완료되었습니다.`);
            });

            const paymentMethodBtns = document.querySelectorAll('.payment-method-btn');
            paymentMethodBtns.forEach(btn => {
                btn.addEventListener('click', () => {
                    paymentMethodBtns.forEach(b => b.classList.remove('active'));
                    btn.classList.add('active');
                    document.querySelectorAll('.payment-details-form').forEach(form => form.classList.add('hidden'));
                    document.getElementById(btn.dataset.target).classList.remove('hidden');
                });
            });

            const donationAmount = document.getElementById('donationAmount');
            const donationCategories = document.querySelectorAll('.donation-category');
            const nextBtn = document.getElementById('nextBtn');
            const backBtn = document.getElementById('backBtn');
            const emailDomainSelect = document.getElementById('emailDomainSelect');
            const searchAddressBtn = document.getElementById('searchAddressBtn');
            const notificationRadios = document.querySelectorAll('input[name="notifications"]');
            const backToStep2Btn = document.getElementById('backToStep2Btn');

            let lastCheckedRadio = document.querySelector('input[name="notifications"]:checked');
            if(notificationRadios.length > 0) {
                notificationRadios.forEach(radio => {
                    radio.addEventListener('click', (e) => {
                        if (e.target === lastCheckedRadio) { e.target.checked = false; lastCheckedRadio = null; }
                        else { lastCheckedRadio = e.target; }
                    });
                });
            }

            const validateStep1 = () => {
                const amountValue = amountInput.value.replace(/,/g, '');
                if (!donationData.donationType) { alert('기부 방식을 선택해주세요.'); return false; }
                if (!amountValue || parseInt(amountValue) <= 0) { alert('기부 금액을 입력해주세요.'); amountInput.focus(); return false; }
                const selectedCategory = document.querySelector('.donation-category.selected');
                if (!selectedCategory) { alert('기부 참여 분야를 선택해주세요.'); return false; }
                donationData.amount = amountValue;
                donationData.selectedCategory = selectedCategory.dataset.category;
                return true;
            };

            if(nextBtn) nextBtn.addEventListener('click', () => { if (validateStep1()) { donationFormContainer.classList.add('view-step2'); } });
            if(backBtn) backBtn.addEventListener('click', () => { donationFormContainer.classList.remove('view-step2'); });
            if(backToStep2Btn) backToStep2Btn.addEventListener('click', () => {
                donationFormContainer.classList.remove('view-step3');
                donationFormContainer.classList.add('view-step2');
            });
            if(donationAmount) donationAmount.addEventListener('change', (e) => {
                const selectedValue = e.target.value;
                if (selectedValue) {
                    amountInput.value = parseInt(selectedValue).toLocaleString('ko-KR');
                    amountInput.readOnly = true; amountInput.classList.add('disabled');
                } else {
                    amountInput.value = ''; amountInput.readOnly = false;
                    amountInput.classList.remove('disabled'); amountInput.focus();
                }
            });
            if(amountInput) amountInput.addEventListener('input', (e) => {
                let value = e.target.value.replace(/[^0-9]/g, '');
                e.target.value = value ? parseInt(value, 10).toLocaleString('ko-KR') : '';
            });
            if(regularBtn) regularBtn.addEventListener('click', () => {
                regularBtn.classList.add('active'); onetimeBtn.classList.remove('active');
                donationData.donationType = 'regular';
            });
            if(onetimeBtn) onetimeBtn.addEventListener('click', () => {
                onetimeBtn.classList.add('active'); regularBtn.classList.remove('active');
                donationData.donationType = 'onetime';
            });
            if(donationCategories.length > 0) {
                donationCategories.forEach(category => {
                    category.addEventListener('click', () => {
                        // 클릭된 카테고리가 이미 선택되어 있는지 확인
                        if (category.classList.contains('selected')) {
                            // 이미 선택된 경우 선택 해제 (토글)
                            category.classList.remove('selected');
                        } else {
                            // 선택되지 않은 경우 다른 모든 카테고리 선택 해제하고 현재 카테고리 선택
                            donationCategories.forEach(c => c.classList.remove('selected'));
                            category.classList.add('selected');
                        }
                    });
                });
            }
            if(emailDomainSelect) emailDomainSelect.addEventListener('change', (e) => {
                const selectedValue = e.target.value;
                const emailDomain = document.getElementById('emailDomain');
                emailDomain.value = selectedValue ? selectedValue : '';
                emailDomain.readOnly = !!selectedValue;
                emailDomain.classList.toggle('disabled', !!selectedValue);
                if (!selectedValue) emailDomain.focus();
            });
            if(searchAddressBtn) searchAddressBtn.addEventListener('click', () => {
                new daum.Postcode({
                    oncomplete: function(data) {
                        document.getElementById('postcode').value = data.zonecode;
                        document.getElementById('address').value = data.address;
                        document.getElementById('detailAddress').focus();
                    }
                }).open();
            });
            
            // 인기 복지 혜택 로드
            loadPopularWelfareServices();
        });
        
        // 인기 복지 서비스 조회 함수
        function loadPopularWelfareServices() {
            console.log('인기 복지 서비스 로딩 시작');
            const popularList = document.getElementById('popular-welfare-list');
            
            fetch('/bdproject/welfare/popular')
                .then(response => {
                    console.log('API 응답 상태:', response.status, response.statusText);
                    if (!response.ok) {
                        throw new Error('서버 응답 오류: ' + response.status);
                    }
                    return response.json();
                })
                .then(data => {
                    console.log('받은 데이터:', data);
                    console.log('데이터 타입:', typeof data, '배열 여부:', Array.isArray(data));
                    displayPopularWelfareServices(data);
                })
                .catch(error => {
                    console.error('인기 복지 서비스 조회 오류:', error);
                    popularList.innerHTML = 
                        '<div class="loading-popular">' +
                            '<p style="color: #dc3545;">인기 복지 혜택을 불러올 수 없습니다.</p>' +
                            '<p style="color: #666; font-size: 12px;">오류: ' + error.message + '</p>' +
                        '</div>';
                });
        }
        
        // 인기 복지 서비스 표시 함수
        function displayPopularWelfareServices(services) {
            const popularList = document.getElementById('popular-welfare-list');
            
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
            const container = document.createElement('div');
            container.className = 'popular-welfare-container';
            
            // 이전/다음 버튼 생성
            const prevBtn = document.createElement('button');
            prevBtn.className = 'slider-nav-btn slider-prev';
            prevBtn.innerHTML = '‹';
            
            const nextBtn = document.createElement('button');
            nextBtn.className = 'slider-nav-btn slider-next';
            nextBtn.innerHTML = '›';
            
            // 슬라이더 래퍼 생성
            const sliderWrapper = document.createElement('div');
            sliderWrapper.className = 'welfare-slider-wrapper';
            
            // 슬라이더 생성
            const slider = document.createElement('div');
            slider.className = 'welfare-slider';
            
            // 카드들 생성
            sortedServices.forEach((service, index) => {
                const rank = index + 1;
                const views = parseInt(service.inqNum) || 0;
                const isTop3 = rank <= 3;
                
                // JSP EL 충돌 방지를 위해 변수로 분리
                const rankClass = isTop3 ? 'top-3' : '';
                const serviceName = service.servNm || '서비스명 없음';
                const jurMnofNm = service.jurMnofNm || '';
                const jurOrgNm = service.jurOrgNm || '';
                const sourceClass = service.source === '중앙부처' ? 'source-central' : 'source-local';
                const sourceText = service.source || '출처 불명';
                
                const item = document.createElement('div');
                item.className = 'popular-welfare-item';
                item.innerHTML = 
                    '<div class="welfare-rank ' + rankClass + '">' + rank + '</div>' +
                    '<div class="welfare-info">' +
                        '<div class="welfare-name">' + serviceName + '</div>' +
                        '<div class="welfare-org">' + jurMnofNm + ' ' + jurOrgNm + '</div>' +
                        '<div class="welfare-views">조회수: ' + views.toLocaleString() + '회</div>' +
                        '<span class="welfare-source ' + sourceClass + '">' + sourceText + '</span>' +
                    '</div>';
                
                // 클릭 시 상세 정보 표시
                item.addEventListener('click', () => {
                    if (service.servDtlLink) {
                        window.open(service.servDtlLink, '_blank');
                    } else {
                        alert('해당 서비스의 상세 정보가 없습니다.');
                    }
                });
                
                slider.appendChild(item);
            });
            
            // 슬라이더 변수
            let currentSlide = 0;
            const itemsPerSlide = 3;
            const totalSlides = Math.max(0, Math.ceil(sortedServices.length - itemsPerSlide + 1));
            
            // 슬라이더 이동 함수
            function moveSlider(direction) {
                if (direction === 'next' && currentSlide < totalSlides - 1) {
                    currentSlide++;
                } else if (direction === 'prev' && currentSlide > 0) {
                    currentSlide--;
                }
                
                const translateX = currentSlide * (100 / itemsPerSlide);
                slider.style.transform = 'translateX(-' + translateX + '%)';
                
                // 버튼 상태 업데이트
                prevBtn.disabled = currentSlide === 0;
                nextBtn.disabled = currentSlide >= totalSlides - 1;
            }
            
            // 버튼 이벤트 리스너
            prevBtn.addEventListener('click', () => moveSlider('prev'));
            nextBtn.addEventListener('click', () => moveSlider('next'));
            
            // 초기 버튼 상태 설정
            moveSlider();
            
            // DOM에 추가
            sliderWrapper.appendChild(slider);
            container.appendChild(prevBtn);
            container.appendChild(nextBtn);
            container.appendChild(sliderWrapper);
            
            popularList.innerHTML = '';
            popularList.appendChild(container);
        }
        
        // 사용자 아이콘 클릭 이벤트
        document.addEventListener('DOMContentLoaded', function() {
            // 사용자 아이콘 클릭 시 projectLogin.jsp로 이동
            const userIcon = document.getElementById('userIcon');
            if (userIcon) {
                userIcon.addEventListener('click', function(e) {
                    e.preventDefault();
                    window.location.href = '/bdproject/projectLogin.jsp';
                });
            }
        
        // 입력 필드 검증 로직
            // 이름 필드에서 숫자 입력 방지
            const sponsorNameInput = document.getElementById('sponsorName');
            if (sponsorNameInput) {
                sponsorNameInput.addEventListener('keypress', function(e) {
                    // 숫자만 차단 (한글, 영문자, 공백, 특수문자는 허용)
                    if (/[0-9]/.test(e.key)) {
                        e.preventDefault();
                    }
                });
                
                sponsorNameInput.addEventListener('input', function(e) {
                    // 숫자만 제거 (한글, 영문, 공백, 일반적인 특수문자는 허용)
                    this.value = this.value.replace(/[0-9]/g, '');
                });
            }
            
            // 생년월일 입력 필드에 숫자만 입력 가능하도록 제한 및 유효성 검증
            const sponsorDobInput = document.getElementById('sponsorDob');
            if (sponsorDobInput) {
                // 키 입력 시 숫자만 허용
                sponsorDobInput.addEventListener('keypress', function(e) {
                    // 숫자(0-9)와 백스페이스, 탭, 엔터, Delete, 방향키만 허용
                    if (!/[0-9]/.test(e.key) && 
                        !['Backspace', 'Tab', 'Enter', 'Delete', 'ArrowLeft', 'ArrowRight', 'ArrowUp', 'ArrowDown'].includes(e.key)) {
                        e.preventDefault();
                    }
                });
                
                // 붙여넣기 시에도 숫자만 허용
                sponsorDobInput.addEventListener('paste', function(e) {
                    e.preventDefault();
                    const pasteData = (e.clipboardData || window.clipboardData).getData('text');
                    const numbersOnly = pasteData.replace(/[^0-9]/g, '');
                    if (numbersOnly.length <= 8) {
                        this.value = numbersOnly;
                        this.validateBirthDate();
                    }
                });
                
                // 입력 값 검증 및 정리
                sponsorDobInput.addEventListener('input', function(e) {
                    // 숫자가 아닌 문자 제거
                    let value = this.value.replace(/[^0-9]/g, '');
                    // 8자리로 제한
                    if (value.length > 8) {
                        value = value.slice(0, 8);
                    }
                    this.value = value;
                    this.validateBirthDate();
                });
                
                // 생년월일 유효성 검증 함수 추가
                sponsorDobInput.validateBirthDate = function() {
                    const value = this.value;
                    let isValid = true;
                    let errorMessage = '';
                    
                    // 8자리가 완성되었을 때만 검증
                    if (value.length === 8) {
                        const year = parseInt(value.substring(0, 4));
                        const month = parseInt(value.substring(4, 6));
                        const day = parseInt(value.substring(6, 8));
                        
                        // 연도 검증 (1900~2025)
                        if (year < 1900 || year > 2025) {
                            isValid = false;
                            errorMessage = '연도는 1900~2025년 사이여야 합니다.';
                        }
                        // 월 검증 (01~12)
                        else if (month < 1 || month > 12) {
                            isValid = false;
                            errorMessage = '월은 01~12 사이여야 합니다.';
                        }
                        // 일 검증 (1~31, 월별 일수 고려)
                        else if (day < 1 || day > 31) {
                            isValid = false;
                            errorMessage = '일은 01~31 사이여야 합니다.';
                        }
                        // 월별 일수 정확한 검증
                        else {
                            const daysInMonth = new Date(year, month, 0).getDate();
                            if (day > daysInMonth) {
                                isValid = false;
                                errorMessage = year + '년 ' + month + '월은 ' + daysInMonth + '일까지만 있습니다.';
                            }
                        }
                        
                        // 오류 메시지 표시/제거
                        let errorDiv = this.parentNode.querySelector('.error-message');
                        if (!isValid) {
                            if (!errorDiv) {
                                errorDiv = document.createElement('div');
                                errorDiv.className = 'error-message';
                                errorDiv.style.color = 'red';
                                errorDiv.style.fontSize = '12px';
                                errorDiv.style.marginTop = '5px';
                                this.parentNode.appendChild(errorDiv);
                            }
                            errorDiv.textContent = errorMessage;
                            this.style.borderColor = 'red';
                        } else {
                            if (errorDiv) {
                                errorDiv.remove();
                            }
                            this.style.borderColor = '';
                        }
                    } else {
                        // 8자리가 아닐 때는 오류 메시지 제거
                        let errorDiv = this.parentNode.querySelector('.error-message');
                        if (errorDiv) {
                            errorDiv.remove();
                        }
                        this.style.borderColor = '';
                    }
                };
            }
        });
    </script>
</body>
</html>