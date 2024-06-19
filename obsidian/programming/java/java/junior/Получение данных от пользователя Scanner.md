#java #примерыкода #javacore

>Пример кода получения данных от пользователя

```java
public class Main{
	public static void main (String []args){
		String s1 = sc.next(); // получает строку до первого пробела
		String s2 = sc.nextLine(); // считывает следующую строку полностью
		int i =sc.nextInt(); // считывает цельночисленные значения 
		double d =sc.nextDoube(); // считывает значения double
		float f =sc.nextFloat(); // считывает значения float
		boolean b = sc.nextBoolean(); // считывает значения boolean
	
	}
}
```

```java
public class Main{
	public static void main (String []args){
		// readNumber выступает в роли контейнера для стандартного метода Scanner 
		Scanner readNumber=new Scanner(System.in);
		int a = readNumber.nextInt();
		int b = readNumber.nextInt();
		System.out.println(a + b);	
	}
}
```

> Если в одной строке нужно вывести несколько значений ,по можно воспользоваться командой `+`

```java
class Main{
	public static void main(String []args){
		int a=5;
		String b= "end";
		System.out.println("Это еще не " + b + ". a" + a);
		// Используй скобки ,если значения сначало надо вычислить
		System.out.println("a + 4 = " + (a+4)); 
	}	
}
```