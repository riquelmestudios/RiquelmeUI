--[[
╔══════════════════════════════════════════════════════════════╗
║           RiquelmeUI — Interface Suite v2.0.0               ║
║           Autor : Riquelme Dev                              ║
║           Site  : https://riquelme-dev.netlify.app          ║
╚══════════════════════════════════════════════════════════════╝

── COMO USAR ────────────────────────────────────────────────────

    local UI = loadstring(game:HttpGet("SEU_RAW_LINK"))()

    local Win = UI:CreateWindow({
        Name            = "Meu Script",
        LoadingTitle    = "Riquelme Dev",
        LoadingSubtitle = "Carregando...",
        Theme           = "Default",
        ConfigurationSaving = {
            Enabled  = false,
            FileName = "MeuScript",
        },
    })

    local Tab = Win:CreateTab("Principal", "home")

    Tab:CreateSection("Categoria")
    Tab:CreateButton({ Name = "Executar", Callback = function() end })
    Tab:CreateToggle({ Name = "Ativar", CurrentValue = false, Flag = "t1", Callback = function(v) end })
    Tab:CreateSlider({ Name = "Speed", Range = {16,500}, Increment = 1, CurrentValue = 16, Flag = "s1", Callback = function(v) end })
    Tab:CreateInput({ Name = "Nome", PlaceholderText = "Digite...", Flag = "i1", Callback = function(v) end })
    Tab:CreateDropdown({ Name = "Mapa", Options = {"A","B","C"}, CurrentOption = {"A"}, Flag = "d1", Callback = function(opts) end })
    Tab:CreateLabel("Texto informativo")
    Tab:CreateDivider()

    UI:Notify({ Title = "Titulo", Content = "Mensagem aqui", Duration = 4 })

─────────────────────────────────────────────────────────────────
]]

-- ════════════════════════════════════════════════════════════════
--  SERVICOS
-- ════════════════════════════════════════════════════════════════

local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local HttpService      = game:GetService("HttpService")
local CoreGui          = game:GetService("CoreGui")
local Debris           = game:GetService("Debris")

local LP = Players.LocalPlayer

-- ════════════════════════════════════════════════════════════════
--  ASSETS
-- ════════════════════════════════════════════════════════════════

local ASSETS = {
    Logo         = "rbxassetid://99990741111604",
    SideNotif    = "rbxassetid://87444469158140",
    IconClose    = "rbxassetid://116447909270552",
    IconMinimize = "rbxassetid://115558082558028",
    Shadow       = "rbxassetid://6014261993",

    SoundClick   = "rbxassetid://113397864512278",
    SoundMin     = "rbxassetid://86070307558627",
    SoundClose   = "rbxassetid://115044676553154",
    SoundOpen    = "rbxassetid://129993339892259",
}

-- ════════════════════════════════════════════════════════════════
--  TEMAS
-- ════════════════════════════════════════════════════════════════

local Themes = {
    Default = {
        Background          = Color3.fromRGB(25,  25,  25),
        Topbar              = Color3.fromRGB(34,  34,  34),
        TabBackground       = Color3.fromRGB(80,  80,  80),
        TabSelected         = Color3.fromRGB(210, 210, 210),
        TabTextColor        = Color3.fromRGB(240, 240, 240),
        TabTextSelected     = Color3.fromRGB(50,  50,  50),
        TabStroke           = Color3.fromRGB(85,  85,  85),
        ElementBackground   = Color3.fromRGB(35,  35,  35),
        ElementHover        = Color3.fromRGB(40,  40,  40),
        ElementStroke       = Color3.fromRGB(50,  50,  50),
        SecondaryBG         = Color3.fromRGB(25,  25,  25),
        SecondaryStroke     = Color3.fromRGB(40,  40,  40),
        SliderBG            = Color3.fromRGB(50, 138, 220),
        SliderProgress      = Color3.fromRGB(50, 138, 220),
        SliderStroke        = Color3.fromRGB(58, 163, 255),
        ToggleBG            = Color3.fromRGB(30,  30,  30),
        ToggleOn            = Color3.fromRGB(0,  146, 214),
        ToggleOff           = Color3.fromRGB(100,100, 100),
        ToggleOnStroke      = Color3.fromRGB(0,  170, 255),
        ToggleOffStroke     = Color3.fromRGB(125,125, 125),
        ToggleOnOuter       = Color3.fromRGB(100,100, 100),
        ToggleOffOuter      = Color3.fromRGB(65,  65,  65),
        InputBG             = Color3.fromRGB(30,  30,  30),
        InputStroke         = Color3.fromRGB(65,  65,  65),
        PlaceholderColor    = Color3.fromRGB(178,178, 178),
        DropSelected        = Color3.fromRGB(40,  40,  40),
        DropUnselected      = Color3.fromRGB(30,  30,  30),
        TextColor           = Color3.fromRGB(240,240, 240),
        Shadow              = Color3.fromRGB(20,  20,  20),
        NotifBG             = Color3.fromRGB(20,  20,  20),
        DividerColor        = Color3.fromRGB(60,  60,  60),
        SectionColor        = Color3.fromRGB(140,140, 140),
    },
    Midnight = {
        Background          = Color3.fromRGB(15,  15,  20),
        Topbar              = Color3.fromRGB(20,  20,  28),
        TabBackground       = Color3.fromRGB(35,  35,  50),
        TabSelected         = Color3.fromRGB(100, 100, 180),
        TabTextColor        = Color3.fromRGB(200, 200, 220),
        TabTextSelected     = Color3.fromRGB(240, 240, 255),
        TabStroke           = Color3.fromRGB(50,  50,  75),
        ElementBackground   = Color3.fromRGB(22,  22,  32),
        ElementHover        = Color3.fromRGB(30,  30,  45),
        ElementStroke       = Color3.fromRGB(45,  45,  65),
        SecondaryBG         = Color3.fromRGB(18,  18,  26),
        SecondaryStroke     = Color3.fromRGB(40,  40,  60),
        SliderBG            = Color3.fromRGB(60,  60, 160),
        SliderProgress      = Color3.fromRGB(80,  80, 200),
        SliderStroke        = Color3.fromRGB(100, 100, 220),
        ToggleBG            = Color3.fromRGB(25,  25,  38),
        ToggleOn            = Color3.fromRGB(80,  80, 200),
        ToggleOff           = Color3.fromRGB(60,  60,  80),
        ToggleOnStroke      = Color3.fromRGB(100, 100, 220),
        ToggleOffStroke     = Color3.fromRGB(70,  70,  90),
        ToggleOnOuter       = Color3.fromRGB(60,  60, 160),
        ToggleOffOuter      = Color3.fromRGB(40,  40,  55),
        InputBG             = Color3.fromRGB(20,  20,  30),
        InputStroke         = Color3.fromRGB(50,  50,  75),
        PlaceholderColor    = Color3.fromRGB(130,130, 160),
        DropSelected        = Color3.fromRGB(35,  35,  55),
        DropUnselected      = Color3.fromRGB(22,  22,  32),
        TextColor           = Color3.fromRGB(220,220, 240),
        Shadow              = Color3.fromRGB(8,   8,   14),
        NotifBG             = Color3.fromRGB(18,  18,  26),
        DividerColor        = Color3.fromRGB(45,  45,  65),
        SectionColor        = Color3.fromRGB(120,120, 160),
    },
}

-- ════════════════════════════════════════════════════════════════
--  UTILITARIOS
-- ════════════════════════════════════════════════════════════════

local function getService(name)
    local s = game:GetService(name)
    return (cloneref and cloneref(s)) or s
end

local function tween(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.3,
            style or Enum.EasingStyle.Exponential,
            dir   or Enum.EasingDirection.Out),
        props):Play()
end

local function sound(id)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume  = 0.5
    s.Parent  = CoreGui
    s:Play()
    Debris:AddItem(s, 4)
end

