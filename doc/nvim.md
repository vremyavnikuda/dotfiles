alt + i -> открыть терминал
tab -> сменить вкладку вправо
shift + tab -> сменить вкладку влево
space + e -> вернуться в дерево файлов
ctrl + n -> открыть закрыть  дерево файлов
space + n -> включить(отключить) отображение нумерации строк в ide
i -> режим редактирования файла
ctrl + n -> save file



space -> g -> t == по смотреть активный git status 
space -> c -> h == открывать список команд доступные на этом файле
space + b -> create new file buffer
space + x -> close buffer file (not save)
space -> t -> h == открыть меню тем для ide 


space -> w -> shift -> K == открывать весь список хоткеев


### git command

git init -> для создания нового репозитория
git clone <URL> -> клонировать репозиторий <- clone repo
git add <имя конкретного файла> <- если хотим добавить для коммита конкретный файл
git add . <- add all files -> for commit
git commit -m "Сообщение коммита" <- тут должен быть коммит
git status <- Просмотр статуса репозитория

#### Ветки
git branch <name>  <- (создать ветку) где name имя ветки 
git checkout <name> <- (переключиться на ветку) где name имя ветки
git checkout -b <name> (создать и переключиться на ветку) где name имя веткиш

### Набор стандартных действий
git status
git add .
git commit -m "Коммит об изменениях"
git push
git log
