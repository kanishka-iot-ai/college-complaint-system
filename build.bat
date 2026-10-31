@echo off
setlocal enabledelayedexpansion

echo ========================================================
echo   College Complaint Management System - Build Script
echo ========================================================

:: 1. Detect Java JDK
if defined JAVA_HOME (
    set "JAVAC_CMD=%JAVA_HOME%\bin\javac.exe"
    set "JAR_CMD=%JAVA_HOME%\bin\jar.exe"
) else (
    if exist "C:\Program Files\Java\jdk-26.0.1\bin\javac.exe" (
        set "JAVAC_CMD=C:\Program Files\Java\jdk-26.0.1\bin\javac.exe"
        set "JAR_CMD=C:\Program Files\Java\jdk-26.0.1\bin\jar.exe"
    ) else (
        where javac >nul 2>nul
        if %errorlevel% equ 0 (
            set "JAVAC_CMD=javac"
            set "JAR_CMD=jar"
        ) else (
            echo [ERROR] JDK javac compiler not found. Please install JDK 11+ or set JAVA_HOME.
            pause
            exit /b 1
        )
    )
)

echo [*] Using Java Compiler: %JAVAC_CMD%

:: 2. Clean and Create output directories
echo [*] Cleaning target directory...
if exist "target" rmdir /s /q "target"
mkdir "target\classes"
mkdir "target\CollegeComplaintSystem\WEB-INF\classes"
mkdir "target\CollegeComplaintSystem\WEB-INF\lib"

:: 3. Prepare source list
echo [*] Gathering Java source files...
del /q "sources.txt" 2>nul
powershell -NoProfile -Command "(Get-ChildItem -Path 'src\main\java' -Recurse -Filter '*.java' | ForEach-Object { '\"' + $_.FullName.Replace('\', '/') + '\"' }) | Set-Content -Path 'sources.txt' -Encoding Ascii"

:: 4. Compile Java Sources
echo [*] Compiling Java classes with dependencies...
"%JAVAC_CMD%" -cp "lib\*" -d "target\classes" @"sources.txt"
if %errorlevel% neq 0 (
    echo [ERROR] Compilation failed!
    pause
    exit /b 1
)
del /q "sources.txt"
echo [OK] Compilation successful!

:: 5. Assemble exploded WAR
echo [*] Assembling Web Application Archive...
xcopy /s /e /y /q "src\main\webapp\*" "target\CollegeComplaintSystem\"
xcopy /s /e /y /q "target\classes\*" "target\CollegeComplaintSystem\WEB-INF\classes\"
copy /y "src\main\resources\db.properties" "target\CollegeComplaintSystem\WEB-INF\classes\" >nul
copy /y "lib\jbcrypt-0.4.jar" "target\CollegeComplaintSystem\WEB-INF\lib\" >nul
copy /y "lib\jstl-1.2.jar" "target\CollegeComplaintSystem\WEB-INF\lib\" >nul
copy /y "lib\mysql-connector-java-8.0.28.jar" "target\CollegeComplaintSystem\WEB-INF\lib\" >nul

:: 6. Package WAR file
echo [*] Packaging CollegeComplaintSystem.war...
cd "target\CollegeComplaintSystem"
"%JAR_CMD%" -cvf "..\CollegeComplaintSystem.war" * >nul
cd ..\..

echo ========================================================
echo   BUILD SUCCESSFUL!
echo   WAR location: target\CollegeComplaintSystem.war
echo   To deploy: Copy target\CollegeComplaintSystem.war to Tomcat webapps/
echo ========================================================
pause
