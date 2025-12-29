<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!--
    복지24 공통 HEAD 섹션
    모든 JSP 페이지에서 공통으로 사용하는 meta 태그, CSS, JavaScript 임포트
-->

<!-- Meta Tags -->
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="description" content="복지24 - 맞춤형 복지 서비스 안내">
<meta name="keywords" content="복지, 복지서비스, 사회복지, 복지혜택, 복지24">
<meta name="author" content="Welfare24 Team">

<!-- Favicon -->
<link rel="icon" type="image/png" href="${pageContext.request.contextPath}/resources/image/복지로고.png">

<!-- Common CSS Files -->
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common-styles.css">
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/google-translate.css">

<!-- Font Awesome (Icons) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<!-- Common JavaScript Files -->
<script src="${pageContext.request.contextPath}/resources/js/auth-utils.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/ui-utils.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/form-validation.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/translation-utils.js"></script>

<!-- Google Translate API -->
<script type="text/javascript" src="//translate.google.com/translate_a/element.js?cb=googleTranslateElementInit"></script>

<!-- Context Path를 JavaScript 전역 변수로 설정 -->
<script>
    var contextPath = '${pageContext.request.contextPath}';
</script>
