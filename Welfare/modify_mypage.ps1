# project_mypage.jsp 수정 - CSS를 외부 파일로 교체
$ErrorActionPreference = "Stop"
$encoding = New-Object System.Text.UTF8Encoding $false

$jspPath = "C:\newproject\Welfare\src\main\webapp\project_mypage.jsp"
$backupPath = "C:\newproject\Welfare\src\main\webapp\project_mypage.jsp.backup"

Write-Host "Reading JSP file..."
$lines = Get-Content $jspPath -Encoding UTF8

Write-Host "Total lines: $($lines.Count)"

# 백업 생성
Write-Host "Creating backup..."
Copy-Item $jspPath $backupPath -Force

# 새 JSP 내용 생성
# 1-27번 라인 유지
# 28번 라인(<style>)을 CSS 링크로 교체
# 29-2380번 라인(CSS 내용 + </style>) 삭제
# 2381번 라인부터 끝까지 유지

$newLines = @()

# 1-27번 라인 (인덱스 0-26)
$newLines += $lines[0..26]

# CSS 링크 추가 (28번 라인 위치)
$newLines += '    <link rel="stylesheet" href="resources/css/project_mypage.css">'

# 2381번 라인부터 끝까지 (인덱스 2380부터)
$newLines += $lines[2380..($lines.Count - 1)]

Write-Host "New total lines: $($newLines.Count)"
Write-Host "Reduced by: $($lines.Count - $newLines.Count) lines"

# 파일 저장
Write-Host "Saving modified JSP..."
$newContent = $newLines -join "`r`n"
[System.IO.File]::WriteAllText($jspPath, $newContent, $encoding)

Write-Host "Done! JSP file modified successfully."
Write-Host "Backup saved at: $backupPath"
