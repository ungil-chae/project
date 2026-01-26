/**
 * Navbar JavaScript
 * 메가 메뉴, Google Translate, 유저 아이콘 기능
 */

// Google Translate 초기화
function googleTranslateElementInit() {
    new google.translate.TranslateElement({
        pageLanguage: 'ko',
        includedLanguages: 'ko,en,ja,zh-CN,zh-TW,es,fr,de,ru,vi,th',
        layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
        autoDisplay: false
    }, 'google_translate_element');
}

// 네비바 메뉴 JavaScript
document.addEventListener('DOMContentLoaded', function() {
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

    if (header) {
        header.addEventListener("mouseleave", () => {
            hideMenu();
        });
    }

    // Google Translate 토글
    const languageToggle = document.getElementById("languageToggle");
    const translateElement = document.getElementById("google_translate_element");

    if (languageToggle && translateElement) {
        languageToggle.addEventListener("click", function(e) {
            e.stopPropagation();
            if (translateElement.style.display === "none" || translateElement.style.display === "") {
                translateElement.style.display = "block";
            } else {
                translateElement.style.display = "none";
            }
        });

        document.addEventListener("click", function(e) {
            if (!e.target.closest(".language-selector")) {
                translateElement.style.display = "none";
            }
        });
    }

    // 유저 아이콘 클릭 - 로그인 상태 확인 후 마이페이지 또는 로그인 페이지로 이동
    const userIcon = document.getElementById('userIcon');
    if (userIcon) {
        userIcon.addEventListener('click', function() {
            // 로그인 상태 확인
            fetch('/bdproject/api/auth/check')
                .then(response => response.json())
                .then(data => {
                    if (data.loggedIn) {
                        // 로그인 상태면 마이페이지로 이동
                        window.location.href = '/bdproject/project_mypage.jsp';
                    } else {
                        // 로그인 안 되어 있으면 로그인 페이지로 이동
                        window.location.href = '/bdproject/projectLogin.jsp';
                    }
                })
                .catch(error => {
                    console.error('로그인 상태 확인 오류:', error);
                    // 오류 시 기본적으로 로그인 페이지로 이동
                    window.location.href = '/bdproject/projectLogin.jsp';
                });
        });
    }
});
