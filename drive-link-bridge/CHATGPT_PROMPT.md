# Prompt para ChatGPT — links "Abrir no Meu Drive local"

Use este texto como instrução persistente ou cole no início de uma conversa em que o ChatGPT tenha acesso ao Google Drive do usuário.

---

Quando eu pedir para localizar, criar ou editar um arquivo no meu Google Drive, além do link normal do Google Drive, gere também um link **Abrir no computador** usando o projeto DriveLinkBridge.

Regras obrigatórias:

1. Antes de montar o caminho, determine a **hierarquia completa e real de pastas no Google Drive**, seguindo os `parent_ids`/metadados do arquivo ou pasta até chegar em **Meu Drive**. Nunca presuma que a pasta encontrada está diretamente na raiz.
2. Para o link DriveLinkBridge, remova apenas o prefixo virtual `Meu Drive/` e preserve todo o restante da hierarquia. Exemplo:
   - Drive: `Meu Drive/documentos/AÇÕES/CLIENTE/arquivo.pdf`
   - caminho relativo: `documentos\AÇÕES\CLIENTE\arquivo.pdf`
3. URL-encode o caminho relativo e monte exatamente:
   `https://josepilas.github.io/drive-link-bridge/?rel=<CAMINHO_RELATIVO_URL_ENCODED>`
4. O caminho relativo NÃO deve conter letra de unidade (`G:`, `H:` etc.). A letra/unidade é configurada no computador de cada usuário pelo instalador.
5. Entregue, nesta ordem:
   - `📂 Abrir no computador` — link DriveLinkBridge;
   - `☁️ Abrir no Google Drive` — link oficial do Google Drive;
   - caminho legível completo, por exemplo `G:\Meu Drive\documentos\AÇÕES\CLIENTE\arquivo.pdf`, somente quando a raiz local do usuário for conhecida.
6. Se o arquivo estiver em "Compartilhados comigo", Drive compartilhado ou fora de "Meu Drive", não invente um caminho local. Informe que o link local só deve ser produzido quando houver um caminho mapeável sob a raiz configurada.
7. Ao criar um arquivo dentro de uma pasta do Google Drive, use a mesma hierarquia real para o link local depois de confirmar o arquivo criado e seu pai.
8. Não use `file:///`, `search-ms:`, `shell:` nem links de protocolo diretamente na resposta. O primeiro clique deve ser sempre HTTPS pelo DriveLinkBridge.

Exemplo final:

`📂 Abrir no computador` → `https://josepilas.github.io/drive-link-bridge/?rel=documentos%5CA%C3%87%C3%95ES%5CCLIENTE%5Carquivo.pdf`

`☁️ Abrir no Google Drive` → link oficial retornado pelo Google Drive.

`G:\Meu Drive\documentos\AÇÕES\CLIENTE\arquivo.pdf`

---
