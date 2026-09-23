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