local function new(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do
        pcall(function() o[k] = v end)
    end
    if parent then o.Parent = parent end
    return o
end

local function corner(r, p)
    local o = Instance.new("UICorner")
    o.CornerRadius = UDim.new(0, r)
    o.Parent = p
    return o
end

local function stroke(col, thick, p)
    local o = Instance.new("UIStroke")
    o.Color     = col
    o.Thickness = thick
    o.Parent    = p
    return o
end

local function padding(t, r, b, l, p)
    local o = Instance.new("UIPadding")
    o.PaddingTop    = UDim.new(0, t)
    o.PaddingRight  = UDim.new(0, r)
    o.PaddingBottom = UDim.new(0, b)
    o.PaddingLeft   = UDim.new(0, l)
    o.Parent        = p
    return o
end

local function listLayout(spacing, p, horiz, halign, valign)
    local o = Instance.new("UIListLayout")
    o.SortOrder = Enum.SortOrder.LayoutOrder
    o.Padding   = UDim.new(0, spacing)
    if horiz  then o.FillDirection       = Enum.FillDirection.Horizontal end
    if halign then o.HorizontalAlignment = halign end
    if valign then o.VerticalAlignment   = valign end
    o.Parent = p
    return o
end

local function autoCanvas(scroll, layout)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
    end)
end

local function makeDraggable(frame, handle)
    local dragging, relPos = false, Vector2.zero
    handle.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            relPos   = Vector2.new(
                i.Position.X - frame.AbsolutePosition.X,
                i.Position.Y - frame.AbsolutePosition.Y
            )
        end
    end)
    UserInputService.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1
        or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInputService.InputChanged:Connect(function(i)
        if dragging and (
            i.UserInputType == Enum.UserInputType.MouseMovement or
            i.UserInputType == Enum.UserInputType.Touch
        ) then
            local p = i.Position
            frame.Position = UDim2.fromOffset(p.X - relPos.X, p.Y - relPos.Y)
        end
    end)
end

-- ════════════════════════════════════════════════════════════════
--  SCREENGUI
-- ════════════════════════════════════════════════════════════════

local Gui = Instance.new("ScreenGui")
Gui.Name           = "RiquelmeUI"
Gui.ResetOnSpawn   = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder   = 999
Gui.IgnoreGuiInset = true

local ok = pcall(function()
    if gethui then
        Gui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(Gui)
        Gui.Parent = CoreGui
    else
        Gui.Parent = CoreGui
    end
end)
if not ok then
    pcall(function() Gui.Parent = LP:WaitForChild("PlayerGui") end)
end

-- ════════════════════════════════════════════════════════════════
--  NOTIFICACOES
-- ════════════════════════════════════════════════════════════════

local NotifContainer = new("Frame", {
    Name                   = "Notifications",
    Size                   = UDim2.new(0, 300, 1, -20),
    Position               = UDim2.new(1, -308, 0, 10),
    BackgroundTransparency = 1,
    ZIndex                 = 900,
}, Gui)

local notifList = listLayout(8, NotifContainer, nil,
    Enum.HorizontalAlignment.Right,
    Enum.VerticalAlignment.Bottom)
padding(0, 0, 12, 0, NotifContainer)

local RiquelmeUI = {}
local selectedTheme = Themes.Default

local function Notify(data)
    task.spawn(function()
        data = data or {}
        local T = selectedTheme

        local NF = new("Frame", {
            Name                   = "Notif",
            Size                   = UDim2.new(1, 0, 0, 0),
            BackgroundColor3       = T.NotifBG,
            BackgroundTransparency = 1,
            ZIndex                 = 901,
            ClipsDescendants       = true,
        }, NotifContainer)
        corner(10, NF)
        local nfStroke = stroke(T.ElementStroke, 1, NF)

        -- Barra esquerda colorida
        new("Frame", {
            Size             = UDim2.new(0, 3, 1, -16),
            Position         = UDim2.new(0, 8, 0, 8),
            BackgroundColor3 = T.SliderProgress,
            BorderSizePixel  = 0,
            ZIndex           = 902,
        }, NF)

        -- Logo
        local ico = new("ImageLabel", {
            Size                   = UDim2.new(0, 28, 0, 28),
            Position               = UDim2.new(0, 18, 0, 0),
            AnchorPoint            = Vector2.new(0, 0.5),
            BackgroundColor3       = T.ElementBackground,
            Image                  = ASSETS.SideNotif,
            ZIndex                 = 902,
        }, NF)
        corner(6, ico)

        -- Titulo
        local nTitle = new("TextLabel", {
            Size                   = UDim2.new(1, -58, 0, 16),
            Position               = UDim2.new(0, 54, 0, 10),
            BackgroundTransparency = 1,
            Text                   = data.Title or "Notificacao",
            TextColor3             = T.TextColor,
            TextSize               = 13,
            Font                   = Enum.Font.GothamBold,
            TextXAlignment         = Enum.TextXAlignment.Left,
            TextTransparency       = 1,
            ZIndex                 = 902,
        }, NF)

        -- Conteudo
        local nContent = new("TextLabel", {
            Size                   = UDim2.new(1, -58, 0, 28),
            Position               = UDim2.new(0, 54, 0, 26),
            BackgroundTransparency = 1,
            Text                   = data.Content or "",
            TextColor3             = T.TextColor,
            TextSize               = 11,
            Font                   = Enum.Font.Gotham,
            TextXAlignment         = Enum.TextXAlignment.Left,
            TextWrapped            = true,
            TextTransparency       = 1,
            ZIndex                 = 902,
        }, NF)

        -- Barra de progresso
        local pbg = new("Frame", {
            Size             = UDim2.new(1, -16, 0, 2),
            Position         = UDim2.new(0, 8, 1, -8),
            BackgroundColor3 = T.ElementStroke,
            BorderSizePixel  = 0,
            ZIndex           = 902,
        }, NF)
        corner(2, pbg)

        local pbar = new("Frame", {
            Size             = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = T.SliderProgress,
            BorderSizePixel  = 0,
            ZIndex           = 903,
        }, pbg)
        corner(2, pbar)

        -- Ajusta posicao do icone verticalmente
        local totalH = 70
        ico.Position = UDim2.new(0, 18, 0, totalH/2 - 14)

        -- Entrada
        tween(NF, {Size = UDim2.new(1, 0, 0, totalH), BackgroundTransparency = 0.15}, 0.4)
        task.wait(0.1)
        tween(nTitle,   {TextTransparency = 0},    0.3)
        task.wait(0.05)
        tween(nContent, {TextTransparency = 0.2},  0.3)

        local dur = data.Duration or 5
        tween(pbar, {Size = UDim2.new(0, 0, 1, 0)}, dur, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

        task.wait(dur)

        tween(NF,       {BackgroundTransparency = 1}, 0.35)
        tween(nTitle,   {TextTransparency = 1},       0.25)
        tween(nContent, {TextTransparency = 1},       0.25)
        tween(NF,       {Size = UDim2.new(1, 0, 0, 0)}, 0.4)
        task.wait(0.45)
        pcall(function() NF:Destroy() end)
    end)
end

RiquelmeUI.Notify = Notify

-- ════════════════════════════════════════════════════════════════
--  SPLASH SCREEN
-- ════════════════════════════════════════════════════════════════

local SplashBG = new("Frame", {
    Name             = "Splash",
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.fromRGB(12, 12, 15),
    ZIndex           = 800,
}, Gui)

-- Fundo sutil com gradiente
local splashGrad = Instance.new("UIGradient")
splashGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(15, 15, 20)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(12, 12, 15)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(8,  8,  12)),
})
splashGrad.Rotation = 135
splashGrad.Parent   = SplashBG

-- Container central
local splashCenter = new("Frame", {
    Size                   = UDim2.new(0, 220, 0, 220),
    Position               = UDim2.new(0.5, -110, 0.5, -130),
    BackgroundTransparency = 1,
    ZIndex                 = 801,
}, SplashBG)

-- Circulo de fundo do logo
local splashCircle = new("Frame", {
    Size             = UDim2.new(0, 100, 0, 100),
    Position         = UDim2.new(0.5, -50, 0, 0),
    BackgroundColor3 = Color3.fromRGB(30, 30, 38),
    BackgroundTransparency = 1,
    ZIndex           = 801,
}, splashCenter)
corner(50, splashCircle)
stroke(Color3.fromRGB(50, 50, 65), 1, splashCircle)

