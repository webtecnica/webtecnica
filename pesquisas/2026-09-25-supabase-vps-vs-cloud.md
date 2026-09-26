# Supabase na VPS self-hosted × Cloud Free — pesquisa (2026-09-25)

> Contexto: instalar o DeskcommCRM numa VPS igual à atual (4 vCPU AMD EPYC 9634,
> 7,7 GB RAM, 251 GB disco — Netcup RS 2000 G12, medida em 25/09).
> Status: **pesquisa apenas** — nenhuma instalação/mudança foi feita.

## 1) Requisitos do kit do CRM (README oficial do repo)

| Item | Exigência |
|---|---|
| Arquitetura | **x86_64/amd64** (ARM64 não suportado pelo kit) |
| RAM | **4 GB recomendados** — "sobe com 2 GB, mas operar é outra coisa" |
| Contêineres do app | **7**, incluindo **WAHA ~150 MB por sessão WhatsApp + ~300 MB de overhead do Node** |
| Portas | 80/443 (Caddy do kit; detecta Traefik da hospedagem e se adapta via `REVERSE_PROXY=traefik`) |
| Docker | Compose v2 — o `install.sh` instala sozinho se faltar |
| docs/deploy-selfhost | "VPS Linux (**2 vCPU / 4 GB+**) com Docker"; build de imagem exige ≥4 GB (~15–25 min) |

## 2) Supabase self-hosted (docs oficiais + guias 2026)

| | Mínimo | Recomendado |
|---|---|---|
| RAM | 4 GB | **8 GB+** |
| CPU | 2 cores | 4+ |
| Disco | 40 GB SSD | 80 GB+ SSD |

- Stack = **11–13 contêineres** (Postgres, Auth/GoTrue, PostgREST, Realtime, Storage, Kong, Studio…).
- Na prática, 4 GB fica **apertado sob carga** (Studio é o container mais pesado).
- Kit do CRM pinado em `SUPABASE_REF=self-hosted/v0.8.1` (compose próprio + override).

## 3) Dimensionamento com os dois juntos na VPS atual

- CRM (~2–3 GB) + Supabase (~2–3 GB) + WAHA (~0,5–1 GB/sessão) + Caddy/agent ≈ **4–5 GB de 8 GB → cabe com folga**.
- VPS de 4 GB: tudo junto + WAHA = no limite, exige swap.

## 4) Supabase **Free** (cloud) — limites vigentes 2026 (4 fontes concordando)

- **Pausa automática após 7 dias de inatividade** (restauração manual) ← incompatível com CRM/bot 24/7
- **500 MB de banco** (compute compartilhado, ~500 MB RAM)
- **1 GB de storage** · **5 GB egress + 5 GB cached egress**
- **2 projetos ativos** · 50.000 MAUs · 200 conexões realtime · 500 mil invocations de Edge Functions
- **SEM backups, SEM SLA**, só suporte da comunidade
- Estourou: **Pro US$ 25/mês** (8 GB de banco, backups diários, sobretaxa por uso)

## 5) Veredito: self-host na VPS

1. O produto é vendido como **"self-hosted de verdade — seus dados na sua VPS"**; cloud free contradiz a proposta.
2. O kit é desenhado para self-host: pin de versão, override, `sincronizar_signup_mode_do_gotrue` gravando no `.env` local, `backup.sh`/`restore.sh`/`update.sh` de 1 comando — cloud free sai do caminho testado.
3. Latência: loopback na mesma VPS × VPS→internet→VPS por query/webhook.
4. Uptime 24/7 (cron de eventos a cada minuto, automações, WhatsApp) incompatível com o pause de 7 dias.
5. Backups próprios (kit tem) × **nenhum** no free.
6. Custo: VPS fixa × free→Pro US$ 25/mês por cliente (come a margem).

**Conclusão:** produção = self-host completo na VPS 4 vCPU/8 GB (com cron de backup e swap de segurança); cloud free = só teste/dev; cloud Pro = só se decidir não administrar banco e aceitar US$ 25/mês por cliente.

## Fontes
- Kit do repo: `hostgator-setup-kit/README.md` §Requisitos do VPS; `docs/deploy-selfhost/README.md`
- Supabase docs (self-hosting/docker): requisitos mínimos/recomendados
- Limites free: jetadmin.io, designrevision.com (jul/2026), metacto.com, makerkit.dev, uibakery.io (consenso)
