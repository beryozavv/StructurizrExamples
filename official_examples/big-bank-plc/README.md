# Big bank PLC

Здесь представлены разные виды подключения зависимостей.
В internet-banking-system подключаются модели extends ../model.dsl и расширяются
В system-landscape аналогично подключаются модели, но расширяются через url : 
```js
!ref internetbankingsystem {
            url https://structurizr.com/share/36141/diagrams#SystemContext
        }
```

А workspace.dsl (файл в каталоге big-bank-plc) демонстрирует реализацию всех диаграмм в одном файле без подключения доп источников 