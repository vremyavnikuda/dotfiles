#cpp 
# Методы класса `std::string`

## Конструкторы

- **`std::string()`**: Создает пустую строку.
    ```cpp
    std::string s; // Пустая строка
    ```

- **`std::string(const char* s)`**: Создает строку из C-строки (массив символов). Параметр `s` — указатель на массив символов (C-строка).
    ```cpp
    std::string s("Hello"); // Строка "Hello"
    ```

- **`std::string(const std::string& str)`**: Копирует другую строку `str`. Параметр `str` — другая строка `std::string`.
    ```cpp
    std::string s1("Hello");
    std::string s2(s1); // Копия строки s1
    ```

- **`std::string(std::string&& str)`**: Конструктор перемещения. Параметр `str` — временная строка, которая будет перемещена.
    ```cpp
    std::string s1("Hello");
    std::string s2(std::move(s1)); // s1 перемещена в s2
    ```

- **`std::string(size_t n, char c)`**: Создает строку из `n` копий символа `c`. Параметры: `n` — количество символов, `c` — символ для копирования.
    ```cpp
    std::string s(5, 'A'); // Строка "AAAAA"
    ```

## Операторы присваивания

- **`operator=(const std::string& str)`**: Присваивает значение строки `str`. Параметр `str` — строка для присваивания.
    ```cpp
    std::string s1("Hello");
    std::string s2 = s1; // s2 теперь равна "Hello"
    ```

- **`operator=(std::string&& str)`**: Присваивает значение строки с использованием перемещения. Параметр `str` — временная строка.
    ```cpp
    std::string s1("Hello");
    std::string s2 = std::move(s1); // s1 перемещена в s2
    ```

- **`operator=(const char* s)`**: Присваивает значение C-строки `s`. Параметр `s` — указатель на C-строку.
    ```cpp
    std::string s;
    s = "Hello"; // Строка s теперь равна "Hello"
    ```

- **`operator=(char c)`**: Присваивает строке один символ `c`. Параметр `c` — символ для присваивания.
    ```cpp
    std::string s;
    s = 'A'; // Строка s теперь равна "A"
    ```

## Доступ к элементам

- **`char& operator[](size_t pos)`**: Доступ к символу на позиции `pos` (без проверки границ). Параметр `pos` — позиция символа.
    ```cpp
    std::string s("Hello");
    s[1] = 'a'; // Строка теперь "Hallo"
    ```

- **`const char& operator[](size_t pos) const`**: Доступ к символу на позиции `pos` для константных объектов.
    ```cpp
    const std::string s("Hello");
    char c = s[1]; // c равен 'e'
    ```

- **`char& at(size_t pos)`**: Доступ к символу на позиции `pos` с проверкой границ. Если `pos` выходит за пределы строки, выбрасывается исключение `std::out_of_range`.
    ```cpp
    std::string s("Hello");
    try {
        s.at(1) = 'a'; // Строка теперь "Hallo"
    } catch (std::out_of_range& e) {
        std::cout << e.what() << std::endl;
    }
    ```

- **`const char& at(size_t pos) const`**: Доступ к символу на позиции `pos` с проверкой границ для константных объектов.
    ```cpp
    const std::string s("Hello");
    try {
        char c = s.at(1); // c равен 'e'
    } catch (std::out_of_range& e) {
        std::cout << e.what() << std::endl;
    }
    ```

- **`char& front()`**: Возвращает ссылку на первый символ строки.
    ```cpp
    std::string s("Hello");
    s.front() = 'Y'; // Строка теперь "Yello"
    ```

- **`const char& front() const`**: Возвращает константную ссылку на первый символ строки.
    ```cpp
    const std::string s("Hello");
    char c = s.front(); // c равен 'H'
    ```

- **`char& back()`**: Возвращает ссылку на последний символ строки.
    ```cpp
    std::string s("Hello");
    s.back() = '!'; // Строка теперь "Hell!"
    ```

- **`const char& back() const`**: Возвращает константную ссылку на последний символ строки.
    ```cpp
    const std::string s("Hello");
    char c = s.back(); // c равен 'o'
    ```

