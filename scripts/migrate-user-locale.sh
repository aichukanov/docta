#!/bin/bash
# Скрипт для применения миграции 006_user_preferred_locale.sql

echo "================================"
echo "User Locale Migration Script"
echo "================================"
echo ""

# Проверяем наличие файла миграции
MIGRATION_FILE="server/sql/migrations/006_user_preferred_locale.sql"

if [ ! -f "$MIGRATION_FILE" ]; then
    echo "❌ Error: Migration file not found at $MIGRATION_FILE"
    exit 1
fi

echo "📄 Migration file found: $MIGRATION_FILE"
echo ""

# Читаем параметры подключения из .env
if [ -f ".env" ]; then
    echo "📋 Reading database config from .env..."
    export $(cat .env | grep -v '^#' | xargs)
else
    echo "⚠️  Warning: .env file not found, using defaults"
fi

# Параметры подключения (можно переопределить через переменные окружения)
DB_HOST="${DB_HOST:-localhost}"
DB_PORT="${DB_PORT:-3306}"
DB_USER="${DB_USER:-root}"
DB_NAME="${DB_NAME:-docta}"

echo ""
echo "Database connection:"
echo "  Host: $DB_HOST:$DB_PORT"
echo "  User: $DB_USER"
echo "  Database: $DB_NAME"
echo ""

# Запрашиваем пароль
read -sp "Enter MySQL password for $DB_USER: " DB_PASSWORD
echo ""
echo ""

# Применяем миграцию
echo "🚀 Applying migration..."
echo ""

mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" < "$MIGRATION_FILE"

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ Migration applied successfully!"
    echo ""
    echo "Checking results..."
    
    # Проверяем что колонка добавлена
    mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -e "DESCRIBE auth_users preferred_locale;"
    
    if [ $? -eq 0 ]; then
        echo ""
        echo "✅ Column 'preferred_locale' successfully added to 'auth_users' table"
        echo ""
        echo "📊 Current statistics:"
        mysql -h "$DB_HOST" -P "$DB_PORT" -u "$DB_USER" -p"$DB_PASSWORD" "$DB_NAME" -e "
            SELECT 
                COUNT(*) as total_users,
                COUNT(preferred_locale) as users_with_locale,
                COUNT(*) - COUNT(preferred_locale) as users_without_locale
            FROM auth_users;
        "
        echo ""
        echo "🎉 Migration complete!"
    fi
else
    echo ""
    echo "❌ Migration failed!"
    echo ""
    echo "Possible reasons:"
    echo "  1. Column already exists (migration already applied)"
    echo "  2. Insufficient privileges"
    echo "  3. Database connection error"
    echo ""
    echo "Please check the error message above."
    exit 1
fi
