// FAQ 토글 기능
function toggleFAQ(element) {
    const answer = element.nextElementSibling;
    const toggle = element.querySelector('.faq-toggle');
    const allAnswers = document.querySelectorAll('.faq-answer');
    const allToggles = document.querySelectorAll('.faq-toggle');

    // 다른 FAQ 닫기
    allAnswers.forEach(item => {
        if (item !== answer) {
            item.classList.remove('active');
        }
    });
    allToggles.forEach(item => {
        if (item !== toggle) {
            item.classList.remove('active');
        }
    });

    // 현재 FAQ 토글
    answer.classList.toggle('active');
    toggle.classList.toggle('active');
}

// 질문 제출
async function submitQuestion(event) {
    event.preventDefault();

    const formData = new FormData(event.target);

    try {
        const response = await fetch('/bdproject/api/questions', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: new URLSearchParams({
                userName: formData.get('userName'),
                userEmail: formData.get('userEmail'),
                category: formData.get('category'),
                title: formData.get('title'),
                content: formData.get('content')
            })
        });

        const result = await response.json();

        if (result.success) {
            const questionId = result.questionId || '확인불가';
            // 성공 모달 표시
            showSuccessModal(questionId);
            event.target.reset();
            // 질문 섹션 닫기
            toggleQuestionSection();
        } else {
            alert('질문 등록에 실패했습니다: ' + (result.message || '알 수 없는 오류'));
        }
    } catch (error) {
        console.error('질문 제출 오류:', error);
        alert('질문 제출 중 오류가 발생했습니다.');
    }
}

// 사용자 질문 불러오기
async function loadUserQuestions() {
    const isAdmin = window.isAdmin; // JSP에서 전달받은 변수

    try {
        const response = await fetch('/bdproject/api/questions');
        const result = await response.json();

        if (result.success && result.data && result.data.length > 0) {
            const container = document.getElementById('userQuestionsContainer');
            let html = '<div class="user-questions-section"><h2 class="section-title">사용자 질문</h2>';

            console.log('질문 데이터:', result.data);

            result.data.forEach(q => {
                console.log('질문 ID:', q.questionId, '타입:', typeof q.questionId);

                const statusBadge = q.status === 'answered' ?
                    '<span class="question-badge badge-answered">답변완료</span>' :
                    '<span class="question-badge badge-pending">대기중</span>';

                const date = new Date(q.createdAt).toLocaleDateString('ko-KR');
                const qId = String(q.questionId);

                html += '<div class="user-question-item" data-question-id="' + qId + '">' +
                        '<div class="user-question-header">' +
                        '<div class="user-question-info">' +
                        statusBadge +
                        '<div class="user-question-title">' + q.title + '</div>' +
                        '<div class="user-question-meta">' +
                        q.category + ' | ' + q.userName + ' | ' + date +
                        '</div>' +
                        '</div>' +
                        '<i class="fas fa-chevron-down faq-toggle"></i>' +
                        '</div>' +
                        '<div class="user-question-body">' +
                        '<div class="question-content">' +
                        '<strong>질문:</strong><br>' + q.content +
                        '</div>';

                if (q.answer) {
                    const answeredDate = new Date(q.answeredAt).toLocaleString('ko-KR');
                    html += '<div class="answer-content">' +
                        '<strong>답변:</strong><br>' + q.answer +
                        '<div style="margin-top:10px; font-size:12px; color:#6c757d;">' +
                        '답변일: ' + answeredDate +
                        '</div>' +
                        '</div>';
                } else if (isAdmin) {
                    console.log('답변 폼 생성 - questionId:', qId);
                    const textareaIdFull = 'answer-' + qId;
                    console.log('생성할 textarea ID:', textareaIdFull);

                    html += '<div class="answer-form">' +
                        '<div class="answer-form-title">' +
                        '<i class="fas fa-edit"></i> 관리자 답변 작성 (질문 ID: ' + qId + ')' +
                        '</div>' +
                        '<textarea class="answer-textarea" id="answer-' + qId + '" placeholder="질문에 대한 답변을 작성해주세요. 사용자의 마이페이지에 알림이 전송됩니다."></textarea>' +
                        '<button class="answer-btn" data-question-id="' + qId + '">' +
                        '<i class="fas fa-paper-plane"></i> 답변 등록' +
                        '</button>' +
                        '</div>';

                    console.log('생성된 HTML 일부:', html.substring(html.length - 200));
                }

                html += '</div>' +
                        '</div>';
            });

            html += '</div>';
            container.innerHTML = html;

            // 이벤트 위임 방식으로 클릭 이벤트 처리
            setTimeout(() => {
                const questionHeaders = document.querySelectorAll('.user-question-header');
                console.log('등록된 헤더 개수:', questionHeaders.length);

                questionHeaders.forEach((header, index) => {
                    header.style.cursor = 'pointer';
                    const questionItem = header.closest('.user-question-item');
                    const questionId = questionItem.getAttribute('data-question-id');
                    console.log('헤더', index, '- questionId:', questionId);

                    header.addEventListener('click', function() {
                        const item = this.closest('.user-question-item');
                        const qId = item.getAttribute('data-question-id');
                        console.log('클릭된 질문 ID:', qId);
                        toggleUserQuestion(qId);
                    });
                });

                // 답변 등록 버튼 이벤트
                const answerBtns = document.querySelectorAll('.answer-btn');
                console.log('등록된 답변 버튼 개수:', answerBtns.length);

                answerBtns.forEach((btn, index) => {
                    const questionId = btn.getAttribute('data-question-id');
                    console.log('답변 버튼', index, '- questionId:', questionId);

                    btn.addEventListener('click', function() {
                        const qId = this.getAttribute('data-question-id');
                        console.log('답변 등록 버튼 클릭 - questionId:', qId);
                        submitAnswer(qId);
                    });
                });
            }, 100);
        } else {
            // 질문이 없을 때
            const container = document.getElementById('userQuestionsContainer');
            container.innerHTML = '<div class="user-questions-section">' +
                '<h2 class="section-title">사용자 질문</h2>' +
                '<div class="empty-state" style="text-align: center; padding: 60px 20px; background: white; border-radius: 15px;">' +
                '<i class="fas fa-comments" style="font-size: 48px; color: #dee2e6; margin-bottom: 20px;"></i>' +
                '<p style="font-size: 16px; color: #6c757d;">아직 등록된 질문이 없습니다.</p>' +
                '</div>' +
                '</div>';
        }
    } catch (error) {
        console.error('질문 목록 로딩 오류:', error);
        const container = document.getElementById('userQuestionsContainer');
        if (container) {
            container.innerHTML = '<div class="user-questions-section">' +
                '<h2 class="section-title">사용자 질문</h2>' +
                '<div class="empty-state" style="text-align: center; padding: 60px 20px; background: white; border-radius: 15px;">' +
                '<i class="fas fa-exclamation-triangle" style="font-size: 48px; color: #ffc107; margin-bottom: 20px;"></i>' +
                '<p style="font-size: 16px; color: #6c757d;">질문 목록을 불러오는 중 오류가 발생했습니다.</p>' +
                '<p style="font-size: 14px; color: #999; margin-top: 10px;">페이지를 새로고침하거나 잠시 후 다시 시도해주세요.</p>' +
                '</div>' +
                '</div>';
        }
    }
}

