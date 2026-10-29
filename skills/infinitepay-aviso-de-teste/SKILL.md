---
name: infinitepay-aviso-de-teste
description: Use when colhendo um aviso real da InfinitePay para o PR #3590. Prova webhook sem colar segredo.
version: 1.0.0
author: webtecnica
license: MIT
metadata:
  hermes:
    tags: [infinitepay, webhook, pagamentos, deskcommcrm, pr-3590]
    related_skills: [deskcomm-crm-contribuicao, revisao-de-pr-de-terceiros]
---

# Aviso real da InfinitePay (PR #3590 / issue #3509)

## When to Use

- O PR `melgarafael/DeskcommCRM#3590` precisa da prova de webhook real que o mantenedor exigiu.
- Alguém pediu para "validar a InfinitePay", "capturar o aviso do pagamento", ou destravar o PR
  de link de pagamento.
- Antes de mexer em `lib/pagamentos/assinatura.ts` para escolher entre `hmac` e `token`: essa
  escolha depende da captura, não de suposição.
- Rodando no PC do dono, com navegador logado na conta InfinitePay (o único lugar que alcança
  `app.infinitepay.io`).

Colher **um aviso (webhook) real de pagamento** da InfinitePay e publicá-lo no PR
`melgarafael/DeskcommCRM#3590` — no formato que o mantenedor aceita: corpo, cabeçalho
e identificador, **sem nenhum segredo**.

## Por que isso existe

O mantenedor **bloqueou o PR de propósito** até ver um aviso real:

> "o link de pagamento só entra depois que alguém com conta InfinitePay capturar um aviso real
> de teste. É o que mostra o formato, o cabeçalho e o identificador que o provedor manda de
> verdade. Se você tiver conta, um aviso de teste resolve; mostre só a forma, sem colar segredo."

O código (`lib/pagamentos/assinatura.ts`) suporta dois modos e **não sabe qual é o real**:

- `hmac` — `X-Assinatura: t=<unix>,v1=<hex64>` (padrão Stripe; o provedor assinaria)
- `token` — `X-Webhook-Token: <segredo>` (token estático; "o que a InfinitePay permite hoje")

A doc oficial descreve o **corpo** mas **não documenta cabeçalho de assinatura**. Só o aviso real
decide. Não invente: sem a captura, não há como escolher o modo com honestidade.

## Pitfalls medidos (não redescubra)

1. **`external_checkout_not_enabled`** — a API responde 404 com esse erro enquanto o checkout
externo não estiver ligado na conta. É o passo zero, e é o que mais trava:
`https://app.infinitepay.io/external-checkout#configuracoes?enabled=true`
2. **Não existe sandbox** documentado. O teste é uma venda real (R$ 1,00) na conta do dono —
o dinheiro volta para ele, menos a taxa.
3. **`price` é em CENTAVOS**: R$ 1,00 = `100`.
4. **`handle` sem o `$`**: a InfiniteTag aparece como `$joaosilva`, use `joaosilva`.
5. **`app.infinitepay.io` é área logada** — `web_extract` cai na tela de login (QR Code).
Só o navegador do dono alcança. Peça print ou use computer-use.
6. **Nomes parecidos**: é **InfinitePay** (com E), não "Infinity Pay". Buscar errado no
GitHub não retorna nada e dá a impressão de que o pedido não existe.

## Procedimento

### 0. Habilitar o checkout externo

Abrir `https://app.infinitepay.io/external-checkout#configuracoes?enabled=true` e ligar.
Sem isso todo `POST /links` falha com `external_checkout_not_enabled`.

### 1. Handle (InfiniteTag)

App InfinitePay → perfil/conta, ou `app.infinitepay.io` → perfil, ou um comprovante de
recebimento ("para `$handle`"). Guardar **sem o `$`**.

### 2. URL de captura

Abrir `https://webhook.site` — gera sozinho uma URL única (`https://webhook.site/<uuid>`).
Não precisa de conta; dura 7 dias. **Deixar a aba aberta**: é onde o aviso aparece.

### 3. Gerar o link apontando o aviso para a captura

```bash
scripts/criar-link-infinitepay.sh <handle> <url-do-webhook.site> [centavos]
```

O script monta `POST https://api.checkout.infinitepay.io/links` com `webhook_url`, `order_nsu`
único (`teste-aviso-3509-<timestamp>`) e valor de R$ 1,00 por padrão. Ele imprime o `url` do
checkout — é o que se abre para pagar.

### 4. Pagar

Abrir o `url` retornado, pagar (Pix é mais rápido) e **clicar em Continuar** para o redirect.

### 5. Colher a prova

No webhook.site, copiar:

- o **corpo** inteiro (JSON)
- **todos os cabeçalhos** da requisição
- o **identificador** que veio (`order_nsu`, `transaction_nsu`, `invoice_slug`)

Campos esperados no corpo (pela doc): `invoice_slug`, `amount`, `paid_amount`,
`installments`, `capture_method`, `transaction_nsu`, `order_nsu`, `receipt_url`, `items`.

Contraste a registrar explicitamente: **quais cabeçalhos vieram** e se algum é assinatura.
É isso que decide entre `hmac` e `token` no `assinatura.ts`.

### 6. Publicar no PR sem segredo

Comentar em `melgarafael/DeskcommCRM#3590` com:

- o corpo em bloco de código, valores sensíveis trocados por `[REDACTED]`
- a lista de cabeçalhos com o **nome** de todos e o valor apenas dos inofensivos
(`content-type`, `user-agent`); qualquer token/assinatura → `[REDACTED]`
- a conclusão: o provedor assina? manda token? não manda nada?
- qual modo do `assinatura.ts` isso confirma

**Nunca** colar: token de webhook, segredo HMAC, chave de API, dado de cliente.
Se o aviso vier com dado pessoal, tarjar antes.

## Onde está o código (para o comentário do PR)

```
lib/pagamentos/assinatura.ts      modos hmac x token, fail closed
lib/pagamentos/confirmar.ts       o que o aviso faz (fecha negócio pelo caminho do Ganhar)
app/api/v1/webhooks/pagamento/[provedor]/route.ts   a rota pública
```

O PR já está **MERGEABLE** (head `7a1743cab`) — o bloqueio é só a prova, não o diff.

## Uso pelo Hermes com navegador

Quando rodando no PC do dono, dá para fazer tudo por computer-use: abrir a página de
configurações, ligar o checkout externo, abrir `webhook.site`, copiar a URL do DOM, rodar o
script no terminal, e ler o corpo/cabeçalhos direto da tela do webhook.site.
O único ponto que **exige o dono** é o pagamento (Pix/cartão).
