работает по принципу swith case в java

```rust
fn main() {
    let number = 3;

    match number {
        1 => println!("One"),
        2 => println!("Two"),
        3 => println!("Three"),
        _ => println!("Other"), // Если ни один из вариантов не совпадает
    }
}
```
