// DOM이 완전히 로드된 후 실행
document.addEventListener('DOMContentLoaded', function() {
    // --- Chart.js 통계 차트 초기화 ---
    const chartConfig = [
        { id: 'chart1', percentage: 90, colors: ['#4a90e2', '#357abd'] },
        { id: 'chart2', percentage: 95, colors: ['#27ae60', '#229954'] },
        { id: 'chart3', percentage: 85, colors: ['#f39c12', '#e67e22'] },
        { id: 'chart4', percentage: 95, colors: ['#e74c3c', '#c0392b'] }
    ];

    chartConfig.forEach(config => {
        const ctx = document.getElementById(config.id);
        if (ctx) {
            new Chart(ctx, {
                type: 'doughnut',
                data: {
                    datasets: [{
                        data: [config.percentage, 100 - config.percentage],
                        backgroundColor: [
                            createGradient(ctx, config.colors),
                            'rgba(255, 255, 255, 0.1)'
                        ],
                        borderWidth: 0,
                        cutout: '75%'
                    }]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: true,
                    plugins: {
                        legend: { display: false },
                        tooltip: { enabled: false }
                    },
                    animation: {
                        animateRotate: true,
                        animateScale: true,
                        duration: 2000,
                        easing: 'easeInOutQuart'
                    }
                }
            });
        }
    });

    function createGradient(ctx, colors) {
        const canvas = ctx.canvas || ctx;
        const chartCtx = canvas.getContext('2d');
        const gradient = chartCtx.createLinearGradient(0, 0, canvas.width, canvas.height);
        gradient.addColorStop(0, colors[0]);
        gradient.addColorStop(1, colors[1]);
        return gradient;
    }
    // --- Chart.js 로직 끝 ---

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

    // 언어 선택 드롭다운
    const languageToggle = document.getElementById('languageToggle');
    const languageDropdown = document.getElementById('languageDropdown');

    if (languageToggle && languageDropdown) {
        languageToggle.addEventListener('click', function(e) {
            e.stopPropagation();
            languageDropdown.classList.toggle('active');
        });

        document.addEventListener('click', function() {
            languageDropdown.classList.remove('active');
        });
    }

    // 유저 아이콘 클릭
    const userIcon = document.getElementById('userIcon');
    if (userIcon) {
        userIcon.addEventListener('click', function() {
            window.location.href = '/bdproject/projectLogin.jsp';
        });
    }
});
