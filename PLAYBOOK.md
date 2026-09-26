# 🧭 PLAYBOOK — 3 repositórios Webtecnica (guia do Antigravity)

> **Dono:** Marcos / @webtecnica · **Atualizado em:** 2026-09-22 (BRT) · **Fonte:** medições diretas na VPS.
> **Uso:** este arquivo é lido pelo Antigravity (PC) e pelo Hermes (VPS). Eu (Hermes) sou quem o
> **atualizo** — quem executa trabalho no PC só **leia** este arquivo e **escreva** no [`LOG.md`](LOG.md).
> Repo: `https://github.com/webtecnica/webtecnica`

---

## 0. Como usar este playbook (Antigravity)

1. Leia este arquivo inteiro antes de tocar em qualquer repo.
2. Siga a seção do repo-alvo **à risca** (idioma, gates, posse e anti-duplicata variam por repo).
3. **Passo 0 obrigatório antes de codar:** provar que o defeito ainda existe na base atual e que
   ninguém (inclusive nós no outro lado) já está resolvendo aquilo — ver §5.
4. Ao terminar (ou interromper) uma sessão de trabalho, **acrescente** uma entrada datada no
   [`LOG.md`](LOG.md) — ver §7. Nunca reescreva entradas antigas.
5. Nunca commite token, chave ou credencial em nenhum repo. Auth no PC: `gh auth login`.

### Prompts prontos que o Marcos pode dar ao Antigravity

- *“Leia PLAYBOOK.md e traga as issues frescas (7 dias) do DeskcommCRM sem dono, com tamanho S/M/L
  e um plano de 1 linha cada.”*
- *“Leia PLAYBOOK.md §4 e liste os bugs novos do hermes-webui que casam com classes de bug já
  conhecidas (prefix-cache, sanitizer, TOCTOU…)”*
- *“Playbook: monte o passo a passo completo do PR #XXXX do repo X — branch, gates rodados, o que
  falta.”*

---

## 1. Os 3 repositórios (endereços e características)

| | **hermes-agent** | **hermes-webui** | **DeskcommCRM** |
|---|---|---|---|
| **Upstream** | `NousResearch/hermes-agent` | `nesquena/hermes-webui` | `melgarafael/DeskcommCRM` |
| **Nosso fork** | `webtecnica/hermes-agent` | `webtecnica/hermes-webui` | `webtecnica/DeskcommCRM` |
| **Web** | github.com/NousResearch/hermes-agent | github.com/nesquena/hermes-webui | github.com/melgarafael/DeskcommCRM |
| **Branch base** | `main` | 🔴 **`master`** (nunca `main` — fetch `main` falha) | `main` |
| **Idioma da casa** | 🇬🇧 EN em tudo | 🇬🇧 EN em tudo | 🇧🇷 **PT-BR em tudo** |
| **Mantenedor** | `teknium1` | `nesquena-hermes` | `melgarafael` |
| **Posse de issue** | não exige claim — PR direto | não exige claim — PR direto | 🔴 comentar **“pego esta”** ANTES de codar (regra 48h) |
| **Stack** | Python (CLI/gateway/agent/tools) + Electron/React (`apps/desktop`) + dashboard web | Backend Python (`api/`) + frontend JS (`static/`, `web/src/`) + testes pytest (`tests/`) | Next.js 16 · React 19 · TS estrito · Supabase · Tailwind 4 · **pnpm 9 / Node 22** |
| **Issues abertas** | ≥1000 (22/09) | 285 (22/09) | 112 (22/09) |
| **CI (workflows)** | `ci.yaml`, `contributor-check.yml`, `case-collision-check.yml`, `docker*.yml` | `tests.yml`, `docs-ci.yml`, `browser-smoke.yml`, `docker-smoke.yml`, `release.yml` | `ci.yml`, `e2e.yml`, `perf.yml`, `release.yml`, `acolhida.yml`, `vigia-de-colisao.yml` |
| **Suporte no PC** | venv do clone + `pytest` | venv do clone + `pytest` (o repo **não** tem `scripts/run_tests.sh`) | `pnpm` (o `AGENTS.md` do repo é a autoridade) |

