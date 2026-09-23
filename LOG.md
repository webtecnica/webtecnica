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



