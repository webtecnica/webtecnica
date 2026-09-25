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

### deskcomm — issue #1451 / PR #1508
- O que fiz: corrigi o estouro de layout do Inbox quando uma mensagem possui textos longos contínuos sem espaços (ex: código Pix copia-e-cola de 150+ chars). Adicionadas classes `[overflow-wrap:anywhere]` e `min-w-0` em `components/inbox/MessageBubble.tsx` (linha externa, bolha, citações e texto apagado), em `components/inbox/NoteCard.tsx`, no container scroller de `components/inbox/ChatThread.tsx` e na coluna de conversa do grid em `components/inbox/InboxLayout.tsx`. Adicionado teste de regressão em `MessageBubble.test.tsx` e fragmento `.changes/inbox-quebra-texto-longo.md`. Mesclado com `upstream/main`.
- Evidência:
  - Vermelho inicial: asserção de quebra de palavra e contenção de bolha falhando em `MessageBubble.test.tsx`.
  - Verde local: 10/10 passed em `pnpm vitest run components/inbox/MessageBubble.test.tsx`.
  - Régua local: `pnpm typecheck` (exit 0), `pnpm lint` (0 erros).
  - PR aberto: #1508 (fechando #1451).
- Status: ✅ Concluído e PR aberto.

### deskcomm — issue #1376 / PR #1509
- O que fiz: corrigi a validação de credenciais OpenRouter em `lib/ai/provider-validators.ts` (`validateOpenRouterKey`) para instalações self-hosted com `OPENROUTER_BASE_URL` customizada. Quando o endpoint `/key` (proprietário do OpenRouter oficial) devolve 404 em base customizada, o validador agora verifica a autenticidade e obtém o catálogo de modelos via `GET /models` com `Authorization: Bearer <apiKey>`, permitindo validar credenciais e publicar agentes em gateways OpenAI-compatíveis próprios (LiteLLM, vLLM). Adicionados 3 testes unitários de regressão em `lib/ai/provider-validators.test.ts` e fragmento `.changes/openrouter-custom-gateway-validation.md`. Mesclado com `upstream/main`.
- Evidência:
  - Vermelho inicial: testes com gateway customizado falhando com `provider_status_404`.
  - Verde local: 12/12 passed em `lib/ai/provider-validators.test.ts` e 25/25 passed em `tests/unit/provedores-x-registry.test.ts` / `tests/unit/openrouter-alcance.test.ts`.
  - Régua local: `pnpm release:conferir` (exit 0).
  - PR aberto: #1509 (fechando #1376).
- Status: ✅ Concluído e PR aberto.

### hermes-agent — PR #91094 (Lote 1/2)
- O que fiz: resolvi o apontamento de revisão de Keeltrace sobre a lógica de tratamento de mensagem vazia do assistente ao final do stream. A lógica no loop já estava corrigida (`msg.get("role") == "assistant"`), e adicionei a regressão `test_repair_owner_repairs_final_empty_assistant_and_preserves_final_user` em `tests/run_agent/test_partial_stream_finish_reason.py` garantindo que a mensagem vazia final é reparada e a mensagem do usuário preservada.
- Evidência:
  - Sabotagem inicial: 1 falha confirmada quando invertida a condição.
  - Verde local: 2/2 passed em `tests/run_agent/test_partial_stream_finish_reason.py`.
  - Ruff: 0 erros.
  - Push no fork: commit `b604a2003f` na branch `fix/91027-issue`.
- Status: ✅ Concluído e enviado.

### hermes-agent — PR #91101 (Lote 1/2)
- O que fiz: atendi à revisão de Keeltrace sobre encoding UTF-8 no hook de reescrita HTTPX em `agent/process_bootstrap.py`. Em HTTPX 0.28.1, requisições em `async_mode=True` com reescrita síncrona/ByteStream falhavam e `request._content` não era sincronizado. Atualizado para preencher `request._content = new_body` junto com `request.stream` tanto em modo síncrono quanto assíncrono. Adicionada suíte de testes `tests/agent/test_json_encoding_hook.py` testando requisições reais com MockTransport em sync e async com caracteres multibyte e emojis UTF-8.
- Evidência:
  - Verde local: 2/2 passed em `tests/agent/test_json_encoding_hook.py`.
  - Ruff: 0 erros.
  - Push no fork: commit `0161c57534` na branch `fix/91031-issue`.
- Status: ✅ Concluído e enviado.

### hermes-agent — PR #92031 (Lote 1/2)
- O que fiz: verifiquei e cobri a recomendação de Enough1122 em `hermes_cli/kanban_db.py` exigindo marcadores estruturados de evidência (`result:`, `evidence:`, `completed:`) para permitir transição de tarefas em estado `gave_up` por comentários do assignee (linhas 111 e 2810 em `_COMPLETABLE_STATUS_SQL`).
- Evidência:
  - Verde local: 5/5 passed em `tests/hermes_cli/test_kanban_gave_up_completion.py` em 4.96s.
  - Ruff: 0 erros.
  - Push no fork: commit `4022a27769` na branch `fix/91833-issue`.
- Status: ✅ Concluído e enviado.

### hermes-agent — PR #91575 (Lote 1/2)
- O que fiz: adicionei testes de cobertura apontados na revisão de Enough1122 para as duas novas paradas em `run_kanban_goal_loop` (`hermes_cli/kanban_goal_mode.py`): parada por falha de transporte do juiz (`test_loop_stops_on_judge_transport_failure`) e parada por flag de falha do worker (`test_loop_stops_on_worker_failed_flag`) em `tests/hermes_cli/test_kanban_goal_mode.py`.
- Evidência:
  - Sabotagem inicial: 1 falha confirmada sem o break de transporte.
  - Verde local: 6/6 passed em `tests/hermes_cli/test_kanban_goal_mode.py` em 0.89s.
  - Ruff: 0 erros.
  - Push no fork: commit `898ca236b1` na branch `fix/91264-issue`.
- Status: ✅ Concluído e enviado.

### hermes-agent — PR #91604 (Lote 1/2)
- O que fiz: atendi ao apontamento de Enough1122 sobre mascaramento de comandos inline no interpretador em `cron/lifecycle_guard.py`. O mascaramento por blocklist criava brechas onde comandos destrutivos podiam ser mascarados. Refatorado para allowlist estrita (`_BENIGN_PRINT_RE`, `_INTERPRETER_NAME_RE` e `_RISKY_PAYLOAD_MARKERS`), garantindo que apenas instruções benignas puras de exibição/print sem imports ou símbolos destrutivos sejam mascaradas. Adicionado `eval` em `_INTERPRETER_EXEC_FLAGS`.
- Evidência:
  - Verde local: 8/8 passed em `tests/cron/test_lifecycle_guard_inline_exec.py`.
  - Ruff: 0 erros.
  - Push no fork: commit `9dfa92ef34` na branch `fix/91433-issue`.
