
# Методы взаимодействия с картами (map) в Go

Go предоставляет несколько встроенных функций и методов для работы с картами. Вот полное руководство:

## Создание карт

### Создание пустой карты
```go
var m map[string]int
m = make(map[string]int)
```

### Создание и инициализация карты
```go
m := map[string]int{"one": 1, "two": 2}
```

## Добавление и изменение элементов

### Добавление нового элемента
```go
m["three"] = 3
```

### Изменение существующего элемента
```go
m["one"] = 11
```

## Удаление элементов

### Удаление элемента по ключу
```go
delete(m, "two")
```

## Доступ к элементам

### Доступ к значению по ключу
```go
value := m["one"]
```

### Проверка существования ключа
```go
value, exists := m["one"]
if exists {
    fmt.Println("Key exists with value", value)
} else {
    fmt.Println("Key does not exist")
}
```

## Итерация по элементам карты

### Использование цикла for-range
```go
for key, value := range m {
    fmt.Println(key, value)
}
```

## Получение длины карты

### Количество элементов в карте
```go
length := len(m)
```

## Вложенные карты

### Создание и использование вложенных карт
```go
nestedMap := make(map[string]map[string]int)
nestedMap["first"] = make(map[string]int)
nestedMap["first"]["one"] = 1
```

## Пример: работа с картами

### Полный пример использования карт
```go
package main

import (
    "fmt"
)

func main() {
    // Создание и инициализация карты
    m := map[string]int{"one": 1, "two": 2}
    
    // Добавление нового элемента
    m["three"] = 3
    
    // Изменение существующего элемента
    m["one"] = 11
    
    // Доступ к элементу и проверка существования ключа
    if value, exists := m["one"]; exists {
        fmt.Println("Key 'one' exists with value", value)
    }
    
    // Удаление элемента
    delete(m, "two")
    
    // Итерация по элементам карты
    for key, value := range m {
        fmt.Println(key, value)
    }
    
    // Количество элементов в карте
    fmt.Println("Length of map:", len(m))
}
```

Это руководство предоставляет полный обзор наиболее распространенных операций с картами (map) в Go.
