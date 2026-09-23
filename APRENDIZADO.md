# 🧠 APRENDIZADO — caderno de lições dos dois lados (VPS × PC)

> **Escritor:** apenas o Hermes (VPS). Append-only, datado, reversível só por destilação.
> Regras duradouras vivem no [`PLAYBOOK.md`](PLAYBOOK.md); aqui fica a **matéria-prima** com data,
> contexto e evidência. Antigravity escreve lições brutas no [`LOG.md`](LOG.md) (campo
> “Aprendizado”) — o Hermes promove para cá nas rodadas de conferência.
> Protocolo completo: PLAYBOOK §9.

<!-- Entrada mais recente ABAIXO desta linha. -->

## 2026-09-22

### 🚨 Watchdog: `deliver='all'` explode no WhatsApp morto
- **Medido:** cron `antigravity-log-watch` detectou o push do LOG (state avançou corretamente) mas
  `last_status=delivery_failed`: `deliver='all'` resolveu também o alvo `whatsapp:5531…@lid` →
  bridge `localhost:3000` (WhatsApp do perfil nunca pareou) → notificação inteira perdida.
- **Correto:** alertas pessoais usam alvo **explícito** `telegram:897220771` (padrão dos watchdogs
  `load-watchdog`/`webui-agent-watchdog`); `deliver='all'` só quando o alvo WhatsApp existir de fato.
- **Armadilha geral:** em `no_agent`, stdout consumido + delivery falho = **estado avança sem ninguém
  ser avisado** (sem retry). Depois de criar qualquer cron com alvo novo, conferir
  `last_status`/`last_delivery_error` no primeiro tique — não basta o script estar certo.

### ✅ 1ª rodada PC→GitHub: o que passou e o que faltou (PR #1482 / issue #1445)
- Passou com evidência: claim “pego esta” 23 min antes do PR, `closingIssuesReferences=[1445]`,
  1 arquivo no diff, autoria `webtecnica`, branch `fix/1445-*` = head, PT-BR, CI 8 pass/0 fail.
- **`pnpm cercas` foi declarado como “depende de POSIX” — falso.** Cercas é
  `vitest run --project cercas` (roda em qualquer SO com node); `test:shell` é que é bash de
  verdade. Ressalva registrada: **cercas entra na régua sempre**; a desculpa de ambiente só cola
  para `test:shell`/`test:db`(Docker).
- Faltou a linha obrigatória `- Status: ✅ TAREFAS CONCLUÍDAS` na entrada do LOG (o push sinalizou,
  mas o protocolo §7 manda a linha — repassada a instrução).

### 🎯 Escopo da issue #1478 (PC em trabalho) — decisões que não podem ser inventadas
- Bug: `lib/agent-engine/edge/llm/pricing.ts` só precifica Anthropic → OpenAI grava `NULL` →
  custo 0 **e teto de gasto nunca dispara** (M, sem migration/schema).
- **Fronteira de escopo:** adicionar entradas OpenAI com **fonte oficial citada** = escopo.
  Fallback “modelo desconhecido → custo estimado” = decisão de produto (a doutrina escolheu
  `NULL` de propósito) — se aparecer no PR, é para questionar na issue, não aceitar calado.
- Paralelo vivo: mesmo tema (pricing) no agent — PR nosso #119717 (MiMo); regra comum dos dois
  repos = **preço sem link da doc do provedor não entra**.
