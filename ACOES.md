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
2026-09-23 | antigravity | agent | 10 CRs resolvidos em 2 lotes de cinco: #91094→b604a20, #91101→0161c57, #92031→4022a27, #91575→898ca23, #91604→9dfa92e, #107604→1da1e60, #90991→e379f88, #104627→15070b9, #91580→13992ea, #91098→567be7f | 10 PRs | done
2026-09-23 | antigravity | deskcomm | issue #1542 → PR #1548 (gerar slug com hifen em etapas criadas pela tela) | #1548 / 885f395 | open
2026-09-23 | antigravity | deskcomm | issue #1541 → PR #1549 (ajustar owner_kind para human na acao assign_owner) | #1549 / 332da1f | open
2026-09-23 | antigravity | deskcomm | issue #1512 → PR #1550 (suportar baseUrl com ou sem /v1 na transcricao) | #1550 / 06d3bc1 | open
2026-09-23 | antigravity | deskcomm | issue #1493 → PR #1551 (isolar atualizacao de template zernio por session_id) | #1551 / 5394a23 | open
2026-09-23 | antigravity | deskcomm | issue #1399 → PR #1552 (gravar ctwa_clid em ad_source_id e preservar ad_id) | #1552 / 811ecc0 | open
2026-09-23 | antigravity | deskcomm | issue #1434 → PR #1553 (e2e trunk-sip host sem letras puras) | #1553 / 74deaac | open
2026-09-23 | antigravity | deskcomm | issue #1426 → PR #1554 (adicionar META_WEBHOOK_BASE_URL) | #1554 / d89812b | open
2026-09-23 | antigravity | deskcomm | issue #1436 → PR #1555 (crm_find_free_slots tolera dia e dias_a_frente) | #1555 / 2120296 | open
2026-09-23 | antigravity | deskcomm | issue #1491 → PR #1556 (freio de envio por token antes de abrir conversa e teto org) | #1556 / 74fb9bf | open
2026-09-23 | antigravity | deskcomm | issue #1246 → PR #1557 (cerca de escrita em organizations com escopo lexico e exports) | #1557 / d680f1a | open
2026-09-24 | antigravity | agent | issue #120512 → PR #120967 (preservar NODE_EXTRA_CA_CERTS no Bitwarden backend) | #120967 / 42af175 | open
2026-09-24 | antigravity | agent | issue #120528 → PR #120971 (skill_manage delete nao remove skill essencial/fixada por caminho de categoria) | #120971 / e57135f | open
2026-09-24 | antigravity | agent | issue #120504 → PR #120974 (cron bash scripts no Windows usam bash nativo/Git bash e ignoram stub WSL bash.exe) | #120974 / a11020b | open
2026-09-24 | antigravity | agent | issue #120526 → PR #120979 (interpolar env placeholders ${VAR} em plugins portaveis mcp.json) | #120979 / b57aa87 | open
2026-09-24 | antigravity | agent | issue #120510 → PR #120987 (suprimir linhas preparing tool sob focus view ou tool_progress off) | #120987 / bebdf58 | open
2026-09-24 | antigravity | deskcomm | issue #1361 → PR #1572 (reconciliacao do vitest checa failed suites antes de alertar sonda cega) | #1572 / ad685d5 | open
2026-09-24 | antigravity | deskcomm | issue #1113 → PR #1574 (invariante configuracao de smtp e server-side only) | #1574 / 404dcbd | open
2026-09-24 | antigravity | deskcomm | issue #1488 (conferido na base: ja corrigido na 0386 / 50df9281e, liberada sem duplicata) | #1488 | closed
2026-09-24 | antigravity | deskcomm | issue #1313 → PR #1577 (declarar politica de retencao para candidatos de prospeccao) | #1577 / 6055537 | open
2026-09-24 | antigravity | webui | CR PR #7418 (lote 1/3): correcao pool credential delete com active profile env materialization | #7418 / 40974e4f | open
2026-09-24 | antigravity | webui | CR PR #7367 (lote 1/3): bare paths com backtick literal preservados em MEDIA_REF_CLASS e wrap backtick suportado | #7367 / d695819d | open
2026-09-24 | antigravity | webui | CR PR #7284 (lote 1/3): isolamento de tupla em dismiss, post-await fence no poll e settle de live producers | #7284 / 3bb72f0d | open
2026-09-24 | antigravity | webui | CR PR #7559 (lote 2/3): identidade composta (session_id, profile) na busca CLI e regressao cross-profile | #7559 / e0beabaf | open
2026-09-24 | antigravity | webui | CR PR #7399 (lote 2/3): cache estrito profile-scoped live models, guarda de falha obsoleta e docs de arquitetura | #7399 / 84ba014f | open
2026-09-24 | antigravity | webui | CR PR #7292 (lote 2/3): autoridade uniforme _entryProvider em todas ramificacoes e option top-level preservada | #7292 / c2bc3cbc | open
2026-09-24 | antigravity | webui | CR PR #7417 (lote 3/3): fallback do schema para reasoning em raciocinio puro e retry de fragmento truncado | #7417 / 31fd7195 | open
2026-09-24 | antigravity | webui | CR PR #7156 (lote 3/3): supressao de badge (default) duplicado no cartao e dropdown de perfis | #7156 / 2c727e61 | open
2026-09-24 | antigravity | webui | CR PR #6946 (lote 3/3): escopo estrito OpenRouter em _providerQualifiedPresetRest e canonicalizacao de settings save | #6946 / da90bc00 | open