## Методы изменения строки

- **`std::string& operator+=(const std::string& str)`**: Добавляет строку `str` к текущей строке. Параметр `str` — строка для добавления.
    ```cpp
    std::string s1("Hello");
    std::string s2(" World");
    s1 += s2; // Строка s1 теперь "Hello World"
    ```

- **`std::string& operator+=(const char* s)`**: Добавляет C-строку `s` к текущей строке. Параметр `s` — C-строка для добавления.
    ```cpp
    std::string s("Hello");
    s += " World"; // Строка теперь "Hello World"
    ```

- **`std::string& operator+=(char c)`**: Добавляет символ `c` к текущей строке. Параметр `c` — символ для добавления.
    ```cpp
    std::string s("Hello");
    s += '!'; // Строка теперь "Hello!"
    ```

- **`std::string& append(const std::string& str)`**: Добавляет строку `str` к текущей строке. Параметр `str` — строка для добавления.
    ```cpp
    std::string s("Hello");
    s.append(" World"); // Строка теперь "Hello World"
    ```

- **`std::string& append(const char* s)`**: Добавляет C-строку `s` к текущей строке. Параметр `s` — C-строка для добавления.
    ```cpp
    std::string s("Hello");
    s.append(" World"); // Строка теперь "Hello World"
    ```

- **`std::string& append(size_t n, char c)`**: Добавляет `n` копий символа `c` к строке. Параметры: `n` — количество копий, `c` — символ для добавления.
    ```cpp
    std::string s("Hello");
    s.append(3, '!'); // Строка теперь "Hello!!!"
    ```

- **`void push_back(char c)`**: Добавляет символ `c` в конец строки. Параметр `c` — символ для добавления.
    ```cpp
    std::string s("Hello");
    s.push_back('!'); // Строка теперь "Hello!"
    ```

- **`void pop_back()`**: Удаляет последний символ строки.
    ```cpp
    std::string s("Hello!");
    s.pop_back(); // Строка теперь "Hello"
    ```

- **`std::string& insert(size_t pos, const std::string& str)`**: Вставляет строку `str` на позицию `pos`. Параметры: `pos` — позиция для вставки, `str` — строка для вставки.
    ```cpp
    std::string s("Hello");
    s.insert(5, " World"); // Строка теперь "Hello World"
    ```

- **`std::string& insert(size_t pos, const char* s)`**: Вставляет C-строку `s` на позицию `pos`. Параметры: `pos` — позиция для вставки, `s` — C-строка для вставки.
    ```cpp
    std::string s("Hello");
    s.insert(5, " World"); // Строка теперь "Hello World"
    ```

- **`std::string& erase(size_t pos = 0, size_t len = npos)`**: Удаляет подстроку длиной `len`, начиная с позиции `pos`. Параметры: `pos` — начальная позиция, `len` — длина удаляемой подстроки.
    ```cpp
    std::string s("Hello World");
    s.erase(5, 6); // Строка теперь "Hello"
    ```

- **`void clear()`**: Очищает строку.
    ```cpp
    std::string s("Hello");
    s.clear(); // Строка теперь пустая
    ```

- **`std::string& replace(size_t pos, size_t len, const std::string& str)`**: Заменяет подстроку на строку `str`. Параметры: `pos` — начальная позиция, `len` — длина заменяемой подстроки, `str` — строка для замены.
    ```cpp
    std::string s("Hello World");
    s.replace(6, 5, "C++"); // Строка теперь "Hello C++"
    ```

- **`std::string& replace(size_t pos, size_t len, const char* s)`**: Заменяет подстроку на C-строку `s`. Параметры: `pos` — начальная позиция, `len` — длина заменяемой подстроки, `s` — C-строка для замены.
    ```cpp
    std::string s("Hello World");
    s.replace(6, 5, "C++"); // Строка теперь "Hello C++"
    ```

## Конкатенация

- **`std::string operator+(const std::string& lhs, const std::string& rhs)`**: Объединяет две строки. Параметры: `lhs` и `rhs` — строки для объединения.
    ```cpp
    std::string s1("Hello");
    std::string s2(" World");
    std::string s3 = s1 + s2; // Строка s3 теперь "Hello World"
    ```