### Baseline do monitoramento (medido em 2026-09-22)

| Métrica | agent | webui | deskcomm |
|---|---|---|---|
| PRs nossos **abertos** no upstream | 434 | 126 | 1 |
| PRs nossos **merged** (total) | 6 | 29 | 124 |
| Últimos merges nossos citados | #88075 (17/08) | #7572, #7560 (set) | #1476, #1449, #1442, #1440, #1401 (22-23/09) |

> Fonte única de lista de repos na VPS: `~/.hermes/profiles/webtecnica/scripts/repos_comum.py`.
> No PC, este playbook é a referência — se divergir, medir no GitHub antes de decidir.

### Labels úteis (medidas em 22/09)

- **agent:** `type/bug`, `type/feature`, `type/docs`, `type/test`, `type/perf`, `type/security`,
  `comp/agent`, `comp/cli`, `comp/gateway`, `comp/tools`, `comp/desktop`, `comp/dashboard`,
  `comp/cron`, `comp/plugins`, `area/auth`, `area/config`, `area/sessions`, `area/memory`, `bug`.
- **webui:** `bug`, `enhancement`, `help wanted` (só 3 — não invente labels).
- **deskcomm:** `bug`, `enhancement`, `good first issue`, `help wanted` + fluxo próprio
  `triagem:recebido|em-analise|confirmado|em-implementacao|pronto|decisao|bloqueado|corrigindo|aguardando-release`
  e `area/kit|schema|api|canal|deps|ui|docs|infra`.
  🔴 **Nós não temos permissão de aplicar label** no repo do mantenedor — issue nossa nasce sem label.

---

## 2. Setup no PC (uma vez)

```bash
# Auth GitHub (conta webtecnica)
gh auth login

# Identidade git — obrigatória (commits fora desta identidade não contam no perfil)
git config --global user.name  "webtecnica"
git config --global user.email "webtecnica@gmail.com"

# --- hermes-agent ---
git clone https://github.com/webtecnica/hermes-agent.git
cd hermes-agent && git remote add upstream https://github.com/NousResearch/hermes-agent.git

# --- hermes-webui ---
git clone https://github.com/webtecnica/hermes-webui.git
cd hermes-webui && git remote add upstream https://github.com/nesquena/hermes-webui.git

# --- DeskcommCRM ---
git clone https://github.com/webtecnica/DeskcommCRM.git
cd DeskcommCRM && git remote add upstream https://github.com/melgarafael/DeskcommCRM.git
```

Convenção no PC: **`origin` = nosso fork** (push daqui), **`upstream` = repo do mantenedor**
(leitura/branch-base). Na VPS os nomes são invertidos em webui/deskcomm (`origin` = upstream) —
não copie comandos da VPS sem checar `git remote -v` primeiro.

Conferência de identidade antes de qualquer PR:

```bash
git log --format='%an <%ae>' upstream/main..HEAD | sort -u   # tem que ser só webtecnica <webtecnica@gmail.com>
```

---

## 3. Regras de ouro (valem nos 3 repos)

1. **Branch nasce SEMPRE da base do upstream atualizada** (`upstream/main` ou `upstream/master`),
   nunca da main do fork e nunca de outra branch nossa.
