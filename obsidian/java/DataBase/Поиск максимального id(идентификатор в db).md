#java #medianamager #идентификаторы #id
Поиск максимального id(идентификатор в db)
В файле interface репозитория нужно задать метод (максимального значения)
```java
public interface MediaRepository extends CrudRepository<Media, Integer> {  
  
    //запрос максимального значения idMedia данных в репозитории  
    @Query(value = "SELECT MAX(m.idMedia) FROM Media m")  
    Integer findMaxIdMedia();  
}
```

А в методе сохранения данных в репозиторий (db)
задать проверку наличия данных (id<- идентификаторов) в репозитории(db) и назначать идентификатор новому объекту медиа данных MaxIdMedia+1
```java
private final MediaRepository mediaRepository;
/*---------------------------------------------------*/
Integer maxIdMedia = mediaRepository.findMaxIdMedia();  
if (maxIdMedia!=null){  
    media.setIdMedia(maxIdMedia+1);  
}else {  
    media.setIdMedia(1);  
}  
  
mediaRepository.save(media);  
return media;
```
[[PostgreSQL]]
