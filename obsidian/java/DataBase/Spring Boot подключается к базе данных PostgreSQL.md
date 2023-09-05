#db #java #postgresql #spring
database superuser
pass:ASD837!7dsfk
port5432
login:vremyavnikuda
pass:Isdhig123

[[PostgreSQL]]

```
Installation Directory: C:\Program Files\PostgreSQL\15

Server Installation Directory: C:\Program Files\PostgreSQL\15

Data Directory: C:\data

Database Port: 5432

Database Superuser: postgres

Operating System Account: NT AUTHORITY\NetworkService

Database Service: postgresql-x64-15

Command Line Tools Installation Directory: C:\Program Files\PostgreSQL\15

pgAdmin4 Installation Directory: C:\Program Files\PostgreSQL\15\pgAdmin 4

Stack Builder Installation Directory: C:\Program Files\PostgreSQL\15

Installation Log: C:\Users\user1\AppData\Local\Temp\install-postgresql.log
```
____
### Spring Boot подключается к базе данных PostgreSQL

В этом руководстве по загрузке Spring вы узнаете, как настроить и написать код для подключения к серверу базы данных PostgreSQL в приложении Spring Boot. Я поделюсь с вами двумя распространенными способами:

-   Используйте Spring JDBC с JdbcTemplate для подключения к базе данных PostgreSQL
-   Используйте Spring Data JPA для подключения к базе данных PostgreSQL

Чтобы подключить приложение Spring Boot к базе данных PostgreSQL, вам необходимо выполнить следующие действия:

-   Добавьте зависимость для драйвера PostgreSQL JDBC, который необходим, чтобы приложения Java могли взаимодействовать с сервером базы данных PostgreSQL.
-   Настройте свойства источника данных для информации о подключении к базе данных
-   Добавьте зависимость для Spring JDBC или Spring Data JPA, в зависимости от ваших потребностей:
    -   Используйте Spring JDBC для выполнения простых инструкций SQL
    -   Используйте Spring Data JPA для более расширенного использования, например, для сопоставления классов Java с таблицами и объектов Java со строками, а также воспользуйтесь преимуществами Spring Data JPA API.

Ниже приведены подробные сведения о конфигурации и примерах кода.
___
## 1. Добавьте зависимость для драйвера PostgreSQL JDBC


Объявите следующую зависимость в вашем проекте pom.xml  файл:
```
<dependency>  
    <groupId>org.postgresql</groupId>  
    <artifactId>postgresql</artifactId>  
    <scope>runtime</scope>  
</dependency>
```
___
## 2. Настройте свойства источника данных

Далее вам необходимо указать некоторую информацию о подключении к базе данных в файле конфигурации приложения Spring Boot (application.properties) следующим образом:
```java
spring.datasource.url=jdbc:postgresql://localhost:5432/shopme
spring.datasource.username=postgres
spring.datasource.password=password
```

Здесь URL-адрес JDBC указывает на сервер базы данных PostgreSQL, работающий на localhost. Обновите URL-адрес JDBC, имя пользователя и пароль в соответствии с вашей средой.
___
## 3. Подключитесь к базе данных PostgreSQL с помощью Spring JDBC

В простейшем случае вы можете использовать Spring JDBC с JdbcTemplate для работы с реляционной базой данных. Итак, добавьте следующую зависимость в файл вашего проекта Maven:
```
<dependency>  
    <groupId>org.springframework.boot</groupId>  
    <artifactId>spring-boot-starter-jdbc</artifactId>  
</dependency>
```
И следующий пример кода относится к консольной программе Spring Boot, использующей JdbcTemplate для выполнения инструкции SQL Insert:
```java
package net.codejava;
 
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.jdbc.core.JdbcTemplate;
 
@SpringBootApplication
public class SpringJdbcTemplate2PostgreSqlApplication implements CommandLineRunner {
 
    @Autowired
    private JdbcTemplate jdbcTemplate;
     
    public static void main(String[] args) {
        SpringApplication.run(SpringJdbcTemplate2PostgreSqlApplication.class, args);
    }
 
    @Override
    public void run(String... args) throws Exception {
        String sql = "INSERT INTO students (name, email) VALUES ("
                + "'Nam Ha Minh', 'nam@codejava.net')";
         
        int rows = jdbcTemplate.update(sql);
        if (rows > 0) {
            System.out.println("A new row has been inserted.");
        }
    }
}
```

Эта программа вставит новую строку в таблицу students в базе данных PostgreSQL, используя Spring JDBC, который представляет собой тонкий API, построенный поверх JDBC.

Для получения подробной информации об использовании Spring JdbcTemplate я рекомендую вам прочитать [это руководство](https://www.codejava.net/frameworks/spring-boot/how-to-use-jdbc-with-spring-boot).
___
## 4. Подключитесь к базе данных PostgreSQL с помощью Spring Data JPA

Если вы хотите сопоставить классы Java с таблицами, а объекты Java - со строками и воспользоваться преимуществами инфраструктуры объектно-реляционного отображения (ORM), такой как Hibernate, вы можете использовать Spring Data JPA. Итак, объявите следующую зависимость для вашего проекта:

```
<dependency>  
    <groupId>org.springframework.boot</groupId>  
    <artifactId>spring-boot-starter-data-jpa</artifactId>  
</dependency>
```
Помимо URL-адреса JDBC, имени пользователя и пароля, вы также можете указать некоторые дополнительные свойства следующим образом:
```java
spring.jpa.hibernate.ddl-auto=update
spring.jpa.show-sql=true
spring.jpa.properties.hibernate.format_sql=true
spring.jpa.properties.hibernate.dialect=org.hibernate.dialect.PostgreSQL81Dialect
```

И вам нужно закодировать класс сущностей (класс POJO Java) для сопоставления с соответствующей таблицей в базе данных следующим образом:

```java
package net.codejava;
 
import javax.persistence.*;
 
@Entity
@Table(name = "students")
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;
 
    private String name;
    private String email;
 
    // getters and setters...
}
```
Затем вам нужно объявить интерфейс репозитория следующим образом:

```java
package net.codejava;
 
import org.springframework.data.jpa.repository.JpaRepository;
 
public interface StudentRepository extends JpaRepository<Student, Integer> {
 
}
```
И затем вы можете использовать этот репозиторий в контроллере Spring MVC или бизнес-классе следующим образом:
```java
@Controller
public class StudentController {
    @Autowired
    private StudentRepository studentRepo;
       
    @GetMapping("/students")
    public String listAll(Model model) {
        List<Studnet> listStudents = studentRepo.findAll();
        model.addAttribute("listStudents", listStudents);
           
        return "students";
    }
}
```

Я рекомендую вам ознакомиться с этой статьей: [Понять Spring Data JPA на простом примере](https://www.codejava.net/frameworks/spring/understand-spring-data-jpa-with-simple-example), чтобы узнать больше о Spring Data JPA.

Это несколько примеров кода для подключения к базе данных PostgreSQL в Spring Boot. Как вы видели, Spring Boot значительно упрощает программирование, и вы можете выбрать использование Spring JDBC или Spring Data JPA.