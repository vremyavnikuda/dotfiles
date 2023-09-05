PostgreSQL
#java #db #postgresql #spring #medianamager [[PostgreSQL]]
Для начала нам нужно скачать установщик PostgreSQL, например отсюда: [PostgreSQL Database Download](https://www.enterprisedb.com/downloads/postgres-postgresql-downloads)

Открываем IDEA с нашим проектом. Нажимаем Database в правом столбце интерфейса, нажимаем на "+" для добавления нашей БД. Далее Data Source --> PostgreSQL.

![[original.png]]

Во всплывающем окне вписываем в поле User роль root, которую мы создали ранее, и наш пароль 123 в поле password. В поле Database пишем название нашей БД customers. Нажимаем кнопку Test Connection, и если видим зеленую галку под ней, то все в порядке, и нажимаем кнопку OK.

![[original (1).png]]

Всё, к БД подключились, теперь переходим к файлу pom.xml и добавим зависимости. 

Для работы с БД ORM:

```java
<dependency> 
	<groupId>org.springframework.boot</groupId> 
	<artifactId>spring-boot-starter-data-jpa</artifactId> 
</dependency>
```

Для создания REST контроллера:
```java
<dependency> 
	<groupId>org.springframework.boot</groupId> 
	<artifactId>spring-boot-starter-data-rest</artifactId> 
</dependency>
```

Для сервера Tomcat:
```java
<dependency> 
	<groupId>org.postgresql</groupId> 
	<artifactId>postgresql</artifactId> 
	<version>42.2.10</version> 
</dependency>
```

Разобрались с pom.xml, перейдем в папку resources, и заполним файл application.properties следующим образом:
```java
spring.datasource.url=jdbc:postgresql: //localhost:5432/customers
spring.datasource.username=login 
spring.datasource.password=password 

spring.datasource.driver-class-name=org.postgresql.Driver 
spring.jpa.database=postgresql 
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQL10Dialect
```

Здесь мы прописали URL нашей базы данных, сообщили логин и пароль для нее, прописали драйвер для PostgreSQL, обозначили, что будем использовать тип данных PostgreSQL и прописали диалект для Hibernate. Далее создадим в той же папке resources новую директорию под названием database. В этой директории создадим 2 файла: initDB.sql и populateDB.sql . Первый будет отвечать за создание таблиц, второй за первоначальное их заполнение. Откроем initDB.sql и увидим сверху зеленую полоску с надписью SQL dialect is not configured. Это означает, что мы не выбрали диалект SQL для нашего проекта (а их существует несколько). Нажимаем справа на этой же полоске на надпись Change dialect to…. Во всплывающем окошке жмем Project SQL Dialect, и поскольку база данных у нас PostgreSQL, то выбираем одноименный диалект. Жмем ОК

![[original (2).png]]

Перейдем к заполнению наших файлов .sql. Заполним сначала файл initDB.sql :

```sql
CREATE TABLE IF NOT EXISTS clients 
( 
	id BIGSERIAL PRIMARY KEY , 
	name VARCHAR(200) NOT NULL , 
	email VARCHAR(254) NOT NULL , 
	phone VARCHAR(20) NOT NULL 
);
```

Если у вас после заполнения файла какие-то слова кроме clients написаны белым шрифтом, то нажмите ПКМ внутри текста, и выберите еще раз Change Dialect --> PostgreSQL. Как вы наверное уже поняли, это те же самые данные, которые мы заполняли при создании тестовой таблицы вручную. Здесь они оформлены на диалекте PostgreSQL языка SQL. 

Теперь заполним файл populateDB.sql :

```sql
INSERT INTO clients VALUES
(1, 'Vassily Petrov', 'vpetrov@jr.com', '+7 (191) 322-22-33)'),
(2, 'Pjotr Vasechkin', 'pvasechkin@jr.com', '+7 (191) 223-33-22)');
```

Если название таблицы clients у вас написано красными буквами, то ничего страшного. Дело в том, что мы еще не создали эту таблицу, и IDEA ее пока что не узнает. Для того, чтобы создать и заполнить таблицу, нам нужно вернуться в файл application.properties и добавить туда три следующие строчки:

```java
spring.datasource.initialization-mode=ALWAYS
spring.datasource.schema=classpath*:database/initDB.sql
spring.datasource.data=classpath*:database/populateDB.sql
```

В этих строках мы говорим, что хотим инициализировать БД программно и указываем какие файлы нужно для этого использовать. Далее переходим в метод main нашего приложения, и запускаем его. После этого идем в pgAdmin --> Servers --> PostgreSQL 12 --> Базы данных --> customers --> Схемы --> public, нажимаем ПКМ на «Таблицы», «Обновить». Если всё прошло успешно, то видим созданную нами таблицу clients. После этого переходим обратно в файл application.properties и закомментируем строку.

```java
spring.datasource.data=classpath*:database/populateDB.sql
```

как показано ниже:

```java
spring.datasource.url=jdbc:postgresql://localhost:5432/customers
spring.datasource.username=root
spring.datasource.password=123

spring.datasource.driver-class-name=org.postgresql.Driver
spring.jpa.database=postgresql
spring.jpa.database-platform=org.hibernate.dialect.PostgreSQL10Dialect

spring.datasource.initialization-mode=ALWAYS
spring.datasource.schema=classpath*:database/initDB.sql
#spring.datasource.data=classpath*:database/populateDB.sql
```

Если мы этого не сделаем, то при следующем запуске программы получим такую ошибку: _org.postgresql.util.PSQLException: ОШИБКА: повторяющееся значение ключа нарушает ограничение уникальности "clients_pkey"_. Это происходит потому, что у нас уже заполнены в таблице поля с id 1 и 2 (еще при первом запуске). В созданной нами таблице поле id указано как bigserial, что соответствует типу Long в Java. Однако в нашей программе для этого поля используется тип Integer. Я решил показать как использовать Long (BIGSERIAL), потому что это больший диапазон чем Integer. Дело в том, что в таблицах поле, обозначенное как Primary Key может использоваться не только для хранения id юзеров, но и для хранения индексов самых различных данных, и количество таких записей может превысить максимальное значение Integer. Например, если наша программа ежесекундно производит какие-то измерения и записывает данные в таблицу. Для того, чтобы переписать наши классы под использование типа данных Long, нам необходимо поменять тип с Integer на Long во всех классах и методах, где используется поле id. Мы этого делать не будем, потому что изначально программа была написана автором под тип id Integer, значит в этом есть какой-то смысл. Чтобы продолжить, давайте еще раз удалим созданную нами таблицу clients из нашей БД, но теперь мы попробуем сделать это программно, а не вручную. Для этого закомментируем наш код в файле initDB.sql, и добавим одну строчку:

```sql
-- CREATE TABLE IF NOT EXISTS clients
-- (
--     id    BIGSERIAL PRIMARY KEY ,
--     name  VARCHAR(200) NOT NULL ,
--     email VARCHAR(254) NOT NULL ,
--     phone VARCHAR(20)  NOT NULL
-- );
DROP TABLE IF EXISTS clients
```

Запустим программу, перейдем в pgAdmin, нажмем ПКМ на «Таблицы» (в нашей базе данных customers) - -> «Обновить», и увидим, что наша таблица пропала. NB! Будьте осторожны с использованием этой команды, иначе вы рискуете потерять все данные, которые были в вашей таблице! Вернемся в файл initDB.sql и перепишем его следующим образом:

```sql
CREATE TABLE IF NOT EXISTS clients
(
    id    SERIAL PRIMARY KEY ,
    name  VARCHAR(200) NOT NULL ,
    email VARCHAR(254) NOT NULL ,
    phone VARCHAR(50)  NOT NULL
);
```

Здесь мы поменяли тип id на SERIAL, что соответствует типу Integer, который мы используем для поля id в нашей программе. Кроме того, была увеличена максимальная длина поля phone, чтобы мы могли свободно использовать пробелы и специальные символы (скобки, тире и др.) в его написании. Максимальное количество цифр в телефонном номере на данный момент составляет 18 цифр (если мне не изменяет память). Я установил размер в 50 символов, чтобы хватило наверняка. Перейдем в файл application.properties, раскомментируем строку:

```java
spring.datasource.data=classpath*:database/populateDB.sql
```

Запустим нашу программу, зайдем в pgAdmin, проверим что наша таблица создана, И закомментируем эту строку обратно.

```java
#spring.datasource.data=classpath*:database/populateDB.sql
```