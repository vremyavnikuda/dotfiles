#cpp 
## Используй это 

```
cmake_minimum_required(VERSION 3.15)
project(MyApp)

set(CMAKE_CXX_STANDARD 17)

file(GLOB APP_SOURCES *.cpp */*.cpp)
foreach (testsourcefile ${APP_SOURCES})
    get_filename_component(testname ${testsourcefile} NAME_WE)
    message("${testname}")
    add_executable(${testname} ${testsourcefile})
endforeach (testsourcefile ${APP_SOURCES})
```