// 사용자 질문 토글
function toggleUserQuestion(questionId) {
    console.log('질문 토글 - questionId:', questionId, '타입:', typeof questionId);

    // 문자열로 변환
    const qIdStr = String(questionId);
    console.log('변환된 questionId:', qIdStr);

    // 모든 질문 아이템 확인
    const allItems = document.querySelectorAll('.user-question-item');
    console.log('전체 질문 아이템 개수:', allItems.length);

    // Array.from으로 변환하여 find 사용
    let targetItem = null;
    allItems.forEach((item, idx) => {
        const dataId = item.getAttribute('data-question-id');
        console.log(`아이템 ${idx} - data-question-id:`, dataId, '비교:', dataId === qIdStr);
        if (dataId === qIdStr) {
            targetItem = item;
            console.log('✅ 매칭된 아이템 찾음!');
        }
    });

    console.log('최종 선택된 아이템:', targetItem);

    if (targetItem) {
        const isActive = targetItem.classList.contains('active');

        // 다른 모든 질문 닫기
        allItems.forEach(q => {
            q.classList.remove('active');
            const t = q.querySelector('.faq-toggle');
            if (t) t.classList.remove('active');
        });

        // 현재 질문 토글
        if (!isActive) {
            targetItem.classList.add('active');
            const toggle = targetItem.querySelector('.faq-toggle');
            if (toggle) {
                toggle.classList.add('active');
            }
            console.log('✅ 질문 펼침 완료');
        } else {
            console.log('질문 접음');
        }
    } else {
        console.error('❌ 질문 아이템을 찾을 수 없습니다. questionId:', qIdStr);
        console.error('현재 페이지의 모든 data-question-id:',
            Array.from(allItems).map(i => i.getAttribute('data-question-id')));
    }
}

