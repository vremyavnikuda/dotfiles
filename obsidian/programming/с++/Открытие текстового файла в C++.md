#примерыкода #НГТУ #теория 
Для открытия текстового файла в C++ и чтения его содержимого можно использовать следующий паттерн проектирования:

```cpp
#include <iostream>
#include <fstream>
#include <string>
int main()
{
    std::ifstream file("example.txt"); // Открытие файла для чтения
    if (file.is_open())
    {
        std::string line;
        while (std::getline(file, line))
        {
            std::cout << line << std::endl; // Вывод содержимого файла
        }
        file.close(); // Закрытие файла
    }
    else
    {
        std::cerr << "Unable to open file" << std::endl;
    }
    return 0;
}
```

