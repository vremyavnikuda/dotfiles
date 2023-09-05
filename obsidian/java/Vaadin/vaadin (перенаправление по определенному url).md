#java #spring #vaadin #url

### Перенаправление по определенному url

```java
private void onUploadMediaButtonClick() {  
	uploadMediaButton.addClickListener(event -> {  
	UI.getCurrent().navigate("MediaManagerFolders/UploadMediaManagerFolders");  
	});  
}
```
- возможность привязать событие к кнопке перенаправление