// 관리자 답변 등록
async function submitAnswer(questionId) {
    console.log('========== submitAnswer 시작 ==========');
    console.log('전달받은 파라미터:', questionId);
    console.log('파라미터 타입:', typeof questionId);
    console.log('파라미터 길이:', String(questionId).length);
    console.log('파라미터 값:', JSON.stringify(questionId));

    // 문자열로 확실히 변환
    const qIdStr = String(questionId).trim();
    console.log('변환된 questionId:', qIdStr, '길이:', qIdStr.length);

    const textareaId = 'answer-' + qIdStr;
    console.log('생성된 textarea ID:', textareaId);

    // 모든 textarea 확인
    const allTextareas = document.querySelectorAll('textarea');
    console.log('페이지의 모든 textarea 개수:', allTextareas.length);
    allTextareas.forEach((ta, idx) => {
        console.log(`  textarea ${idx} - id:`, ta.id);
    });

    const textarea = document.getElementById(textareaId);
    console.log('document.getElementById 결과:', textarea);

    if (!textarea) {
        console.error('❌ textarea를 찾을 수 없습니다.');
        console.error('찾으려고 한 ID:', textareaId);
        console.error('현재 페이지의 모든 ID:',
            Array.from(allTextareas).map(t => t.id));
        alert('답변 입력란을 찾을 수 없습니다. 페이지를 새로고침해주세요.');
        return;
    }

    const answer = textarea.value.trim();
    console.log('답변 내용:', answer);

    if (!answer) {
        alert('답변을 입력해주세요.');
        return;
    }

    const apiUrl = '/bdproject/api/questions/' + qIdStr + '/answer';
    console.log('API 호출 URL:', apiUrl);

    try {
        const response = await fetch(apiUrl, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: new URLSearchParams({
                answer: answer
            })
        });

        console.log('HTTP 상태:', response.status);
        console.log('Content-Type:', response.headers.get('content-type'));

        // 응답이 JSON이 아닌 경우 처리
        const contentType = response.headers.get('content-type');
        if (!contentType || !contentType.includes('application/json')) {
            const text = await response.text();
            console.error('서버가 JSON이 아닌 응답 반환:', text.substring(0, 500));

            if (response.status === 500) {
                alert('서버 오류가 발생했습니다.\n\n서버 콘솔 로그를 확인해주세요:\n1. 관리자 로그인 확인\n2. 데이터베이스 연결 확인\n3. NotificationService 빈 등록 확인');
            } else {
                alert('서버 응답 오류 (상태 코드: ' + response.status + ')');
            }
            return;
        }

        const result = await response.json();
        console.log('서버 응답:', result);

        if (result.success) {
            alert('답변이 등록되었습니다.\n질문 작성자의 마이페이지에 알림이 전송되었습니다.');
            location.reload();
        } else {
            alert('답변 등록에 실패했습니다:\n' + (result.message || '알 수 없는 오류'));
        }
    } catch (error) {
        console.error('답변 등록 오류:', error);
        alert('답변 등록 중 오류가 발생했습니다:\n' + error.message);
    }
}

// 질문하기 버튼 토글
function toggleQuestionSection() {
    const questionSection = document.querySelector('.question-section');
    const askQuestionBtn = document.getElementById('askQuestionBtn');
    const isActive = questionSection.classList.toggle('active');

    // 버튼 아이콘 변경
    if (isActive) {
        askQuestionBtn.innerHTML = '<i class="fas fa-minus"></i> 질문 접기';
    } else {
        askQuestionBtn.innerHTML = '<i class="fas fa-plus"></i> 질문하기';
    }
}


// ========== 고급 검색 엔진 (Server-Side API) ==========

// 검색 캐시 (동일 검색어 재검색 방지)
const searchCache = new Map();
let searchDebounceTimer = null;
let currentSearchQuery = '';

// 검색 API 호출 (Debouncing 적용)
async function searchFAQ() {
    const searchInput = document.getElementById('searchInput');
    const searchText = searchInput.value.trim();

    // 자동완성 숨기기
    hideAutocomplete();

    // 빈 검색어인 경우 모든 FAQ 표시
    if (searchText === '') {
        showAllFaqs();
        return;
    }

    // 이미 검색 중이면 취소
    if (searchDebounceTimer) {
        clearTimeout(searchDebounceTimer);
    }

    // 300ms debounce
    searchDebounceTimer = setTimeout(async () => {
        await performSearch(searchText);
    }, 300);
}

// 실제 검색 수행
async function performSearch(query) {
    // 먼저 사용자 질문에서 이름/이메일로 검색
    await searchUserQuestions(query);

    // FAQ 검색도 수행
    const activeCategoryBtn = document.querySelector('.category-btn.active');
    const category = activeCategoryBtn ? activeCategoryBtn.dataset.category : 'all';

    try {
        // API 호출
        const url = '/bdproject/api/faqs/search?q=' + encodeURIComponent(query) +
                   (category !== 'all' ? '&category=' + encodeURIComponent(category) : '');

        console.log('검색 API 호출:', url);

        const response = await fetch(url);
        const result = await response.json();

        if (result.success) {
            console.log('검색 결과:', result.count + '건', '평균 점수:', result.avgRelevanceScore);

            // 캐시 저장 (최대 50개)
            if (searchCache.size >= 50) {
                const firstKey = searchCache.keys().next().value;
                searchCache.delete(firstKey);
            }
            searchCache.set(query, result);

            displaySearchResults(result, query);
        } else {
            console.error('검색 실패:', result.message);
            showNoResults(query);
        }
    } catch (error) {
        console.error('검색 API 오류:', error);
        showNoResults(query);
    }
}

