<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // 관리자인 경우 관리자 페이지로 리다이렉트
    String userRole = (String) session.getAttribute("role");
    if ("ADMIN".equals(userRole)) {
        response.sendRedirect("admin");
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
    <style>
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

        /* 네비게이션 바 */
        #main-header {
            position: sticky;
            top: 0;
            z-index: 1000;
            background-color: white;
            box-shadow: 0 2px 4px rgba(0,0,0,0.05);
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
            background-image: url('resources/image/복지로고.png');
            background-size: contain;
            background-repeat: no-repeat;
            background-position: center;
        }

        .logo-text {
            font-size: 24px;
            font-weight: 700;
            color: #333;
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
            transition: color 0.2s;
        }

        .navbar-icon:hover {
            color: #4A90E2;
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
            color: #4A90E2;
        }

        /* 메가 메뉴 */
        #mega-menu-wrapper {
            position: absolute;
            width: 100%;
            background-color: white;
            color: #333;
            left: 0;
            top: 60px;
            max-height: 0;
            overflow: hidden;
            transition: max-height 0.4s ease-in-out, padding 0.4s ease-in-out, border-top 0.4s ease-in-out;
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
            background-color: #4A90E2;
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

        /* 메인 컨테이너 */
        .main-container {
            display: flex;
            max-width: 1400px;
            margin: 0 auto;
            min-height: calc(100vh - 60px);
        }

        /* 사이드바 */
        .sidebar {
            width: 280px;
            background: white;
            border-right: 1px solid #e9ecef;
            padding: 30px 0;
        }

        .sidebar-header {
            padding: 0 30px 20px;
            border-bottom: 1px solid #e9ecef;
        }

        .user-profile {
            display: flex;
            align-items: center;
            gap: 15px;
            margin-bottom: 15px;
        }

        .user-avatar {
            width: 60px;
            height: 60px;
            border-radius: 50%;
            background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%);
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 24px;
            font-weight: 700;
            position: relative;
            overflow: hidden;
            cursor: pointer;
            transition: all 0.3s ease;
        }

        .user-avatar:hover {
            transform: scale(1.05);
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
        }

        .user-avatar img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }

        .avatar-upload-btn {
            position: absolute;
            bottom: -2px;
            right: -2px;
            width: 24px;
            height: 24px;
            background: white;
            border-radius: 50%;
            border: 2px solid #4A90E2;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            transition: all 0.2s ease;
            z-index: 10;
        }

        .avatar-upload-btn:hover {
            background: #4A90E2;
            transform: scale(1.1);
        }

        .avatar-upload-btn i {
            font-size: 12px;
            color: #4A90E2;
            transition: color 0.2s ease;
        }

        .avatar-upload-btn:hover i {
            color: white;
        }

        #profileImageInput {
            display: none;
        }

        .user-info h3 {
            font-size: 18px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .user-info p {
            font-size: 13px;
            color: #6c757d;
        }

        /* 온도 시스템 */
        .user-temperature {
            margin-top: 12px;
            padding: 10px;
            background: linear-gradient(135deg, #f8f9fa 0%, #e9ecef 100%);
            border-radius: 8px;
            border: 1px solid #dee2e6;
        }

        .temperature-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 8px;
        }

        .temperature-label {
            font-size: 12px;
            color: #6c757d;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .temperature-value {
            font-size: 18px;
            font-weight: 700;
            display: flex;
            align-items: center;
            gap: 4px;
        }

        .temperature-icon {
            font-size: 16px;
        }

        .temperature-bar-container {
            height: 12px;
            background: #e9ecef;
            border-radius: 20px;
            overflow: hidden;
            position: relative;
            box-shadow: inset 0 2px 4px rgba(0,0,0,0.1);
        }

        .temperature-bar {
            height: 100%;
            border-radius: 20px;
            transition: width 0.5s ease, background 0.5s ease;
            position: relative;
            background: linear-gradient(90deg, #4A90E2 0%, #357ABD 100%);
        }

        .temperature-bar::after {
            content: '';
            position: absolute;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: linear-gradient(90deg, transparent 0%, rgba(255,255,255,0.3) 50%, transparent 100%);
            animation: shimmer 2s infinite;
        }

        @keyframes shimmer {
            0% { transform: translateX(-100%); }
            100% { transform: translateX(100%); }
        }

        /* 온도 레벨별 색상 */
        .temperature-bar.level-cold {
            background: linear-gradient(90deg, #17a2b8 0%, #0e7c8e 100%);
        }

        .temperature-bar.level-cool {
            background: linear-gradient(90deg, #4A90E2 0%, #357ABD 100%);
        }

        .temperature-bar.level-warm {
            background: linear-gradient(90deg, #28a745 0%, #1e7e34 100%);
        }

        .temperature-bar.level-hot {
            background: linear-gradient(90deg, #fd7e14 0%, #dc6502 100%);
        }

        .temperature-bar.level-fire {
            background: linear-gradient(90deg, #dc3545 0%, #c82333 100%);
            box-shadow: 0 0 10px rgba(220, 53, 69, 0.5);
        }

        .temperature-value.level-cold { color: #17a2b8; }
        .temperature-value.level-cool { color: #4A90E2; }
        .temperature-value.level-warm { color: #28a745; }
        .temperature-value.level-hot { color: #fd7e14; }
        .temperature-value.level-fire { color: #dc3545; }

        .temperature-message {
            font-size: 11px;
            color: #6c757d;
            margin-top: 6px;
            text-align: center;
            font-weight: 500;
        }

        /* 모달 스타일 */
        .modal-overlay {
            display: none;
            position: fixed;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background: rgba(0, 0, 0, 0.5);
            z-index: 9998;
            animation: fadeIn 0.2s ease;
        }

        .modal-overlay.active {
            display: flex;
            align-items: center;
            justify-content: center;
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        .modal-container {
            background: white;
            border-radius: 12px;
            width: 90%;
            max-width: 500px;
            max-height: 90vh;
            overflow-y: auto;
            box-shadow: 0 10px 40px rgba(0, 0, 0, 0.3);
            animation: slideUp 0.3s ease;
        }

        @keyframes slideUp {
            from {
                transform: translateY(50px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }

        .modal-header {
            padding: 20px 25px;
            border-bottom: 2px solid #e9ecef;
            display: flex;
            align-items: center;
            justify-content: space-between;
        }

        .modal-header h3 {
            font-size: 20px;
            font-weight: 700;
            color: #2c3e50;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .modal-header h3 i {
            color: #4A90E2;
        }

        .modal-close {
            background: none;
            border: none;
            font-size: 24px;
            color: #6c757d;
            cursor: pointer;
            padding: 0;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: all 0.2s;
        }

        .modal-close:hover {
            background: #f8f9fa;
            color: #dc3545;
        }

        .modal-body {
            padding: 25px;
        }

        .modal-date-info {
            display: none;
        }

        .date-selection-row {
            display: flex;
            gap: 15px;
            margin-bottom: 25px;
        }

        .date-box {
            flex: 1;
        }

        .date-box-label {
            font-size: 13px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
            display: block;
        }

        .date-display {
            background: white;
            border: 2px solid #e9ecef;
            padding: 12px 15px;
            border-radius: 8px;
            font-size: 15px;
            font-weight: 500;
            color: #2c3e50;
            text-align: center;
            transition: all 0.2s;
        }

        .date-display:hover {
            border-color: #4A90E2;
        }

        .date-input-field {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .date-input-field:focus {
            outline: none;
            border-color: #4A90E2;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }

        .event-form-group {
            margin-bottom: 20px;
        }

        .event-form-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
        }

        .event-form-input,
        .event-form-textarea {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.2s;
            font-family: inherit;
        }

        .event-form-input:focus,
        .event-form-textarea:focus {
            outline: none;
            border-color: #4A90E2;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }

        .event-form-textarea {
            resize: vertical;
            min-height: 100px;
        }

        .event-list {
            margin-top: 25px;
        }

        .event-list-title {
            font-size: 16px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 15px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .event-item {
            background: #f8f9fa;
            padding: 15px;
            border-radius: 8px;
            margin-bottom: 10px;
            border-left: 4px solid #4A90E2;
        }

        .event-item-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 8px;
        }

        .event-item-title {
            font-weight: 600;
            color: #2c3e50;
            font-size: 15px;
        }

        .event-item-actions {
            display: flex;
            gap: 8px;
        }

        .event-item-btn {
            background: none;
            border: none;
            cursor: pointer;
            padding: 4px 8px;
            border-radius: 4px;
            transition: all 0.2s;
            font-size: 14px;
        }

        .event-item-btn.edit {
            color: #4A90E2;
        }

        .event-item-btn.edit:hover {
            background: #e3f2fd;
        }

        .event-item-btn.delete {
            color: #dc3545;
        }

        .event-item-btn.delete:hover {
            background: #f8d7da;
        }

        .event-item-content {
            font-size: 14px;
            color: #555;
            line-height: 1.5;
        }

        .event-empty {
            text-align: center;
            padding: 30px;
            color: #6c757d;
            font-size: 14px;
        }

        .event-empty i {
            font-size: 48px;
            color: #dee2e6;
            margin-bottom: 10px;
        }

        .modal-footer {
            padding: 15px 25px;
            border-top: 2px solid #e9ecef;
            display: flex;
            gap: 10px;
            justify-content: flex-end;
        }

        .modal-btn {
            padding: 10px 20px;
            border: none;
            border-radius: 6px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
        }

        .modal-btn-primary {
            background: #4A90E2;
            color: white;
        }

        .modal-btn-primary:hover {
            background: #357ABD;
        }

        .modal-btn-secondary {
            background: #e9ecef;
            color: #555;
        }

        .modal-btn-secondary:hover {
            background: #dee2e6;
        }

        .sidebar-menu {
            padding: 20px 0;
        }

        .menu-section {
            margin-bottom: 25px;
        }

        .menu-section-title {
            padding: 0 30px;
            font-size: 12px;
            font-weight: 700;
            color: #95a5a6;
            text-transform: uppercase;
            letter-spacing: 0.5px;
            margin-bottom: 10px;
        }

        .menu-item {
            display: flex;
            align-items: center;
            gap: 12px;
            padding: 12px 30px;
            color: #555;
            text-decoration: none;
            transition: all 0.2s ease;
            cursor: pointer;
            border-left: 3px solid transparent;
        }

        .menu-item:hover {
            background: #f8f9fa;
            color: #4A90E2;
        }

        .menu-item.active {
            background: #e3f2fd;
            color: #4A90E2;
            border-left-color: #4A90E2;
            font-weight: 600;
        }

        .menu-item i {
            width: 20px;
            font-size: 18px;
            text-align: center;
        }

        .menu-item span {
            font-size: 15px;
        }

        .menu-badge {
            margin-left: auto;
            background: #333;
            color: white;
            padding: 2px 8px;
            border-radius: 50%;
            min-width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 11px;
            font-weight: 600;
        }

        /* 메인 콘텐츠 */
        .main-content {
            flex: 1;
            padding: 40px;
        }

        .page-header {
            margin-bottom: 30px;
        }

        .page-title {
            font-size: 32px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .page-subtitle {
            font-size: 16px;
            color: #6c757d;
        }

        /* 콘텐츠 카드 */
        .content-section {
            background: white;
            border-radius: 12px;
            padding: 30px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 25px;
        }

        .section-title {
            font-size: 20px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 10px;
        }

        .section-title i {
            color: #4A90E2;
        }

        /* 캘린더 스타일 */
        .calendar-container {
            background: white;
            border-radius: 10px;
            padding: 15px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            margin-bottom: 18px;
        }

        .calendar-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 10px;
            padding-bottom: 10px;
            border-bottom: 2px solid #e9ecef;
        }

        .calendar-title {
            font-size: 16px;
            font-weight: 700;
            color: #2c3e50;
        }

        .calendar-timezone {
            font-size: 11px;
            color: #6c757d;
            display: flex;
            align-items: center;
            gap: 5px;
        }

        .calendar-timezone i {
            color: #4A90E2;
        }

        .calendar-nav-buttons {
            display: flex;
            gap: 6px;
            align-items: center;
        }

        .calendar-nav-btn {
            background: #4A90E2;
            color: white;
            border: none;
            width: 28px;
            height: 28px;
            border-radius: 6px;
            cursor: pointer;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 13px;
            transition: all 0.2s;
        }

        .calendar-nav-btn:hover {
            background: #357ABD;
            transform: scale(1.1);
        }

        .calendar-today-btn {
            background: #e3f2fd;
            color: #4A90E2;
            border: 2px solid #4A90E2;
            padding: 4px 10px;
            border-radius: 6px;
            cursor: pointer;
            font-weight: 600;
            font-size: 11px;
            transition: all 0.2s;
        }

        .calendar-today-btn:hover {
            background: #4A90E2;
            color: white;
        }

        .calendar-weekdays {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 2px;
            margin: 10px 0 6px 0;
        }

        .calendar-weekday {
            text-align: center;
            font-weight: 700;
            color: #6c757d;
            padding: 6px 0;
            font-size: 11px;
        }

        .calendar-weekday.sunday {
            color: #dc3545;
        }

        .calendar-weekday.saturday {
            color: #4A90E2;
        }

        .calendar-days {
            display: grid;
            grid-template-columns: repeat(7, 1fr);
            gap: 2px;
            margin-bottom: 0;
        }

        .calendar-day {
            min-height: 80px;
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: flex-start;
            font-size: 12px;
            border-radius: 5px;
            cursor: pointer;
            position: relative;
            transition: all 0.2s;
            background: white;
            padding: 5px 3px;
            border: 1.5px solid transparent;
        }

        .calendar-day:hover {
            background: #f0f0f0;
            border-color: #dee2e6;
        }

        .calendar-day.other-month {
            color: #dee2e6;
            background: #fafafa;
        }

        .calendar-day.today {
            background: #4A90E2;
            color: white;
            font-weight: 700;
            border-color: #357ABD;
        }

        .calendar-day.today .calendar-day-number {
            color: white;
        }

        .calendar-day.sunday .calendar-day-number {
            color: #dc3545;
        }

        .calendar-day.saturday .calendar-day-number {
            color: #4A90E2;
        }

        .calendar-day.has-event {
            border-color: #dee2e6;
            background: white;
        }

        .calendar-day.range-start,
        .calendar-day.range-end {
            background: #fff3cd;
            border-color: #ffc107;
            font-weight: 600;
        }

        .calendar-day.in-range {
            background: #fff9e6;
            border-color: #ffe69c;
        }

        .calendar-day-number {
            font-weight: 700;
            margin-bottom: 4px;
            font-size: 13px;
            width: 100%;
            text-align: center;
            color: #2c3e50;
            display: block;
        }

        .calendar-event-text {
            font-size: 10px;
            color: #2c5282;
            font-weight: 600;
            width: 100%;
            margin: 3px 0 0 0;
            text-align: center;
            line-height: 1.2;
            padding: 4px 2px;
            background: linear-gradient(135deg, #e3f2fd 0%, #bbdefb 100%);
            border-radius: 3px;
            border-left: 2px solid #4A90E2;
            box-shadow: 0 1px 2px rgba(0, 0, 0, 0.08);
            transition: all 0.2s ease;
            word-break: break-all;
            white-space: normal;
            min-height: 28px;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .calendar-date:hover .calendar-event-text {
            background: linear-gradient(135deg, #bbdefb 0%, #90caf9 100%);
            box-shadow: 0 2px 4px rgba(0, 0, 0, 0.15);
        }

        .calendar-events {
            display: flex;
            gap: 1.5px;
            flex-wrap: wrap;
            justify-content: center;
            margin-top: auto;
        }

        .event-dot {
            width: 4px;
            height: 4px;
            border-radius: 50%;
        }

        .event-dot.volunteer {
            background: #28a745;
        }

        .event-dot.donation {
            background: #dc3545;
        }

        .event-dot.diagnosis {
            background: #ffc107;
        }

        .event-dot.notification {
            background: #17a2b8;
        }

        .calendar-legend {
            display: flex;
            gap: 20px;
            justify-content: center;
            margin-top: 25px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
            flex-wrap: wrap;
        }

        .legend-item {
            display: flex;
            align-items: center;
            gap: 8px;
            font-size: 13px;
            color: #6c757d;
            font-weight: 500;
        }

        .legend-dot {
            width: 10px;
            height: 10px;
            border-radius: 50%;
        }

        /* 통계 카드 - 작은 버전 */
        .stats-grid-small {
            display: grid;
            grid-template-columns: repeat(3, 1fr);
            gap: 15px;
            margin-top: 12px;
            padding: 12px;
            background: #f8f9fa;
            border-radius: 8px;
        }

        .stat-card-small {
            background: white;
            padding: 10px;
            border-radius: 6px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.06);
            transition: transform 0.2s ease, box-shadow 0.2s ease;
            border-top: 2.5px solid #4A90E2;
            text-align: center;
        }

        .stat-card-small:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
        }

        .stat-card-small.green {
            border-top-color: #28a745;
        }

        .stat-card-small.red {
            border-top-color: #dc3545;
        }

        .stat-card-small.orange {
            border-top-color: #fd7e14;
        }

        .stat-icon-small {
            width: 28px;
            height: 28px;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            margin: 0 auto 6px;
            background: #e3f2fd;
            color: #4A90E2;
        }

        .stat-card-small.green .stat-icon-small {
            background: #d4edda;
            color: #28a745;
        }

        .stat-card-small.red .stat-icon-small {
            background: #f8d7da;
            color: #dc3545;
        }

        .stat-card-small.orange .stat-icon-small {
            background: #ffe5d0;
            color: #fd7e14;
        }

        .stat-value-small {
            font-size: 18px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 3px;
        }

        .stat-label-small {
            font-size: 11px;
            color: #6c757d;
            font-weight: 500;
        }

        /* 리스트 아이템 */
        .list-item {
            padding: 20px;
            border-bottom: 1px solid #e9ecef;
            transition: background 0.2s;
        }

        .list-item:last-child {
            border-bottom: none;
        }

        .list-item:hover {
            background: #f8f9fa;
        }

        .list-item-header {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 10px;
        }

        .list-item-title {
            font-size: 16px;
            font-weight: 600;
            color: #2c3e50;
        }

        .list-item-date {
            font-size: 13px;
            color: #6c757d;
        }

        .list-item-content {
            font-size: 14px;
            color: #555;
            line-height: 1.6;
        }

        /* 관심 복지 서비스 카드 스타일 */
        .welfare-favorite-card {
            background: white;
            border-radius: 12px;
            padding: 24px;
            margin-bottom: 20px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.08);
            transition: all 0.3s ease;
            border: 2px solid transparent;
        }

        .welfare-favorite-card:hover {
            box-shadow: 0 4px 16px rgba(0,0,0,0.12);
            border-color: #4A90E2;
            transform: translateY(-2px);
        }

        .favorite-card-header {
            margin-bottom: 15px;
        }

        .favorite-card-title {
            font-size: 18px;
            font-weight: 700;
            color: #2c3e50;
            margin-bottom: 10px;
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .favorite-badge {
            color: #ffd700;
            font-size: 20px;
        }

        .favorite-card-department {
            margin-bottom: 8px;
        }

        .department-tag {
            display: inline-block;
            background: #e3f2fd;
            color: #1976d2;
            padding: 4px 12px;
            border-radius: 12px;
            font-size: 13px;
            font-weight: 500;
        }

        .favorite-card-date {
            font-size: 13px;
            color: #6c757d;
            margin-top: 8px;
        }

        .favorite-card-date i {
            margin-right: 5px;
        }

        .favorite-card-description {
            font-size: 14px;
            color: #495057;
            line-height: 1.6;
            margin-bottom: 20px;
            padding: 15px;
            background: #f8f9fa;
            border-radius: 8px;
            border-left: 3px solid #4A90E2;
        }

        .favorite-card-actions {
            display: flex;
            gap: 10px;
            flex-wrap: wrap;
        }

        .btn-delete {
            background: white;
            color: #dc3545;
            border: 1px solid #dc3545;
            padding: 8px 16px;
            font-size: 13px;
            border-radius: 6px;
            cursor: pointer;
            transition: all 0.2s;
            display: inline-flex;
            align-items: center;
            gap: 5px;
        }

        .btn-delete:hover {
            background: #dc3545;
            color: white;
        }

        .btn-delete i {
            font-size: 12px;
        }

        .status-badge {
            display: inline-block;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .status-badge.completed {
            background: #d4edda;
            color: #155724;
        }

        .status-badge.pending {
            background: #fff3cd;
            color: #856404;
        }

        .status-badge.cancelled {
            background: #f8d7da;
            color: #721c24;
        }

        /* 폼 스타일 */
        .form-group {
            margin-bottom: 25px;
        }

        .form-label {
            display: block;
            font-size: 14px;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 8px;
        }

        .form-input,
        .form-select {
            width: 100%;
            padding: 12px 15px;
            border: 2px solid #e9ecef;
            border-radius: 8px;
            font-size: 14px;
            transition: all 0.2s;
            background: white;
        }

        .form-input:focus,
        .form-select:focus {
            outline: none;
            border-color: #4A90E2;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }

        .form-input:disabled {
            background: #f8f9fa;
            color: #6c757d;
            cursor: not-allowed;
        }

        .form-help {
            font-size: 12px;
            color: #6c757d;
            margin-top: 5px;
        }

        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 20px;
        }

        .address-row {
            display: flex;
            gap: 10px;
            margin-bottom: 10px;
        }

        .address-row .form-input {
            flex: 1;
        }

        /* 버튼 */
        .btn {
            display: inline-flex;
            align-items: center;
            justify-content: center;
            gap: 8px;
            padding: 12px 24px;
            border: none;
            border-radius: 8px;
            font-size: 14px;
            font-weight: 600;
            cursor: pointer;
            transition: all 0.2s;
            text-decoration: none;
        }

        .btn-primary {
            background: #4A90E2;
            color: white;
        }

        .btn-primary:hover {
            background: #357ABD;
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
        }

        .btn-outline {
            background: white;
            color: #4A90E2;
            border: 2px solid #4A90E2;
        }

        .btn-outline:hover {
            background: #4A90E2;
            color: white;
        }

        .btn-danger {
            background: #dc3545;
            color: white;
        }

        .btn-danger:hover {
            background: #c82333;
        }

        .btn-group {
            display: flex;
            gap: 10px;
            margin-top: 30px;
        }

        /* 빈 상태 */
        .empty-state {
            text-align: center;
            padding: 60px 20px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 64px;
            color: #dee2e6;
            margin-bottom: 20px;
        }

        .empty-state h3 {
            font-size: 20px;
            color: #2c3e50;
            margin-bottom: 10px;
        }

        .empty-state p {
            font-size: 14px;
            margin-bottom: 20px;
        }

        /* 알림 메시지 */
        .alert {
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 20px;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .alert i {
            font-size: 20px;
        }

        .alert-info {
            background: #d1ecf1;
            color: #0c5460;
            border-left: 4px solid #17a2b8;
        }

        .alert-success {
            background: #d4edda;
            color: #155724;
            border-left: 4px solid #28a745;
        }

        .alert-warning {
            background: #fff3cd;
            color: #856404;
            border-left: 4px solid #ffc107;
        }

        /* 비밀번호 강도 표시 */
        .password-strength {
            height: 4px;
            background: #e9ecef;
            border-radius: 2px;
            margin-top: 8px;
            overflow: hidden;
        }

        .password-strength-bar {
            height: 100%;
            transition: all 0.3s;
            border-radius: 2px;
        }

        .password-strength-bar.weak {
            width: 33%;
            background: #dc3545;
        }

        .password-strength-bar.medium {
            width: 66%;
            background: #ffc107;
        }

        .password-strength-bar.strong {
            width: 100%;
            background: #28a745;
        }

        /* 반응형 */
        @media (max-width: 1024px) {
            .sidebar {
                width: 240px;
            }

            .main-content {
                padding: 30px 20px;
            }

            .form-row {
                grid-template-columns: 1fr;
            }

            .stats-grid-small {
                grid-template-columns: repeat(3, 1fr);
                gap: 12px;
                padding: 15px;
            }
        }

        @media (max-width: 768px) {
            .navbar {
                padding: 0 20px;
            }

            .nav-menu {
                display: none;
            }

            .main-container {
                flex-direction: column;
            }

            .sidebar {
                width: 100%;
                border-right: none;
                border-bottom: 1px solid #e9ecef;
            }

            .main-content {
                padding: 20px;
            }

            .stats-grid-small {
                grid-template-columns: 1fr;
                gap: 10px;
                padding: 12px;
            }

            .btn-group {
                flex-direction: column;
            }

            .btn-group .btn {
                width: 100%;
            }

            .calendar-container {
                padding: 15px;
            }

            .calendar-header {
                flex-direction: column;
                align-items: flex-start;
                gap: 12px;
            }

            .calendar-title {
                font-size: 15px;
            }

            .calendar-timezone {
                font-size: 10px;
            }

            .calendar-nav-btn {
                width: 26px;
                height: 26px;
                font-size: 12px;
            }

            .calendar-today-btn {
                padding: 5px 10px;
                font-size: 10px;
            }

            .calendar-weekday {
                font-size: 10px;
                padding: 6px 0;
            }

            .calendar-days {
                gap: 3px;
            }

            .calendar-day {
                padding: 4px 3px;
                min-height: 70px;
            }

            .calendar-day-number {
                font-size: 11px;
                margin-bottom: 2px;
            }

            .calendar-event-text {
                font-size: 9px;
                padding: 3px 2px;
                min-height: 26px;
            }

            .event-dot {
                width: 3px;
                height: 3px;
            }
        }

        @media (max-width: 480px) {
            .calendar-container {
                padding: 12px;
            }

            .calendar-header {
                gap: 8px;
            }

            .calendar-title {
                font-size: 14px;
            }

            .calendar-nav-buttons {
                gap: 6px;
            }

            .calendar-nav-btn {
                width: 24px;
                height: 24px;
                font-size: 11px;
            }

            .calendar-today-btn {
                padding: 4px 8px;
                font-size: 10px;
            }

            .calendar-days {
                gap: 2px;
            }

            .calendar-day {
                padding: 3px 2px;
                min-height: 65px;
            }

            .calendar-day-number {
                font-size: 10px;
            }

            .calendar-event-text {
                font-size: 8px;
                padding: 3px 2px;
                min-height: 24px;
            }

            .stat-value-small {
                font-size: 16px;
            }

            .stat-label-small {
                font-size: 10px;
            }
        }

        /* 알림 설정 스타일 */
        .notification-info-box {
            background: #e3f2fd;
            border-left: 4px solid #4A90E2;
            padding: 15px 20px;
            border-radius: 8px;
            margin-bottom: 25px;
            display: flex;
            gap: 15px;
            align-items: flex-start;
        }

        .notification-info-box i {
            color: #4A90E2;
            font-size: 24px;
            margin-top: 2px;
        }

        .notification-info-box strong {
            font-size: 15px;
            color: #2c3e50;
            display: block;
            margin-bottom: 5px;
        }

        .notification-info-box p {
            font-size: 14px;
            color: #555;
            margin: 0;
        }

        .notification-list {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }

        .notification-item {
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            transition: all 0.2s;
        }

        .notification-item:hover {
            border-color: #4A90E2;
            box-shadow: 0 2px 8px rgba(74, 144, 226, 0.1);
        }

        .notification-item-content {
            flex: 1;
        }

        .notification-item-title {
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .notification-item-date {
            font-size: 13px;
            color: #6c757d;
        }

        .notification-item-badge {
            background: #fff3cd;
            color: #856404;
            padding: 4px 12px;
            border-radius: 20px;
            font-size: 12px;
            font-weight: 600;
        }

        .notification-delete-btn {
            background: none;
            border: none;
            color: #dc3545;
            cursor: pointer;
            padding: 6px 10px;
            border-radius: 4px;
            transition: all 0.2s;
            font-size: 14px;
        }

        .notification-delete-btn:hover {
            background: #fee;
            color: #c82333;
        }

        /* 알림 필터 버튼 스타일 */
        .notification-filter-btn {
            padding: 8px 16px;
            border: 2px solid #dee2e6;
            background: white;
            color: #495057;
            border-radius: 20px;
            cursor: pointer;
            transition: all 0.2s;
            font-size: 14px;
            font-weight: 600;
            display: flex;
            align-items: center;
            gap: 6px;
        }

        .notification-filter-btn:hover {
            background-color: #f8f9fa;
            border-color: #4A90E2;
        }

        .notification-filter-btn.active {
            background-color: #4A90E2;
            color: white;
            border-color: #4A90E2;
        }

        .badge-count {
            background: rgba(255, 255, 255, 0.3);
            padding: 2px 8px;
            border-radius: 10px;
            font-size: 12px;
            font-weight: 700;
        }

        .notification-filter-btn.active .badge-count {
            background: rgba(255, 255, 255, 0.3);
        }

        /* 알림 아이템 스타일 개선 */
        .notification-item.unread {
            background: #f0f8ff;
            border-left: 4px solid #4A90E2;
        }

        .notification-item-type {
            display: inline-block;
            padding: 4px 10px;
            border-radius: 12px;
            font-size: 12px;
            font-weight: 600;
            margin-right: 10px;
        }

        .type-faq_answer {
            background: #e3f2fd;
            color: #1976d2;
        }

        .type-schedule {
            background: #f3e5f5;
            color: #7b1fa2;
        }

        .type-donation {
            background: #ffebee;
            color: #c62828;
        }

        .type-volunteer {
            background: #e8f5e9;
            color: #2e7d32;
        }

        .type-system {
            background: #fff3e0;
            color: #e65100;
        }

        .pagination {
            display: flex;
            justify-content: center;
            align-items: center;
            gap: 8px;
            margin-top: 20px;
            padding-top: 20px;
            border-top: 1px solid #e9ecef;
        }

        .pagination-btn {
            min-width: 36px;
            height: 36px;
            padding: 8px 12px;
            border: 1px solid #dee2e6;
            background: white;
            color: #495057;
            border-radius: 6px;
            cursor: pointer;
            font-size: 14px;
            font-weight: 500;
            transition: all 0.2s;
        }

        .pagination-btn:hover {
            background: #f8f9fa;
            border-color: #4A90E2;
            color: #4A90E2;
        }

        .pagination-btn.active {
            background: #4A90E2;
            border-color: #4A90E2;
            color: white;
            font-weight: 600;
        }

        .pagination-btn.active:hover {
            background: #357ABD;
            border-color: #357ABD;
        }

        .settings-item {
            display: flex;
            justify-content: space-between;
            align-items: center;
            padding: 20px;
            background: white;
            border: 2px solid #e9ecef;
            border-radius: 10px;
            margin-bottom: 15px;
        }

        .settings-label {
            display: flex;
            gap: 15px;
            align-items: flex-start;
        }

        .settings-label i {
            font-size: 24px;
            color: #4A90E2;
            margin-top: 3px;
        }

        .settings-label strong {
            display: block;
            font-size: 15px;
            color: #2c3e50;
            margin-bottom: 5px;
        }

        .settings-desc {
            font-size: 13px;
            color: #6c757d;
            margin: 0;
        }

        .toggle-switch {
            position: relative;
            display: inline-block;
            width: 50px;
            height: 26px;
        }

        .toggle-switch input {
            opacity: 0;
            width: 0;
            height: 0;
        }

        .toggle-slider {
            position: absolute;
            cursor: pointer;
            top: 0;
            left: 0;
            right: 0;
            bottom: 0;
            background-color: #ccc;
            transition: 0.3s;
            border-radius: 26px;
        }

        .toggle-slider:before {
            position: absolute;
            content: "";
            height: 20px;
            width: 20px;
            left: 3px;
            bottom: 3px;
            background-color: white;
            transition: 0.3s;
            border-radius: 50%;
        }

        input:checked + .toggle-slider {
            background-color: #4A90E2;
        }

        input:checked + .toggle-slider:before {
            transform: translateX(24px);
        }

        .empty-state {
            text-align: center;
            padding: 40px;
            color: #6c757d;
        }

        .empty-state i {
            font-size: 48px;
            color: #dee2e6;
            margin-bottom: 15px;
        }

        .empty-state p {
            font-size: 14px;
            margin: 0;
        }

        /* Google Translate Widget 스타일 */
        .language-selector {
            position: relative;
            display: inline-block;
        }

        #google_translate_element {
            position: absolute;
            top: 100%;
            right: 0;
            margin-top: 10px;
            background: white;
            padding: 8px;
            border-radius: 12px;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15);
            z-index: 9999;
            min-width: 180px;
        }

        /* Google Translate 기본 스타일 숨기기 */
        .goog-te-banner-frame {
            display: none !important;
        }

        body {
            top: 0 !important;
        }

        .goog-te-gadget {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif !important;
            font-size: 0 !important;
        }

        .goog-te-gadget-simple {
            background-color: white !important;
            border: 2px solid #e9ecef !important;
            border-radius: 8px !important;
            font-size: 14px !important;
            padding: 10px 15px !important;
            display: inline-block !important;
            cursor: pointer !important;
            transition: all 0.2s !important;
        }

        .goog-te-gadget-simple:hover {
            border-color: #4A90E2 !important;
            background-color: #f8f9fa !important;
        }

        .goog-te-gadget-icon {
            display: none !important;
        }

        .goog-te-menu-value {
            color: #2c3e50 !important;
            font-weight: 500 !important;
        }

        .goog-te-menu-value span {
            color: #2c3e50 !important;
            font-size: 14px !important;
            font-weight: 500 !important;
        }

        .goog-te-menu-value span:first-child {
            display: none !important;
        }

        .goog-te-menu-value > span:before {
            content: '🌐 ' !important;
        }

        /* 드롭다운 메뉴 스타일 */
        .goog-te-menu2 {
            border: none !important;
            border-radius: 12px !important;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.15) !important;
            max-height: 450px !important;
            overflow-y: auto !important;
            padding: 8px 0 !important;
            background: white !important;
        }

        .goog-te-menu2-item {
            padding: 12px 20px !important;
            font-size: 14px !important;
            color: #2c3e50 !important;
            transition: all 0.2s !important;
            border-left: 3px solid transparent !important;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif !important;
        }

        .goog-te-menu2-item:hover {
            background-color: #f8f9fa !important;
            border-left-color: #4A90E2 !important;
        }

        .goog-te-menu2-item-selected {
            background-color: #e3f2fd !important;
            color: #4A90E2 !important;
            font-weight: 600 !important;
            border-left-color: #4A90E2 !important;
        }

        .goog-te-menu2-item div {
            color: inherit !important;
        }

        /* 스크롤바 스타일 */
        .goog-te-menu2::-webkit-scrollbar {
            width: 8px !important;
        }

        .goog-te-menu2::-webkit-scrollbar-track {
            background: #f1f1f1 !important;
            border-radius: 10px !important;
        }

        .goog-te-menu2::-webkit-scrollbar-thumb {
            background: #4A90E2 !important;
            border-radius: 10px !important;
        }

        .goog-te-menu2::-webkit-scrollbar-thumb:hover {
            background: #357ABD !important;
        }

        /* iframe 내부 스타일 (언어 선택 창) */
        iframe.goog-te-menu-frame {
            border-radius: 12px !important;
            box-shadow: 0 8px 24px rgba(0, 0, 0, 0.2) !important;
        }

        /* 스피너 애니메이션 */
        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        /* 후기 작성 버튼 */
        .review-write-btn {
            background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%);
            color: white;
            border: none;
            padding: 8px 16px;
            border-radius: 6px;
            font-size: 13px;
            font-weight: 600;
            cursor: pointer;
            margin-left: 12px;
            transition: all 0.3s ease;
            box-shadow: 0 2px 8px rgba(74, 144, 226, 0.3);
        }

        .review-write-btn:hover {
            transform: translateY(-2px);
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.4);
        }

        /* 후기 작성 모달 */
        .review-modal {
            display: none;
            position: fixed;
            z-index: 10000;
            left: 0;
            top: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.6);
            justify-content: center;
            align-items: center;
            animation: fadeIn 0.3s ease;
        }

        .review-modal-content {
            background: white;
            border-radius: 20px;
            width: 90%;
            max-width: 600px;
            max-height: 90vh;
            overflow: hidden;
            box-shadow: 0 12px 48px rgba(0, 0, 0, 0.2);
            animation: slideUp 0.3s ease;
        }

        .review-modal-header {
            background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%);
            color: white;
            padding: 24px 32px;
            display: flex;
            justify-content: space-between;
            align-items: center;
        }

        .review-modal-header h2 {
            margin: 0;
            font-size: 24px;
            font-weight: 700;
        }

        .review-modal-close {
            background: rgba(255, 255, 255, 0.2);
            border: none;
            color: white;
            width: 40px;
            height: 40px;
            border-radius: 50%;
            cursor: pointer;
            font-size: 20px;
            transition: all 0.3s ease;
            display: flex;
            align-items: center;
            justify-content: center;
        }

        .review-modal-close:hover {
            background: rgba(255, 255, 255, 0.3);
            transform: rotate(90deg);
        }

        .review-modal-body {
            padding: 32px;
            overflow-y: auto;
            max-height: calc(90vh - 96px);
        }

        .review-activity-info {
            background: #f8f9fa;
            padding: 16px 20px;
            border-radius: 12px;
            margin-bottom: 24px;
            font-size: 16px;
            font-weight: 600;
            color: #333;
            display: flex;
            align-items: center;
            gap: 12px;
        }

        .review-activity-info i {
            color: #4A90E2;
            font-size: 20px;
        }

        .review-form-group {
            margin-bottom: 24px;
        }

        .review-form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: 600;
            color: #333;
            font-size: 15px;
        }

        .review-input,
        .review-textarea,
        .review-select {
            width: 100%;
            padding: 12px 16px;
            border: 2px solid #e0e0e0;
            border-radius: 10px;
            font-size: 14px;
            transition: all 0.3s ease;
            font-family: inherit;
        }

        .review-input:focus,
        .review-textarea:focus,
        .review-select:focus {
            outline: none;
            border-color: #4A90E2;
            box-shadow: 0 0 0 3px rgba(74, 144, 226, 0.1);
        }

        .review-textarea {
            resize: vertical;
            min-height: 150px;
        }

        .review-form-actions {
            display: flex;
            gap: 12px;
            margin-top: 32px;
            padding-top: 24px;
            border-top: 2px solid #f0f0f0;
        }

        .review-btn {
            flex: 1;
            padding: 16px 24px;
            border-radius: 10px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            border: none;
        }

        .review-btn-cancel {
            background: #f5f5f5;
            color: #666;
            border: 2px solid #e0e0e0;
        }

        .review-btn-cancel:hover {
            background: #eeeeee;
        }

        .review-btn-submit {
            background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%);
            color: white;
            box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);
        }

        .review-btn-submit:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 16px rgba(74, 144, 226, 0.4);
        }

        @keyframes fadeIn {
            from { opacity: 0; }
            to { opacity: 1; }
        }

        @keyframes slideUp {
            from {
                transform: translateY(30px);
                opacity: 0;
            }
            to {
                transform: translateY(0);
                opacity: 1;
            }
        }
    </style>
    <script type="text/javascript">
        function googleTranslateElementInit() {
            new google.translate.TranslateElement({
                pageLanguage: 'ko',
                includedLanguages: 'ko,en,ja,zh-CN,zh-TW,es,fr,de,ru,vi,th',
                layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
                autoDisplay: false
            }, 'google_translate_element');
        }
    </script>
    <script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>
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
                    <a href="#" class="menu-item" data-content="diagnosis">
                        <i class="fas fa-clipboard-list"></i>
                        <span>복지 진단 내역</span>
                    </a>
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
                        <i class="fas fa-bell"></i>
                        <span>알림</span>
                        <span class="menu-badge" id="notificationBadge">0</span>
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

                <!-- 최근 활동 -->
                <div class="content-section">
                    <h2 class="section-title">
                        <i class="fas fa-clock"></i>
                        최근 활동
                    </h2>
                    <div id="recentActivityList">
                        <!-- 동적으로 생성됨 -->
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
                                <input type="text" class="form-input" value="김철수" placeholder="이름을 입력하세요">
                            </div>
                            <div class="form-group">
                                <label class="form-label">성별</label>
                                <select class="form-select">
                                    <option value="male" selected>남성</option>
                                    <option value="female">여성</option>
                                    <option value="other">선택 안함</option>
                                </select>
                            </div>
                        </div>

                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">생년월일</label>
                                <input type="date" class="form-input" value="1990-01-15">
                            </div>
                            <div class="form-group">
                                <label class="form-label">전화번호</label>
                                <input type="tel" class="form-input" value="010-1234-5678" placeholder="010-0000-0000">
                                <div class="form-help">'-' 포함하여 입력해주세요</div>
                            </div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">이메일</label>
                            <input type="email" class="form-input" value="chulsoo@email.com" placeholder="example@email.com">
                            <div class="form-help">로그인 및 알림 수신에 사용됩니다</div>
                        </div>

                        <div class="form-group">
                            <label class="form-label">주소</label>
                            <div class="address-row">
                                <input type="text" class="form-input" value="06234" placeholder="우편번호" style="max-width: 150px;" readonly>
                                <button type="button" class="btn btn-outline" onclick="searchAddress()">주소 검색</button>
                            </div>
                            <input type="text" class="form-input" value="서울특별시 강남구 테헤란로 123" placeholder="기본 주소" readonly style="margin-bottom: 10px;">
                            <input type="text" class="form-input" value="복지빌딩 4층" placeholder="상세 주소">
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
                            <strong>보안 권장사항</strong><br>
                            안전한 비밀번호는 8자 이상, 영문/숫자/특수문자를 조합하여 만들어주세요.
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

                <!-- 회원 탈퇴 -->
                <div class="content-section">
                    <h2 class="section-title">
                        <i class="fas fa-user-times"></i>
                        회원 탈퇴
                    </h2>

                    <div class="alert alert-warning">
                        <i class="fas fa-exclamation-triangle"></i>
                        <div>
                            <strong>주의사항</strong><br>
                            회원 탈퇴 시 모든 정보가 삭제되며 복구가 불가능합니다. 신중하게 결정해주세요.
                        </div>
                    </div>

                    <button type="button" class="btn btn-danger" onclick="confirmWithdrawal()">
                        <i class="fas fa-sign-out-alt"></i>
                        회원 탈퇴하기
                    </button>
                </div>
            </div>

            <!-- 기타 콘텐츠 페이지들 -->
            <div id="content-diagnosis" class="content-page" style="display: none;">
                <div class="page-header">
                    <h1 class="page-title">복지 진단 내역</h1>
                    <p class="page-subtitle">과거 진단 결과를 다시 확인할 수 있습니다</p>
                </div>
                <div id="diagnosisListContainer">
                    <div class="empty-state">
                        <i class="fas fa-spinner fa-spin"></i>
                        <p>진단 내역을 불러오는 중...</p>
                    </div>
                </div>
            </div>

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

            <!-- 알림 목록 페이지 -->
            <div id="content-notifications-list" class="content-page" style="display: none;">
                <div class="page-header">
                    <h1 class="page-title">알림</h1>
                    <p class="page-subtitle">받은 알림을 확인하세요</p>
                </div>

                <div class="content-section">
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <div class="notification-tabs" style="display: flex; gap: 10px;">
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
                        <button class="btn-secondary" onclick="markAllAsRead()" style="padding: 8px 16px; font-size: 14px;">
                            <i class="fas fa-check-double"></i> 모두 읽음 처리
                        </button>
                    </div>

                    <div class="notification-list" id="notificationList">
                        <div class="empty-state">
                            <i class="fas fa-bell"></i>
                            <p>받은 알림이 없습니다</p>
                        </div>
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
                            <input type="checkbox" id="eventNotification" checked onchange="saveNotificationSettings()">
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
                            <input type="checkbox" id="donationNotification" checked onchange="saveNotificationSettings()">
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
                            <input type="checkbox" id="volunteerNotification" checked onchange="saveNotificationSettings()">
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
                            <input type="checkbox" id="faqAnswerNotification" checked onchange="saveNotificationSettings()">
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
                            <i class="fas fa-diagnoses"></i>
                            <div>
                                <strong>복지 진단 내역</strong>
                                <p class="settings-desc">복지 진단 결과 저장 및 표시</p>
                            </div>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" id="diagnosisHistoryEnabled" checked onchange="saveSecuritySettings()">
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                    <div class="settings-item">
                        <div class="settings-label">
                            <i class="fas fa-calendar-check"></i>
                            <div>
                                <strong>캘린더 일정 저장</strong>
                                <p class="settings-desc">등록한 일정을 로컬에 저장</p>
                            </div>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" id="calendarStorageEnabled" checked onchange="saveSecuritySettings()">
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                </div>

                <div class="content-section">
                    <h2 class="section-title">
                        <i class="fas fa-lock"></i>
                        보안 설정
                    </h2>
                    <div class="settings-item">
                        <div class="settings-label">
                            <i class="fas fa-key"></i>
                            <div>
                                <strong>자동 로그아웃</strong>
                                <p class="settings-desc">30분 동안 활동이 없으면 자동 로그아웃</p>
                            </div>
                        </div>
                        <label class="toggle-switch">
                            <input type="checkbox" id="autoLogoutEnabled" checked onchange="saveSecuritySettings()">
                            <span class="toggle-slider"></span>
                        </label>
                    </div>
                </div>

                <div class="content-section">
                    <h2 class="section-title">
                        <i class="fas fa-trash-alt"></i>
                        데이터 관리
                    </h2>
                    <div class="list-item">
                        <div class="list-item-header">
                            <span class="list-item-title" style="color: #dc3545;">모든 데이터 삭제</span>
                        </div>
                        <div class="list-item-content">
                            <p style="color: #856404; background: #fff3cd; padding: 10px; border-radius: 4px; margin-bottom: 10px;">
                                <i class="fas fa-exclamation-triangle"></i>
                                경고: 이 작업은 되돌릴 수 없습니다. 모든 일정, 설정, 활동 기록이 영구적으로 삭제됩니다.
                            </p>
                            <button class="btn-primary" onclick="deleteAllData()" style="margin-top: 10px; padding: 8px 16px; font-size: 14px; background: #dc3545; border-color: #dc3545;">
                                <i class="fas fa-trash-alt"></i> 모든 데이터 삭제
                            </button>
                        </div>
                    </div>
                </div>
            </div>
        </main>
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
       <%@ include file="footer.jsp" %>
    <!-- Daum 주소 API -->
    <script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

    <script>
        // 온도 시스템
        const temperatureData = {
            current: 36.5,  // 현재 온도 (DB에서 가져옴)
            min: 36.5,      // 최소 온도
            max: 50.0       // 최대 온도
        };

        // 선행 온도 불러오기 (API 호출)
        async function loadKindnessTemperature() {
            try {
                const response = await fetch('/bdproject/api/kindness/temperature');
                const result = await response.json();

                if (result.success && result.temperature) {
                    temperatureData.current = parseFloat(result.temperature);
                    updateTemperatureDisplay(temperatureData.current);
                    console.log('선행온도 로드 성공:', temperatureData.current);
                } else {
                    console.warn('선행온도 API 응답 실패:', result.message);
                    temperatureData.current = 36.5;
                    updateTemperatureDisplay(36.5);
                }
            } catch (error) {
                console.error('선행 온도 로딩 오류:', error);
                // 오류 시 기본값 사용
                temperatureData.current = 36.5;
                updateTemperatureDisplay(36.5);
            }
        }

        // 선행 온도 업데이트 (봉사/기부/리뷰 작성 후 호출)
        async function refreshKindnessTemperature() {
            try {
                // 백엔드에서 이미 온도가 증가되었으므로, 최신 온도를 다시 로드
                const response = await fetch('/bdproject/api/kindness/temperature');
                const result = await response.json();

                if (result.success && result.temperature) {
                    temperatureData.current = parseFloat(result.temperature);
                    updateTemperatureDisplay(temperatureData.current);

                    // 성공 메시지 표시
                    if (result.message) {
                        showTemperatureToast(result.message);
                    }
                }

                return result;
            } catch (error) {
                console.error('선행 온도 증가 오류:', error);
                return { success: false };
            }
        }

        // 온도 증가 알림 토스트
        function showTemperatureToast(message) {
            const toast = document.createElement('div');
            toast.style.cssText = `
                position: fixed;
                top: 80px;
                right: 20px;
                background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
                color: white;
                padding: 15px 20px;
                border-radius: 12px;
                box-shadow: 0 4px 12px rgba(0,0,0,0.2);
                z-index: 10000;
                font-weight: 600;
                animation: slideIn 0.3s ease;
            `;
            toast.innerHTML = `<i class="fas fa-fire-alt"></i> ${message}`;
            document.body.appendChild(toast);

            setTimeout(() => {
                toast.style.animation = 'slideOut 0.3s ease';
                setTimeout(() => toast.remove(), 300);
            }, 3000);
        }

        // 온도 레벨 및 메시지 결정
        function getTemperatureLevel(temp) {
            if (temp < 37.5) {
                return {
                    level: 'cold',
                    icon: '❄️',
                    message: '선행을 시작해보세요!'
                };
            } else if (temp < 40.0) {
                return {
                    level: 'cool',
                    icon: '💧',
                    message: '따뜻한 마음을 나눠주세요!'
                };
            } else if (temp < 43.0) {
                return {
                    level: 'warm',
                    icon: '🌱',
                    message: '좋은 에너지가 퍼지고 있어요!'
                };
            } else if (temp < 46.0) {
                return {
                    level: 'hot',
                    icon: '🔥',
                    message: '뜨거운 열정으로 세상을 바꾸고 있어요!'
                };
            } else {
                return {
                    level: 'fire',
                    icon: '⭐',
                    message: '천사같은 당신! 세상을 밝히는 빛입니다!'
                };
            }
        }

        // 온도계 UI 업데이트
        function updateTemperatureDisplay(temp) {
            temperatureData.current = temp;

            const percentage = ((temp - temperatureData.min) / (temperatureData.max - temperatureData.min)) * 100;
            const levelInfo = getTemperatureLevel(temp);

            // DOM 업데이트
            const tempNumber = document.getElementById('tempNumber');
            const tempIcon = document.getElementById('tempIcon');
            const tempValue = document.getElementById('temperatureValue');
            const tempBar = document.getElementById('temperatureBar');
            const tempMessage = document.getElementById('temperatureMessage');

            if (tempNumber) tempNumber.textContent = temp.toFixed(1);
            if (tempIcon) tempIcon.textContent = levelInfo.icon;
            if (tempMessage) tempMessage.textContent = levelInfo.message;

            if (tempBar) {
                tempBar.style.width = percentage + '%';
                tempBar.className = 'temperature-bar level-' + levelInfo.level;
            }

            if (tempValue) {
                tempValue.className = 'temperature-value level-' + levelInfo.level;
            }
        }

        // 사용자 시간대 감지 및 표시
        function detectUserTimezone() {
            try {
                const timezoneElement = document.getElementById('userTimezone');
                if (!timezoneElement) {
                    console.error('userTimezone element not found');
                    return;
                }

                // 사용자의 시간대 감지
                const timezone = Intl.DateTimeFormat().resolvedOptions().timeZone;
                const timezoneOffset = new Date().getTimezoneOffset();
                const offsetHours = -timezoneOffset / 60;
                const offsetSign = offsetHours >= 0 ? '+' : '';

                // 시간대 이름을 더 읽기 쉽게 변환
                let displayTimezone = timezone;
                if (timezone === 'Asia/Seoul') {
                    displayTimezone = '한국 표준시 (KST)';
                } else if (timezone.includes('Asia/Tokyo')) {
                    displayTimezone = '일본 표준시 (JST)';
                } else if (timezone.includes('America/New_York')) {
                    displayTimezone = '미국 동부 표준시 (EST)';
                } else if (timezone.includes('America/Los_Angeles')) {
                    displayTimezone = '미국 서부 표준시 (PST)';
                } else if (timezone.includes('Europe/London')) {
                    displayTimezone = '영국 표준시 (GMT)';
                }

                timezoneElement.textContent = displayTimezone + ' (UTC' + offsetSign + offsetHours + ')';
                console.log('Timezone detected:', displayTimezone);
            } catch (error) {
                console.error('Timezone detection error:', error);
                const timezoneElement = document.getElementById('userTimezone');
                if (timezoneElement) {
                    timezoneElement.textContent = '시간대 감지 불가';
                }
            }
        }

        // 캘린더 전역 변수
        let currentYear;
        let currentMonth;
        const todayDate = new Date();
        const monthNames = ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'];

        // 이벤트 데이터
        const calendarEvents = {};
        function initEvents() {
            // 더미 데이터 제거 - 사용자가 직접 등록한 일정만 표시됨
        }

        // 사용자 일정 저장소 (localStorage 사용)
        let userEvents = {};
        let selectedDate = '';
        let editingEventId = null;

        // 날짜 포맷 함수
        function formatDateDisplay(dateStr) {
            const [year, month, day] = dateStr.split('-');
            return year + '년 ' + parseInt(month) + '월 ' + parseInt(day) + '일';
        }

        // localStorage에서 사용자 일정 불러오기 (계정별 분리)
        function loadUserEvents() {
            const userId = '<%= session.getAttribute("id") != null ? session.getAttribute("id") : "" %>';
            if (!userId) {
                userEvents = {};
                return;
            }
            const key = 'userEvents_' + userId;
            const stored = localStorage.getItem(key);
            if (stored) {
                try {
                    userEvents = JSON.parse(stored);
                } catch (e) {
                    console.error('Failed to parse user events:', e);
                    userEvents = {};
                }
            }
        }

        // 봉사 신청 내역 불러오기
        function loadVolunteerApplications() {
            const container = document.getElementById('volunteerListContainer');

            fetch('/bdproject/api/volunteer/my-applications')
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.data && data.data.length > 0) {
                        let html = '';
                        const today = new Date();
                        today.setHours(0, 0, 0, 0);

                        data.data.forEach(app => {
                            const statusText = getStatusText(app.status);
                            const statusClass = getStatusClass(app.status);

                            // 날짜 범위 표시
                            let dateStr = new Date(app.volunteerDate).toLocaleDateString('ko-KR');
                            if (app.volunteerEndDate) {
                                const endDateStr = new Date(app.volunteerEndDate).toLocaleDateString('ko-KR');
                                dateStr += ' ~ ' + endDateStr;
                            }

                            // 후기 작성 가능 여부 확인 (volunteer_end_date 기준)
                            let canWriteReview = false;
                            if (app.volunteerEndDate && !app.hasReview) {
                                const endDate = new Date(app.volunteerEndDate);
                                endDate.setHours(0, 0, 0, 0);
                                const daysPassed = Math.floor((today - endDate) / (1000 * 60 * 60 * 24));

                                // 봉사 종료일이 지났고, 3일 이내인 경우만 후기 작성 가능
                                canWriteReview = daysPassed >= 0 && daysPassed <= 3;
                            }

                            const reviewButton = canWriteReview
                                ? '<button class="review-write-btn" onclick="openReviewModal(' + app.applicationId + ', \'' + app.selectedCategory.replace(/'/g, "\\'") + '\')">후기 작성</button>'
                                : '';

                            html += '<div class="list-item">' +
                                '<div class="list-item-header">' +
                                    '<span class="list-item-title">' + app.selectedCategory + '</span>' +
                                    '<span class="list-item-date">' + dateStr + '</span>' +
                                '</div>' +
                                '<div class="list-item-content">' +
                                    '시간대: ' + app.volunteerTime + ' | 경험: ' + app.volunteerExperience +
                                    '<span class="status-badge ' + statusClass + '">' + statusText + '</span>' +
                                    reviewButton +
                                '</div>' +
                            '</div>';
                        });
                        container.innerHTML = html;

                        // 봉사활동 통계 업데이트 (신청 건수 표시)
                        const volunteerCountElement = document.getElementById('totalVolunteerHours');
                        if (volunteerCountElement) {
                            volunteerCountElement.textContent = data.data.length + '건';
                        }
                    } else {
                        container.innerHTML = '<div class="empty-state"><i class="fas fa-hands-helping"></i><p>봉사 신청 내역이 없습니다</p></div>';

                        // 데이터 없을 때 0으로 표시
                        const volunteerCountElement = document.getElementById('totalVolunteerHours');
                        if (volunteerCountElement) {
                            volunteerCountElement.textContent = '0건';
                        }
                    }
                })
                .catch(error => {
                    console.error('봉사 내역 로드 오류:', error);
                    container.innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-circle"></i><p>봉사 내역을 불러오지 못했습니다</p></div>';
                });
        }

        // 기부 내역 불러오기
        function loadDonations() {
            const container = document.getElementById('donationListContainer');

            fetch('/bdproject/api/donation/my')
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.data && data.data.length > 0) {
                        let html = '';
                        let totalAmount = 0;

                        data.data.forEach(donation => {
                            const typeText = donation.donationType === 'regular' ? '정기 후원' : '일시 후원';
                            const dateStr = new Date(donation.createdAt).toLocaleDateString('ko-KR');
                            const amountStr = donation.amount.toLocaleString();
                            totalAmount += donation.amount;

                            // 패키지명이 있으면 표시, 없으면 카테고리만 표시
                            const titleText = donation.packageName
                                ? `\${typeText} - \${donation.packageName}`
                                : `\${typeText} - \${donation.category}`;

                            html += `
                                <div class="list-item">
                                    <div class="list-item-header">
                                        <span class="list-item-title">\${titleText}</span>
                                        <span class="list-item-date">\${dateStr}</span>
                                    </div>
                                    <div class="list-item-content">
                                        금액: \${amountStr}원
                                        <span class="status-badge completed">완료</span>
                                    </div>
                                </div>
                            `;
                        });

                        container.innerHTML = html;

                        // 총 기부 금액 업데이트
                        const totalDonationElement = document.getElementById('totalDonationAmount');
                        if (totalDonationElement) {
                            totalDonationElement.textContent = totalAmount.toLocaleString() + '원';
                        }
                    } else {
                        container.innerHTML = '<div class="empty-state"><i class="fas fa-heart"></i><p>기부 내역이 없습니다</p></div>';

                        // 데이터 없을 때 0으로 표시
                        const totalDonationElement = document.getElementById('totalDonationAmount');
                        if (totalDonationElement) {
                            totalDonationElement.textContent = '0원';
                        }
                    }
                })
                .catch(error => {
                    console.error('기부 내역 로드 오류:', error);
                    container.innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-circle"></i><p>기부 내역을 불러오지 못했습니다</p></div>';
                });
        }

        // 관심 복지 서비스 불러오기
        function loadFavoriteServices() {
            const container = document.getElementById('favoriteListContainer');

            fetch('/bdproject/api/welfare/favorite/list')
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.data && data.data.length > 0) {
                        let html = '<div class="content-section"><h2 class="section-title"><i class="fas fa-star"></i>관심 복지 서비스</h2>';

                        data.data.forEach(favorite => {
                            const dateStr = new Date(favorite.createdAt).toLocaleDateString('ko-KR');

                            html += `
                                <div class="welfare-favorite-card">
                                    <div class="favorite-card-header">
                                        <div>
                                            <div class="favorite-card-title">
                                                \${favorite.serviceName}
                                                <span class="favorite-badge">★</span>
                                            </div>
                                            <div class="favorite-card-department">
                                                <span class="department-tag">\${favorite.department || '소관기관 정보 없음'}</span>
                                            </div>
                                            <div class="favorite-card-date">
                                                <i class="fas fa-calendar-alt"></i> 추가일: \${dateStr}
                                            </div>
                                        </div>
                                    </div>
                                    \${favorite.servicePurpose ? '<div class="favorite-card-description">' + favorite.servicePurpose + '</div>' : ''}
                                    <div class="favorite-card-actions">
                                        <button class="btn btn-primary" onclick="showFavoriteDetail('\${favorite.serviceId}')">
                                            상세 보기
                                        </button>
                                        <a href="https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=\${favorite.serviceId}"
                                           target="_blank" class="btn btn-outline">
                                            복지로 이동
                                        </a>
                                        <button class="btn btn-delete" onclick="removeFavorite('\${favorite.serviceId}')">
                                            <i class="fas fa-trash-alt"></i> 삭제
                                        </button>
                                    </div>
                                </div>
                            `;
                        });

                        html += '</div>';
                        container.innerHTML = html;

                        // 통계 업데이트
                        const favoriteCountElement = document.getElementById('totalFavoriteServices');
                        if (favoriteCountElement) {
                            favoriteCountElement.textContent = data.data.length + '개';
                        }
                    } else {
                        container.innerHTML = `
                            <div class="empty-state">
                                <i class="fas fa-star"></i>
                                <h3>등록된 관심 서비스가 없습니다</h3>
                                <p>복지 혜택 검색에서 마음에 드는 서비스를 즐겨찾기해보세요</p>
                                <a href="/bdproject/project_information.jsp" class="btn btn-primary">복지 혜택 찾기</a>
                            </div>
                        `;

                        // 데이터 없을 때 0으로 표시
                        const favoriteCountElement = document.getElementById('totalFavoriteServices');
                        if (favoriteCountElement) {
                            favoriteCountElement.textContent = '0개';
                        }
                    }
                })
                .catch(error => {
                    console.error('관심 서비스 로드 오류:', error);
                    container.innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-circle"></i><p>관심 서비스를 불러오지 못했습니다</p></div>';
                });
        }

        // 관심 서비스 삭제
        function removeFavorite(serviceId) {
            if (!confirm('이 서비스를 관심 목록에서 삭제하시겠습니까?')) {
                return;
            }

            fetch('/bdproject/api/welfare/favorite/remove?serviceId=' + encodeURIComponent(serviceId), {
                method: 'DELETE'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('관심 서비스가 삭제되었습니다.');
                    loadFavoriteServices(); // 목록 새로고침
                } else {
                    alert(data.message || '삭제에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('삭제 오류:', error);
                alert('삭제 중 오류가 발생했습니다.');
            });
        }

        // 관심 서비스 상세 보기
        function showFavoriteDetail(serviceId) {
            // 모달 생성
            const modal = document.createElement('div');
            modal.className = 'detail-modal';
            modal.style.cssText = `
                position: fixed;
                top: 0;
                left: 0;
                width: 100%;
                height: 100%;
                background: rgba(0,0,0,0.5);
                display: flex;
                align-items: center;
                justify-content: center;
                z-index: 10000;
            `;

            const modalContent = document.createElement('div');
            modalContent.style.cssText = `
                background: white;
                padding: 30px;
                border-radius: 15px;
                max-width: 600px;
                max-height: 80vh;
                overflow-y: auto;
                margin: 20px;
                box-shadow: 0 10px 30px rgba(0,0,0,0.3);
            `;

            modalContent.innerHTML = `
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                    <h3 style="margin: 0; color: #2c3e50;">서비스 상세 정보</h3>
                    <button onclick="this.closest('.detail-modal').remove()" style="
                        background: none;
                        border: none;
                        font-size: 28px;
                        cursor: pointer;
                        color: #666;
                        line-height: 1;
                    ">&times;</button>
                </div>
                <div style="text-align: center; padding: 40px;">
                    <div class="loading-spinner" style="
                        width: 50px;
                        height: 50px;
                        border: 4px solid #f3f3f3;
                        border-top: 4px solid #4A90E2;
                        border-radius: 50%;
                        animation: spin 1s linear infinite;
                        margin: 0 auto;
                    "></div>
                    <p style="margin-top: 20px; color: #666;">상세 정보를 불러오는 중...</p>
                </div>
            `;

            modal.appendChild(modalContent);
            document.body.appendChild(modal);

            // 복지로 API에서 상세 정보 가져오기 (실제로는 복지로 페이지로 이동)
            setTimeout(() => {
                modalContent.innerHTML = `
                    <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px;">
                        <h3 style="margin: 0; color: #2c3e50;">서비스 ID: \${serviceId}</h3>
                        <button onclick="this.closest('.detail-modal').remove()" style="
                            background: none;
                            border: none;
                            font-size: 28px;
                            cursor: pointer;
                            color: #666;
                            line-height: 1;
                        ">&times;</button>
                    </div>
                    <div style="line-height: 1.6; color: #495057;">
                        <p>상세한 정보는 복지로 사이트에서 확인하실 수 있습니다.</p>
                        <div style="margin-top: 20px; text-align: center;">
                            <a href="https://www.bokjiro.go.kr/ssis-tbu/twataa/wlfareInfo/moveTWAT52011M.do?wlfareInfoId=\${serviceId}"
                               target="_blank"
                               style="
                                   display: inline-block;
                                   background: #4A90E2;
                                   color: white;
                                   padding: 12px 30px;
                                   border-radius: 8px;
                                   text-decoration: none;
                                   font-weight: 600;
                               ">
                                복지로에서 자세히 보기
                            </a>
                        </div>
                    </div>
                `;
            }, 500);

            // 모달 배경 클릭시 닫기
            modal.addEventListener('click', function(e) {
                if (e.target === modal) {
                    modal.remove();
                }
            });
        }

        // 복지 진단 내역 불러오기
        function loadDiagnosisHistory() {
            const container = document.getElementById('diagnosisListContainer');

            fetch('/bdproject/api/welfare/diagnosis/my')
                .then(response => response.json())
                .then(data => {
                    console.log('진단 내역 데이터:', data);

                    const diagnoses = data.diagnoses || data.data || [];

                    if (data.success && diagnoses.length > 0) {
                        let html = '<div class="content-section"><h2 class="section-title">나에게 맞는 복지 혜택</h2>';

                        diagnoses.forEach((diagnosis, diagIndex) => {
                            const dateStr = new Date(diagnosis.createdAt).toLocaleDateString('ko-KR', {
                                year: 'numeric',
                                month: 'long',
                                day: 'numeric'
                            });

                            // 매칭된 서비스 파싱
                            let services = [];
                            try {
                                if (diagnosis.matchedServicesJson) {
                                    services = JSON.parse(diagnosis.matchedServicesJson);
                                }
                            } catch (e) {
                                console.error('JSON 파싱 오류:', e);
                            }

                            // 평균 적합도 계산
                            const avgScore = services.length > 0
                                ? Math.round(services.reduce((sum, s) => sum + (s.matchScore || s.score || 0), 0) / services.length)
                                : 0;

                            html += '<div class="diagnosis-group" style="margin-bottom: 30px; background: white; border-radius: 16px; box-shadow: 0 2px 12px rgba(0,0,0,0.08); overflow: hidden;">';
                            html += '<div class="diagnosis-date-header" style="display: flex; justify-content: space-between; align-items: center; padding: 20px 24px; transition: all 0.2s; background: linear-gradient(135deg, #f8fbff 0%, #ffffff 100%);">';
                            html += '<div onclick="toggleDiagnosis(' + diagIndex + ')" style="display: flex; align-items: center; gap: 12px; flex: 1; cursor: pointer;" onmouseenter="this.parentElement.style.background=\'#f0f7ff\'" onmouseleave="this.parentElement.style.background=\'linear-gradient(135deg, #f8fbff 0%, #ffffff 100%)\'">';
                            html += '<i id="toggle-icon-' + diagIndex + '" class="fas fa-chevron-down" style="color: #4A90E2; font-size: 16px; transition: transform 0.3s;"></i>';
                            html += '<h3 style="font-size: 18px; font-weight: 600; color: #333; margin: 0;">' + dateStr + ' 진단</h3>';
                            html += '</div>';
                            html += '<div style="display: flex; align-items: center; gap: 12px;">';
                            html += '<span style="background: #E8F4FD; color: #4A90E2; padding: 8px 16px; border-radius: 20px; font-size: 13px; font-weight: 600;">평균 적합도 ' + avgScore + '%</span>';
                            html += '<span style="background: #E8F4FD; color: #4A90E2; padding: 8px 16px; border-radius: 20px; font-size: 13px; font-weight: 600;">' + services.length + '개 혜택</span>';
                            html += '<button onclick="event.stopPropagation(); deleteDiagnosis(' + diagnosis.diagnosisId + ')" style="background: #fff; border: 2px solid #dc3545; color: #dc3545; padding: 8px 16px; border-radius: 8px; font-size: 13px; font-weight: 600; cursor: pointer; transition: all 0.2s;" onmouseenter="this.style.background=\'#dc3545\'; this.style.color=\'white\'" onmouseleave="this.style.background=\'#fff\'; this.style.color=\'#dc3545\'" title="진단 내역 삭제"><i class="fas fa-trash-alt" style="margin-right: 6px;"></i>삭제</button>';
                            html += '</div>';
                            html += '</div>';

                            if (services.length > 0) {
                                html += '<div id="diagnosis-content-' + diagIndex + '" class="diagnosis-content" style="padding: 24px; border-top: 1px solid #e9ecef; display: ' + (diagIndex === 0 ? 'block' : 'none') + ';">';
                                html += '<div class="welfare-services-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(350px, 1fr)); gap: 20px;">';

                                services.forEach((service, index) => {
                                    const servNm = service.servNm || '서비스명 없음';
                                    const servDgst = service.servDgst || service.sprtTrgtCn || '상세 정보를 확인해주세요';
                                    const jurMnofNm = service.jurMnofNm || '담당기관';
                                    const matchScore = service.matchScore || service.score || 0; // matchScore 또는 score 사용
                                    const servDtlLink = service.servDtlLink || '';
                                    const source = service.source || '중앙부처';

                                    console.log('서비스 적합도:', servNm, matchScore); // 디버깅용

                                    html += '<div class="welfare-card" style="background: white; border: 1px solid #e0e0e0; border-radius: 12px; padding: 20px; transition: all 0.3s ease; box-shadow: 0 2px 8px rgba(0,0,0,0.06); cursor: pointer;" onmouseenter="this.style.transform=\'translateY(-4px)\'; this.style.boxShadow=\'0 4px 16px rgba(0,0,0,0.12)\'" onmouseleave="this.style.transform=\'translateY(0)\'; this.style.boxShadow=\'0 2px 8px rgba(0,0,0,0.06)\'">';

                                    // 카드 헤더
                                    html += '<div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">';
                                    html += '<div style="flex: 1;">';
                                    html += '<div style="display: flex; align-items: center; justify-content: space-between; margin-bottom: 8px;">';
                                    html += '<h4 style="font-size: 16px; font-weight: 600; color: #2c3e50; margin: 0; line-height: 1.4; padding-right: 12px;">' + servNm + '</h4>';
                                    html += '<span style="background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%); color: white; padding: 6px 12px; border-radius: 20px; font-size: 13px; font-weight: 700; box-shadow: 0 2px 6px rgba(74, 144, 226, 0.3); flex-shrink: 0;"><i class="fas fa-heart" style="margin-right: 4px;"></i>' + matchScore + '%</span>';
                                    html += '</div>';
                                    html += '<div style="display: flex; align-items: center; gap: 8px; margin-top: 6px;">';
                                    html += '<span style="background: #E8F4FD; color: #4A90E2; padding: 3px 10px; border-radius: 12px; font-size: 12px; font-weight: 500;"><i class="fas fa-building" style="margin-right: 4px;"></i>' + jurMnofNm + '</span>';
                                    html += '<span style="background: #f3e5f5; color: #7b1fa2; padding: 3px 10px; border-radius: 12px; font-size: 12px; font-weight: 500;">' + source + '</span>';
                                    html += '</div>';
                                    html += '</div>';
                                    html += '</div>';

                                    // 설명
                                    const shortDesc = servDgst.length > 80 ? servDgst.substring(0, 80) + '...' : servDgst;
                                    html += '<p style="color: #555; font-size: 14px; line-height: 1.6; margin: 12px 0; min-height: 42px;">' + shortDesc + '</p>';

                                    // 버튼 그룹
                                    html += '<div style="display: flex; gap: 10px; margin-top: 16px;">';
                                    html += '<button onclick="showWelfareDetail(' + diagIndex + ', ' + index + ')" style="flex: 1; background: #fff; border: 2px solid #4A90E2; color: #4A90E2; padding: 10px 16px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s;" onmouseenter="this.style.background=\'#E8F4FD\'" onmouseleave="this.style.background=\'#fff\'"><i class="fas fa-info-circle" style="margin-right: 6px;"></i>상세보기</button>';

                                    if (servDtlLink) {
                                        html += '<button onclick="window.open(\'' + servDtlLink + '\', \'_blank\')" style="flex: 1; background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%); border: none; color: white; padding: 10px 16px; border-radius: 8px; font-size: 14px; font-weight: 600; cursor: pointer; transition: all 0.2s; box-shadow: 0 2px 8px rgba(74, 144, 226, 0.3);" onmouseenter="this.style.transform=\'scale(1.02)\'; this.style.boxShadow=\'0 4px 12px rgba(74, 144, 226, 0.4)\'" onmouseleave="this.style.transform=\'scale(1)\'; this.style.boxShadow=\'0 2px 8px rgba(74, 144, 226, 0.3)\'"><i class="fas fa-external-link-alt" style="margin-right: 6px;"></i>복지로 이동</button>';
                                    }

                                    html += '</div>';
                                    html += '</div>';
                                });

                                html += '</div>';
                                html += '</div>'; // diagnosis-content 종료
                            } else {
                                html += '<div id="diagnosis-content-' + diagIndex + '" class="diagnosis-content" style="padding: 24px; border-top: 1px solid #e9ecef; background: #f8f9fa; display: ' + (diagIndex === 0 ? 'block' : 'none') + ';">';
                                html += '<div style="border: 1px dashed #dee2e6; border-radius: 12px; padding: 40px; text-align: center; color: #6c757d;">';
                                html += '<i class="fas fa-inbox" style="font-size: 48px; color: #dee2e6; margin-bottom: 16px;"></i>';
                                html += '<p>매칭된 복지 서비스가 없습니다</p>';
                                html += '</div>';
                                html += '</div>'; // diagnosis-content 종료
                            }

                            html += '</div>'; // diagnosis-group 종료
                        });

                        html += '</div>';
                        container.innerHTML = html;

                        // 첫 번째 아이템의 아이콘 회전
                        const firstIcon = document.getElementById('toggle-icon-0');
                        if (firstIcon) {
                            firstIcon.style.transform = 'rotate(180deg)';
                        }
                    } else {
                        container.innerHTML = '<div class="empty-state" style="background: white; border-radius: 16px; padding: 60px 40px; text-align: center; box-shadow: 0 2px 12px rgba(0,0,0,0.08);"><i class="fas fa-clipboard" style="font-size: 64px; color: #dee2e6; margin-bottom: 20px;"></i><h3 style="font-size: 20px; font-weight: 600; color: #333; margin-bottom: 12px;">복지 진단 내역이 없습니다</h3><p style="color: #6c757d; margin-bottom: 24px;">복지 혜택 진단을 받고 결과를 저장해보세요</p><a href="/bdproject/project_detail" class="btn btn-primary" style="background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%); color: white; padding: 10px 20px; border-radius: 8px; text-decoration: none; font-weight: 600; display: inline-block; box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3); transition: all 0.2s; font-size: 14px;">복지 진단 받기</a></div>';
                    }
                })
                .catch(error => {
                    console.error('진단 내역 로드 오류:', error);
                    container.innerHTML = '<div class="empty-state" style="background: white; border-radius: 16px; padding: 60px 40px; text-align: center;"><i class="fas fa-exclamation-circle" style="font-size: 64px; color: #ff5252; margin-bottom: 20px;"></i><p style="color: #666; font-size: 16px;">진단 내역을 불러오지 못했습니다</p><button onclick="loadDiagnosisHistory()" style="margin-top: 16px; background: #4A90E2; color: white; padding: 10px 24px; border: none; border-radius: 8px; cursor: pointer; font-weight: 600;"><i class="fas fa-redo" style="margin-right: 6px;"></i>다시 시도</button></div>';
                });
        }

        // 진단 내역 토글 함수
        function toggleDiagnosis(diagIndex) {
            const content = document.getElementById('diagnosis-content-' + diagIndex);
            const icon = document.getElementById('toggle-icon-' + diagIndex);

            if (content && icon) {
                if (content.style.display === 'none') {
                    content.style.display = 'block';
                    icon.style.transform = 'rotate(180deg)';
                } else {
                    content.style.display = 'none';
                    icon.style.transform = 'rotate(0deg)';
                }
            }
        }

        // 복지 진단 내역 삭제 함수
        function deleteDiagnosis(diagnosisId) {
            if (!confirm('이 진단 내역을 삭제하시겠습니까?')) {
                return;
            }

            fetch('/bdproject/api/welfare/diagnosis/delete?diagnosisId=' + diagnosisId, {
                method: 'DELETE'
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert(data.message || '진단 내역이 삭제되었습니다.');
                    // 진단 내역 다시 로드
                    loadDiagnosisHistory();
                } else {
                    alert(data.message || '삭제에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('삭제 오류:', error);
                alert('삭제 중 오류가 발생했습니다.');
            });
        }

        // 복지 서비스 상세 정보 모달
        let diagnosisData = [];

        function showWelfareDetail(diagIndex, serviceIndex) {
            fetch('/bdproject/api/welfare/diagnosis/my')
                .then(response => response.json())
                .then(data => {
                    const diagnoses = data.diagnoses || data.data || [];
                    if (diagnoses[diagIndex]) {
                        const services = JSON.parse(diagnoses[diagIndex].matchedServicesJson);
                        const service = services[serviceIndex];

                        if (service) {
                            const modalHtml = '<div id="welfareDetailModal" style="position: fixed; top: 0; left: 0; width: 100%; height: 100%; background: rgba(0,0,0,0.6); display: flex; align-items: center; justify-content: center; z-index: 10000; animation: fadeIn 0.2s;" onclick="if(event.target.id===\'welfareDetailModal\') closeWelfareModal()"><div style="background: white; border-radius: 16px; max-width: 700px; width: 90%; max-height: 85vh; overflow-y: auto; padding: 0; box-shadow: 0 8px 32px rgba(0,0,0,0.2); animation: slideUp 0.3s;" onclick="event.stopPropagation()"><div style="position: sticky; top: 0; background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%); color: white; padding: 24px 32px; border-radius: 16px 16px 0 0; z-index: 1; box-shadow: 0 2px 8px rgba(0,0,0,0.1);"><div style="display: flex; justify-content: space-between; align-items: flex-start;"><div style="flex: 1; padding-right: 16px;"><h2 style="margin: 0 0 8px 0; font-size: 22px; font-weight: 700; line-height: 1.3;">' + (service.servNm || '서비스명') + '</h2><div style="display: flex; gap: 8px; flex-wrap: wrap; margin-top: 12px;"><span style="background: rgba(255,255,255,0.25); padding: 6px 12px; border-radius: 20px; font-size: 13px; font-weight: 500;"><i class="fas fa-building" style="margin-right: 4px;"></i>' + (service.jurMnofNm || '담당기관') + '</span><span style="background: rgba(255,255,255,0.25); padding: 6px 12px; border-radius: 20px; font-size: 13px; font-weight: 500;"><i class="fas fa-tag" style="margin-right: 4px;"></i>' + (service.source || '중앙부처') + '</span></div></div><button onclick="closeWelfareModal()" style="background: rgba(255,255,255,0.2); border: 2px solid rgba(255,255,255,0.5); color: white; width: 40px; height: 40px; border-radius: 50%; font-size: 20px; cursor: pointer; display: flex; align-items: center; justify-content: center; flex-shrink: 0; transition: all 0.2s;" onmouseenter="this.style.background=\'rgba(255,255,255,0.3)\'; this.style.transform=\'rotate(90deg)\'" onmouseleave="this.style.background=\'rgba(255,255,255,0.2)\'; this.style.transform=\'rotate(0)\'">×</button></div></div><div style="padding: 32px;"><div class="modal-section" style="margin-bottom: 28px;"><div style="display: flex; align-items: center; margin-bottom: 12px;"><i class="fas fa-bullseye" style="color: #4A90E2; font-size: 20px; margin-right: 10px;"></i><h3 style="font-size: 17px; font-weight: 700; color: #2c3e50; margin: 0;">서비스 목적</h3></div><p style="color: #555; line-height: 1.7; font-size: 15px; padding-left: 30px; margin: 0;">' + (service.servDgst || service.sprtTrgtCn || '정보 없음') + '</p></div>';

                            if (service.sprtTrgtCn) {
                                modalHtml += '<div class="modal-section" style="margin-bottom: 28px; background: #f8f9fa; padding: 20px; border-radius: 12px; border-left: 4px solid #4A90E2;"><div style="display: flex; align-items: center; margin-bottom: 12px;"><i class="fas fa-users" style="color: #4A90E2; font-size: 20px; margin-right: 10px;"></i><h3 style="font-size: 17px; font-weight: 700; color: #2c3e50; margin: 0;">지원 대상</h3></div><p style="color: #555; line-height: 1.7; font-size: 15px; padding-left: 30px; margin: 0;">' + service.sprtTrgtCn + '</p></div>';
                            }

                            if (service.slctCritCn) {
                                modalHtml += '<div class="modal-section" style="margin-bottom: 28px;"><div style="display: flex; align-items: center; margin-bottom: 12px;"><i class="fas fa-check-double" style="color: #4A90E2; font-size: 20px; margin-right: 10px;"></i><h3 style="font-size: 17px; font-weight: 700; color: #2c3e50; margin: 0;">선정 기준</h3></div><p style="color: #555; line-height: 1.7; font-size: 15px; padding-left: 30px; margin: 0;">' + service.slctCritCn + '</p></div>';
                            }

                            if (service.matchScore) {
                                const scorePercent = Math.min(100, service.matchScore);
                                modalHtml += '<div class="modal-section" style="margin-bottom: 28px; background: linear-gradient(135deg, #E8F4FD 0%, #f0f7ff 100%); padding: 20px; border-radius: 12px;"><div style="display: flex; align-items: center; margin-bottom: 12px;"><i class="fas fa-chart-line" style="color: #4A90E2; font-size: 20px; margin-right: 10px;"></i><h3 style="font-size: 17px; font-weight: 700; color: #4A90E2; margin: 0;">매칭도</h3></div><div style="padding-left: 30px;"><div style="background: white; height: 12px; border-radius: 6px; overflow: hidden; box-shadow: inset 0 1px 3px rgba(0,0,0,0.1);"><div style="height: 100%; background: linear-gradient(90deg, #4A90E2 0%, #7EC8E3 100%); width: ' + scorePercent + '%; transition: width 0.6s ease; box-shadow: 0 0 10px rgba(74, 144, 226, 0.5);"></div></div><p style="color: #4A90E2; font-weight: 700; font-size: 16px; margin-top: 10px;">' + scorePercent + '% 매칭</p></div></div>';
                            }

                            modalHtml += '<div style="display: flex; gap: 12px; margin-top: 32px; padding-top: 24px; border-top: 2px solid #f0f0f0;">';

                            if (service.servDtlLink) {
                                modalHtml += '<button onclick="window.open(\'' + service.servDtlLink + '\', \'_blank\')" style="flex: 1; background: linear-gradient(135deg, #4A90E2 0%, #357ABD 100%); border: none; color: white; padding: 16px 24px; border-radius: 10px; font-size: 15px; font-weight: 700; cursor: pointer; transition: all 0.2s; box-shadow: 0 4px 12px rgba(74, 144, 226, 0.3);" onmouseenter="this.style.transform=\'translateY(-2px)\'; this.style.boxShadow=\'0 6px 16px rgba(74, 144, 226, 0.4)\'" onmouseleave="this.style.transform=\'translateY(0)\'; this.style.boxShadow=\'0 4px 12px rgba(74, 144, 226, 0.3)\'"><i class="fas fa-external-link-alt" style="margin-right: 8px;"></i>복지로에서 신청하기</button>';
                            }

                            modalHtml += '<button onclick="closeWelfareModal()" style="background: #f5f5f5; border: 2px solid #e0e0e0; color: #666; padding: 16px 24px; border-radius: 10px; font-size: 15px; font-weight: 600; cursor: pointer; min-width: 120px; transition: all 0.2s;" onmouseenter="this.style.background=\'#eeeeee\'" onmouseleave="this.style.background=\'#f5f5f5\'">닫기</button>';

                            modalHtml += '</div></div></div></div><style>@keyframes fadeIn { from { opacity: 0; } to { opacity: 1; } } @keyframes slideUp { from { transform: translateY(30px); opacity: 0; } to { transform: translateY(0); opacity: 1; } }</style>';

                            document.body.insertAdjacentHTML('beforeend', modalHtml);
                        }
                    }
                })
                .catch(error => {
                    console.error('상세 정보 로드 오류:', error);
                    alert('상세 정보를 불러올 수 없습니다.');
                });
        }

        function closeWelfareModal() {
            const modal = document.getElementById('welfareDetailModal');
            if (modal) {
                modal.style.animation = 'fadeOut 0.2s';
                setTimeout(() => modal.remove(), 200);
            }
        }

        // 상태 텍스트 변환
        function getStatusText(status) {
            const statusMap = {
                'applied': '신청완료',
                'confirmed': '확인완료',
                'completed': '완료',
                'cancelled': '취소'
            };
            return statusMap[status] || status;
        }

        // 상태 클래스 변환
        function getStatusClass(status) {
            const classMap = {
                'applied': 'pending',
                'confirmed': 'confirmed',
                'completed': 'completed',
                'cancelled': 'cancelled'
            };
            return classMap[status] || '';
        }

        // localStorage에 사용자 일정 저장 (계정별 분리)
        function saveUserEvents() {
            try {
                const userId = '<%= session.getAttribute("id") != null ? session.getAttribute("id") : "" %>';
                if (!userId) return;
                const key = 'userEvents_' + userId;
                localStorage.setItem(key, JSON.stringify(userEvents));
            } catch (e) {
                console.error('Failed to save user events:', e);
            }
        }

        // 모달 열기
        function openEventModal(dateStr) {
            selectedDate = dateStr;
            const modal = document.getElementById('eventModal');
            const startDateDisplay = document.getElementById('startDateDisplay');
            const endDateInput = document.getElementById('eventEndDate');

            // 시작 날짜 표시
            startDateDisplay.textContent = formatDateDisplay(dateStr);

            // 폼 초기화
            document.getElementById('eventTitle').value = '';
            document.getElementById('eventDescription').value = '';
            endDateInput.value = dateStr; // 종료 날짜 기본값을 시작 날짜로 설정
            endDateInput.min = dateStr; // 종료 날짜의 최소값을 시작 날짜로 설정
            editingEventId = null;

            // 해당 날짜의 일정 표시
            displayEventsForDate(dateStr);

            modal.classList.add('active');
        }

        // 모달 닫기
        function closeEventModal() {
            const modal = document.getElementById('eventModal');
            modal.classList.remove('active');
            selectedDate = '';
            editingEventId = null;
        }

        // 해당 날짜의 일정 표시
        function displayEventsForDate(dateStr) {
            const container = document.getElementById('eventListContainer');
            const events = userEvents[dateStr] || [];

            if (events.length === 0) {
                container.innerHTML = '<div class="event-empty"><i class="fas fa-calendar-alt"></i><p>등록된 일정이 없습니다</p></div>';
                return;
            }

            let html = '';
            events.forEach((event, index) => {
                html += '<div class="event-item">';
                html += '<div class="event-item-header">';
                html += '<span class="event-item-title">' + event.title + '</span>';
                html += '<div class="event-item-actions">';
                html += '<button class="event-item-btn edit" onclick="editEvent(\'' + dateStr + '\', ' + index + ')"><i class="fas fa-edit"></i></button>';
                html += '<button class="event-item-btn delete" onclick="deleteEvent(\'' + dateStr + '\', ' + index + ')"><i class="fas fa-trash"></i></button>';
                html += '</div>';
                html += '</div>';
                if (event.description) {
                    html += '<div class="event-item-content">' + event.description + '</div>';
                }
                html += '</div>';
            });

            container.innerHTML = html;
        }

        // 일정 저장
        function saveEvent() {
            const title = document.getElementById('eventTitle').value.trim();
            const description = document.getElementById('eventDescription').value.trim();
            const endDate = document.getElementById('eventEndDate').value;

            if (!title) {
                alert('일정 제목을 입력해주세요.');
                return;
            }

            if (!selectedDate) {
                alert('날짜가 선택되지 않았습니다.');
                return;
            }

            if (!endDate) {
                alert('종료 날짜를 선택해주세요.');
                return;
            }

            if (endDate < selectedDate) {
                alert('종료 날짜는 시작 날짜 이후여야 합니다.');
                return;
            }

            // 기간 여부 판단
            const isRange = endDate !== selectedDate;

            const eventData = {
                id: Date.now(),
                title: title,
                description: description,
                type: isRange ? 'range' : 'single',
                startDate: selectedDate,
                endDate: endDate,
                createdAt: new Date().toISOString()
            };

            // 날짜 범위의 모든 날짜에 일정 추가
            let currentDate = new Date(selectedDate);
            const finalDate = new Date(endDate);

            while (currentDate <= finalDate) {
                const dateStr = currentDate.toISOString().split('T')[0];

                if (!userEvents[dateStr]) {
                    userEvents[dateStr] = [];
                }

                if (editingEventId !== null && dateStr === selectedDate) {
                    // 수정 모드
                    userEvents[dateStr][editingEventId] = eventData;
                } else {
                    // 추가 모드
                    userEvents[dateStr].push(eventData);
                }

                currentDate.setDate(currentDate.getDate() + 1);
            }

            if (editingEventId !== null) {
                editingEventId = null;
            }

            saveUserEvents();

            // 폼 초기화
            document.getElementById('eventTitle').value = '';
            document.getElementById('eventDescription').value = '';
            document.getElementById('eventEndDate').value = selectedDate;

            // 일정 목록 업데이트
            displayEventsForDate(selectedDate);

            // 캘린더 다시 렌더링
            renderMonthCalendar();

            // 최근 활동 업데이트
            updateRecentActivity();

            alert('일정이 저장되었습니다.');
        }

        // 일정 수정
        function editEvent(dateStr, index) {
            const event = userEvents[dateStr][index];
            document.getElementById('eventTitle').value = event.title;
            document.getElementById('eventDescription').value = event.description || '';
            document.getElementById('eventEndDate').value = event.endDate || dateStr;
            editingEventId = index;

            // 스크롤을 폼 위치로
            document.getElementById('eventForm').scrollIntoView({ behavior: 'smooth' });
        }

        // 일정 삭제
        function deleteEvent(dateStr, index) {
            if (!confirm('이 일정을 삭제하시겠습니까?')) {
                return;
            }

            userEvents[dateStr].splice(index, 1);

            // 빈 배열이면 삭제
            if (userEvents[dateStr].length === 0) {
                delete userEvents[dateStr];
            }

            saveUserEvents();
            displayEventsForDate(dateStr);
            renderMonthCalendar();
            updateRecentActivity();
        }

        // 월별 캘린더 렌더링
        function renderMonthCalendar() {
            console.log('renderMonthCalendar called');

            const calendarDays = document.getElementById('calendarDays');
            const calendarTitle = document.getElementById('calendarTitle');

            if (!calendarDays || !calendarTitle) {
                console.error('Calendar elements not found');
                return;
            }

            // 제목 업데이트
            calendarTitle.textContent = currentYear + '년 ' + monthNames[currentMonth];

            // 이번 달의 첫날과 마지막 날
            const firstDay = new Date(currentYear, currentMonth, 1);
            const lastDay = new Date(currentYear, currentMonth + 1, 0);
            const firstDayOfWeek = firstDay.getDay();
            const lastDate = lastDay.getDate();

            // 이전 달의 마지막 날
            const prevLastDay = new Date(currentYear, currentMonth, 0);
            const prevLastDate = prevLastDay.getDate();

            let calendarHTML = '';

            // 이전 달 날짜
            for (let i = firstDayOfWeek; i > 0; i--) {
                calendarHTML += '<div class="calendar-day other-month">';
                calendarHTML += '<div class="calendar-day-number">' + (prevLastDate - i + 1) + '</div>';
                calendarHTML += '</div>';
            }

            // 이번 달 날짜
            for (let day = 1; day <= lastDate; day++) {
                const monthStr = String(currentMonth + 1).padStart(2, '0');
                const dayStr = String(day).padStart(2, '0');
                const dateStr = currentYear + '-' + monthStr + '-' + dayStr;
                const dayOfWeek = new Date(currentYear, currentMonth, day).getDay();

                let dayClass = 'calendar-day';
                if (dayOfWeek === 0) dayClass += ' sunday';
                if (dayOfWeek === 6) dayClass += ' saturday';

                // 오늘 날짜 체크
                if (day === todayDate.getDate() &&
                    currentMonth === todayDate.getMonth() &&
                    currentYear === todayDate.getFullYear()) {
                    dayClass += ' today';
                }

                // 이벤트 있는 날짜 (시스템 이벤트 또는 사용자 이벤트)
                if (calendarEvents[dateStr] || userEvents[dateStr]) {
                    dayClass += ' has-event';
                }

                // 사용자 일정 제목 가져오기
                let eventTitle = '';
                if (userEvents[dateStr] && userEvents[dateStr].length > 0) {
                    eventTitle = userEvents[dateStr][0].title; // 첫 번째 일정 제목만 표시
                    if (userEvents[dateStr].length > 1) {
                        eventTitle += ' +' + (userEvents[dateStr].length - 1); // 추가 일정 개수 표시
                    }
                }

                let eventDots = '';
                // 시스템 이벤트 표시
                if (calendarEvents[dateStr]) {
                    calendarEvents[dateStr].forEach(function(eventType) {
                        eventDots += '<div class="event-dot ' + eventType + '"></div>';
                    });
                }
                // 사용자 이벤트 표시 (사용자 지정 색상으로 표시)
                if (userEvents[dateStr] && userEvents[dateStr].length > 0) {
                    for (let i = 0; i < Math.min(userEvents[dateStr].length, 3); i++) {
                        eventDots += '<div class="event-dot" style="background: #9b59b6;"></div>';
                    }
                }

                calendarHTML += '<div class="' + dayClass + '" data-date="' + dateStr + '" onclick="openEventModal(\'' + dateStr + '\')" style="cursor: pointer;">';
                calendarHTML += '<div class="calendar-day-number">' + day + '</div>';
                if (eventTitle) {
                    calendarHTML += '<div class="calendar-event-text">' + eventTitle + '</div>';
                }
                calendarHTML += '<div class="calendar-events">' + eventDots + '</div>';
                calendarHTML += '</div>';
            }

            // 다음 달 날짜 (7의 배수로 맞추기)
            const totalCells = firstDayOfWeek + lastDate;
            const nextDays = totalCells % 7 === 0 ? 0 : 7 - (totalCells % 7);
            for (let i = 1; i <= nextDays; i++) {
                calendarHTML += '<div class="calendar-day other-month">';
                calendarHTML += '<div class="calendar-day-number">' + i + '</div>';
                calendarHTML += '</div>';
            }

            calendarDays.innerHTML = calendarHTML;
            console.log('Calendar rendered successfully');
        }

        // 이전 달로 이동
        function previousMonth() {
            currentMonth--;
            if (currentMonth < 0) {
                currentMonth = 11;
                currentYear--;
            }
            renderMonthCalendar();
        }

        // 다음 달로 이동
        function nextMonth() {
            currentMonth++;
            if (currentMonth > 11) {
                currentMonth = 0;
                currentYear++;
            }
            renderMonthCalendar();
        }

        // 오늘로 이동
        function goToToday() {
            currentYear = todayDate.getFullYear();
            currentMonth = todayDate.getMonth();
            renderMonthCalendar();
        }

        // 네비바 메뉴
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM Content Loaded');

            // 프로필 이미지 로드
            loadProfileImage();

            // 프로필 이미지 업로드 이벤트
            const profileImageInput = document.getElementById('profileImageInput');
            if (profileImageInput) {
                profileImageInput.addEventListener('change', function(e) {
                    const file = e.target.files[0];
                    if (file) {
                        uploadProfileImage(file);
                    }
                });
            }

            // 로그아웃 버튼 클릭 이벤트
            const logoutBtn = document.getElementById('logoutBtn');
            if (logoutBtn) {
                logoutBtn.addEventListener('click', function(e) {
                    e.preventDefault();

                    if (confirm('로그아웃 하시겠습니까?')) {
                        const contextPath = '<%= request.getContextPath() %>';

                        fetch(contextPath + '/api/auth/logout', {
                            method: 'GET'
                        })
                        .then(response => response.json())
                        .then(data => {
                            if (data.success) {
                                alert('로그아웃되었습니다.');
                                window.location.href = contextPath + '/projectLogin.jsp';
                            } else {
                                alert('로그아웃 중 오류가 발생했습니다.');
                            }
                        })
                        .catch(error => {
                            console.error('로그아웃 오류:', error);
                            alert('로그아웃 중 오류가 발생했습니다.');
                        });
                    }
                });
            }

            // 시간대 감지 및 캘린더 초기화
            try {
                // 현재 날짜로 초기화
                currentYear = todayDate.getFullYear();
                currentMonth = todayDate.getMonth();

                detectUserTimezone();
                initEvents();
                loadUserEvents(); // 사용자 일정 불러오기
                loadVolunteerApplications(); // 봉사 신청 내역 불러오기
                loadDonations(); // 기부 내역 불러오기
                loadFavoriteServices(); // 관심 복지 서비스 불러오기
                loadDiagnosisHistory(); // 복지 진단 내역 불러오기
                renderMonthCalendar();
            } catch (error) {
                console.error('Error initializing calendar:', error);
            }

            // 모달 외부 클릭 시 닫기
            const modal = document.getElementById('eventModal');
            if (modal) {
                modal.addEventListener('click', function(e) {
                    if (e.target === modal) {
                        closeEventModal();
                    }
                });
            }

            // ESC 키로 모달 닫기
            document.addEventListener('keydown', function(e) {
                if (e.key === 'Escape' && modal.classList.contains('active')) {
                    closeEventModal();
                }
            });

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

            // 사이드바 메뉴 클릭
            const menuItems = document.querySelectorAll('.menu-item');
            const contentPages = document.querySelectorAll('.content-page');

            menuItems.forEach(item => {
                item.addEventListener('click', function(e) {
                    e.preventDefault();

                    // 메뉴 active 상태 변경
                    menuItems.forEach(mi => mi.classList.remove('active'));
                    this.classList.add('active');

                    // 콘텐츠 페이지 전환
                    const contentId = this.getAttribute('data-content');
                    contentPages.forEach(page => {
                        page.style.display = 'none';
                    });

                    const targetContent = document.getElementById('content-' + contentId);
                    if (targetContent) {
                        targetContent.style.display = 'block';
                    }

                    // 알림 페이지 열 때 예정된 일정 표시
                    if (contentId === 'notifications') {
                        setTimeout(displayUpcomingEvents, 100);
                    }

                    // 페이지 상단으로 스크롤
                    window.scrollTo({top: 0, behavior: 'smooth'});
                });
            });

            // 프로필 폼 제출
            const profileForm = document.getElementById('profileForm');
            if (profileForm) {
                profileForm.addEventListener('submit', function(e) {
                    e.preventDefault();
                    alert('회원 정보가 성공적으로 수정되었습니다.');
                });
            }

            // 비밀번호 변경 폼
            const passwordForm = document.getElementById('passwordForm');
            if (passwordForm) {
                passwordForm.addEventListener('submit', function(e) {
                    e.preventDefault();

                    const currentPw = document.getElementById('currentPassword').value;
                    const newPw = document.getElementById('newPassword').value;
                    const confirmPw = document.getElementById('confirmPassword').value;

                    if (!currentPw || !newPw || !confirmPw) {
                        alert('모든 항목을 입력해주세요.');
                        return;
                    }

                    if (newPw !== confirmPw) {
                        alert('새 비밀번호가 일치하지 않습니다.');
                        return;
                    }

                    if (newPw.length < 8) {
                        alert('비밀번호는 8자 이상이어야 합니다.');
                        return;
                    }

                    // 서버에 비밀번호 변경 요청
                    const formData = new URLSearchParams();
                    formData.append('currentPassword', currentPw);
                    formData.append('newPassword', newPw);

                    fetch('/bdproject/api/member/changePassword', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: formData.toString()
                    })
                    .then(response => response.json())
                    .then(data => {
                        if (data.success) {
                            alert('비밀번호가 성공적으로 변경되었습니다.');
                            passwordForm.reset();
                            document.getElementById('strengthBar').className = 'password-strength-bar';
                            document.getElementById('strengthText').textContent = '비밀번호 강도: -';
                            document.getElementById('matchText').textContent = '';
                        } else {
                            alert(data.message || '비밀번호 변경에 실패했습니다.');
                        }
                    })
                    .catch(error => {
                        console.error('비밀번호 변경 오류:', error);
                        alert('비밀번호 변경 중 오류가 발생했습니다.');
                    });
                });
            }

            // 비밀번호 강도 체크
            const newPassword = document.getElementById('newPassword');
            if (newPassword) {
                newPassword.addEventListener('input', function() {
                    const password = this.value;
                    const strengthBar = document.getElementById('strengthBar');
                    const strengthText = document.getElementById('strengthText');

                    if (password.length === 0) {
                        strengthBar.className = 'password-strength-bar';
                        strengthText.textContent = '비밀번호 강도: -';
                        return;
                    }

                    let strength = 0;
                    if (password.length >= 8) strength++;
                    if (/[a-z]/.test(password) && /[A-Z]/.test(password)) strength++;
                    if (/\d/.test(password)) strength++;
                    if (/[^a-zA-Z\d]/.test(password)) strength++;

                    if (strength <= 2) {
                        strengthBar.className = 'password-strength-bar weak';
                        strengthText.textContent = '비밀번호 강도: 약함';
                    } else if (strength === 3) {
                        strengthBar.className = 'password-strength-bar medium';
                        strengthText.textContent = '비밀번호 강도: 보통';
                    } else {
                        strengthBar.className = 'password-strength-bar strong';
                        strengthText.textContent = '비밀번호 강도: 강함';
                    }
                });
            }

            // 비밀번호 확인 체크
            const confirmPassword = document.getElementById('confirmPassword');
            if (confirmPassword && newPassword) {
                confirmPassword.addEventListener('input', function() {
                    const matchText = document.getElementById('matchText');
                    if (this.value.length === 0) {
                        matchText.textContent = '';
                        matchText.style.color = '';
                        return;
                    }

                    if (this.value === newPassword.value) {
                        matchText.textContent = '✓ 비밀번호가 일치합니다';
                        matchText.style.color = '#28a745';
                    } else {
                        matchText.textContent = '✗ 비밀번호가 일치하지 않습니다';
                        matchText.style.color = '#dc3545';
                    }
                });
            }
        });

        // 주소 검색
        function searchAddress() {
            new daum.Postcode({
                oncomplete: function(data) {
                    document.querySelector('input[value="06234"]').value = data.zonecode;
                    document.querySelector('input[value="서울특별시 강남구 테헤란로 123"]').value = data.address;
                    document.querySelector('input[value="복지빌딩 4층"]').focus();
                }
            }).open();
        }

        // 폼 리셋
        function resetForm() {
            if (confirm('변경사항을 취소하시겠습니까?')) {
                document.getElementById('profileForm').reset();
            }
        }

        // 회원 탈퇴
        function confirmWithdrawal() {
            if (confirm('정말로 회원 탈퇴를 하시겠습니까?\n\n탈퇴 시 모든 정보가 삭제되며 복구가 불가능합니다.')) {
                if (confirm('한 번 더 확인합니다. 정말 탈퇴하시겠습니까?')) {
                    alert('회원 탈퇴가 완료되었습니다.');
                }
            }
        }

        // 알림 설정 저장
        function saveNotificationSettings() {
            const settings = {
                event: document.getElementById('eventNotification').checked,
                donation: document.getElementById('donationNotification').checked,
                volunteer: document.getElementById('volunteerNotification').checked,
                faqAnswer: document.getElementById('faqAnswerNotification').checked
            };
            localStorage.setItem('notificationSettings', JSON.stringify(settings));
        }

        // 알림 목록 불러오기
        async function loadNotifications() {
            try {
                const response = await fetch('/bdproject/api/notifications');
                const result = await response.json();

                if (result.success && result.data) {
                    const notifications = result.data;
                    // 알림 데이터를 전역 변수에 캐시
                    window.cachedNotifications = notifications;
                    displayNotifications(notifications, 'all');
                    updateNotificationCounts(notifications);
                    updateNotificationBadge(notifications);
                    // 최근 활동 업데이트
                    updateRecentActivity();
                }
            } catch (error) {
                console.error('알림 로딩 오류:', error);
            }
        }

        // 알림 표시
        function displayNotifications(notifications, filter) {
            const container = document.getElementById('notificationList');

            let filtered = notifications;
            if (filter !== 'all') {
                if (filter === 'unread') {
                    filtered = notifications.filter(n => !n.is_read);
                } else {
                    filtered = notifications.filter(n => n.type === filter);
                }
            }

            if (filtered.length === 0) {
                container.innerHTML = '<div class="empty-state"><i class="fas fa-bell"></i><p>받은 알림이 없습니다</p></div>';
                return;
            }

            let html = '';
            filtered.forEach(notif => {
                const typeText = getNotificationTypeText(notif.type);
                const readClass = notif.is_read ? '' : 'unread';
                const date = new Date(notif.created_at).toLocaleString('ko-KR');

                html += `
                    <div class="notification-item ${readClass}" data-id="${notif.notification_id}">
                        <div class="notification-item-content" onclick="markAsReadAndRedirect(${notif.notification_id}, '${notif.related_url || '#'}')">
                            <div>
                                <span class="notification-item-type type-${notif.type}">${typeText}</span>
                                <span class="notification-item-title">${notif.title}</span>
                            </div>
                            <p style="margin: 8px 0 0 0; font-size: 14px; color: #555;">${notif.content}</p>
                            <div class="notification-item-date">${date}</div>
                        </div>
                        <button class="notification-delete-btn" onclick="deleteNotification(${notif.notification_id}, event)">
                            <i class="fas fa-trash"></i>
                        </button>
                    </div>
                `;
            });

            container.innerHTML = html;
        }

        // 알림 유형 텍스트 변환
        function getNotificationTypeText(type) {
            const typeMap = {
                'faq_answer': 'FAQ 답변',
                'schedule': '일정',
                'donation': '기부',
                'volunteer': '봉사',
                'system': '시스템'
            };
            return typeMap[type] || '알림';
        }

        // 알림 카운트 업데이트
        function updateNotificationCounts(notifications) {
            const all = notifications.length;
            const unread = notifications.filter(n => !n.is_read).length;

            document.getElementById('allCount').textContent = all;
            document.getElementById('unreadCount').textContent = unread;
        }

        // 알림 배지 업데이트
        function updateNotificationBadge(notifications) {
            const unread = notifications.filter(n => !n.is_read).length;
            const badge = document.getElementById('notificationBadge');
            if (badge) {
                badge.textContent = unread;
                if (unread > 0) {
                    badge.style.display = 'inline-block';
                } else {
                    badge.style.display = 'none';
                }
            }
        }

        // 알림 필터링
        function filterNotifications(filter) {
            // 버튼 활성화 상태 변경
            document.querySelectorAll('.notification-filter-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            document.querySelector(`[data-filter="${filter}"]`).classList.add('active');

            // 알림 다시 로드하여 필터 적용
            loadNotifications().then(() => {
                // 필터링 로직은 displayNotifications에서 처리
            });
        }

        // 알림 읽음 처리 및 리다이렉트
        async function markAsReadAndRedirect(notificationId, url) {
            try {
                await fetch(`/bdproject/api/notifications/${notificationId}/read`, {
                    method: 'POST'
                });

                // 알림 목록 새로고침
                await loadNotifications();

                // URL이 있으면 이동
                if (url && url !== '#') {
                    window.location.href = url;
                }
            } catch (error) {
                console.error('알림 읽음 처리 오류:', error);
            }
        }

        // 모두 읽음 처리
        async function markAllAsRead() {
            if (!confirm('모든 알림을 읽음 처리하시겠습니까?')) {
                return;
            }

            try {
                const response = await fetch('/bdproject/api/notifications/read-all', {
                    method: 'POST'
                });
                const result = await response.json();

                if (result.success) {
                    alert('모든 알림이 읽음 처리되었습니다.');
                    await loadNotifications();
                }
            } catch (error) {
                console.error('모두 읽음 처리 오류:', error);
                alert('알림 처리 중 오류가 발생했습니다.');
            }
        }

        // 알림 삭제
        async function deleteNotification(notificationId, event) {
            event.stopPropagation();

            if (!confirm('이 알림을 삭제하시겠습니까?')) {
                return;
            }

            try {
                const response = await fetch(`/bdproject/api/notifications/${notificationId}`, {
                    method: 'DELETE'
                });
                const result = await response.json();

                if (result.success) {
                    await loadNotifications();
                }
            } catch (error) {
                console.error('알림 삭제 오류:', error);
                alert('알림 삭제 중 오류가 발생했습니다.');
            }
        }

        // 보안 설정 저장
        function saveSecuritySettings() {
            const settings = {
                activityHistory: document.getElementById('activityHistoryEnabled').checked,
                diagnosisHistory: document.getElementById('diagnosisHistoryEnabled').checked,
                calendarStorage: document.getElementById('calendarStorageEnabled').checked,
                analytics: document.getElementById('analyticsEnabled').checked,
                autoLogout: document.getElementById('autoLogoutEnabled').checked,
                twoFactor: document.getElementById('twoFactorEnabled').checked
            };
            localStorage.setItem('securitySettings', JSON.stringify(settings));

            // 최근 활동 표시 설정이 변경되면 즉시 반영
            if (!settings.activityHistory) {
                document.getElementById('recentActivityList').innerHTML = '<div class="empty-state"><i class="fas fa-user-shield"></i><p>활동 기록이 비활성화되어 있습니다.</p></div>';
            } else {
                updateRecentActivity();
            }
        }

        // 보안 설정 불러오기
        function loadSecuritySettings() {
            const stored = localStorage.getItem('securitySettings');
            if (stored) {
                try {
                    const settings = JSON.parse(stored);
                    document.getElementById('activityHistoryEnabled').checked = settings.activityHistory !== false;
                    document.getElementById('diagnosisHistoryEnabled').checked = settings.diagnosisHistory !== false;
                    document.getElementById('calendarStorageEnabled').checked = settings.calendarStorage !== false;
                    document.getElementById('analyticsEnabled').checked = settings.analytics !== false;
                    document.getElementById('autoLogoutEnabled').checked = settings.autoLogout !== false;
                    document.getElementById('twoFactorEnabled').checked = settings.twoFactor === true;
                } catch (e) {
                    console.error('Failed to load security settings:', e);
                }
            }
        }

        // 모든 데이터 내보내기
        function exportAllData() {
            const data = {
                events: userEvents,
                notificationSettings: JSON.parse(localStorage.getItem('notificationSettings') || '{}'),
                securitySettings: JSON.parse(localStorage.getItem('securitySettings') || '{}'),
                exportDate: new Date().toISOString()
            };

            const blob = new Blob([JSON.stringify(data, null, 2)], { type: 'application/json' });
            const url = URL.createObjectURL(blob);
            const a = document.createElement('a');
            a.href = url;
            a.download = 'welfare24_data_' + new Date().toISOString().split('T')[0] + '.json';
            document.body.appendChild(a);
            a.click();
            document.body.removeChild(a);
            URL.revokeObjectURL(url);

            alert('데이터가 성공적으로 내보내졌습니다.');
        }

        // 모든 데이터 삭제
        function deleteAllData() {
            if (!confirm('정말로 모든 데이터를 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
                return;
            }

            if (!confirm('마지막 확인: 모든 일정, 설정, 활동 기록이 영구적으로 삭제됩니다. 계속하시겠습니까?')) {
                return;
            }

            // 모든 localStorage 데이터 삭제
            localStorage.removeItem('userEvents');
            localStorage.removeItem('notificationSettings');
            localStorage.removeItem('securitySettings');

            // 메모리 데이터 초기화
            userEvents = {};

            // UI 업데이트
            renderMonthCalendar();
            displayUpcomingEvents();
            updateRecentActivity();
            loadNotificationSettings();
            loadSecuritySettings();

            alert('모든 데이터가 삭제되었습니다.');
        }

        // 알림 설정 불러오기
        function loadNotificationSettings() {
            const stored = localStorage.getItem('notificationSettings');
            if (stored) {
                try {
                    const settings = JSON.parse(stored);
                    document.getElementById('eventNotification').checked = settings.event !== false;
                    document.getElementById('donationNotification').checked = settings.donation !== false;
                    document.getElementById('volunteerNotification').checked = settings.volunteer !== false;
                } catch (e) {
                    console.error('Failed to load notification settings:', e);
                }
            }
        }

        // 예정된 일정 표시
        function displayUpcomingEvents() {
            const container = document.getElementById('upcomingEventsList');
            if (!container) return;

            const today = new Date();
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);
            const nextWeek = new Date(today);
            nextWeek.setDate(nextWeek.getDate() + 7);

            const upcomingEvents = [];
            const processedEventIds = new Set();

            // 모든 사용자 일정 확인
            for (const dateStr in userEvents) {
                const eventDate = new Date(dateStr);
                if (eventDate >= today && eventDate <= nextWeek) {
                    userEvents[dateStr].forEach(event => {
                        // 이미 처리된 일정은 건너뛰기 (범위 일정의 경우)
                        if (!processedEventIds.has(event.id)) {
                            processedEventIds.add(event.id);

                            const startDate = new Date(event.startDate || dateStr);
                            const daysDiff = Math.floor((startDate - today) / (1000 * 60 * 60 * 24));

                            upcomingEvents.push({
                                date: event.startDate || dateStr,
                                endDate: event.endDate,
                                event: event,
                                daysDiff: daysDiff
                            });
                        }
                    });
                }
            }

            // 날짜순 정렬
            upcomingEvents.sort((a, b) => new Date(a.date) - new Date(b.date));

            if (upcomingEvents.length === 0) {
                container.innerHTML = '<div class="empty-state"><i class="fas fa-calendar-alt"></i><p>예정된 일정이 없습니다</p></div>';
                return;
            }

            let html = '';
            upcomingEvents.forEach((item, index) => {
                const badge = item.daysDiff === 0 ? '오늘' : item.daysDiff === 1 ? '내일' : item.daysDiff + '일 후';

                // 날짜 범위 표시
                let dateDisplay = '';
                if (item.endDate && item.endDate !== item.date) {
                    dateDisplay = formatDateDisplay(item.date) + ' ~ ' + formatDateDisplay(item.endDate);
                } else {
                    dateDisplay = formatDateDisplay(item.date);
                }

                html += '<div class="notification-item">';
                html += '<div class="notification-item-content">';
                html += '<div class="notification-item-title">' + item.event.title + '</div>';
                html += '<div class="notification-item-date">' + dateDisplay + '</div>';
                html += '</div>';
                html += '<div style="display: flex; align-items: center; gap: 10px;">';
                html += '<span class="notification-item-badge">' + badge + '</span>';
                html += '<button class="notification-delete-btn" onclick="deleteEventFromNotification(\'' + item.event.id + '\')" title="일정 삭제">';
                html += '<i class="fas fa-trash-alt"></i>';
                html += '</button>';
                html += '</div>';
                html += '</div>';
            });

            container.innerHTML = html;
        }

        // 알림 설정에서 일정 삭제 (ID 기반)
        function deleteEventFromNotification(eventId) {
            if (!confirm('이 일정을 삭제하시겠습니까?')) {
                return;
            }

            // 모든 날짜에서 해당 ID의 일정 삭제
            for (const dateStr in userEvents) {
                userEvents[dateStr] = userEvents[dateStr].filter(event => event.id !== eventId);

                // 빈 배열이면 날짜 키도 삭제
                if (userEvents[dateStr].length === 0) {
                    delete userEvents[dateStr];
                }
            }

            // localStorage 저장 (계정별)
            saveUserEvents();

            // UI 업데이트
            displayUpcomingEvents();
            renderMonthCalendar();
            updateRecentActivity();
        }

        // 최근 활동 업데이트
        function updateRecentActivity() {
            const container = document.getElementById('recentActivityList');
            if (!container) return;

            // 보안 설정 확인
            const securitySettings = JSON.parse(localStorage.getItem('securitySettings') || '{}');
            if (securitySettings.activityHistory === false) {
                container.innerHTML = '<div class="empty-state"><i class="fas fa-user-shield"></i><p>활동 기록이 비활성화되어 있습니다.</p></div>';
                return;
            }

            let html = '';

            // 캘린더 일정 내역 가져오기 (최근 30일)
            const today = new Date();
            const thirtyDaysAgo = new Date(today);
            thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

            const recentEvents = [];
            const processedEventIds = new Set();

            for (const dateStr in userEvents) {
                const eventDate = new Date(dateStr);
                if (eventDate >= thirtyDaysAgo) {
                    userEvents[dateStr].forEach(event => {
                        // 이미 처리된 일정은 건너뛰기 (범위 일정의 경우)
                        if (!processedEventIds.has(event.id)) {
                            processedEventIds.add(event.id);

                            const startDate = new Date(event.startDate || dateStr);
                            recentEvents.push({
                                date: event.startDate || dateStr,
                                endDate: event.endDate,
                                event: event,
                                timestamp: startDate.getTime()
                            });
                        }
                    });
                }
            }

            // 날짜순 정렬 (최신순)
            recentEvents.sort((a, b) => b.timestamp - a.timestamp);

            // 페이지네이션 처리
            const currentPage = window.recentActivityPage || 1;
            const itemsPerPage = 10;
            const totalPages = Math.ceil(recentEvents.length / itemsPerPage);
            const startIndex = (currentPage - 1) * itemsPerPage;
            const endIndex = startIndex + itemsPerPage;
            const displayEvents = recentEvents.slice(startIndex, endIndex);

            displayEvents.forEach(item => {
                const dateObj = new Date(item.date);
                const formattedDate = dateObj.getFullYear() + '.' +
                                    String(dateObj.getMonth() + 1).padStart(2, '0') + '.' +
                                    String(dateObj.getDate()).padStart(2, '0');

                // 날짜 범위 표시
                let dateDisplay = formattedDate;
                if (item.endDate && item.endDate !== item.date) {
                    const endDateObj = new Date(item.endDate);
                    const endFormatted = endDateObj.getFullYear() + '.' +
                                        String(endDateObj.getMonth() + 1).padStart(2, '0') + '.' +
                                        String(endDateObj.getDate()).padStart(2, '0');
                    dateDisplay = formattedDate + ' ~ ' + endFormatted;
                }

                html += '<div class="list-item">';
                html += '<div class="list-item-header">';
                html += '<span class="list-item-title"><i class="fas fa-calendar-plus" style="color: #4A90E2; margin-right: 5px;"></i>' + item.event.title + '</span>';
                html += '<div style="display: flex; align-items: center; gap: 10px;">';
                html += '<span class="list-item-date">' + dateDisplay + '</span>';
                html += '<button onclick="deleteRecentActivity(\'' + item.event.id + '\')" style="background: none; border: none; color: #dc3545; cursor: pointer; font-size: 18px; padding: 4px 8px; border-radius: 4px; transition: all 0.2s;" onmouseenter="this.style.background=\'#fee\'" onmouseleave="this.style.background=\'none\'" title="일정 삭제"><i class="fas fa-times"></i></button>';
                html += '</div>';
                html += '</div>';
                html += '<div class="list-item-content">';
                html += item.event.description || '일정이 등록되었습니다.';
                html += '</div>';
                html += '</div>';
            });

            // 알림 기반 활동 표시 (캘린더 일정이 없을 경우)
            if (recentEvents.length === 0) {
                // 알림 데이터가 있다면 알림을 최근 활동으로 표시
                const notificationsData = window.cachedNotifications || [];

                if (notificationsData.length > 0) {
                    const recentNotifications = notificationsData.slice(0, 10);
                    recentNotifications.forEach(notif => {
                        const date = new Date(notif.created_at);
                        const formattedDate = date.getFullYear() + '.' +
                                            String(date.getMonth() + 1).padStart(2, '0') + '.' +
                                            String(date.getDate()).padStart(2, '0');

                        let icon = 'fas fa-bell';
                        let iconColor = '#4A90E2';
                        if (notif.type === 'faq_answer') {
                            icon = 'fas fa-comment-dots';
                            iconColor = '#28a745';
                        } else if (notif.type === 'donation') {
                            icon = 'fas fa-heart';
                            iconColor = '#e74c3c';
                        } else if (notif.type === 'volunteer') {
                            icon = 'fas fa-hands-helping';
                            iconColor = '#f39c12';
                        } else if (notif.type === 'schedule') {
                            icon = 'fas fa-calendar';
                            iconColor = '#9b59b6';
                        }

                        html += '<div class="list-item">';
                        html += '<div class="list-item-header">';
                        html += '<span class="list-item-title"><i class="' + icon + '" style="color: ' + iconColor + '; margin-right: 5px;"></i>' + notif.title + '</span>';
                        html += '<span class="list-item-date">' + formattedDate + '</span>';
                        html += '</div>';
                        html += '<div class="list-item-content">';
                        html += notif.content;
                        html += '</div>';
                        html += '</div>';
                    });
                } else {
                    html += '<div class="empty-state"><i class="fas fa-clock"></i><p>최근 활동이 없습니다.</p></div>';
                }
            }

            // 페이지네이션 추가
            if (totalPages > 1) {
                html += '<div class="pagination">';
                for (let i = 1; i <= totalPages; i++) {
                    const activeClass = i === currentPage ? 'active' : '';
                    html += '<button class="pagination-btn ' + activeClass + '" onclick="changeRecentActivityPage(' + i + ')">' + i + '</button>';
                }
                html += '</div>';
            }

            container.innerHTML = html;
        }

        // 최근 활동 페이지 변경
        function changeRecentActivityPage(page) {
            window.recentActivityPage = page;
            updateRecentActivity();
        }

        // 최근 활동(캘린더 일정) 삭제 함수
        function deleteRecentActivity(eventId) {
            console.log('삭제 시도 - 이벤트 ID:', eventId);
            console.log('현재 userEvents:', userEvents);

            if (!confirm('이 일정을 삭제하시겠습니까?')) {
                return;
            }

            // userEvents에서 해당 이벤트 삭제 (모든 날짜에서)
            let deleted = false;
            const datesToDelete = [];
            let deleteCount = 0;

            for (const dateStr in userEvents) {
                const events = userEvents[dateStr];
                console.log('날짜:', dateStr, '이벤트 목록:', events);

                // 해당 ID를 가진 모든 이벤트 찾기
                for (let i = events.length - 1; i >= 0; i--) {
                    console.log('비교:', events[i].id, '===', eventId, '결과:', events[i].id === eventId);
                    if (events[i].id === eventId || events[i].id == eventId) {
                        console.log('일정 발견! 삭제:', dateStr, events[i]);
                        events.splice(i, 1);
                        deleteCount++;
                        deleted = true;
                    }
                }

                if (events.length === 0) {
                    datesToDelete.push(dateStr);
                }
            }

            console.log('삭제된 이벤트 수:', deleteCount);

            // 빈 날짜 항목 제거
            datesToDelete.forEach(dateStr => {
                delete userEvents[dateStr];
            });

            if (deleted) {
                console.log('삭제 성공! localStorage 저장 중...');
                // localStorage에 저장
                saveUserEvents();

                // 캘린더 다시 렌더링
                renderMonthCalendar();

                // 최근 활동 목록 업데이트
                updateRecentActivity();
                alert('일정이 삭제되었습니다.');
            } else {
                console.error('일정을 찾지 못했습니다. 이벤트 ID:', eventId);
                alert('일정을 찾을 수 없습니다.');
            }
        }

        // 페이지 초기화 시 알림 설정 불러오기
        document.addEventListener('DOMContentLoaded', function() {
            loadNotificationSettings();
            loadSecuritySettings();
            updateRecentActivity();
            loadNotifications();
            loadKindnessTemperature(); // 선행 온도 로드

            // 언어 번역 토글
            const languageToggle = document.getElementById('languageToggle');
            const translateElement = document.getElementById('google_translate_element');

            if (languageToggle && translateElement) {
                languageToggle.addEventListener('click', function(e) {
                    e.stopPropagation();
                    if (translateElement.style.display === 'none' || translateElement.style.display === '') {
                        translateElement.style.display = 'block';
                    } else {
                        translateElement.style.display = 'none';
                    }
                });

                // 외부 클릭 시 닫기
                document.addEventListener('click', function(e) {
                    if (!e.target.closest('.language-selector')) {
                        translateElement.style.display = 'none';
                    }
                });
            }
        });

        // === 봉사 후기 작성 모달 ===
        let currentApplicationId = null;
        let currentActivityName = '';

        // 프로필 이미지 업로드 함수
        function uploadProfileImage(file) {
            const contextPath = '<%= request.getContextPath() %>';

            // 파일 크기 검증 (5MB)
            if (file.size > 5 * 1024 * 1024) {
                alert('파일 크기는 5MB를 초과할 수 없습니다.');
                return;
            }

            // 파일 형식 검증
            const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif', 'image/webp'];
            if (!allowedTypes.includes(file.type)) {
                alert('JPG, PNG, GIF, WEBP 형식의 이미지만 업로드 가능합니다.');
                return;
            }

            const formData = new FormData();
            formData.append('image', file);

            // 로딩 표시
            const avatar = document.getElementById('userAvatar');
            const uploadBtn = avatar.querySelector('.avatar-upload-btn');
            uploadBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i>';

            fetch(contextPath + '/api/profile/upload-image', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    // 이미지 미리보기
                    const img = document.createElement('img');
                    img.src = contextPath + data.imageUrl;
                    img.alt = 'Profile';

                    // 기존 내용 제거하고 이미지 추가
                    const initial = document.getElementById('avatarInitial');
                    if (initial) {
                        initial.style.display = 'none';
                    }

                    // 기존 이미지 제거
                    const existingImg = avatar.querySelector('img');
                    if (existingImg) {
                        existingImg.remove();
                    }

                    // 새 이미지 추가
                    avatar.insertBefore(img, uploadBtn);

                    alert('프로필 이미지가 업로드되었습니다.');
                } else {
                    alert(data.message || '이미지 업로드에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('업로드 오류:', error);
                alert('이미지 업로드 중 오류가 발생했습니다.');
            })
            .finally(() => {
                // 업로드 버튼 원래대로
                uploadBtn.innerHTML = '<i class="fas fa-plus"></i>';
            });
        }

        // 프로필 이미지 로드 함수
        function loadProfileImage() {
            const contextPath = '<%= request.getContextPath() %>';

            fetch(contextPath + '/api/profile/image')
            .then(response => response.json())
            .then(data => {
                if (data.success && data.imageUrl) {
                    const avatar = document.getElementById('userAvatar');
                    const initial = document.getElementById('avatarInitial');
                    const uploadBtn = avatar.querySelector('.avatar-upload-btn');

                    // 이미지 생성
                    const img = document.createElement('img');
                    img.src = contextPath + data.imageUrl;
                    img.alt = 'Profile';

                    // 이니셜 숨기기
                    if (initial) {
                        initial.style.display = 'none';
                    }

                    // 이미지 추가
                    avatar.insertBefore(img, uploadBtn);
                }
            })
            .catch(error => {
                console.error('프로필 이미지 로드 오류:', error);
            });
        }

        function openReviewModal(applicationId, activityName) {
            console.log('Opening review modal for application:', applicationId);
            currentApplicationId = applicationId;
            currentActivityName = activityName;
            document.getElementById('reviewActivityName').textContent = activityName;
            document.getElementById('reviewModal').style.display = 'flex';
        }

        function closeReviewModal() {
            document.getElementById('reviewModal').style.display = 'none';
            document.getElementById('reviewForm').reset();
            currentApplicationId = null;
            currentActivityName = '';
        }

        // DOM이 로드된 후 이벤트 리스너 등록
        document.addEventListener('DOMContentLoaded', function() {
            console.log('Setting up review form listener...');

            // 후기 작성 폼 제출
            const reviewForm = document.getElementById('reviewForm');
            console.log('Review form element:', reviewForm);

            if (reviewForm) {
                reviewForm.addEventListener('submit', function(e) {
                    e.preventDefault();
                    console.log('Review form submitted');

                    const title = document.getElementById('reviewTitle').value.trim();
                    const content = document.getElementById('reviewContent').value.trim();
                    const rating = document.getElementById('reviewRating').value;

                    console.log('Form data:', { title, content, rating, applicationId: currentApplicationId });

                    if (!title || !content) {
                        alert('제목과 내용을 모두 입력해주세요.');
                        return;
                    }

                    const formData = new URLSearchParams();
                    formData.append('applicationId', currentApplicationId);
                    formData.append('title', title);
                    formData.append('content', content);
                    if (rating) {
                        formData.append('rating', rating);
                    }

                    console.log('Sending request to:', '/bdproject/api/volunteer/review/create');

                    fetch('/bdproject/api/volunteer/review/create', {
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/x-www-form-urlencoded'
                        },
                        body: formData.toString()
                    })
                    .then(response => {
                        console.log('Response status:', response.status);
                        return response.json();
                    })
                    .then(data => {
                        console.log('Response data:', data);
                        if (data.success) {
                            alert('후기가 성공적으로 작성되었습니다!');
                            closeReviewModal();
                            loadVolunteerApplications(); // 목록 새로고침

                            // 선행 온도 업데이트 (백엔드에서 이미 증가됨)
                            refreshKindnessTemperature();
                        } else {
                            alert(data.message || '후기 작성에 실패했습니다.');
                        }
                    })
                    .catch(error => {
                        console.error('후기 작성 오류:', error);
                        alert('후기 작성 중 오류가 발생했습니다.');
                    });
                });
                console.log('Review form listener registered successfully');
            } else {
                console.error('Review form not found!');
            }

            // 모달 외부 클릭 시 닫기
            window.addEventListener('click', function(e) {
                const modal = document.getElementById('reviewModal');
                if (e.target === modal) {
                    closeReviewModal();
                }
            });
        });
    </script>

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