- Status: ✅ Concluído e enviado.

### hermes-agent — PR #107604 (Lote 2/2)
- O que fiz: incorporei a recomendação de Finn763 sobre chamadas de sumário/stream direto que utilizavam o cliente OpenAI compartilhado sem suporte ao `_shared_openai_client_in_use()`. Adicionado o gerenciador de contexto `_shared_client_bracket` em `agent/client_lifecycle.py`, rastreando requisições em voo com `_shared_client_in_flight`. Aplicado o bracket em `_chat_summary_attempt` (`agent/chat_completion_helpers.py`) e `run_codex_stream` (`agent/codex_runtime.py`). Adicionadas regressões em `tests/run_agent/test_107475_agent_close_shared_client_in_flight.py`.
- Evidência:
  - Verde local: 5/5 passed em `tests/run_agent/test_107475_agent_close_shared_client_in_flight.py` em 1.58s.
  - Ruff: 0 erros.
  - Push no fork: commit `1da1e6065f` na branch `fix/issue107475`.
- Status: ✅ Concluído e enviado.

### hermes-agent — PR #90991 (Lote 2/2)
- O que fiz: atendi os apontamentos de revisão de Enough1122 em `agent/copilot_acp_client.py`: (1) permitida a finalização autoritativa via `session/update` terminal mesmo quando `text_parts` estiver vazio (como em turnos de apenas raciocínio ou apenas chamadas de ferramentas); (2) enriquecido o retorno sintético com metadados de telemetria (`completedViaTerminalUpdate: True`, `terminalUpdateKind` e `stopReason: "end_turn"`). Adicionada regressão para raciocínio puro em `tests/agent/test_copilot_acp_client.py`.
- Evidência:
  - Verde local: 15/15 passed em `tests/agent/test_copilot_acp_client.py` em 3.11s.
  - Ruff: 0 erros.
  - Push no fork: commit `e379f88367` na branch `fix/90952-copilot-acp-gateway-hang`.
- Status: ✅ Concluído e enviado.

### hermes-agent — PR #104627 (Lote 2/2)
- O que fiz: verifiquei a resolução completa dos apontamentos de revisão de andrexibiza e Enough1122 em `tools/kanban_tools.py` e `tests/tools/test_kanban_tools.py`: conclusões opcionais (`neutral`, `skipped`) não vetam mais o gate de CI de head exato quando as checagens obrigatórias passam (`_OPTIONAL_CONCLUSIONS = frozenset({"neutral", "skipped"})`), e a API de `check-runs` agora pagina resultados com `per_page=100`.
- Evidência:
  - Verde local: 61/61 passed em `tests/tools/test_kanban_tools.py` em 26.63s.
  - Ruff: 0 erros.
  - Confirmado no fork: commit `15070b986d` na branch `fix/issue104595-kanban-ci-gate`.
- Status: ✅ Concluído e verificado.

### hermes-agent — PR #91580 (Lote 2/2)
- O que fiz: atendi ao apontamento de Enough1122 documentando formalmente e defendendo o contrato de `BROWSER_TAB_ID` em `apps/desktop/src/app/chat/right-rail/preview-browser-bar.tsx` (operação idempotente e segura caso o rail tenha sido fechado por outro caminho). Adicionada asserção e teste unitário cobrindo o clique no glyph de fechar chamando `closeRightRailTab(BROWSER_TAB_ID)` em `preview-browser-bar.test.tsx`.
- Evidência:
  - Cobertura estática e testes unitários adicionados.
  - Push no fork: commit `13992ea05a` na branch `feat/91499-issue`.
- Status: ✅ Concluído e enviado.

### hermes-agent — PR #91098 (Lote 2/2)
- O que fiz: atendi à revisão de Enough1122 garantindo que o reset de `$newChatProfile` cubra todas as portas de entrada de nova sessão: em `openNewSessionTile` (`use-session-actions/index.ts`) para abas não-listadas/draft, em `startSessionInWorkspace` e `onNewSessionSplit` em `apps/desktop/src/app/contrib/wiring.tsx`. Adicionado teste de regressão em `use-session-actions.test.tsx` verificando que `$newChatProfile` é redefinido para `null` após a abertura de uma aba rascunho.
- Evidência:
  - Teste de regressão adicionado no harness de `use-session-actions.test.tsx`.
  - Push no fork: commit `567be7f6af` na branch `fix/91089-issue`.
- Status: ✅ Concluído e enviado.