// 검색 결과 표시
function displaySearchResults(result, query) {
    const faqList = document.querySelector('.faq-list');

    if (!result.data || result.data.length === 0) {
        showNoResults(query);
        return;
    }

    let html = '';
    result.data.forEach(item => {
        // 하이라이팅이 적용된 텍스트 사용 (서버에서 제공)
        const questionHtml = item.highlightedQuestion || item.question;
        const answerHtml = item.highlightedAnswer || item.answer;

        html += '<div class="faq-item" data-category="' + item.category + '">' +
                '<div class="faq-question" onclick="toggleFAQ(this)">' +
                '<div class="faq-icon">Q</div>' +
                '<div class="faq-question-text">' + questionHtml + '</div>' +
                '<i class="fas fa-chevron-down faq-toggle"></i>' +
                '</div>' +
                '<div class="faq-answer">' +
                '<div class="faq-answer-text">' + answerHtml + '</div>' +
                '</div>' +
                '</div>';
    });

    faqList.innerHTML = html;

    // <mark> 태그 스타일 추가
    addMarkStyles();
}

// 검색 결과 없음 표시
function showNoResults(query) {
    const faqList = document.querySelector('.faq-list');
    faqList.innerHTML = '<div style="padding:60px 20px; text-align:center;">' +
        '<i class="fas fa-search" style="font-size:48px; color:#dee2e6; margin-bottom:20px;"></i>' +
        '<p style="font-size:18px; color:#6c757d; margin-bottom:10px;">"' + query + '"에 대한 검색 결과가 없습니다.</p>' +
        '<p style="font-size:14px; color:#999;">다른 검색어로 시도해보세요.</p>' +
        '</div>';
}

// 모든 FAQ 표시
function showAllFaqs() {
    // 모든 FAQ를 다시 표시 (필터 제거)
    const faqItems = document.querySelectorAll('.faq-item');
    faqItems.forEach(item => {
        item.style.display = 'block';
    });

    // 카테고리 버튼 활성화 상태 초기화
    document.querySelectorAll('.category-btn').forEach(btn => {
        if (btn.dataset.category === 'all') {
            btn.classList.add('active');
        } else {
            btn.classList.remove('active');
        }
    });
}

