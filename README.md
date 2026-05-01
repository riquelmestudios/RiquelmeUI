# 🎮 RiquelmeUI - Interface Roblox Lua

> Interface moderna, otimizada e pronta pra uso em scripts Roblox 🚀

---

## 📌 Sobre o Projeto

A **RiquelmeUI** é uma interface feita em **Lua para Roblox**, criada pra facilitar a vida de quem desenvolve scripts.

Chega de perder tempo criando UI do zero 😴  
Com a RiquelmeUI você simplesmente **importa e usa**.

💡 Ideal para:
- Hubs de scripts
- Sistemas administrativos
- Menus personalizados
- Projetos profissionais

---

## ⚡ Vantagens

✔ Design moderno (black style)  
✔ Fácil de integrar  
✔ Leve e otimizada  
✔ Totalmente personalizável  
✔ Economiza MUITO tempo  

---

## 🌐 Acesse

🔗 Site:  
https://riquelme-dev.netlify.app/home  

💬 Discord:  
https://discord.gg/76PJPm8GNY  

📢 WhatsApp Channel:  
https://whatsapp.com/channel/0029Vb7iZ6R35fLyYrWnZy0s  

---

## 🧠 Como usar

```lua
-- Exemplo básico (pode adaptar conforme seu sistema)

local UI = loadstring(game:HttpGet("LINK_DA_UI_AQUI"))()

UI:CreateWindow({
    Name = "RiquelmeUI"
})

UI:CreateButton({
    Name = "Botão Teste",
    Callback = function()
        print("Funcionando")
    end
})