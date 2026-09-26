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

### Carga na VPS (load 11) — 4 causas medidas e as correções que ficaram
- Pico de load 11 com CPU 96% ociosa e iowait 0 = espera de LOCK/FORK, não falta de CPU:
  3 clones paralelos do mesmo repo (0,5–1,6G cada) + 2 `pnpm install` no MESMO store +
  `typecheck` rodado FORA da lane única. Correção: **pré-voo do pai serializado** (clone+install
  ANTES do fan-out; filho não clona nem instala nem roda gate direto — só via fila).
- Heap fixo do worker (3072) derrubava o `tsc` do repo com rc=134 (SIGABRT) → filho RE-RODava o
  gate inteiro = trabalho pesado em dobro. Correção: default do worker subido (5120).
- Sem histórico de carga na máquina → instalado `sysstat` (coleta ativa) para forense futura.
- Estado órfão de job (`.state=running` com unit morto) enganava o status — limpar.

### 🔴 Gate VERDE FALSO — "o log mentiu"
- Job cujo comando usa binário ausente (`npx` não existe no PATH do worker) fecha `exit=0` com
  `command not found` e o marcador final VAZIO — rc do `bash -lc` é do último comando, não do
  que falhou. Antes de citar qualquer gate verde: `grep -c 'command not found' <log>` +
  conferir presença do marcador (`GATES_OK`/`exit=0` da etapa). Encontrado 2 vezes no mesmo dia
  (gates do #1642 e do #1660 deram "verde" sem nunca terem rodado o teste).

### Corrida de migration entre 2 PRs NOSSOS (0416 × 0416)
- Dois filhos mediram "próximo livre" antes de um empurrar o outro → mesmíssimo NNNN em 2 PRs.
  O checker da casa (`pnpm checar:colisao-de-migration`) avisa e dá a doutrina: **"quem entrar
  primeiro fica, e o outro renumera (NNNN e timestamp juntos)"**. Verificação cruzada: puxar a
  branch do irmão e rodar o checker ANTES de esperar o mantenedor notar. Renumeração = renomear
  arquivo + linha do MANIFEST + corpo do PR + re-rodar checker/cercas/test:shell + push normal.

### Corte de saldo/provider no MEIO da onda (HTTP 402) — recuperação sem perda
- Filho morre com 402 mas o **worktree preserva tudo** (árvore suja, commits, gates já medidos).
  Protocolo: (1) trocar provider/config e provar com sonda (filho-probe confirma o modelo novo);
  (2) PARAR os filhos ainda vivos no provider morto (steer não funciona — sem modelo não há
  raciocínio); (3) re-despachar 1:1 como "continue from partial" com o ESTADO MEDIDO no brief
  (arquivos, jobs de gate, o que falta); (4) reverter o provider depois, com cron one-shot de
  segurança caso a sessão caia. 3 cortes, 0 trabalhos perdidos.

### Revisão do mantenedor sem CR = NÃO agir
- Comentário do mantenedor do tipo "você não precisa fazer nada" (ele mesmo pushou os ajustes na
  nossa branch, ou ligou auto-merge) não é CR: ler INTEIRO, confirmar o que ele pushou
  (`git log origin/<branch>`) e ficar quieto — reagir de mais cria ruído em review alheio.

### Watchdog de reserva deduplica — varredura independente para "livres"
- O script de alerta de issues silencia para o que já foi alertado uma vez (estado de 30 dias):
  pedir "issues livres" exige varredura NOVA (sem estado) com as mesmas regras do protocolo —
  sem claim, sem assignee, sem label de bloqueio, sem PR cruzado. Em 25/09 a varredura achou
  11 livres enquanto o watchdog dizia "nada novo".

### Pesquisa de infra (salva, nada instalado)
- [`pesquisas/2026-09-25-supabase-vps-vs-cloud.md`](pesquisas/2026-09-25-supabase-vps-vs-cloud.md)
  — self-host na VPS × Supabase cloud free, todas as especificações (kit + Supabase + limites do free).
  Nada instalado; só pesquisa, salva para quando decidirmos subir o CRM numa VPS igual a esta.
## 2026-09-26

### Lote das 8 propostas 💡 — 3 entregas + revisão do mantenedor em 5 blocos (#1683/#1684/#1688)
- Reservas ("Pego esta") ×8, pré-voo serializado do pai, gate de seed em BATCH (1 request p/ 3
  seeds, rc por score) e onda de 3: as 3 primeiras issues saíram como PRs em ~1h44 de filho cada
  (todos com sabotagem medida e gates pela lane única).
- **A revisão longa do mantenedor tem 5 blocos**: leitura → "O que medi (head X)" → "O que NÃO
  medi" → **"O que falta, é com você"** (lista numerada do nosso desenho; ele não mexe por
  princípio) → **"o que é conosco"** (ele faz na nossa branch, com nosso nome). Fecha oferecendo
  dividir o PR. Resposta que funcionou: aceitar os itens, **decidir a pergunta de desenho**
  (1 PR só), confirmar a divisão de papéis e despachar com fix-spec medida.
