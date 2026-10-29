# Skills publicadas

Copias das skills do perfil `webtecnica` que precisam rodar em outros lugares
(ex.: o Hermes do PC, que tem navegador).

Para usar numa instalacao Hermes, copie a pasta da skill para o diretorio de
skills do perfil:

    cp -r skills/<nome> ~/.hermes/skills/<nome>
    # ou, com perfil: ~/.hermes/profiles/<perfil>/skills/<nome>

Depois e so chamar `skill_view(name='<nome>')`.

- `infinitepay-aviso-de-teste` — colher aviso real de webhook da InfinitePay
  (PR melgarafael/DeskcommCRM#3590). Precisa de navegador logado na conta.
