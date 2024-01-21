workspace {

    #softwareSystem <name> [description] [tags]
    #container <name> [description] [technology] [tags]

    !docs docs
    !adrs adrs

    model {

        properties {
            "structurizr.groupSeparator" "/"
        }

        # Внешние системы и сервисы
        bigBank = softwareSystem "Big bank API" "Платежный сервис BigBank" "External System"
        smallBank = softwareSystem "Small bank API" "Платежный сервис SmallBank" "External System"

        user = person "Покупатель"

        group "Между скобок" {
            kafka = softwareSystem "Kafka" "Message broker" "Infrastructure,Kafka"
            #prometeus = softwareSystem "prometeus" "Prometeus" "Infrastructure"
            
            webSite = softwareSystem "Web-сайт" "" "Internal System"

            gatewayService = softwareSystem "API-гейтвей" "API-гейтвей для сайта" {
                gatewayApp = container "API-гейтвей Backend" "" "Spring WebFlux"
                gatewayCache = container "Кэш" "" "Redis" "Cache"
            }

            customerService = softwareSystem "Сервис клиентов" "Сервис для управления клиентами" {
                customerApp = container "Backend сервиса клиентов" "" "Spring Web MVC"
                customerDB = container "База данных" "" "PostgreSQL" "Database"
            }

            

            # group "PaymentApp" {
                payGatewayService = softwareSystem "Сервис платежей" "Сервис для проведения оплат через внешних провайдеров" {
                    payGatewayApp = container "Backend сервиса платежей" "" "Spring Web MVC"
                    payGatewayDB = container "База данных" "" "PostgreSQL" "Database"
                    payGatewaySchedulerApp = container "Планировщик сервиса платежей" "" "Spring Quartz"

                    payBigBankApp = container "Backend коннектора к BigBank" "" "Spring Web MVC"
                    paySmallBankApp = container "Backend коннектора к Small Bank" "" "Spring Web MVC"
                }

                # payBigBankService = softwareSystem "Коннектор к Big Bank" "Коннектор к платежному сервису Big Bank" {
                #     payBigBankApp = container "Backend коннектора к Big Bank" "" "Spring Web MVC"
                # }

                # paySmallBankService = softwareSystem "Коннектор к Small Bank" "Коннектор к платежному сервису Small Bank" {
                #     paySmallBankApp = container "Backend коннектора к Small Bank" "" "Spring Web MVC"
                # }
            # }
        }

        user -> webSite "Использует"

        ### gatewayService ###
        gatewayApp -> webSite "Получает запросы от" "JSON/HTTP"
        gatewayApp -> gatewayCache "Кэширует ответы в"

        ### customerService ###
        customerApp -> gatewayApp "Получает запросы через" "JSON/HTTP"
        customerApp -> customerDB "Хранит заказы в" "JDBC"
        #тут есть проблема
        customerApp -> kafka "Получает статусы платежей из"

        ### paymentService ###
        payGatewayApp -> gatewayApp "Получает запросы на оплату через" "JSON/HTTP"
        payGatewayApp -> payGatewayDB "Хранит платежи в" "JDBC"
        payGatewayApp -> customerApp "Получает информацию о клиенте из" "JSON/HTTP"
        payGatewayApp -> kafka "Отправляет статусы платежей в"
        payGatewaySchedulerApp -> payGatewayDB "Получает зависшие платежи из" "JDBC"
        payGatewaySchedulerApp -> payGatewayApp "Повторяет платежи через" "JSON/HTTP"

        payBigBankApp -> payGatewayApp "Получает запросы из" "JSON/HTTP"
        payBigBankApp -> bigBank "Отправляет запросы в" "JSON/HTTP"
        paySmallBankApp -> payGatewayApp "Получает запросы из" "JSON/HTTP"
        paySmallBankApp -> smallBank "Отправляет запросы в" "JSON/HTTP"
    }

    #systemContext <software system identifier> [key] [description]
    views {
        systemLandscape "SystemLandscape" {
            include *
            #autoLayout bt

            #!script groovy {
            #    workspace.model.softwareSystems.findAll { it.group == "Group 1" && it.hasTag("Tag 1") }.each{ view.add(it); };
            #}
        }

        ### gatewayService ###
        systemContext gatewayService "gatewayServiceContext" "Gateway Service Context Diagram" {
            include *
            exclude *->*
            include *->gatewayService
            include gatewayService->*
            autoLayout
        }
        container gatewayService "gatewayServiceContainers" "Gateway Service Containers Diagram" {
            include *
            exclude "element.type==softwareSystem->element.type==softwareSystem"
            autoLayout
        }

        ### customerService ###
        systemContext customerService "customerServiceContext" "Customer Service Context Diagram" {
            include *
            exclude *->*
            include *->customerService
            include customerService->*
            autoLayout
        }
        container customerService "customerServiceContainers" "Customer Service Containers Diagram" {
            include *
            exclude "element.type==softwareSystem->element.type==softwareSystem"
            autoLayout
        }

        ### paymentService ###
        systemContext payGatewayService "payGatewayServiceContext" "Payment Service Context Diagram" {
            include *
            exclude *->*
            include *->payGatewayService
            include payGatewayService->*
            autoLayout
        }
        container payGatewayService "payGatewayServiceContainers" "Payment Service Containers Diagram" {
            include *
            exclude "element.type==softwareSystem->element.type==softwareSystem"
            autoLayout
        }


        # systemContext payBigBankService "payBigBankServiceContext" "Pay BigBank Service Context Diagram" {
        #     include *
        #     exclude *->*
        #     include *->payBigBankService
        #     include payBigBankService->*
        #     autoLayout
        # }
        # container payBigBankService "payBigBankServiceContainers" "Pay BigBank Service Containers Diagram" {
        #     include *
        #     exclude "element.type==softwareSystem->element.type==softwareSystem"
        #     autoLayout
        # }

        # systemContext paySmallBankService "paySmallBankServiceContext" "Pay SmallBank Service Context Diagram" {
        #     include *
        #     exclude *->*
        #     include *->paySmallBankService
        #     include paySmallBankService->*
        #     autoLayout
        # }
        # container paySmallBankService "paySmallBankServiceContainers" "Pay SmallBank Service Containers Diagram" {
        #     include *
        #     exclude "element.type==softwareSystem->element.type==softwareSystem"
        #     autoLayout
        # }


        theme default
        styles {
            element "Element" {
                shape RoundedBox
            }
            element "Person" {
                shape Person
            }
            element "External System" {
                background #999999
                color #000000
            }
            element "Infrastructure" {
                background  #1abc9c
                color #ffffff
            }
            element "Internal System" {
                background #6600cc
                color #ffffff
            }
            element "Software System" {
                background #1168bd
                color #ffffff
            }
            element "Container" {
                background #438dd5
                color #ffffff
            }
            element "Component" {
                background #85bbf0
                color #000000
            }
            element "Database" {
                shape Cylinder
            }
            element "Kafka" {
                shape Pipe
            }
        }
    }
}