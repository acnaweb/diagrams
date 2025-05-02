workspace {

    !identifiers hierarchical

    model {
        user = person "Cliente do Banco"

        sistema = softwareSystem "Sistema Bancário" {
            web = container "Frontend Web" {
                technology "Angular"
                description "Interface para clientes acessarem serviços bancários"
            }

            backend = container "API Backend" {
                technology "Spring Boot"
                description "Exposição de serviços via REST"

                authService = component "AuthService" {
                    technology "Spring Security"
                    description "Valida tokens JWT e regras de acesso"
                }

                accountService = component "AccountService" {
                    technology "Spring Bean"
                    description "Gerencia lógica de contas bancárias"
                }

                transactionService = component "TransactionService" {
                    technology "Spring Bean"
                    description "Processa transferências e pagamentos"
                }

                authService -> accountService "Valida acesso a conta"
                transactionService -> accountService "Consulta saldo"
            }

            kafka = container "Kafka" {
                technology "Apache Kafka"
                description "Fila de mensagens para eventos financeiros"
                tags "Kafka"
            }

            pubsub = container "GCP Pub/Sub" {
                technology "Google Cloud Pub/Sub"
                description "Mensageria entre sistemas na nuvem"
                tags "Google Cloud Platform - Cloud PubSub"
            }

            cloudFunction = container "Cloud Function - Enriquecimento" {
                technology "GCP Cloud Function (Python)"
                description "Processa mensagens e aplica enriquecimento de dados"
                tags "Google Cloud Platform - Cloud Functions"
            }

            bigquery = container "BigQuery" {
                technology "Google BigQuery"
                description "Armazena dados analíticos e transacionais para relatórios"
                tags "Google Cloud Platform - BigQuery"
            }

            postgres = container "PostgreSQL" {
                technology "Cloud SQL (PostgreSQL)"
                description "Banco de dados principal com dados transacionais"
                tags "Google Cloud Platform - Cloud SQL"
            }

            user -> sistema.web "Usa via navegador"
            sistema.web -> sistema.backend "Chama API REST"
            sistema.backend -> sistema.kafka "Publica eventos"
            sistema.kafka -> sistema.pubsub "Encaminha eventos"
            sistema.pubsub -> sistema.cloudFunction "Dispara função com payload"
            sistema.cloudFunction -> sistema.bigquery "Insere dados enriquecidos"
            sistema.backend -> sistema.postgres "Consulta/atualiza dados transacionais"
        }

        antifraude = softwareSystem "Sistema Antifraude" {
            antifraudeService = container "Analisador de Fraudes" {
                technology "Cloud Run (Python)"
                description "Detecta padrões suspeitos em transações"
                tags "Google Cloud Platform - Cloud Run"
            }

            sistema.kafka -> antifraudeService "Envia eventos de transações"
            antifraudeService -> sistema.backend "Reporta transações suspeitas"
        }

        auditoria = softwareSystem "Sistema de Auditoria" {
            auditoriaService = container "Coletor de Logs" {
                technology "Dataflow + BigQuery"
                description "Processa e armazena logs operacionais"
                tags "Google Cloud Platform - Cloud Dataflow"
            }

            sistema.backend -> auditoriaService "Envia logs de auditoria"
            auditoriaService -> sistema.bigquery "Armazena logs para consultas"
        }

        notificacoes = softwareSystem "Sistema de Notificações Push" {
            notificacaoService = container "Dispatcher de Notificações" {
                technology "Cloud Function + Firebase Cloud Messaging"
                description "Envia notificações em tempo real para os clientes"
                tags "Google Cloud Platform - Cloud Functions"
            }

            antifraude.antifraudeService -> notificacaoService "Notifica usuário sobre fraude"
            sistema.backend -> notificacaoService "Envia notificações de operações"
        }
    }

    views {
        systemContext sistema {
            include *
            autolayout lr
            title "Contexto - Ecossistema Bancário Expandido"
        }

        container sistema {
            include *
            autolayout lr
            title "Containers - Sistema Bancário"
        }

        container antifraude {
            include *
            autolayout lr
            title "Containers - Sistema Antifraude"
        }

        container auditoria {
            include *
            autolayout lr
            title "Containers - Sistema de Auditoria"
        }

        container notificacoes {
            include *
            autolayout lr
            title "Containers - Sistema de Notificações Push"
        }

        component sistema.backend {
            include *
            autolayout lr
            title "Componentes - API Backend"
        }

        theme "https://static.structurizr.com/themes/google-cloud-platform-v1.5/theme.json"
    }
}