2. **Nunca rebase de commit publicado, nunca `push --force` na base, nunca push em `main`/`master`.**
   Branch atrasada se atualiza com `git merge upstream/<base>` (no Deskcomm é regra escrita do repo).
   **Force-push só em branch comprovadamente 100% nossa** — antes de qualquer `--force` (mesmo
   `--force-with-lease`): `git fetch origin <branch>` e conferir
   `git log --oneline HEAD..origin/<branch>` + `git log --format='%an' origin/<branch> | sort -u`.
   Qualquer commit que não seja nosso ⇒ ABORTAR o force e seguir com **commit novo ou `git pull`**.
   O lease NÃO protege: ele apaga sem pestanejar tudo que já estava no remote no momento do push.
   Em branch de PR onde o mantenedor já commitou, force é proibido para sempre — ele pediu por
   escrito (25/09, PR do Deskcomm #1651, após perdermos 2 commits dele num rebase pushado).
   E renumeração de migration só pode reescrever NOSSAS referências: `git diff upstream/<base> --
   supabase/` tem de mostrar só adições nossas (troca às cegas renomeou o 0412 da main e trocou
   comentários do baseline). Detalhe medido: APRENDIZADO 2026-09-25.
3. **Nunca `gh pr merge`** — não temos permissão de merge em nenhum dos 3; quem mergeia é o mantenedor.
4. **Zero PR inferior/duplicata:** passo 0 (§5) é obrigatório; se o fix já existe na base, comente na
   issue apontando o PR/sha e feche o trabalho — não abra PR.
5. **Honestidade radical no PR:** “O que medi” (comandos + saída) e “O que NÃO medi” (o que ficou
   de fora e porquê). Gate declarado sem ter rodado não é gate.
6. **Teste que fica VERMELHO sem a mudança** + **sabotagem** (reverter o fix e conferir a contagem
   de vermelhos prevista) — é a prova que separa teste de enfeite.
7. **Idioma:** agent/webui → EN (corpo de PR, comentários, mensagens de commit). Deskcomm → PT-BR
   em tudo (comentários, docs, corpo de PR; só o prefixo do commit é o conventional em EN).
8. **Um PR = uma issue = um escopo.** Escopo de epic/feature grande vira issue primeiro.
9. 🔴 **SEMPRE sincronizar com este repositório** — `git pull --rebase origin main` ao ABRIR
   qualquer sessão de trabalho e `git push` ao FECHAR (LOG com status) e SEMPRE que houver
   aprendizado novo: lição commitada no MESMO dia, em `APRENDIZADO.md` (ou destilada aqui).
   O que não foi pushado não existe para o outro lado — conhecimento que fica só na conversa
   se perde quando a sessão acaba.
10. **PR parcial = DRAFT + `Refs #N`** — nunca `Closes` pela metade (fecharia a issue incompleta);
    perguntas de produto que a issue abriu vão como comentário na issue, e o PR espera as
    respostas (validado 25/09 na #1639 → PR #1672).
11. **CR/revisão do mantenedor: ler INTEIRO e separar** — *"é com você"* (nosso desenho →
    codar e **responder decidindo** a pergunta de desenho, ex.: "1 PR só") × *"é conosco"*
    (carimbo, fragmento, i18n alheia → confirmar e não mexer) × frases que dispensam ação
    ("você não precisa fazer nada"). E antes de reportar qualquer entrega, **provar os claims
    do próprio resumo** (grep no branch por cada tela/módulo citado): PR verde não valida
    conteúdo (medido 26/09: resumo dizia "editor criado" e o arquivo tinha 0 ocorrências).
12. **CONFLICTING: medir ANTES de acreditar** — `git merge-tree` contra o remoto **certo**
    (`origin` pode ser o fork com main velha — medição inócua; o upstream é quem vale). Se o
    conflito for real: `git merge` (nunca rebase) **unindo os dois lados**, e a escada:
    marcadores → typecheck → testes do caminho → push → readback. Conflito de mesmo arquivo
    com outra lei recém-mergeada = decidir a ORDEM (estado > conteúdo) e **fundir fakes
    duplicados** (no mock, o primeiro `if` vence e o teste mente).

---

## 4. Issues frescas — comandos prontos (por repo)

```bash
# ── Issues criadas nos últimos 7 dias, sem dono, sem PR linkado ──────────────
# agent
gh issue list -R NousResearch/hermes-agent --state open \
  --search "created:>$(date -d '7 days ago' +%F)" --limit 30 \
  --json number,title,createdAt,labels,assignees,comments

# webui
gh issue list -R nesquena/hermes-webui --state open \
  --search "created:>$(date -d '7 days ago' +%F)" --limit 30 \
  --json number,title,createdAt,labels,assignees,comments

# deskcomm
gh issue list -R melgarafael/DeskcommCRM --state open \
  --search "created:>$(date -d '7 days ago' +%F)" --limit 30 \
  --json number,title,createdAt,labels,assignees,comments

# ── Filtros que mais rendem ──────────────────────────────────────────────────
gh issue list -R NousResearch/hermes-agent --state open --label type/bug      --limit 20
gh issue list -R nesquena/hermes-webui      --state open --label "help wanted" --limit 20
gh issue list -R melgarafael/DeskcommCRM    --state open --label "good first issue" --limit 20
gh issue list -R melgarafael/DeskcommCRM    --state open --label "triagem:pronto"    --limit 20  # já aceito p/ PR

# ── Sinais de “issue viva” ──────────────────────────────────────────────────
gh issue view <N> -R <slug> --json comments,assignees,labels,state
```

**Janela do Deskcomm é curta** — a triagem lá responde em ~1h (p50): reservar no MESMO dia em que a
issue aparece. Filtros manuais de “livre”: sem `assignee`, sem label de bloqueio
(`triagem:decisao|bloqueado`), sem comentário de reserva, sem PR aberto citando `Closes/Fixes/Resolves #N`,
e **não é proposta nossa** (não reservamos a própria 💡).

---

## 5. Passo 0 — anti-duplicata e prova do defeito (obrigatório antes de codar)

```bash
# 1) Já existe PR (de qualquer pessoa) para esta issue?
gh pr list -R <slug> --state open --search "<N da issue>" --json number,title,author
gh pr list -R <slug> --state all --search "<termo do bug>" --limit 10

# 2) Alguém reservou/comentou? (especialmente no Deskcomm: “pego esta”)
gh issue view <N> -R <slug> --json comments,assignees,labels

# 3) O defeito ainda existe na BASE ATUAL? (relato antigo pode ser bug já corrigido)
git fetch upstream && git log --oneline -S'<trecho exato do defeito>' upstream/<base> -- <arquivo>
# Achou fix? → comente na issue apontando sha/PR/tag e NÃO abra PR.
```

Se a issue for de terceiro e houver PR concorrente: **não abra PR duplicado** — comente com a sua
medição/apoio apenas se acrescentar algo novo.

### 5.1 Coordenação VPS × PC (os dois lados no mesmo fork)

VPS (Hermes) e PC (Antigravity) usam a **mesma conta e o mesmo fork**, e os dois podem ser
acionados a qualquer momento pelo Marcos. PR duplicado para a mesma issue é o pior erro possível.
Antes de iniciar QUALQUER issue, no lado que for:

1. `git pull --rebase origin main` no playbook e ler as entradas recentes do `LOG.md`
   (é o registro do que o outro lado fez/prometeu).
2. Checar se o outro lado já começou:
   ```bash
   gh pr list -R <upstream> --state all --search "<N>"   # já existe PR pra issue?
   gh issue view <N> -R <slug> --json comments           # "pego esta"/comentário nosso?
   git ls-remote origin 'refs/heads/*<N>*'               # branch já pushada no fork?
   ```
3. **Começou (branch pushada, claim respondido, PR aberto) ⇒ não pegue a mesma issue** — escolha
   outra. Se for RETOMAR o trabalho do outro lado, faça no **mesmo branch/PR** (continuidade:
   `git fetch origin && git checkout <branch>`), nunca um branch/PR novo.
4. Deskcomm mantém o claim de 48h ("pego esta" = precedência). Nos repos do Hermes, onde não há
   claim, **o primeiro a pushar `fix/<N>-*` tem a precedência**.
5. Os crons da VPS (claim de issues, watchdogs de menção) rodam independentemente — o sinal deles
   é comentário/branch no GitHub, então as regras acima já os cobrem.

Na dúvida de qual lado assumir: o Marcos decide — um pedido vale um lado por vez.

---

## 9. Como este playbook evolui (3 arquivos, um escritor por arquivo)

| Arquivo | Escritor | Papel |
|---|---|---|
| `PLAYBOOK.md` | Hermes (VPS) | **doutrina viva** — só regra destilada e ainda válida; legível de ponta a ponta |
| `APRENDIZADO.md` | Hermes (VPS) | **caderno append-only datado** — armadilhas medidas, incidentes, feedback de mantenedor, dos dois lados |
| `LOG.md` | Antigravity (PC) | atividade + lições brutas do PC (campo “Aprendizado”, se quiser sugerir) |

**Pipeline de inteligência:**

1. **Desenvolvimento na VPS** que afeta os dois lados (nova armadilha do Deskcomm, mudança de
   gate, lição de review) → regra vai **direto no PLAYBOOK** na mesma rodada.
2. **Rodada de conferência do PC** → lição crua datada entra no **APRENDIZADO.md**; se durar,
   repetir e valer para os dois lados, é **destilada** para o PLAYBOOK (e a versão velha é cortada
   aqui — o PLAYBOOK não acumula histórico).
3. **Tamanho é contrato:** o Antigravity lê o PLAYBOOK inteiro antes de trabalhar. Se uma seção
   inflar, o detalhe migra pro APRENDIZADO e o PLAYBOOK guarda ~3 linhas + ponteiro.
4. **O que NÃO entra aqui:** estado temporário (PR aberto/merged, “falta X”), logs de atividade
   (→ LOG) e procedimentos exclusivos da VPS (→ skills do Hermes). Número de PR/issue só como
   evidência datada, nunca como afirmação de estado permanente.

---

## 6. Fluxo de trabalho por repo

### 6.1 hermes-agent (EN, `main`)

1. `git fetch upstream && git worktree add ../wt-agent-<N> -b fix/<N>-<slug> upstream/main`
   (um worktree por issue; nunca patchar no clone principal).
2. Passo 0 (§5) → fix mínimo + teste RED→GREEN → sabotagem → restaurar.
3. Gates locais (régua = o que o CI roda — **leia, não adivinhe**):
   ```bash
   python -m py_compile <py alterado>        # parse failure é blocker objetivo
   node --check <js alterado>                # se tocou JS
   # lista real de jobs da CI:
   gh api repos/NousResearch/hermes-agent/contents/.github/workflows/ci.yaml --jq '.content' | base64 -d | grep -E 'name:|run:'
   # testes do escopo (venv do clone):
   <venv>/bin/python -m pytest tests/<arquivo> -q -p no:cacheprovider
   ```
4. Commit conventional (prefixo EN) → `git push origin <branch>` →
   `gh pr create --repo NousResearch/hermes-agent --base main --head webtecnica:<branch>`
   com corpo em **EN**: Summary / Root cause / Test plan (red→green) / `Closes #N` (sem crases).
5. Lint do CI é **scoped às linhas mudadas** — não corrija backlog alheio no mesmo PR.
6. Classes de bug recorrentes do repo (checar antes de inventar fix): flag de CLI engolida no
   one-shot (`-z`), init que só roda em `HermesCLI.run()` (morto em query mode), callback ligado em
   `gateway/run.py` mas ausente em `api_server.py`, drift de normalização dashboard×ferramenta,
   contadores de sessão não re-hidratados do SQLite, credential pool ignorado por `get_env_value()`.

### 6.2 hermes-webui (EN, `master`)

1. 🔴 Base é `upstream/master`. O clone costuma estar parado numa branch antiga — sempre
   `git fetch upstream && git worktree add ../wt-webui-<N> -b fix/<N> upstream/master`.
2. Passo 0 (§5) → teste de regressão PRIMEIRO (RED) → fix → sabotagem → restaurar.
3. Gates:
   ```bash
   <venv do clone>/bin/python -m pytest tests/<arquivo> -q -p no:cacheprovider
   # lint do CI é SCOPED (scripts/ruff_lint.py) — só as linhas do seu diff
   python scripts/ruff_lint.py <arquivos do diff>   # se existir no head; senão ruff do venv
   ```
   🔴 **Proibido:** assertar source-string (asserção é sobre DOM/HTML/payload executado) e
   mutar `os.environ` em request-time.
4. PR para `nesquena/hermes-webui`, corpo **EN**. O bot `nesquena-hermes` comenta o resultado do
   gate referenciando o head daquela hora — **compare com `gh pr view N --json headRefOid`**; se o
   head atual já endereça o pedido e o CI está verde, não refaça, só confirme.
5. Prioridade da fila (somos #1 não-maintainer, 126 abertos): (1) MERGEABLE sem change-request;
   (2) CR **vivo** (head ≤ último `CHANGES_REQUESTED`); (3) CONFLICTING/BEHIND (trazer
   `git merge upstream/master`, nunca rebase).
6. Rebase de branch publicada: commite antes, re-rode a suíte, `push --force-with-lease` só nesse
   caso (fork), e comente o sha novo no PR.

### 6.3 DeskcommCRM (🔴 PT-BR, `main`, claim obrigatório)

1. Comentar **“pego esta”** na issue ANTES de qualquer linha de código (regra 48h; o mantenedor
   atribui). Sem isso, seu trabalho pode ser de outro.
2. Ler o guia da casa no clone: **`.agents/skills/deskcomm-contribuir/`** (SKILL.md +
   `references/pre-voo.md`) e o `CONTRIBUTING.md` — eles mudam com frequência; conferir a versão
   atual antes de cada PR.
3. Worktree por issue: `git worktree add ../wt-dk-<N> -b fix/<N>-<slug> upstream/main` →
   **armar os hooks** (nunca commitar sem): `bash .agents/skills/deskcomm-contribuir/scripts/armar-hooks.sh`
   → `pnpm install --frozen-lockfile`.
4. DoD do CI (ordem, um pesado por vez; a régua real é `.github/workflows/ci.yml`):
   ```bash
   pnpm cercas && pnpm typecheck && pnpm lint && pnpm lint:channels && \
   pnpm test:unit && pnpm test:shell && pnpm build
   # pnpm test:db  → só se tocou schema/RLS (exige Docker)
   # pnpm gov:verify NÃO cobre cercas/test:shell — não use como única régua
   ```
   Depois: `bash .agents/skills/deskcomm-contribuir/scripts/pre-voo.sh`.
   **`O que NÃO medi` declara o COMANDO tentado + o ERRO** — não a categoria do ambiente: se o
   mesmo runner (vitest/node) já rodou no PC, o gate vizinho é obrigado a ser tentado;
   `test:shell` (bash) é a exceção legítima em Windows.
5. Sabotagem contada → commit conventional (**prefixo EN, descrição PT-BR**, escopo EPIC se couber:
   `fix(EPIC-03): ...` — catálogo em `docs/stories/epics/MASTER.md`).
6. Fragmento de release `.changes/<kebab>.md` quando o operador da VPS percebe a mudança, fechando
   com linha em branco + `Contribuição de @webtecnica (#<n do PR>).`.
7. Push no fork → `gh pr create --repo melgarafael/DeskcommCRM --base main --head webtecnica:<branch>`
   com corpo **PT-BR**: “# O que este PR faz”, `Closes #N` **sem crases**, **“O que medi”**
   (comandos e saídas), **“O que NÃO medi”**. Depois comentar o link do PR na issue.
8. Migrations = **sempre tripla** (arquivo em `supabase/migrations/` + apêndice idempotente em
   `supabase/baseline.sql` + linha no `supabase/migrations/MANIFEST.md`), número/timestamp únicos.
   Nunca edite migration já aplicada.
9. Conflito: `git merge upstream/main` (nunca rebase); medir antes com
   `git merge-tree --write-tree upstream/main HEAD` (só OID = limpo; linhas com estágio 1/2/3 = conflito real).
10. Checks de fork esperados: `Vercel` vermelho (deploy recusa PR de fork) e workflows parados
    aguardando liberação no **primeiro** PR — não re-pushar por causa disso.
11. O `AGENTS.md`/`CLAUDE.md` do próprio repo são a autoridade máxima (precedência:
    `CLAUDE.md` > `docs/specs/` > `docs/prd/` > `HANDOFF` > `README`). **Não invente regra de
    negócio** — se não está escrita, pergunte.

---

## 7. Protocolo de LOG e monitoramento (PLAYBOOK ↔ LOG.md)

**Divisão de propriedade (evita conflito mesmo editando os dois lados ao mesmo tempo):**

| Arquivo | Quem escreve | Regra |
|---|---|---|
| `PLAYBOOK.md` | Hermes (VPS) | os outros só leem; correções passam por mim |
| `LOG.md` | Antigravity (PC) | **append-only**: só acrescenta, nunca reescreve entradas antigas |

**Formato da entrada no `LOG.md`** — uma seção por data de trabalho:

```markdown
## 2026-09-25

### <repo> — <issue/PR #>
- O que fiz:
- Evidência (gate/vermelho→verde/medida):
- Status: aberto | merged | fechado | aguardando <X>
- Próximo passo:
```

**Ledger de ações (`ACOES.md`) — obrigatório nos DOIS lados:** além da narrativa do LOG, **toda
ação executada** vira **UMA linha append-only** no [`ACOES.md`](ACOES.md), no formato
`AAAA-MM-DD | executor | repo | ação | ref(s) | status`, com o executor certo:
`[antigravity]` para o PC, `[hermes:webui]` / `[hermes:telegram]` / `[hermes:cron]` / `[hermes:vps]`
para a VPS. É o arquivo que responde “quem fez o quê” por filtro — não substitui o LOG, completa-o.

**Rotina do Antigravity ao fechar a sessão:**

```bash
cd <pasta do playbook>
git pull --rebase origin main     # sempre antes de push (append-only → conflito quase impossível)
# …acrescente a seção do dia no LOG.md…
git add LOG.md ACOES.md && git commit -m "log: trabalho do Antigravity em YYYY-MM-DD"
git push origin main              # NUNCA --force
```

**Aviso de conclusão (obrigatório — este é o sinal de “terminei”):**
quando **TODAS** as tarefas instruídas estiverem terminadas — ou o trabalho interromper —, a última
entrada do `LOG.md` deve trazer, obrigatoriamente, uma destas linhas no campo Status:

```markdown
- Status: ✅ TAREFAS CONCLUÍDAS (<N> issues/PRs: #a, #b, …)
- Status: ⛔ INTERROMPIDO: <motivo exato + o que falta>
```

O `git push` com essa linha é o gatilho: um watchdog na VPS vigia commits novos em `LOG.md`
(cron `antigravity-log-watch`, a cada 15 min) e dispara notificação quando detecta — o push
final **não pode faltar**, mesmo que o resultado seja “interrompido”. Trabalho sem push de
conclusão = o monitoramento não sabe que você terminou.

**Como eu monitoro (Hermes):** no sinal do watchdog (ou a pedido do Marcos) eu rodo `git pull`
neste repo, leio as entradas novas do `LOG.md` (`git log -p -- LOG.md`) e **confiro contra a
realidade do GitHub** (`gh pr list/gh issue view` com os números citados). O log é autodeclarado —
vale o que o GitHub mostra; divergência eu aponto e corrijo aqui.

**O que registrar sempre:** números de issue/PR, branch, o que foi medido, o que ficou de fora e
o status real. Se o trabalho no PC criou commit mas não empurrou, dizer isso no log (“não pushado”)
— é melhor que silêncio.

---

## 8. Endereços rápidos

- Nosso fork (push): `github.com/webtecnica/hermes-agent` · `github.com/webtecnica/hermes-webui` · `github.com/webtecnica/DeskcommCRM`
- Upstreams: `github.com/NousResearch/hermes-agent` · `github.com/nesquena/hermes-webui` · `github.com/melgarafael/DeskcommCRM`
- Nossos PRs abertos (verificar a qualquer momento):
  ```bash
  for R in NousResearch/hermes-agent nesquena/hermes-webui melgarafael/DeskcommCRM; do
    echo "== $R"; gh pr list -R $R --state open --author webtecnica --limit 20 \
      --json number,title,mergeStateStatus --jq '.[] | "\(.number) [\(.mergeStateStatus)] \(.title[0:60])"'
  done
  ```
- Dashboard/WebUI internos (upsay.com.br): `hermes.upsay.com.br` (dashboard) · `hermesui.upsay.com.br` (WebUI)
- Contato humano: WhatsApp 41 98533-7818