// 사용자 질문 검색 (이름 또는 이메일)
async function searchUserQuestions(query) {
    const questionsList = document.getElementById('userQuestionsList');
    const pagination = document.getElementById('pagination');

    try {
        const response = await fetch('/bdproject/api/questions');
        const result = await response.json();

        if (result.success && result.data && result.data.length > 0) {
            // 이름 또는 이메일로 필터링
            const filteredQuestions = result.data.filter(q => {
                const nameMatch = q.userName && q.userName.toLowerCase().includes(query.toLowerCase());
                const emailMatch = q.userEmail && q.userEmail.toLowerCase().includes(query.toLowerCase());
                const titleMatch = q.title && q.title.toLowerCase().includes(query.toLowerCase());
                return nameMatch || emailMatch || titleMatch;
            });

            if (filteredQuestions.length > 0) {
                // 최신순 정렬
                filteredQuestions.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

                // 검색 결과 HTML 생성
                let html = '';
                filteredQuestions.forEach(q => {
                    const date = new Date(q.createdAt).toLocaleDateString('ko-KR');
                    const statusBadge = q.status === 'answered' ?
                        '<span style="display:inline-block; padding:3px 8px; background:#d4edda; color:#155724; border-radius:8px; font-size:11px; font-weight:600; margin-left:8px;">답변완료</span>' :
                        '<span style="display:inline-block; padding:3px 8px; background:#fff3cd; color:#856404; border-radius:8px; font-size:11px; font-weight:600; margin-left:8px;">답변대기</span>';

                    // 검색어 하이라이트
                    let displayName = q.userName;
                    let displayEmail = q.userEmail;
                    let displayTitle = q.title;

                    if (q.userName && q.userName.toLowerCase().includes(query.toLowerCase())) {
                        const regex = new RegExp('(' + query + ')', 'gi');
                        displayName = q.userName.replace(regex, '<mark>$1</mark>');
                    }
                    if (q.userEmail && q.userEmail.toLowerCase().includes(query.toLowerCase())) {
                        const regex = new RegExp('(' + query + ')', 'gi');
                        displayEmail = q.userEmail.replace(regex, '<mark>$1</mark>');
                    }
                    if (q.title && q.title.toLowerCase().includes(query.toLowerCase())) {
                        const regex = new RegExp('(' + query + ')', 'gi');
                        displayTitle = q.title.replace(regex, '<mark>$1</mark>');
                    }

                    html += '<div class="faq-item">' +
                            '<div class="faq-question" onclick="toggleFAQ(this)">' +
                            '<div class="faq-icon user-question">Q</div>' +
                            '<div class="faq-question-text">' + displayTitle + statusBadge +
                            '<div style="font-size:12px; color:#6c757d; font-weight:400; margin-top:5px;">' +
                            q.category + ' | ' + displayName + ' (' + displayEmail + ') | ' + date +
                            '</div></div>' +
                            '<i class="fas fa-chevron-down faq-toggle"></i>' +
                            '</div>' +
                            '<div class="faq-answer">' +
                            '<div class="faq-answer-text">' +
                            '<strong>질문:</strong><br>' + q.content + '<br><br>';

                    if (q.answer) {
                        const answerDate = new Date(q.answeredAt).toLocaleDateString('ko-KR');
                        html += '<div style="background:#e3f2fd; padding:15px; border-left:4px solid #4A90E2; border-radius:8px; margin-top:15px;">' +
                                '<strong>답변:</strong><br>' + q.answer +
                                '<div style="margin-top:10px; font-size:12px; color:#6c757d;">답변일: ' + answerDate + '</div>' +
                                '</div>';
                    } else {
                        html += '<div style="background:#fff3cd; padding:15px; border-left:4px solid:#ffc107; border-radius:8px; margin-top:15px;">' +
                                '<strong>답변 대기 중입니다.</strong>' +
                                '</div>';
                    }

                    html += '</div></div></div>';
                });

                questionsList.innerHTML = html;
                pagination.innerHTML = '<div style="text-align:center; padding:20px; color:#6c757d; font-size:14px;">' +
                    '<i class="fas fa-search" style="margin-right:8px;"></i>' +
                    '<strong>' + filteredQuestions.length + '개의 질문</strong>을 찾았습니다.</div>';

                console.log('✅ 검색 결과:', filteredQuestions.length + '개');

                // mark 태그 스타일 적용
                addMarkStyles();
            } else {
                // 검색 결과 없음
                questionsList.innerHTML = '<div style="text-align: center; padding: 40px; color: #6c757d;">' +
                    '<i class="fas fa-search" style="font-size: 48px; margin-bottom: 15px; opacity: 0.3;"></i>' +
                    '<p><strong>"' + query + '"</strong>에 대한 질문을 찾을 수 없습니다.</p>' +
                    '<p style="font-size:14px; margin-top:10px;">이름 또는 이메일을 정확히 입력해주세요.</p>' +
                    '</div>';
                pagination.innerHTML = '';
            }
        }
    } catch (error) {
        console.error('사용자 질문 검색 오류:', error);
    }
}

// <mark> 하이라이팅 스타일
function addMarkStyles() {
    if (!document.getElementById('mark-styles')) {
        const style = document.createElement('style');
        style.id = 'mark-styles';
        style.innerHTML = 'mark { background-color: #fff3cd; color: #856404; font-weight: 600; padding: 2px 4px; border-radius: 3px; }';
        document.head.appendChild(style);
    }
}

// 자동완성 표시 (서버 API 기반)
async function showAutocomplete() {
    const searchInput = document.getElementById('searchInput');
    const searchText = searchInput.value.trim();
    const autocompleteDiv = document.getElementById('searchAutocomplete');

    if (searchText === '' || searchText.length < 2) {
        hideAutocomplete();
        return;
    }

    // 캐시 확인
    if (searchCache.has(searchText)) {
        const cachedResult = searchCache.get(searchText);
        displayAutocomplete(cachedResult.data, searchText);
        return;
    }

    try {
        const url = '/bdproject/api/faqs/search?q=' + encodeURIComponent(searchText);
        const response = await fetch(url);
        const result = await response.json();

        if (result.success && result.data.length > 0) {
            displayAutocomplete(result.data, searchText);
        } else {
            autocompleteDiv.innerHTML = '<div class="autocomplete-empty">검색 결과가 없습니다</div>';
            autocompleteDiv.classList.add('active');
            searchInput.classList.add('autocomplete-active');
        }
    } catch (error) {
        console.error('자동완성 API 오류:', error);
        hideAutocomplete();
    }
}

