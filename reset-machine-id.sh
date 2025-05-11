#!/bin/sh
set -e  # Останавливаем скрипт при ошибке

# Константы
LOG_FILE="/var/log/reset-machine-id.log"
BACKUP_DIR="/var/backups/machine-id"
NOTIF_TITLE="Системное уведомление"

log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $1" | tee -a "$LOG_FILE"
}

notify_user() {
    echo "$1"
    if command -v notify-send >/dev/null 2>&1; then
        notify-send "$NOTIF_TITLE" "$1"
    fi
}

restore_from_backup() {
    if [ ! -d "$BACKUP_DIR" ]; then
        log "❌ Папка резервных копий не найдена: $BACKUP_DIR"
        return 1
    fi

    latest_backup=$(ls -t "$BACKUP_DIR"/*.bak 2>/dev/null | head -n1)
    if [ -z "$latest_backup" ]; then
        log "❌ Резервные копии отсутствуют."
        return 1
    fi

    log "🔄 Восстановление machine-id из резервной копии: $latest_backup"
    cat "$latest_backup" > /etc/machine-id
    log "✅ machine-id успешно восстановлен: $(cat "$latest_backup")"
    notify_user "machine-id успешно восстановлен из резервной копии."
}

main() {
    echo "⚠️ ВНИМАНИЕ: Этот скрипт изменит machine-id системы."
    echo "Это повлияет на systemd, journal и другие компоненты системы."
    echo ""
    echo "❗️ Изменение machine-id может повлиять на:"
    echo "   - системные логи (journalctl)"
    echo "   - работу некоторых сервисов"
    echo "   - приложения, зависящие от уникального ID системы"
    echo ""
    echo "⚠️ Не рекомендуется выполнять это на продакшн-серверах без понимания последствий."
    echo ""

    read -p "Хотите восстановить machine-id из резервной копии? (y/N): " restore_choice
    if [ "$restore_choice" = "y" ] || [ "$restore_choice" = "Y" ]; then
        restore_from_backup
        exit 0
    fi

    read -p "Вы всё ещё хотите продолжить? (y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        log "❌ Операция отменена пользователем."
        echo "❌ Операция отменена пользователем."
        exit 0
    fi

    # Проверяем текущий machine-id
    if [ -f /etc/machine-id ]; then
        CURRENT_ID=$(cat /etc/machine-id)
        log "📊 Текущий machine-id: $CURRENT_ID"
    else
        log "⚠️ /etc/machine-id не найден. Возможно, система ещё не сгенерировала ID."
        CURRENT_ID=""
    fi

    read -p "Хотите сделать резервную копию текущего machine-id? (y/N): " backup_choice
    if [ "$backup_choice" = "y" ] || [ "$backup_choice" = "Y" ]; then
        sudo mkdir -p "$BACKUP_DIR"
        TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
        if [ -n "$CURRENT_ID" ]; then
            echo "$CURRENT_ID" | sudo tee "$BACKUP_DIR/machine-id-$TIMESTAMP.bak" > /dev/null
            log "💾 Резервная копия сохранена в: $BACKUP_DIR/machine-id-$TIMESTAMP.bak"
        else
            log "❌ Нет данных для резервного копирования."
        fi
    fi

    read -p "Вы уверены, что хотите удалить текущий machine-id и создать новый? (y/N): " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        log "❌ Операция отменена пользователем."
        echo "❌ Операция отменена пользователем."
        exit 0
    fi

    log "🔄 Удаление текущего /etc/machine-id..."
    sudo rm -f /etc/machine-id

    log "⚙️ Генерация нового machine-id..."
    sudo systemd-machine-id-setup

    NEW_ID=$(cat /etc/machine-id)
    log "✅ machine-id успешно изменён!"
    log "🆕 Новый machine-id: $NEW_ID"

    notify_user "machine-id был успешно изменён на: $NEW_ID"
    echo "✅ machine-id успешно изменён!"
    echo "🆕 Новый machine-id: $NEW_ID"
    echo "Операция завершена."
}

main