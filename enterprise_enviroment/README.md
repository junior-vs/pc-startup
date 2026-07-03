# Ambiente de desenvolvimento local

Stack completa para desenvolvimento Java (Quarkus / Spring) com observabilidade.

## Estrutura

```
.
├── .env
├── docker-compose.yml
└── config/
    ├── prometheus/
    │   └── prometheus.yml
    ├── otel/
    │   └── config.yaml
    ├── logstash/
    │   └── pipeline/
    │       └── logstash.conf
    └── grafana/
        └── provisioning/
            └── datasources/
                └── datasources.yaml
```

## Subindo o ambiente

```bash
# Ajuste as portas expostas no arquivo .env quando necessário.

# Subir tudo
docker compose up -d

# Acompanhar logs
docker compose logs -f

# Subir só os bancos de dados
docker compose up -d postgres redis mongodb

# Parar tudo preservando volumes
docker compose stop

# Destruir tudo incluindo volumes
docker compose down -v
```

## Endereços

| Serviço          | URL / Endpoint                    | Credenciais     |
|------------------|-----------------------------------|-----------------|
| Grafana          | http://localhost:3000             | admin / admin   |
| Prometheus       | http://localhost:9090             | —               |
| Kibana           | http://localhost:5601             | —               |
| Keycloak         | http://localhost:8180             | admin / admin   |
| PostgreSQL       | localhost:5432                    | dev / dev       |
| Redis            | localhost:6379                    | senha: dev      |
| MongoDB          | localhost:27017                   | dev / dev       |
| Elasticsearch    | http://localhost:9200             | —               |
| OTLP gRPC        | localhost:4317                    | —               |
| OTLP HTTP        | localhost:4318                    | —               |

## Configuração da aplicação Quarkus

Adicione ao `application.properties`:

```properties
# OTLP (traces + métricas)
quarkus.otel.exporter.otlp.endpoint=http://localhost:4317
quarkus.otel.exporter.otlp.protocol=grpc

# Métricas Prometheus (scrape direto)
quarkus.micrometer.export.prometheus.enabled=true
quarkus.http.port=8081

# Keycloak OIDC
quarkus.oidc.auth-server-url=http://localhost:8180/realms/dev
quarkus.oidc.client-id=my-app
quarkus.oidc.credentials.secret=change-me
```

## Configuração da aplicação Spring Boot

Adicione ao `application.yml`:

```yaml
management:
  endpoints:
    web:
      exposure:
        include: health,info,prometheus
  metrics:
    export:
      prometheus:
        enabled: true

spring:
  application:
    name: my-service

logging:
  pattern:
    console: "%d{ISO8601} [%thread] %-5level %logger - %msg%n"

# OTLP via Spring Actuator + Micrometer OTLP
management:
  otlp:
    metrics:
      export:
        url: http://localhost:4318/v1/metrics
```

## Observações

- Todas as portas publicadas estão parametrizadas no arquivo `.env`.
- O ambiente evita a porta externa `8080`; por padrão o Keycloak é exposto em `8180:8080`.
- A stack de logs usa Elasticsearch + Logstash + Kibana (ELK).
- O Elasticsearch tem `xpack.security.enabled=false` para simplificar o dev.
  Nunca use essa configuração em produção.
- O Keycloak está em modo `start-dev` com banco em memória.
  Os realms são perdidos ao reiniciar o container. Para persistir, troque para PostgreSQL.
- O Prometheus já coleta a si mesmo e o endpoint de métricas do OpenTelemetry Collector.
  Isso evita dependência de `host.docker.internal`, o que simplifica o uso em Windows, WSL e Linux nativo.
