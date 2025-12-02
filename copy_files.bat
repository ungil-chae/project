@echo off
echo Copying updated files to target directory...
copy /Y "Welfare\src\main\webapp\project_admin.jsp" "Welfare\target\bdproject\project_admin.jsp"
copy /Y "Welfare\src\main\resources\mapper\AdminMapper.xml" "Welfare\target\classes\mapper\AdminMapper.xml"
echo Files copied successfully!
