#rust #rocket

#[get("/")] -> мапим страницу ,которая возвращает строку  ""Main Page""

```rust
#[get("/")]  
fn index()->&'static str{  
    "Main Page"  
}  
  
#[get("/mainpage")]  
  
fn main_page()->&'static str{  
    "Main offer Page"  
}  
  
#[launch]  
fn rocket()-> _ {  
    rocket::build().mount("/", routes![index]).mount("mainpage",routes![main_page])  
}
```
