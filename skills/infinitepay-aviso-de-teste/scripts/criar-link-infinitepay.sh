#!/usr/bin/env bash
# Cria um link de checkout da InfinitePay apontando o aviso (webhook) para uma
# URL de captura. Serve para colher UM aviso real de teste — a prova que o
# mantenedor pediu no PR #3590 (issue #3509).
#
# Uso:
#   ./criar-link-infinitepay.sh <handle> <url-de-captura> [valor-em-centavos]
#
#   <handle>           InfiniteTag da conta, SEM o "$" do inicio
#   <url-de-captura>   ex.: https://webhook.site/00000000-1111-2222-3333-444444444444
#   [valor]            padrao 100 (= R$ 1,00). O valor vai em CENTAVOS.
#
# NAO coloque segredo aqui: a InfinitePay nao usa token de API para gerar link,
# so o handle. O segredo do nosso lado e o X-Webhook-Token, configurado na tela
# de Cobranca da instalacao — e ele NAO entra nesta requisicao.
#
# Se a API responder {"error":"external_checkout_not_enabled"}, habilite antes:
#   https://app.infinitepay.io/external-checkout#configuracoes?enabled=true

set -euo pipefail

HANDLE="${1:?uso: $0 <handle> <url-de-captura> [centavos]}"
CAPTURA="${2:?uso: $0 <handle> <url-de-captura> [centavos]}"
VALOR="${3:-100}"

NSU="teste-aviso-3509-$(date +%s)"

payload=$(cat <<JSON
{
  "handle": "${HANDLE}",
  "items": [
    { "quantity": 1, "price": ${VALOR}, "description": "Teste de aviso (PR 3590)" }
  ],
  "order_nsu": "${NSU}",
  "webhook_url": "${CAPTURA}",
  "redirect_url": "https://example.com/pagamento-concluido"
}
JSON
)

echo "order_nsu deste teste: ${NSU}"
echo "valor: ${VALOR} centavos"
echo "aviso vai para: ${CAPTURA}"
echo

resposta=$(curl -sS -X POST 'https://api.checkout.infinitepay.io/links' \
  -H 'Content-Type: application/json' \
  --data "$payload" \
  --max-time 40)

echo "--- resposta ---"
echo "$resposta"
echo
echo "Abra o 'url' acima, pague (Pix de R\$ $(awk "BEGIN{printf \"%.2f\", ${VALOR}/100}")),"
echo "e o aviso cai na URL de captura. Copie de la:"
echo "  1) o corpo JSON inteiro"
echo "  2) TODOS os cabecalhos (headers) da requisicao"
