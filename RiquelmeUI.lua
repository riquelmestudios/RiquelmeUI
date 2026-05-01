--[[
Interface Riquelme Dev
]]

-- ═══════════════════════════════════════════════════════════════════
--  SERVIÇOS
-- ═══════════════════════════════════════════════════════════════════

local Players        = game:GetService("Players")
local RunService     = game:GetService("RunService")
local TweenService   = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui        = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse       = LocalPlayer:GetMouse()

-- ═══════════════════════════════════════════════════════════════════
--  ASSETS
-- ═══════════════════════════════════════════════════════════════════

local ASSETS = {
    Logo         = "rbxassetid://99990741111604",
    SideNotif    = "rbxassetid://87444469158140",
    IconClose    = "rbxassetid://116447909270552",
    IconMinimize = "rbxassetid://115558082558028",

    SoundClick   = "rbxassetid://113397864512278",
    SoundMinimize= "rbxassetid://86070307558627",
    SoundClose   = "rbxassetid://115044676553154",
    SoundOpen    = "rbxassetid://129993339892259",
}

-- ═══════════════════════════════════════════════════════════════════
--  TEMA
-- ═══════════════════════════════════════════════════════════════════

local THEME = {
    BG           = Color3.fromRGB(10,  10,  12),
    BG2          = Color3.fromRGB(16,  16,  20),
    BG3          = Color3.fromRGB(22,  22,  28),
    Surface      = Color3.fromRGB(28,  28,  35),
    SurfaceHover = Color3.fromRGB(35,  35,  44),
    Border       = Color3.fromRGB(45,  45,  58),
    BorderLight  = Color3.fromRGB(60,  60,  75),
    Accent       = Color3.fromRGB(255, 255, 255),
    AccentDim    = Color3.fromRGB(160, 160, 175),
    Text         = Color3.fromRGB(230, 230, 235),
    TextDim      = Color3.fromRGB(130, 130, 145),
    TextMuted    = Color3.fromRGB(75,  75,  90),
    Toggle       = Color3.fromRGB(50,  200, 120),
    ToggleOff    = Color3.fromRGB(55,  55,  68),
    Slider       = Color3.fromRGB(255, 255, 255),
    TabActive    = Color3.fromRGB(255, 255, 255),
    TabInactive  = Color3.fromRGB(70,  70,  85),
    Notification = Color3.fromRGB(18,  18,  24),
    Divider      = Color3.fromRGB(35,  35,  45),
    Shadow       = Color3.fromRGB(0,   0,   0),
}

-- ═══════════════════════════════════════════════════════════════════
--  UTILIDADES
-- ═══════════════════════════════════════════════════════════════════

local function Tween(obj, props, duration, style, direction)
    style     = style     or Enum.EasingStyle.Quart
    direction = direction or Enum.EasingDirection.Out
    return TweenService:Create(obj, TweenInfo.new(duration, style, direction), props):Play()
end

local function PlaySound(id)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume  = 0.5
    s.Parent  = CoreGui
    s:Play()
    game:GetService("Debris"):AddItem(s, 3)
end

local function Corner(r, parent)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r)
    c.Parent = parent
    return c
end

local function Stroke(c, t, parent)
    local s = Instance.new("UIStroke")
    s.Color     = c
    s.Thickness = t
    s.Parent    = parent
    return s
end

local function Padding(top, right, bottom, left, parent)
    local p = Instance.new("UIPadding")
    p.PaddingTop    = UDim.new(0, top)
    p.PaddingRight  = UDim.new(0, right)
    p.PaddingBottom = UDim.new(0, bottom)
    p.PaddingLeft   = UDim.new(0, left)
    p.Parent = parent
    return p
end

local function ListLayout(spacing, parent, hor)
    local l = Instance.new("UIListLayout")
    l.SortOrder       = Enum.SortOrder.LayoutOrder
    l.Padding         = UDim.new(0, spacing)
    if hor then l.FillDirection = Enum.FillDirection.Horizontal end
    l.Parent = parent
    return l
end

