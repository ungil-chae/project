/**
 * 복지24 - 폼 검증 유틸리티
 * 이메일, 전화번호, 비밀번호 등 검증 함수
 */

const FormValidation = {
    /**
     * 이메일 형식 검증
     * @param {string} email - 검증할 이메일
     * @returns {boolean} - 유효하면 true
     */
    validateEmail: function(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    },

    /**
     * 전화번호 형식 검증 (한국 휴대폰 번호)
     * @param {string} phone - 검증할 전화번호
     * @returns {boolean} - 유효하면 true
     */
    validatePhone: function(phone) {
        const phoneRegex = /^010[0-9]{8}$/;
        return phoneRegex.test(phone.replace(/[^0-9]/g, ''));
    },

    /**
     * 비밀번호 형식 검증
     * @param {string} password - 검증할 비밀번호
     * @returns {boolean} - 유효하면 true
     */
    validatePassword: function(password) {
        // 영문/숫자/특수문자 중 2가지 이상을 포함하여 8~12자
        const hasNumber = /[0-9]/.test(password);
        const hasLetter = /[a-zA-Z]/.test(password);
        const hasSpecial = /[!@#$%^&*]/.test(password);

        const typeCount = [hasNumber, hasLetter, hasSpecial].filter(Boolean).length;

        return password.length >= 8 && password.length <= 12 && typeCount >= 2;
    },

    /**
     * 생년월일 형식 검증 (YYYYMMDD)
     * @param {string} birthDate - 검증할 생년월일
     * @returns {boolean} - 유효하면 true
     */
    validateBirthDate: function(birthDate) {
        if (birthDate.length !== 8) return false;

        const year = parseInt(birthDate.substring(0, 4));
        const month = parseInt(birthDate.substring(4, 6));
        const day = parseInt(birthDate.substring(6, 8));

        const currentYear = new Date().getFullYear();

        if (year < 1900 || year > currentYear) return false;
        if (month < 1 || month > 12) return false;
        if (day < 1 || day > 31) return false;

        // 월별 일수 체크
        const daysInMonth = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];

        // 윤년 체크
        if ((year % 4 === 0 && year % 100 !== 0) || year % 400 === 0) {
            daysInMonth[1] = 29;
        }

        return day <= daysInMonth[month - 1];
    },

    /**
     * 필수 입력 필드 검증
     * @param {string} value - 검증할 값
     * @returns {boolean} - 값이 있으면 true
     */
    validateRequired: function(value) {
        return value !== null && value !== undefined && value.trim() !== '';
    },

    /**
     * 숫자만 입력되었는지 검증
     * @param {string} value - 검증할 값
     * @returns {boolean} - 숫자만 있으면 true
     */
    validateNumeric: function(value) {
        return /^[0-9]+$/.test(value);
    },

    /**
     * 최소/최대 길이 검증
     * @param {string} value - 검증할 값
     * @param {number} minLength - 최소 길이
     * @param {number} maxLength - 최대 길이 (선택사항)
     * @returns {boolean} - 유효하면 true
     */
    validateLength: function(value, minLength, maxLength) {
        const length = value.length;
        if (maxLength) {
            return length >= minLength && length <= maxLength;
        }
        return length >= minLength;
    },

    /**
     * 우편번호 형식 검증 (5자리)
     * @param {string} postcode - 검증할 우편번호
     * @returns {boolean} - 유효하면 true
     */
    validatePostcode: function(postcode) {
        return /^[0-9]{5}$/.test(postcode);
    },

    /**
     * 폼 필드에 에러 스타일 적용
     * @param {Element|string} field - DOM 요소 또는 선택자
     * @param {string} errorMessage - 에러 메시지
     */
    showError: function(field, errorMessage) {
        const element = typeof field === 'string' ? document.querySelector(field) : field;
        if (!element) return;

        element.classList.add('error');
        element.classList.remove('success');

        // 에러 메시지 표시
        const errorDiv = element.nextElementSibling;
        if (errorDiv && errorDiv.classList.contains('error-message')) {
            errorDiv.textContent = errorMessage;
            errorDiv.style.display = 'block';
        }
    },

    /**
     * 폼 필드에 성공 스타일 적용
     * @param {Element|string} field - DOM 요소 또는 선택자
     */
    showSuccess: function(field) {
        const element = typeof field === 'string' ? document.querySelector(field) : field;
        if (!element) return;

        element.classList.remove('error');
        element.classList.add('success');

        // 에러 메시지 숨기기
        const errorDiv = element.nextElementSibling;
        if (errorDiv && errorDiv.classList.contains('error-message')) {
            errorDiv.style.display = 'none';
        }
    },

    /**
     * 폼 필드 스타일 초기화
     * @param {Element|string} field - DOM 요소 또는 선택자
     */
    clearValidation: function(field) {
        const element = typeof field === 'string' ? document.querySelector(field) : field;
        if (!element) return;

        element.classList.remove('error', 'success');

        const errorDiv = element.nextElementSibling;
        if (errorDiv && errorDiv.classList.contains('error-message')) {
            errorDiv.style.display = 'none';
        }
    },

    /**
     * 전체 폼 검증
     * @param {string} formId - 폼 ID
     * @returns {boolean} - 모든 필드가 유효하면 true
     */
    validateForm: function(formId) {
        const form = document.getElementById(formId);
        if (!form) return false;

        let isValid = true;
        const requiredFields = form.querySelectorAll('[required]');

        requiredFields.forEach(field => {
            if (!this.validateRequired(field.value)) {
                this.showError(field, '필수 입력 항목입니다.');
                isValid = false;
            } else {
                // 타입별 추가 검증
                if (field.type === 'email' && !this.validateEmail(field.value)) {
                    this.showError(field, '올바른 이메일 형식이 아닙니다.');
                    isValid = false;
                } else if (field.type === 'tel' && !this.validatePhone(field.value)) {
                    this.showError(field, '올바른 전화번호 형식이 아닙니다.');
                    isValid = false;
                } else {
                    this.showSuccess(field);
                }
            }
        });

        return isValid;
    }
};

// 전역 스코프에 노출
if (typeof window !== 'undefined') {
    window.FormValidation = FormValidation;
}
