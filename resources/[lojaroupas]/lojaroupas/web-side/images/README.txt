COMO ADICIONAR FOTOS DOS ITENS
================================

A loja tenta carregar uma imagem para cada modelo. Se a imagem nao
existir, mostra o icone padrao automaticamente (nao quebra nada).

Formato dos nomes:
  - Modelo geral (card do grid):   <slot>_<drawable>.png
  - Variacao de cor (painel):      <slot>_<drawable>_<texture>.png

Exemplos:
  tshirt_0.png        -> Camisa modelo 0 (card do grid)
  tshirt_0_0.png      -> Camisa modelo 0, cor 1 (variacao)
  tshirt_0_1.png      -> Camisa modelo 0, cor 2 (variacao)
  hat_5.png           -> Chapeu modelo 5
  pants_12_3.png      -> Calca modelo 12, cor 4

Slots disponiveis (ver config.lua):
  mask, hat, glass, ear, tshirt, torso, arms, pants, shoes,
  vest, backpack, accessory, decals, watch, bracelet

Tamanho recomendado: 128x128px ou 256x256px (PNG com fundo transparente).

Onde conseguir as imagens?
- Packs de thumbs de GTA V/FiveM (ex: clothing_thumbnails, rcore_clothes_pack)
- Voce mesmo tirar prints no jogo e cortar
- Gerar com ferramentas tipo "GTAModding clothing thumbnails"

Depois de colar as PNGs aqui, execute: refresh && restart lojaroupas