- 🔴 **Auto-relato de filho não é prova**: o resumo disse "editor criado" e a branch tinha
  **0 ocorrências** — o mantenedor mediu antes. PR OPEN+MERGEABLE+`Closes` prova ESTADO, não
  CONTEúdo; claim de artefato alto nível (tela/módulo/endpoint) exige grep no branch antes de
  reportar a alguém.
- **Colisão de migration com PR irmão do MESMO lote**: o checker conta PRs abertos — dois filhos
  mediram "próximo livre" antes de um empurrar o outro (0416×0416, e 0419×PR irmão); doutrina da
  casa: quem entra primeiro fica, o outro renumera NNNN+timestamp juntos. Verificar contra os PRs
  do próprio lote, não só contra a main.
- **Filho TRUNCATED (max_iterations) com PR completo e 1 pendência de um comando** → o pai
  executa a pendência no mesmo turno (comentário na issue) — não re-dispara.

### Conflito de DUAS LEIS na mesma branch — #1712 × o #1688 que mergeou no meio do lote
- O mantenedor mergeou o nosso #1688 (campos exigidos) enquanto a branch seguinte (#1538)
  já tocava os MESMOS 7 arquivos → CONFLICTING real. Primeiro erro: medi contra `origin/main`
  — aqui `origin` é o FORK (main velha), medição inócua; o certo é `upstream/main`.
- Resolução = **união das duas leis**: 409 de reabertura (estado) ANTES do 422 de campos
  (conteúdo), nunca um no lugar do outro. 12 marcadores, 3 ciclos de gate até verde.
- Armadilhas pagas do resolver: (a) lados A/B podem ser RABOS de um `import {` comum —
  concat vira sintaxe quebrada, precisa reinserir o `import {`; (b) classificar região por
  palavra-chave exige chave EXCLUSIVA (`.select(` e `MODO_REABERTURA_PADRAO` existiam nos
  DOIS lados e mandaram o handler errado — um bloco inteiro foi sobrescrito); (c)
  `git checkout -m` refaz os marcadores mas APAGA consertos já feitos naquele arquivo.
- **União semântica em teste**: dois blocos `if (tabela === "crm_pipelines")` = o PRIMEIRO
  vence → a pergunta de 409 saía como 200; fundir num bloco só com união de payload. E a
  fake de builder precisa de `.in` E `then` — `await` de não-thenable devolve o próprio
  builder e o `.map` explode depois.
- **Escada de verificação do merge**: marcadores 0 → typecheck (cobre `tests/`) → eslint nos
  tocados → TODOS os testes do caminho (`grep -rl "<rota>" tests`) → commit (o pré-commit já
  checa colisão de migration) → push → readback MERGEABLE. Erros em cascata: consertar a RAIZ
  (import/chave faltando) e re-rodar — nunca caçar o último erro da lista.
- 🔴 `cmd | tail; echo $?` mascarou o rc do script **2× no mesmo dia** (pré-voo e arremate
  do filho) — rc se captura SEM pipe (`; rc=$?` antes de qualquer redirecionamento).
- O roteiro numerado que o filho deixou (`commits.sh`: espera gate → sabotagem → push → PR →
  crédito → comentário) rodou inteiro no pai — exigir esse artefato no brief quando o filho
  estourar teto.
- **CI vermelha pós-merge (#1683): as CERCAS da main não estão no brief do filho.** O filho
  entrega `typecheck` verde e a CI reprova em i18n/espanhol (12 t() sem es), `rotulo-do-contato`
  (fallback de nome feito à mão → usar `nomeDoContato`) e `vocabulario.test` (enum de wire sem
  mapa → exportar mapa em `lib/followup/vocabulario.ts`). Regra: depois de TDOO merge de
  upstream, rodar local as 3 cercas antes do push; traduções novas = uma linha em
  `lib/i18n/dicionario.ts` no formato `"pt": { es: "..." }`. E o depend novo que a main trouxe
  exige `pnpm install` antes do typecheck (`@types/jsdom` mascarou como erro nosso).
- **Corrida de migração ACONTECEU de novo (0426×0426, Onda 3)** — o `checar:colisao` é
  por-branch, então cada filho mediu "próximo livre" em momentos diferentes e os dois pegaram
  0426 (#1535 e #1537). Regra: **o pai mede o NNNN no dispatch e PINA o número no brief de
  cada filho do lote** (0426, 0427, 0428…), em vez de deixar cada um medir. Correção aplicada:
  quem entrou primeiro fica (#1715 = 0426), o outro renumera NNNN+timestamp juntos +
  comentário no `baseline.sql` → checker passou a apontar 0428, os dois PRs MERGEABLE.