-- Logo
local splashLogo = new("ImageLabel", {
    Size                   = UDim2.new(0, 72, 0, 72),
    Position               = UDim2.new(0.5, -36, 0.5, -36),
    BackgroundTransparency = 1,
    Image                  = ASSETS.Logo,
    ImageTransparency      = 1,
    ZIndex                 = 802,
}, splashCircle)

-- Linha decorativa
local splashLine = new("Frame", {
    Size                   = UDim2.new(0, 0, 0, 1),
    Position               = UDim2.new(0.5, 0, 0, 115),
    BackgroundColor3       = Color3.fromRGB(80, 80, 100),
    BackgroundTransparency = 1,
    BorderSizePixel        = 0,
    ZIndex                 = 801,
}, splashCenter)

-- Nome
local splashName = new("TextLabel", {
    Size                   = UDim2.new(1, 0, 0, 28),
    Position               = UDim2.new(0, 0, 0, 125),
    BackgroundTransparency = 1,
    Text                   = "RIQUELME DEV",
    TextColor3             = Color3.fromRGB(220, 220, 230),
    TextTransparency       = 1,
    TextSize               = 16,
    Font                   = Enum.Font.GothamBold,
    ZIndex                 = 801,
}, splashCenter)

-- Site
local splashSite = new("TextLabel", {
    Size                   = UDim2.new(1, 0, 0, 18),
    Position               = UDim2.new(0, 0, 0, 155),
    BackgroundTransparency = 1,
    Text                   = "riquelme-dev.netlify.app",
    TextColor3             = Color3.fromRGB(100, 100, 120),
    TextTransparency       = 1,
    TextSize               = 11,
    Font                   = Enum.Font.Gotham,
    ZIndex                 = 801,
}, splashCenter)

