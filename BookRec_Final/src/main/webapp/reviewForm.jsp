<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page isELIgnored="false"%>
<%@ page import="model.User"%>
<%@ page import="dto.ReviewDetailDisplayDTO"%> <%-- 리뷰 상세 DTO 임포트 --%>

<%
    User loggedInUser = (User) session.getAttribute("loggedInUser");
    String contextPath = request.getContextPath();

    // -- 폼에 미리 채울 책/리뷰 정보 --
    String isbn = request.getParameter("isbn");
    String title = request.getParameter("title");
    String author = request.getParameter("author");
    String coverImageUrl = request.getParameter("coverImageUrl");
    String naverLink = request.getParameter("naverLink");

    // 수정 모드일 때 (editReview 서블릿에서 포워딩될 때)
    ReviewDetailDisplayDTO reviewDetailToEdit = (ReviewDetailDisplayDTO) request.getAttribute("reviewDetailToEdit");

    // 리뷰 수정 모드인지 확인
    boolean isEditMode = (reviewDetailToEdit != null);

    // 수정 모드이면 reviewDetailToEdit에서 값 가져오기
    if (isEditMode) {
        isbn = reviewDetailToEdit.getIsbn();
        title = reviewDetailToEdit.getBookTitle();
        author = reviewDetailToEdit.getBookAuthor();
        coverImageUrl = reviewDetailToEdit.getBookCoverImageUrl();
        // naverLink는 ReviewListDisplayDTO에 없으므로, 필요시 ReviewDetailDisplayDTO에 추가하거나,
        // ReviewBookDAO를 통해 ReviewEditServlet에서 별도로 가져와야 합니다.
        // 현재는 naverLink를 reviewForm에 표시하지 않으므로, 이 부분은 그대로 둡니다.

        // 기존 리뷰 내용과 별점
        request.setAttribute("existingReviewText", reviewDetailToEdit.getReviewText());
        request.setAttribute("existingRating", reviewDetailToEdit.getRating());
        request.setAttribute("reviewIdToEdit", reviewDetailToEdit.getReviewId()); // 수정할 리뷰 ID
    }

    // 파라미터가 null일 경우 빈 문자열로 처리 (초기 로드 또는 비정상 접근 시)
    if (isbn == null) isbn = "";
    if (title == null) title = "";
    if (author == null) author = "";
    if (coverImageUrl == null || coverImageUrl.isEmpty()) coverImageUrl = contextPath + "/img/icon2.png"; // 기본 이미지
    if (naverLink == null) naverLink = ""; // naverLink는 현재 폼에 표시되지 않음

    // 로그인하지 않은 사용자는 리뷰 작성/수정 불가 (로그인 페이지로 리다이렉트)
    if (loggedInUser == null) {
        response.sendRedirect(contextPath + "/login.jsp?message=" + java.net.URLEncoder.encode("리뷰를 작성/수정하려면 로그인해주세요.", "UTF-8") + "&redirectUrl=" + request.getRequestURI());
        return;
    }

    // 에러 메시지 (SubmitReviewServlet 또는 UpdateReviewServlet에서 전달될 수 있음)
    String errorMessage = request.getParameter("errorMessage");
    if (errorMessage == null) errorMessage = (String) request.getAttribute("errorMessage");
    if (errorMessage == null) errorMessage = "";

    // 이전 제출 시 입력되었던 리뷰 내용 (유효성 검사 실패 시 재입력용)
    String prevReviewText = request.getParameter("reviewText");
    if (prevReviewText == null) prevReviewText = (String) request.getAttribute("prevReviewText");
    if (prevReviewText == null) prevReviewText = "";

    // 이전 제출 시 입력되었던 별점
    String prevRatingStr = request.getParameter("rating");
    int prevRating = 0;
    if (prevRatingStr != null && !prevRatingStr.isEmpty()) {
        try { prevRating = Integer.parseInt(prevRatingStr); } catch(NumberFormatException e) { /* 무시 */ }
    }
    if (request.getAttribute("prevRating") != null) {
        prevRating = (int) request.getAttribute("prevRating");
    }