- **`std::string operator+(const std::string& lhs, const char* rhs)`**: Объединяет строку и C-строку. Параметры: `lhs` — строка `std::string`, `rhs` — C-строка.
    ```cpp
    std::string s1("Hello");
    std::string s2 = s1 + " World"; // Строка s2 теперь "Hello World"
    ```

- **`std::string operator+(const std::string& lhs, char rhs)`**: Объединяет строку и символ. Параметры: `lhs` — строка `std::string`, `rhs` — символ.
    ```cpp
    std::string s1("Hello");
    std::string s2 = s1 + '!'; // Строка s2 теперь "Hello!"
    ```

## Поиск

- **`size_t find(const std::string& str, size_t pos = 0) const`**: Находит первую позицию подстроки `str` начиная с `pos`. Параметры: `str` — строка для поиска, `pos` — начальная позиция поиска.
    ```cpp
    std::string s("Hello World");
    size_t pos = s.find("World"); // pos = 6
    ```

- **`size_t find(const char* s, size_t pos = 0) const`**: Находит первую позицию C-строки `s` начиная с `pos`. Параметры: `s` — C-строка для поиска, `pos` — начальная позиция поиска.
    ```cpp
    std::string str("Hello World");
    size_t pos = str.find("World"); // pos = 6
    ```

- **`size_t find(char c, size_t pos = 0) const`**: Находит первую позицию символа `c` начиная с `pos`. Параметры: `c` — символ для поиска, `pos` — начальная позиция поиска.
    ```cpp
    std::string s("Hello World");
    size_t pos = s.find('o'); // pos = 4
    ```

- **`size_t rfind(const std::string& str, size_t pos = npos) const`**: Находит последнюю позицию подстроки `str`. Параметры: `str` — строка для поиска, `pos` — начальная позиция поиска с конца.
    ```cpp
    std::string s("Hello World World");
    size_t pos = s.rfind("World"); // pos = 12
    ```

- **`size_t rfind(const char* s, size_t pos = npos) const`**: Находит последнюю позицию C-строки `s`. Параметры: `s` — C-строка для поиска, `pos` — начальная позиция поиска с конца.
    ```cpp
    std::string str("Hello World World");
    size_t pos = str.rfind("World"); // pos = 12
    ```

- **`size_t rfind(char c, size_t pos = npos) const`**: Находит последнюю позицию символа `c`. Параметры: `c` — символ для поиска, `pos` — начальная позиция поиска с конца.
    ```cpp
    std::string s("Hello World");
    size_t pos = s.rfind('o'); // pos = 7
    ```

- **`size_t find_first_of(const std::string& str, size_t pos = 0) const`**: Находит первую позицию любого символа из строки `str`. Параметры: `str` — строка символов, `pos` — начальная позиция поиска.
    ```cpp
    std::string s("Hello World");
    size_t pos = s.find_first_of("aeiou"); // pos = 1 (первая гласная 'e')
    ```

- **`size_t find_first_not_of(const std::string& str, size_t pos = 0) const`**: Находит первую позицию символа, отсутствующего в строке `str`. Параметры: `str` — строка символов, которых нужно избегать, `pos` — начальная позиция поиска.
    ```cpp
    std::string s("Hello World");
    size_t pos = s.find_first_not_of("He"); // pos = 2 ('l' не входит в "He")
    ```

- **`size_t find_last_of(const std::string& str, size_t pos = npos) const`**: Находит последнюю позицию любого символа из строки `str`. Параметры: `str` — строка символов, `pos` — начальная позиция поиска с конца.
    ```cpp
    std::string s("Hello World");
    size_t pos = s.find_last_of("aeiou"); // pos = 7 (последняя гласная 'o')
    ```

- **`size_t find_last_not_of(const std::string& str, size_t pos = npos) const`**: Находит последнюю позицию символа, отсутствующего в строке `str`. Параметры: `str` — строка символов, которых нужно избегать, `pos` — начальная позиция поиска с конца.
    ```cpp
    std::string s("Hello World");
    size_t pos = s.find_last_not_of("ld"); // pos = 9 (символ 'r')
    ```

