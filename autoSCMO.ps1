$url = "https://robotix-com.web.app/old/pages/table.html"

$response = Invoke-WebRequest -Uri $url

#МЕНЯТЬ СТРОГО ЗАПРЕЩЕННО
# Браузер Firefox >5.0
#Данный мануал написан 1 раз ,чтобы 1000 раз не объяснять особо одаренным 
#Программа предназначена для тех людей которые относят себя к котигории "ленивое чмо"
# 
# $url -> тут указывается адрес который парсим (адрес SCMO )при этом логиниться нужно заранее-нареч. за некоторое время до чего-л.; заблаговременно.
# 
#
#
#
$elements = $response.ParsedHtml.body.getElementsByTagName('div') | Where-Object { $_.id -like 'DIV_oname*' }

# Проверяем значение атрибута "value" у каждого найденного элемента
foreach ($element in $elements) {
    $value = $element.getAttribute("value")
    Write-Host "Значение элемента с id='$($element.id)': $value"
}