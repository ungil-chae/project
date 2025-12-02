# project_mypage.jsp에서 CSS와 JS 추출 스크립트
$ErrorActionPreference = "Stop"
$encoding = [System.Text.Encoding]::UTF8

$jspPath = "C:\newproject\Welfare\src\main\webapp\project_mypage.jsp"
$cssPath = "C:\newproject\Welfare\src\main\webapp\resources\css\project_mypage.css"
$jsPath = "C:\newproject\Welfare\src\main\webapp\resources\js\project_mypage.js"

Write-Host "Reading JSP file..."
$lines = Get-Content $jspPath -Encoding UTF8

# CSS 추출 (라인 29 ~ 2379)
Write-Host "Extracting CSS (lines 29-2379)..."
$cssLines = $lines[28..2378]
$cssContent = $cssLines -join "`n"

# JS 추출 (라인 3073 ~ 7591)
Write-Host "Extracting JavaScript (lines 3073-7591)..."
$jsLines = $lines[3072..7590]
$jsContent = $jsLines -join "`n"

# CSS 디렉토리 확인
$cssDir = Split-Path $cssPath -Parent
if (!(Test-Path $cssDir)) {
    New-Item -ItemType Directory -Path $cssDir -Force
}

# JS 디렉토리 확인
$jsDir = Split-Path $jsPath -Parent
if (!(Test-Path $jsDir)) {
    New-Item -ItemType Directory -Path $jsDir -Force
}

# 파일 저장
Write-Host "Saving CSS file..."
[System.IO.File]::WriteAllText($cssPath, $cssContent, $encoding)

Write-Host "Saving JS file..."
[System.IO.File]::WriteAllText($jsPath, $jsContent, $encoding)

Write-Host "Done! CSS and JS files extracted successfully."
Write-Host "CSS: $cssPath"
Write-Host "JS: $jsPath"
