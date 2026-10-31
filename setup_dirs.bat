@echo off
echo Creating project directory structure...

mkdir src\main\java\com\college\complaint\model
mkdir src\main\java\com\college\complaint\dao
mkdir src\main\java\com\college\complaint\servlet\student
mkdir src\main\java\com\college\complaint\servlet\admin
mkdir src\main\java\com\college\complaint\util
mkdir src\main\webapp\WEB-INF
mkdir src\main\webapp\css
mkdir src\main\webapp\js
mkdir src\main\webapp\images
mkdir src\main\webapp\student
mkdir src\main\webapp\admin
mkdir src\main\resources
mkdir sql

echo.
echo Directory structure created successfully!
echo.
echo Structure:
echo src/
echo   main/
echo     java/com/college/complaint/
echo       model/       - Data model classes (POJO)
echo       dao/         - Data Access Objects
echo       servlet/
echo         student/   - Student-facing servlets
echo         admin/     - Admin-facing servlets
echo       util/        - Utility classes (DB, helpers)
echo     webapp/
echo       WEB-INF/     - Deployment descriptors
echo       css/         - Stylesheets
echo       js/          - JavaScript files
echo       images/      - Static image assets
echo       student/     - Student JSP pages
echo       admin/       - Admin JSP pages
echo     resources/     - db.properties, config files
echo sql/               - SQL scripts (schema, seed data)
echo.
pause
