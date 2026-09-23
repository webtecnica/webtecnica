# 📓 LOG — trabalho do Antigravity (alimentado a partir do PC)

> **Regras:** append-only · uma seção `## AAAA-MM-DD` por dia de trabalho · nunca reescrever
> entradas antigas · `git pull --rebase` antes de push · nunca `--force`.
> Formato e protocolo completos: [`PLAYBOOK.md`](PLAYBOOK.md) §7.
> Este log é **autodeclarado** — o Hermes confere cada número contra o GitHub.

<!-- Antigravity: acrescente a entrada mais recente ABAIXO desta linha. -->

## 2026-09-22

### Setup — playbook criado
- O que fiz: playbook dos 3 repos publicado neste repo (primeira entrada; baseline medido: abertos
  agent 434 / webui 126 / deskcomm 1; merged 6 / 29 / 124).
- Evidência: medições via `gh` na VPS em 22/09.
- Status: pronto para uso pelo Antigravity.
- Próximo passo: primeira sessão de trabalho no PC registrar aqui.

### deskcomm — issue #1445 / PR #1482
- O que fiz: corrigi o gate `tests/unit/indice-de-contato-ignora-ficha-mesclada.test.ts` que reprovava no Windows devido ao separador de caminho `\` gerado por `slice(process.cwd().length + 1)`. Substituído pelo helper `relativoEmBarraNormal(process.cwd(), caminho)`, garantindo barras normais `/` e passando o teste unitário.
- Evidência (gate/vermelho→verde/sabotagem):
  - Vermelho inicial reproduzido localmente: falha em `expect(CORPUS.some((i) => i.arquivo.includes("migrations/"))).toBe(true)` na linha 128.
  - Verde pós-fix: 3 passed em 49ms (`pnpm vitest run tests/unit/indice-de-contato-ignora-ficha-mesclada.test.ts`).
  - Sabotagem: reversão temporária resultou em exatamente 1 falha de 3 (o previsto), restaurado para 3 passed.
  - Régua local: `pnpm typecheck` (tsc exit 0 com 4GB heap), `pnpm lint` (0 erros), `pnpm lint:channels` (ok), `pnpm build` (exit 0).
  - O que NÃO medi: `pnpm cercas` e `pnpm test:shell` (dependem de utilitários shell POSIX que rodam no ambiente Ubuntu do CI); `pnpm test:db` e `test:e2e` (sem Docker local na máquina e sem alteração de schema/RLS).
  - Vínculo verificado: `gh pr view 1482 -R melgarafael/DeskcommCRM --json closingIssuesReferences` vinculando a #1445; comentário "PR: #1482" adicionado na issue.
- Status: aberto (aguardando triagem/revisão do mantenedor)
- Próximo passo: acompanhar execução dos checks de CI e eventual revisão do mantenedor.

## 2026-09-23

### deskcomm — issue #1478 / PR #1486
- O que fiz: adicionei as entradas de preços dos modelos OpenAI (`gpt-4o`, `gpt-4o-mini` e os modelos `gpt-5.x` do catálogo curado) na tabela `USD_PER_MTOK` em `lib/agent-engine/edge/llm/pricing.ts` com fontes oficiais citadas (https://openai.com/api/pricing), e estendi `precoDoModelo` para tolerar datas no padrão `-YYYY-MM-DD`. Adicionado fragmento de release `.changes/custo-modelos-openai.md`.
- Evidência (gate/vermelho→verde/sabotagem):
  - Vermelho inicial: 14 testes falharam em `pricing.test.ts` (modelos devolvendo null).
  - Verde pós-fix: 40 passed de 40 em 594ms (`pnpm vitest run lib/agent-engine/edge/llm/pricing.test.ts`).
  - Sabotagem: revertidas temporariamente as linhas da OpenAI, confirmando exatamente 14 falhas de 40 (o previsto).
  - Régua local: `pnpm typecheck` (exit 0), `pnpm lint` (exit 0), `pnpm lint:channels` (ok), `pnpm release:conferir` (ok), `pnpm build` (exit 0).
  - O que NÃO medi: `pnpm test:shell` (depende de utilitários shell bash no runner Linux do CI); `pnpm test:db` e `test:e2e` (sem Docker local e sem alteração de schema/RLS).
  - Vínculo verificado: `gh pr view 1486 -R melgarafael/DeskcommCRM --json closingIssuesReferences` vinculando a #1478; comentário "PR: #1486" adicionado na issue.
- Status: ✅ TAREFAS CONCLUÍDAS (PR #1486 aberto aguardando revisão de @melgarafael)
### hermes-webui — PR #7647
- O que fiz: corrigi a quebra de paridade de i18n em 10 suítes de locale adicionando as traduções das chaves `saved_prompts_delete_confirm` e `saved_prompts_deleted` em todos os 14 idiomas em `static/i18n.js`.
- Evidência:
  - Vermelho inicial: 12 jobs falhando no CI com `AssertionError` em `test_czech_locale.py`, `test_zh_hant_locale.py`, etc.
  - Verde local: 27/27 passed em `pytest tests/test_czech_locale.py tests/test_zh_hant_locale.py tests/test_chinese_locale.py tests/test_issue7644_saved_prompt_delete_confirm.py`.
  - CI oficial: 24/24 passed (100% GREEN) no commit `d2ecf3d7`.
- Status: ✅ Concluído e aprovado nos gates do CI.

### hermes-webui — PR #7559
- O que fiz: isentei a rota `/api/session/archive` da guarda genérica de visibilidade pré-handler em `api/routes.py`, mantendo a autorização de perfil ativo no handler para requisições comuns e permitindo a restauração (unarchive) de sidecars de outros perfis via `all_profiles=1`. Adicionado teste de round-trip arquivar/restaurar em `tests/test_issue7549_archive_all_profiles.py` e resolvido conflito com `upstream/master`.
- Evidência:
  - Verde local: 9/9 passed em `pytest tests/test_issue7549_archive_all_profiles.py`.
  - CI oficial: 24/24 passed (100% GREEN) no commit `2ac61a53`.
- Status: ✅ Concluído e aprovado nos gates do CI.

### hermes-webui — PR #7610
- O que fiz: refatorei a lógica de OOB steer writeback em `api/streaming.py` para extração in-place do texto do usuário a partir de linhas tipadas `role: user, display_kind: 'steer'` (unwrapping de frame único validado), preservando linhas de ferramentas legadas e marcadores malformados/múltiplos byte a byte. Atualizado `docs/rfcs/webui-pending-intent-controls.md` e suíte de testes `tests/test_issue7600_oob_display_writeback.py`. Mesclado com `upstream/master`.
- Evidência:
  - Verde local: 5/5 passed em `pytest tests/test_issue7600_oob_display_writeback.py`.
  - Push no fork: commit `6caa0c19` (com ruff scoped 100% limpo).
- Status: 🟡 CI disparado e em execução.

### hermes-webui — PR #7743
- O que fiz: corrigi o isolamento e ownership de base URL para provedores em `api/providers.py`. Mesclado com `upstream/master`.
- Evidência:
  - Verde local: 10/10 passed nos testes de base URL ownership.
  - Push no fork: commit `301ed54a` na branch `fix/7535-provider-base-url-ownership`.
- Status: ✅ Concluído e enviado.

### hermes-webui — PR #7651
- O que fiz: preservei a integridade de corpo em transparent replay body em `api/routes.py` e streaming. Mesclado com `upstream/master`.
- Evidência:
  - Verde local: testes de replay body aprovados.
  - Push no fork: commit `4b791bd8` na branch `fix/7640-transparent-replay-body`.
- Status: ✅ Concluído e enviado.

### hermes-webui — PR #7418
- O que fiz: corrigi a deleção de credenciais compartilhadas em pools de provedores em `api/routes.py` (envolvendo `/api/providers` e `/api/providers/delete` com contexto de ambiente ativo) e em `api/providers.py` (`_lift_suppressed_pool_source` abrangendo todos os provedores afetados). Ajustados testes de monkeypatching e try-imports com `pytest.importorskip`. Mesclado com `upstream/master`.
- Evidência:
  - Verde local: 5/5 passed em `tests/test_provider_delete_credential_pool.py`.
  - Ruff scoped: 0 erros.
  - Push no fork: commit `826caee0` na branch `fix/7412-credential-pool-delete`.
- Status: ✅ Concluído e enviado.

### hermes-webui — PR #7417
- O que fiz: atendi os dois apontamentos de revisão do mantenedor em `api/streaming.py`: (1) fallback para modo sem reasoning no mesmo slot quando schema mode encontra `llm_empty_reasoning_aux`; (2) preservação de `llm_length` quando `finish_reason == 'length'`, rejeição de JSONs truncados em `_title_unwrap_schema_content`, e política de retry com orçamento dobrado antes do fallback. Adicionadas 2 regressões em `tests/test_title_aux_routing.py`. Mesclado com `upstream/master`.
- Evidência:
  - Verde local: 68/68 passed em `tests/test_title_aux_routing.py`.
  - Ruff scoped: 0 erros.
  - Push no fork: commit `31fd7195` na branch `feat/7413-title-json-schema`.
- Status: ✅ Concluído e enviado.

### hermes-webui — PR #7400
- O que fiz: resolvi o conflito e integrei com `upstream/master` a persistência de id de roteamento no seletor de modelos. Cobertura de autoridade de provedores e seleção canônica em Settings.
- Evidência:
  - Verde local: 36/36 passed em 5 suítes de regressão (`test_issue7400_model_picker_qualified_selected_row.py`, `test_chat_start_provider_fallback.py`, `test_issue5989_custom_proxy_picker_dedup.py`, `test_custom_provider_model_identity.py`, `test_issue1771_session_model_switch_sync.py`).
  - Node check & Ruff scoped: 0 erros.
  - Push no fork: commit `92e6623c` na branch `fix/picker-routing-id-persist`.
- Status: ✅ Concluído e enviado.

### hermes-webui — PR #7399
- O que fiz: corrigi os 3 defeitos apontados na revisão de refetch de catálogo: (1) invalidação do número de geração de requisição (`bumpModelDropdownRequestSeq()`) na troca de perfil em `static/panels.js` e guarda de mutação de variáveis globais de perfil stale em `static/ui.js`; (2) preservação de texto de busca (`.model-search-input`), input de modelo customizado (`.model-custom-input`) e foco ativo durante o refetch e re-render do dropdown em `static/ui.js`; (3) unificação do rastreamento de hidratação via `window._trackModelCatalogHydration` e coalescência de requisições de live models em voo em `static/ui.js` e `static/sessions.js`. Mesclado com `upstream/master`.
- Evidência:
  - Verde local: 7/7 passed em `tests/test_issue7227_picker_catalog_refetch.py`.
  - Node check: 0 erros de sintaxe.
  - Push no fork: commit `cd624baf` na branch `fix/picker-refetch-catalog`.
- Status: ✅ Concluído e enviado.

### hermes-webui — PR #7292
- O que fiz: solucionei o conflito estrutural entre #2051 e #7290 em `static/ui.js::_isEquivalentConfiguredModelEntry()`. Consolidada a autoridade de provedor com fallback de badge (`_entryProvider(entry)`) para opções de topo e entradas temporárias, mantendo a ordem estrita de checagem do prefixo de barra e `@provider:` exigida pelas regras estruturais de regressão do #2051. Mesclado com `upstream/master`.
- Evidência:
  - Verde local: 22/22 passed em `tests/test_configured_model_picker_dedup.py`, `tests/test_issue7290_no_slash_prefixed_alias.py` e `tests/test_issue2051_duplicate_model_picker_entry.py`.
  - Node check & Ruff scoped: 0 erros.
  - Push no fork: commit `b56d92f3` na branch `fix/7290-provider-prefix-badge-dedup`.
- Status: ✅ Concluído e enviado.

### hermes-webui — PR #7284
- O que fiz: atendi os 4 apontamentos da revisão do mantenedor em `api/route_approvals.py` e `static/messages.js`:
  1. Identidade completa de aprovação na chave de dispensa: incluído `(session_id, approval_id, run_id, mirror_token)` com namespacing por perfil ativo (`activeProfile`), permitindo reuso de `approval_id` em runs subsequentes da mesma sessão.
  2. Limpeza da fila interna `_gateway_queues`: ao aposentar entradas por `run_id` terminal, remove instâncias correspondentes da fila de gateway sem exigir que `approval_id` esteja setado.
  3. Isolamento multi-aba e de respostas atrasadas no polling fallback: `_startApprovalFallbackPoll` valida tupla do proprietário (`sid`, `approval_id`, `run_id`, `mirrorToken`) contra o card ativo antes de ocultar com `hideApprovalCard(true)`, e não limpa projeções pendentes de sessões que já avançaram para sucessores.
  4. Diferenciação de 404 autoritativo: mantém dispensa apenas quando o corpo da resposta traz `approval_not_found`, restaurando o card para retentativa em casos de 404 genérico / sobrecarregado (ex: troca de perfil concorrente).
  Adicionados testes comportamentais completos em `tests/test_issue7242_approval_flyout_dismiss.py`. Mesclado com `upstream/master`.
- Evidência:
  - Verde local: 41/41 passed em `tests/test_issue7242_approval_flyout_dismiss.py` + 37/37 em testes relacionados de aprovações.
  - Node check: 0 erros de sintaxe em `static/messages.js`.
  - Ruff scoped: 0 erros.
  - Push no fork: commit `17c9205e` na branch `fix/7242-approval-flyout-dismiss`.
- Status: ✅ Concluído e enviado.




