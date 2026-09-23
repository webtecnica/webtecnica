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