%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title><%= isEditMode ? "리뷰 수정" : "새 리뷰 작성" %></title>
    <%@ include file="css/main_css.jsp"%>
    <link rel="stylesheet" href="<%=contextPath%>/css/reviewForm.css" />
    <style>
        /* (생략된 스타일) */
        .container {
            min-height: calc(100vh - 250px);
            padding: 20px;
            max-width: 800px;
            margin: 20px auto;
            background-color: #fff;
            border-radius: 8px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
        }
        h2 {
            text-align: center;
            color: #333;
            margin-bottom: 30px;
        }
        .book-info-display {
            display: flex;
            align-items: flex-start;
            margin-bottom: 30px;
            border: 1px solid #eee;
            padding: 15px;
            border-radius: 5px;
            background-color: #f9f9f9;
        }
        .book-info-display img {
            width: 120px;
            height: 180px;
            object-fit: cover;
            border-radius: 4px;
            margin-right: 20px;
        }
        .book-details {
            flex-grow: 1;
        }
        .book-details p {
            margin: 5px 0;
            font-size: 0.95em;
            color: #555;
        }
        .book-details strong {
            color: #333;
            font-weight: bold;
        }
        .form-group {
            margin-bottom: 20px;
        }
        .form-group label {
            display: block;
            margin-bottom: 8px;
            font-weight: bold;
            color: #333;
        }
        .form-group input[type="text"],
        .form-group textarea {
            width: calc(100% - 20px);
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 5px;
            font-size: 1em;
        }
        .form-group textarea {
            min-height: 150px;
            resize: vertical;
        }
        .rating-stars {
            font-size: 2em;
            color: #ccc; /* 빈 별 색상 */
            cursor: pointer;
        }
        .rating-stars .filled {
            color: #f8d601; /* 채워진 별 색상 */
        }
        .rating-stars span:hover,
        .rating-stars span:hover ~ span {
            color: #f8d601;
        }
        .submit-btn {
            display: block;
            width: 100%;
            padding: 12px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 5px;
            font-size: 1.1em;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .submit-btn:hover {
            background-color: #0056b3;
        }
        .error-message {
            color: red;
            font-size: 0.9em;
            margin-top: 5px;
        }
    </style>
</head>
<body>
    <%@ include file="header.jsp"%>
    <nav>
        <a href="<%=contextPath%>/aiRecommend.jsp">(AI) 책 추천</a> <a
            href="<%=contextPath%>/reviewList">리뷰</a> <a
            href="<%=contextPath%>/playlistmain.jsp">플레이리스트</a> <a
            href="<%=contextPath%>/celebList">셀럽추천</a> <a
            href="<%=contextPath%>/mypage.jsp">마이페이지</a>
    </nav>

    <div class="container">
        <h2><%= isEditMode ? "리뷰 수정" : "새 리뷰 작성" %></h2>
        <% if (!errorMessage.isEmpty()) { %>
            <p class="error-message" style="text-align: center;"><%= errorMessage %></p>
        <% } %>

        <form id="reviewForm" action="<%= isEditMode ? contextPath + "/editReview" : contextPath + "/submitReview" %>" method="post">
            <div class="book-info-display">
                <img src="<%=coverImageUrl%>" alt="<%=title%> 표지" onerror="this.onerror=null; this.src='<%=contextPath%>/img/icon2.png';"/>
                <div class="book-details">
                    <p><strong>제목:</strong> <span id="bookTitleDisplay"><%=title%></span></p>
                    <p><strong>저자:</strong> <span id="bookAuthorDisplay"><%=author%></span></p>
                    <% if (!naverLink.isEmpty()) { %>
                        <p><strong>네이버 책:</strong> <a href="<%=naverLink%>" target="_blank">링크 이동</a></p>
                    <% } %>
                </div>
            </div>

            <input type="hidden" name="isbn" value="<%=isbn%>">
            <input type="hidden" name="title" value="<%=title%>">
            <input type="hidden" name="author" value="<%=author%>">
            <input type="hidden" name="coverImageUrl" value="<%=coverImageUrl%>">
            <input type="hidden" name="naverLink" value="<%=naverLink%>">
            
            <%-- 수정 모드일 때 리뷰 ID 전달 --%>
            <% if (isEditMode) { %>
                <input type="hidden" name="reviewId" value="<%= (Integer) request.getAttribute("reviewIdToEdit") %>">
            <% } %>

            <div class="form-group">
                <label for="rating">별점:</label>
                <div id="ratingStars" class="rating-stars">
                    <span data-value="1">★</span><span data-value="2">★</span><span data-value="3">★</span><span data-value="4">★</span><span data-value="5">★</span>
                </div>
                <input type="hidden" name="rating" id="ratingInput" value="<%= isEditMode ? request.getAttribute("existingRating") : prevRating %>">
                <div id="ratingError" class="error-message"></div>
            </div>

            <div class="form-group">
                <label for="reviewText">리뷰 내용:</label>
                <textarea id="reviewText" name="reviewText" placeholder="이 책에 대한 당신의 생각을 자유롭게 공유해주세요." required><%= isEditMode ? (String) request.getAttribute("existingReviewText") : prevReviewText %></textarea>
                <div id="reviewTextError" class="error-message"></div>
            </div>

            <button type="submit" class="submit-btn"><%= isEditMode ? "리뷰 수정" : "리뷰 제출" %></button>
        </form>
    </div>

    <%@ include file="main_footer.jsp"%>

    <script>
        document.addEventListener('DOMContentLoaded', () => {
            const ratingStars = document.getElementById('ratingStars');
            const ratingInput = document.getElementById('ratingInput');
            const reviewForm = document.getElementById('reviewForm');
            const ratingError = document.getElementById('ratingError');
            const reviewTextError = document.getElementById('reviewTextError');
            const reviewTextarea = document.getElementById('reviewText');

            // 초기 별점 설정 (기존 별점이 있거나, 이전에 입력했던 별점)
            let currentRating = parseInt(ratingInput.value) || 0; 

            // 별점 클릭 이벤트
            ratingStars.addEventListener('click', (e) => {
                const target = e.target;
                if (target.tagName === 'SPAN') {
                    const value = parseInt(target.dataset.value);
                    currentRating = value;
                    ratingInput.value = value;
                    updateStars(value);
                    ratingError.textContent = ''; // 에러 메시지 초기화
                }
            });

            // 별점 호버 이벤트
            ratingStars.addEventListener('mouseover', (e) => {
                const target = e.target;
                if (target.tagName === 'SPAN') {
                    const value = parseInt(target.dataset.value);
                    updateStars(value, true); // 호버 시 별 채우기
                }
            });

            // 별점 호버 아웃 이벤트
            ratingStars.addEventListener('mouseout', () => {
                updateStars(currentRating); // 호버 해제 시 원래 별점으로 돌아가기
            });

            // 별점 UI 업데이트 함수
            function updateStars(rating, isHover = false) {
                Array.from(ratingStars.children).forEach(star => {
                    const starValue = parseInt(star.dataset.value);
                    if (starValue <= rating) {
                        star.classList.add('filled');
                    } else {
                        star.classList.remove('filled');
                    }
                });
            }

            // 폼 제출 유효성 검사
            reviewForm.addEventListener('submit', (e) => {
                let isValid = true;

                // 별점 유효성 검사
                if (currentRating === 0) {
                    ratingError.textContent = '별점을 선택해주세요.';
                    isValid = false;
                } else {
                    ratingError.textContent = '';
                }

                // 리뷰 내용 유효성 검사
                if (reviewTextarea.value.trim() === '') {
                    reviewTextError.textContent = '리뷰 내용을 입력해주세요.';
                    isValid = false;
                } else {
                    reviewTextError.textContent = '';
                }

                if (!isValid) {
                    e.preventDefault(); // 유효성 검사 실패 시 폼 제출 방지
                }
            });

            // 초기 로드 시 별점 UI 업데이트
            updateStars(currentRating);
        });
    </script>
</body>
</html>