// 자동완성 결과 표시
function displayAutocomplete(data, searchText) {
    const autocompleteDiv = document.getElementById('searchAutocomplete');
    const searchInput = document.getElementById('searchInput');

    let html = '';
    data.slice(0, 5).forEach(item => {
        const questionText = item.question.replace(/'/g, "\\'");
        const highlightedQuestion = highlightMatch(item.question, searchText);
        html += '<div class="autocomplete-item" onclick="selectAutocomplete(\'' + questionText + '\')">' +
                highlightedQuestion +
                '</div>';
    });

    autocompleteDiv.innerHTML = html;
    autocompleteDiv.classList.add('active');
    searchInput.classList.add('autocomplete-active');
}

// 자동완성 숨기기
function hideAutocomplete() {
    const autocompleteDiv = document.getElementById('searchAutocomplete');
    const searchInput = document.getElementById('searchInput');
    autocompleteDiv.classList.remove('active');
    searchInput.classList.remove('active');
}

// 검색어 하이라이트
function highlightMatch(text, search) {
    const regex = new RegExp('(' + search + ')', 'gi');
    return text.replace(regex, '<strong>$1</strong>');
}

// 자동완성 항목 선택
function selectAutocomplete(text) {
    const searchInput = document.getElementById('searchInput');
    searchInput.value = text;
    searchFAQ();
}

// 답변하기 버튼 토글 (관리자 전용)
function toggleAnswerSection() {
    const container = document.getElementById('userQuestionsContainer');
    const answerBtn = document.getElementById('answerQuestionBtn');

    if (container.style.display === 'none') {
        container.style.display = 'block';
        answerBtn.innerHTML = '<i class="fas fa-minus"></i> 답변 닫기';
        answerBtn.style.background = '#dc3545';
        // 질문 목록 로드
        loadUserQuestions();
    } else {
        container.style.display = 'none';
        answerBtn.innerHTML = '<i class="fas fa-comment-dots"></i> 답변하기';
        answerBtn.style.background = '#28a745';
    }
}

// DOM이 완전히 로드된 후 실행
document.addEventListener('DOMContentLoaded', function() {
    // 질문하기 버튼 이벤트
    const askQuestionBtn = document.getElementById('askQuestionBtn');
    if (askQuestionBtn) {
        askQuestionBtn.addEventListener('click', toggleQuestionSection);
    }

    // 답변하기 버튼 이벤트 (관리자 전용)
    const answerQuestionBtn = document.getElementById('answerQuestionBtn');
    if (answerQuestionBtn) {
        answerQuestionBtn.addEventListener('click', toggleAnswerSection);
    }

    // 검색 기능
    const searchInput = document.getElementById('searchInput');
    const searchIcon = document.getElementById('searchIcon');

    if (searchInput) {
        // 입력 시 자동완성 표시
        searchInput.addEventListener('input', showAutocomplete);

        // Enter 키로 검색
        searchInput.addEventListener('keypress', function(e) {
            if (e.key === 'Enter') {
                searchFAQ();
            }
        });
    }

    if (searchIcon) {
        // 검색 아이콘 클릭으로 검색
        searchIcon.addEventListener('click', searchFAQ);
    }

    // 외부 클릭 시 자동완성 숨기기
    document.addEventListener('click', function(e) {
        const searchBox = document.querySelector('.search-box');
        if (searchBox && !searchBox.contains(e.target)) {
            hideAutocomplete();
        }
    });

    // 카테고리 필터링 (서버 API 기반)
    const categoryBtns = document.querySelectorAll('.category-btn');
    if (categoryBtns) {
        categoryBtns.forEach(btn => {
            btn.addEventListener('click', async function() {
                const category = this.dataset.category;
                const searchInput = document.getElementById('searchInput');
                const searchText = searchInput.value.trim();

                // 버튼 활성화 상태 변경
                document.querySelectorAll('.category-btn').forEach(b => b.classList.remove('active'));
                this.classList.add('active');

                // 검색어가 있으면 카테고리 필터링 적용하여 재검색
                if (searchText !== '') {
                    await performSearch(searchText);
                } else {
                    // 검색어 없이 카테고리만 필터링 (클라이언트 사이드)
                    const faqItems = document.querySelectorAll('.faq-item');
                    faqItems.forEach(item => {
                        const itemCategory = item.dataset.category;
                        if (category === 'all' || itemCategory === category) {
                            item.style.display = 'block';
                        } else {
                            item.style.display = 'none';
                        }
                    });
                }
            });
        });
    }

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

    if (header) {
        header.addEventListener("mouseleave", () => {
            hideMenu();
        });
    }
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

    // 페이지 로드 시 서버에서 고정 FAQ 가져오기
    loadFixedFaqs();

    // 사용자 질문 목록 로드
    loadPublicUserQuestions(1);

    // FAQ 접기/펼치기 기능
    const faqToggleHeader = document.getElementById('faqToggleHeader');
    const faqToggleIcon = document.getElementById('faqToggleIcon');
    const fixedFaqList = document.getElementById('fixedFaqList');
    let faqExpanded = true;

    if (faqToggleHeader) {
        faqToggleHeader.addEventListener('click', function() {
            faqExpanded = !faqExpanded;

            if (faqExpanded) {
                // 펼치기
                fixedFaqList.style.display = 'block';
                fixedFaqList.style.opacity = '1';
                fixedFaqList.style.overflow = 'visible';
                faqToggleIcon.style.transform = 'rotate(0deg)';
            } else {
                // 접기
                fixedFaqList.style.display = 'none';
                fixedFaqList.style.opacity = '0';
                fixedFaqList.style.overflow = 'hidden';
                faqToggleIcon.style.transform = 'rotate(-180deg)';
            }
        });
    }
});

// 서버에서 FAQ 목록 가져오기 (상단 고정용)
async function loadFixedFaqs() {
    try {
        const response = await fetch('/bdproject/api/faqs/list?isActive=true');
        const result = await response.json();

        console.log('📦 서버 응답:', result);

        if (result.success && result.data && result.data.length > 0) {
            const faqList = document.getElementById('fixedFaqList');

            if (!faqList) {
                console.error('❌ fixedFaqList 요소를 찾을 수 없습니다!');
                return;
            }

            const faqs = result.data;

            console.log('📝 첫 번째 FAQ 데이터:', faqs[0]);
            console.log('📝 FAQ 필드:', Object.keys(faqs[0]));

            // 카테고리 코드 매핑
            const categoryCodeMap = {
                '복지혜택': 'welfare',
                '서비스이용': 'service',
                '계정관리': 'account',
                '기부/후원': 'donation',
                '봉사활동': 'volunteer',
                '기타': 'etc'
            };

            let html = '';
            faqs.forEach((faq, index) => {
                const categoryCode = categoryCodeMap[faq.category] || 'etc';
                const question = faq.question || '';
                const answer = faq.answer || '';

                console.log('FAQ ' + (index + 1) + ' - categoryCode:', categoryCode, 'question:', question.substring(0, 30));

                if (!question) {
                    console.warn('FAQ ' + (index + 1) + ': question이 비어있습니다!', faq);
                }

                html += '<div class="faq-item" data-category="' + categoryCode + '" style="margin-bottom: 15px;">' +
                        '<div class="faq-question" onclick="toggleFAQ(this)" style="cursor: pointer;">' +
                        '<div class="faq-icon">Q</div>' +
                        '<div class="faq-question-text">' + question + '</div>' +
                        '<i class="fas fa-chevron-down faq-toggle"></i>' +
                        '</div>' +
                        '<div class="faq-answer">' +
                        '<div class="faq-answer-text">' + answer + '</div>' +
                        '</div>' +
                        '</div>';
            });

            console.log('✅ HTML 생성 완료, 길이:', html.length);
            console.log('📄 HTML 미리보기:', html.substring(0, 500));

            // HTML 삽입
            faqList.innerHTML = html;

            // 삽입 후 확인
            console.log('✅ innerHTML 설정 완료');
            console.log('✅ 자식 요소 개수:', faqList.children.length);
            console.log('✅ 고정 FAQ 로드 완료:', faqs.length + '개');
        } else {
            console.warn('⚠️ FAQ 데이터가 없습니다.', result);
        }
    } catch (error) {
        console.error('❌ FAQ 로드 오류:', error);
    }
}

// 사용자 질문 목록 로드 (페이지네이션)
let currentPage = 1;
const questionsPerPage = 10;
let totalQuestions = 0;

async function loadPublicUserQuestions(page) {
    currentPage = page;
    const questionsList = document.getElementById('userQuestionsList');
    const pagination = document.getElementById('pagination');

    try {
        const response = await fetch('/bdproject/api/questions');
        const result = await response.json();

        if (result.success && result.data && result.data.length > 0) {
            const questions = result.data;
            totalQuestions = questions.length;

            // 최신순 정렬
            questions.sort((a, b) => new Date(b.createdAt) - new Date(a.createdAt));

            // 페이지네이션 계산
            const startIndex = (page - 1) * questionsPerPage;
            const endIndex = startIndex + questionsPerPage;
            const pageQuestions = questions.slice(startIndex, endIndex);

            // 질문 목록 HTML 생성
            let html = '';
            pageQuestions.forEach(q => {
                const date = new Date(q.createdAt).toLocaleDateString('ko-KR');
                const statusBadge = q.status === 'answered' ?
                    '<span style="display:inline-block; padding:3px 8px; background:#d4edda; color:#155724; border-radius:8px; font-size:11px; font-weight:600; margin-left:8px;">답변완료</span>' :
                    '<span style="display:inline-block; padding:3px 8px; background:#fff3cd; color:#856404; border-radius:8px; font-size:11px; font-weight:600; margin-left:8px;">답변대기</span>';

                html += '<div class="faq-item">' +
                        '<div class="faq-question" onclick="toggleFAQ(this)">' +
                        '<div class="faq-icon user-question">Q</div>' +
                        '<div class="faq-question-text">' + q.title + statusBadge +
                        '<div style="font-size:12px; color:#6c757d; font-weight:400; margin-top:5px;">' +
                        q.category + ' | ' + q.userName + ' | ' + date +
                        '</div></div>' +
                        '<i class="fas fa-chevron-down faq-toggle"></i>' +
                        '</div>' +
                        '<div class="faq-answer">' +
                        '<div class="faq-answer-text">' +
                        '<strong>질문:</strong><br>' + q.content + '<br><br>';

                if (q.answer) {
                    const answerDate = new Date(q.answeredAt).toLocaleDateString('ko-KR');
                    html += '<div style="background:#e3f2fd; padding:15px; border-left:4px solid #4A90E2; border-radius:8px; margin-top:15px;">' +
                            '<strong>답변:</strong><br>' + q.answer +
                            '<div style="margin-top:10px; font-size:12px; color:#6c757d;">답변일: ' + answerDate + '</div>' +
                            '</div>';
                } else {
                    html += '<div style="background:#fff3cd; padding:15px; border-left:4px solid:#ffc107; border-radius:8px; margin-top:15px;">' +
                            '<strong>답변 대기 중입니다.</strong>' +
                            '</div>';
                }

                html += '</div></div></div>';
            });

            questionsList.innerHTML = html;

            // 페이지네이션 버튼 생성
            renderPagination(totalQuestions, page);

            console.log('✅ 사용자 질문 로드 완료:', pageQuestions.length + '개 (총 ' + totalQuestions + '개)');
        } else {
            questionsList.innerHTML = '<div style="text-align: center; padding: 40px; color: #6c757d;">' +
                '<i class="fas fa-comments" style="font-size: 48px; margin-bottom: 15px; opacity: 0.3;"></i>' +
                '<p>아직 등록된 질문이 없습니다.</p>' +
                '</div>';
            pagination.innerHTML = '';
        }
    } catch (error) {
        console.error('사용자 질문 로딩 실패:', error);
        questionsList.innerHTML = '<div style="text-align: center; padding: 40px; color: #dc3545;">' +
            '<i class="fas fa-exclamation-triangle" style="font-size: 48px; margin-bottom: 15px;"></i>' +
            '<p>질문 목록을 불러올 수 없습니다.</p>' +
            '</div>';
    }
}

// 페이지네이션 렌더링
function renderPagination(total, current) {
    const pagination = document.getElementById('pagination');
    const totalPages = Math.ceil(total / questionsPerPage);

    if (totalPages <= 1) {
        pagination.innerHTML = '';
        return;
    }

    let html = '';

    // 이전 버튼
    html += '<button class="pagination-btn" onclick="loadPublicUserQuestions(' + (current - 1) + ')" ' +
            (current === 1 ? 'disabled' : '') + '>' +
            '<i class="fas fa-chevron-left"></i> 이전' +
            '</button>';

    // 페이지 번호
    const startPage = Math.max(1, current - 2);
    const endPage = Math.min(totalPages, current + 2);

    if (startPage > 1) {
        html += '<button class="pagination-btn" onclick="loadPublicUserQuestions(1)">1</button>';
        if (startPage > 2) {
            html += '<span class="pagination-info">...</span>';
        }
    }

    for (let i = startPage; i <= endPage; i++) {
        html += '<button class="pagination-btn ' + (i === current ? 'active' : '') + '" ' +
                'onclick="loadPublicUserQuestions(' + i + ')">' + i + '</button>';
    }

    if (endPage < totalPages) {
        if (endPage < totalPages - 1) {
            html += '<span class="pagination-info">...</span>';
        }
        html += '<button class="pagination-btn" onclick="loadPublicUserQuestions(' + totalPages + ')">' + totalPages + '</button>';
    }

    // 다음 버튼
    html += '<button class="pagination-btn" onclick="loadPublicUserQuestions(' + (current + 1) + ')" ' +
            (current === totalPages ? 'disabled' : '') + '>' +
            '다음 <i class="fas fa-chevron-right"></i>' +
            '</button>';

    // 페이지 정보
    html += '<span class="pagination-info" style="margin-left: 15px;">' +
            current + ' / ' + totalPages + ' 페이지</span>';

    pagination.innerHTML = html;
}

// 질문 접수 완료 모달 표시
function showSuccessModal(questionId) {
    const modal = document.getElementById('successModal');
    // questionNumber 요소는 삭제되었으므로 체크만 수행
    const questionNumberEl = document.getElementById('questionNumber');
    if (questionNumberEl) {
        questionNumberEl.textContent = questionId;
    }
    modal.classList.add('show');
}

// 모달 닫기 및 페이지 새로고침
function closeSuccessModal() {
    const modal = document.getElementById('successModal');
    modal.classList.remove('show');
    // 페이지 새로고침하여 질문 목록 업데이트
    location.reload();
}
