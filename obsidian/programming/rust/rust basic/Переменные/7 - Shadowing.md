#rust  #теория 
**Shadowing** — возможность объявления новой переменную с тем же именем, что и предыдущая, в таком случае мы можем сказать, что первая затенена второй.

```rust
fn main() {
    let shadowed_binding: i16 = 1989;

    {
        println!("до затенения: {}", shadowed_binding);

        // Этот блок *затеняет* переменную из внешнего.
        // Заметьте что переменная - &'static str Строковые литералы.
        let shadowed_binding = "zeliboba";

        println!("затенна внутринним блоком: {}", shadowed_binding);
    }
    println!("снаружи: {}", shadowed_binding);

    // Тут *затеняем* переменную из этого блока.
    let shadowed_binding: u32 = 42069;
    println!("тень в томже блоке: {}", shadowed_binding);
}
```

```no-highlight
Standard Output
до затенения: 1989
затенна внутринним блоком: zeliboba
снаружи: 1989
тень в томже блоке: 42069
```