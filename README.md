Запустите контейнеры из docker-compose.yaml

Для контейнера structurizr_cli нужно узнать айпи контейнера structurizr_premises внутри контура доккера. 
Для этого выполняем команды:

    ```powershell
    docker ps -a # находим среди них id нашего контейнера structurizr_premises, например id = 2b8063e53fcb
    
    #делаем анализ контейнера и находим его ip
    docker inspect --format "{{ .NetworkSettings.IPAddress }}" 2b8063e53fcb
    
    #далее подставляем этот ip в параметр url при запуске structurizr_cli
    ```
В каталоге alex_example пример из репозитория: https://github.com/Alterant-zz/between-brackets-c4

В каталоге official_examples примеры из репозитория: https://github.com/structurizr/examples/tree/main/dsl

В каталоге temp_examples примеры из оф документации

Разработка диаграмм происходит следующим образом:
- Пишем dsl, например в райдере или vs-Code с плагином для structurizr, сохраняем изменения, чтобы увидеть результат.
- Подключаем в lite-версии наш dsl и по f5 смотрим результат после каждого изменения файла dsl
- Загружаем итоговый dsl в наш сервис onPremises через утилиту structurizr_cli командой push
- Коммитим изменения файла dsl в гит-репозиторий проекта