#go 

- Конструкция `var s []map[int]string` в языке программирования Go объявляет переменную `s`, которая представляет собой срез карт. 
```go
package main

import "fmt"

func main() {
    // Инициализация среза карт
    var s []map[int]string

    // Добавление новой карты в срез
    newMap := make(map[int]string)
    newMap[1] = "one"
    newMap[2] = "two"

    s = append(s, newMap)

    // Печать содержимого среза карт
    for i, m := range s {
        fmt.Printf("Map %d:\n", i)
        for k, v := range m {
            fmt.Printf("  %d: %s\n", k, v)
        }
    }
}

```

- Cоздает новую карту, где можно хранить пары ключ-значение, где ключи — это числа с плавающей запятой типа `float32`, а значения — целые числа типа `int`.
```go
m := make(map[float32]int)
```
```go
package main

import "fmt"

func main() {
    m := make(map[float32]int)

    // Добавление элементов в карту
    m[1.1] = 10
    m[2.2] = 20

    // Доступ к элементам карты
    fmt.Println(m[1.1]) // Выведет: 10
    fmt.Println(m[2.2]) // Выведет: 20

    // Проверка существования ключа
    value, exists := m[3.3]
    if exists {
        fmt.Println(value)
    } else {
        fmt.Println("Key 3.3 does not exist")
    }
}

```
- Конструкция `var s []map[int]int` в языке программирования Go объявляет переменную `s`, которая представляет собой срез карт (slice of maps).
```go
package main

import "fmt"

func main() {
    // Объявление переменной s как среза карт
    var s []map[int]int

    // Инициализация и добавление карты в срез
    m1 := map[int]int{1: 100, 2: 200}
    m2 := map[int]int{3: 300, 4: 400}

    s = append(s, m1)
    s = append(s, m2)

    // Вывод значений
    for i, m := range s {
        fmt.Printf("Map %d:\n", i)
        for k, v := range m {
            fmt.Printf("  Key: %d, Value: %d\n", k, v)
        }
    }
}

```