<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ include file="navi.jsp" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>복지24</title>
    <link rel="icon" type="image/png" href="resources/image/복지로고.png">
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: 'Arial', 'Noto Sans KR', sans-serif;
            background-color: #f5f7fa;
            color: #333;
            line-height: 1.6;
        }

        .container {
            max-width: 1000px;
            margin: 0 auto;
            padding: 20px;
        }

        .board-detail {
            background: white;
            border-radius: 15px;
            box-shadow: 0 8px 25px rgba(0,0,0,0.1);
            overflow: hidden;
            margin-bottom: 30px;
        }

        .post-header {
            background: #f8f9fa;
            padding: 30px;
            border-bottom: 3px solid #e9ecef;
        }

        .post-title {
            font-size: 1.8rem;
            font-weight: 600;
            color: #2c3e50;
            margin-bottom: 20px;
            line-height: 1.3;
        }

        .post-info {
            display: flex;
            flex-wrap: wrap;
            gap: 25px;
            color: #6c757d;
            font-size: 0.95rem;
        }

        .post-info span {
            display: flex;
            align-items: center;
            gap: 8px;
        }

        .post-info span::before {
            content: '';
            width: 4px;
            height: 4px;
            background: #667eea;
            border-radius: 50%;
        }

        .post-content {
            padding: 40px;
            font-size: 1.1rem;
            line-height: 1.8;
            color: #495057;
        }

        .post-content p {
            margin-bottom: 20px;
        }

        .post-stats {
            background: #f8f9fa;
            padding: 20px 40px;
            border-top: 1px solid #e9ecef;
            display: flex;
            justify-content: space-between;
            align-items: center;
            flex-wrap: wrap;
            gap: 15px;
        }

        .stats-item {
            display: flex;
            align-items: center;
            gap: 8px;
            color: #6c757d;
            font-size: 0.9rem;
        }

        .stats-icon {
            width: 18px;
            height: 18px;
            fill: #667eea;
        }

        .action-buttons {
            display: flex;
            justify-content: center;
            gap: 15px;
            margin-bottom: 40px;
            flex-wrap: wrap;
        }

        .btn {
            padding: 12px 30px;
            border: none;
            border-radius: 25px;
            cursor: pointer;
            font-size: 1rem;
            font-weight: 500;
            transition: all 0.3s ease;
            text-decoration: none;
            display: inline-flex;
            align-items: center;
            gap: 8px;
        }

        .btn-primary {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            color: white;
        }

        .btn-primary:hover {
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(102, 126, 234, 0.4);
        }

        .btn-secondary {
            background: #6c757d;
            color: white;
        }

        .btn-secondary:hover {
            background: #5a6268;
            transform: translateY(-2px);
            box-shadow: 0 5px 15px rgba(108, 117, 125, 0.4);
        }

        .btn-outline {
            background: transparent;
            color: #667eea;
            border: 2px solid #667eea;
        }

        .btn-outline:hover {
            background: #667eea;
            color: white;
            transform: translateY(-2px);
        }

        .back-to-list {
            text-align: center;
            margin-top: 40px;
        }

        @media (max-width: 768px) {
            .container {
                padding: 15px;
            }
            
            .header h1 {
                font-size: 1.5rem;
            }
            
            .post-title {
                font-size: 1.4rem;
            }
            
            .post-header, .post-content {
                padding: 20px;
            }
            
            .post-info {
                gap: 15px;
                font-size: 0.85rem;
            }
            
            .action-buttons {
                flex-direction: column;
                align-items: center;
            }
            
            .btn {
                width: 100%;
                max-width: 200px;
                justify-content: center;
            }
            
            .post-stats {
                padding: 15px 20px;
                flex-direction: column;
                align-items: flex-start;
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="container">
        <div class="board-detail">
            <div class="post-header">
                <h2 class="post-title">${dto.title }</h2>
                <div class="post-info">
                    <span>작성자: ${dto.writer }</span>
                    <span>작성일: ${dto.regDate }</span>
                </div>
            </div>

            <div class="post-content">
				${dto.content }
            </div>

            <div class="post-stats">
                <div class="stats-item">
                    <svg class="stats-icon" viewBox="0 0 24 24">
                        <path d="M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"/>
                    </svg>
                    좋아요 15
                </div>
                <div class="stats-item">
                    <svg class="stats-icon" viewBox="0 0 24 24">
                        <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm-2 15l-5-5 1.41-1.41L10 14.17l7.59-7.59L19 8l-9 9z"/>
                    </svg>
                    조회수 ${dto.viewCnt }
                </div>
            </div>
        </div>

        <div class="action-buttons">
        	<c:if test="${sessionScope.id eq dto.writer }">
	            <button class="btn btn-primary">수정</button>
	            <button class="btn btn-primary">삭제</button>
            </c:if>
            <a href="<c:url value='/board/list'/>" class="btn btn-primary">목록보기</a>
        </div>
    </div>

</body>
</html>
