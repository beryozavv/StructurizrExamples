DSL позволяет описать модели и связи между моделями, а далее можно настроить отображение(view) любой нужной диаграммы на основе описания.
То есть мы описываем не диаграмму, а только модели системы.

Запустите контейнеры из docker-compose.yaml
Для контейнера structurizr_cli нужно узнать айпи контейнера structurizr_premises внутри контура доккера.
Для этого выполняем команды:
```powershell
    docker ps -a # находим среди них id нашего контейнера structurizr_premises, например id = 2b8063e53fcb
    
    #делаем анализ контейнера и находим его ip
    docker inspect --format "{{ .NetworkSettings.IPAddress }}" 2b8063e53fcb
    
    #далее подставляем этот ip в параметр url при запуске structurizr_cli
```

Разработка диаграмм происходит следующим образом:
- Пишем dsl, например в райдере или vs-Code с плагином для structurizr, сохраняем изменения
- Подключаем в lite-версии папку с нашим dsl и по f5 смотрим результат после каждого изменения файла dsl(после сохранения)
- Загружаем итоговый dsl в наш onPremises-сервис через утилиту structurizr_cli командой push
- Коммитим изменения файла dsl в гит-репозиторий проекта <br>
Все необходимые конфигурации structurizr_lite, structurizr_premises и structurizr_cli смотрите в docker-compose

В каталоге alex_example пример из репозитория: https://github.com/Alterant-zz/between-brackets-c4

В каталоге official_examples примеры из репозитория: https://github.com/structurizr/examples/tree/main/dsl

В каждом примере отдельный Readme для описания особенностей примера