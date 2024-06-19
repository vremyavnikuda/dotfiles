#теория #rust 
Функции могут возвращать несколько значений с помощью **кортежа** значений (tuple).

Доступ к значениям элементов кортежа осуществляется по их позиции внутри кортежа.

Rust поддерживает разные виды деструктуризации (destructuring), которые вы увидите в разных формах. Это позволяет извлекать части данных из структур удобным способом. Смотрите внимательно!

```rust
fn swap(x: i32, y: i32) -> (i32, i32) {
    return (y, x);
}

fn main() {
    // return a tuple of return values
    let result = swap(123, 321);
    println!("{} {}", result.0, result.1);

    // destructure the tuple into two variables names
    let (a, b) = swap(result.0, result.1);
    println!("{} {}", a, b);
}
```