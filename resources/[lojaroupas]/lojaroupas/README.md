# Loja de Roupas - RADEX STORE

Resource de loja de roupas para a base **vRP** com NUI moderna, preview em tempo real no boneco, carrinho e pagamento via `vRP.PaymentFull`.

## Instalacao

1. Copie a pasta `[lojaroupas]` para dentro de `resources/`.
   Caminho final: `resources/[lojaroupas]/lojaroupas/`

2. No seu `server.cfg`, adicione a linha (apos os outros `start`):

   ```
   ensure [lojaroupas]
   ```

   Ou especificamente:

   ```
   ensure lojaroupas
   ```

3. Reinicie o servidor. Pronto.

## Como funciona

- Tem um **blip** no mapa no ponto `-1597.51, -1027.47, 13.18` (Vespucci Beach).
- Ao chegar perto, aparece um **marker azul ciano** no chao.
- Pressione **E** para abrir a loja.
- Escolha categorias na **lateral esquerda** (Mascaras, Chapeus, Camisas, Jaquetas, Maos, Calcas, Sapatos, etc).
- Clique em qualquer peca para **visualizar em tempo real no seu personagem** (a roupa muda na hora).
- Os itens selecionados vao para o **carrinho** com o total.
- Use as setas de rotacao para girar o boneco.
- **Comprar**: desconta o valor em dinheiro e salva no skinshop oficial da base (persiste no banco).
- **Cancelar / ESC**: restaura suas roupas originais.

## Customizar

Tudo fica em `config.lua`:

- `Config.Location` -> coordenada da loja.
- `Config.Blip` -> sprite / cor / nome do blip.
- `Config.Categories` -> categorias e itens (drawable / texture / preco).

Para adicionar mais lojas em outros pontos, basta duplicar a estrutura
(ou pedir pra eu transformar `Location` em uma lista de varias).

## Tecnico

- Usa **Tunnel/Proxy** do vRP igual aos outros scripts da base.
- Integra com **`skinshop`** existente:
  - Pega a roupa atual via `exports.skinshop:CurrentClothes()`.
  - Aplica preview com `SetPedComponentVariation` / `SetPedPropIndex`.
  - Ao confirmar compra, dispara `skinshop:Apply` com `Save=true`,
    que ja persiste no `playerdata/SetData` (mesmo metodo do `/skinshop`).
- Usa `Notify` da base para mensagens (verde / amarelo).
- Registra ponto via `hoverfy:Insert` (igual aos outros scripts).
