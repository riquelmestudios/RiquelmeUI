<p align="center">
  <img src="https://files.catbox.moe/2lzab2.jpg" width="200" />
</p>

<h1 align="center">RiquelmeUI</h1>

<p align="center">
  Interface profissional para scripts Roblox
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Status-Ativo-green?style=for-the-badge">
  <img src="https://img.shields.io/badge/Version-1.0-blue?style=for-the-badge">
  <img src="https://img.shields.io/badge/Roblox-Lua-red?style=for-the-badge">
</p>

<p align="center">
  <a href="https://riquelme-dev.netlify.app/home">
    <img src="https://img.shields.io/badge/Site-Acessar-black?style=for-the-badge&logo=google-chrome">
  </a>
  <a href="https://discord.gg/76PJPm8GNY">
    <img src="https://img.shields.io/badge/Discord-Entrar-5865F2?style=for-the-badge&logo=discord">
  </a>
  <a href="https://whatsapp.com/channel/0029Vb7iZ6R35fLyYrWnZy0s">
    <img src="https://img.shields.io/badge/WhatsApp-Canal-25D366?style=for-the-badge&logo=whatsapp">
  </a>
</p>

---

## Sobre o Projeto

A RiquelmeUI é uma interface feita em Lua para Roblox, criada para facilitar o desenvolvimento de scripts.

Evite perder tempo criando interfaces do zero.  
Com a RiquelmeUI, basta importar e utilizar.

Aplicações ideais:
- Hubs de scripts  
- Sistemas administrativos  
- Menus personalizados  
- Projetos profissionais  

---

## Vantagens

- Design moderno (black style)  
- Fácil integração  
- Leve e otimizada  
- Totalmente personalizável  
- Economia de tempo no desenvolvimento  

---

## Como usar

```lua
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