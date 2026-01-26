<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/footer.css">

<footer>
    <div class="footer-container">
        <div class="footer-content">
            <!-- 회사 소개 -->
            <div class="footer-section footer-about">
                <h3>복지24</h3>
                <p>
                    국민 모두가 누려야 할 복지 혜택,<br>
                    복지24가 찾아드립니다.
                </p>
                <p style="font-size: 13px; color: #95a5a6;">
                    보건복지부, 지방자치단체와 함께<br>
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
                    <li><a href="/bdproject/project_volunteer.jsp">봉사 신청</a></li>
                    <li><a href="/bdproject/project_Donation.jsp">기부하기</a></li>
                    <li><a href="/bdproject/project_donation_review.jsp">후원자 리뷰</a></li>
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
                    <strong>이메일</strong>
                    support@welfare24.com
                </p>
                <p>
                    <strong>운영시간</strong>
                    평일 09:00 - 18:00<br>
                    (주말 및 공휴일 휴무)
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
                    <a href="#" style="font-weight: 600; color: #3498db;">개인정보처리방침</a>
                    <a href="#">이메일무단수집거부</a>
                </div>
                <p>
                    사업자등록번호: 123-45-67890 | 대표: 홍길동 | 통신판매업신고: 제2025-서울종로-0000호
                </p>
                <p>
                    주소: 서울특별시 종로구 세종대로 209 (복지로 빌딩)
                </p>
                <p style="margin-top: 10px;">
                    Copyright &copy; 2025 복지24. All rights reserved.
                </p>
            </div>
        </div>
    </div>
</footer>