-- Animação splash
task.spawn(function()
    task.wait(0.2)

    -- Circulo aparece
    tween(splashCircle, {BackgroundTransparency = 0}, 0.5)
    task.wait(0.2)

    -- Logo fade in
    tween(splashLogo, {ImageTransparency = 0}, 0.6, Enum.EasingStyle.Quart)
    task.wait(0.35)

    -- Linha expande
    tween(splashLine, {
        Size     = UDim2.new(0, 180, 0, 1),
        Position = UDim2.new(0.5, -90, 0, 115),
        BackgroundTransparency = 0.5,
    }, 0.5, Enum.EasingStyle.Quart)
    task.wait(0.2)

    -- Textos
    tween(splashName, {TextTransparency = 0},   0.4)
    task.wait(0.1)
    tween(splashSite, {TextTransparency = 0.4}, 0.4)

    task.wait(2.2)

    -- Fade out
    tween(splashLogo,   {ImageTransparency = 1}, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    tween(splashName,   {TextTransparency  = 1}, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    tween(splashSite,   {TextTransparency  = 1}, 0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    tween(splashLine,   {BackgroundTransparency = 1, Size = UDim2.new(0,0,0,1)}, 0.35)
    tween(splashCircle, {BackgroundTransparency = 1}, 0.4)
    task.wait(0.3)
    tween(SplashBG, {BackgroundTransparency = 1}, 0.4)
    task.wait(0.45)
    pcall(function() SplashBG:Destroy() end)
end)

-- ════════════════════════════════════════════════════════════════
--  CREATE WINDOW
-- ════════════════════════════════════════════════════════════════

function RiquelmeUI:CreateWindow(Settings)
    Settings = Settings or {}

    -- Resolve tema
    if Settings.Theme and Themes[Settings.Theme] then
        selectedTheme = Themes[Settings.Theme]
    end
    local T = selectedTheme

    -- Config saving
    local cfgEnabled  = Settings.ConfigurationSaving and Settings.ConfigurationSaving.Enabled or false
    local cfgFileName = Settings.ConfigurationSaving and Settings.ConfigurationSaving.FileName or tostring(game.PlaceId)
    local cfgFolder   = "RiquelmeUI/Configurations"
    local cfgExt      = ".rqui"
    local Flags       = {}

    local function saveConfig()
        if not cfgEnabled then return end
        local data = {}
        for k, v in pairs(Flags) do
            if v.Type == "Toggle"   then data[k] = v.CurrentValue
            elseif v.Type == "Slider"   then data[k] = v.CurrentValue
            elseif v.Type == "Input"    then data[k] = v.CurrentValue
            elseif v.Type == "Dropdown" then data[k] = v.CurrentOption
            end
        end
        pcall(function()
            if not isfolder("RiquelmeUI") then makefolder("RiquelmeUI") end
            if not isfolder(cfgFolder)    then makefolder(cfgFolder)    end
            writefile(cfgFolder.."/"..cfgFileName..cfgExt, HttpService:JSONEncode(data))
        end)
    end

    local function loadConfig()
        if not cfgEnabled then return end
        pcall(function()
            if isfile and isfile(cfgFolder.."/"..cfgFileName..cfgExt) then
                local raw  = readfile(cfgFolder.."/"..cfgFileName..cfgExt)
                local data = HttpService:JSONDecode(raw)
                for k, v in pairs(data) do
                    if Flags[k] and Flags[k].Set then
                        task.spawn(function() Flags[k]:Set(v) end)
                    end
                end
                Notify({Title = "Configuracoes", Content = "Sessao anterior carregada.", Duration = 3})
            end
        end)
    end

    -- Aguarda splash
    task.wait(3.8)

    -- ── Dimensoes ─────────────────────────────────────────────
    local WW, WH   = 520, 490
    local TOPBAR_H = 50
    local TABLIST_W = 165

    -- ── Container raiz (posicionamento) ───────────────────────
    local Root = new("Frame", {
        Name                   = "RiquelmeUI_Root",
        Size                   = UDim2.fromOffset(WW, WH),
        Position               = UDim2.fromOffset(
            (workspace.CurrentCamera.ViewportSize.X/2) - WW/2,
            (workspace.CurrentCamera.ViewportSize.Y/2) - WH/2
        ),
        BackgroundTransparency = 1,
        ZIndex                 = 10,
    }, Gui)

    -- ── Sombra ────────────────────────────────────────────────
    new("ImageLabel", {
        Size                   = UDim2.new(1, 80, 1, 80),
        Position               = UDim2.fromOffset(-40, -30),
        BackgroundTransparency = 1,
        Image                  = ASSETS.Shadow,
        ImageColor3            = T.Shadow,
        ImageTransparency      = 0.4,
        ZIndex                 = 9,
        ScaleType              = Enum.ScaleType.Slice,
        SliceCenter            = Rect.new(49, 49, 450, 450),
    }, Root)

    -- ── Frame principal ───────────────────────────────────────
    local Main = new("Frame", {
        Name             = "Main",
        Size             = UDim2.fromOffset(WW, WH),
        BackgroundColor3 = T.Background,
        BorderSizePixel  = 0,
        ZIndex           = 10,
    }, Root)
    corner(12, Main)
    stroke(T.ElementStroke, 1, Main)

    -- ── LOADING FRAME ─────────────────────────────────────────
    local LoadFrame = new("Frame", {
        Name             = "LoadFrame",
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = T.Background,
        BorderSizePixel  = 0,
        ZIndex           = 50,
        Visible          = true,
    }, Main)
    corner(12, LoadFrame)

    local loadTitle = new("TextLabel", {
        Size                   = UDim2.new(1, 0, 0, 30),
        Position               = UDim2.new(0, 0, 0.5, -28),
        BackgroundTransparency = 1,
        Text                   = Settings.LoadingTitle or "Riquelme Dev",
        TextColor3             = T.TextColor,
        TextTransparency       = 1,
        TextSize               = 22,
        Font                   = Enum.Font.GothamBold,
        ZIndex                 = 51,
    }, LoadFrame)

    local loadSub = new("TextLabel", {
        Size                   = UDim2.new(1, 0, 0, 20),
        Position               = UDim2.new(0, 0, 0.5, 8),
        BackgroundTransparency = 1,
        Text                   = Settings.LoadingSubtitle or "Carregando interface...",
        TextColor3             = T.TextColor,
        TextTransparency       = 1,
        TextSize               = 13,
        Font                   = Enum.Font.Gotham,
        ZIndex                 = 51,
    }, LoadFrame)

    -- ── TOPBAR ────────────────────────────────────────────────
    local Topbar = new("Frame", {
        Name             = "Topbar",
        Size             = UDim2.new(1, 0, 0, TOPBAR_H),
        BackgroundColor3 = T.Topbar,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, Main)
    corner(12, Topbar)

    -- Corrige cantos inferiores do topbar
    new("Frame", {
        Size             = UDim2.new(1, 0, 0, 12),
        Position         = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = T.Topbar,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, Topbar)

    -- Linha separadora base do topbar
    new("Frame", {
        Name             = "Divider",
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = T.ElementStroke,
        BorderSizePixel  = 0,
        ZIndex           = 12,
    }, Topbar)

    -- Logo no topbar
    local topLogo = new("ImageLabel", {
        Size             = UDim2.fromOffset(26, 26),
        Position         = UDim2.new(0, 14, 0.5, -13),
        BackgroundColor3 = T.ElementBackground,
        Image            = ASSETS.Logo,
        ZIndex           = 12,
    }, Topbar)
    corner(6, topLogo)

    -- Separador vertical
    new("Frame", {
        Size             = UDim2.fromOffset(1, 22),
        Position         = UDim2.new(0, 49, 0.5, -11),
        BackgroundColor3 = T.ElementStroke,
        BorderSizePixel  = 0,
        ZIndex           = 12,
    }, Topbar)

    -- Titulo
    local topTitle = new("TextLabel", {
        Size                   = UDim2.new(0, 220, 0, 18),
        Position               = UDim2.new(0, 58, 0, 8),
        BackgroundTransparency = 1,
        Text                   = Settings.Name or "Riquelme UI",
        TextColor3             = T.TextColor,
        TextSize               = 13,
        Font                   = Enum.Font.GothamBold,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 12,
    }, Topbar)

    local topSub = new("TextLabel", {
        Size                   = UDim2.new(0, 220, 0, 14),
        Position               = UDim2.new(0, 58, 0, 27),
        BackgroundTransparency = 1,
        Text                   = "riquelme-dev.netlify.app",
        TextColor3             = T.SectionColor,
        TextSize               = 10,
        Font                   = Enum.Font.Gotham,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 12,
    }, Topbar)

    -- Botoes de controle
    local function makeCtrlBtn(asset, xOffset)
        local btn = new("ImageButton", {
            Size             = UDim2.fromOffset(26, 26),
            Position         = UDim2.new(1, xOffset, 0.5, -13),
            BackgroundColor3 = T.ElementBackground,
            Image            = asset,
            ImageColor3      = T.TextColor,
            ZIndex           = 13,
            AutoButtonColor  = false,
        }, Topbar)
        corner(7, btn)
        btn.MouseEnter:Connect(function()
            tween(btn, {BackgroundColor3 = T.ElementHover}, 0.15)
        end)
        btn.MouseLeave:Connect(function()
            tween(btn, {BackgroundColor3 = T.ElementBackground}, 0.15)
        end)
        return btn
    end

    local BtnMin   = makeCtrlBtn(ASSETS.IconMinimize, -72)
    local BtnClose = makeCtrlBtn(ASSETS.IconClose,    -38)

    -- ── SIDEBAR (TabList) ─────────────────────────────────────
    local Sidebar = new("Frame", {
        Name             = "Sidebar",
        Size             = UDim2.new(0, TABLIST_W, 1, -TOPBAR_H - 32),
        Position         = UDim2.new(0, 0, 0, TOPBAR_H),
        BackgroundColor3 = T.Topbar,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, Main)

    -- Linha separadora direita da sidebar
    new("Frame", {
        Size             = UDim2.new(0, 1, 1, 0),
        Position         = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = T.ElementStroke,
        BorderSizePixel  = 0,
        ZIndex           = 12,
    }, Sidebar)

    local TabScroll = new("ScrollingFrame", {
        Name                   = "TabScroll",
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        ScrollBarThickness     = 0,
        CanvasSize             = UDim2.new(0, 0, 0, 0),
        ZIndex                 = 12,
    }, Sidebar)
    padding(8, 8, 8, 8, TabScroll)
    local tabListLayout = listLayout(3, TabScroll)

    tabListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        TabScroll.CanvasSize = UDim2.new(0, 0, 0, tabListLayout.AbsoluteContentSize.Y + 16)
    end)

    -- ── CONTENT AREA ──────────────────────────────────────────
    local ContentHolder = new("Frame", {
        Name                   = "ContentHolder",
        Size                   = UDim2.new(1, -TABLIST_W, 1, -TOPBAR_H - 32),
        Position               = UDim2.new(0, TABLIST_W, 0, TOPBAR_H),
        BackgroundTransparency = 1,
        ClipsDescendants       = true,
        ZIndex                 = 11,
    }, Main)

    -- ── FOOTER ────────────────────────────────────────────────
    local Footer = new("Frame", {
        Name             = "Footer",
        Size             = UDim2.new(1, 0, 0, 32),
        Position         = UDim2.new(0, 0, 1, -32),
        BackgroundColor3 = T.Topbar,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, Main)
    corner(12, Footer)

    new("Frame", {
        Size             = UDim2.new(1, 0, 0, 12),
        BackgroundColor3 = T.Topbar,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, Footer)

    new("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = T.ElementStroke,
        BorderSizePixel  = 0,
        ZIndex           = 12,
    }, Footer)

    new("TextLabel", {
        Size                   = UDim2.new(1, -20, 1, 0),
        Position               = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text                   = "© 𝚃𝚘𝚍𝚘𝚜 𝚘𝚜 𝚍𝚒𝚛𝚎𝚒𝚝𝚘𝚜 𝚛𝚎𝚜𝚎𝚛𝚟𝚊𝚍𝚘𝚜 — 𝚑𝚝𝚝𝚙𝚜://𝚛𝚒𝚚𝚞𝚎𝚕𝚖𝚎-𝚍𝚎𝚟.𝚗𝚎𝚝𝚕𝚒𝚏𝚢.𝚊𝚙𝚙/",
        TextColor3             = T.SectionColor,
        TextSize               = 9,
        Font                   = Enum.Font.Code,
        ZIndex                 = 12,
    }, Footer)

    -- ── ARRASTAR ──────────────────────────────────────────────
    makeDraggable(Root, Topbar)

    -- ── MINIMIZAR ─────────────────────────────────────────────
    local minimized = false
    BtnMin.MouseButton1Click:Connect(function()
        sound(ASSETS.SoundMin)
        minimized = not minimized
        tween(Main, {
            Size = minimized and UDim2.fromOffset(WW, TOPBAR_H) or UDim2.fromOffset(WW, WH)
        }, 0.35, Enum.EasingStyle.Quart)
    end)

    -- ── FECHAR ────────────────────────────────────────────────
    BtnClose.MouseButton1Click:Connect(function()
        sound(ASSETS.SoundClose)
        tween(Main, {
            Size             = UDim2.fromOffset(WW * 0.9, WH * 0.9),
            BackgroundTransparency = 1,
        }, 0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        tween(Root, {Position = UDim2.fromOffset(
            Root.AbsolutePosition.X + WW*0.05,
            Root.AbsolutePosition.Y + WH*0.05
        )}, 0.25)
        task.wait(0.28)
        pcall(function() Gui:Destroy() end)
    end)

    -- ── ANIMACAO LOADING ──────────────────────────────────────
    Main.Size = UDim2.fromOffset(WW * 0.93, WH * 0.93)
    Main.BackgroundTransparency = 0.3

    sound(ASSETS.SoundOpen)

    tween(Main, {
        Size                   = UDim2.fromOffset(WW, WH),
        BackgroundTransparency = 0,
    }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    task.wait(0.3)
    tween(loadTitle, {TextTransparency = 0}, 0.5)
    task.wait(0.1)
    tween(loadSub,   {TextTransparency = 0.25}, 0.5)

    task.wait(1.2)

    tween(loadTitle, {TextTransparency = 1}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    tween(loadSub,   {TextTransparency = 1}, 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    task.wait(0.25)
    tween(LoadFrame, {BackgroundTransparency = 1}, 0.3)
    task.wait(0.35)
    LoadFrame.Visible = false

    -- Notificacoes iniciais
    task.wait(0.2)
    Notify({
        Title   = Settings.Name or "Riquelme UI",
        Content = "Interface carregada com sucesso.",
        Duration = 4,
    })
    task.wait(1.2)
    Notify({
        Title   = "Acesse o Nosso Site",
        Content = "riquelme-dev.netlify.app",
        Duration = 5,
    })

    -- ════════════════════════════════════════════════════════
    --  WINDOW OBJECT
    -- ════════════════════════════════════════════════════════

    local Window     = {}
    local _tabs      = {}  -- { btn, page }
    local _active    = nil
    local tabOrder   = 0

    local function switchTab(name)
        if _active == name then return end
        _active = name
        sound(ASSETS.SoundClick)

        for n, d in pairs(_tabs) do
            local on = (n == name)

            -- Botao da sidebar
            tween(d.btn, {
                BackgroundColor3       = on and T.TabSelected or T.TabBackground,
                BackgroundTransparency = on and 0 or 0.7,
            }, 0.25)
            tween(d.btnLabel, {
                TextColor3 = on and T.TabTextSelected or T.TabTextColor,
                TextTransparency = on and 0 or 0.2,
            }, 0.25)
            d.indicator.BackgroundTransparency = on and 0 or 1

            -- Pagina de conteudo
            d.page.Visible = on
        end
    end

    -- ── CreateTab ─────────────────────────────────────────────
    function Window:CreateTab(Name, Icon)
        tabOrder = tabOrder + 1

        -- Botao da tab
        local TabBtn = new("TextButton", {
            Name                   = "Tab_"..Name,
            Size                   = UDim2.new(1, 0, 0, 34),
            BackgroundColor3       = T.TabBackground,
            BackgroundTransparency = 0.7,
            Text                   = "",
            ZIndex                 = 13,
            AutoButtonColor        = false,
            LayoutOrder            = tabOrder,
        }, TabScroll)
        corner(8, TabBtn)

        -- Indicador lateral
        local tabInd = new("Frame", {
            Size                   = UDim2.fromOffset(3, 18),
            Position               = UDim2.new(0, 1, 0.5, -9),
            BackgroundColor3       = T.TextColor,
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            ZIndex                 = 14,
        }, TabBtn)
        corner(2, tabInd)

        local tabLabel = new("TextLabel", {
            Size                   = UDim2.new(1, -14, 1, 0),
            Position               = UDim2.new(0, 13, 0, 0),
            BackgroundTransparency = 1,
            Text                   = Name,
            TextColor3             = T.TabTextColor,
            TextTransparency       = 0.2,
            TextSize               = 12,
            Font                   = Enum.Font.GothamSemibold,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 14,
        }, TabBtn)

        TabBtn.MouseEnter:Connect(function()
            if _active ~= Name then
                tween(TabBtn, {BackgroundTransparency = 0.5, BackgroundColor3 = T.TabBackground}, 0.15)
            end
        end)
        TabBtn.MouseLeave:Connect(function()
            if _active ~= Name then
                tween(TabBtn, {BackgroundTransparency = 0.7}, 0.15)
            end
        end)
        TabBtn.MouseButton1Click:Connect(function()
            switchTab(Name)
        end)

        -- Pagina de conteudo (ScrollingFrame)
        local Page = new("ScrollingFrame", {
            Name                   = "Page_"..Name,
            Size                   = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            ScrollBarThickness     = 3,
            ScrollBarImageColor3   = T.ElementStroke,
            CanvasSize             = UDim2.new(0, 0, 0, 0),
            Visible                = false,
            ZIndex                 = 12,
        }, ContentHolder)
        padding(10, 12, 10, 12, Page)
        local pageLayout = listLayout(7, Page)
        autoCanvas(Page, pageLayout)

        _tabs[Name] = {
            btn       = TabBtn,
            btnLabel  = tabLabel,
            indicator = tabInd,
            page      = Page,
        }

        if not _active then switchTab(Name) end

        -- ── TAB API ──────────────────────────────────────────

        local Tab      = {}
        local elemOrder = 0

        local function nextOrder()
            elemOrder = elemOrder + 1
            return elemOrder
        end

        -- Elemento base (surface)
        local function makeElement(h)
            local f = new("Frame", {
                Size             = UDim2.new(1, 0, 0, h or 40),
                BackgroundColor3 = T.ElementBackground,
                BorderSizePixel  = 0,
                ZIndex           = 13,
                LayoutOrder      = nextOrder(),
            }, Page)
            corner(8, f)
            stroke(T.ElementStroke, 1, f)
            return f
        end

        -- ─ Section ───────────────────────────────────────────
        function Tab:CreateSection(name)
            local sv = {}

            local f = new("Frame", {
                Size                   = UDim2.new(1, 0, 0, 28),
                BackgroundTransparency = 1,
                ZIndex                 = 13,
                LayoutOrder            = nextOrder(),
            }, Page)

            local lbl = new("TextLabel", {
                Size                   = UDim2.new(0, 0, 1, 0),
                AutomaticSize          = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Text                   = string.upper(name),
                TextColor3             = T.SectionColor,
                TextSize               = 10,
                Font                   = Enum.Font.GothamBold,
                TextXAlignment         = Enum.TextXAlignment.Left,
                ZIndex                 = 14,
            }, f)

            new("Frame", {
                Size             = UDim2.new(1, 0, 0, 1),
                Position         = UDim2.new(0, 0, 1, -1),
                BackgroundColor3 = T.DividerColor,
                BorderSizePixel  = 0,
                ZIndex           = 14,
                BackgroundTransparency = 0.5,
            }, f)

            function sv:Set(v) lbl.Text = string.upper(v) end
            return sv
        end

        -- ─ Divider ───────────────────────────────────────────
        function Tab:CreateDivider()
            local dv = {}
            local f = new("Frame", {
                Size             = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = T.DividerColor,
                BackgroundTransparency = 0.5,
                BorderSizePixel  = 0,
                ZIndex           = 13,
                LayoutOrder      = nextOrder(),
            }, Page)

            function dv:Set(v) f.Visible = v end
            return dv
        end

        -- ─ Label ─────────────────────────────────────────────
        function Tab:CreateLabel(text, color)
            local lv = {}

            local f = new("Frame", {
                Size             = UDim2.new(1, 0, 0, 36),
                BackgroundColor3 = color or T.SecondaryBG,
                BorderSizePixel  = 0,
                ZIndex           = 13,
                LayoutOrder      = nextOrder(),
            }, Page)
            corner(8, f)
            stroke(color or T.SecondaryStroke, 1, f)

            local lbl = new("TextLabel", {
                Size                   = UDim2.new(1, -20, 1, 0),
                Position               = UDim2.new(0, 10, 0, 0),
                BackgroundTransparency = 1,
                Text                   = text,
                TextColor3             = T.TextColor,
                TextSize               = 12,
                Font                   = Enum.Font.Gotham,
                TextXAlignment         = Enum.TextXAlignment.Left,
                TextWrapped            = true,
                ZIndex                 = 14,
            }, f)

            function lv:Set(v) lbl.Text = v end
            return lv
        end

        -- ─ Paragraph ─────────────────────────────────────────
        function Tab:CreateParagraph(cfg)
            local pv = {}
            cfg = cfg or {}

            local f = new("Frame", {
                Size             = UDim2.new(1, 0, 0, 56),
                BackgroundColor3 = T.SecondaryBG,
                BorderSizePixel  = 0,
                ZIndex           = 13,
                LayoutOrder      = nextOrder(),
            }, Page)
            corner(8, f)
            stroke(T.SecondaryStroke, 1, f)

            local title = new("TextLabel", {
                Size                   = UDim2.new(1, -20, 0, 18),
                Position               = UDim2.new(0, 10, 0, 6),
                BackgroundTransparency = 1,
                Text                   = cfg.Title or "",
                TextColor3             = T.TextColor,
                TextSize               = 13,
                Font                   = Enum.Font.GothamBold,
                TextXAlignment         = Enum.TextXAlignment.Left,
                ZIndex                 = 14,
            }, f)

            local content = new("TextLabel", {
                Size                   = UDim2.new(1, -20, 0, 28),
                Position               = UDim2.new(0, 10, 0, 24),
                BackgroundTransparency = 1,
                Text                   = cfg.Content or "",
                TextColor3             = T.SectionColor,
                TextSize               = 11,
                Font                   = Enum.Font.Gotham,
                TextXAlignment         = Enum.TextXAlignment.Left,
                TextWrapped            = true,
                ZIndex                 = 14,
            }, f)

            function pv:Set(v)
                title.Text   = v.Title   or title.Text
                content.Text = v.Content or content.Text
            end
            return pv
        end

        -- ─ Button ────────────────────────────────────────────
        function Tab:CreateButton(cfg)
            cfg = cfg or {}
            local bv = {}

            local f = makeElement(40)

            local lbl = new("TextLabel", {
                Size                   = UDim2.new(1, -48, 1, 0),
                Position               = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text                   = cfg.Name or "Botao",
                TextColor3             = T.TextColor,
                TextSize               = 13,
                Font                   = Enum.Font.GothamSemibold,
                TextXAlignment         = Enum.TextXAlignment.Left,
                ZIndex                 = 14,
            }, f)

            -- Indicador ">"
            new("TextLabel", {
                Size                   = UDim2.fromOffset(20, 20),
                Position               = UDim2.new(1, -28, 0.5, -10),
                BackgroundTransparency = 1,
                Text                   = ">",
                TextColor3             = T.SectionColor,
                TextSize               = 14,
                Font                   = Enum.Font.GothamBold,
                ZIndex                 = 14,
            }, f)

            local btn = new("TextButton", {
                Size                   = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text                   = "",
                ZIndex                 = 15,
                AutoButtonColor        = false,
            }, f)

            btn.MouseEnter:Connect(function()
                tween(f, {BackgroundColor3 = T.ElementHover}, 0.15)
            end)
            btn.MouseLeave:Connect(function()
                tween(f, {BackgroundColor3 = T.ElementBackground}, 0.15)
            end)
            btn.MouseButton1Click:Connect(function()
                sound(ASSETS.SoundClick)
                tween(f, {BackgroundColor3 = T.ElementStroke}, 0.07)
                task.wait(0.08)
                tween(f, {BackgroundColor3 = T.ElementHover}, 0.2)
                local ok, err = pcall(function()
                    if cfg.Callback then cfg.Callback() end
                end)
                if not ok then
                    lbl.Text = "Erro no Callback"
                    tween(f, {BackgroundColor3 = Color3.fromRGB(80,0,0)}, 0.2)
                    task.wait(1)
                    lbl.Text = cfg.Name or "Botao"
                    tween(f, {BackgroundColor3 = T.ElementBackground}, 0.3)
                end
            end)

            function bv:Set(v) lbl.Text = v end
            return bv
        end

        -- ─ Toggle ────────────────────────────────────────────
        function Tab:CreateToggle(cfg)
            cfg = cfg or {}
            local tv = {}
            tv.Type = "Toggle"
            tv.CurrentValue = cfg.CurrentValue == true

            local f = makeElement(40)

            local lbl = new("TextLabel", {
                Size                   = UDim2.new(1, -64, 1, 0),
                Position               = UDim2.new(0, 14, 0, 0),
                BackgroundTransparency = 1,
                Text                   = cfg.Name or "Toggle",
                TextColor3             = T.TextColor,
                TextSize               = 13,
                Font                   = Enum.Font.GothamSemibold,
                TextXAlignment         = Enum.TextXAlignment.Left,
                ZIndex                 = 14,
            }, f)

            -- Track
            local track = new("Frame", {
                Size             = UDim2.fromOffset(38, 20),
                Position         = UDim2.new(1, -50, 0.5, -10),
                BackgroundColor3 = T.ToggleBG,
                BorderSizePixel  = 0,
                ZIndex           = 14,
            }, f)
            corner(10, track)
            local trackStroke = stroke(tv.CurrentValue and T.ToggleOnOuter or T.ToggleOffOuter, 1, track)

            -- Knob
            local knob = new("Frame", {
                Size             = UDim2.fromOffset(14, 14),
                Position         = tv.CurrentValue and UDim2.new(0, 21, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
                BackgroundColor3 = tv.CurrentValue and T.ToggleOn or T.ToggleOff,
                BorderSizePixel  = 0,
                ZIndex           = 15,
            }, track)
            corner(7, knob)
            stroke(tv.CurrentValue and T.ToggleOnStroke or T.ToggleOffStroke, 1, knob)

            local function applyToggle(state)
                tv.CurrentValue = state
                tween(track, {}, 0)
                tween(knob, {
                    Position         = state and UDim2.new(0,21,0.5,-7) or UDim2.new(0,3,0.5,-7),
                    BackgroundColor3 = state and T.ToggleOn or T.ToggleOff,
                }, 0.25, Enum.EasingStyle.Quart)
                tween(trackStroke, {Color = state and T.ToggleOnOuter or T.ToggleOffOuter}, 0.25)
            end

            local btn = new("TextButton", {
                Size=UDim2.new(1,0,1,0),
                BackgroundTransparency=1, Text="", ZIndex=16, AutoButtonColor=false,
            }, f)

            btn.MouseEnter:Connect(function() tween(f,{BackgroundColor3=T.ElementHover},0.15) end)
            btn.MouseLeave:Connect(function() tween(f,{BackgroundColor3=T.ElementBackground},0.15) end)
            btn.MouseButton1Click:Connect(function()
                sound(ASSETS.SoundClick)
                applyToggle(not tv.CurrentValue)
                pcall(function() if cfg.Callback then cfg.Callback(tv.CurrentValue) end end)
                saveConfig()
            end)

            function tv:Set(v)
                applyToggle(v)
                pcall(function() if cfg.Callback then cfg.Callback(tv.CurrentValue) end end)
            end
            function tv:Get() return tv.CurrentValue end

            if cfg.Flag then
                Flags[cfg.Flag] = tv
            end
            return tv
        end

        -- ─ Slider ────────────────────────────────────────────
        function Tab:CreateSlider(cfg)
            cfg = cfg or {}
            local sv = {}
            sv.Type = "Slider"

            local Min  = cfg.Range and cfg.Range[1] or 0
            local Max  = cfg.Range and cfg.Range[2] or 100
            local Inc  = cfg.Increment or 1
            sv.CurrentValue = math.clamp(cfg.CurrentValue or Min, Min, Max)

            local f = makeElement(52)

            -- Titulo e valor
            local rowTop = new("Frame", {
                Size                   = UDim2.new(1, -28, 0, 20),
                Position               = UDim2.new(0, 14, 0, 6),
                BackgroundTransparency = 1,
                ZIndex                 = 14,
            }, f)

            local lbl = new("TextLabel", {
                Size=UDim2.new(0.65,0,1,0),
                BackgroundTransparency=1,
                Text=cfg.Name or "Slider",
                TextColor3=T.TextColor, TextSize=13,
                Font=Enum.Font.GothamSemibold,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=15,
            }, rowTop)

            local function fmtVal(v)
                return tostring(v)..(cfg.Suffix and " "..cfg.Suffix or "")
            end

            local valLbl = new("TextLabel", {
                Size=UDim2.new(0.35,0,1,0), Position=UDim2.new(0.65,0,0,0),
                BackgroundTransparency=1,
                Text=fmtVal(sv.CurrentValue),
                TextColor3=T.SectionColor, TextSize=12,
                Font=Enum.Font.GothamSemibold,
                TextXAlignment=Enum.TextXAlignment.Right, ZIndex=15,
            }, rowTop)

            -- Track do slider
            local sliderTrack = new("Frame", {
                Size             = UDim2.new(1,-28,0,5),
                Position         = UDim2.new(0,14,0,34),
                BackgroundColor3 = T.SliderBG,
                BorderSizePixel  = 0,
                ZIndex           = 14,
            }, f)
            corner(3, sliderTrack)
            stroke(T.SliderStroke, 1, sliderTrack)

            local pct0 = (sv.CurrentValue - Min) / (Max - Min)

            local sliderFill = new("Frame", {
                Size             = UDim2.new(pct0, 0, 1, 0),
                BackgroundColor3 = T.SliderProgress,
                BorderSizePixel  = 0,
                ZIndex           = 15,
            }, sliderTrack)
            corner(3, sliderFill)

            local sliderKnob = new("Frame", {
                Size             = UDim2.fromOffset(14,14),
                Position         = UDim2.new(pct0,-7,0.5,-7),
                BackgroundColor3 = Color3.new(1,1,1),
                BorderSizePixel  = 0,
                ZIndex           = 16,
            }, sliderTrack)
            corner(7, sliderKnob)

            local interact = new("TextButton", {
                Size=UDim2.new(1,0,1,20), Position=UDim2.new(0,0,0,-8),
                BackgroundTransparency=1, Text="", ZIndex=17, AutoButtonColor=false,
            }, sliderTrack)

            local isDragging = false

            local function update(x)
                local abs = sliderTrack.AbsolutePosition.X
                local wid = sliderTrack.AbsoluteSize.X
                if wid <= 0 then return end
                local p  = math.clamp((x - abs) / wid, 0, 1)
                local raw = Min + p * (Max - Min)
                local val = math.clamp(
                    math.round(raw / Inc) * Inc,
                    Min, Max
                )
                -- Precisao
                local factor = 10 ^ math.max(0, math.ceil(-math.log10(Inc)))
                val = math.round(val * factor) / factor

                sv.CurrentValue = val
                valLbl.Text = fmtVal(val)

                tween(sliderFill,  {Size     = UDim2.new(p, 0, 1, 0)},         0.06)
                tween(sliderKnob,  {Position = UDim2.new(p, -7, 0.5, -7)},      0.06)

                pcall(function() if cfg.Callback then cfg.Callback(val) end end)
                saveConfig()
            end

            interact.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                    isDragging = true
                    sound(ASSETS.SoundClick)
                    update(i.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if isDragging and (
                    i.UserInputType == Enum.UserInputType.MouseMovement or
                    i.UserInputType == Enum.UserInputType.Touch
                ) then update(i.Position.X) end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1
                or i.UserInputType == Enum.UserInputType.Touch then
                    isDragging = false
                end
            end)

            f.MouseEnter:Connect(function() tween(f,{BackgroundColor3=T.ElementHover},0.15) end)
            f.MouseLeave:Connect(function() tween(f,{BackgroundColor3=T.ElementBackground},0.15) end)

            function sv:Set(v)
                sv.CurrentValue = math.clamp(v, Min, Max)
                local p = (sv.CurrentValue - Min) / (Max - Min)
                valLbl.Text = fmtVal(sv.CurrentValue)
                tween(sliderFill,  {Size     = UDim2.new(p, 0, 1, 0)},       0.15)
                tween(sliderKnob,  {Position = UDim2.new(p, -7, 0.5, -7)},    0.15)
                pcall(function() if cfg.Callback then cfg.Callback(sv.CurrentValue) end end)
            end
            function sv:Get() return sv.CurrentValue end

            if cfg.Flag then Flags[cfg.Flag] = sv end
            return sv
        end

        -- ─ Input ─────────────────────────────────────────────
        function Tab:CreateInput(cfg)
            cfg = cfg or {}
            local iv = {}
            iv.Type = "Input"
            iv.CurrentValue = cfg.CurrentValue or ""

            local f = makeElement(52)

            local lbl = new("TextLabel", {
                Size=UDim2.new(1,-28,0,18), Position=UDim2.new(0,14,0,5),
                BackgroundTransparency=1, Text=cfg.Name or "Input",
                TextColor3=T.TextColor, TextSize=13,
                Font=Enum.Font.GothamSemibold,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14,
            }, f)

            local inputBG = new("Frame", {
                Size=UDim2.new(1,-28,0,22), Position=UDim2.new(0,14,0,24),
                BackgroundColor3=T.InputBG, BorderSizePixel=0, ZIndex=14,
            }, f)
            corner(6, inputBG)
            stroke(T.InputStroke, 1, inputBG)

            local tb = new("TextBox", {
                Size=UDim2.new(1,-16,1,0), Position=UDim2.new(0,8,0,0),
                BackgroundTransparency=1,
                PlaceholderText=cfg.PlaceholderText or "Digite aqui...",
                PlaceholderColor3=T.PlaceholderColor,
                Text=iv.CurrentValue,
                TextColor3=T.TextColor, TextSize=12,
                Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,
                ClearTextOnFocus=false, ZIndex=15,
            }, inputBG)

            tb.Focused:Connect(function()
                tween(inputBG, {BackgroundColor3 = T.ElementHover}, 0.15)
                tween(stroke(T.SliderStroke, 1, inputBG), {}, 0)
            end)
            tb.FocusLost:Connect(function(enter)
                tween(inputBG, {BackgroundColor3 = T.InputBG}, 0.15)
                iv.CurrentValue = tb.Text
                if enter then
                    pcall(function() if cfg.Callback then cfg.Callback(tb.Text) end end)
                    saveConfig()
                end
                if cfg.RemoveTextAfterFocusLost then tb.Text = "" end
            end)

            f.MouseEnter:Connect(function() tween(f,{BackgroundColor3=T.ElementHover},0.15) end)
            f.MouseLeave:Connect(function() tween(f,{BackgroundColor3=T.ElementBackground},0.15) end)

            function iv:Set(v)
                tb.Text = tostring(v)
                iv.CurrentValue = tostring(v)
                pcall(function() if cfg.Callback then cfg.Callback(iv.CurrentValue) end end)
            end
            function iv:Get() return iv.CurrentValue end

            if cfg.Flag then Flags[cfg.Flag] = iv end
            return iv
        end

        -- ─ Dropdown ──────────────────────────────────────────
        function Tab:CreateDropdown(cfg)
            cfg = cfg or {}
            local dv = {}
            dv.Type = "Dropdown"

            local opts = cfg.Options or {}
            local multi = cfg.MultipleOptions or false

            -- Normaliza CurrentOption
            if type(cfg.CurrentOption) == "string" then
                cfg.CurrentOption = {cfg.CurrentOption}
            end
            dv.CurrentOption = cfg.CurrentOption or {}
            if not multi then
                dv.CurrentOption = {dv.CurrentOption[1]}
            end

            local function selText()
                if #dv.CurrentOption == 0 then return "Nenhum"
                elseif #dv.CurrentOption == 1 then return dv.CurrentOption[1]
                else return "Varios ("..#dv.CurrentOption..")" end
            end

            local isOpen = false

            local f = makeElement(40)
            f.ClipsDescendants = false

            local lbl = new("TextLabel", {
                Size=UDim2.new(0.5,0,1,0), Position=UDim2.new(0,14,0,0),
                BackgroundTransparency=1, Text=cfg.Name or "Dropdown",
                TextColor3=T.TextColor, TextSize=13,
                Font=Enum.Font.GothamSemibold,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14,
            }, f)

            local selBtn = new("TextButton", {
                Size=UDim2.fromOffset(140,26),
                Position=UDim2.new(1,-152,0.5,-13),
                BackgroundColor3=T.InputBG, Text="", ZIndex=14, AutoButtonColor=false,
            }, f)
            corner(7, selBtn)
            stroke(T.InputStroke, 1, selBtn)

            local selLabel = new("TextLabel", {
                Size=UDim2.new(1,-22,1,0), Position=UDim2.new(0,8,0,0),
                BackgroundTransparency=1,
                Text=selText(),
                TextColor3=T.TextColor, TextSize=11,
                Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=15,
            }, selBtn)

            local arrow = new("TextLabel", {
                Size=UDim2.fromOffset(14,14),
                Position=UDim2.new(1,-16,0.5,-7),
                BackgroundTransparency=1, Text="v",
                TextColor3=T.SectionColor, TextSize=9,
                Font=Enum.Font.GothamBold, ZIndex=15,
            }, selBtn)

            -- Lista dropdown
            local dropList = new("Frame", {
                Size=UDim2.fromOffset(140,0),
                Position=UDim2.new(1,-152,1,4),
                BackgroundColor3=T.Background,
                BorderSizePixel=0,
                ClipsDescendants=true, ZIndex=50, Visible=false,
            }, f)
            corner(8, dropList)
            stroke(T.ElementStroke, 1, dropList)

            local dropInner = new("Frame", {
                Size=UDim2.new(1,0,0,1),
                AutomaticSize=Enum.AutomaticSize.Y,
                BackgroundTransparency=1, ZIndex=51,
            }, dropList)
            padding(4,5,4,5, dropInner)
            listLayout(2, dropInner)

            local function buildOptions()
                for _, ch in ipairs(dropInner:GetChildren()) do
                    if ch:IsA("TextButton") then ch:Destroy() end
                end

                for _, opt in ipairs(opts) do
                    local isSelected = table.find(dv.CurrentOption, opt) ~= nil

                    local ob = new("TextButton", {
                        Size=UDim2.new(1,0,0,26),
                        BackgroundColor3 = isSelected and T.DropSelected or T.DropUnselected,
                        BackgroundTransparency=0,
                        Text=opt,
                        TextColor3=T.TextColor, TextSize=11,
                        Font=Enum.Font.Gotham,
                        TextXAlignment=Enum.TextXAlignment.Left,
                        ZIndex=52, AutoButtonColor=false,
                    }, dropInner)
                    corner(5, ob)
                    padding(0,0,0,7,ob)

                    ob.MouseEnter:Connect(function()
                        tween(ob,{BackgroundColor3=T.ElementHover},0.1)
                    end)
                    ob.MouseLeave:Connect(function()
                        local sel = table.find(dv.CurrentOption, opt) ~= nil
                        tween(ob,{BackgroundColor3= sel and T.DropSelected or T.DropUnselected},0.1)
                    end)

                    ob.MouseButton1Click:Connect(function()
                        sound(ASSETS.SoundClick)

                        if multi then
                            local idx = table.find(dv.CurrentOption, opt)
                            if idx then
                                table.remove(dv.CurrentOption, idx)
                            else
                                table.insert(dv.CurrentOption, opt)
                            end
                        else
                            if table.find(dv.CurrentOption, opt) then return end
                            dv.CurrentOption = {opt}
                        end

                        selLabel.Text = selText()
                        buildOptions()

                        pcall(function() if cfg.Callback then cfg.Callback(dv.CurrentOption) end end)
                        saveConfig()

                        if not multi then
                            -- Fechar apos selecao unica
                            isOpen = false
                            tween(dropList, {Size=UDim2.fromOffset(140,0)}, 0.2, Enum.EasingStyle.Quart)
                            task.wait(0.22)
                            dropList.Visible = false
                        end
                    end)
                end
            end

            buildOptions()

            selBtn.MouseEnter:Connect(function() tween(selBtn,{BackgroundColor3=T.ElementHover},0.15) end)
            selBtn.MouseLeave:Connect(function() tween(selBtn,{BackgroundColor3=T.InputBG},0.15) end)

            selBtn.MouseButton1Click:Connect(function()
                sound(ASSETS.SoundClick)
                isOpen = not isOpen
                if isOpen then
                    local h = math.min(#opts * 28 + 8, 160)
                    dropList.Visible = true
                    dropList.Size    = UDim2.fromOffset(140, 0)
                    tween(dropList, {Size=UDim2.fromOffset(140,h)}, 0.22, Enum.EasingStyle.Quart)
                    tween(arrow, {Rotation=180}, 0.2)
                else
                    tween(dropList, {Size=UDim2.fromOffset(140,0)}, 0.18, Enum.EasingStyle.Quart)
                    tween(arrow, {Rotation=0}, 0.2)
                    task.wait(0.2)
                    dropList.Visible = false
                end
            end)

            f.MouseEnter:Connect(function() tween(f,{BackgroundColor3=T.ElementHover},0.15) end)
            f.MouseLeave:Connect(function() tween(f,{BackgroundColor3=T.ElementBackground},0.15) end)

            function dv:Set(v)
                if type(v) == "string" then v = {v} end
                dv.CurrentOption = v
                selLabel.Text = selText()
                buildOptions()
                pcall(function() if cfg.Callback then cfg.Callback(dv.CurrentOption) end end)
            end
            function dv:Refresh(newOpts)
                opts = newOpts
                buildOptions()
            end
            function dv:Get() return dv.CurrentOption end

            if cfg.Flag then Flags[cfg.Flag] = dv end
            return dv
        end

        -- ─ Keybind ───────────────────────────────────────────
        function Tab:CreateKeybind(cfg)
            cfg = cfg or {}
            local kv = {}
            kv.CurrentKeybind = cfg.CurrentKeybind or "F"

            local f = makeElement(40)

            local lbl = new("TextLabel", {
                Size=UDim2.new(1,-120,1,0), Position=UDim2.new(0,14,0,0),
                BackgroundTransparency=1, Text=cfg.Name or "Keybind",
                TextColor3=T.TextColor, TextSize=13,
                Font=Enum.Font.GothamSemibold,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14,
            }, f)

            local kbFrame = new("Frame", {
                Size=UDim2.fromOffset(80,26),
                Position=UDim2.new(1,-92,0.5,-13),
                BackgroundColor3=T.InputBG, BorderSizePixel=0, ZIndex=14,
            }, f)
            corner(6, kbFrame)
            stroke(T.InputStroke, 1, kbFrame)

            local kbBox = new("TextBox", {
                Size=UDim2.new(1,-8,1,0), Position=UDim2.new(0,4,0,0),
                BackgroundTransparency=1,
                Text=kv.CurrentKeybind,
                TextColor3=T.TextColor, TextSize=12,
                Font=Enum.Font.GothamSemibold,
                ZIndex=15, ClearTextOnFocus=false,
            }, kbFrame)

            local listening = false

            kbBox.Focused:Connect(function()
                listening = true
                kbBox.Text = ""
                tween(kbFrame,{BackgroundColor3=T.ElementHover},0.15)
            end)
            kbBox.FocusLost:Connect(function()
                listening = false
                if kbBox.Text == "" then
                    kbBox.Text = kv.CurrentKeybind
                end
                tween(kbFrame,{BackgroundColor3=T.InputBG},0.15)
            end)

            UserInputService.InputBegan:Connect(function(input, processed)
                if listening and not processed then
                    if input.KeyCode ~= Enum.KeyCode.Unknown then
                        local split = string.split(tostring(input.KeyCode), ".")
                        local key   = split[3] or split[1]
                        kv.CurrentKeybind = key
                        kbBox.Text        = key
                        kbBox:ReleaseFocus()
                        pcall(function()
                            if cfg.CallOnChange and cfg.Callback then cfg.Callback(key) end
                        end)
                        saveConfig()
                    end
                elseif not listening and not processed and kv.CurrentKeybind then
                    if input.KeyCode == Enum.KeyCode[kv.CurrentKeybind] and not cfg.CallOnChange then
                        pcall(function() if cfg.Callback then cfg.Callback(kv.CurrentKeybind) end end)
                    end
                end
            end)

            f.MouseEnter:Connect(function() tween(f,{BackgroundColor3=T.ElementHover},0.15) end)
            f.MouseLeave:Connect(function() tween(f,{BackgroundColor3=T.ElementBackground},0.15) end)

            function kv:Set(v)
                kv.CurrentKeybind = tostring(v)
                kbBox.Text        = kv.CurrentKeybind
                pcall(function() if cfg.CallOnChange and cfg.Callback then cfg.Callback(v) end end)
            end
            function kv:Get() return kv.CurrentKeybind end

            if cfg.Flag then Flags[cfg.Flag] = kv end
            return kv
        end

        return Tab
    end

    -- ── Window extra ──────────────────────────────────────────

    function Window:Notify(data)
        Notify(data)
    end

    function Window:LoadConfiguration()
        task.delay(1, loadConfig)
    end

    function Window:ModifyTheme(themeName)
        if Themes[themeName] then
            selectedTheme = Themes[themeName]
            Notify({Title="Tema Alterado", Content="Tema '"..themeName.."' aplicado.", Duration=3})
        end
    end

    function Window:Destroy()
        pcall(function() Gui:Destroy() end)
    end

    -- Carrega config automaticamente
    task.delay(1.5, loadConfig)

    return Window
end

-- ════════════════════════════════════════════════════════════════
--  NOTIFY GLOBAL
-- ════════════════════════════════════════════════════════════════

function RiquelmeUI:Notify(data)
    Notify(data)
end

return RiquelmeUI
