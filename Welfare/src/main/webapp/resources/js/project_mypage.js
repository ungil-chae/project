        // 전역 변수
        const contextPath = '<%= request.getContextPath() %>';
        let currentUserId = '<%= session.getAttribute("id") != null ? session.getAttribute("id") : "" %>';

        // 회원 정보 로드 함수
        async function loadMemberInfo() {
            try {
                const response = await fetch('/bdproject/api/member/info');
                const result = await response.json();

                if (result.success && result.data) {
                    const data = result.data;

                    // 현재 사용자 ID 설정 (email)
                    if (data.email) {
                        currentUserId = data.email;
                        console.log('currentUserId 설정됨:', currentUserId);

                        // 회원가입 후 1시간 이내인 경우 localStorage 데이터 정리
                        if (data.createdAt) {
                            const createdAt = new Date(data.createdAt);
                            const now = new Date();
                            const hoursSinceCreation = (now - createdAt) / (1000 * 60 * 60);

                            if (hoursSinceCreation < 1) {
                                console.log('신규 가입 계정 감지 (가입 후 ' + hoursSinceCreation.toFixed(2) + '시간), localStorage 데이터 정리');

                                // 이전 데이터 정리 (userEvents는 DB 기반이므로 제외)
                                localStorage.removeItem('userActivityLog_' + currentUserId);
                                localStorage.removeItem('profileImage_' + currentUserId);

                                console.log('localStorage 정리 완료');
                            }
                        }
                    }

                    // 프로필 폼에 데이터 채우기
                    const nameInput = document.getElementById('profileName');
                    const genderSelect = document.getElementById('profileGender');
                    const birthInput = document.getElementById('profileBirth');
                    const phoneInput = document.getElementById('profilePhone');
                    const emailInput = document.getElementById('profileEmail');
                    const postcodeInput = document.getElementById('profilePostcode');
                    const addressInput = document.getElementById('profileAddress');
                    const detailAddressInput = document.getElementById('profileDetailAddress');

                    if (nameInput && data.name) nameInput.value = data.name;
                    if (genderSelect && data.gender) genderSelect.value = data.gender;
                    if (birthInput && data.birth) birthInput.value = data.birth;
                    if (phoneInput && data.phone) {
                        // 전화번호 포맷팅 (01012345678 -> 010-1234-5678)
                        let phone = data.phone;
                        if (phone && phone.length === 11 && !phone.includes('-')) {
                            phone = phone.substring(0, 3) + '-' + phone.substring(3, 7) + '-' + phone.substring(7);
                        }
                        phoneInput.value = phone;
                    }
                    if (emailInput && data.email) emailInput.value = data.email;
                    if (postcodeInput && data.postcode) postcodeInput.value = data.postcode;
                    if (addressInput && data.address) addressInput.value = data.address;
                    if (detailAddressInput && data.detailAddress) detailAddressInput.value = data.detailAddress;

                    console.log('회원 정보 로드 성공:', data);
                } else {
                    console.warn('회원 정보 조회 실패:', result.message);
                }
            } catch (error) {
                console.error('회원 정보 로드 오류:', error);
            }
        }

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

                    // 성공 메시지 표시 제거 - 보라색 토스트 알림 비활성화
                    // if (result.message) {
                    //     showTemperatureToast(result.message);
                    // }
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

        // 사용자 일정 저장소 (DB 기반)
        let userEvents = {};
        let selectedDate = '';
        let editingEventId = null;

        // 날짜 포맷 함수
        function formatDateDisplay(dateStr) {
            const [year, month, day] = dateStr.split('-');
            return year + '년 ' + parseInt(month) + '월 ' + parseInt(day) + '일';
        }

        // DB에서 사용자 일정 불러오기
        async function loadUserEvents() {
            try {
                console.log('DB에서 일정 불러오기 시작');
                const response = await fetch('/bdproject/api/calendar/events');
                console.log('일정 API 응답 상태:', response.status);
                const result = await response.json();
                console.log('일정 API 응답 데이터:', result);

                if (result.success && result.events) {
                    // DB 데이터를 window.userEvents 객체로 변환 (날짜별 그룹화)
                    window.userEvents = {};
                    result.events.forEach(event => {
                        console.log('=== DB 이벤트 원본 데이터 ===');
                        console.log('전체 이벤트 객체:', event);
                        console.log('title 필드:', event.title);
                        console.log('description 필드:', event.description);
                        console.log('event_date 필드:', event.event_date);
                        console.log('eventDate 필드:', event.eventDate);

                        const dateKey = event.event_date || event.eventDate;
                        console.log('최종 날짜 키:', dateKey);

                        if (!window.userEvents[dateKey]) {
                            window.userEvents[dateKey] = [];
                        }

                        // DB 데이터를 프론트엔드 형식으로 변환
                        const convertedEvent = {
                            id: event.event_id || event.eventId,
                            title: event.title,
                            description: event.description,
                            type: 'single',
                            startDate: event.event_date || event.eventDate,
                            endDate: event.event_date || event.eventDate,
                            createdAt: event.created_at || event.createdAt
                        };
                        console.log('변환된 이벤트:', convertedEvent);
                        window.userEvents[dateKey].push(convertedEvent);
                    });
                    console.log('일정 불러오기 성공, window.userEvents:', window.userEvents);
                    console.log('userEvents 키들:', Object.keys(window.userEvents));
                } else {
                    console.log('일정이 없거나 조회 실패:', result);
                    window.userEvents = {};
                }

                // 일정 로드 후 최근 활동 업데이트
                updateRecentActivity();
            } catch (error) {
                console.error('일정 불러오기 오류:', error);
                window.userEvents = {};
            }
        }

        // 시간대 변환 함수 (상세 시간 포함)
        function formatVolunteerTime(time) {
            if (!time) return '미정';
            const timeMap = {
                '오전': '오전 (09:00~12:00)',
                '오후': '오후 (13:00~18:00)',
                '종일': '종일 (09:00~18:00)',
                '조율가능': '조율가능',
                'AM': '오전 (09:00~12:00)',
                'PM': '오후 (13:00~18:00)',
                'MORNING': '오전 (09:00~12:00)',
                'AFTERNOON': '오후 (13:00~18:00)',
                'EVENING': '저녁 (18:00~21:00)',
                'ALLDAY': '종일 (09:00~18:00)',
                'FLEXIBLE': '조율가능'
            };
            return timeMap[time] || timeMap[time.toUpperCase()] || time;
        }

        // 경험 수준 변환 함수 (DB 실제 값: NONE, LESS_THAN_1YEAR, 1_TO_3_YEARS, MORE_THAN_3YEARS)
        function formatVolunteerExperience(experience) {
            if (!experience) return '미정';

            // 디버깅: 실제 받은 경험 데이터 출력
            console.log('받은 경험 데이터:', experience, '(타입:', typeof experience + ')');

            const expMap = {
                'NONE': '경험 없음',
                'LESS_THAN_1YEAR': '1년 미만',
                '1_TO_3_YEARS': '1-3년',
                'MORE_THAN_3YEARS': '3년 이상'
            };

            const result = expMap[experience] || experience;
            console.log('변환 결과:', result);
            return result;
        }

        // 봉사 신청 내역 불러오기
        async function loadVolunteerApplications() {
            const container = document.getElementById('volunteerListContainer');

            return fetch('/bdproject/api/volunteer/my-applications')
                .then(response => response.json())
                .then(data => {
                    // 디버깅: 전체 응답 데이터 구조 확인
                    console.log('=== 봉사활동 내역 전체 응답 ===');
                    console.log('응답 데이터:', data);

                    if (data.success && data.data && data.data.length > 0) {
                        console.log('총 봉사활동 수:', data.data.length);
                        console.log('첫 번째 봉사활동 상세 데이터:', data.data[0]);
                        console.log('첫 번째 봉사활동 경험 필드:', data.data[0].volunteerExperience);
                        console.log('모든 필드 이름:', Object.keys(data.data[0]));

                        // 전역 변수에 저장 (최근 활동에서 사용)
                        window.volunteerApplications = data.data;
                    } else {
                        window.volunteerApplications = [];
                    }

                    return data;
                })
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

                            // 후기 작성 가능 여부 확인 (volunteer_end_date 및 시간대 고려)
                            let canWriteReview = false;
                            if (app.volunteerEndDate && !app.hasReview) {
                                const now = new Date();
                                const endDate = new Date(app.volunteerEndDate);

                                // 시간대별 종료 시간 설정
                                const timeEndMap = {
                                    '오전': 12,
                                    'AM': 12,
                                    'MORNING': 12,
                                    '오후': 18,
                                    'PM': 18,
                                    'AFTERNOON': 18,
                                    '저녁': 21,
                                    'EVENING': 21,
                                    '종일': 18,
                                    'ALLDAY': 18,
                                    '조율가능': 18,
                                    'FLEXIBLE': 18
                                };

                                const endHour = timeEndMap[app.volunteerTime] || 18;
                                endDate.setHours(endHour, 0, 0, 0);

                                // 봉사 종료 시간이 지났는지 확인
                                const timePassed = now >= endDate;

                                // 종료 후 3일 이내인지 확인
                                const daysPassed = Math.floor((now - endDate) / (1000 * 60 * 60 * 24));

                                // 봉사 종료 시간이 지났고, 3일 이내인 경우만 후기 작성 가능
                                canWriteReview = timePassed && daysPassed <= 3;
                            }

                            const reviewButton = canWriteReview
                                ? '<button class="review-write-btn" onclick="event.stopPropagation(); openReviewModal(' + app.applicationId + ', \'' + app.selectedCategory.replace(/'/g, "\\'") + '\')">후기 작성</button>'
                                : '';

                            // 취소 가능 여부 확인 (PENDING 또는 APPLIED 상태일 때만)
                            const canCancel = (app.status === 'PENDING' || app.status === 'APPLIED' || app.status === 'CONFIRMED');
                            const cancelButton = canCancel
                                ? '<button class="cancel-btn" style="background: #e74c3c; color: white; border: none; padding: 8px 16px; border-radius: 6px; cursor: pointer; font-size: 13px; margin-left: 8px;" onclick="event.stopPropagation(); cancelVolunteerApplication(' + app.applicationId + ', \'' + app.volunteerDate + '\', \'' + (app.volunteerTime || 'MORNING') + '\')">취소하기</button>'
                                : '';

                            // 시간대와 경험 수준 변환
                            const timeText = formatVolunteerTime(app.volunteerTime);
                            const experienceText = formatVolunteerExperience(app.volunteerExperience);

                            // 배정된 시설 정보 HTML 생성
                            let facilityHtml = '';
                            if (app.assignedFacilityName && (app.status === 'CONFIRMED' || app.status === 'COMPLETED')) {
                                facilityHtml = '<div style="background: #e8f5e9; padding: 12px; border-radius: 8px; border-left: 3px solid #4caf50; margin-bottom: 12px;">' +
                                    '<div style="font-weight: 600; color: #2e7d32; margin-bottom: 6px; font-size: 14px;">' +
                                        '<i class="fas fa-building" style="margin-right: 6px;"></i>배정된 시설' +
                                    '</div>' +
                                    '<div style="font-size: 14px; color: #333;">' +
                                        '<strong>' + app.assignedFacilityName + '</strong>' +
                                        (app.assignedFacilityAddress ? '<br><span style="color: #666; font-size: 13px;">' + app.assignedFacilityAddress + '</span>' : '') +
                                    '</div>' +
                                    (app.adminNote ? '<div style="margin-top: 8px; padding-top: 8px; border-top: 1px solid #c8e6c9; font-size: 13px; color: #555;"><i class="fas fa-sticky-note" style="color: #4caf50; margin-right: 4px;"></i>' + app.adminNote + '</div>' : '') +
                                '</div>';
                            }

                            html += '<div class="list-item" style="background: white; border: 1px solid #e0e0e0; border-radius: 12px; padding: 20px; margin-bottom: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); transition: all 0.3s ease; cursor: pointer;" onclick="showVolunteerDetail(' + app.applicationId + ')" onmouseenter="this.style.boxShadow=\'0 4px 16px rgba(0,0,0,0.12)\'; this.style.transform=\'translateY(-2px)\'" onmouseleave="this.style.boxShadow=\'0 2px 8px rgba(0,0,0,0.06)\'; this.style.transform=\'translateY(0)\'">' +
                                '<div class="list-item-header" style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">' +
                                    '<div style="flex: 1;">' +
                                        '<h4 style="font-size: 18px; font-weight: 600; color: #2c3e50; margin: 0 0 8px 0;"><i class="fas fa-hands-helping" style="color: #4A90E2; margin-right: 8px;"></i>' + app.selectedCategory + '</h4>' +
                                        '<span style="font-size: 14px; color: #7f8c8d;"><i class="far fa-calendar-alt" style="margin-right: 6px;"></i>' + dateStr + '</span>' +
                                    '</div>' +
                                    '<span class="status-badge ' + statusClass + '" style="padding: 8px 16px; border-radius: 20px; font-size: 13px; font-weight: 600;">' + statusText + '</span>' +
                                '</div>' +
                                '<div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; margin-bottom: 12px; padding: 12px; background: #f8f9fa; border-radius: 8px;">' +
                                    '<div style="display: flex; align-items: center; gap: 8px;">' +
                                        '<i class="far fa-clock" style="color: #4A90E2; font-size: 16px;"></i>' +
                                        '<span style="font-size: 14px; color: #555;"><strong>시간대:</strong> ' + timeText + '</span>' +
                                    '</div>' +
                                    (experienceText ?
                                        '<div style="display: flex; align-items: center; gap: 8px;">' +
                                            '<i class="fas fa-star" style="color: #f39c12; font-size: 16px;"></i>' +
                                            '<span style="font-size: 14px; color: #555;"><strong>경험:</strong> ' + experienceText + '</span>' +
                                        '</div>' : '') +
                                    (app.applicantAddress ?
                                        '<div style="display: flex; align-items: center; gap: 8px;">' +
                                            '<i class="fas fa-map-marker-alt" style="color: #e74c3c; font-size: 16px;"></i>' +
                                            '<span style="font-size: 14px; color: #555;"><strong>위치:</strong> ' + app.applicantAddress.substring(0, 20) + (app.applicantAddress.length > 20 ? '...' : '') + '</span>' +
                                        '</div>' : '') +
                                    (app.actualHours > 0 ?
                                        '<div style="display: flex; align-items: center; gap: 8px;">' +
                                            '<i class="fas fa-hourglass-half" style="color: #9b59b6; font-size: 16px;"></i>' +
                                            '<span style="font-size: 14px; color: #555;"><strong>활동시간:</strong> ' + app.actualHours + '시간</span>' +
                                        '</div>' : '') +
                                '</div>' +
                                facilityHtml +
                                (app.motivation ?
                                    '<div style="background: #e8f4fd; padding: 12px; border-radius: 8px; border-left: 3px solid #4A90E2; margin-bottom: 12px;">' +
                                        '<p style="margin: 0; font-size: 14px; color: #555; line-height: 1.6;"><i class="fas fa-quote-left" style="color: #4A90E2; margin-right: 6px; font-size: 12px;"></i>' +
                                        (app.motivation.length > 100 ? app.motivation.substring(0, 100) + '...' : app.motivation) + '</p>' +
                                    '</div>' : '') +
                                ((reviewButton || cancelButton) ?
                                    '<div style="text-align: right; display: flex; justify-content: flex-end; gap: 8px;">' + reviewButton + cancelButton + '</div>' : '') +
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
                    // 최근 활동 업데이트
                    updateRecentActivity();
                })
                .catch(error => {
                    console.error('봉사 내역 로드 오류:', error);
                    container.innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-circle"></i><p>봉사 내역을 불러오지 못했습니다</p></div>';
                    // 오류 발생 시에도 최근 활동 업데이트
                    updateRecentActivity();
                });
        }

        // 기부 내역 불러오기
        async function loadDonations() {
            const container = document.getElementById('donationListContainer');

            return fetch('/bdproject/api/donation/my')
                .then(response => response.json())
                .then(data => {
                    // 디버깅: 전체 응답 데이터 구조 확인
                    console.log('=== 기부 내역 전체 응답 ===');
                    console.log('응답 데이터:', data);

                    if (data.success && data.data && data.data.length > 0) {
                        console.log('총 기부 수:', data.data.length);
                        console.log('첫 번째 기부 상세 데이터:', data.data[0]);
                        console.log('모든 필드 이름:', Object.keys(data.data[0]));

                        // 전역 변수에 저장 (최근 활동에서 사용)
                        window.donationHistory = data.data;

                        let html = '';
                        let totalAmount = 0;

                        data.data.forEach((donation, index) => {
                            console.log('=== 기부 #' + (index + 1) + ' 상세 분석 ===');
                            console.log('전체 기부 객체:', donation);
                            console.log('기부 유형 필드 (donationType):', donation.donationType);
                            console.log('결제 방법 필드 (paymentMethod):', donation.paymentMethod);
                            console.log('서명 필드들:');
                            console.log('  - signature:', donation.signature);
                            console.log('  - signatureImageUrl:', donation.signatureImageUrl);
                            console.log('  - signatureImage:', donation.signatureImage);
                            console.log('  - donorSignature:', donation.donorSignature);

                            // 기부 유형 매핑 (DB 실제 값: REGULAR, ONETIME)
                            const donationTypeMap = {
                                'REGULAR': '정기 후원',
                                'ONETIME': '일시 후원'
                            };
                            const typeText = donationTypeMap[donation.donationType] || '일시 후원';
                            console.log('변환된 기부 유형:', typeText);

                            // 결제 방법 매핑 (DB 실제 값: CREDIT_CARD, BANK_TRANSFER, KAKAO_PAY, NAVER_PAY, TOSS_PAY)
                            const paymentMethodMap = {
                                'CREDIT_CARD': '신용카드',
                                'BANK_TRANSFER': '계좌이체',
                                'KAKAO_PAY': '카카오페이',
                                'NAVER_PAY': '네이버페이',
                                'TOSS_PAY': '토스페이'
                            };
                            const paymentText = paymentMethodMap[donation.paymentMethod] || donation.paymentMethod || '-';
                            console.log('변환된 결제 방법:', paymentText);

                            const dateStr = new Date(donation.createdAt).toLocaleDateString('ko-KR');
                            const amountStr = (donation.amount || 0).toLocaleString();
                            totalAmount += (donation.amount || 0);

                            // 패키지명이 있으면 표시, 없으면 카테고리명 표시
                            const titleText = (donation.packageName && donation.packageName !== 'undefined' && donation.packageName !== 'null')
                                ? donation.packageName
                                : (donation.categoryName || donation.category || '일반 기부');

                            // 정기 기부 시작일 포맷팅
                            const regularStartDateStr = donation.regularStartDate ?
                                new Date(donation.regularStartDate).toLocaleDateString('ko-KR') : null;

                            html += '<div class="list-item" style="background: white; border: 1px solid #e0e0e0; border-radius: 12px; padding: 20px; margin-bottom: 16px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); transition: all 0.3s ease; cursor: pointer;" onclick="showDonationDetail(' + donation.donationId + ')" onmouseenter="this.style.boxShadow=\'0 4px 16px rgba(0,0,0,0.12)\'; this.style.transform=\'translateY(-2px)\'" onmouseleave="this.style.boxShadow=\'0 2px 8px rgba(0,0,0,0.06)\'; this.style.transform=\'translateY(0)\'">' +
                                '<div class="list-item-header" style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 12px;">' +
                                    '<div style="flex: 1;">' +
                                        '<h4 style="font-size: 18px; font-weight: 600; color: #2c3e50; margin: 0 0 8px 0;"><i class="fas fa-heart" style="color: #e74c3c; margin-right: 8px;"></i>' + titleText + '</h4>' +
                                        '<span style="font-size: 14px; color: #7f8c8d;"><i class="far fa-calendar-alt" style="margin-right: 6px;"></i>' + dateStr + '</span>' +
                                    '</div>' +
                                    '<span class="status-badge completed" style="background: #27ae60; color: white; padding: 8px 16px; border-radius: 20px; font-size: 13px; font-weight: 600;">완료</span>' +
                                '</div>' +
                                '<div style="display: grid; grid-template-columns: repeat(2, 1fr); gap: 12px; padding: 12px; background: #f8f9fa; border-radius: 8px;">' +
                                    '<div style="display: flex; align-items: center; gap: 8px;">' +
                                        '<i class="fas fa-won-sign" style="color: #27ae60; font-size: 16px;"></i>' +
                                        '<span style="font-size: 14px; color: #555;"><strong>금액:</strong> ' + amountStr + '원</span>' +
                                    '</div>' +
                                    '<div style="display: flex; align-items: center; gap: 8px;">' +
                                        '<i class="fas fa-sync-alt" style="color: #3498db; font-size: 16px;"></i>' +
                                        '<span style="font-size: 14px; color: #555;"><strong>유형:</strong> ' + typeText + '</span>' +
                                    '</div>' +
                                    (donation.paymentMethod ?
                                        '<div style="display: flex; align-items: center; gap: 8px;">' +
                                            '<i class="fas fa-credit-card" style="color: #9b59b6; font-size: 16px;"></i>' +
                                            '<span style="font-size: 14px; color: #555;"><strong>결제:</strong> ' + paymentText + '</span>' +
                                        '</div>' : '') +
                                    (regularStartDateStr ?
                                        '<div style="display: flex; align-items: center; gap: 8px;">' +
                                            '<i class="fas fa-calendar-check" style="color: #f39c12; font-size: 16px;"></i>' +
                                            '<span style="font-size: 14px; color: #555;"><strong>시작일:</strong> ' + regularStartDateStr + '</span>' +
                                        '</div>' : '') +
                                    (donation.categoryName ?
                                        '<div style="display: flex; align-items: center; gap: 8px;">' +
                                            '<i class="fas fa-tag" style="color: #1abc9c; font-size: 16px;"></i>' +
                                            '<span style="font-size: 14px; color: #555;"><strong>분야:</strong> ' + donation.categoryName + '</span>' +
                                        '</div>' : '') +
                                '</div>' +
                                (donation.message && donation.message !== 'false' && donation.message.trim() !== '' ?
                                    '<div style="background: #fff5f5; padding: 12px; border-radius: 8px; border-left: 3px solid #e74c3c; margin-top: 12px;">' +
                                        '<p style="margin: 0; font-size: 14px; color: #555; line-height: 1.6;"><i class="fas fa-quote-left" style="color: #e74c3c; margin-right: 6px; font-size: 12px;"></i>' +
                                        (donation.message.length > 100 ? donation.message.substring(0, 100) + '...' : donation.message) + '</p>' +
                                    '</div>' : '') +
                                (donation.signatureImage && donation.signatureImage !== 'null' && donation.signatureImage !== '' && donation.signatureImage.length > 10 ?
                                    '<div style="background: #e8f5e9; padding: 8px 12px; border-radius: 6px; margin-top: 12px; display: inline-flex; align-items: center; gap: 6px;">' +
                                        '<i class="fas fa-signature" style="color: #27ae60;"></i>' +
                                        '<span style="font-size: 13px; color: #27ae60; font-weight: 600;">서명 포함</span>' +
                                    '</div>' : '') +
                                // 버튼 영역 추가 (리뷰 작성, 환불)
                                '<div style="display: flex; gap: 10px; margin-top: 15px; justify-content: flex-end;">' +
                                    (!donation.hasReview ?
                                        '<button onclick="event.stopPropagation(); openDonationReviewModal(' + donation.donationId + ', \'' + (titleText || '').replace(/'/g, "\\'") + '\', ' + (donation.amount || 0) + ')" style="padding: 8px 16px; background: #3498db; color: white; border: none; border-radius: 6px; font-size: 13px; cursor: pointer; display: flex; align-items: center; gap: 6px;"><i class="fas fa-pen"></i>리뷰 작성</button>' :
                                        '<span style="padding: 8px 16px; background: #95a5a6; color: white; border-radius: 6px; font-size: 13px; display: flex; align-items: center; gap: 6px;"><i class="fas fa-check"></i>리뷰 작성완료</span>') +
                                    (canRefund(donation.createdAt) && donation.paymentStatus !== 'REFUNDED' ?
                                        '<button onclick="event.stopPropagation(); requestRefund(' + donation.donationId + ', ' + (donation.amount || 0) + ', \'' + donation.createdAt + '\')" style="padding: 8px 16px; background: #e74c3c; color: white; border: none; border-radius: 6px; font-size: 13px; cursor: pointer; display: flex; align-items: center; gap: 6px;"><i class="fas fa-undo"></i>환불 요청</button>' : '') +
                                    (donation.paymentStatus === 'REFUNDED' ?
                                        '<span style="padding: 8px 16px; background: #95a5a6; color: white; border-radius: 6px; font-size: 13px; display: flex; align-items: center; gap: 6px;"><i class="fas fa-ban"></i>환불완료</span>' : '') +
                                '</div>' +
                            '</div>';
                        });

                        container.innerHTML = html;

                        // 총 기부 금액 업데이트
                        const totalDonationElement = document.getElementById('totalDonationAmount');
                        if (totalDonationElement) {
                            totalDonationElement.textContent = totalAmount.toLocaleString() + '원';
                        }
                    } else {
                        // 전역 변수 초기화
                        window.donationHistory = [];

                        container.innerHTML = '<div class="empty-state"><i class="fas fa-heart"></i><p>기부 내역이 없습니다</p></div>';

                        // 데이터 없을 때 0으로 표시
                        const totalDonationElement = document.getElementById('totalDonationAmount');
                        if (totalDonationElement) {
                            totalDonationElement.textContent = '0원';
                        }
                    }
                    // 최근 활동 업데이트
                    updateRecentActivity();
                })
                .catch(error => {
                    console.error('기부 내역 로드 오류:', error);
                    container.innerHTML = '<div class="empty-state"><i class="fas fa-exclamation-circle"></i><p>기부 내역을 불러오지 못했습니다</p></div>';
                    // 오류 발생 시에도 최근 활동 업데이트
                    updateRecentActivity();
                });
        }

        // FAQ 질문 내역 불러오기
        async function loadMyQuestions() {
            try {
                const response = await fetch('/bdproject/api/questions/my-questions');
                const data = await response.json();

                if (data.success && data.data) {
                    window.userQuestions = data.data;
                    console.log('FAQ 질문 로드 완료:', window.userQuestions.length, '개');
                } else {
                    window.userQuestions = [];
                }
            } catch (error) {
                console.error('FAQ 질문 로드 오류:', error);
                window.userQuestions = [];
            }
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
                                <a href="/bdproject/project_detail.jsp" class="btn btn-primary">복지 혜택 찾기</a>
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

            if (!container) {
                console.warn('diagnosisListContainer 요소를 찾을 수 없습니다.');
                return;
            }

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
                                if (diagnosis.matchedServices) {
                                    services = JSON.parse(diagnosis.matchedServices);
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
            if (!status) return '-';
            const statusMap = {
                'applied': '신청완료',
                'APPLIED': '신청완료',
                'confirmed': '확인완료',
                'CONFIRMED': '확인완료',
                'approved': '승인완료',
                'APPROVED': '승인완료',
                'completed': '완료',
                'COMPLETED': '완료',
                'cancelled': '취소',
                'CANCELLED': '취소',
                'pending': '대기중',
                'PENDING': '대기중'
            };
            return statusMap[status] || statusMap[status.toUpperCase()] || status;
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
        // saveUserEvents 함수 제거 - DB 기반으로 전환

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
            const events = (window.userEvents && window.userEvents[dateStr]) ? window.userEvents[dateStr] : [];

            console.log('📅 displayEventsForDate 호출 - 날짜:', dateStr);
            console.log('📅 해당 날짜 일정 수:', events.length);
            console.log('📅 일정 목록:', events);

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

        // 일정 저장 (DB 기반)
        async function saveEvent() {
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

            let savedSuccessfully = false;

            try {
                // 날짜 범위의 모든 날짜에 일정 생성
                // 시간대 문제를 방지하기 위해 로컬 날짜 문자열을 직접 사용
                let currentDateStr = selectedDate;
                const savedEvents = [];

                // 날짜 비교를 위한 Date 객체 생성 (로컬 시간대 사용)
                const endDateObj = new Date(endDate + 'T00:00:00');
                let currentDateObj = new Date(currentDateStr + 'T00:00:00');

                while (currentDateObj <= endDateObj) {
                    const dateStr = currentDateObj.getFullYear() + '-' +
                                   String(currentDateObj.getMonth() + 1).padStart(2, '0') + '-' +
                                   String(currentDateObj.getDate()).padStart(2, '0');

                    const eventData = {
                        title: title,
                        description: description,
                        event_date: dateStr,
                        event_type: 'PERSONAL',
                        reminder_enabled: true,
                        remind_before_days: 1,
                        status: 'SCHEDULED'
                    };

                    // DB에 저장
                    const response = await fetch('/bdproject/api/calendar/events', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify(eventData)
                    });

                    const result = await response.json();
                    if (result.success) {
                        savedEvents.push(result.event);
                    }

                    // 다음 날짜로 이동 (로컬 시간대 기준)
                    currentDateObj.setDate(currentDateObj.getDate() + 1);
                }

                savedSuccessfully = true;

                // 사용자 활동 로그에 기록
                logUserActivity({
                    type: 'calendar_create',
                    icon: 'fas fa-calendar-plus',
                    iconColor: '#4A90E2',
                    title: '일정 등록',
                    description: selectedDate + '에 "' + title + '" 일정을 등록했습니다.',
                    timestamp: new Date().toISOString()
                });

                // DB에서 일정 다시 불러오기
                await loadUserEvents();

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

            } catch (error) {
                console.error('일정 저장 오류:', error);
                alert('일정 저장 중 오류가 발생했습니다.');
            } finally {
                // 저장 성공 여부와 관계없이 알림 생성 시도
                if (savedSuccessfully) {
                    try {
                        console.log('🔔 일정 저장 완료 - 알림 생성 시작');
                        console.log('  - selectedDate:', selectedDate);
                        console.log('  - title:', title);
                        await createCalendarNotifications(selectedDate, title, description);
                        console.log('🔔 알림 생성 함수 호출 완료');
                    } catch (notifError) {
                        console.error('❌ 알림 생성 중 오류:', notifError);
                    }
                }
            }
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
        async function deleteEvent(dateStr, index) {
            if (!confirm('이 일정을 삭제하시겠습니까?')) {
                return;
            }

            try {
                const event = userEvents[dateStr][index];
                const eventId = event.id;

                // DB에서 삭제
                const response = await fetch('/bdproject/api/calendar/events/' + eventId, {
                    method: 'DELETE'
                });

                const result = await response.json();

                if (result.success) {
                    // DB에서 일정 다시 불러오기
                    await loadUserEvents();

                    displayEventsForDate(dateStr);
                    renderMonthCalendar();
                    updateRecentActivity();

                    alert('일정이 삭제되었습니다.');
                } else {
                    alert('일정 삭제에 실패했습니다.');
                }

            } catch (error) {
                console.error('일정 삭제 오류:', error);
                alert('일정 삭제 중 오류가 발생했습니다.');
            }
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
                if (calendarEvents[dateStr] || (window.userEvents && window.userEvents[dateStr])) {
                    dayClass += ' has-event';
                }

                // 사용자 일정 제목 가져오기
                let eventTitle = '';
                if (window.userEvents && window.userEvents[dateStr] && window.userEvents[dateStr].length > 0) {
                    const firstEvent = window.userEvents[dateStr][0];
                    console.log('날짜 ' + dateStr + '의 첫 번째 일정:', firstEvent);
                    console.log('  - title:', firstEvent.title);
                    console.log('  - description:', firstEvent.description);
                    eventTitle = firstEvent.title || '(제목 없음)'; // 첫 번째 일정 제목만 표시
                    if (window.userEvents[dateStr].length > 1) {
                        eventTitle += ' +' + (window.userEvents[dateStr].length - 1); // 추가 일정 개수 표시
                    }
                    console.log('  - 최종 eventTitle:', eventTitle);
                }

                let eventDots = '';
                // 시스템 이벤트 표시
                if (calendarEvents[dateStr]) {
                    calendarEvents[dateStr].forEach(function(eventType) {
                        eventDots += '<div class="event-dot ' + eventType + '"></div>';
                    });
                }
                // 사용자 이벤트 표시 (사용자 지정 색상으로 표시)
                if (window.userEvents && window.userEvents[dateStr] && window.userEvents[dateStr].length > 0) {
                    for (let i = 0; i < Math.min(window.userEvents[dateStr].length, 3); i++) {
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

        // 사용자 활동 로그 함수
        function logUserActivity(activity) {
            const userId = currentUserId || 'guest';
            const activityLog = JSON.parse(localStorage.getItem('userActivityLog_' + userId) || '[]');

            activityLog.unshift(activity); // 최신 활동을 앞에 추가

            // 최대 100개까지만 보관
            if (activityLog.length > 100) {
                activityLog.splice(100);
            }

            localStorage.setItem('userActivityLog_' + userId, JSON.stringify(activityLog));
        }

        // 캘린더 일정 알림 생성 함수
        async function createCalendarNotifications(eventDate, title, description) {
            console.log('📢 createCalendarNotifications 함수 시작');
            console.log('  - eventDate:', eventDate);
            console.log('  - title:', title);
            console.log('  - description:', description);

            try {
                const today = new Date();
                today.setHours(0, 0, 0, 0);
                console.log('  - today (00:00:00):', today.toISOString());

                const eventDateObj = new Date(eventDate + 'T00:00:00');
                console.log('  - eventDateObj:', eventDateObj.toISOString());
                console.log('  - 과거 날짜 여부 (eventDateObj < today):', eventDateObj < today);

                const oneDayBefore = new Date(eventDateObj);
                oneDayBefore.setDate(oneDayBefore.getDate() - 1);

                // 과거 날짜의 일정인 경우: 즉시 "일정 등록 완료" 알림 생성
                if (eventDateObj < today) {
                    console.log('🔔 과거 날짜 일정 감지:', eventDate, '< 오늘:', today.toISOString().split('T')[0]);

                    const registrationNotification = {
                        type: 'CALENDAR_EVENT',
                        title: '일정이 등록되었습니다',
                        content: eventDate + '에 \'' + title + '\' 일정이 등록되었습니다.',
                        relatedId: Date.now(),
                        eventDate: new Date().toISOString().split('T')[0]  // 오늘 날짜로 알림 생성
                    };

                    console.log('📤 알림 생성 요청 데이터:', registrationNotification);

                    const response = await fetch('/bdproject/api/notifications/create-calendar', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify(registrationNotification)
                    });

                    const result = await response.json();
                    console.log('📥 알림 생성 응답:', result);

                    if (result.success) {
                        console.log('✅ 과거 날짜 일정 등록 알림 생성 완료');
                        // 알림 목록 새로고침
                        await loadNotifications();
                    } else {
                        console.error('❌ 알림 생성 실패:', result.message);
                    }

                    return;  // 과거 일정은 추가 알림 생성하지 않음
                }

                // 미래 날짜의 일정인 경우: 기존 로직 (하루 전, 당일 알림)
                console.log('📅 미래/오늘 날짜 일정:', eventDate, '>= 오늘:', today.toISOString().split('T')[0]);
                let notificationsCreated = 0;

                // 하루 전 알림 (하루 전 날짜가 오늘 이후인 경우에만)
                if (oneDayBefore >= today) {
                    const beforeNotification = {
                        type: 'CALENDAR_EVENT',
                        title: '내일은 일정이 있는 날입니다',
                        content: '내일 \'' + title + '\' 일정이 예정되어 있습니다.',
                        relatedId: Date.now(),
                        eventDate: oneDayBefore.toISOString().split('T')[0]
                    };

                    console.log('📤 하루 전 알림 요청:', beforeNotification);

                    const response1 = await fetch('/bdproject/api/notifications/create-calendar', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify(beforeNotification)
                    });

                    const result1 = await response1.json();
                    console.log('📥 하루 전 알림 응답:', result1);
                    if (result1.success) notificationsCreated++;
                }

                // 당일 알림 (일정 날짜가 오늘 이후인 경우에만)
                if (eventDateObj >= today) {
                    const todayNotification = {
                        type: 'CALENDAR_EVENT',
                        title: '오늘은 일정이 있는 날입니다',
                        content: '오늘 \'' + title + '\' 일정이 있습니다. 잊지 마세요!',
                        relatedId: Date.now() + 1,
                        eventDate: eventDate
                    };

                    console.log('📤 당일 알림 요청:', todayNotification);

                    const response2 = await fetch('/bdproject/api/notifications/create-calendar', {
                        method: 'POST',
                        headers: {'Content-Type': 'application/json'},
                        body: JSON.stringify(todayNotification)
                    });

                    const result2 = await response2.json();
                    console.log('📥 당일 알림 응답:', result2);
                    if (result2.success) notificationsCreated++;
                }

                console.log('✅ 캘린더 일정 알림 생성 완료 - 생성된 알림 수:', notificationsCreated);

                // 알림이 생성되었으면 알림 목록 새로고침
                if (notificationsCreated > 0) {
                    await loadNotifications();
                }
            } catch (error) {
                console.error('캘린더 알림 생성 오류:', error);
            }
        }

        // 네비바 메뉴
        document.addEventListener('DOMContentLoaded', function() {
            console.log('DOM Content Loaded');

            // 회원 정보 로드
            loadMemberInfo();

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

                        // 로그아웃 전 사용자별 localStorage 데이터 삭제
                        const userId = currentUserId || '<%= session.getAttribute("id") != null ? session.getAttribute("id") : "" %>';
                        if (userId) {
                            // userEvents는 DB 기반이므로 localStorage 삭제 불필요
                            localStorage.removeItem('userActivityLog_' + userId);
                            localStorage.removeItem('profileImage_' + userId);
                            console.log('로그아웃: 사용자 데이터 삭제 완료 -', userId);
                        }

                        // 세션 스토리지 클리어
                        sessionStorage.clear();

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
            (async function() {
                try {
                    // 현재 날짜로 초기화
                    currentYear = todayDate.getFullYear();
                    currentMonth = todayDate.getMonth();

                    detectUserTimezone();
                    initEvents();
                    await loadUserEvents(); // 사용자 일정 불러오기 (DB)
                    loadVolunteerApplications(); // 봉사 신청 내역 불러오기
                    loadDonations(); // 기부 내역 불러오기
                    loadFavoriteServices(); // 관심 복지 서비스 불러오기
                    loadDiagnosisHistory(); // 복지 진단 내역 불러오기
                    renderMonthCalendar();
                } catch (error) {
                    console.error('Error initializing calendar:', error);
                }
            })();

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
                profileForm.addEventListener('submit', async function(e) {
                    e.preventDefault();

                    // 폼 데이터 수집
                    const name = document.getElementById('profileName').value.trim();
                    const gender = document.getElementById('profileGender').value;
                    const birth = document.getElementById('profileBirth').value;
                    const phone = document.getElementById('profilePhone').value.trim();

                    // 유효성 검사
                    if (!name) {
                        alert('이름을 입력해주세요.');
                        return;
                    }

                    if (!birth) {
                        alert('생년월일을 입력해주세요.');
                        return;
                    }

                    if (!phone) {
                        alert('전화번호를 입력해주세요.');
                        return;
                    }

                    // 전화번호 형식 변환 (하이픈 제거)
                    const phoneNumber = phone.replace(/-/g, '');
                    if (!/^\d{11}$/.test(phoneNumber)) {
                        alert('올바른 전화번호 형식이 아닙니다. (예: 010-1234-5678)');
                        return;
                    }

                    // 주소 정보 가져오기
                    const postcode = document.getElementById('profilePostcode')?.value || '';
                    const address = document.getElementById('profileAddress')?.value || '';
                    const detailAddress = document.getElementById('profileDetailAddress')?.value || '';

                    // 서버에 전송할 데이터
                    const formData = new URLSearchParams();
                    formData.append('name', name);
                    formData.append('gender', gender);
                    formData.append('birth', birth);
                    formData.append('phone', phoneNumber);
                    formData.append('postcode', postcode);
                    formData.append('address', address);
                    formData.append('detailAddress', detailAddress);

                    try {
                        console.log('=== 프로필 수정 요청 시작 ===');
                        console.log('전송 데이터:', formData.toString());

                        const response = await fetch('/bdproject/api/member/updateProfile', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded'
                            },
                            body: formData.toString()
                        });

                        console.log('응답 상태:', response.status);
                        console.log('응답 헤더:', response.headers.get('Content-Type'));

                        if (!response.ok) {
                            const errorText = await response.text();
                            console.error('서버 오류 응답:', errorText);
                            alert('서버 오류: ' + response.status + ' - 관리자에게 문의하세요.');
                            return;
                        }

                        const result = await response.json();
                        console.log('서버 응답:', result);

                        if (result.success) {
                            alert('회원 정보가 성공적으로 수정되었습니다.');
                            // 회원 정보 다시 로드
                            await loadMemberInfo();
                        } else {
                            alert(result.message || '회원 정보 수정에 실패했습니다.');
                        }
                    } catch (error) {
                        console.error('프로필 수정 오류:', error);
                        console.error('오류 스택:', error.stack);
                        alert('회원 정보 수정 중 오류가 발생했습니다: ' + error.message);
                    }
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

                    // 영문자 포함 검사
                    if (!/[a-zA-Z]/.test(newPw)) {
                        alert('비밀번호는 영문자를 최소 1개 이상 포함해야 합니다.');
                        return;
                    }

                    // 숫자 포함 검사
                    if (!/[0-9]/.test(newPw)) {
                        alert('비밀번호는 숫자를 최소 1개 이상 포함해야 합니다.');
                        return;
                    }

                    // 특수문자 포함 검사
                    if (!/[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(newPw)) {
                        alert('비밀번호는 특수문자를 최소 1개 이상 포함해야 합니다.\n(예: !@#$%^&*()_+-=[]{};\':"|,.<>/?)');
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

                    // 필수 조건 체크
                    const hasLength = password.length >= 8;
                    const hasLetter = /[a-zA-Z]/.test(password);
                    const hasNumber = /[0-9]/.test(password);
                    const hasSpecial = /[!@#$%^&*()_+\-=\[\]{};':"\\|,.<>\/?]/.test(password);

                    let strength = 0;
                    if (hasLength) strength++;
                    if (hasLetter) strength++;
                    if (hasNumber) strength++;
                    if (hasSpecial) strength++;

                    // 필수 조건 미충족 시 경고 메시지
                    let missingMsg = [];
                    if (!hasLength) missingMsg.push('8자 이상');
                    if (!hasLetter) missingMsg.push('영문자');
                    if (!hasNumber) missingMsg.push('숫자');
                    if (!hasSpecial) missingMsg.push('특수문자');

                    if (strength < 4) {
                        strengthBar.className = 'password-strength-bar weak';
                        strengthText.textContent = '필요: ' + missingMsg.join(', ');
                        strengthText.style.color = '#dc3545';
                    } else {
                        strengthBar.className = 'password-strength-bar strong';
                        strengthText.textContent = '✓ 사용 가능한 비밀번호입니다';
                        strengthText.style.color = '#28a745';
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
                    // ID로 요소 찾아서 값 설정
                    const postcodeInput = document.getElementById('profilePostcode');
                    const addressInput = document.getElementById('profileAddress');
                    const detailAddressInput = document.getElementById('profileDetailAddress');

                    if (postcodeInput) postcodeInput.value = data.zonecode;
                    if (addressInput) addressInput.value = data.address;
                    if (detailAddressInput) detailAddressInput.focus();

                    console.log('주소 선택 완료:', data.zonecode, data.address);
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
        async function saveNotificationSettings() {
            // 서버 DTO와 맞추기 위해 snake_case 사용
            const settings = {
                event_notification: document.getElementById('eventNotification').checked,
                donation_notification: document.getElementById('donationNotification').checked,
                volunteer_notification: document.getElementById('volunteerNotification').checked,
                faq_answer_notification: document.getElementById('faqAnswerNotification').checked
            };

            console.log('=== 알림 설정 저장 시작 ===');
            console.log('저장할 설정값:', settings);

            // 서버에 저장
            try {
                const response = await fetch('/bdproject/api/notifications/settings', {
                    method: 'POST',
                    headers: {'Content-Type': 'application/json'},
                    body: JSON.stringify(settings)
                });

                console.log('서버 응답 상태:', response.status);
                const result = await response.json();
                console.log('서버 응답 데이터:', result);

                if (result.success) {
                    console.log('✅ 알림 설정이 서버에 저장되었습니다.');
                } else {
                    console.error('❌ 알림 설정 저장 실패:', result.message);
                }
            } catch (error) {
                console.error('❌ 알림 설정 저장 중 오류:', error);
            }
        }

        // 알림 목록 불러오기
        // skipGenerate: true면 자동 생성을 건너뜀 (삭제 후 새로고침 시)
        async function loadNotifications(skipGenerate = false) {
            try {
                // 1. 알림 자동 생성 API 호출 (정기 기부, 봉사, 캘린더)
                // 페이지 최초 로드 시에만 실행
                if (!skipGenerate) {
                    try {
                        const generateResponse = await fetch('/bdproject/api/notifications/generate', {
                            method: 'POST'
                        });
                        const generateResult = await generateResponse.json();
                        if (generateResult.success && generateResult.count > 0) {
                            console.log('✅ ' + generateResult.count + '개의 알림이 자동 생성되었습니다.');
                        }
                    } catch (generateError) {
                        console.log('알림 자동 생성 실패:', generateError);
                    }
                }

                // 2. 서버 알림 가져오기 시도
                try {
                    const response = await fetch('/bdproject/api/notifications');
                    const result = await response.json();

                    if (result.success && result.data) {
                        // 디버깅: 서버 응답 확인
                        console.log('서버 알림 응답:', result);
                        if (result.data.length > 0) {
                            console.log('첫 번째 알림 샘플:', result.data[0]);
                        }

                        // 서버 알림만 사용 (로컬 알림은 서버 연결 실패 시에만 사용)
                        const serverNotifications = result.data;

                        // 날짜순 정렬
                        serverNotifications.sort((a, b) => {
                            const dateA = new Date(a.created_at || a.createdAt || 0);
                            const dateB = new Date(b.created_at || b.createdAt || 0);
                            return dateB - dateA;
                        });

                        window.cachedNotifications = serverNotifications;
                        displayNotifications(serverNotifications, currentNotificationFilter || 'all');
                        updateNotificationCounts(serverNotifications);
                        updateNotificationBadge(serverNotifications);
                        updateRecentActivity();
                        return;
                    }
                } catch (serverError) {
                    console.log('서버 알림 로드 실패, 로컬 알림만 사용:', serverError);
                }

                // 서버 오류 시 로컬 알림만 사용 (fallback)
                let localNotifications = JSON.parse(localStorage.getItem('localNotifications') || '[]');
                window.cachedNotifications = localNotifications;
                displayNotifications(localNotifications, 'all');
                updateNotificationCounts(localNotifications);
                updateNotificationBadge(localNotifications);
                updateRecentActivity();

            } catch (error) {
                console.error('알림 로딩 오류:', error);
            }
        }

        // 알림 표시
        function displayNotifications(notifications, filter) {
            const container = document.getElementById('notificationList');

            console.log('=== displayNotifications 호출 ===');
            console.log('전체 알림 개수:', notifications.length);
            console.log('필터:', filter);
            console.log('알림 샘플 (첫 3개):', notifications.slice(0, 3));

            let filtered = notifications;
            if (filter !== 'all') {
                if (filter === 'unread') {
                    filtered = notifications.filter(n => !n.is_read);
                } else {
                    // 필터 타입 매핑 (서버 타입과 프론트엔드 필터 연결)
                    const typeFilterMap = {
                        'faq_answer': ['faq_answer', 'FAQ_ANSWER'],
                        'schedule': ['schedule', 'CALENDAR_EVENT'],
                        'donation': ['donation', 'DONATION_REMINDER'],
                        'volunteer': ['volunteer', 'VOLUNTEER_REMINDER', 'VOLUNTEER_APPROVED']
                    };
                    const matchTypes = typeFilterMap[filter] || [filter];
                    filtered = notifications.filter(n => matchTypes.includes(n.type) || matchTypes.includes(n.notification_type));
                }
            }

            console.log('필터링 후 알림 개수:', filtered.length);

            if (filtered.length === 0) {
                container.innerHTML = '<div class="empty-state"><i class="fas fa-bell"></i><p>받은 알림이 없습니다</p></div>';
                return;
            }

            let html = '';
            filtered.forEach((notif, index) => {
                console.log('알림 #' + (index + 1) + ' 데이터:', notif);
                console.log('  - notification_id:', notif.notification_id);
                console.log('  - title:', notif.title);
                console.log('  - message:', notif.message);
                console.log('  - content:', notif.content);
                console.log('  - type:', notif.type);
                console.log('  - notification_type:', notif.notification_type);
                console.log('  - is_read:', notif.is_read);
                console.log('  - created_at:', notif.created_at);

                // 타입은 notification_type 또는 type 필드에서 가져옴
                const notifType = notif.notification_type || notif.type || 'GENERAL';
                const typeText = getNotificationTypeText(notifType);
                const readClass = notif.is_read ? '' : 'unread';

                // 날짜 처리
                let date = '날짜 없음';
                try {
                    if (notif.created_at) {
                        date = new Date(notif.created_at).toLocaleString('ko-KR');
                    } else if (notif.createdAt) {
                        date = new Date(notif.createdAt).toLocaleString('ko-KR');
                    }
                } catch (e) {
                    console.error('날짜 파싱 오류:', e);
                }

                // 메시지는 message 또는 content 필드에서 가져옴
                const message = notif.message || notif.content || '내용 없음';
                const title = notif.title || '알림';
                const notifId = notif.notification_id || notif.id || 0;
                const relatedId = notif.related_id || notif.relatedId || null;

                // notification_type에 따라 동적으로 URL 생성
                let relatedUrl = notif.related_url || '#';
                if (relatedUrl === '#' && relatedId) {
                    const upperType = notifType.toUpperCase();
                    if (upperType === 'FAQ_ANSWER' || upperType === 'FAQ') {
                        relatedUrl = '/bdproject/project_mypage.jsp?viewQuestion=' + relatedId;
                    } else if (upperType === 'VOLUNTEER_APPROVED' || upperType === 'VOLUNTEER_REMINDER') {
                        relatedUrl = '/bdproject/project_mypage.jsp?tab=volunteer&applicationId=' + relatedId;
                    } else if (upperType === 'DONATION_REMINDER') {
                        relatedUrl = '/bdproject/project_mypage.jsp?tab=donations';
                    } else if (upperType === 'CALENDAR_EVENT') {
                        relatedUrl = '/bdproject/project_mypage.jsp?tab=calendar&eventId=' + relatedId;
                    }
                }

                // 디버깅: notifId 확인
                if (index < 3) {
                    console.log('알림 #' + (index + 1) + ' HTML 생성 - notifId: ' + notifId + ', 타입: ' + (typeof notifId));
                }

                html += '<div class="notification-item ' + readClass + '" data-id="' + notifId + '">' +
                    '<div class="notification-item-content" onclick="markAsReadAndRedirect(' + notifId + ', \'' + relatedUrl + '\')">' +
                        '<div>' +
                            '<span class="notification-item-type type-' + notifType + '">' + typeText + '</span>' +
                            '<span class="notification-item-title">' + title + '</span>' +
                        '</div>' +
                        '<p style="margin: 8px 0 0 0; font-size: 14px; color: #555;">' + message + '</p>' +
                        '<div class="notification-item-date">' + date + '</div>' +
                    '</div>' +
                    '<button class="notification-delete-btn" onclick="event.stopPropagation(); deleteNotification(' + notifId + ');" title="삭제">' +
                        '<i class="fas fa-times"></i>' +
                    '</button>' +
                '</div>';
            });

            container.innerHTML = html;
        }

        // 알림 유형 텍스트 변환
        function getNotificationTypeText(type) {
            const typeMap = {
                'faq_answer': 'FAQ 답변',
                'FAQ_ANSWER': 'FAQ 답변',
                'schedule': '일정',
                'CALENDAR_EVENT': '일정',
                'donation': '기부',
                'DONATION_REMINDER': '기부',
                'volunteer': '봉사',
                'VOLUNTEER_REMINDER': '봉사',
                'VOLUNTEER_APPROVED': '봉사 승인',
                'system': '시스템',
                'SYSTEM': '시스템',
                'GENERAL': '일반'
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

        // 현재 필터 상태 저장
        let currentNotificationFilter = 'all';

        // 알림 필터링
        function filterNotifications(filter) {
            currentNotificationFilter = filter;

            // 버튼 활성화 상태 변경
            document.querySelectorAll('.notification-filter-btn').forEach(btn => {
                btn.classList.remove('active');
            });
            document.querySelector('[data-filter="' + filter + '"]').classList.add('active');

            // 캐시된 알림으로 필터 적용 (서버 재조회 불필요)
            if (window.cachedNotifications) {
                displayNotifications(window.cachedNotifications, filter);
                updateNotificationCounts(window.cachedNotifications);
            }
        }

        // 알림 읽음 처리 및 리다이렉트
        async function markAsReadAndRedirect(notificationId, url) {
            try {
                await fetch('/bdproject/api/notifications/' + notificationId + '/read', {
                    method: 'POST'
                });

                // 알림 목록 새로고침 (자동 생성 건너뜀)
                await loadNotifications(true);

                // URL이 있으면 처리
                if (url && url !== '#') {
                    // FAQ 질문 상세 보기인 경우 모달로 열기
                    if (url.includes('viewQuestion=')) {
                        const urlParams = new URLSearchParams(url.split('?')[1]);
                        const questionId = urlParams.get('viewQuestion');
                        if (questionId) {
                            openFaqDetailModal(questionId);
                            return;
                        }
                    }
                    // 봉사활동 승인 알림인 경우 상세 모달로 열기
                    if (url.includes('applicationId=')) {
                        const urlParams = new URLSearchParams(url.split('?')[1]);
                        const applicationId = urlParams.get('applicationId');
                        if (applicationId) {
                            openVolunteerDetailModal(applicationId);
                            return;
                        }
                    }
                    // 그 외의 경우 페이지 이동
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
                    await loadNotifications(true);
                }
            } catch (error) {
                console.error('모두 읽음 처리 오류:', error);
                alert('알림 처리 중 오류가 발생했습니다.');
            }
        }

        // 알림 삭제
        async function deleteNotification(notificationId) {
            console.log('=== deleteNotification 호출 ===');
            console.log('전달받은 notificationId:', notificationId);
            console.log('notificationId 타입:', typeof notificationId);

            if (!notificationId || notificationId === 0) {
                console.error('유효하지 않은 notification ID:', notificationId);
                alert('알림 ID가 유효하지 않습니다.');
                return;
            }

            if (!confirm('이 알림을 삭제하시겠습니까?')) {
                return;
            }

            try {
                const url = '/bdproject/api/notifications/' + notificationId;
                console.log('DELETE 요청 URL:', url);

                const response = await fetch(url, {
                    method: 'DELETE'
                });

                console.log('응답 상태:', response.status);
                console.log('응답 Content-Type:', response.headers.get('Content-Type'));

                const result = await response.json();
                console.log('응답 결과:', result);

                if (result.success) {
                    // 삭제 후 목록 새로고침 (자동 생성 건너뜀)
                    await loadNotifications(true);
                } else {
                    alert(result.message || '알림 삭제에 실패했습니다.');
                }
            } catch (error) {
                console.error('알림 삭제 오류:', error);
                alert('알림 삭제 중 오류가 발생했습니다.');
            }
        }

        // 전체 알림 삭제
        async function deleteAllNotifications() {
            if (!confirm('모든 알림을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.')) {
                return;
            }

            try {
                const response = await fetch('/bdproject/api/notifications/delete-all', {
                    method: 'POST'
                });
                const result = await response.json();

                if (result.success) {
                    alert('모든 알림이 삭제되었습니다.');
                    await loadNotifications(true);
                } else {
                    alert(result.message || '알림 삭제에 실패했습니다.');
                }
            } catch (error) {
                console.error('전체 알림 삭제 오류:', error);
                alert('알림 삭제 중 오류가 발생했습니다.');
            }
        }

        // 로그인 상태 유지 토글 (자동 로그인)
        async function toggleAutoLogin() {
            const checkbox = document.getElementById('autoLoginEnabled');
            const isEnabled = checkbox.checked;

            if (isEnabled) {
                // 로그인 상태 유지 활성화
                if (!confirm('로그인 상태 유지를 활성화하시겠습니까?\n30일간 자동으로 로그인됩니다.')) {
                    checkbox.checked = false; // 취소하면 체크 해제
                    return;
                }

                try {
                    const response = await fetch(contextPath + '/api/auth/enable-auto-login', {
                        method: 'POST'
                    });
                    const result = await response.json();

                    if (result.success) {
                        alert('로그인 상태 유지가 활성화되었습니다.\n30일간 자동 로그인됩니다.');
                    } else {
                        alert(result.message || '로그인 상태 유지 활성화에 실패했습니다.');
                        checkbox.checked = false; // 실패하면 체크 해제
                    }
                } catch (error) {
                    console.error('로그인 상태 유지 활성화 오류:', error);
                    alert('로그인 상태 유지 활성화 중 오류가 발생했습니다.');
                    checkbox.checked = false; // 오류 발생 시 체크 해제
                }
            } else {
                // 로그인 상태 유지 해제
                if (!confirm('로그인 상태 유지를 해제하시겠습니까?\n다음 로그인 시 자동 로그인되지 않습니다.')) {
                    checkbox.checked = true; // 취소하면 다시 체크
                    return;
                }

                try {
                    const response = await fetch(contextPath + '/api/auth/disable-auto-login', {
                        method: 'POST'
                    });
                    const result = await response.json();

                    if (result.success) {
                        alert('로그인 상태 유지가 해제되었습니다.');
                    } else {
                        alert(result.message || '로그인 상태 유지 해제에 실패했습니다.');
                        checkbox.checked = true; // 실패하면 다시 체크
                    }
                } catch (error) {
                    console.error('로그인 상태 유지 해제 오류:', error);
                    alert('로그인 상태 유지 해제 중 오류가 발생했습니다.');
                    checkbox.checked = true; // 오류 발생 시 다시 체크
                }
            }
        }

        // 로그인 상태 유지 상태 확인 및 토글 버튼 초기화
        async function loadAutoLoginStatus() {
            try {
                console.log('=== 로그인 상태 유지 확인 시작 ===');
                const response = await fetch(contextPath + '/api/auth/auto-login-status');
                console.log('API 응답 상태:', response.status);

                const result = await response.json();
                console.log('API 응답 데이터:', result);

                if (result.success) {
                    const checkbox = document.getElementById('autoLoginEnabled');
                    if (checkbox) {
                        checkbox.checked = result.enabled;
                        console.log('✅ 로그인 상태 유지 토글 설정:', result.enabled);
                    } else {
                        console.error('❌ autoLoginEnabled 체크박스를 찾을 수 없습니다.');
                    }
                } else {
                    console.warn('⚠️ API 호출 실패:', result.message);
                }
            } catch (error) {
                console.error('❌ 로그인 상태 유지 상태 확인 오류:', error);
            }
        }

        // 보안 설정 저장
        function saveSecuritySettings() {
            const settings = {
                activityHistory: document.getElementById('activityHistoryEnabled').checked
            };
            localStorage.setItem('securitySettings', JSON.stringify(settings));

            // 최근 활동 표시 설정이 변경되면 즉시 반영
            if (!settings.activityHistory) {
                const recentActivityList = document.getElementById('recentActivityList');
                if (recentActivityList) {
                    recentActivityList.innerHTML = '<div class="empty-state"><i class="fas fa-user-shield"></i><p>활동 기록이 비활성화되어 있습니다.</p></div>';
                }
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
                    const activityHistoryEl = document.getElementById('activityHistoryEnabled');

                    if (activityHistoryEl) {
                        activityHistoryEl.checked = settings.activityHistory !== false;
                    }
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

        // 회원 탈퇴 모달 표시
        function showWithdrawModal() {
            const modal = document.getElementById('withdrawModal');
            if (modal) {
                modal.style.display = 'flex';
                document.getElementById('withdrawPassword').value = '';
                document.getElementById('withdrawPassword').focus();
            }
        }

        // 회원 탈퇴 모달 닫기
        function closeWithdrawModal() {
            const modal = document.getElementById('withdrawModal');
            if (modal) {
                modal.style.display = 'none';
                document.getElementById('withdrawPassword').value = '';
            }
        }

        // 회원 탈퇴 처리
        async function processWithdraw() {
            const password = document.getElementById('withdrawPassword').value;

            if (!password) {
                alert('비밀번호를 입력해주세요.');
                return;
            }

            try {
                // 비밀번호 확인 및 탈퇴 처리
                const response = await fetch(contextPath + '/api/member/withdraw', {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/x-www-form-urlencoded',
                    },
                    body: 'password=' + encodeURIComponent(password)
                });

                const result = await response.json();

                if (result.success) {
                    // 현재 사용자 ID 가져오기
                    const userId = currentUserId || '<%= session.getAttribute("id") != null ? session.getAttribute("id") : "" %>';

                    // 사용자별 로컬 스토리지 데이터 삭제
                    if (userId) {
                        // userEvents는 DB 기반이므로 localStorage 삭제 불필요
                        // 최근 활동 로그 삭제
                        localStorage.removeItem('userActivityLog_' + userId);
                        // 프로필 이미지 삭제
                        localStorage.removeItem('profileImage_' + userId);
                        // 알림 설정 삭제 (사용자별로 저장되지 않지만 정리)
                        localStorage.removeItem('notificationSettings');
                        // 보안 설정 삭제
                        localStorage.removeItem('securitySettings');

                        console.log('사용자 데이터 삭제 완료:', userId);
                    }

                    // 세션 스토리지 전체 클리어
                    sessionStorage.clear();

                    alert('회원 탈퇴가 완료되었습니다. 그동안 이용해주셔서 감사합니다.');
                    // 메인 페이지로 이동 (세션은 서버에서 이미 무효화됨)
                    window.location.href = contextPath + '/project.jsp';
                } else {
                    alert(result.message || '회원 탈퇴에 실패했습니다.');
                    document.getElementById('withdrawPassword').value = '';
                    document.getElementById('withdrawPassword').focus();
                }
            } catch (error) {
                console.error('회원 탈퇴 오류:', error);
                alert('회원 탈퇴 처리 중 오류가 발생했습니다.');
            }
        }

        // 알림 설정 불러오기
        async function loadNotificationSettings() {
            console.log('=== 알림 설정 불러오기 시작 ===');
            try {
                const response = await fetch('/bdproject/api/notifications/settings');
                console.log('서버 응답 상태:', response.status);
                const result = await response.json();
                console.log('서버 응답 데이터:', result);

                if (result.success && result.data) {
                    const settings = result.data;
                    // 서버에서 받은 설정값으로 체크박스 설정 (기본값 true)
                    document.getElementById('eventNotification').checked = settings.event_notification !== false;
                    document.getElementById('donationNotification').checked = settings.donation_notification !== false;
                    document.getElementById('volunteerNotification').checked = settings.volunteer_notification !== false;
                    document.getElementById('faqAnswerNotification').checked = settings.faq_answer_notification !== false;
                    console.log('✅ 알림 설정 로드 완료:', settings);
                } else {
                    // 서버에 설정이 없으면 기본값으로 모두 활성화
                    console.warn('⚠️ 서버에 알림 설정이 없습니다. 기본값(모두 활성화)으로 설정합니다.');
                    document.getElementById('eventNotification').checked = true;
                    document.getElementById('donationNotification').checked = true;
                    document.getElementById('volunteerNotification').checked = true;
                    document.getElementById('faqAnswerNotification').checked = true;
                }
            } catch (error) {
                console.error('❌ 알림 설정 불러오기 실패:', error);
                // 오류 발생 시 기본값으로 모두 활성화
                document.getElementById('eventNotification').checked = true;
                document.getElementById('donationNotification').checked = true;
                document.getElementById('volunteerNotification').checked = true;
                document.getElementById('faqAnswerNotification').checked = true;
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

        // 최근 활동 업데이트 (일정, 봉사, 기부 통합)
        async function updateRecentActivity() {
            console.log('=== 최근 활동 업데이트 시작 ===');
            const container = document.getElementById('recentActivityList');
            if (!container) return;

            // 보안 설정 확인
            const securitySettings = JSON.parse(localStorage.getItem('securitySettings') || '{}');
            if (securitySettings.activityHistory === false) {
                container.innerHTML = '<div class="empty-state"><i class="fas fa-user-shield"></i><p>활동 기록이 비활성화되어 있습니다.</p></div>';
                return;
            }

            let html = '';
            const activities = [];

            // 최근 30일 기준
            const today = new Date();
            const thirtyDaysAgo = new Date(today);
            thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

            console.log('데이터 확인:');
            console.log('- volunteerApplications:', window.volunteerApplications?.length || 0);
            console.log('- donationHistory:', window.donationHistory?.length || 0);
            console.log('- userEvents:', Object.keys(window.userEvents || {}).length);
            console.log('- userQuestions:', window.userQuestions?.length || 0);

            // 1. 캘린더 일정 가져오기
            const processedEventIds = new Set();
            const safeUserEvents = window.userEvents || {};
            for (const dateStr in safeUserEvents) {
                const eventDate = new Date(dateStr);
                if (eventDate >= thirtyDaysAgo) {
                    safeUserEvents[dateStr].forEach(event => {
                        if (!processedEventIds.has(event.id)) {
                            processedEventIds.add(event.id);
                            // 최근 활동은 등록한 시간(createdAt) 기준으로 정렬
                            const createdAtDate = event.createdAt ? new Date(event.createdAt) : new Date(event.startDate || dateStr);

                            activities.push({
                                type: 'calendar',
                                icon: 'fa-calendar-check',
                                iconColor: '#4A90E2',
                                title: event.title,
                                description: '<strong>' + formatActivityDate(event.startDate || dateStr) + '</strong>에 일정을 등록하셨습니다.',
                                detail: event.description || '',
                                date: event.startDate || dateStr,
                                endDate: event.endDate,
                                timestamp: createdAtDate.getTime(), // createdAt 기준으로 변경
                                id: event.id,
                                deletable: true,
                                createdAt: event.createdAt // 디버깅용
                            });
                        }
                    });
                }
            }

            // 2. 봉사 활동 가져오기
            if (window.volunteerApplications && window.volunteerApplications.length > 0) {
                window.volunteerApplications.forEach(volunteer => {
                    // createdAt을 우선 사용하여 실제 신청 시간 기준으로 정렬
                    const createdAtDate = new Date(volunteer.createdAt);
                    if (createdAtDate >= thirtyDaysAgo) {
                        const category = volunteer.selectedCategory || '봉사 활동';
                        const displayDate = volunteer.createdAt; // 실제 신청일 표시

                        let statusText = '';
                        let statusColor = '';

                        if (volunteer.status === 'APPROVED' || volunteer.status === 'CONFIRMED') {
                            statusText = '승인됨';
                            statusColor = '#28a745';
                        } else if (volunteer.status === 'PENDING' || volunteer.status === 'APPLIED') {
                            statusText = '검토중';
                            statusColor = '#ffc107';
                        } else if (volunteer.status === 'COMPLETED') {
                            statusText = '완료';
                            statusColor = '#17a2b8';
                        } else if (volunteer.status === 'REJECTED' || volunteer.status === 'CANCELLED') {
                            statusText = '거절됨';
                            statusColor = '#dc3545';
                        }

                        activities.push({
                            type: 'volunteer',
                            icon: 'fa-hands-helping',
                            iconColor: '#28a745',
                            title: category,
                            description: '<strong>' + formatActivityDate(displayDate) + '</strong>에 봉사 활동을 신청하셨습니다.',
                            detail: statusText ? '상태: <span style="color: ' + statusColor + '; font-weight: 600;">' + statusText + '</span>' : '',
                            date: displayDate,
                            timestamp: createdAtDate.getTime(),
                            id: volunteer.applicationId,
                            deletable: false
                        });
                    }
                });
            }

            // 3. 기부 내역 가져오기
            if (window.donationHistory && window.donationHistory.length > 0) {
                console.log('기부 내역 처리 시작, 총 개수:', window.donationHistory.length);
                window.donationHistory.forEach((donation, index) => {
                    console.log('기부 #' + (index + 1) + ':', {
                        createdAt: donation.createdAt,
                        amount: donation.amount,
                        categoryName: donation.categoryName,
                        donationType: donation.donationType
                    });

                    const createdAtDate = new Date(donation.createdAt);
                    if (createdAtDate >= thirtyDaysAgo) {
                        const amount = Number(donation.amount || 0).toLocaleString();

                        // 결제 방법 매핑
                        const paymentMethodMap = {
                            'CREDIT_CARD': '신용카드',
                            'BANK_TRANSFER': '계좌이체',
                            'KAKAO_PAY': '카카오페이',
                            'NAVER_PAY': '네이버페이',
                            'TOSS_PAY': '토스페이'
                        };
                        const method = paymentMethodMap[donation.paymentMethod] || donation.paymentMethod || '기타';

                        // 기부 유형 확인
                        const isRegular = donation.donationType === 'REGULAR';
                        const donationType = isRegular ? '정기 기부' : '일시 기부';

                        // 기부 제목 (패키지명 또는 카테고리명)
                        const title = (donation.packageName && donation.packageName !== 'undefined' && donation.packageName !== 'null')
                            ? donation.packageName
                            : (donation.categoryName || '따뜻한 기부');

                        console.log('기부 활동 추가:', {
                            title: title,
                            amount: amount,
                            timestamp: createdAtDate.getTime(),
                            date: donation.createdAt
                        });

                        activities.push({
                            type: 'donation',
                            icon: 'fa-heart',
                            iconColor: '#e74c3c',
                            title: title,
                            description: '<strong>' + formatActivityDate(donation.createdAt) + '</strong>에 <strong>' + amount + '원</strong>을 기부하셨습니다.',
                            detail: '결제수단: ' + method + ' | ' + donationType,
                            date: donation.createdAt,
                            timestamp: createdAtDate.getTime(),
                            id: donation.donationId,
                            deletable: false
                        });
                    } else {
                        console.log('기부 #' + (index + 1) + ' 30일 이전 데이터로 제외됨');
                    }
                });
            } else {
                console.log('기부 내역 없음');
            }

            // 4. FAQ 질문 내역 가져오기
            if (window.userQuestions && window.userQuestions.length > 0) {
                console.log('FAQ 질문 처리 시작, 총 개수:', window.userQuestions.length);
                window.userQuestions.forEach((question, index) => {
                    const createdAtDate = new Date(question.createdAt);
                    if (createdAtDate >= thirtyDaysAgo) {
                        // 상태에 따른 텍스트와 색상
                        let statusText = '';
                        let statusColor = '';
                        if (question.status === 'answered') {
                            statusText = '답변완료';
                            statusColor = '#28a745';
                        } else if (question.status === 'pending') {
                            statusText = '답변대기';
                            statusColor = '#ffc107';
                        }

                        // 제목 (최대 30자)
                        const title = question.title && question.title.length > 30
                            ? question.title.substring(0, 30) + '...'
                            : (question.title || 'FAQ 질문');

                        activities.push({
                            type: 'faq',
                            icon: 'fa-question-circle',
                            iconColor: '#9b59b6',
                            title: title,
                            description: '<strong>' + formatActivityDate(question.createdAt) + '</strong>에 질문을 등록하셨습니다.',
                            detail: statusText ? '상태: <span style="color: ' + statusColor + '; font-weight: 600;">' + statusText + '</span>' : '',
                            date: question.createdAt,
                            timestamp: createdAtDate.getTime(),
                            id: question.questionId,
                            deletable: false
                        });
                    }
                });
            } else {
                console.log('FAQ 질문 내역 없음');
            }

            // 숨겨진 활동 필터링 (DB 기반)
            let hiddenVolunteerIds = [];
            let hiddenDonationIds = [];

            try {
                // DB에서 숨긴 봉사 활동 목록 가져오기
                const volunteerResponse = await fetch('/bdproject/api/hidden-activities/VOLUNTEER');
                if (volunteerResponse.ok) {
                    const volunteerResult = await volunteerResponse.json();
                    if (volunteerResult.success) {
                        hiddenVolunteerIds = volunteerResult.hiddenIds || [];
                    }
                }

                // DB에서 숨긴 기부 내역 목록 가져오기
                const donationResponse = await fetch('/bdproject/api/hidden-activities/DONATION');
                if (donationResponse.ok) {
                    const donationResult = await donationResponse.json();
                    if (donationResult.success) {
                        hiddenDonationIds = donationResult.hiddenIds || [];
                    }
                }
            } catch (error) {
                console.error('숨긴 활동 목록 조회 오류:', error);
            }

            console.log('숨긴 봉사 활동 IDs:', hiddenVolunteerIds);
            console.log('숨긴 기부 내역 IDs:', hiddenDonationIds);

            // 숨겨지지 않은 활동만 필터링
            const visibleActivities = activities.filter(activity => {
                if (activity.type === 'volunteer') {
                    return !hiddenVolunteerIds.includes(activity.id);
                } else if (activity.type === 'donation') {
                    return !hiddenDonationIds.includes(activity.id);
                }
                return true; // calendar, faq 타입은 항상 표시
            });

            // 날짜순 정렬 (최신순)
            visibleActivities.sort((a, b) => b.timestamp - a.timestamp);

            console.log('전체 활동 수:', activities.length);
            console.log('숨김 처리된 활동 수:', activities.length - visibleActivities.length);
            console.log('표시할 활동 수:', visibleActivities.length);
            console.log('활동 목록 (최신순):', visibleActivities.map(a => ({
                type: a.type,
                title: a.title,
                date: a.date,
                timestamp: a.timestamp
            })));

            // 최근 15개만 표시
            const displayActivities = visibleActivities.slice(0, 15);

            if (displayActivities.length === 0) {
                html = '<div class="empty-state"><i class="fas fa-clock"></i><p>최근 30일간 활동 내역이 없습니다</p><p style="font-size: 14px; color: #999; margin-top: 10px;">일정을 등록하거나 봉사 활동, 기부, FAQ 질문을 진행해보세요!</p></div>';
                container.innerHTML = html;
                return;
            }

            displayActivities.forEach(activity => {
                const dateObj = new Date(activity.date);
                const formattedDate = dateObj.getFullYear() + '.' +
                                    String(dateObj.getMonth() + 1).padStart(2, '0') + '.' +
                                    String(dateObj.getDate()).padStart(2, '0');

                // 날짜 범위 표시 (일정의 경우)
                let dateDisplay = formattedDate;
                if (activity.endDate && activity.endDate !== activity.date) {
                    const endDateObj = new Date(activity.endDate);
                    const endFormatted = endDateObj.getFullYear() + '.' +
                                        String(endDateObj.getMonth() + 1).padStart(2, '0') + '.' +
                                        String(endDateObj.getDate()).padStart(2, '0');
                    dateDisplay = formattedDate + ' ~ ' + endFormatted;
                }

                html += '<div class="list-item" style="border-left: 3px solid ' + activity.iconColor + ';">';
                html += '<div class="list-item-header">';
                html += '<span class="list-item-title">';
                html += '<i class="fas ' + activity.icon + '" style="color: ' + activity.iconColor + '; margin-right: 8px;"></i>';
                html += activity.title;
                html += '</span>';
                html += '<div style="display: flex; align-items: center; gap: 10px;">';
                html += '<span class="list-item-date">' + dateDisplay + '</span>';

                // 모든 활동에 삭제 버튼 표시 (id는 숫자 또는 문자열, type은 문자열)
                const safeId = typeof activity.id === 'string' ? "'" + activity.id + "'" : activity.id;
                html += '<button onclick="deleteRecentActivity(' + safeId + ', \'' + activity.type + '\')" ';
                html += 'style="background: none; border: none; color: #dc3545; cursor: pointer; ';
                html += 'font-size: 18px; padding: 4px 8px; border-radius: 4px; transition: all 0.2s;" ';
                html += 'onmouseenter="this.style.background=\'#fee\'" ';
                html += 'onmouseleave="this.style.background=\'none\'" ';
                html += 'title="삭제">';
                html += '<i class="fas fa-times"></i></button>';

                html += '</div>';
                html += '</div>';
                html += '<div class="list-item-content">';
                html += '<p style="margin: 0 0 5px 0;">' + activity.description + '</p>';
                if (activity.detail) {
                    html += '<p style="margin: 0; color: #666; font-size: 14px;">' + activity.detail + '</p>';
                }
                html += '</div>';
                html += '</div>';
            });

            container.innerHTML = html;
        }

        // 날짜 포맷팅 헬퍼 함수
        function formatActivityDate(dateStr) {
            const date = new Date(dateStr);
            const year = date.getFullYear();
            const month = String(date.getMonth() + 1).padStart(2, '0');
            const day = String(date.getDate()).padStart(2, '0');

            // 항상 실제 날짜를 표시 (YYYY.MM.DD 형식)
            return year + '.' + month + '.' + day;
        }

        // 구버전 호환성을 위해 아래 코드 유지 (삭제 예정)
        function updateRecentActivity_OLD() {
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

        // 최근 활동 삭제 함수 (타입별 처리)
        async function deleteRecentActivity(id, type) {
            console.log('삭제 시도 - ID:', id, ', 타입:', type);

            try {
                if (type === 'calendar') {
                    // 캘린더 일정은 실제 DB에서 삭제
                    const response = await fetch('/bdproject/api/calendar/events/' + id, {
                        method: 'DELETE'
                    });

                    if (response.ok) {
                        const result = await response.json();
                        if (result.success) {
                            console.log('✅ 일정 삭제 성공');
                            // DB에서 일정 다시 불러오기
                            await loadUserEvents();

                            // 캘린더 다시 렌더링
                            if (typeof renderMonthCalendar === 'function') {
                                renderMonthCalendar();
                            }
                        } else {
                            console.error('❌ 일정 삭제 실패:', result.message);
                        }
                    } else {
                        console.error('❌ 서버 오류:', response.status);
                    }
                } else {
                    // 봉사/기부 활동: DB에 숨김 처리
                    const activityType = type === 'volunteer' ? 'VOLUNTEER' : 'DONATION';

                    const formData = new FormData();
                    formData.append('activityType', activityType);
                    formData.append('activityId', id);

                    const response = await fetch('/bdproject/api/hidden-activities', {
                        method: 'POST',
                        body: formData
                    });

                    if (response.ok) {
                        const result = await response.json();
                        if (result.success) {
                            console.log('✅ 활동 숨김 처리 완료 (DB):', activityType, id);
                        } else {
                            console.error('❌ 숨김 처리 실패:', result.message);
                        }
                    } else {
                        console.error('❌ 서버 오류:', response.status);
                    }
                }

                // 최근 활동 목록 업데이트
                updateRecentActivity();

            } catch (error) {
                console.error('❌ 삭제 오류:', error);
            }
        }

        // 모든 최근 활동 삭제/숨김 함수
        async function deleteAllRecentActivities() {
            if (!confirm('모든 최근 활동 내역을 삭제하시겠습니까?')) {
                return;
            }

            try {
                let deletedCount = 0;

                // 1. 캘린더 일정 모두 삭제
                const response = await fetch('/bdproject/api/calendar/events/all', {
                    method: 'DELETE'
                });

                if (response.ok) {
                    const result = await response.json();
                    if (result.success) {
                        console.log('캘린더 일정 전체 삭제 성공');
                        deletedCount++;

                        // DB에서 일정 다시 불러오기
                        await loadUserEvents();

                        // 캘린더 다시 렌더링
                        if (typeof renderMonthCalendar === 'function') {
                            renderMonthCalendar();
                        }
                    }
                }

                // 2. 봉사 활동과 기부 내역 숨김 처리 (DB에 일괄 등록)
                let hiddenCount = 0;

                // 현재 표시된 모든 봉사 활동 숨김 처리
                if (window.volunteerApplications && window.volunteerApplications.length > 0) {
                    for (const volunteer of window.volunteerApplications) {
                        const formData = new FormData();
                        formData.append('activityType', 'VOLUNTEER');
                        formData.append('activityId', volunteer.applicationId);

                        const response = await fetch('/bdproject/api/hidden-activities', {
                            method: 'POST',
                            body: formData
                        });

                        if (response.ok) {
                            const result = await response.json();
                            if (result.success) {
                                hiddenCount++;
                            }
                        }
                    }
                }

                // 현재 표시된 모든 기부 내역 숨김 처리
                if (window.donationHistory && window.donationHistory.length > 0) {
                    for (const donation of window.donationHistory) {
                        const formData = new FormData();
                        formData.append('activityType', 'DONATION');
                        formData.append('activityId', donation.donationId);

                        const response = await fetch('/bdproject/api/hidden-activities', {
                            method: 'POST',
                            body: formData
                        });

                        if (response.ok) {
                            const result = await response.json();
                            if (result.success) {
                                hiddenCount++;
                            }
                        }
                    }
                }

                console.log('봉사/기부 활동 숨김 처리 완료 (DB):', hiddenCount, '개');

                // UI 업데이트
                updateRecentActivity();

                alert('모든 최근 활동이 정리되었습니다.');

            } catch (error) {
                console.error('최근 활동 전체 삭제 오류:', error);
                alert('최근 활동 삭제 중 오류가 발생했습니다.');
            }
        }

        // 일정 리마인더 체크 (당일 및 하루 전 알림)
        function checkEventReminders() {
            console.log('=== 일정 리마인더 체크 시작 ===');
            const today = new Date();
            today.setHours(0, 0, 0, 0);
            const tomorrow = new Date(today);
            tomorrow.setDate(tomorrow.getDate() + 1);

            // 로컬 타임존을 사용하여 날짜 문자열 생성
            const formatDate = (date) => {
                const year = date.getFullYear();
                const month = String(date.getMonth() + 1).padStart(2, '0');
                const day = String(date.getDate()).padStart(2, '0');
                return `${year}-${month}-${day}`;
            };

            const todayStr = formatDate(today);
            const tomorrowStr = formatDate(tomorrow);

            console.log('오늘:', today.toLocaleDateString('ko-KR'), '(' + todayStr + ')');
            console.log('내일:', tomorrow.toLocaleDateString('ko-KR'), '(' + tomorrowStr + ')');
            console.log('userEvents 객체 타입:', typeof userEvents);
            console.log('userEvents 키 개수:', Object.keys(userEvents).length);
            console.log('전체 일정 날짜 키:', Object.keys(userEvents));
            console.log('전체 일정 객체:', userEvents);

            // 오늘 일정 체크
            if (userEvents[todayStr] && userEvents[todayStr].length > 0) {
                console.log('✅ 오늘 일정 발견:', userEvents[todayStr]);
                userEvents[todayStr].forEach((event, index) => {
                    console.log('--- 오늘 일정 #' + (index + 1) + ' ---');
                    console.log('제목:', event.title);
                    console.log('ID:', event.id);
                    console.log('전체 이벤트 객체:', event);

                    // 리마인더 키 생성 (고유 키)
                    const reminderKey = 'event_reminder_' + event.id + '_' + todayStr;
                    console.log('리마인더 키:', reminderKey);

                    const alreadySent = localStorage.getItem(reminderKey);
                    console.log('이미 전송 여부:', alreadySent);

                    // 알림이 아직 전송되지 않았으면 생성
                    if (!alreadySent) {
                        console.log('🔔 오늘 일정 알림 생성:', event.title);
                        createNotification({
                            type: 'schedule',
                            title: '오늘 일정이 있습니다!',
                            message: event.title + ' 일정이 오늘 예정되어 있습니다.',
                            relatedUrl: '/bdproject/project_mypage.jsp'
                        });

                        // 알림 생성 완료 표시
                        localStorage.setItem(reminderKey, 'sent');
                    } else {
                        console.log('⏭️ 이미 알림 생성됨:', event.title);
                    }
                });
            }

            // 내일 날짜 키가 userEvents에 있는지 확인
            const hasKey = tomorrowStr in userEvents;
            console.log('내일 날짜 키 존재 여부:', hasKey);

            if (hasKey) {
                console.log('내일 날짜 데이터:', userEvents[tomorrowStr]);
                console.log('내일 일정 개수:', userEvents[tomorrowStr].length);
            }

            // 내일 일정이 있는지 체크
            if (userEvents[tomorrowStr] && userEvents[tomorrowStr].length > 0) {
                console.log('✅ 내일 일정 발견:', userEvents[tomorrowStr]);
                userEvents[tomorrowStr].forEach((event, index) => {
                    console.log('--- 일정 #' + (index + 1) + ' ---');
                    console.log('제목:', event.title);
                    console.log('ID:', event.id);
                    console.log('전체 이벤트 객체:', event);

                    // 이미 알림을 생성했는지 체크 (localStorage 사용)
                    const reminderKey = 'event_reminder_' + event.id + '_' + tomorrowStr;
                    console.log('리마인더 키:', reminderKey);
                    const alreadySent = localStorage.getItem(reminderKey);
                    console.log('이미 전송 여부:', alreadySent);

                    if (!alreadySent) {
                        console.log('🔔 새 알림 생성 시도:', event.title);
                        // 로컬 알림 생성 (localStorage 기반)
                        createLocalNotification({
                            type: 'schedule',
                            title: '내일 일정이 있습니다!',
                            message: event.title + ' 일정이 내일 예정되어 있습니다.',
                            relatedUrl: '#calendar'
                        });

                        // 알림 생성 완료 표시
                        localStorage.setItem(reminderKey, 'sent');
                        console.log('✅ 알림 생성 완료 및 localStorage에 저장');
                    } else {
                        console.log('⏭️ 이미 알림 생성됨:', event.title);
                    }
                });
            } else {
                console.log('❌ 내일 일정 없음');
                console.log('디버깅: 모든 일정 날짜 키 확인');
                Object.keys(userEvents).forEach(key => {
                    console.log('  - ' + key + ': ' + userEvents[key].length + '개 일정');
                });
            }
        }

        // 봉사 활동 리마인더 체크 (하루 전 알림)
        function checkVolunteerReminders() {
            fetch('/bdproject/api/volunteer/my-applications')
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.data) {
                        const today = new Date();
                        today.setHours(0, 0, 0, 0);
                        const tomorrow = new Date(today);
                        tomorrow.setDate(tomorrow.getDate() + 1);

                        data.data.forEach(app => {
                            if (app.volunteerDate) {
                                const volunteerDate = new Date(app.volunteerDate);
                                volunteerDate.setHours(0, 0, 0, 0);

                                // 봉사 시작일이 내일인 경우
                                if (volunteerDate.getTime() === tomorrow.getTime()) {
                                    const reminderKey = 'volunteer_reminder_' + app.applicationId;
                                    if (!localStorage.getItem(reminderKey)) {
                                        createNotification({
                                            type: 'volunteer',
                                            title: '내일 봉사 활동이 있습니다!',
                                            message: app.selectedCategory + ' 봉사 활동이 내일 예정되어 있습니다.',
                                            relatedUrl: '#volunteer'
                                        });

                                        localStorage.setItem(reminderKey, 'sent');
                                    }
                                }
                            }
                        });
                    }
                })
                .catch(error => {
                    console.error('봉사 활동 리마인더 체크 오류:', error);
                });
        }

        // 로컬 알림 생성 함수 (localStorage 기반)
        function createLocalNotification(notificationData) {
            // localStorage에서 기존 알림 가져오기
            let notifications = JSON.parse(localStorage.getItem('localNotifications') || '[]');

            // 새 알림 추가
            const newNotification = {
                notification_id: 'local_' + Date.now(),
                type: notificationData.type,
                title: notificationData.title,
                message: notificationData.message,
                related_url: notificationData.relatedUrl || '#',
                is_read: false,
                created_at: new Date().toISOString()
            };

            notifications.unshift(newNotification);

            // localStorage에 저장
            localStorage.setItem('localNotifications', JSON.stringify(notifications));

            console.log('로컬 알림 생성:', newNotification);

            // 알림 목록 새로고침 (자동 생성 건너뜀)
            loadNotifications(true);
        }

        // 알림 생성 함수 (서버 API - 폴백)
        function createNotification(notificationData) {
            // 먼저 로컬 알림 생성
            createLocalNotification(notificationData);

            // 서버 API도 시도 (선택적)
            fetch('/bdproject/api/notifications/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/json'
                },
                body: JSON.stringify(notificationData)
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    console.log('서버 알림 생성 성공:', notificationData.title);
                }
            })
            .catch(error => {
                console.log('서버 알림 생성 실패 (로컬 알림 사용):', error);
            });
        }

        // FAQ 답변 체크 함수
        function checkFaqAnswers() {
            fetch('/bdproject/api/questions/my-questions')
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.data) {
                        data.data.forEach(question => {
                            // 답변이 있고, 아직 알림을 생성하지 않은 경우
                            if (question.answer && question.answer.trim() !== '') {
                                const notificationKey = 'faq_answer_notified_' + question.questionId;
                                if (!localStorage.getItem(notificationKey)) {
                                    // FAQ 답변 알림 생성
                                    createNotification({
                                        type: 'faq_answer',
                                        title: 'FAQ 질문에 답변이 달렸습니다!',
                                        message: '회원님의 질문 "' + question.title + '"에 관리자가 답변했습니다.',
                                        relatedUrl: '/bdproject/project_faq.jsp?questionId=' + question.questionId
                                    });

                                    // 알림 생성 완료 표시
                                    localStorage.setItem(notificationKey, 'sent');
                                }
                            }
                        });
                    }
                })
                .catch(error => {
                    console.error('FAQ 답변 체크 오류:', error);
                });
        }

        // 페이지 초기화 시 알림 설정 불러오기
        document.addEventListener('DOMContentLoaded', async function() {
            console.log('=== 마이페이지 초기화 시작 ===');

            // 설정 및 상태 로드
            loadNotificationSettings();
            loadSecuritySettings();
            loadAutoLoginStatus(); // 로그인 상태 유지 확인
            loadKindnessTemperature(); // 선행 온도 로드
            loadNotifications();

            // 데이터 로드 (순차적으로)
            console.log('일정 데이터 로드 시작...');
            await loadUserEvents(); // 캘린더 일정 로드

            console.log('봉사 활동 데이터 로드 시작...');
            await loadVolunteerApplications(); // 봉사 활동 로드

            console.log('기부 데이터 로드 시작...');
            await loadDonations(); // 기부 내역 로드

            console.log('FAQ 질문 데이터 로드 시작...');
            await loadMyQuestions(); // FAQ 질문 로드

            console.log('모든 데이터 로드 완료');
            console.log('- window.userEvents:', Object.keys(window.userEvents || {}).length, '개 날짜');
            console.log('- window.volunteerApplications:', window.volunteerApplications?.length || 0, '개');
            console.log('- window.donationHistory:', window.donationHistory?.length || 0, '개');
            console.log('- window.userQuestions:', window.userQuestions?.length || 0, '개');

            // 모든 데이터 로드 후 최근 활동 업데이트
            updateRecentActivity();

            // 리마인더 체크 (일정 및 봉사 활동)
            checkEventReminders();
            checkVolunteerReminders();
            checkFaqAnswers(); // FAQ 답변 체크

            // 정기적으로 리마인더 체크
            setInterval(() => {
                checkEventReminders();
                checkVolunteerReminders();
            }, 24 * 60 * 60 * 1000); // 24시간마다

            // FAQ 답변은 더 자주 체크 (1시간마다)
            setInterval(() => {
                checkFaqAnswers();
            }, 60 * 60 * 1000);

            // URL 파라미터로 질문 상세 보기 요청이 있는지 확인
            const urlParams = new URLSearchParams(window.location.search);
            const viewQuestionId = urlParams.get('viewQuestion');
            if (viewQuestionId) {
                console.log('URL에서 질문 상세 보기 요청 감지 - questionId:', viewQuestionId);
                // 약간의 지연 후 모달 열기 (데이터 로드 완료 대기)
                setTimeout(() => {
                    openFaqDetailModal(viewQuestionId);
                }, 500);
            }
        });

        // === FAQ 질문/답변 상세 모달 ===
        function openFaqDetailModal(questionId) {
            console.log('FAQ 상세 모달 열기 - questionId:', questionId);
            const modal = document.getElementById('faqDetailModal');
            const content = document.getElementById('faqDetailContent');

            modal.style.display = 'flex';

            // 로딩 표시
            content.innerHTML = '<div style="text-align: center; padding: 40px;"><i class="fas fa-spinner fa-spin fa-2x"></i><p>로딩 중...</p></div>';

            // 질문 상세 정보 가져오기
            fetch('/bdproject/api/questions/' + questionId)
                .then(response => response.json())
                .then(result => {
                    if (result.success && result.data) {
                        const question = result.data;
                        const createdAt = new Date(question.createdAt).toLocaleDateString('ko-KR', {
                            year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit'
                        });
                        const answeredAt = question.answeredAt ? new Date(question.answeredAt).toLocaleDateString('ko-KR', {
                            year: 'numeric', month: 'long', day: 'numeric', hour: '2-digit', minute: '2-digit'
                        }) : null;

                        let statusBadge = '';
                        if (question.status === 'answered') {
                            statusBadge = '<span style="background: #28a745; color: white; padding: 4px 10px; border-radius: 12px; font-size: 12px;">답변완료</span>';
                        } else {
                            statusBadge = '<span style="background: #ffc107; color: #333; padding: 4px 10px; border-radius: 12px; font-size: 12px;">답변대기</span>';
                        }

                        let html = '<div style="margin-bottom: 20px;">';
                        html += '<div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px;">';
                        html += '<h4 style="margin: 0; color: #333;">' + (question.title || '제목 없음') + '</h4>';
                        html += statusBadge;
                        html += '</div>';
                        html += '<div style="font-size: 13px; color: #888; margin-bottom: 15px;">';
                        html += '<i class="fas fa-clock"></i> ' + createdAt;
                        html += '</div>';

                        // 질문 내용
                        html += '<div style="background: #f8f9fa; padding: 15px; border-radius: 8px; margin-bottom: 20px; border-left: 4px solid #9b59b6;">';
                        html += '<div style="font-size: 13px; color: #9b59b6; margin-bottom: 8px; font-weight: 600;"><i class="fas fa-user"></i> 내 질문</div>';
                        html += '<div style="color: #333; line-height: 1.6; white-space: pre-wrap;">' + (question.content || '내용 없음') + '</div>';
                        html += '</div>';

                        // 답변 내용
                        if (question.answer) {
                            html += '<div style="background: #e8f5e9; padding: 15px; border-radius: 8px; border-left: 4px solid #28a745;">';
                            html += '<div style="font-size: 13px; color: #28a745; margin-bottom: 8px; font-weight: 600;"><i class="fas fa-user-shield"></i> 관리자 답변</div>';
                            if (answeredAt) {
                                html += '<div style="font-size: 12px; color: #888; margin-bottom: 10px;"><i class="fas fa-clock"></i> ' + answeredAt + '</div>';
                            }
                            html += '<div style="color: #333; line-height: 1.6; white-space: pre-wrap;">' + question.answer + '</div>';
                            html += '</div>';
                        } else {
                            html += '<div style="background: #fff3cd; padding: 15px; border-radius: 8px; text-align: center; color: #856404;">';
                            html += '<i class="fas fa-hourglass-half"></i> 아직 답변이 등록되지 않았습니다.';
                            html += '</div>';
                        }

                        html += '</div>';
                        content.innerHTML = html;
                    } else {
                        content.innerHTML = '<div style="text-align: center; padding: 40px; color: #dc3545;"><i class="fas fa-exclamation-circle fa-2x"></i><p>질문을 찾을 수 없습니다.</p></div>';
                    }
                })
                .catch(error => {
                    console.error('질문 상세 조회 오류:', error);
                    content.innerHTML = '<div style="text-align: center; padding: 40px; color: #dc3545;"><i class="fas fa-exclamation-circle fa-2x"></i><p>질문을 불러오는 중 오류가 발생했습니다.</p></div>';
                });
        }

        function closeFaqDetailModal() {
            document.getElementById('faqDetailModal').style.display = 'none';
            // URL 파라미터 제거
            const url = new URL(window.location);
            url.searchParams.delete('viewQuestion');
            window.history.replaceState({}, '', url);
        }

        // === 봉사 후기 작성 모달 ===
        let currentApplicationId = null;
        let currentActivityName = '';

        // 프로필 이미지 업로드 함수
        function uploadProfileImage(file) {

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
                    const imageUrl = contextPath + data.imageUrl;

                    // localStorage에 프로필 이미지 URL 저장 (영구 보존)
                    const userId = '<%= session.getAttribute("id") %>';
                    if (userId) {
                        localStorage.setItem('profileImage_' + userId, imageUrl);
                    }

                    // 이미지 미리보기
                    const img = document.createElement('img');
                    img.src = imageUrl;
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
            const userId = '<%= session.getAttribute("id") %>';

            // 먼저 localStorage에서 이미지 확인
            const cachedImage = localStorage.getItem('profileImage_' + userId);
            if (cachedImage) {
                const avatar = document.getElementById('userAvatar');
                const initial = document.getElementById('avatarInitial');
                const uploadBtn = avatar.querySelector('.avatar-upload-btn');

                // 이미지 생성
                const img = document.createElement('img');
                img.src = cachedImage;
                img.alt = 'Profile';

                // 이니셜 숨기기
                if (initial) {
                    initial.style.display = 'none';
                }

                // 기존 이미지 제거
                const existingImg = avatar.querySelector('img');
                if (existingImg) {
                    existingImg.remove();
                }

                // 이미지 추가
                avatar.insertBefore(img, uploadBtn);
            }

            // 서버에서도 이미지 로드 시도 (서버와 동기화)
            fetch(contextPath + '/api/profile/image')
            .then(response => response.json())
            .then(data => {
                if (data.success && data.imageUrl) {
                    const imageUrl = contextPath + data.imageUrl;

                    // localStorage 업데이트
                    if (userId) {
                        localStorage.setItem('profileImage_' + userId, imageUrl);
                    }

                    const avatar = document.getElementById('userAvatar');
                    const initial = document.getElementById('avatarInitial');
                    const uploadBtn = avatar.querySelector('.avatar-upload-btn');

                    // 이미지 생성
                    const img = document.createElement('img');
                    img.src = imageUrl;
                    img.alt = 'Profile';

                    // 이니셜 숨기기
                    if (initial) {
                        initial.style.display = 'none';
                    }

                    // 기존 이미지 제거
                    const existingImg = avatar.querySelector('img');
                    if (existingImg) {
                        existingImg.remove();
                    }

                    // 이미지 추가
                    avatar.insertBefore(img, uploadBtn);
                }
            })
            .catch(error => {
                console.error('프로필 이미지 로드 오류:', error);
                // 서버 오류 시 localStorage의 이미지 사용
            });
        }

        // 봉사 활동 상세 정보 표시
        function showVolunteerDetail(applicationId) {
            fetch('/bdproject/api/volunteer/my-applications')
                .then(response => response.json())
                .then(data => {
                    if (data.success && data.data) {
                        const app = data.data.find(a => a.applicationId === applicationId);
                        if (app) {
                            const modal = document.getElementById('volunteerDetailModal');
                            const timeText = formatVolunteerTime(app.volunteerTime);
                            const experienceText = formatVolunteerExperience(app.volunteerExperience);
                            const statusText = getStatusText(app.status);

                            let dateStr = new Date(app.volunteerDate).toLocaleDateString('ko-KR');
                            if (app.volunteerEndDate) {
                                const endDateStr = new Date(app.volunteerEndDate).toLocaleDateString('ko-KR');
                                dateStr += ' ~ ' + endDateStr;
                            }

                            // 안전한 값 체크 함수
                            const safeValue = (value) => (value && value !== 'false' && value !== 'undefined') ? value : '-';

                            let detailHtml = '<h3 style="color: #2c3e50; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">' +
                                '<i class="fas fa-hands-helping" style="color: #4A90E2;"></i> ' + (app.selectedCategory || '봉사 활동') +
                                '</h3>' +
                                '<div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px;">' +
                                    '<div style="display: grid; grid-template-columns: 120px 1fr; gap: 15px; font-size: 15px;">' +
                                        '<div style="font-weight: 600; color: #555;">신청자</div>' +
                                        '<div>' + safeValue(app.applicantName) + '</div>' +
                                        '<div style="font-weight: 600; color: #555;">이메일</div>' +
                                        '<div>' + safeValue(app.applicantEmail) + '</div>' +
                                        '<div style="font-weight: 600; color: #555;">연락처</div>' +
                                        '<div>' + safeValue(app.applicantPhone) + '</div>' +
                                        '<div style="font-weight: 600; color: #555;">봉사 기간</div>' +
                                        '<div>' + (dateStr || '-') + '</div>' +
                                        '<div style="font-weight: 600; color: #555;">시간대</div>' +
                                        '<div>' + (timeText || '-') + '</div>' +
                                        '<div style="font-weight: 600; color: #555;">경험 수준</div>' +
                                        '<div>' + (experienceText || '-') + '</div>' +
                                        '<div style="font-weight: 600; color: #555;">주소</div>' +
                                        '<div>' + safeValue(app.applicantAddress) + '</div>' +
                                        '<div style="font-weight: 600; color: #555;">상태</div>' +
                                        '<div><span style="background: #4A90E2; color: white; padding: 4px 12px; border-radius: 12px; font-size: 13px;">' + statusText + '</span></div>';

                            if (app.actualHours && app.actualHours > 0) {
                                detailHtml += '<div style="font-weight: 600; color: #555;">활동 시간</div>' +
                                    '<div>' + app.actualHours + '시간</div>';
                            }

                            detailHtml += '</div></div>';

                            // 배정된 시설 정보 표시 (승인 또는 완료된 경우)
                            if (app.assignedFacilityName && (app.status === 'CONFIRMED' || app.status === 'COMPLETED')) {
                                detailHtml += '<div style="background: #e8f5e9; padding: 20px; border-radius: 8px; margin-bottom: 20px; border-left: 4px solid #4caf50;">' +
                                    '<div style="font-weight: 600; color: #2e7d32; margin-bottom: 12px; font-size: 16px;">' +
                                        '<i class="fas fa-building" style="margin-right: 8px;"></i>배정된 봉사 시설' +
                                    '</div>' +
                                    '<div style="display: grid; grid-template-columns: 80px 1fr; gap: 10px; font-size: 14px;">' +
                                        '<div style="font-weight: 600; color: #555;">시설명</div>' +
                                        '<div style="color: #333;">' + app.assignedFacilityName + '</div>' +
                                        '<div style="font-weight: 600; color: #555;">주소</div>' +
                                        '<div style="color: #333;">' + (app.assignedFacilityAddress || '-') + '</div>' +
                                    '</div>' +
                                    (app.adminNote ? '<div style="margin-top: 12px; padding-top: 12px; border-top: 1px solid #c8e6c9;"><span style="font-weight: 600; color: #555;">관리자 메모:</span> ' + app.adminNote + '</div>' : '') +
                                '</div>';
                            }

                            if (app.motivation && app.motivation !== 'false' && app.motivation.trim() !== '') {
                                detailHtml += '<div style="background: #e8f4fd; padding: 15px; border-radius: 8px; border-left: 4px solid #4A90E2;">' +
                                    '<div style="font-weight: 600; color: #4A90E2; margin-bottom: 8px;">신청 동기</div>' +
                                    '<div style="color: #555; line-height: 1.6;">' + app.motivation + '</div>' +
                                '</div>';
                            }

                            document.getElementById('volunteerDetailContent').innerHTML = detailHtml;
                            modal.style.display = 'flex';
                        }
                    }
                })
                .catch(error => {
                    console.error('봉사 상세 정보 로드 오류:', error);
                    alert('상세 정보를 불러올 수 없습니다.');
                });
        }

        function closeVolunteerDetailModal() {
            document.getElementById('volunteerDetailModal').style.display = 'none';
        }

        // === 기부 환불 기능 ===
        // 환불 가능 여부 확인 (7일 이내)
        function canRefund(createdAt) {
            const createdDate = new Date(createdAt);
            const now = new Date();
            const daysDiff = Math.floor((now - createdDate) / (1000 * 60 * 60 * 24));
            return daysDiff <= 7;
        }

        // 환불 요청
        function requestRefund(donationId, amount, createdAt) {
            const createdDate = new Date(createdAt);
            const now = new Date();
            const hoursDiff = Math.floor((now - createdDate) / (1000 * 60 * 60));

            let refundAmount = amount;
            let feePercent = 0;
            let message = '';

            if (hoursDiff >= 24) {
                // 하루 이상 지났으면 10% 수수료
                feePercent = 10;
                refundAmount = Math.floor(amount * 0.9);
                message = '기부 후 24시간이 지나 10% 수수료가 부과됩니다.\n\n' +
                          '기부금액: ' + amount.toLocaleString() + '원\n' +
                          '수수료 (10%): ' + Math.floor(amount * 0.1).toLocaleString() + '원\n' +
                          '환불금액: ' + refundAmount.toLocaleString() + '원\n\n' +
                          '환불을 진행하시겠습니까?';
            } else {
                message = '기부금액 ' + amount.toLocaleString() + '원 전액이 환불됩니다.\n\n환불을 진행하시겠습니까?';
            }

            if (!confirm(message)) {
                return;
            }

            fetch('/bdproject/api/donation/refund', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'donationId=' + donationId + '&feePercent=' + feePercent
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('환불이 완료되었습니다.\n환불금액: ' + data.refundAmount.toLocaleString() + '원');
                    loadDonations(); // 목록 새로고침
                } else {
                    alert(data.message || '환불 처리에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('환불 처리 오류:', error);
                alert('환불 처리 중 오류가 발생했습니다.');
            });
        }

        // === 기부 리뷰 작성 모달 ===
        let currentDonationForReview = null;

        function openDonationReviewModal(donationId, title, amount) {
            currentDonationForReview = { donationId, title, amount };

            const modal = document.getElementById('donationReviewModal');
            document.getElementById('reviewDonationTitle').textContent = title;
            document.getElementById('reviewDonationAmount').textContent = amount.toLocaleString() + '원';
            document.getElementById('donationReviewContent').value = '';
            document.getElementById('donationReviewRating').value = '5';
            document.getElementById('donationReviewAnonymous').checked = false;

            modal.style.display = 'flex';
        }

        function closeDonationReviewModal() {
            document.getElementById('donationReviewModal').style.display = 'none';
            currentDonationForReview = null;
        }

        function submitDonationReview() {
            if (!currentDonationForReview) return;

            const title = document.getElementById('donationReviewTitleInput').value.trim();
            const content = document.getElementById('donationReviewContent').value.trim();
            const rating = document.getElementById('donationReviewRating').value;

            if (!title) {
                alert('리뷰 제목을 입력해주세요.');
                return;
            }

            if (!content) {
                alert('리뷰 내용을 입력해주세요.');
                return;
            }

            if (content.length < 10) {
                alert('리뷰는 10자 이상 작성해주세요.');
                return;
            }

            fetch('/bdproject/api/donation-review/create', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'donationId=' + currentDonationForReview.donationId +
                      '&title=' + encodeURIComponent(title) +
                      '&content=' + encodeURIComponent(content) +
                      '&rating=' + rating
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert('리뷰가 등록되었습니다. 감사합니다!');
                    closeDonationReviewModal();
                    loadDonations(); // 목록 새로고침
                } else {
                    alert(data.message || '리뷰 등록에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('리뷰 등록 오류:', error);
                alert('리뷰 등록 중 오류가 발생했습니다.');
            });
        }

        // === 봉사활동 취소 기능 ===
        function cancelVolunteerApplication(applicationId, volunteerDate, volunteerTime) {
            const volDate = new Date(volunteerDate);
            const now = new Date();

            // 시간대별 시작 시간 설정
            const timeStartMap = {
                '오전': 9, 'AM': 9, 'MORNING': 9,
                '오후': 13, 'PM': 13, 'AFTERNOON': 13,
                '저녁': 18, 'EVENING': 18,
                '종일': 9, 'ALLDAY': 9,
                '조율가능': 9, 'FLEXIBLE': 9
            };

            const startHour = timeStartMap[volunteerTime] || 9;
            volDate.setHours(startHour, 0, 0, 0);

            // 봉사 시작까지 남은 시간 계산
            const hoursDiff = Math.floor((volDate - now) / (1000 * 60 * 60));

            let message = '';
            let willBeBanned = false;

            if (hoursDiff < 24) {
                // 24시간 이내 취소 - 1주일 제한
                willBeBanned = true;
                message = '⚠️ 경고: 봉사 예정 시간까지 24시간 미만 남았습니다.\n\n' +
                          '이 시점에서 취소하시면 1주일간 봉사 신청이 제한됩니다.\n\n' +
                          '정말 취소하시겠습니까?';
            } else {
                message = '봉사 신청을 취소하시겠습니까?';
            }

            if (!confirm(message)) {
                return;
            }

            fetch('/bdproject/api/volunteer/cancel', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: 'applicationId=' + applicationId + '&applyBan=' + willBeBanned
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    if (willBeBanned) {
                        alert('봉사 신청이 취소되었습니다.\n\n' + data.banUntil + '까지 봉사 신청이 제한됩니다.');
                    } else {
                        alert('봉사 신청이 취소되었습니다.');
                    }
                    loadVolunteerApplications(); // 목록 새로고침
                } else {
                    alert(data.message || '취소 처리에 실패했습니다.');
                }
            })
            .catch(error => {
                console.error('취소 처리 오류:', error);
                alert('취소 처리 중 오류가 발생했습니다.');
            });
        }

        // 알림에서 봉사활동 상세 모달 열기 (applicationId로 직접 호출)
        function openVolunteerDetailModal(applicationId) {
            console.log('봉사활동 상세 모달 열기 - applicationId:', applicationId);
            showVolunteerDetail(parseInt(applicationId));
        }

        // 기부 상세 정보 표시
        function showDonationDetail(donationId) {
            fetch('/bdproject/api/donation/my')
                .then(response => response.json())
                .then(data => {
                    console.log('=== 기부 상세 모달 요청 ===');
                    console.log('요청 ID:', donationId);
                    console.log('응답 데이터:', data);

                    if (data.success && data.data) {
                        const donation = data.data.find(d => d.donationId === donationId);
                        if (donation) {
                            console.log('=== 선택된 기부 상세 분석 ===');
                            console.log('전체 기부 객체:', donation);
                            console.log('모든 필드:', Object.keys(donation));
                            console.log('기부 유형:', donation.donationType);
                            console.log('결제 방법:', donation.paymentMethod);
                            console.log('서명 관련 필드:', {
                                signature: donation.signature,
                                signatureImageUrl: donation.signatureImageUrl,
                                signatureImage: donation.signatureImage,
                                donorSignature: donation.donorSignature,
                                donorName: donation.donorName
                            });

                            const modal = document.getElementById('donationDetailModal');

                            // 기부 유형 매핑 (DB 실제 값: REGULAR, ONETIME)
                            const donationTypeMap = {
                                'REGULAR': '정기 후원',
                                'ONETIME': '일시 후원'
                            };
                            const typeText = donationTypeMap[donation.donationType] || '일시 후원';
                            console.log('변환된 기부 유형:', typeText);

                            const dateStr = new Date(donation.createdAt).toLocaleString('ko-KR');
                            const titleText = (donation.packageName && donation.packageName !== 'undefined' && donation.packageName !== 'false' && donation.packageName !== 'null')
                                ? donation.packageName
                                : (donation.categoryName || donation.category || '일반 기부');

                            // 결제 방법 매핑 (DB 실제 값: CREDIT_CARD, BANK_TRANSFER, KAKAO_PAY, NAVER_PAY, TOSS_PAY)
                            const paymentMethodMap = {
                                'CREDIT_CARD': '신용카드',
                                'BANK_TRANSFER': '계좌이체',
                                'KAKAO_PAY': '카카오페이',
                                'NAVER_PAY': '네이버페이',
                                'TOSS_PAY': '토스페이'
                            };
                            const paymentMethodText = paymentMethodMap[donation.paymentMethod] || donation.paymentMethod || '-';
                            console.log('변환된 결제 방법:', paymentMethodText);

                            let detailHtml = '<h3 style="color: #2c3e50; margin-bottom: 20px; display: flex; align-items: center; gap: 10px;">' +
                                '<i class="fas fa-heart" style="color: #e74c3c;"></i> ' + titleText +
                                '</h3>' +
                                '<div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px;">' +
                                    '<div style="display: grid; grid-template-columns: 120px 1fr; gap: 15px; font-size: 15px;">' +
                                        '<div style="font-weight: 600; color: #555;">기부 유형</div>' +
                                        '<div>' + typeText + '</div>';

                            if (donation.category && donation.category !== 'false') {
                                detailHtml += '<div style="font-weight: 600; color: #555;">카테고리</div>' +
                                    '<div>' + donation.category + '</div>';
                            }

                            detailHtml += '<div style="font-weight: 600; color: #555;">기부 금액</div>' +
                                '<div style="font-size: 20px; font-weight: 700; color: #e74c3c;">' + (donation.amount || 0).toLocaleString() + '원</div>' +
                                '<div style="font-weight: 600; color: #555;">기부 일시</div>' +
                                '<div>' + (dateStr || '-') + '</div>';

                            if (donation.paymentMethod && donation.paymentMethod !== 'false') {
                                detailHtml += '<div style="font-weight: 600; color: #555;">결제 방법</div>' +
                                    '<div>' + paymentMethodText + '</div>';
                            }

                            // 정기 기부 시작일 표시
                            if (donation.regularStartDate && donation.donationType === 'REGULAR') {
                                const regularStartDateStr = new Date(donation.regularStartDate).toLocaleDateString('ko-KR');
                                detailHtml += '<div style="font-weight: 600; color: #555;">정기 기부 시작일</div>' +
                                    '<div style="color: #f39c12; font-weight: 600;"><i class="fas fa-calendar-check"></i> ' + regularStartDateStr + '</div>';
                            }

                            // 기부 분야 표시
                            if (donation.categoryName) {
                                detailHtml += '<div style="font-weight: 600; color: #555;">기부 분야</div>' +
                                    '<div><i class="fas fa-tag" style="color: #1abc9c;"></i> ' + donation.categoryName + '</div>';
                            }

                            // 서명 이미지 표시 (DB 필드: signature_image)
                            const signatureImage = donation.signatureImage;
                            console.log('서명 이미지 데이터:', signatureImage ? signatureImage.substring(0, 50) + '...' : 'null');

                            // 서명 이미지가 있는 경우에만 표시
                            if (signatureImage &&
                                signatureImage !== 'null' &&
                                signatureImage !== 'undefined' &&
                                signatureImage !== '' &&
                                typeof signatureImage === 'string' &&
                                signatureImage.length > 10) {

                                console.log('✅ 서명 이미지 표시 시도');
                                console.log('서명 이미지 시작 부분:', signatureImage.substring(0, 30));

                                // data:image로 시작하지 않는 경우에도 표시 시도
                                const imgSrc = signatureImage.startsWith('data:image') ? signatureImage : 'data:image/png;base64,' + signatureImage;

                                detailHtml += '<div style="font-weight: 600; color: #555;">서명</div>' +
                                    '<div style="padding: 10px; background: white; border: 1px solid #ddd; border-radius: 8px;">' +
                                        '<img src="' + imgSrc + '" alt="서명" style="max-width: 300px; height: auto; display: block; border: 1px solid #ccc;" onerror="console.error(\'서명 이미지 로드 실패\'); this.style.display=\'none\';">' +
                                    '</div>';
                            } else {
                                console.log('❌ 서명 이미지 없음 또는 유효하지 않음');
                                console.log('signatureImage 값:', signatureImage);
                            }

                            if (donation.message && donation.message !== 'false' && donation.message.trim() !== '') {
                                detailHtml += '<div style="font-weight: 600; color: #555;">응원 메시지</div>' +
                                    '<div style="background: #fff5f5; padding: 10px; border-radius: 6px; border-left: 3px solid #e74c3c;">' + donation.message + '</div>';
                            }

                            detailHtml += '<div style="font-weight: 600; color: #555;">상태</div>' +
                                '<div><span style="background: #27ae60; color: white; padding: 4px 12px; border-radius: 12px; font-size: 13px;">완료</span></div>' +
                                '</div>' +
                                '</div>' +
                                '<div style="text-align: center; padding: 15px; background: #e8f8f5; border-radius: 8px; color: #27ae60; font-weight: 600;">' +
                                    '<i class="fas fa-check-circle"></i> 소중한 기부에 감사드립니다!' +
                                '</div>';

                            document.getElementById('donationDetailContent').innerHTML = detailHtml;
                            modal.style.display = 'flex';
                        } else {
                            alert('해당 기부 내역을 찾을 수 없습니다.');
                        }
                    }
                })
                .catch(error => {
                    console.error('기부 상세 정보 로드 오류:', error);
                    alert('상세 정보를 불러올 수 없습니다.');
                });
        }

        function closeDonationDetailModal() {
            document.getElementById('donationDetailModal').style.display = 'none';
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

                const donationReviewModal = document.getElementById('donationReviewModal');
                if (e.target === donationReviewModal) {
                    closeDonationReviewModal();
                }
            });

            // 기부 리뷰 폼 제출 이벤트 리스너
            const donationReviewForm = document.getElementById('donationReviewForm');
            if (donationReviewForm) {
                donationReviewForm.addEventListener('submit', function(e) {
                    e.preventDefault();
                    submitDonationReview();
                });
            }
        });