## Сравнение

- **`int compare(const std::string& str) const`**: Сравнивает строку с `str`. Параметр `str` — строка для сравнения. Возвращает отрицательное значение, если текущая строка меньше, 0 — если равны, положительное — если больше.
    ```cpp
    std::string s1("Hello");
    std::string s2("World");
    int result = s1.compare(s2); // result < 0 (s1 < s2)
    ```

- **`int compare(const char* s) const`**: Сравнивает строку с C-строкой `s`. Параметр `s` — C-строка для сравнения. Возвращает отрицательное значение, если текущая строка меньше, 0 — если равны, положительное — если больше.
    ```cpp
    std::string s("Hello");
    int result = s.compare("World"); // result < 0 (s < "World")
    ```

## Извлечение подстрок

- **`std::string substr(size_t pos = 0, size_t len = npos) const`**: Возвращает подстроку, начинающуюся с позиции `pos` длиной `len`. Параметры: `pos` — начальная позиция, `len` — длина подстроки.
    ```cpp
    std::string s("Hello World");
    std::string sub = s.substr(6, 5); // sub равна "World"
    ```

## Размер строки

- **`size_t size() const`**: Возвращает количество символов в строке.
    ```cpp
    std::string s("Hello");
    size_t size = s.size(); // size = 5
    ```

- **`size_t length() const`**: То же, что и `size()`.
    ```cpp
    std::string s("Hello");
    size_t length = s.length(); // length = 5
    ```

- **`size_t max_size() const`**: Возвращает максимальный возможный размер строки.
    ```cpp
    std::string s;
    size_t max_size = s.max_size(); // Обычно очень большое значение
    ```

- **`void resize(size_t n)`**: Изменяет размер строки на `n`. Если новый размер больше текущего, строка заполняется символами `'\0'`.
    ```cpp
    std::string s("Hello");
    s.resize(10); // Строка теперь "Hello\0\0\0\0\0"
    ```

- **`size_t capacity() const`**: Возвращает количество памяти, зарезервированной для строки.
    ```cpp
    std::string s("Hello");
    size_t capacity = s.capacity(); // Например, 15 (в зависимости от компилятора)
    ```

- **`void reserve(size_t res_arg = 0)`**: Зарезервировать память для строки. Параметр `res_arg` — новое количество зарезервированной памяти.
    ```cpp
    std::string s("Hello");
    s.reserve(50); // Резервируем память для 50 символов
    ```

- **`void shrink_to_fit()`**: Освобождает неиспользуемую память.
    ```cpp
    std::string s("Hello");
    s.reserve(50); // Резервируем много памяти
    s.shrink_to_fit(); // Освобождаем лишнюю память
    ```

## Проверка состояния

- **`bool empty() const`**: Проверяет, пуста ли строка.
    ```cpp
    std::string s;
    bool isEmpty = s.empty(); // true, так как строка пуста
    ```

## Преобразование в C-строку

- **`const char* c_str() const`**: Возвращает C-строку (заканчивающуюся `'\0'`).
    ```cpp
    std::string s("Hello");
    const char* cstr = s.c_str(); // cstr указывает на "Hello"
    ```

- **`const char* data() const`**: Возвращает указатель на данные строки (не обязательно заканчивается `'\0'`).
    ```cpp
    std::string s("Hello");
    const char* data = s.data(); // data указывает на "Hello" (не гарантировано наличие '\0' в конце)
    ```

## Преобразование регистра

- **`std::transform`** (не метод, но можно использовать с `std::string`): Для преобразования символов строки (например, к верхнему/нижнему регистру).
    ```cpp
    std::string s("Hello");
    std::transform(s.begin(), s.end(), s.begin(), ::toupper); // s теперь "HELLO"
    ```

## Взаимодействие с потоком

- **`std::istream& getline(std::istream& is, std::string& str)`**: Чтение строки до конца или до разделителя. Параметры: `is` — входной поток, `str` — строка для записи результата.
    ```cpp
    std::string s;
    std::getline(std::cin, s); // Чтение строки из входного потока
    ```
