#archlinux #полезное 
[источник](https://losst.pro/ustanovka-paketov-archlinux)

# Установка пакетов ArchLinux

Все существующие дистрибутивы Linux для того, чтобы осуществлять операции по обновлению ПО и библиотек ОС в основном используют [пакетные менеджеры](https://losst.pro/package-manager). Пакетный менеджер является ключевой программой, который зачастую и отличает различие одного [дистрибутива](https://losst.pro/distribution) Linux от другого.

Содержание статьи

- [Общее описание технологии](https://losst.pro/ustanovka-paketov-archlinux#obshchee-opisanie-tehnologii)
- [История разработки ArchLinux](https://losst.pro/ustanovka-paketov-archlinux#istoriya-razrabotki-archlinux)
- [Установка пакетов в ArchLinux](https://losst.pro/ustanovka-paketov-archlinux#ustanovka-paketov-v-archlinux)
- [Установка пакетов ArchLinux](https://losst.pro/ustanovka-paketov-archlinux#ustanovka-paketov-archlinux)
    - [Установка пакетов Pacman](https://losst.pro/ustanovka-paketov-archlinux#ustanovka-paketov-pacman)
    - [Установка пакетов из AUR](https://losst.pro/ustanovka-paketov-archlinux#ustanovka-paketov-iz-aur)
    - [Графический интерфейс Pacman](https://losst.pro/ustanovka-paketov-archlinux#graficheskiy-interfeys-pacman)
- [Выводы](https://losst.pro/ustanovka-paketov-archlinux#vyvody)

## Общее описание технологии

Пакетный менеджер pacman является основным признаком дистрибутива ArchLinux. Archlinux pacman предназначен для установки программ и пакетов в дистрибутиве ArchLinux. pacman оперирует пакетами, которые, как и в случае с другими пакетными менеджерами представляют из себя бинарные архивы, содержащие некоторые данные для установки.

Pacman сам по себе может использоваться не только в ArchLinux и его производных, но и в прочих дистрибутивах. Возможна адаптация pacman для использования [RPM](https://losst.pro/ustanovka-rpm-paketov-v-linux), а также пакетов прочего типа, несовместимого со стандартным ArchLinux.

Pacman, как и RPM имеет возможность загрузки части пакета при обновлении. При работе pacman зачастую значительно быстрее обрабатывает транзакции, нежели это делает DPKG или RPM.

## История разработки ArchLinux

Первые версии ArchLinux на самом деле являлись просто некоторой сборкой [LFS](https://losst.pro/lts-linux-from-scratch), содержащим набор скриптов для сборки и развертывания дистрибутива. Очень долго, для установки самого дистрибутива pacman вообще не использовался, установочный образ содержал специализированную программу, называемую Arch Install Frimewere (AIF).

Сам по себе, дистрибутив в первых своих версиях содержал примитивную скрипт-сборочную пакетную систему, называемую Arch Build System (ABS). Суть такой примитивной пакетной системы заключался в предоставлении быстрого и удобного метода сборки пакетов из исходного кода. Но это не то, что хотел иметь собственно разработчик Arch Linux. По этой причине была разработана утилита pacman, которая и предназначалась для оперирования с уже собранными бинарными пакетами. ABS затем была переназначена для того, чтобы заниматься сборкой пакетов для pacman.

В дальнейшем, ABS в Archlinux позволил создать пользовательский репозиторий рецептов для сборки пакетов, называемый AUR. Из AUR возможна установка пакетов ArchLinux, которых нет даже в официальных репозиториях.

## Установка пакетов в ArchLinux

Установка пакетов ArchLinux, их обновление, а также их удаление как мы уже поняли выше, осуществляются при помощи pacman. Данная утилита достаточно проста. Рассмотрим команды ее синтаксис:

**$ sudo pacman [опция] <имя пакета>**

Вот основные опции программы, которые мы будем использовать:

- **-S** – установка программ в archlinux;
- **-Sw** - скачать пакет но не устанавливать;
- **-U** - установить локальный пакет;
- **-s** – поиск пакета;
- **-i** – информация;
- **-u** – обновить пакеты;
- **-y** – обновить списки пакетов из репозиториев;
- **-dd** – игнорирование зависимостей;
- **-g** – запрос информации о группе;
- **-l** – вывод пакетов в виде списка;
- **-o** – вывод в файл;
- **-R** – удаление;
- **-Q** – запрос к базе данных установленных пакетов;
- **-F** – поиск по файлам;
- **-D** – задание и изменение цели установки уже имеющегося пакета;
- **-R** - удалить пакет;
- **-Rn** - удалять резервные копии конфигурационных файлов;
- **-Rs** - удалять зависимости пакета;

Это основные опции, которые будут применяться в этой инструкции.

## Установка пакетов ArchLinux

Сначала рассмотрим как выполняется установка программ ArchLinux с помощью Pacman из официальных репозиториев, а потом остановимся на пользовательском репозитории AUR. Теперь рассмотрим основные команды pacman archlinux.

### Установка пакетов Pacman

Опции для pacman при использовании комбинируются в одну фразу, таким образом, например, для обновления репозиториев и обновления ОС команда будет выглядеть так:

 `sudo pacman -Suy`

![](https://losst.pro/wp-content/uploads/2017/08/archlinuxi13-e1501614703290-1024x696.png)

Порядок расстановки опций значения не имеет, за исключением только того, что основной ключ, указывающийся большой буквой должен быть первым.

Установка конкретного пакета:

 `sudo pacman -S [имя пакета]` 

[![](https://losst.pro/wp-content/uploads/2017/08/archlinuxi9-e1501614733736-1024x694.png)](https://losst.pro/wp-content/uploads/2017/08/archlinuxi9.png)

Удаление конкретного пакета:

 `sudo pacman -R [имя пакета]` 

[![](https://losst.pro/wp-content/uploads/2017/08/archlinuxi8-e1501614782548-1024x698.png)](https://losst.pro/wp-content/uploads/2017/08/archlinuxi8.png)

Принудительное удаление конкретного пакета, с игнорированием зависимостей:

 `sudo pacman -Rdd [имя пакета]` 

[![](https://losst.pro/wp-content/uploads/2017/08/archlinuxi7-e1501614817731-1024x694.png)](https://losst.pro/wp-content/uploads/2017/08/archlinuxi7.png)

Поиск пакета в репозиториях:

 `pacman -Ss [имя пакета]` 

[![](https://losst.pro/wp-content/uploads/2017/08/archlinuxi6-e1501614842819-1024x694.png)](https://losst.pro/wp-content/uploads/2017/08/archlinuxi6.png)

Получение информации о пакете:

 `pacman -Si [имя пакета]` 

[![](https://losst.pro/wp-content/uploads/2017/08/archlinuxi5-e1501614917575-1024x694.png)](https://losst.pro/wp-content/uploads/2017/08/archlinuxi5.png)

Поиск только среди установленных пакетов:

 `pacman -Qs [имя_пакета]`

[![](https://losst.pro/wp-content/uploads/2017/08/archlinuxi4-e1501614962137-1024x696.png)](https://losst.pro/wp-content/uploads/2017/08/archlinuxi4.png)

Просмотр списка всех установленных пакетов:

 `pacman -Qqe`

[![](https://losst.pro/wp-content/uploads/2017/08/archlinuxi3-e1501615007766-1024x694.png)](https://losst.pro/wp-content/uploads/2017/08/archlinuxi3.png)

Просмотр списка файлов пакета:

 `pacman -Ql [имя_пакета]`

[![](https://losst.pro/wp-content/uploads/2017/08/archlinuxi1-e1501615033934-1024x698.png)](https://losst.pro/wp-content/uploads/2017/08/archlinuxi1.png)

Очистка кэша:

 `sudo pacman -Scc`

[![](https://losst.pro/wp-content/uploads/2017/08/archlinuxi-1024x606.png)](https://losst.pro/wp-content/uploads/2017/08/archlinuxi.png)

### Установка пакетов из AUR

К сожалению, не все пакеты есть в официальных репозиториях, многие вам придется искать пакеты на стороне. Большинство пакетов уже собраны и подготовлены пользователями в репозитории AUR. Для этого можно использовать пакет pacaur. Его можно установить командой:

 `curl -o install.sh https://gist.githubusercontent.com/Tadly/0e65d30f279a34c33e9b/raw/pacaur_install.sh   $ sudo sh install.sh`

Теперь вы можете использовать те же опции что и в утилите pacman в pacaur чтобы пользоваться AUR, например, поиск пакета:

 `pacaur -Ss firefox`

[![](https://losst.pro/wp-content/uploads/2017/08/archlinuxi12-e1501615086436-1024x696.png)](https://losst.pro/wp-content/uploads/2017/08/archlinuxi12.png)

Установка пакета:

 `pacaur -S firefox`

### Графический интерфейс Pacman

Для любителей пользоваться графическим интерфейсом вместо терминала в ArchLinux есть утилита pamac. Это простой менеджер приложений, чем-то похожий на стандартный менеджер приложений Ubuntu:

[![](https://losst.pro/wp-content/uploads/2017/08/archlinuxi11-e1501615126693-1024x694.png)](https://losst.pro/wp-content/uploads/2017/08/archlinuxi11.png)

Для установки пакета достаточно открыть для него контекстное меню и нажать **"Установить"**:

[![](https://losst.pro/wp-content/uploads/2017/08/archlinuxi10-e1501615158456-1024x694.png)](https://losst.pro/wp-content/uploads/2017/08/archlinuxi10.png)

Удаление пакетов выполняется тем же образом.

## Выводы

В этой статье мы рассмотрели как выполняется установка пакетов ArchLinux различными способами. А также немного поговорили про историю разработки дистрибутива.