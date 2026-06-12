# wnBoost - Sistema de Otimização FPS

Sistema de otimização de FPS para servidores FiveM com framework vRP.

## 📋 Requisitos

- FiveM Server
- Framework vRP (creative_v5, vrpex ou creative_network)
- MySQL/MariaDB

## 🚀 Instalação

1. **Coloque a pasta `wnBoost` dentro de `resources`**

2. **Execute o SQL no seu banco de dados:**
   - Abra o arquivo `sql.sql` e execute no seu banco de dados
   - Ou deixe o script criar a tabela automaticamente na primeira execução

3. **Configure o arquivo `config/config.lua`:**
   - Altere o `Config.Framework` para o seu framework
   - Altere o `Config.Nome_Cidade` para o nome da sua cidade
   - Configure os webhooks do Discord (opcional)
   - Configure a permissão de admin

4. **Adicione no `server.cfg`:**
```cfg
ensure wnBoost
```

## 📝 Comandos

| Comando | Descrição |
|---------|-----------|
| `/fpsboost` | Abre o painel de otimização (todos os jogadores) |
| `/fpsadmin` | Abre o painel de admin (apenas admins) |
| `/abrirfps` | Alternativa para abrir o painel |

## ⚙️ Configurações

### Framework
```lua
Config.Framework = "creative_v5" -- creative_v5 / vrpex / creative_network
```

### Permissões
```lua
Config.Permissoes = {
    ['Abrir-painel'] = "Admin", -- Grupo necessário para acessar painel admin
}
```

### Webhooks Discord
```lua
Config.Webhooks = {
    ['Feedbacks'] = "URL_DO_WEBHOOK",
    ['Deletar'] = "URL_DO_WEBHOOK"
}
```

## 🎮 Funcionalidades

### Para Jogadores:
- ✅ Ajuste de distância de carregamento
- ✅ Otimização de texturas
- ✅ Otimização de sombras
- ✅ Otimização de luzes
- ✅ Sistema de feedback com estrelas

### Para Admins:
- ✅ Visualizar quantidade de veículos no servidor
- ✅ Visualizar quantidade de peds no servidor
- ✅ Deletar todos os veículos
- ✅ Deletar todos os peds
- ✅ Visualizar feedbacks dos jogadores

## 📁 Estrutura de Arquivos

```
wnBoost/
├── client-side/
│   └── client.lua
├── config/
│   └── config.lua
├── server-side/
│   └── server.lua
├── stream/
│   └── (arquivos de stream)
├── web-side/
│   ├── assets/
│   │   ├── imgs/
│   │   └── (imagens)
│   ├── css.css
│   ├── index.html
│   └── jquery.js
├── fxmanifest.lua
├── sql.sql
└── README.md
```

## 🔧 Solução de Problemas

### O painel não abre
- Verifique se o script está iniciado no server.cfg
- Verifique o console do F8 por erros
- Certifique-se que o framework está configurado corretamente

### Erro de SQL
- Execute o arquivo `sql.sql` manualmente no banco de dados
- Verifique se a conexão com o banco está funcionando

### Painel admin não funciona
- Verifique se você tem a permissão configurada em `Config.Permissoes['Abrir-painel']`

## 📞 Suporte

- Discord: https://discord.gg/sXjmKjQj5J
- Documentação: https://docs.warn-nuis.com/

---
**wnBoost** - Sistema de Otimização FPS para FiveM

