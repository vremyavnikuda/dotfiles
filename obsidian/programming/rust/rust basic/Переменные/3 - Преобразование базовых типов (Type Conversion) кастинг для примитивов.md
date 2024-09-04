#rust 
Rust требует полной ясности при работе с числами. Нельзя использовать тип `u8`, работая с типом `u32`: это ошибка.

К счастью, в Rust есть ключевое слово **as**, позволяющее очень легко преобразовывать типы.

Приведение типов позволяет нам преобразовывать переменные одного типа данных в другой. В **Rust** мы используем ключевое слово `as` для приведения типов.
```rust
fn main() {
    let a = 13u8;
    let b = 7u32;
    let c = a as u32 + b;
    println!("{}", c);

    let t = true;
    println!("{}", t as u8);
}

```

**Приведение чисел:**

```rust
// создаем переменную с плавающей точкой
let decimal: f64 = 54.321;

// кастуем float в int
let integer = decimal as u16;

// Output:
// decimal = 64.31
// integer = 64
```

**Приведение символов:**

```rust
fn main() {
    // только u8 может быть преобразован в char
    let character: char = 'A';
    println!("{}", type_of(&character));
    // char

    // char в u8 integer type
    let integer = character as u8;
    println!("{}", type_of(&integer));
    // u8

    // и обратно
    let back_to_character = integer as char;
    println!("{}", type_of(&back_to_character));
    // char
}

// Принимает ссылку на переменну и возвращает строковое представление типа, 
// например, "i8", "u8", "i32", "u32"
fn type_of<T>(_: &T) -> String {
    format!("{}", std::any::type_name::<T>())
}
```