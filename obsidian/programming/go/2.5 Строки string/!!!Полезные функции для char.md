#go #теория 

unicode.IsDigit(char) - проверка -> если ли в символах арабские числа
unicode.IsLetter(char) - проверка -> есть ли в символах латинские буквы 

пример кода где есть алфавит + цифры
в функцию просто просто передаем каждый символ и проверяем соответствует он или нет заданному условию
```go
func isLetterOrDigit(r rune) bool {  
    return (r >= 'a' && r <= 'z') || (r >= 'A' && r <= 'Z') || (r >= '0' && r <= '9')  
}
```

### Дана строка, содержащая только английские буквы (большие и маленькие). Добавить символ ‘*’ (звездочка) между буквами (перед первой буквой и после последней символ ‘*’ добавлять не нужно).
Если на надо разделить монотонную строку
```go
  
func main() {  
  
    addSymbol()  
}  
  
func addSymbol() {  
    // Создаем reader для считывания входных данных  
    reader := bufio.NewReader(os.Stdin)  
    // Считываем строку  
    input, _ := reader.ReadString('\n')  
    // Убираем символ новой строки  
    input = strings.TrimSpace(input)  
  
    // Создаем builder для формирования результата  
    var builder strings.Builder  
  
    // Проходим по каждому символу строки  
    for i, char := range input {  
       if i > 0 {  
          builder.WriteString("*")  
       }       builder.WriteRune(char)  
    }  
    // Печатаем результат  
    fmt.Println(builder.String())  
}
```



### На вход подается целое число. Необходимо возвести в квадрат каждую цифру числа и вывести получившееся число. 

~~~
Например, у нас есть число 9119. Первая цифра - 9. 9 в квадрате - 81. Дальше 1. Единица в квадрате - 1. В итоге получаем 811181

**Sample Input:**

9119

**Sample Output:**

811181
~~~~

решение задачи 
```go
package main  
  
import (  
    "fmt"  
    "strconv"    "strings")  
  
func main() {  
    var number int  
    fmt.Scanln(&number)  
    fmt.Println(numberSquared(number))  
}  
  
func numberSquared(number int) int {  
    if number < 0 {  
       return 0  
    }  
  
    inputString := strconv.Itoa(number)  
    var builderString strings.Builder  
  
    //перебираем строку числе и возводим в квадрат каждое число и формируем строку числового ряда  
    for _, char := range inputString {  
       digit := char - '0'  
       square := int(digit * digit)  
       builderString.WriteString(fmt.Sprintf("%d", square))  
    }  
    //преобразовываем строку чисел -> в числовой ряд  
    result, err := strconv.Atoi(builderString.String())  
    if err != nil {  
       return 0  
    }  
    return result  
}
```