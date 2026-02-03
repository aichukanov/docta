@echo off
REM Скрипт для применения миграции 006_user_preferred_locale.sql (Windows)

echo ================================
echo User Locale Migration Script
echo ================================
echo.

REM Проверяем наличие файла миграции
set MIGRATION_FILE=server\sql\migrations\006_user_preferred_locale.sql

if not exist "%MIGRATION_FILE%" (
    echo ❌ Error: Migration file not found at %MIGRATION_FILE%
    pause
    exit /b 1
)

echo 📄 Migration file found: %MIGRATION_FILE%
echo.

REM Параметры подключения (можно переопределить)
if not defined DB_HOST set DB_HOST=localhost
if not defined DB_PORT set DB_PORT=3306
if not defined DB_USER set DB_USER=root
if not defined DB_NAME set DB_NAME=docta

echo Database connection:
echo   Host: %DB_HOST%:%DB_PORT%
echo   User: %DB_USER%
echo   Database: %DB_NAME%
echo.

REM Запрашиваем пароль
set /p DB_PASSWORD="Enter MySQL password for %DB_USER%: "
echo.

REM Применяем миграцию
echo 🚀 Applying migration...
echo.

mysql -h %DB_HOST% -P %DB_PORT% -u %DB_USER% -p%DB_PASSWORD% %DB_NAME% < "%MIGRATION_FILE%"

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✅ Migration applied successfully!
    echo.
    echo Checking results...
    
    REM Проверяем что колонка добавлена
    mysql -h %DB_HOST% -P %DB_PORT% -u %DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "DESCRIBE auth_users preferred_locale;"
    
    if %ERRORLEVEL% EQU 0 (
        echo.
        echo ✅ Column 'preferred_locale' successfully added to 'auth_users' table
        echo.
        echo 📊 Current statistics:
        mysql -h %DB_HOST% -P %DB_PORT% -u %DB_USER% -p%DB_PASSWORD% %DB_NAME% -e "SELECT COUNT(*) as total_users, COUNT(preferred_locale) as users_with_locale, COUNT(*) - COUNT(preferred_locale) as users_without_locale FROM auth_users;"
        echo.
        echo 🎉 Migration complete!
    )
) else (
    echo.
    echo ❌ Migration failed!
    echo.
    echo Possible reasons:
    echo   1. Column already exists (migration already applied^)
    echo   2. Insufficient privileges
    echo   3. Database connection error
    echo.
    echo Please check the error message above.
    pause
    exit /b 1
)

echo.
pause
