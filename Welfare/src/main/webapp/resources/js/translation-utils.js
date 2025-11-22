/**
 * 복지24 - Google Translate 유틸리티
 * 다국어 번역 기능
 */

/**
 * Google Translate 초기화 함수
 * Google Translate API에서 자동 호출
 */
function googleTranslateElementInit() {
    new google.translate.TranslateElement({
        pageLanguage: 'ko',
        includedLanguages: 'ko,en,ja,zh-CN,zh-TW,es,fr,de,ru,pt,it,vi,th,id,ar',
        layout: google.translate.TranslateElement.InlineLayout.SIMPLE,
        autoDisplay: false
    }, 'google_translate_element');
}

const TranslationUtils = {
    /**
     * 번역 토글 버튼 초기화
     */
    initToggle: function() {
        document.addEventListener('DOMContentLoaded', function() {
            const languageToggle = document.getElementById('languageToggle');
            const translateElement = document.getElementById('google_translate_element');

            if (languageToggle && translateElement) {
                // 토글 버튼 클릭 이벤트
                languageToggle.addEventListener('click', function(e) {
                    e.stopPropagation();
                    const isVisible = translateElement.style.display === 'block';
                    translateElement.style.display = isVisible ? 'none' : 'block';
                });

                // 외부 클릭 시 닫기
                document.addEventListener('click', function(e) {
                    if (!translateElement.contains(e.target) && e.target !== languageToggle) {
                        translateElement.style.display = 'none';
                    }
                });
            }
        });
    },

    /**
     * 특정 언어로 번역
     * @param {string} langCode - 언어 코드 (예: 'en', 'ja', 'zh-CN')
     */
    translateTo: function(langCode) {
        const selectField = document.querySelector('.goog-te-combo');
        if (selectField) {
            selectField.value = langCode;
            selectField.dispatchEvent(new Event('change'));
        }
    },

    /**
     * 원본 언어(한국어)로 복원
     */
    resetTranslation: function() {
        this.translateTo('ko');
    }
};

// 전역 스코프에 노출
if (typeof window !== 'undefined') {
    window.TranslationUtils = TranslationUtils;
    window.googleTranslateElementInit = googleTranslateElementInit;
}

// 자동 초기화
TranslationUtils.initToggle();
