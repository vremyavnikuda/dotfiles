# Замените URL на адрес вашей HTML-страницы
$url = "https://robotix-com.web.app/old/pages/table.html"

# Получаем HTML-код страницы
$response = Invoke-WebRequest -Uri $url

# Ищем все строки таблицы
$rows = $response.ParsedHtml.body.getElementsByTagName('tr')

# Проверяем, есть ли строки в таблице
if ($null -eq $rows) {
    Write-Host "Таблица не найдена на странице."
} else {
    # Пропускаем первую строку (с заголовками)
    foreach ($row in $rows[1..-1]) {
        # Находим все ячейки в текущей строке
        $cells = $row.getElementsByTagName('td')
        # Получаем текст из первой ячейки (№)
        $number = $cells[0].innerText
        # Получаем текст из второй и третьей ячеек
        $value1 = $cells[1].innerText
        $value2 = $cells[2].innerText
        # Выводим значения
        Write-Host "№${number}: ${value1}, ${value2}"
    }
}

# Добавляем ожидание нажатия клавиши Enter
Read-Host "Нажмите Enter, чтобы завершить программу"
