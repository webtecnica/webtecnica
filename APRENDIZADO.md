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

## 2026-09-23

### 🪟 PC é Windows — o que muda na régua honesta (2ª rodada, PR #1486 / issue #1478)
- Confirmado no corpo do PR: **"ambiente local Windows"**. Medido:
  - `pnpm test:shell` = bash puro → não roda em Windows (sem WSL): declaração legítima.
  - `pnpm cercas` foi agrupado na mesma desculpa "POSIX/globs" — **não cola**: o mesmo runner
    (vitest) **rodou** no PC (40 testes do `pricing.test.ts`) e typecheck/lint/build (node)
    também. Cercas é `vitest run --project cercas`; se falhar no Windows, o "O que NÃO medi"
    tem que trazer o **erro da tentativa**, não a categoria do ambiente.
  - Juiz final = CI: verify do #1482 passou 13/13 (inclui cercas) — o risco só vira retrabalho
    quando o vermelho do CI aparece.
- **Regra destilada → PLAYBOOK §6.3:** "O que NÃO medi" = comando tentado + erro; mesmo runner
  já rodando no ambiente obriga a tentar o gate vizinho.
- Padrões que se confirmaram (2ª vez): linha `✅ TAREFAS CONCLUÍDAS` adotada; claim ~22 min antes
  do PR (03:07 vs 03:30); `.changes/` com crédito ao PR — e amendaram um commit só pra citar
  `#1486`, exatamente a regra do crédito; fonte oficial citada **no código** com data
  (`openai.com/api/pricing`, conferidas 2026-09) — ressalva da rodada 1 resolvida.
- Escopo conferido: 3 arquivos exatos (pricing.ts + teste + fragmento), 4 commits todos
  `webtecnica`, `Closes #1478` sem crases (`closingIssuesReferences=[1478]`), CI na conferência:
  3 pass / 12 pending / 0 fail. Delta: deskcomm abertos 2 (#1482+#1486), merged 125; agent 434 /
  webui 126 sem mudança. Watchdog detectou o push (state=`9cb9dba`) com alvo telegram corrigido.

### Onda de 4 CRs webui: economia medida + 2 incidentes + reconciliacao VPS x PC
- Economia (medida, state.db): onda inteira (semente + 4 filhos, 124 calls) = $0,094; os 3 CRs da 1a leva = ~$0,05 com review respondido, sabotagem e evidencia. Cache 6,63M vs 299K frios = 22x (-90,6% vs conta fria de $1,004). Gates do Jev (5 seeds) ~ $0,00014.
- Prefixo de subagente no MiMo medido = 15,7K tokens (nao 685K — era da era DeepSeek): cold start custa $0,002, nao $0,19. Warm-up no MiMo e seguro de latencia e de prefixo entre filhos, nao alavanca de $ (skill subagent-warmup-recovery ja corrigida).
- Incidente 1 (timeout): filho do #7098 preso 420s+ num pytest --collect-only -> timeout 2700s com diff parcial nao commitado; arremate despachado COM o estado medido no brief.
- Incidente 2 (filtro de seguranca da Xiaomi): arremate barrado com "high risk" ao redigir o RESUMO FINAL — mas commit (ccb23d1d), push e comentario no PR ja estavam feitos. Mensagem de "failed" nao e trabalho perdido: medir o disco/remote antes de reagir (state-in-git pagou 100%). Regra mantida: reportar, NUNCA trocar filho de modelo/provider.
- Reconciliacao VPS x PC (o ledger expoz em tempo real): o Antigravity rodou lote de 8 PRs webui em paralelo; #7647 = colaboracao provada por ancestry (nosso 5c1b1dea e ancestral do i18n d2ecf3d7 dele — findings 1+2 nossos, finding 4 dele); #7651/#7743 = heads nossos apesar do LOG dele reivindicar — ACOES.md existe justamente para separar feito x declarado.

## 2026-09-25

### 🚨 Force-push na branch do PR apagou 2 commits do mantenedor (Deskcomm #1651) — pedido explícito dele
- **Incidente:** o rebase da VPS (renumeração da migration do provedor custom 0412→0413) foi
  pushado com `--force-with-lease` 2 minutos depois de o mantenedor ter pushado 2 commits NA
  NOSSA branch do PR — os 2 commits dele foram apagados. Ele refiz em cima do nosso head novo
  (935f4af) só com commits novos, sem force; os nossos 7 commits continuam como estavam.
- **Pedido do mantenedor, vale para sempre:** "daqui para a frente, não use force-push nesta
  branch. Se precisar mudar algo, faça commit novo ou git pull antes. Assim o trabalho dos dois
  lados não se perde."
- **Por que o lease não salvou:** `--force-with-lease` só protege contra mudança CONCORRENTE
  depois do nosso fetch; commits alheios já existentes no remote são apagados conscientemente.
  A checagem correta é por commit e autoria, ANTES do force:
  `git fetch origin <branch> && git log --oneline HEAD..origin/<branch>` (tem commit de terceiro? ⇒ aborta).
- **Efeito colateral do rebase às cegas:** a troca 0412→0413 reescreveu também o 0412 da main
  (birthdate do #1546): linha do MANIFEST apontando para migration inexistente em disco + 3
  comentários do baseline.sql trocados. Renumeração só pode tocar referências NOSSAS — conferência
  obrigatória: `git diff upstream/<base> -- supabase/` deve mostrar só adições nossas.
- **Achado que virou bug nosso (corrigido por ele):** a rota `/revalidate` chamava o validador
  sem `base_url` → para provider `custom` respondia `base_url_ausente` e o botão Revalidar
  derrubava credencial que funciona. Todo chamador novo do validador precisa receber o endereço gravado.
- Destilado no PLAYBOOK §3, regra 2 (inspeção pré-force obrigatória + banido em branch com commit dele).
