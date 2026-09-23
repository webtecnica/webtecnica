# Agent instructions — workspace do Marcos (webtecnica)

**Se você (Antigravity, Codex, Cursor, Claude Code, etc.) acabou de abrir esta pasta: leia
[`PLAYBOOK.md`](PLAYBOOK.md) INTEIRO antes de qualquer ação.** Ele contém tudo: os 3
repositórios de contribuição (endereços, branch base, idioma, gates), regras de coordenação
VPS × PC, issues frescas, anti-duplicata e o protocolo de LOG.

## Arquivos deste repo

| Arquivo | Ler? | Escrever? | O quê |
|---|---|---|---|
| `PLAYBOOK.md` | ✅ sempre, primeiro | ❌ (só o Hermes atualiza) | doutrina viva |
| `APRENDIZADO.md` | ✅ útil (lições datadas dos dois lados) | ❌ (só o Hermes) | caderno de aprendizado |
| `LOG.md` | ✅ as entradas recentes (o outro lado já fez o quê) | ✅ **append-only**, só sua seção `## AAAA-MM-DD` | seu registro de trabalho |

## Se este é um reabrir sem contexto (sessão nova)

1. `git pull --rebase origin main` nesta pasta (ou clone
   `https://github.com/webtecnica/webtecnica.git`) — o playbook é a fonte, não a memória da
   conversa anterior: **você não retoma aprendizado de sessões passadas, ele está nos arquivos**.
2. Leia `PLAYBOOK.md` (seção 5.1 é obrigatória: coordenação anti-PR-duplicado).
3. Ao terminar ou interromper trabalho: entrada datada no `LOG.md` com a linha obrigatória
   `- Status: ✅ TAREFAS CONCLUÍDAS (…)` ou `- Status: ⛔ INTERROMPIDO: <motivo>` e `git push`
   (nunca `--force`) — o push é o sinal que dispara a notificação na VPS.
4. Regras de ouro: idioma por repo (Deskcomm = PT-BR; Hermes = EN), claim “pego esta” no
   Deskcomm antes de codar, `Closes #N` sem crases, gates rodados de verdade antes do PR.

Este arquivo existe para você não depender do bootstrap colado à mão: ele é o bootstrap.