local function new(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        obj[k] = v
    end
    obj.Parent = parent
    return obj
end

-- ═══════════════════════════════════════════════════════════════════
--  BIBLIOTECA PRINCIPAL
-- ═══════════════════════════════════════════════════════════════════

local RiquelmeUI = {}
RiquelmeUI.__index = RiquelmeUI

-- ─── Root ScreenGui ─────────────────────────────────────────────

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name             = "RiquelmeUI"
ScreenGui.ResetOnSpawn     = false
ScreenGui.ZIndexBehavior   = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder     = 999

pcall(function()
    ScreenGui.Parent = CoreGui
end)
if not ScreenGui.Parent then
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

-- ─── Notification Queue ─────────────────────────────────────────

local NotifContainer = new("Frame", {
    Name             = "NotifContainer",
    Size             = UDim2.new(0, 280, 1, 0),
    Position         = UDim2.new(1, -290, 0, 0),
    BackgroundTransparency = 1,
    ZIndex           = 200,
}, ScreenGui)

local NotifList = Instance.new("UIListLayout")
NotifList.SortOrder       = Enum.SortOrder.LayoutOrder
NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifList.Padding         = UDim.new(0, 8)
NotifList.Parent          = NotifContainer

Padding(0, 0, 16, 0, NotifContainer)

local notifOrder = 0

local function SendNotification(cfg)
    notifOrder = notifOrder + 1

    local NFrame = new("Frame", {
        Name             = "Notif_"..notifOrder,
        Size             = UDim2.new(1, 0, 0, 72),
        BackgroundColor3 = THEME.Notification,
        BackgroundTransparency = 1,
        LayoutOrder      = notifOrder,
        ZIndex           = 200,
    }, NotifContainer)
    Corner(10, NFrame)
    Stroke(THEME.Border, 1, NFrame)

    -- Ícone lateral
    local IconFrame = new("Frame", {
        Size             = UDim2.new(0, 4, 1, -16),
        Position         = UDim2.new(0, 8, 0, 8),
        BackgroundColor3 = THEME.Accent,
        BorderSizePixel  = 0,
        ZIndex           = 201,
    }, NFrame)
    Corner(2, IconFrame)

    -- Logo na notif
    local LogoImg = new("ImageLabel", {
        Size             = UDim2.new(0, 28, 0, 28),
        Position         = UDim2.new(0, 20, 0, 8),
        BackgroundTransparency = 1,
        Image            = ASSETS.SideNotif,
        ZIndex           = 201,
    }, NFrame)
    Corner(4, LogoImg)

    -- Título
    new("TextLabel", {
        Size             = UDim2.new(1, -60, 0, 18),
        Position         = UDim2.new(0, 56, 0, 8),
        BackgroundTransparency = 1,
        Text             = cfg.Title or "Notificação",
        TextColor3       = THEME.Text,
        TextSize         = 13,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 201,
    }, NFrame)

    -- Mensagem
    new("TextLabel", {
        Size             = UDim2.new(1, -60, 0, 30),
        Position         = UDim2.new(0, 56, 0, 26),
        BackgroundTransparency = 1,
        Text             = cfg.Message or "",
        TextColor3       = THEME.TextDim,
        TextSize         = 11,
        Font             = Enum.Font.Gotham,
        TextXAlignment   = Enum.TextXAlignment.Left,
        TextWrapped      = true,
        ZIndex           = 201,
    }, NFrame)

    -- Barra de progresso
    local BarBG = new("Frame", {
        Size             = UDim2.new(1, -16, 0, 2),
        Position         = UDim2.new(0, 8, 1, -10),
        BackgroundColor3 = THEME.Border,
        BorderSizePixel  = 0,
        ZIndex           = 201,
    }, NFrame)
    Corner(2, BarBG)

    local Bar = new("Frame", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = THEME.Accent,
        BorderSizePixel  = 0,
        ZIndex           = 202,
    }, BarBG)
    Corner(2, Bar)

    -- Fade in
    Tween(NFrame, {BackgroundTransparency = 0.1}, 0.25)

    local duration = cfg.Duration or 4

    -- Progresso
    Tween(Bar, {Size = UDim2.new(0, 0, 1, 0)}, duration, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    task.delay(duration, function()
        Tween(NFrame, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.35)
        NFrame:Destroy()
    end)
end

-- ═══════════════════════════════════════════════════════════════════
--  SPLASH SCREEN (LOGO)
-- ═══════════════════════════════════════════════════════════════════

local SplashFrame = new("Frame", {
    Name             = "Splash",
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = THEME.BG,
    ZIndex           = 300,
}, ScreenGui)

-- Grid decorativo de fundo
local GridDecor = new("ImageLabel", {
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    Image            = "rbxassetid://6772884648",
    ImageTransparency = 0.95,
    ZIndex           = 300,
}, SplashFrame)

-- Logo centralizada
local SplashLogo = new("ImageLabel", {
    Size             = UDim2.new(0, 120, 0, 120),
    Position         = UDim2.new(0.5, -60, 0.5, -70),
    BackgroundTransparency = 1,
    Image            = ASSETS.Logo,
    ImageTransparency = 1,
    ZIndex           = 301,
}, SplashFrame)
Corner(12, SplashLogo)

-- Nome abaixo da logo
local SplashText = new("TextLabel", {
    Size             = UDim2.new(0, 300, 0, 24),
    Position         = UDim2.new(0.5, -150, 0.5, 60),
    BackgroundTransparency = 1,
    Text             = "RIQUELME DEV",
    TextColor3       = THEME.Text,
    TextTransparency = 1,
    TextSize         = 16,
    Font             = Enum.Font.GothamBold,
    LetterSpacing    = 6,
    ZIndex           = 301,
})
SplashText.Parent = SplashFrame

local SplashSub = new("TextLabel", {
    Size             = UDim2.new(0, 300, 0, 18),
    Position         = UDim2.new(0.5, -150, 0.5, 86),
    BackgroundTransparency = 1,
    Text             = "riquelme-dev.netlify.app",
    TextColor3       = THEME.TextMuted,
    TextTransparency = 1,
    TextSize         = 11,
    Font             = Enum.Font.Gotham,
    ZIndex           = 301,
})
SplashSub.Parent = SplashFrame

-- Linha decorativa
local SplashLine = new("Frame", {
    Size             = UDim2.new(0, 0, 0, 1),
    Position         = UDim2.new(0.5, 0, 0.5, 50),
    BackgroundColor3 = THEME.Accent,
    BackgroundTransparency = 1,
    BorderSizePixel  = 0,
    ZIndex           = 301,
})
SplashLine.Parent = SplashFrame

-- Animação de entrada da splash
task.spawn(function()
    task.wait(0.2)
    -- Fade in logo
    Tween(SplashLogo, {ImageTransparency = 0}, 0.6, Enum.EasingStyle.Quart)
    task.wait(0.3)
    -- Linha expande
    Tween(SplashLine, {
        Size = UDim2.new(0, 200, 0, 1),
        Position = UDim2.new(0.5, -100, 0.5, 50),
        BackgroundTransparency = 0
    }, 0.5, Enum.EasingStyle.Quart)
    task.wait(0.2)
    -- Texto aparece
    Tween(SplashText, {TextTransparency = 0}, 0.4)
    task.wait(0.15)
    Tween(SplashSub, {TextTransparency = 0.3}, 0.4)
    -- Aguarda
    task.wait(2.5)
    -- Fade out tudo
    Tween(SplashLogo,  {ImageTransparency = 1},    0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    Tween(SplashText,  {TextTransparency  = 1},    0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    Tween(SplashSub,   {TextTransparency  = 1},    0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    Tween(SplashLine,  {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 1)}, 0.5)
    task.wait(0.3)
    Tween(SplashFrame, {BackgroundTransparency = 1}, 0.4)
    task.wait(0.45)
    SplashFrame:Destroy()
end)

-- ═══════════════════════════════════════════════════════════════════
--  CRIAR JANELA PRINCIPAL
-- ═══════════════════════════════════════════════════════════════════

function RiquelmeUI.CreateWindow(config)
    config = config or {}

    local Title      = config.Title      or "Riquelme UI"
    local Subtitle   = config.Subtitle   or "by Riquelme Dev"
    local ScriptName = config.ScriptName or "Script"

    -- ─── Espera splash ─────────────────────────────────────────

    task.wait(4.2)

    -- ─── Janela Principal ───────────────────────────────────────

    local WIN_W, WIN_H = 620, 440

    local MainFrame = new("Frame", {
        Name             = "MainFrame",
        Size             = UDim2.new(0, WIN_W, 0, WIN_H),
        Position         = UDim2.new(0.5, -WIN_W/2, 0.5, -WIN_H/2),
        BackgroundColor3 = THEME.BG,
        BorderSizePixel  = 0,
        ZIndex           = 10,
    }, ScreenGui)
    Corner(14, MainFrame)
    Stroke(THEME.Border, 1, MainFrame)

    -- Sombra externa
    local Shadow = new("ImageLabel", {
        Name             = "Shadow",
        Size             = UDim2.new(1, 60, 1, 60),
        Position         = UDim2.new(0, -30, 0, -20),
        BackgroundTransparency = 1,
        Image            = "rbxassetid://6014261993",
        ImageColor3      = Color3.new(0, 0, 0),
        ImageTransparency = 0.5,
        ZIndex           = 9,
        ScaleType        = Enum.ScaleType.Slice,
        SliceCenter      = Rect.new(49, 49, 450, 450),
    }, MainFrame)

    -- ─── Header ──────────────────────────────────────────────

    local Header = new("Frame", {
        Name             = "Header",
        Size             = UDim2.new(1, 0, 0, 52),
        BackgroundColor3 = THEME.BG2,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, MainFrame)
    Corner(14, Header)

    -- Corrigir cantos inferiores do header
    new("Frame", {
        Size             = UDim2.new(1, 0, 0, 14),
        Position         = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = THEME.BG2,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, Header)

    Padding(0, 14, 0, 14, Header)

    local HeaderLayout = Instance.new("UIListLayout")
    HeaderLayout.FillDirection = Enum.FillDirection.Horizontal
    HeaderLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    HeaderLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
    HeaderLayout.Padding = UDim.new(0, 10)
    HeaderLayout.SortOrder = Enum.SortOrder.LayoutOrder
    HeaderLayout.Parent = Header

    -- Logo pequena no header
    local HeaderLogo = new("ImageLabel", {
        Size             = UDim2.new(0, 28, 0, 28),
        BackgroundColor3 = THEME.Surface,
        Image            = ASSETS.Logo,
        ZIndex           = 12,
        LayoutOrder      = 1,
    }, Header)
    Corner(6, HeaderLogo)

    -- Separador
    new("Frame", {
        Size             = UDim2.new(0, 1, 0, 24),
        BackgroundColor3 = THEME.Border,
        BorderSizePixel  = 0,
        ZIndex           = 12,
        LayoutOrder      = 2,
    }, Header)

    -- Títulos
    local TitleContainer = new("Frame", {
        Size             = UDim2.new(0, 200, 1, 0),
        BackgroundTransparency = 1,
        ZIndex           = 12,
        LayoutOrder      = 3,
    }, Header)

    new("TextLabel", {
        Size             = UDim2.new(1, 0, 0, 20),
        Position         = UDim2.new(0, 0, 0, 6),
        BackgroundTransparency = 1,
        Text             = Title,
        TextColor3       = THEME.Text,
        TextSize         = 14,
        Font             = Enum.Font.GothamBold,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 12,
    }, TitleContainer)

    new("TextLabel", {
        Size             = UDim2.new(1, 0, 0, 14),
        Position         = UDim2.new(0, 0, 0, 28),
        BackgroundTransparency = 1,
        Text             = Subtitle,
        TextColor3       = THEME.TextMuted,
        TextSize         = 10,
        Font             = Enum.Font.Gotham,
        TextXAlignment   = Enum.TextXAlignment.Left,
        ZIndex           = 12,
    }, TitleContainer)

    -- Botões de controle (direita)
    local ControlFrame = new("Frame", {
        Size             = UDim2.new(0, 60, 1, 0),
        Position         = UDim2.new(1, -74, 0, 0),
        BackgroundTransparency = 1,
        ZIndex           = 12,
    }, Header)

    local BtnLayout = Instance.new("UIListLayout")
    BtnLayout.FillDirection = Enum.FillDirection.Horizontal
    BtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    BtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    BtnLayout.Padding = UDim.new(0, 6)
    BtnLayout.Parent = ControlFrame

    local function MakeControlBtn(icon, order)
        local Btn = new("ImageButton", {
            Size             = UDim2.new(0, 26, 0, 26),
            BackgroundColor3 = THEME.Surface,
            Image            = icon,
            ImageColor3      = Color3.new(1, 1, 1),
            ZIndex           = 13,
            LayoutOrder      = order,
            AutoButtonColor  = false,
        }, ControlFrame)
        Corner(6, Btn)

        Btn.MouseEnter:Connect(function()
            Tween(Btn, {BackgroundColor3 = THEME.SurfaceHover}, 0.15)
        end)
        Btn.MouseLeave:Connect(function()
            Tween(Btn, {BackgroundColor3 = THEME.Surface}, 0.15)
        end)

        return Btn
    end

    local BtnMinimize = MakeControlBtn(ASSETS.IconMinimize, 1)
    local BtnClose    = MakeControlBtn(ASSETS.IconClose, 2)

    -- ─── Sidebar de Tabs ──────────────────────────────────────

    local Sidebar = new("Frame", {
        Name             = "Sidebar",
        Size             = UDim2.new(0, 150, 1, -52),
        Position         = UDim2.new(0, 0, 0, 52),
        BackgroundColor3 = THEME.BG2,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, MainFrame)

    -- Linha separadora sidebar
    new("Frame", {
        Size             = UDim2.new(0, 1, 1, 0),
        Position         = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = THEME.Border,
        BorderSizePixel  = 0,
        ZIndex           = 12,
    }, Sidebar)

    local SidebarScroll = new("ScrollingFrame", {
        Size             = UDim2.new(1, 0, 1, -36),
        Position         = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        BorderSizePixel  = 0,
        ScrollBarThickness = 0,
        CanvasSize       = UDim2.new(0, 0, 0, 0),
        ZIndex           = 12,
    }, Sidebar)
    Padding(8, 8, 8, 8, SidebarScroll)
    ListLayout(4, SidebarScroll)

    -- Footer na sidebar
    local SidebarFooter = new("TextLabel", {
        Size             = UDim2.new(1, 0, 0, 36),
        Position         = UDim2.new(0, 0, 1, -36),
        BackgroundTransparency = 1,
        Text             = "v1.0.0",
        TextColor3       = THEME.TextMuted,
        TextSize         = 9,
        Font             = Enum.Font.Gotham,
        ZIndex           = 12,
    }, Sidebar)

    -- ─── Área de Conteúdo ─────────────────────────────────────

    local ContentArea = new("Frame", {
        Name             = "Content",
        Size             = UDim2.new(1, -150, 1, -88),
        Position         = UDim2.new(0, 150, 0, 52),
        BackgroundTransparency = 1,
        ZIndex           = 11,
    }, MainFrame)

    -- ─── Footer copyright ─────────────────────────────────────

    local FooterBar = new("Frame", {
        Name             = "Footer",
        Size             = UDim2.new(1, -150, 0, 36),
        Position         = UDim2.new(0, 150, 1, -36),
        BackgroundColor3 = THEME.BG2,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, MainFrame)
    Corner(14, FooterBar)

    -- Cobrir cantos superiores do footer
    new("Frame", {
        Size             = UDim2.new(1, 0, 0, 14),
        Position         = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = THEME.BG2,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, FooterBar)

    -- Linha topo do footer
    new("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = THEME.Border,
        BorderSizePixel  = 0,
        ZIndex           = 12,
    }, FooterBar)

    new("TextLabel", {
        Size             = UDim2.new(1, -20, 1, 0),
        Position         = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text             = "© 𝚃𝚘𝚍𝚘𝚜 𝚘𝚜 𝚍𝚒𝚛𝚎𝚒𝚝𝚘𝚜 𝚛𝚎𝚜𝚎𝚛𝚟𝚊𝚍𝚘𝚜 — 𝚑𝚝𝚝𝚙𝚜://𝚛𝚒𝚚𝚞𝚎𝚕𝚖𝚎-𝚍𝚎𝚟.𝚗𝚎𝚝𝚕𝚒𝚏𝚢.𝚊𝚙𝚙/",
        TextColor3       = THEME.TextMuted,
        TextSize         = 10,
        Font             = Enum.Font.Code,
        TextXAlignment   = Enum.TextXAlignment.Center,
        ZIndex           = 12,
    }, FooterBar)

    -- ─── Arrastar janela ──────────────────────────────────────

    local dragging, dragStart, startPos = false, nil, nil

    Header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging  = true
            dragStart = input.Position
            startPos  = MainFrame.Position
        end
    end)

    Header.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(
                startPos.X.Scale, startPos.X.Offset + delta.X,
                startPos.Y.Scale, startPos.Y.Offset + delta.Y
            )
        end
    end)

    -- ─── Minimizar ────────────────────────────────────────────

    local minimized = false

    BtnMinimize.MouseButton1Click:Connect(function()
        PlaySound(ASSETS.SoundMinimize)
        minimized = not minimized
        if minimized then
            Tween(MainFrame, {Size = UDim2.new(0, WIN_W, 0, 52)}, 0.3, Enum.EasingStyle.Quart)
        else
            Tween(MainFrame, {Size = UDim2.new(0, WIN_W, 0, WIN_H)}, 0.3, Enum.EasingStyle.Quart)
        end
    end)

    -- ─── Fechar ───────────────────────────────────────────────

    BtnClose.MouseButton1Click:Connect(function()
        PlaySound(ASSETS.SoundClose)
        Tween(MainFrame, {
            Size             = UDim2.new(0, WIN_W * 0.9, 0, WIN_H * 0.9),
            BackgroundTransparency = 1,
        }, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.wait(0.28)
        ScreenGui:Destroy()
    end)

    -- ─── Animação de abertura ─────────────────────────────────

    MainFrame.Size         = UDim2.new(0, WIN_W * 0.92, 0, WIN_H * 0.92)
    MainFrame.BackgroundTransparency = 0.3

    PlaySound(ASSETS.SoundOpen)
    Tween(MainFrame, {
        Size             = UDim2.new(0, WIN_W, 0, WIN_H),
        BackgroundTransparency = 0,
    }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    -- Notificações iniciais
    task.wait(0.6)
    SendNotification({
        Title   = ScriptName,
        Message = "Interface carregada com sucesso.",
        Duration = 4,
    })
    task.wait(1)
    SendNotification({
        Title   = "Acesse o Nosso Site",
        Message = "riquelme-dev.netlify.app",
        Duration = 5,
    })

    -- ═══════════════════════════════════════════════════════════
    --  OBJETO WINDOW (API PÚBLICA)
    -- ═══════════════════════════════════════════════════════════

    local Window    = {}
    Window._tabs    = {}
    Window._content = {}
    Window._active  = nil

    local function SwitchTab(name)
        if Window._active == name then return end
        Window._active = name
        PlaySound(ASSETS.SoundClick)

        for tName, tData in pairs(Window._tabs) do
            local isActive = (tName == name)

            -- Tab button
            Tween(tData.Button, {
                BackgroundColor3 = isActive and THEME.Surface or Color3.fromRGB(0,0,0),
                BackgroundTransparency = isActive and 0 or 1,
            }, 0.18)
            Tween(tData.Label, {
                TextColor3 = isActive and THEME.Text or THEME.TextDim,
            }, 0.18)
            tData.Indicator.BackgroundTransparency = isActive and 0 or 1

            -- Content
            if Window._content[tName] then
                Window._content[tName].Visible = isActive
            end
        end
    end

    -- ─── AddTab ───────────────────────────────────────────────

    function Window:AddTab(name, icon)
        -- Botão na sidebar
        local TabBtn = new("TextButton", {
            Name             = "Tab_"..name,
            Size             = UDim2.new(1, 0, 0, 34),
            BackgroundColor3 = Color3.fromRGB(0,0,0),
            BackgroundTransparency = 1,
            Text             = "",
            ZIndex           = 13,
            AutoButtonColor  = false,
        }, SidebarScroll)
        Corner(8, TabBtn)

        -- Indicador lateral ativo
        local Indicator = new("Frame", {
            Size             = UDim2.new(0, 3, 0, 18),
            Position         = UDim2.new(0, 0, 0.5, -9),
            BackgroundColor3 = THEME.Accent,
            BackgroundTransparency = 1,
            BorderSizePixel  = 0,
            ZIndex           = 14,
        }, TabBtn)
        Corner(2, Indicator)

        local TabLabel = new("TextLabel", {
            Size             = UDim2.new(1, -16, 1, 0),
            Position         = UDim2.new(0, 14, 0, 0),
            BackgroundTransparency = 1,
            Text             = name,
            TextColor3       = THEME.TextDim,
            TextSize         = 12,
            Font             = Enum.Font.GothamSemibold,
            TextXAlignment   = Enum.TextXAlignment.Left,
            ZIndex           = 14,
        }, TabBtn)

        -- Hover
        TabBtn.MouseEnter:Connect(function()
            if Window._active ~= name then
                Tween(TabBtn, {BackgroundTransparency = 0.7}, 0.15)
                Tween(TabBtn, {BackgroundColor3 = THEME.Surface}, 0.15)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if Window._active ~= name then
                Tween(TabBtn, {BackgroundTransparency = 1}, 0.15)
            end
        end)

        -- Área de scroll do conteúdo
        local ContentScroll = new("ScrollingFrame", {
            Name             = "Content_"..name,
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel  = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = THEME.Border,
            CanvasSize       = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            Visible          = false,
            ZIndex           = 12,
        }, ContentArea)
        Padding(12, 14, 12, 14, ContentScroll)
        ListLayout(8, ContentScroll)

        Window._tabs[name]    = { Button = TabBtn, Label = TabLabel, Indicator = Indicator }
        Window._content[name] = ContentScroll

        TabBtn.MouseButton1Click:Connect(function()
            SwitchTab(name)
        end)

        -- Ativa primeiro tab automaticamente
        if not Window._active then
            SwitchTab(name)
        end

        -- ─── Tab API ──────────────────────────────────────────

        local Tab = {}
        Tab._parent = ContentScroll

        -- Atualiza tamanho do scroll
        local function updateCanvas()
            local layout = ContentScroll:FindFirstChildOfClass("UIListLayout")
            if layout then
                ContentScroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 24)
            end
        end

        ContentScroll.ChildAdded:Connect(updateCanvas)
        ContentScroll.ChildRemoved:Connect(updateCanvas)

        -- ── Seção ────────────────────────────────────────────

        function Tab:AddSection(title)
            local Sec = new("Frame", {
                Size             = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                ZIndex           = 13,
            }, ContentScroll)

            new("TextLabel", {
                Size             = UDim2.new(0, 200, 1, 0),
                BackgroundTransparency = 1,
                Text             = string.upper(title),
                TextColor3       = THEME.TextMuted,
                TextSize         = 10,
                Font             = Enum.Font.GothamBold,
                TextXAlignment   = Enum.TextXAlignment.Left,
                LetterSpacing    = 3,
                ZIndex           = 14,
            }, Sec)

            new("Frame", {
                Size             = UDim2.new(1, -120, 0, 1),
                Position         = UDim2.new(0, 115, 0.5, 0),
                BackgroundColor3 = THEME.Divider,
                BorderSizePixel  = 0,
                ZIndex           = 14,
            }, Sec)
        end

        -- ── Divisor ──────────────────────────────────────────

        function Tab:AddDivider()
            new("Frame", {
                Size             = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = THEME.Divider,
                BorderSizePixel  = 0,
                ZIndex           = 13,
            }, ContentScroll)
        end

        -- ── Label ────────────────────────────────────────────

        function Tab:AddLabel(text)
            new("TextLabel", {
                Size             = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text             = text,
                TextColor3       = THEME.TextDim,
                TextSize         = 12,
                Font             = Enum.Font.Gotham,
                TextXAlignment   = Enum.TextXAlignment.Left,
                TextWrapped      = true,
                ZIndex           = 13,
            }, ContentScroll)
        end

        -- ── Botão ────────────────────────────────────────────

        function Tab:AddButton(cfg)
            cfg = cfg or {}

            local Wrapper = new("Frame", {
                Size             = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = THEME.Surface,
                BorderSizePixel  = 0,
                ZIndex           = 13,
            }, ContentScroll)
            Corner(8, Wrapper)
            Stroke(THEME.Border, 1, Wrapper)

            new("TextLabel", {
                Size             = UDim2.new(1, -16, 1, 0),
                Position         = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text             = cfg.Label or "Botão",
                TextColor3       = THEME.Text,
                TextSize         = 13,
                Font             = Enum.Font.GothamSemibold,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 14,
            }, Wrapper)

            -- Seta
            new("TextLabel", {
                Size             = UDim2.new(0, 20, 1, 0),
                Position         = UDim2.new(1, -24, 0, 0),
                BackgroundTransparency = 1,
                Text             = ">",
                TextColor3       = THEME.TextMuted,
                TextSize         = 14,
                Font             = Enum.Font.GothamBold,
                ZIndex           = 14,
            }, Wrapper)

            local Btn = new("TextButton", {
                Size             = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text             = "",
                ZIndex           = 15,
                AutoButtonColor  = false,
            }, Wrapper)

            Btn.MouseEnter:Connect(function()
                Tween(Wrapper, {BackgroundColor3 = THEME.SurfaceHover}, 0.15)
            end)
            Btn.MouseLeave:Connect(function()
                Tween(Wrapper, {BackgroundColor3 = THEME.Surface}, 0.15)
            end)

            Btn.MouseButton1Click:Connect(function()
                PlaySound(ASSETS.SoundClick)
                -- Ripple
                Tween(Wrapper, {BackgroundColor3 = THEME.BorderLight}, 0.08)
                task.wait(0.08)
                Tween(Wrapper, {BackgroundColor3 = THEME.SurfaceHover}, 0.15)
                if cfg.Callback then cfg.Callback() end
            end)
        end

        -- ── Toggle ───────────────────────────────────────────

        function Tab:AddToggle(cfg)
            cfg = cfg or {}
            local state = cfg.Default or false

            local Wrapper = new("Frame", {
                Size             = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = THEME.Surface,
                BorderSizePixel  = 0,
                ZIndex           = 13,
            }, ContentScroll)
            Corner(8, Wrapper)
            Stroke(THEME.Border, 1, Wrapper)

            new("TextLabel", {
                Size             = UDim2.new(1, -60, 1, 0),
                Position         = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text             = cfg.Label or "Toggle",
                TextColor3       = THEME.Text,
                TextSize         = 13,
                Font             = Enum.Font.GothamSemibold,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 14,
            }, Wrapper)

            -- Track
            local Track = new("Frame", {
                Size             = UDim2.new(0, 36, 0, 20),
                Position         = UDim2.new(1, -48, 0.5, -10),
                BackgroundColor3 = state and THEME.Toggle or THEME.ToggleOff,
                BorderSizePixel  = 0,
                ZIndex           = 14,
            }, Wrapper)
            Corner(10, Track)

            local Knob = new("Frame", {
                Size             = UDim2.new(0, 14, 0, 14),
                Position         = state and UDim2.new(0, 19, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                BackgroundColor3 = Color3.new(1,1,1),
                BorderSizePixel  = 0,
                ZIndex           = 15,
            }, Track)
            Corner(7, Knob)

            local Btn = new("TextButton", {
                Size             = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text             = "",
                ZIndex           = 16,
                AutoButtonColor  = false,
            }, Wrapper)

            Btn.MouseEnter:Connect(function()
                Tween(Wrapper, {BackgroundColor3 = THEME.SurfaceHover}, 0.15)
            end)
            Btn.MouseLeave:Connect(function()
                Tween(Wrapper, {BackgroundColor3 = THEME.Surface}, 0.15)
            end)

            Btn.MouseButton1Click:Connect(function()
                PlaySound(ASSETS.SoundClick)
                state = not state
                Tween(Track, {BackgroundColor3 = state and THEME.Toggle or THEME.ToggleOff}, 0.2)
                Tween(Knob, {Position = state and UDim2.new(0, 19, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}, 0.2, Enum.EasingStyle.Back)
                if cfg.Callback then cfg.Callback(state) end
            end)

            local toggleObj = {}
            function toggleObj:Set(v)
                state = v
                Tween(Track, {BackgroundColor3 = state and THEME.Toggle or THEME.ToggleOff}, 0.2)
                Tween(Knob, {Position = state and UDim2.new(0, 19, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}, 0.2, Enum.EasingStyle.Back)
            end
            return toggleObj
        end

        -- ── Slider ───────────────────────────────────────────

        function Tab:AddSlider(cfg)
            cfg = cfg or {}
            local Min     = cfg.Min     or 0
            local Max     = cfg.Max     or 100
            local Default = cfg.Default or Min
            local current = math.clamp(Default, Min, Max)

            local Wrapper = new("Frame", {
                Size             = UDim2.new(1, 0, 0, 54),
                BackgroundColor3 = THEME.Surface,
                BorderSizePixel  = 0,
                ZIndex           = 13,
            }, ContentScroll)
            Corner(8, Wrapper)
            Stroke(THEME.Border, 1, Wrapper)

            local TopRow = new("Frame", {
                Size             = UDim2.new(1, -28, 0, 26),
                Position         = UDim2.new(0, 14, 0, 6),
                BackgroundTransparency = 1,
                ZIndex           = 14,
            }, Wrapper)

            new("TextLabel", {
                Size             = UDim2.new(0.7, 0, 1, 0),
                BackgroundTransparency = 1,
                Text             = cfg.Label or "Slider",
                TextColor3       = THEME.Text,
                TextSize         = 13,
                Font             = Enum.Font.GothamSemibold,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 15,
            }, TopRow)

            local ValLabel = new("TextLabel", {
                Size             = UDim2.new(0.3, 0, 1, 0),
                Position         = UDim2.new(0.7, 0, 0, 0),
                BackgroundTransparency = 1,
                Text             = tostring(current),
                TextColor3       = THEME.TextDim,
                TextSize         = 12,
                Font             = Enum.Font.GothamSemibold,
                TextXAlignment   = Enum.TextXAlignment.Right,
                ZIndex           = 15,
            }, TopRow)

            -- Track
            local SliderTrack = new("Frame", {
                Size             = UDim2.new(1, -28, 0, 4),
                Position         = UDim2.new(0, 14, 0, 38),
                BackgroundColor3 = THEME.ToggleOff,
                BorderSizePixel  = 0,
                ZIndex           = 14,
            }, Wrapper)
            Corner(2, SliderTrack)

            local pct = (current - Min) / (Max - Min)

            local Fill = new("Frame", {
                Size             = UDim2.new(pct, 0, 1, 0),
                BackgroundColor3 = THEME.Slider,
                BorderSizePixel  = 0,
                ZIndex           = 15,
            }, SliderTrack)
            Corner(2, Fill)

            local Knob = new("Frame", {
                Size             = UDim2.new(0, 12, 0, 12),
                Position         = UDim2.new(pct, -6, 0.5, -6),
                BackgroundColor3 = Color3.new(1,1,1),
                BorderSizePixel  = 0,
                ZIndex           = 16,
            }, SliderTrack)
            Corner(6, Knob)

            local draggingSlider = false

            local function updateSlider(x)
                local abs   = SliderTrack.AbsolutePosition.X
                local width = SliderTrack.AbsoluteSize.X
                local p     = math.clamp((x - abs) / width, 0, 1)
                current = math.round(Min + p * (Max - Min))
                ValLabel.Text = tostring(current)
                Tween(Fill,  {Size     = UDim2.new(p, 0, 1, 0)},       0.05)
                Tween(Knob,  {Position = UDim2.new(p, -6, 0.5, -6)},   0.05)
                if cfg.Callback then cfg.Callback(current) end
            end

            SliderTrack.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    PlaySound(ASSETS.SoundClick)
                    updateSlider(inp.Position.X)
                end
            end)

            UserInputService.InputChanged:Connect(function(inp)
                if draggingSlider and inp.UserInputType == Enum.UserInputType.MouseMovement then
                    updateSlider(inp.Position.X)
                end
            end)

            UserInputService.InputEnded:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                end
            end)
        end

        -- ── Textbox ──────────────────────────────────────────

        function Tab:AddTextbox(cfg)
            cfg = cfg or {}

            local Wrapper = new("Frame", {
                Size             = UDim2.new(1, 0, 0, 54),
                BackgroundColor3 = THEME.Surface,
                BorderSizePixel  = 0,
                ZIndex           = 13,
            }, ContentScroll)
            Corner(8, Wrapper)
            Stroke(THEME.Border, 1, Wrapper)

            new("TextLabel", {
                Size             = UDim2.new(1, -28, 0, 20),
                Position         = UDim2.new(0, 14, 0, 6),
                BackgroundTransparency = 1,
                Text             = cfg.Label or "Campo",
                TextColor3       = THEME.Text,
                TextSize         = 13,
                Font             = Enum.Font.GothamSemibold,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 14,
            }, Wrapper)

            local InputBG = new("Frame", {
                Size             = UDim2.new(1, -28, 0, 22),
                Position         = UDim2.new(0, 14, 0, 26),
                BackgroundColor3 = THEME.BG3,
                BorderSizePixel  = 0,
                ZIndex           = 14,
            }, Wrapper)
            Corner(6, InputBG)
            Stroke(THEME.Border, 1, InputBG)

            local Input = new("TextBox", {
                Size             = UDim2.new(1, -16, 1, 0),
                Position         = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                PlaceholderText  = cfg.Placeholder or "Digite aqui...",
                PlaceholderColor3 = THEME.TextMuted,
                Text             = cfg.Default or "",
                TextColor3       = THEME.Text,
                TextSize         = 12,
                Font             = Enum.Font.Gotham,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 15,
                ClearTextOnFocus = false,
            }, InputBG)

            Input.Focused:Connect(function()
                Tween(InputBG, {BackgroundColor3 = THEME.BG2}, 0.15)
            end)

            Input.FocusLost:Connect(function(enter)
                Tween(InputBG, {BackgroundColor3 = THEME.BG3}, 0.15)
                if enter and cfg.Callback then
                    cfg.Callback(Input.Text)
                end
            end)
        end

        -- ── Dropdown ─────────────────────────────────────────

        function Tab:AddDropdown(cfg)
            cfg = cfg or {}
            local Options  = cfg.Options or {}
            local selected = cfg.Default or (Options[1] or "Selecionar")
            local open     = false

            local Wrapper = new("Frame", {
                Size             = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = THEME.Surface,
                BorderSizePixel  = 0,
                ZIndex           = 13,
                ClipsDescendants = false,
            }, ContentScroll)
            Corner(8, Wrapper)
            Stroke(THEME.Border, 1, Wrapper)

            new("TextLabel", {
                Size             = UDim2.new(0.5, -10, 1, 0),
                Position         = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text             = cfg.Label or "Dropdown",
                TextColor3       = THEME.Text,
                TextSize         = 13,
                Font             = Enum.Font.GothamSemibold,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 14,
            }, Wrapper)

            local SelBtn = new("TextButton", {
                Size             = UDim2.new(0, 130, 0, 26),
                Position         = UDim2.new(1, -144, 0.5, -13),
                BackgroundColor3 = THEME.BG3,
                Text             = "",
                ZIndex           = 14,
                AutoButtonColor  = false,
            }, Wrapper)
            Corner(6, SelBtn)
            Stroke(THEME.Border, 1, SelBtn)

            local SelLabel = new("TextLabel", {
                Size             = UDim2.new(1, -22, 1, 0),
                Position         = UDim2.new(0, 8, 0, 0),
                BackgroundTransparency = 1,
                Text             = selected,
                TextColor3       = THEME.Text,
                TextSize         = 12,
                Font             = Enum.Font.Gotham,
                TextXAlignment   = Enum.TextXAlignment.Left,
                ZIndex           = 15,
            }, SelBtn)

            new("TextLabel", {
                Size             = UDim2.new(0, 16, 1, 0),
                Position         = UDim2.new(1, -18, 0, 0),
                BackgroundTransparency = 1,
                Text             = "v",
                TextColor3       = THEME.TextMuted,
                TextSize         = 10,
                Font             = Enum.Font.GothamBold,
                ZIndex           = 15,
            }, SelBtn)

            -- Lista
            local DropList = new("Frame", {
                Size             = UDim2.new(0, 130, 0, 0),
                Position         = UDim2.new(1, -144, 1, 4),
                BackgroundColor3 = THEME.BG2,
                BorderSizePixel  = 0,
                ClipsDescendants = true,
                ZIndex           = 20,
                Visible          = false,
            }, Wrapper)
            Corner(8, DropList)
            Stroke(THEME.BorderLight, 1, DropList)

            local DropInner = new("Frame", {
                Size             = UDim2.new(1, 0, 0, 0),
                AutomaticSize    = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                ZIndex           = 21,
            }, DropList)
            Padding(4, 6, 4, 6, DropInner)
            ListLayout(2, DropInner)

            for _, opt in ipairs(Options) do
                local OptBtn = new("TextButton", {
                    Size             = UDim2.new(1, 0, 0, 28),
                    BackgroundColor3 = THEME.BG2,
                    BackgroundTransparency = 1,
                    Text             = opt,
                    TextColor3       = THEME.TextDim,
                    TextSize         = 12,
                    Font             = Enum.Font.Gotham,
                    TextXAlignment   = Enum.TextXAlignment.Left,
                    ZIndex           = 22,
                    AutoButtonColor  = false,
                }, DropInner)
                Corner(6, OptBtn)
                Padding(0, 0, 0, 6, OptBtn)

                OptBtn.MouseEnter:Connect(function()
                    Tween(OptBtn, {BackgroundTransparency = 0.6, BackgroundColor3 = THEME.Surface}, 0.1)
                    Tween(OptBtn, {TextColor3 = THEME.Text}, 0.1)
                end)
                OptBtn.MouseLeave:Connect(function()
                    Tween(OptBtn, {BackgroundTransparency = 1}, 0.1)
                    Tween(OptBtn, {TextColor3 = THEME.TextDim}, 0.1)
                end)

                OptBtn.MouseButton1Click:Connect(function()
                    PlaySound(ASSETS.SoundClick)
                    selected = opt
                    SelLabel.Text = opt
                    open = false
                    Tween(DropList, {Size = UDim2.new(0, 130, 0, 0)}, 0.2, Enum.EasingStyle.Quart)
                    task.wait(0.2)
                    DropList.Visible = false
                    if cfg.Callback then cfg.Callback(opt) end
                end)
            end

            SelBtn.MouseButton1Click:Connect(function()
                PlaySound(ASSETS.SoundClick)
                open = not open
                if open then
                    local h = math.min(#Options * 30 + 8, 160)
                    DropList.Visible = true
                    DropList.Size = UDim2.new(0, 130, 0, 0)
                    Tween(DropList, {Size = UDim2.new(0, 130, 0, h)}, 0.2, Enum.EasingStyle.Quart)
                else
                    Tween(DropList, {Size = UDim2.new(0, 130, 0, 0)}, 0.15)
                    task.wait(0.16)
                    DropList.Visible = false
                end
            end)

            SelBtn.MouseEnter:Connect(function()
                Tween(SelBtn, {BackgroundColor3 = THEME.Surface}, 0.15)
            end)
            SelBtn.MouseLeave:Connect(function()
                Tween(SelBtn, {BackgroundColor3 = THEME.BG3}, 0.15)
            end)
        end

        return Tab
    end

    -- ─── Notificação pública ──────────────────────────────────

    function Window:Notify(cfg)
        SendNotification(cfg)
    end

    return Window
end

return RiquelmeUI

--[[
    ─────────────────────────────────────────────────
    EXEMPLO COMPLETO DE USO:
    ─────────────────────────────────────────────────

    local UI = loadstring(game:HttpGet("SEU_RAW_LINK"))()

    local Win = UI.CreateWindow({
        Title      = "Meu Hub",
        Subtitle   = "by Riquelme Dev",
        ScriptName = "Meu Script v1.0",
    })

    -- TAB PRINCIPAL
    local Main = Win:AddTab("Principal")

    Main:AddSection("Movimento")

    Main:AddToggle({
        Label    = "Speed Hack",
        Default  = false,
        Callback = function(v)
            local char = game.Players.LocalPlayer.Character
            if char then
                char.Humanoid.WalkSpeed = v and 50 or 16
            end
        end,
    })

    Main:AddSlider({
        Label    = "Walk Speed",
        Min      = 16,
        Max      = 500,
        Default  = 16,
        Callback = function(v)
            local char = game.Players.LocalPlayer.Character
            if char then char.Humanoid.WalkSpeed = v end
        end,
    })

    Main:AddDivider()
    Main:AddSection("Outros")

    Main:AddButton({
        Label    = "Teleportar ao Spawn",
        Callback = function()
            local char = game.Players.LocalPlayer.Character
            if char then char:MoveTo(Vector3.new(0,5,0)) end
        end,
    })

    Main:AddDropdown({
        Label    = "Selecionar Mapa",
        Options  = {"Lobby", "Arena", "Floresta"},
        Default  = "Lobby",
        Callback = function(v) print("Mapa:", v) end,
    })

    -- TAB CONFIGURAÇÕES
    local Config = Win:AddTab("Configurações")

    Config:AddTextbox({
        Label       = "Tag Personalizada",
        Placeholder = "Digite sua tag...",
        Callback    = function(v) print("Tag:", v) end,
    })

    -- Notificação manual
    Win:Notify({
        Title   = "Dica",
        Message = "Use os controles acima para configurar.",
        Duration = 5,
    })
    ─────────────────────────────────────────────────
]]
