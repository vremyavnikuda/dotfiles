### Базовый файл Dockerfile
[[Docker]]


Приложение `Spring Boot` легко реобразовать в исполяемый файл `jar`.
запуск сборки для `Maven`

```
./mvnw install
```

Базовый файл `Dockerfile`  для запуска этого jar бдует выглядить следующим образом на верхнем уровне проекта:

```Dockerfile
FROM eclipse-temurin:17-jdk-alpine 
VOLUME /tmp 
ARG JAR_FILE COPY ${JAR_FILE} app.jar 
ENTRYPOINT ["java","-jar","/app.jar"]
```

Дальше передаем jar_file как часть docker команды
maven:

```maven
docker build --build-arg JAR_FILE=target/*.jar -t myorg/myapp .
```

grable:
```grable
docker build --build-arg JAR_FILE=build/libs/*.jar -t myorg/myapp .
```

После того как выбрали систему сборки ,нужно жеско запрограммировать местоположение `jar` в Dockerfile
```Dockerfile
FROM eclipse-temurin:17-jdk-alpine 
VOLUME /tmp 
COPY target/*.jar app.jar 
ENTRYPOINT ["java","-jar","/app.jar"]
```

Затем можно создать образ с   помошь  команды 

```
docker build -t myorg/myapp .
```

Затем можно запустить его ,выполнив команду 

```
docker run -p 8080:8080 myorg/myapp
```

Пример вывода 

```
. ____ _ __ _ _ /\\ / ___'_ __ _ _(_)_ __ __ _ \ \ \ \ ( ( )\___ | '_ | '_| | '_ \/ _` | \ \ \ \ \\/ ___)| |_)| | | | | || (_| | ) ) ) ) ' |____| .__|_| |_|_| |_\__, | / / / / =========|_|==============|___/=/_/_/_/ :: Spring Boot :: (v2.7.4) 
Nov 06, 2018 2:45:16 PM org.springframework.boot.StartupInfoLogger logStarting 
INFO: Starting Application v0.1.0 on b8469cdc9b87 with PID 1 (/app.jar started by root in /) 
Nov 06, 2018 2:45:16 PM org.springframework.boot.SpringApplication logStartupProfileInfo ...
```


Если необходимо  покапаться внутри образа ,можно открыть в нем оболочку ,полнив следующую команду 

```
docker run -ti --entyrypoint /bir/sh myorg/myapp
```

Вывод анологичен следующему образцу  
```
/ # ls 
app.jar dev  home  media proc  run  srv tmp var 
bin     etc  lib   mnt   root  sbin sys usr 
/ #
```

>Базовый контейнер alpine ,который используется в примере ,не имеет bash ,так что это ash оболочка.Она обладает некоторыми ,но не всеми функциями bash

Если есть работающий контейнер и необходимо заглянуть  в него ,ножно сделать это вополнив docker exec

```
docker run --name myapp -ti --entrypoint /bin/sh myorg/myapp 
docker exec -ti myapp /bin/sh 
/ #
```

где `myapp` `--name` передается `docker run` команде.Если не использовали `--name`, то  docker присваивает мнемоническое имя ,которое можно получить из выходных `docker ps` .
Так же можно использовать идентификатор `Sha` контейнера вместо имени.`Идентификатор sha` также отображается в `docker ps`  выходных данных.
### Создать образ с помошью Maven

Для начало нужно запустить генератор образов загрузки Spring даже не меняя свой pox.xml (Важно!!! что Dockerfile если он все еще существует ,он игнорируется)


```
./mvnw spring-boot:build-image -Dspring-boot.build-image.imageName=springio/gs-spring-boot-docker
```

Чтобы выполнить `push` в реестр Docker необходимо иметь разрешение на `push` ,которого у нас нет по умолчанию .Необходимо изменить префикс изображения на свой собственный идентификатор `DockerHub` и `dockerlogin` чтобы убедиться ,что прошло проверку подлиности перед запуском Docker.

`docker push` 