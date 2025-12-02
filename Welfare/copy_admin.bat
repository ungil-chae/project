@echo off
echo Copying project_admin.jsp to target directory...
xcopy /Y "src\main\webapp\project_admin.jsp" "target\bdproject\"
echo.
echo File copied successfully!
pause
