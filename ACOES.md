# 🧾 ACOES — ledger de ações nos 3 repos: QUEM fez o quê

> **Append-only · UMA LINHA por ação · nunca reescrever linhas antigas.**
> Conflito de merge = `git pull --rebase` e **re-anexe a sua linha no fim**.
> Narrativa completa: [`PLAYBOOK.md`](PLAYBOOK.md) §7 · este arquivo é só o **LEDGER** para responder
> “quem executou” sem ler a narratura — filtro por executor/repo/data.

## Legenda de executores

- `[antigravity]` — Antigravity no PC do Marcos
- `[hermes:webui]` — agente Hermes (VPS) em sessão WebUI
- `[hermes:telegram]` — agente Hermes acionado via Telegram
- `[hermes:cron]` — crons/watchdogs da VPS
- `[hermes:vps]` — agente Hermes, outros contextos

Formato: `AAAA-MM-DD | executor | repo | ação | ref(s) | status`
Repo: `agent` | `webui` | `deskcomm` | `infra` (playbook/ecossistema)

---

2026-09-22 | hermes:webui | infra | PLAYBOOK + LOG publicados no repo webtecnica/webtecnica | c874071 | done
2026-09-22 | hermes:webui | infra | Watchdog antigravity-log-watch criado (15m, script-only) | cron 130d9c10f590 | done
2026-09-22 | hermes:webui | infra | deliver do watchdog corrigido: all → telegram:897220771 (WhatsApp morto na porta 3000) | cron 130d9c10f590 | done
2026-09-22 | antigravity | deskcomm | issue #1445 → PR #1482 — claim 02:32Z, closes verificado, CI 13/13 pass | #1482 / c4d6f4f | open
2026-09-23 | antigravity | deskcomm | issue #1478 → PR #1486 — pricing OpenAI + fonte citada, fragmento .changes creditado | #1486 / 7c93a50 | open
2026-09-23 | hermes:webui | infra | AGENTS.md criado (bootstrap automatico p/ agentes que abrem a pasta) | 7dd8353 | done
2026-09-23 | hermes:webui | infra | APRENDIZADO.md + PLAYBOOK §9 (ciclo de vida dos 3 arquivos) | f3428df | done
2026-09-23 | hermes:webui | infra | PLAYBOOK §5.1 — coordenacao VPS x PC (anti PR duplicado) | 892ae32 | done
2026-09-23 | hermes:webui | infra | warmup_cache.py corrigido no perfil (default era cheaperinference morto → lê delegation xiaomi/mimo) | scripts/warmup_cache.py | done
2026-09-23 | hermes:webui | webui | Onda de 4 CRs (deleg_8c420a9c): #7647 → 5c1b1dea, #7651 → 4b791bd8, #7743 → 301ed54a (comentarios de re-gate postados) | 3 PRs | done
2026-09-23 | hermes:webui | webui | CR #7098: filho estourou timeout (35 calls) — worktree c/ diff parcial NAO commitado → arremate despachado | #7098 / 8952b75 | andamento
2026-09-23 | hermes:webui | infra | ACOES.md criado + regras de marcação em todos os canais (PLAYBOOK §7, AGENTS.md, skill) | este arquivo | done
2026-09-23 | antigravity | deskcomm | issue #1451 → PR #1508 (inbox: contencao de layout e quebra de palavras) | #1508 / ccc9d05 | open
2026-09-23 | antigravity | deskcomm | PR #1509 (validacao de credenciais OpenRouter aceita gate) | #1509 / 863fe9d | open
2026-09-23 | antigravity | webui | Lote de CRs batch1+2: #7559→2ac61a5, #7610→6caa0c1 (CI rodando), #7284→17c9205; #7418 #7417 #7400 #7399 #7292 enviados | 8 PRs | done
2026-09-23 | antigravity | webui | #7647 follow-up i18n (18 locales) EMPILHADO no nosso 5c1b1dea (finding 4) — divisao complementar comprovada por ancestry | d2ecf3d7 | done
2026-09-23 | hermes:webui | webui | CR #7098 ARREMATE CONCLUIDO: commit ccb23d1d pushado + comentario no PR (13:55Z) — 2 filhos falharam (timeout pytest; filtro de seguranca do MiMo no resumo final), trabalho sobreviveu no git | #7098 / ccb23d1d | done
2026-09-23 | hermes:webui | webui | Onda webui FECHADA 4/4: #7098 ccb23d1d, #7647 5c1b1dea (+i18n do antigravity d2ecf3d7), #7651 4b791bd8, #7743 301ed54a | 4 CRs | done