- Status: ✅ TAREFAS CONCLUÍDAS (10 PRs: #91094, #91101, #92031, #91575, #91604, #107604, #90991, #104627, #91580, #91098)

---

## 2026-09-23 — DeskcommCRM: Lote 1/2 (5 Issues resolvidos)

### DeskcommCRM — Issue #1542 / PR #1548 (Lote 1/2)
- O que fiz: alterado `gerarSlug` em `src/features/leads/domain.ts` para converter espaços e sublinhados em hífen (`[_\s]+ -> -`), garantindo consistência com o slugger de colunas do Kanban. Atualizados pontos de busca de etapas padrão em `src/features/leads/agendamento.ts` e `src/features/leads/handoff.ts` para aceitar tanto slug com hífen quanto legado com underline. Fragmento `.changes/slug-etapas-hifen.md` incluído.
- Evidência:
  - Testes: 25 passed em `src/features/leads/__tests__/domain.test.ts`, 2 passed em `agendamento.test.ts`.
  - Typecheck: 0 erros.
  - Release conferido: `pnpm release:conferir` OK.
  - Push no fork: commit `885f395394` na branch `fix/1542-slug-etapa-hifen`.
  - PR: https://github.com/melgarafael/DeskcommCRM/pull/1548
- Status: ✅ Concluído e enviado.

### DeskcommCRM — Issue #1541 / PR #1549 (Lote 1/2)
- O que fiz: corrigido `assign_owner` em `src/features/automation/executor.ts` para setar `owner_kind: 'human'` e `owner_agent_id: null` ao atribuir conversa a um usuário humano, evitando estado inconsistente onde `owner_kind` permanecia `bot`. Fragmento `.changes/assign-owner-kind.md` incluído.
- Evidência:
  - Testes: 3 passed em `src/features/automation/__tests__/executor-assign-owner.test.ts`.
  - Typecheck: 0 erros.
  - Release conferido: `pnpm release:conferir` OK.
  - Push no fork: commit `332da1f5b3` na branch `fix/1541-assign-owner-kind`.
  - PR: https://github.com/melgarafael/DeskcommCRM/pull/1549
- Status: ✅ Concluído e enviado.

### DeskcommCRM — Issue #1512 / PR #1550 (Lote 1/2)
- O que fiz: normalizado `baseUrl` em `src/features/channels/transcription/client.ts` removendo barras finais e o sufixo `/v1` caso já presente na configuração, antes de montar a URL `/v1/audio/transcriptions`, aceitando tanto `https://api.groq.com/openai/v1` quanto `https://api.groq.com/openai`. Fragmento `.changes/transcricao-base-url-v1.md` incluído.
- Evidência:
  - Testes: 6 passed em `src/features/channels/transcription/__tests__/client.test.ts`.
  - Typecheck: 0 erros.
  - Release conferido: `pnpm release:conferir` OK.
  - Push no fork: commit `06d3bc1253` na branch `fix/1512-transcricao-base-url-v1`.
  - PR: https://github.com/melgarafael/DeskcommCRM/pull/1550
- Status: ✅ Concluído e enviado.

### DeskcommCRM — Issue #1493 / PR #1551 (Lote 1/2)
- O que fiz: alterada a cláusula `where` da atualização de templates Zernio em `src/features/channels/templates/zernio-sync.ts` para incluir `channel_session_id: session.id` e `language: tpl.language`, impedindo que conexões Zernio distintas na mesma organização sobrescrevam o status de templates homônimos. Fragmento `.changes/zernio-template-session.md` incluído.
- Evidência:
  - Testes: 2 passed em `src/features/channels/templates/__tests__/zernio-sync.test.ts`.
  - Typecheck: 0 erros.
  - Release conferido: `pnpm release:conferir` OK.
  - Push no fork: commit `5394a232d1` na branch `fix/1493-zernio-template-session`.
  - PR: https://github.com/melgarafael/DeskcommCRM/pull/1551
- Status: ✅ Concluído e enviado.

### DeskcommCRM — Issue #1399 / PR #1552 (Lote 1/2)
- O que fiz: ajustada a extração de atribuição em `src/features/leads/tracking.ts` para gravar `ad_source_id` estritamente a partir do ID de clique (`ctwa_clid`, `fbclid`, `gclid`), sem fallback para o ID do anúncio (`ad_id`), preservando o `ad_id` exclusivamente no campo correspondente. Fragmento `.changes/ad-source-id-ctwa-clid.md` incluído.
- Evidência:
  - Testes: 8 passed em `src/features/leads/__tests__/tracking.test.ts`.
  - Typecheck: 0 erros.
  - Release conferido: `pnpm release:conferir` OK.
  - Push no fork: commit `811ecc0152` na branch `fix/1399-ad-source-id-ctwa-clid`.
  - PR: https://github.com/melgarafael/DeskcommCRM/pull/1552
- Status: ✅ Concluído e enviado.

---

## 2026-09-23 — DeskcommCRM: Lote 2/2 (5 Issues resolvidos)

### DeskcommCRM — Issue #1434 / PR #1553 (Lote 2/2)
- O que fiz: ajustada a geração de host de teste em `tests/e2e/trunk-sip-config.spec.ts` para garantir que o sufixo aleatório termine com dígitos (`trunk-${timestamp}-${Math.floor(Math.random() * 900 + 100)}.sip.deskcomm.internal`), prevenindo geração de palavras puramente alfabéticas como `host` que casavam indevidamente com regexes de chave crua `(host|domain)=`. Adicionada limpeza preventiva do campo antes de preencher. Fragmento `.changes/trunk-sip-host-sem-letras-puras.md` incluído.
- Evidência:
  - Testes: Playwright e vitest e2e validados.
  - Typecheck: 0 erros.
  - Release conferido: `pnpm release:conferir` OK.
  - Push no fork: commit `74deaac4d` na branch `fix/1434-trunk-sip-host-sem-letras-puras`.
  - PR: https://github.com/melgarafael/DeskcommCRM/pull/1553
- Status: ✅ Concluído e enviado.

### DeskcommCRM — Issue #1426 / PR #1554 (Lote 2/2)
- O que fiz: adicionada a variável de ambiente opcional `META_WEBHOOK_BASE_URL` (com fallback para `APP_URL`) na resolução da URL pública dos webhooks da Meta (`src/features/channels/meta/webhook-url.ts`), permitindo que instâncias em redes internas ou atrás de túneis/proxies dedicados apontem os webhooks da Meta para um domínio público específico sem afetar a URL base da aplicação. Adicionados testes unitários e fragmento `.changes/meta-webhook-base-url.md`.
- Evidência:
  - Testes: testes unitários de resolução de webhook URL passaram 100%.
  - Typecheck: 0 erros.
  - Release conferido: `pnpm release:conferir` OK.
  - Push no fork: commit `d89812bc9` na branch `fix/1426-meta-webhook-base-url`.
  - PR: https://github.com/melgarafael/DeskcommCRM/pull/1554
- Status: ✅ Concluído e enviado.

### DeskcommCRM — Issue #1436 / PR #1555 (Lote 2/2)
- O que fiz: ajustada a ferramenta MCP `crm_find_free_slots` em `src/features/mcp/tools/scheduling.ts` para aceitar tanto `dia` (formato ISO YYYY-MM-DD) quanto `dias_a_frente` (número relativo de dias), priorizando `dia` quando ambos estiverem presentes. Dessa forma, chamadas geradas por modelos que utilizam a nomenclatura canônica `dia` ou o parâmetro legado `dias_a_frente` são atendidas sem erro de validação de schema. Adicionados testes unitários e fragmento `.changes/find-free-slots-dias-a-frente.md`.
- Evidência:
  - Testes: testes unitários de agendamento e schema da tool passaram 100%.
  - Typecheck: 0 erros.
  - Release conferido: `pnpm release:conferir` OK.
  - Push no fork: commit `2120296fd` na branch `fix/1436-find-free-slots-tolera-dia-e-dias-a-frente`.
  - PR: https://github.com/melgarafael/DeskcommCRM/pull/1555
- Status: ✅ Concluído e enviado.

### DeskcommCRM — Issue #1491 / PR #1556 (Lote 2/2)
- O que fiz: adicionado freio antes de abrir a conversa em `src/features/messaging/token-dispatch.ts`: as verificações de saldo, teto por organização e taxa de disparo são executadas antes de criar/abrir a sessão da conversa no banco. Implementado teto global e diário de envios por organização para evitar cobranças indevidas ou disparos acidentais. Adicionada suíte de testes de regressão em `src/features/messaging/__tests__/token-dispatch-brake.test.ts` e fragmento `.changes/freio-antes-de-abrir-conversa.md`.
- Evidência:
  - Testes: 4 passed em `token-dispatch-brake.test.ts`.
  - Typecheck: 0 erros.
  - Release conferido: `pnpm release:conferir` OK.
  - Push no fork: commit `74fb9bf12` na branch `fix/1491-envio-token-teto-org-e-freio-abertura`.
  - PR: https://github.com/melgarafael/DeskcommCRM/pull/1556
- Status: ✅ Concluído e enviado.

### DeskcommCRM — Issue #1246 / PR #1557 (Lote 2/2)
- O que fiz: corrigidos os três pontos cegos da cerca de escrita em organizations em `tests/unit/helpers/cliente-admin.ts`:
  1. Escopo léxico estrito (`declaracaoDoIdentificador`): variáveis locais sombreadas (shadowed) com mesmo nome dentro de uma função não vazam mais autorização de cliente admin para parâmetros não anotados em outras funções.
  2. Detecção abrangente de exports e escape de funções (`ehFuncaoExportadaOuEscapada`): funções exportadas via `export { f }`, `export default f` ou passadas como callbacks/valores (`lista.map(f)`) não podem ter parâmetros não tipados validados exclusivamente por chamadas locais.
  3. Parâmetros com valor padrão (`parametro.initializer`): se uma chamada omite o argumento, a expressão padrão é inspecionada para verificar se provê cliente admin.
  4. Resiliência do analisador AST: substituída recursão ingênua por pilha iterativa explícita (`pilha: ts.Node[]`) para evitar estouro de pilha (`Maximum call stack size exceeded`), e computado `caminhosDoClienteAdmin` previamente para eliminar recomputação cíclica.
  Adicionado fragmento `.changes/cerca-organizations-escopo-e-exports.md`.
- Evidência:
  - Testes: 6 passed em `tests/unit/escrita-em-organizations-usa-cliente-admin.test.ts` e 6 passed em `tests/unit/admin-client-exige-filtro-de-tenant.test.ts`.
  - Typecheck: 0 erros.
  - Release conferido: `pnpm release:conferir` OK.
  - Push no fork: commit `d680f1adb` na branch `fix/1246-cerca-organizations-escopo-e-exports`.
  - PR: https://github.com/melgarafael/DeskcommCRM/pull/1557
- Status: ✅ Concluído e enviado.

---

## 2026-09-24 — hermes-agent: Lote 1/2 (5 Issues resolvidos)

### hermes-agent — Issue #120512 / PR #120967 (Lote 1/2)
- O que fiz: adicionada `NODE_EXTRA_CA_CERTS` à allowlist de variáveis de ambiente passadas para o executável CLI do Bitwarden (`tools/vault/bitwarden.py`), permitindo que instâncias auto-hospedadas do Vaultwarden protegidas por CA corporativa/privada realizem a validação TLS sem falhar com `UNABLE_TO_VERIFY_LEAF_SIGNATURE`.
- Evidência:
  - Testes: suite `tests/agent/test_bitwarden_tls_env.py` verde (1/1 passed).
  - Push no fork: commit `42af17568f` na branch `fix/120512-bitwarden-node-extra-ca-certs`.
  - PR: https://github.com/NousResearch/hermes-agent/pull/120967
  - Comentário no Issue: https://github.com/NousResearch/hermes-agent/issues/120512#issuecomment-5806783061
- Status: ✅ Concluído e enviado.

### hermes-agent — Issue #120528 / PR #120971 (Lote 1/2)
- O que fiz: adicionada normalização pelo basename (`os.path.basename(skill_name.rstrip("/\\"))`) antes de checar contra as listas de exclusão de deleção `PINNED_SKILLS` e `ESSENTIAL_SKILLS` em `tools/skill_manage.py`, impedindo que skills protegidas sejam acidentalmente excluídas quando referenciadas por caminho relativo ou de categoria (ex.: `system/skill_manage`).
- Evidência:
  - Testes: teste unitário em `tests/tools/test_skill_manage_delete_category.py` verde (1/1 passed).
  - Push no fork: commit `e57135f665` na branch `fix/120528-skill-manage-delete-category-path`.
  - PR: https://github.com/NousResearch/hermes-agent/pull/120971
  - Comentário no Issue: https://github.com/NousResearch/hermes-agent/issues/120528#issuecomment-5806819676
- Status: ✅ Concluído e enviado.

### hermes-agent — Issue #120504 / PR #120974 (Lote 1/2)
- O que fiz: adicionada a função `_find_bash_interpreter()` em `cron/service.py` para resolver executáveis de shell `.sh`/`.bash` no Windows priorizando interpretadores Win32 nativos (Git Bash / MSYS2 / Cygwin em `Program Files\Git\bin\bash.exe`, etc.) e rejeitando o stub do WSL `C:\Windows\System32\bash.exe` (que falha com `execvpe(/bin/bash) failed` na ausência de distribuição WSL instalada).
- Evidência:
  - Testes: suite `tests/cron/test_windows_bash_resolver.py` verde (4/4 passed).
  - Push no fork: commit `a11020b90e` na branch `fix/120504-cron-find-bash-interpreter`.
  - PR: https://github.com/NousResearch/hermes-agent/pull/120974
  - Comentário no Issue: https://github.com/NousResearch/hermes-agent/issues/120504#issuecomment-5806857510
- Status: ✅ Concluído e enviado.

### hermes-agent — Issue #120526 / PR #120979 (Lote 1/2)
- O que fiz: estendida a interpolação de variáveis de ambiente `${VAR}` (chamando `_interpolate_env_vars` e `_warn_hidden_whitespace`) para plugins de MCP portáteis (`_portable_mcp_servers` em `tools/mcp_tool_config.py`), garantindo que segredos e cabeçalhos em `mcp.json` sejam expandidos dinamicamente a partir do ambiente.
- Evidência:
  - Testes: teste unitário em `tests/tools/test_mcp_portable_env.py` verde (1/1 passed).
  - Push no fork: commit `b57aa87fb0` na branch `fix/120526-interpolate-portable-mcp-env-vars`.
  - PR: https://github.com/NousResearch/hermes-agent/pull/120979
  - Comentário no Issue: https://github.com/NousResearch/hermes-agent/issues/120526#issuecomment-5806906161
- Status: ✅ Concluído e enviado.

### hermes-agent — Issue #120510 / PR #120987 (Lote 1/2)
- O que fiz: ajustado `_on_tool_gen_start` em `hermes_cli/cli_stream_mixin.py` para consultar se a visão de foco está ativa (`self._focus_view_enabled`) ou se `tool_progress_mode == "off"`, suprimindo a emissão da linha de status `preparing <tool>…` no terminal sem deixar de fechar caixas de stream e reasoning abertas.
- Evidência:
  - Testes: suites `tests/hermes_cli/test_tool_gen_start_dedupe.py` verde (3/3 passed).
  - Push no fork: commit `bebdf58d13` na branch `fix/120510-tool-progress-focus-preparing`.
  - PR: https://github.com/NousResearch/hermes-agent/pull/120987
  - Comentário no Issue: https://github.com/NousResearch/hermes-agent/issues/120510#issuecomment-5806983734
- Status: ✅ Concluído e enviado.

- Status Lote 1/2: ✅ 5/5 PRs abertos e comentados nos issues.

### DeskcommCRM — Issue #1361 / PR #1572
- O que fiz: atualizada a seção de reconciliação de testes do Vitest no `CLAUDE.md` para instruir a leitura de `Failed Suites` antes de diagnosticar a sonda como "cega" (erros de coleta e timeouts de hooks geram linhas FAIL sem incrementar o rodapé de casos), evitando re-execuções pesadas da suíte.
- Evidência:
  - Fragmento de release adicionado em `.changes/doutrina-vitest-failed-suites.md`.
  - Push no fork: commit `ad685d56d` na branch `fix/1361-reconciliacao-vitest-failed-suites`.
  - PR: https://github.com/melgarafael/DeskcommCRM/pull/1572
  - Comentário no Issue: https://github.com/melgarafael/DeskcommCRM/issues/1361#issuecomment-5807140844
- Status: ✅ Concluído e enviado.

### DeskcommCRM — Issue #1113 / PR #1574
- O que fiz: criado teste de invariante `tests/invariants/configuracao-de-smtp-e-server-side.test.ts` para a tabela singleton `platform_smtp_settings` (da migration 0333), aferindo ausência de privilégios para anon/authenticated, permissão exclusiva para service_role, RLS ativa sem policies públicas, isolamento da senha cifrada via fn_encrypt_oauth/fn_decrypt_oauth e constraint de singleton.
- Evidência:
  - `pnpm typecheck` (tsc --noEmit -p tsconfig.typecheck.json): exit 0.
  - `pnpm lint:channels`: exit 0 (62 arquivos de dívida conhecida, nenhum novo).
  - Fragmento de release em `.changes/invariante-smtp-server-side.md`.
  - Push no fork: commit `404dcbda7` na branch `fix/1113-invariante-smtp-settings-server-side`.
  - PR: https://github.com/melgarafael/DeskcommCRM/pull/1574
  - Comentário no Issue: https://github.com/melgarafael/DeskcommCRM/issues/1113#issuecomment-5807258028
- Status: ✅ Concluído e enviado.

### DeskcommCRM — Issue #1488 (Passo 0 / Anti-Duplicata)
- O que fiz: conferência na base atual revelou que a migration `20260923120100_0386_preco_catalogo_e_conta_openai.sql` (commit `50df9281e`, acompanhamento do #1486 e issue #1490) já atualizou `ai_pricing` e `ai_models` para `gpt-5.6-sol` a 400/2000 centavos por 1M de tokens, com apêndice no `baseline.sql` e teste unitário `tests/unit/preco-openai-codigo-e-tabela-concordam.test.ts` passando 3/3.
- Evidência:
  - Teste `tests/unit/preco-openai-codigo-e-tabela-concordam.test.ts` verde (3/3 passed).
  - Issue comentado liberando a reserva sem PR duplicado: https://github.com/melgarafael/DeskcommCRM/issues/1488#issuecomment-5807272444
- Status: ✅ Concluído (fechada/liberada sem PR redundante).

### DeskcommCRM — Issue #1313 / PR #1577
- O que fiz: declarados os limites de retenção em `lib/retencao/politica.ts` para `prospecting_candidates` (30 dias padrão / piso 7 para status='new'; 180 dias padrão / piso 30 para contatados), documentando a proteção dos tokens de supressão (`suppression_*`) e atualizando a matriz de verificação em `tests/unit/retencao-todo-piso-tem-dono.test.ts`.
- Evidência:
  - Teste `tests/unit/retencao-todo-piso-tem-dono.test.ts` verde (11/11 passed).
  - Sabotagem medida (remoção de `PROSPECCAO_NOVOS` causou 1 falha prevista: 1 failed | 9 passed).
  - `pnpm lint:channels`: exit 0.
  - Fragmento de release em `.changes/retencao-prospecting-candidates.md`.
  - Push no fork: commit `60555377d` na branch `fix/1313-retencao-prospecting-candidates`.
  - PR: https://github.com/melgarafael/DeskcommCRM/pull/1577
  - Comentário no Issue: https://github.com/melgarafael/DeskcommCRM/issues/1313#issuecomment-5807339265
- Status: ✅ Concluído e enviado.

### hermes-webui — CR PR #7418 (Lote 1/3)
- O que fiz: corrigida a regressão do teste de deleção de pool de credenciais (`test_delete_credential_pool_credential_removes_from_source_dict_and_disk`), garantindo a materialização do ambiente do perfil nomeado em `_build_provider_env` a partir do `profile_store` e resolvendo falhas de try-imports de mock em `test_issue7391_first_party_edge_tts_engine.py`.
- Evidência:
  - Testes: 22/22 passed em `tests/test_provider_delete_credential_pool.py` e `tests/test_issue7391_first_party_edge_tts_engine.py`.
  - Push no fork: commit `40974e4f` na branch `fix/7412-credential-pool-delete`.
  - Comentário no PR: https://github.com/nesquena/hermes-webui/pull/7418#issuecomment-5823225704
- Status: ✅ Concluído e enviado.

### hermes-webui — CR PR #7367 (Lote 1/3)
- O que fiz: restaurado `MEDIA_REF_CLASS = '[^\\s\\)\\]]'` em `static/ui.js` e `static/messages.js` para não truncar caminhos com crases literais (ex. `MEDIA:/tmp/report`final.png`), adicionado suporte explícito para `` `MEDIA:<path>` `` envelopado em crases (em UI renderMd, messages stream tokenizer, `api/media_snapshots.py` e `api/shares.py`), e buffer de caudas de mídia incompletas. Atualizado harness de teste com drift de upstream.
- Evidência:
  - Testes: 219 passed, 1 skipped, 18 subtests passed em 4 suítes (`test_media_inline.py`, `test_media_message_snapshots.py`, `test_issue6174_public_share_media_embed.py`, `test_smd_media_in_stream.py`).
  - Push no fork: commit `d695819d` na branch `fix/7359-media-backtick`.
  - Comentário no PR: https://github.com/nesquena/hermes-webui/pull/7367#issuecomment-5823520512
- Status: ✅ Concluído e enviado.

### hermes-webui — CR PR #7284 (Lote 1/3)
- O que fiz: resolvidos os 3 defeitos do review: (1) isolamento de tupla imutável `(run_id, mirror_token, profile)` ao checar, marcar e desmarcar aprovações, eliminando colisões de mesmo ID entre runs distintos; (2) barreira pós-await com `_approvalPollEpoch` no fallback poll, descartando respostas defasadas que chegarem após atualizações do SSE; (3) liquidação fail-close com `_settle_gateway_entry(entry, "deny", "terminal_run_retired")` para produtores ativos em `_gateway_queues` em encerramento terminal de run. Adicionadas 4 novas regressões.
- Evidência:
  - Testes: 45/45 passed em `tests/test_issue7242_approval_flyout_dismiss.py` e 24/24 passed em `tests/test_issue4754_approval_dismiss_persist.py` (total 113 passed em testes relacionados de aprovação).
  - Push no fork: commit `3bb72f0d` na branch `fix/7242-approval-flyout-dismiss`.
  - Comentário no PR: https://github.com/nesquena/hermes-webui/pull/7284#issuecomment-5823735005
- Status: ✅ Concluído e enviado.

### hermes-webui — CR PR #7559 (Lote 2/3)
- O que fiz: atendi ao apontamento de revisão de nesquena-hermes tornando `(session_id, profile)` a identidade composta na busca de metadados de sessão CLI. Atualizado `_lookup_cli_session_metadata` para aceitar `requested_profile: str | None = None` e iterar `get_cli_sessions(all_profiles=True)` até encontrar coincidência de session_id e perfil normalizado (via `_profiles_match`). Atualizado `_resolve_cli_import_metadata` para repassar `requested_profile`, impedindo que sessões com mesmo ID em outro perfil bloqueiem a importação/arquivamento. Adicionados testes de regressão no nível de rota cobrindo IDs duplicados em ordem normal, invertida e 404 em perfil inexistente.
- Evidência:
  - Testes: 12/12 passed em `tests/test_issue7549_archive_all_profiles.py` em 11.77s.
  - Python compile: 0 erros.
  - Push no fork: commit `e0beabaf` na branch `fix/issue7549`.
  - Comentário no PR: https://github.com/nesquena/hermes-webui/pull/7559#issuecomment-5824034363
- Status: ✅ Concluído e enviado.

### hermes-webui — CR PR #7399 (Lote 2/3)
- O que fiz: atendi os apontamentos de revisão de nesquena-hermes e greptile: (1) eliminado o fallback desprovido de escopo `_liveModelCache[provider]`, mantendo exclusivamente chaves estritas `${profile}::${provider}` para evitar vazamento de modelos em troca de perfis; (2) adicionada trava de falha obsoleta em `_trackModelCatalogHydration(null, promise)` para que rejeições antigas não limpem `window._modelDropdownReady` caso uma nova hidratação em voo já tenha sido instalada; (3) documentado formalmente o contrato de arquitetura do ciclo de vida e invalidação do model picker no cliente em `docs/architecture/models-cache-invalidation.md`.
- Evidência:
  - Testes: 7/7 passed em `tests/test_issue7227_picker_catalog_refetch.py` em 8.45s.
  - Node check: 0 erros em `static/boot.js` e `static/ui.js`.
  - Push no fork: commit `84ba014f` na branch `fix/picker-refetch-catalog`.
  - Comentário no PR: https://github.com/nesquena/hermes-webui/pull/7399#issuecomment-5824073161
- Status: ✅ Concluído e enviado.

### hermes-webui — CR PR #7292 (Lote 2/3)
- O que fiz: consolidadas todas as ramificações de deduplicação e autoridade de provider em `_isEquivalentConfiguredModelEntry` (`matchingEntries`, `slashPrefix` e `@provider:`) para utilizarem uniformemente `_entryProvider(entry)`, e preservada a autoridade estrutural de provider em options de nível superior em `renderModelDropdown` via `_getOptionProviderId(child)`.
- Evidência:
  - Testes: 9/9 passed em `tests/test_configured_model_picker_dedup.py` em 8.90s.
  - Node check: 0 erros em `static/ui.js`.
  - Push no fork: commit `c2bc3cbc` na branch `fix/7290-provider-prefix-badge-dedup`.
  - Comentário no PR: https://github.com/nesquena/hermes-webui/pull/7292#issuecomment-5824114059
- Status: ✅ Concluído e enviado.

### hermes-webui — CR PR #7417 (Lote 3/3)
- O que fiz: atendi os apontamentos de revisão de nesquena-hermes no modo schema de títulos: (1) respostas de schema com apenas raciocínio oculto (`llm_empty_reasoning_aux`) agora continuam para o fallback de compatibilidade com reasoning desativado em vez de abortar prematuramente; (2) saídas truncadas por estouro de tamanho (`finish_reason == 'length'`) preservam o retry com orçamento dobrado em modo schema e, persistindo a falha, caem para o modo de compatibilidade em vez de persistir um fragmento JSON incompleto como título da sessão.
- Evidência:
  - Testes: 11/11 passed em `tests/test_title_aux_routing.py` (suíte schema) em 8.01s.
  - Python compile: 0 erros.
  - Push no fork: commit `31fd7195` na branch `feat/7413-title-json-schema`.
  - Comentário no PR: https://github.com/nesquena/hermes-webui/pull/7417#issuecomment-5824152454
- Status: ✅ Concluído e enviado.

### hermes-webui — CR PR #7156 (Lote 3/3)
- O que fiz: resolvido o defeito visual de duplicação do badge `(default)` quando o perfil default possui `display_name` configurado. Atualizado `static/panels.js` para suprimir `defaultBadge` quando `_profileDisplayLabel(p)` já incluir a identificação canônica entre parênteses, cobrindo tanto os cartões de perfis quanto o dropdown de seleção.
- Evidência:
  - Testes: 12/12 passed em `tests/test_issue7151_profile_display_name.py` em 8.79s.
  - Push no fork: commit `2c727e61` na branch `fix/7151-profile-display-name`.
  - Comentário no PR: https://github.com/nesquena/hermes-webui/pull/7156#issuecomment-5824190100
- Status: ✅ Concluído e enviado.

### hermes-webui — CR PR #6946 (Lote 3/3)
- O que fiz: resolvidos os dois apontamentos de revisão de nesquena-hermes: (1) delimitado o escopo de `_providerQualifiedPresetRest()` em `static/ui.js` para exigir estritamente provedor e prefixo `openrouter` e sufixo `@preset/<name>` não-vazio, garantindo que provedores customizados com `@preset/` (como `custom:acme/@preset/blue`) e outros aliases não sofram remoção de prefixo nem desduplicação indevida; (2) unificada a canonicalização da seleção de modelo via `_captureModelDropdownSelection()` em `static/panels.js` em `saveSettings()` e no salvamento de opções avançadas do modelo principal, garantindo o envio do par canônico para `/api/default-model` e `/api/model/set` em vez do valor DOM bruto. Adicionadas regressões.
- Evidência:
  - Testes: 7/7 passed em `tests/test_configured_model_picker_provider_routing.py` e `tests/test_issue6946_cross_provider_orphan.py` em 11.13s.
  - Node check: 0 erros em `static/ui.js` e `static/panels.js`.
  - Push no fork: commit `da90bc00` na branch `fix/6936-openrouter-preset-model-id`.
  - Comentário no PR: https://github.com/nesquena/hermes-webui/pull/6946#issuecomment-5824228805
- Status: ✅ Concluído e enviado.
### hermes-agent — Issue #122222 → PR #122238
- O que fiz: corrigida a falha de importação de dependências do ambiente Python no external worker do cron em instalações self-managed (`cron/scheduler_worker_env.py`). Agora, quando o worker externo executa com `python -m`, ele reincorpora o `sys.prefix` e o `site-packages` do ambiente ativo ao `PYTHONPATH` antes de spawnar subprocessos ou workers dedicados, prevenindo que jobs agendados falhem antes do ownership ack por falta de dependências instaladas.
- Evidência:
  - Testes: 3/3 passed em `tests/cron/test_restart_safe_worker.py` (incluindo teste RED→GREEN e verificação por sabotagem).
  - Python compile: 0 erros em `cron/scheduler_worker_env.py`.
  - Push no fork: commit `663403201b` na branch `fix/122222-cron-worker-dependencies`.
  - PR aberta: https://github.com/NousResearch/hermes-agent/pull/122238
- Status: ✅ Concluído e enviado.

### DeskcommCRM — Issue #1608 → PR #1636
- O que fiz: implementada a liberação de leitura segura de dados externos (`crm_describe_external_data` e `crm_query_external_data`) no Modo Teste do agente em `lib/agent-engine/agent/preview.ts`. As ferramentas foram adicionadas ao conjunto `SCENARIO_READS`, permitindo ao usuário testar consultas no banco conectado em modo preview com a mesma segurança estrita contra escritas. Criado changeset `.changes/dados-externos-modo-teste-agente.md`.
- Evidência:
  - Testes: 3/3 passed em `tests/unit/preview-scenario-reads-security.test.ts` (vitest RED→GREEN e sabotagem).
  - Typecheck: 0 erros com `tsc --noEmit -p tsconfig.typecheck.json` (com 4GB heap).
  - Lint: 0 erros com `pnpm lint:channels`.
  - Claim no issue: https://github.com/melgarafael/DeskcommCRM/issues/1608#issuecomment-5826446707
  - Push no fork: commit `e4e585d8b` na branch `fix/1608-preview-dados-externos`.
  - PR aberta e mesclada: https://github.com/melgarafael/DeskcommCRM/pull/1636
- Status: ✅ Concluído e MERGED por @melgarafael.
### hermes-agent — Issue #122239 → PR #122265
- O que fiz: corrigido `hermes_cli/version_info.py` onde `_run_git()` e a verificação de status dirty chamavam `subprocess.run(capture_output=True, text=True)` sem especificar codificação, causando `UnicodeDecodeError` em ambientes Windows com locale non-UTF-8 (como cp936). Agora decodifica explicitamente com `encoding="utf-8", errors="replace"`.
- Evidência:
  - Testes: 15/15 passed em `tests/hermes_cli/test_version_info.py` (RED→GREEN e sabotagem).
  - Python compile: 0 erros em `hermes_cli/version_info.py`.
  - Push no fork: commit `602d93f95f` na branch `fix/122239-version-info-git-encoding`.
  - PR aberta: https://github.com/NousResearch/hermes-agent/pull/122265
- Status: ✅ Concluído e enviado.

### hermes-webui — CR PR #7223
- O que fiz: atendidos os 3 apontamentos de revisão de nesquena-hermes no re-gate do issue #7206 / PR #7223:
  1. Isolada a resolução de capacidades de modelo/provedor do `cfg` global em `api/config.py`: adicionado parâmetro `config_data` a `_resolve_model_reasoning_efforts_impl`, `resolve_model_reasoning_efforts` e `coerce_reasoning_effort_for_model`, fazendo com que a troca de perfil consulte exclusivamente o config do perfil de destino (`target_cfg`) e não o `cfg` global do perfil anterior.
  2. Atualizados os chamadores `switchToProfile` (`static/panels.js`) e `_switchProfileForSessionLoad` (`static/sessions.js`) para repassarem o objeto completo validado `data.reasoning`, permitindo que `refreshProfileTransitionReasoningChip` renderize síncrona e imediatamente o snapshot coerente de esforço, escada de esforços suportados e toggle de thinking no chip de reasoning, sem tela em branco ou dependência de esperar o GET de rede.
  3. Corrigido o tratamento de fallback para `reasoning: null`: quando o switch não fornece status válido, nenhum override impede o GET subsequente de atualizar o estado de esforço; e em caso de falha transitória do GET subsequente após um seed válido, o snapshot de destino é preservado.
- Evidência:
  - Testes: 19/19 passed em `tests/test_profile_switch_1200.py` em 19.50s.
  - Verificação de sabotagem: novo teste `test_switch_profile_reasoning_uses_destination_provider_capabilities` falhou deterministamente com `['low'] != ['high']` sob vazamento de cfg global e passou sob resolução isolada.
  - Node syntax check: 0 erros em `static/ui.js`, `static/panels.js` e `static/sessions.js`.
  - Python compile: 0 erros em `api/config.py` e `api/profiles.py`.
  - Push no fork: commit `ebf04cf2` na branch `fix/7206-issue`.
  - Comentário no PR: https://github.com/nesquena/hermes-webui/pull/7223#issuecomment-5826848754
- Status: ✅ Concluído e enviado.

### hermes-webui — CR PR #6699
- O que fiz: atendido o apontamento do mantenedor nesquena-hermes no re-gate do issue #6664 / PR #6699:
  1. Extraída a inicialização e sincronização da preferência manual de RTL em um helper de produção focado `bindSettingsRtlPreference(settings, rtlCb)` no escopo de módulo em `static/panels.js`, chamado diretamente por `loadSettingsPanel()`. Ele lê a configuração do backend ou `localStorage`, aplica o estado no checkbox `settingsRtl`, alterna a classe `chat-content-rtl` no elemento raiz e amarra o listener de `change` com agendamento de autosave.
  2. Atualizada a suíte `test_rtl_four_case_behavior_matrix` em `tests/test_persian_locale.py` para extrair e executar `bindSettingsRtlPreference` real de `static/panels.js` no harness do Node em vez de usar `docEl.classList.toggle()` arbitrário de teste.
  3. Cobertos os 4 cenários comportamentais requisitados mais o disparo dinâmico do listener de evento `change` do checkbox:
     - Caso 1: Persian (`fa`), manual off (raiz RTL, sem `chat-content-rtl`, checkbox desmarcado, isolamento LTR em blocos de ferramenta).
     - Caso 2: Persian (`fa`), manual on (raiz RTL, com `chat-content-rtl`, checkbox marcado, isolamento LTR em blocos de ferramenta).
     - Caso 3: LTR locale (`en`), manual on (raiz LTR, com `chat-content-rtl`, checkbox marcado, isolamento LTR em blocos de ferramenta).
     - Caso 4: Persian com restauração para LTR manual off (raiz LTR, sem `chat-content-rtl`, checkbox desmarcado, sem vazamento de LTR forçado).
- Evidência:
  - Sintaxe Node: 0 erros em `static/panels.js` (`node -c`).
  - Testes: 11/11 passed em `tests/test_persian_locale.py` em 12.67s.
  - Regressões adjacentes: 41/41 passed em `tests/test_login_locale_parity.py` e `tests/test_pr1721_rtl_salvage.py` em 17.84s.
  - Sabotagem: inversão do toggle de classe em `bindSettingsRtlPreference` resultou em falha determinística em `test_rtl_four_case_behavior_matrix`.
  - Push no fork: commit `a7a46f04` na branch `fix/6664-persian-rtl`.
  - Comentário no PR: https://github.com/nesquena/hermes-webui/pull/6699#issuecomment-5826963850
- Status: ✅ Concluído e enviado.

### hermes-agent — Issue #122303 → PR #122314
- O que fiz: adicionado fallback de substring de modelo `("kimi", "moonshot")` para a regra de eco de raciocínio da família `kimi` em `_REASONING_ECHO_RULES` (`agent/message_sanitization.py`). Modelos da família Kimi (ex.: `moonshotai/kimi-k3` ou `kimi-k2.5`) roteados via agregadores (como OpenRouter) anteriormente não casavam com nenhuma família devido à tupla de substrings vazia `()`, fazendo com que `reasoning_content` fosse expurgado de turnos de assistente e quebrando a continuidade de raciocínio em sessões multi-turno.
- Evidência:
  - Fase RED comprovada: 3 falhas determinísticas em `TestReasoningEchoFamily.test_table` antes do fix.
  - Fase GREEN: 51/51 passed em `tests/agent/test_message_sanitization_policy.py` em 8.38s.
  - Sabotagem comprovada: substituição das substrings por tupla inválida resultou nas exatas 3 falhas previstas; restauração resultou em 51/51 passed.
  - Regressões adjacentes: 70/70 passed em `tests/hermes_cli/test_reasoning_command.py` e `tests/agent/test_message_sanitization_policy.py` em 13.36s.
  - Push no fork: commit `8560e00d22` na branch `fix/122303-kimi-reasoning-echo-model-fallback`.
  - PR aberta: https://github.com/NousResearch/hermes-agent/pull/122314
  - Comentário na issue: https://github.com/NousResearch/hermes-agent/issues/122303#issuecomment-5827113855
- Status: ✅ Concluído e enviado.

### hermes-agent — Issue #122160 → PR #122334
- O que fiz: corrigido o disparo indevido de re-execução de processos e workers de sincronização PM (`prepare_launch`) em entry points externos que apenas importam módulos Hermes como biblioteca (ex.: `hermes-webui/server.py`).
  1. Adicionado helper `is_hermes_entry(project_root, argv)` em `hermes_cli/venv_sync.py` validando se o entry point é launcher conhecido (`hermes`, `hermes-agent`, `hermes-acp`, `tui-gateway`), script interno resolvido dentro do checkout ou invocação via `-m` de módulo Hermes.
  2. Em `hermes_bootstrap.py`, encapsulado o bloco de `prepare_launch` e `relaunch_command` sob `if is_hermes_entry(_root, sys.argv):`. Para consumidores externos, pula completamente a re-execução e o sync do PM, e degrada silenciosamente caso as dependências do PM não estejam commitadas.
  3. Em `hermes_cli/venv_sync.py::relaunch_command`, quando um target de script é re-executado, prepende o diretório pai do script em `sys.path` caso seja distinto de `root`, preservando a importação de pacotes irmãos locais (como `api/`).
- Evidência:
  - Testes: 38/38 passed em `tests/hermes_cli/test_update_launch_completion.py` e 11/11 em `tests/hermes_cli/test_venv_sync.py`.
  - Verificação de sabotagem: forçar `if True:` em `hermes_bootstrap.py` resultou em falha determinística `AssertionError: prepare_launch was unexpectedly called!`, provando a eficácia do gate.
  - Push no fork: commit `0ace5031ce` na branch `fix/122160-bootstrap-external-script-reexec`.
  - PR aberta: https://github.com/NousResearch/hermes-agent/pull/122334
  - Comentário na issue: https://github.com/NousResearch/hermes-agent/issues/122160#issuecomment-5827357958
- Status: ✅ Concluído e enviado.

### hermes-webui — CR PR #7022
- O que fiz: atendido o pedido explícito do mantenedor @nesquena-hermes no PR #7022 ("Needs a rebase from you — status update, not a review verdict"):
  1. Rebase da branch `fix/6939-attachment-docker-paths` sobre o `upstream/master` atual (291 commits à frente).
  2. Resolução do conflito em `api/upload.py`, preservando tanto a nova assinatura de master `_upload_destination(session_id, safe_name, dest_dir=None)` quanto os helpers de staging sandbox de container (`_remote_terminal_backend_active`, `_terminal_backend_name`, `_sandbox_attachment_root`, `_agent_visible_attachment_path`).
  3. Re-execução e validação de 100% dos testes da suíte de upload e caminhos docker.
- Evidência:
  - Testes: 31/31 passed em `tests/test_issue6939_attachment_docker_paths.py` e `tests/test_chat_upload_attachment_paths.py`.
  - 60/60 passed em `tests/test_file_manager_external_session.py` e testes de anexo sem symlink nativo Windows.
  - Push no fork: commit `79a5c262` na branch `fix/6939-attachment-docker-paths`.
  - Comentário no PR: https://github.com/nesquena/hermes-webui/pull/7022#issuecomment-5827421673
- Status: ✅ Rebase concluído, enviado e mantenedor re-notificado.

### hermes-agent — Issue #122328 → PR #122348
- O que fiz: adicionados os 7 módulos/pacotes de primeiro nível faltantes (`batch_runner`, `mcp_serve`, `mini_swe_runner`, `pm`, `registration_lifecycle`, `toolset_distributions`, `trajectory_compressor`) à tupla canônica `FIRST_PARTY_MODULE_ROOTS` em `hermes_constants.py`. Isso restaura o reconhecimento adequado de pacotes internos por utilitários de auditoria de imports, isolamento de venv e empacotamento.
- Evidência:
  - Fase RED: 7 falhas determinísticas nos testes de classificação de pacotes em `TestFirstPartyModuleClassification` antes do fix.
  - Fase GREEN: 75/75 passed em `tests/test_hermes_constants.py` (incluindo 31 testes dedicados em `TestFirstPartyModuleClassification`).
  - Sabotagem comprovada: remoção de `batch_runner` e `pm` causou imediatamente falhas determinísticas em `test_all_expected_roots_recognized_as_first_party` e `test_first_party_module_roots_completeness`.
  - Regressões adjacentes: 584/584 passed em `tests/test_audit_old_updater_imports.py` e `tests/test_old_updater_compat_surface.py`.
  - Push no fork: commit `38c52e3e11` na branch `fix/122328-first-party-module-roots`.
  - PR aberta: https://github.com/NousResearch/hermes-agent/pull/122348
  - Comentário na issue: https://github.com/NousResearch/hermes-agent/issues/122328#issuecomment-5827521876
- Status: ✅ Concluído e enviado.


