--[[
    RiquelmeUI — Interface Premium para Roblox Scripts
    Autor : Riquelme Dev
    Site  : https://riquelme-dev.netlify.app
    Versão: 1.0.0

    ── USO RÁPIDO ──────────────────────────────────────────────────
    local UI = loadstring(game:HttpGet("SEU_RAW_LINK"))()

    local Win = UI.CreateWindow({
        Title      = "Meu Script",
        Subtitle   = "by Riquelme Dev",
        ScriptName = "Meu Script v1.0",
    })

    local Tab = Win:AddTab("Principal")
    Tab:AddSection("Movimento")
    Tab:AddButton({ Label = "Executar", Callback = function() end })
    Tab:AddToggle({ Label = "Ativar",   Default = false, Callback = function(v) end })
    Tab:AddSlider({ Label = "Speed",    Min = 16, Max = 500, Default = 16, Callback = function(v) end })
    Tab:AddTextbox({ Label = "Nome",    Placeholder = "Digite...", Callback = function(v) end })
    Tab:AddDropdown({ Label = "Mapa",   Options = {"A","B","C"}, Default = "A", Callback = function(v) end })
    Tab:AddLabel("Informacao aqui")
    Tab:AddDivider()

    Win:Notify({ Title = "Ola", Message = "Carregado!", Duration = 4 })
    ────────────────────────────────────────────────────────────────
]]

-- ══════════════════════════════════════════════════════════
--  SERVICOS
-- ══════════════════════════════════════════════════════════

local Players          = game:GetService("Players")
local TweenService     = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local CoreGui          = game:GetService("CoreGui")
local Debris           = game:GetService("Debris")

local LP = Players.LocalPlayer

-- ══════════════════════════════════════════════════════════
--  ASSETS
-- ══════════════════════════════════════════════════════════

local A = {
    Logo         = "rbxassetid://99990741111604",
    SideNotif    = "rbxassetid://87444469158140",
    IconClose    = "rbxassetid://116447909270552",
    IconMinimize = "rbxassetid://115558082558028",
    SoundClick   = "rbxassetid://113397864512278",
    SoundMin     = "rbxassetid://86070307558627",
    SoundClose   = "rbxassetid://115044676553154",
    SoundOpen    = "rbxassetid://129993339892259",
}

-- ══════════════════════════════════════════════════════════
--  TEMA
-- ══════════════════════════════════════════════════════════

local C = {
    BG        = Color3.fromRGB(10,  10,  13),
    BG2       = Color3.fromRGB(17,  17,  22),
    BG3       = Color3.fromRGB(24,  24,  30),
    Surface   = Color3.fromRGB(30,  30,  38),
    SurfHov   = Color3.fromRGB(38,  38,  48),
    Border    = Color3.fromRGB(48,  48,  62),
    BorderLt  = Color3.fromRGB(65,  65,  80),
    Text      = Color3.fromRGB(225, 225, 232),
    TextDim   = Color3.fromRGB(120, 120, 138),
    TextMut   = Color3.fromRGB(65,  65,  80),
    White     = Color3.new(1, 1, 1),
    Toggle    = Color3.fromRGB(50,  195, 115),
    ToggleOff = Color3.fromRGB(50,  50,  64),
    Divider   = Color3.fromRGB(32,  32,  42),
}

-- ══════════════════════════════════════════════════════════
--  HELPERS
-- ══════════════════════════════════════════════════════════

local function tw(obj, props, t, style, dir)
    TweenService:Create(obj,
        TweenInfo.new(t or 0.2,
            style or Enum.EasingStyle.Quart,
            dir   or Enum.EasingDirection.Out),
        props):Play()
end

local function corner(r, p)
    local o = Instance.new("UICorner")
    o.CornerRadius = UDim.new(0, r)
    o.Parent = p
end

local function stroke(col, thick, p)
    local o = Instance.new("UIStroke")
    o.Color = col; o.Thickness = thick; o.Parent = p
end

local function pad(t, r, b, l, p)
    local o = Instance.new("UIPadding")
    o.PaddingTop    = UDim.new(0, t)
    o.PaddingRight  = UDim.new(0, r)
    o.PaddingBottom = UDim.new(0, b)
    o.PaddingLeft   = UDim.new(0, l)
    o.Parent = p
end

local function listLayout(spc, p, horiz)
    local o = Instance.new("UIListLayout")
    o.SortOrder = Enum.SortOrder.LayoutOrder
    o.Padding   = UDim.new(0, spc)
    if horiz then o.FillDirection = Enum.FillDirection.Horizontal end
    o.Parent = p
    return o
end

local function mk(class, props, parent)
    local o = Instance.new(class)
    for k, v in pairs(props) do
        pcall(function() o[k] = v end)
    end
    o.Parent = parent
    return o
end

local function playSound(id)
    local s = Instance.new("Sound")
    s.SoundId = id
    s.Volume  = 0.45
    s.Parent  = CoreGui
    s:Play()
    Debris:AddItem(s, 4)
end

-- ══════════════════════════════════════════════════════════
--  SCREENGUI
-- ══════════════════════════════════════════════════════════

local Gui = Instance.new("ScreenGui")
Gui.Name           = "RiquelmeUI"
Gui.ResetOnSpawn   = false
Gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
Gui.DisplayOrder   = 999
Gui.IgnoreGuiInset = true

local ok = pcall(function() Gui.Parent = CoreGui end)
if not ok then
    Gui.Parent = LP:WaitForChild("PlayerGui")
end

-- ══════════════════════════════════════════════════════════
--  NOTIFICACOES
-- ══════════════════════════════════════════════════════════

local NotifHolder = mk("Frame", {
    Name                   = "Notifs",
    Size                   = UDim2.new(0, 272, 1, -20),
    Position               = UDim2.new(1, -280, 0, 10),
    BackgroundTransparency = 1,
    ZIndex                 = 500,
}, Gui)

local nList = listLayout(8, NotifHolder)
nList.VerticalAlignment   = Enum.VerticalAlignment.Bottom
nList.HorizontalAlignment = Enum.HorizontalAlignment.Right
pad(0, 0, 10, 0, NotifHolder)

local nOrder = 0

local function Notify(cfg)
    nOrder = nOrder + 1
    cfg = cfg or {}

    local NF = mk("Frame", {
        Name                   = "N"..nOrder,
        Size                   = UDim2.new(1, 0, 0, 68),
        BackgroundColor3       = C.BG2,
        BackgroundTransparency = 0.08,
        LayoutOrder            = nOrder,
        ZIndex                 = 501,
    }, NotifHolder)
    corner(10, NF)
    stroke(C.Border, 1, NF)

    mk("Frame", {
        Size             = UDim2.new(0, 3, 1, -18),
        Position         = UDim2.new(0, 8, 0, 9),
        BackgroundColor3 = C.White,
        BorderSizePixel  = 0,
        ZIndex           = 502,
    }, NF)

    local ico = mk("ImageLabel", {
        Size                   = UDim2.new(0, 26, 0, 26),
        Position               = UDim2.new(0, 18, 0, 7),
        BackgroundColor3       = C.Surface,
        Image                  = A.SideNotif,
        ZIndex                 = 502,
    }, NF)
    corner(5, ico)

    mk("TextLabel", {
        Size                   = UDim2.new(1, -56, 0, 18),
        Position               = UDim2.new(0, 52, 0, 8),
        BackgroundTransparency = 1,
        Text                   = cfg.Title or "Notificacao",
        TextColor3             = C.Text,
        TextSize               = 13,
        Font                   = Enum.Font.GothamBold,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 502,
    }, NF)

    mk("TextLabel", {
        Size                   = UDim2.new(1, -56, 0, 26),
        Position               = UDim2.new(0, 52, 0, 26),
        BackgroundTransparency = 1,
        Text                   = cfg.Message or "",
        TextColor3             = C.TextDim,
        TextSize               = 11,
        Font                   = Enum.Font.Gotham,
        TextXAlignment         = Enum.TextXAlignment.Left,
        TextWrapped            = true,
        ZIndex                 = 502,
    }, NF)

    local pbg = mk("Frame", {
        Size             = UDim2.new(1, -16, 0, 2),
        Position         = UDim2.new(0, 8, 1, -8),
        BackgroundColor3 = C.Border,
        BorderSizePixel  = 0,
        ZIndex           = 502,
    }, NF)
    corner(2, pbg)

    local pbar = mk("Frame", {
        Size             = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = C.White,
        BorderSizePixel  = 0,
        ZIndex           = 503,
    }, pbg)
    corner(2, pbar)

    local dur = cfg.Duration or 4
    tw(pbar, {Size = UDim2.new(0, 0, 1, 0)}, dur, Enum.EasingStyle.Linear, Enum.EasingDirection.In)

    task.delay(dur, function()
        tw(NF, {BackgroundTransparency = 1}, 0.3)
        task.wait(0.35)
        pcall(function() NF:Destroy() end)
    end)
end

-- ══════════════════════════════════════════════════════════
--  SPLASH
-- ══════════════════════════════════════════════════════════

local Splash = mk("Frame", {
    Name             = "Splash",
    Size             = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = C.BG,
    ZIndex           = 300,
}, Gui)

local splashLogo = mk("ImageLabel", {
    Size                   = UDim2.new(0, 110, 0, 110),
    Position               = UDim2.new(0.5, -55, 0.5, -75),
    BackgroundColor3       = C.Surface,
    BackgroundTransparency = 0.4,
    Image                  = A.Logo,
    ImageTransparency      = 1,
    ZIndex                 = 301,
}, Splash)
corner(14, splashLogo)

local splashLine = mk("Frame", {
    Size                   = UDim2.new(0, 0, 0, 1),
    Position               = UDim2.new(0.5, 0, 0.5, 52),
    BackgroundColor3       = C.White,
    BackgroundTransparency = 1,
    BorderSizePixel        = 0,
    ZIndex                 = 301,
}, Splash)

local splashTitle = mk("TextLabel", {
    Size                   = UDim2.new(0, 280, 0, 22),
    Position               = UDim2.new(0.5, -140, 0.5, 62),
    BackgroundTransparency = 1,
    Text                   = "RIQUELME DEV",
    TextColor3             = C.Text,
    TextTransparency       = 1,
    TextSize               = 15,
    Font                   = Enum.Font.GothamBold,
    ZIndex                 = 301,
}, Splash)

local splashSub = mk("TextLabel", {
    Size                   = UDim2.new(0, 280, 0, 16),
    Position               = UDim2.new(0.5, -140, 0.5, 86),
    BackgroundTransparency = 1,
    Text                   = "riquelme-dev.netlify.app",
    TextColor3             = C.TextMut,
    TextTransparency       = 1,
    TextSize               = 10,
    Font                   = Enum.Font.Gotham,
    ZIndex                 = 301,
}, Splash)

task.spawn(function()
    task.wait(0.15)
    tw(splashLogo, {ImageTransparency = 0, BackgroundTransparency = 0}, 0.55)
    task.wait(0.35)
    tw(splashLine, {
        Size     = UDim2.new(0, 180, 0, 1),
        Position = UDim2.new(0.5, -90, 0.5, 52),
        BackgroundTransparency = 0.6
    }, 0.45)
    task.wait(0.2)
    tw(splashTitle, {TextTransparency = 0},    0.35)
    task.wait(0.12)
    tw(splashSub,   {TextTransparency = 0.35}, 0.35)
    task.wait(2.4)
    tw(splashLogo,  {ImageTransparency = 1, BackgroundTransparency = 1}, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    tw(splashTitle, {TextTransparency  = 1},   0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    tw(splashSub,   {TextTransparency  = 1},   0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
    tw(splashLine,  {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 1)}, 0.35)
    task.wait(0.3)
    tw(Splash, {BackgroundTransparency = 1}, 0.35)
    task.wait(0.4)
    pcall(function() Splash:Destroy() end)
end)

-- ══════════════════════════════════════════════════════════
--  BIBLIOTECA PRINCIPAL
-- ══════════════════════════════════════════════════════════

local RiquelmeUI = {}

function RiquelmeUI.CreateWindow(cfg)
    cfg = cfg or {}
    local Title      = cfg.Title      or "Riquelme UI"
    local Subtitle   = cfg.Subtitle   or "by Riquelme Dev"
    local ScriptName = cfg.ScriptName or "Script"

    task.wait(4.0) -- aguarda splash terminar

    local WW, WH = 610, 430

    -- ── Frame Principal ────────────────────────────────────
    local Main = mk("Frame", {
        Name             = "RiquelmeUI_Main",
        Size             = UDim2.new(0, WW * 0.93, 0, WH * 0.93),
        Position         = UDim2.new(0.5, -WW/2, 0.5, -WH/2),
        BackgroundColor3 = C.BG,
        BackgroundTransparency = 0.2,
        BorderSizePixel  = 0,
        ZIndex           = 10,
    }, Gui)
    corner(14, Main)
    stroke(C.Border, 1, Main)

    mk("ImageLabel", {
        Size                   = UDim2.new(1, 70, 1, 70),
        Position               = UDim2.new(0, -35, 0, -25),
        BackgroundTransparency = 1,
        Image                  = "rbxassetid://6014261993",
        ImageColor3            = Color3.new(0, 0, 0),
        ImageTransparency      = 0.45,
        ZIndex                 = 9,
        ScaleType              = Enum.ScaleType.Slice,
        SliceCenter            = Rect.new(49, 49, 450, 450),
    }, Main)

    -- ── Header ─────────────────────────────────────────────
    local Header = mk("Frame", {
        Name             = "Header",
        Size             = UDim2.new(1, 0, 0, 50),
        BackgroundColor3 = C.BG2,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, Main)
    corner(14, Header)

    mk("Frame", {
        Size             = UDim2.new(1, 0, 0, 14),
        Position         = UDim2.new(0, 0, 1, -14),
        BackgroundColor3 = C.BG2,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, Header)

    mk("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        Position         = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = C.Border,
        BorderSizePixel  = 0,
        ZIndex           = 12,
    }, Header)

    local hLogo = mk("ImageLabel", {
        Size             = UDim2.new(0, 26, 0, 26),
        Position         = UDim2.new(0, 13, 0.5, -13),
        BackgroundColor3 = C.Surface,
        Image            = A.Logo,
        ZIndex           = 12,
    }, Header)
    corner(6, hLogo)

    mk("Frame", {
        Size             = UDim2.new(0, 1, 0, 22),
        Position         = UDim2.new(0, 48, 0.5, -11),
        BackgroundColor3 = C.Border,
        BorderSizePixel  = 0,
        ZIndex           = 12,
    }, Header)

    mk("TextLabel", {
        Size                   = UDim2.new(0, 200, 0, 18),
        Position               = UDim2.new(0, 58, 0, 8),
        BackgroundTransparency = 1,
        Text                   = Title,
        TextColor3             = C.Text,
        TextSize               = 13,
        Font                   = Enum.Font.GothamBold,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 12,
    }, Header)

    mk("TextLabel", {
        Size                   = UDim2.new(0, 200, 0, 14),
        Position               = UDim2.new(0, 58, 0, 28),
        BackgroundTransparency = 1,
        Text                   = Subtitle,
        TextColor3             = C.TextMut,
        TextSize               = 10,
        Font                   = Enum.Font.Gotham,
        TextXAlignment         = Enum.TextXAlignment.Left,
        ZIndex                 = 12,
    }, Header)

    local function ctrlBtn(ico, xOff)
        local b = mk("ImageButton", {
            Size             = UDim2.new(0, 24, 0, 24),
            Position         = UDim2.new(1, xOff, 0.5, -12),
            BackgroundColor3 = C.Surface,
            Image            = ico,
            ImageColor3      = C.White,
            ZIndex           = 13,
            AutoButtonColor  = false,
        }, Header)
        corner(6, b)
        b.MouseEnter:Connect(function() tw(b, {BackgroundColor3 = C.SurfHov}, 0.12) end)
        b.MouseLeave:Connect(function() tw(b, {BackgroundColor3 = C.Surface},  0.12) end)
        return b
    end

    local BtnMin   = ctrlBtn(A.IconMinimize, -66)
    local BtnClose = ctrlBtn(A.IconClose,    -36)

    -- ── Sidebar ────────────────────────────────────────────
    local Sidebar = mk("Frame", {
        Name             = "Sidebar",
        Size             = UDim2.new(0, 145, 1, -50),
        Position         = UDim2.new(0, 0, 0, 50),
        BackgroundColor3 = C.BG2,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, Main)

    mk("Frame", {
        Size             = UDim2.new(0, 1, 1, 0),
        Position         = UDim2.new(1, 0, 0, 0),
        BackgroundColor3 = C.Border,
        BorderSizePixel  = 0,
        ZIndex           = 12,
    }, Sidebar)

    local TabScroll = mk("ScrollingFrame", {
        Size                   = UDim2.new(1, 0, 1, -32),
        BackgroundTransparency = 1,
        BorderSizePixel        = 0,
        ScrollBarThickness     = 0,
        ZIndex                 = 12,
        CanvasSize             = UDim2.new(0, 0, 0, 0),
    }, Sidebar)
    pad(8, 8, 8, 8, TabScroll)
    local tabLayout = listLayout(3, TabScroll)

    mk("TextLabel", {
        Size                   = UDim2.new(1, 0, 0, 32),
        Position               = UDim2.new(0, 0, 1, -32),
        BackgroundTransparency = 1,
        Text                   = "v1.0.0",
        TextColor3             = C.TextMut,
        TextSize               = 9,
        Font                   = Enum.Font.Gotham,
        ZIndex                 = 12,
    }, Sidebar)

    -- ── Content Area ───────────────────────────────────────
    local ContentArea = mk("Frame", {
        Name                   = "ContentArea",
        Size                   = UDim2.new(1, -145, 1, -86),
        Position               = UDim2.new(0, 145, 0, 50),
        BackgroundTransparency = 1,
        ZIndex                 = 11,
        ClipsDescendants       = true,
    }, Main)

    -- ── Footer ─────────────────────────────────────────────
    local Footer = mk("Frame", {
        Name             = "Footer",
        Size             = UDim2.new(1, -145, 0, 36),
        Position         = UDim2.new(0, 145, 1, -36),
        BackgroundColor3 = C.BG2,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, Main)
    corner(14, Footer)
    mk("Frame", {
        Size             = UDim2.new(1, 0, 0, 14),
        BackgroundColor3 = C.BG2,
        BorderSizePixel  = 0,
        ZIndex           = 11,
    }, Footer)
    mk("Frame", {
        Size             = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = C.Border,
        BorderSizePixel  = 0,
        ZIndex           = 12,
    }, Footer)
    mk("TextLabel", {
        Size                   = UDim2.new(1, -20, 1, 0),
        Position               = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text                   = "© 𝚃𝚘𝚍𝚘𝚜 𝚘𝚜 𝚍𝚒𝚛𝚎𝚒𝚝𝚘𝚜 𝚛𝚎𝚜𝚎𝚛𝚟𝚊𝚍𝚘𝚜 — 𝚑𝚝𝚝𝚙𝚜://𝚛𝚒𝚚𝚞𝚎𝚕𝚖𝚎-𝚍𝚎𝚟.𝚗𝚎𝚝𝚕𝚒𝚏𝚢.𝚊𝚙𝚙/",
        TextColor3             = C.TextMut,
        TextSize               = 10,
        Font                   = Enum.Font.Code,
        TextXAlignment         = Enum.TextXAlignment.Center,
        ZIndex                 = 12,
    }, Footer)

    -- ── Arrastar ───────────────────────────────────────────
    do
        local drag, ds, sp = false, nil, nil
        Header.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then
                drag = true; ds = i.Position; sp = Main.Position
            end
        end)
        Header.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then drag = false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if drag and i.UserInputType == Enum.UserInputType.MouseMovement then
                local d = i.Position - ds
                Main.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
            end
        end)
    end

    -- ── Minimizar ──────────────────────────────────────────
    local minimized = false
    BtnMin.MouseButton1Click:Connect(function()
        playSound(A.SoundMin)
        minimized = not minimized
        tw(Main, {Size = minimized and UDim2.new(0, WW, 0, 50) or UDim2.new(0, WW, 0, WH)}, 0.28, Enum.EasingStyle.Quart)
    end)

    -- ── Fechar ─────────────────────────────────────────────
    BtnClose.MouseButton1Click:Connect(function()
        playSound(A.SoundClose)
        tw(Main, {Size = UDim2.new(0, WW * 0.9, 0, WH * 0.9), BackgroundTransparency = 1}, 0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In)
        task.wait(0.26)
        pcall(function() Gui:Destroy() end)
    end)

    -- ── Animacao abertura ──────────────────────────────────
    playSound(A.SoundOpen)
    tw(Main, {Size = UDim2.new(0, WW, 0, WH), BackgroundTransparency = 0}, 0.38, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

    task.wait(0.6)
    Notify({ Title = ScriptName, Message = "Interface carregada com sucesso.", Duration = 4 })
    task.wait(1.0)
    Notify({ Title = "Acesse o Nosso Site", Message = "riquelme-dev.netlify.app", Duration = 5 })

    -- ══════════════════════════════════════════════════════
    --  WINDOW OBJECT
    -- ══════════════════════════════════════════════════════

    local Win   = {}
    Win._tabs   = {}
    Win._pages  = {}
    Win._active = nil

    local tabOrder = 0

    local function switchTab(name)
        if Win._active == name then return end
        Win._active = name
        playSound(A.SoundClick)
        for n, d in pairs(Win._tabs) do
            local on = (n == name)
            tw(d.btn, {BackgroundColor3 = on and C.Surface or C.BG2, BackgroundTransparency = on and 0 or 1}, 0.16)
            tw(d.lbl, {TextColor3 = on and C.Text or C.TextDim}, 0.16)
            d.ind.BackgroundTransparency = on and 0 or 1
        end
        for n, pg in pairs(Win._pages) do
            pg.Visible = (n == name)
        end
    end

    -- ── AddTab ─────────────────────────────────────────────
    function Win:AddTab(name)
        tabOrder = tabOrder + 1

        local btn = mk("TextButton", {
            Name                   = "Tab_"..name,
            Size                   = UDim2.new(1, 0, 0, 32),
            BackgroundColor3       = C.BG2,
            BackgroundTransparency = 1,
            Text                   = "",
            ZIndex                 = 13,
            AutoButtonColor        = false,
            LayoutOrder            = tabOrder,
        }, TabScroll)
        corner(8, btn)

        local ind = mk("Frame", {
            Size                   = UDim2.new(0, 3, 0, 16),
            Position               = UDim2.new(0, 1, 0.5, -8),
            BackgroundColor3       = C.White,
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            ZIndex                 = 14,
        }, btn)
        corner(2, ind)

        local lbl = mk("TextLabel", {
            Size                   = UDim2.new(1, -12, 1, 0),
            Position               = UDim2.new(0, 12, 0, 0),
            BackgroundTransparency = 1,
            Text                   = name,
            TextColor3             = C.TextDim,
            TextSize               = 12,
            Font                   = Enum.Font.GothamSemibold,
            TextXAlignment         = Enum.TextXAlignment.Left,
            ZIndex                 = 14,
        }, btn)

        btn.MouseEnter:Connect(function()
            if Win._active ~= name then
                tw(btn, {BackgroundTransparency = 0.65, BackgroundColor3 = C.Surface}, 0.12)
            end
        end)
        btn.MouseLeave:Connect(function()
            if Win._active ~= name then
                tw(btn, {BackgroundTransparency = 1}, 0.12)
            end
        end)
        btn.MouseButton1Click:Connect(function() switchTab(name) end)

        tabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabScroll.CanvasSize = UDim2.new(0, 0, 0, tabLayout.AbsoluteContentSize.Y + 16)
        end)

        local page = mk("ScrollingFrame", {
            Name                   = "Page_"..name,
            Size                   = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel        = 0,
            ScrollBarThickness     = 3,
            ScrollBarImageColor3   = C.Border,
            CanvasSize             = UDim2.new(0, 0, 0, 0),
            Visible                = false,
            ZIndex                 = 12,
        }, ContentArea)
        pad(12, 14, 12, 14, page)
        local pageList = listLayout(8, page)

        pageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            page.CanvasSize = UDim2.new(0, 0, 0, pageList.AbsoluteContentSize.Y + 24)
        end)

        Win._tabs[name]  = {btn = btn, lbl = lbl, ind = ind}
        Win._pages[name] = page

        if not Win._active then switchTab(name) end

        -- ── TAB API ────────────────────────────────────────
        local Tab      = {}
        local itemOrder = 0

        local function nextOrder()
            itemOrder = itemOrder + 1
            return itemOrder
        end

        function Tab:AddSection(title)
            local f = mk("Frame", {
                Size                   = UDim2.new(1, 0, 0, 26),
                BackgroundTransparency = 1,
                ZIndex                 = 13,
                LayoutOrder            = nextOrder(),
            }, page)
            mk("TextLabel", {
                Size                   = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text                   = string.upper(title),
                TextColor3             = C.TextMut,
                TextSize               = 10,
                Font                   = Enum.Font.GothamBold,
                TextXAlignment         = Enum.TextXAlignment.Left,
                ZIndex                 = 14,
            }, f)
            mk("Frame", {
                Size             = UDim2.new(1, 0, 0, 1),
                Position         = UDim2.new(0, 0, 1, -1),
                BackgroundColor3 = C.Divider,
                BorderSizePixel  = 0,
                ZIndex           = 14,
            }, f)
        end

        function Tab:AddDivider()
            mk("Frame", {
                Size             = UDim2.new(1, 0, 0, 1),
                BackgroundColor3 = C.Divider,
                BorderSizePixel  = 0,
                ZIndex           = 13,
                LayoutOrder      = nextOrder(),
            }, page)
        end

        function Tab:AddLabel(text)
            mk("TextLabel", {
                Size                   = UDim2.new(1, 0, 0, 20),
                BackgroundTransparency = 1,
                Text                   = text,
                TextColor3             = C.TextDim,
                TextSize               = 12,
                Font                   = Enum.Font.Gotham,
                TextXAlignment         = Enum.TextXAlignment.Left,
                TextWrapped            = true,
                ZIndex                 = 13,
                LayoutOrder            = nextOrder(),
            }, page)
        end

        function Tab:AddButton(cfg2)
            cfg2 = cfg2 or {}
            local w = mk("Frame", {
                Size             = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = C.Surface,
                BorderSizePixel  = 0,
                ZIndex           = 13,
                LayoutOrder      = nextOrder(),
            }, page)
            corner(8, w)
            stroke(C.Border, 1, w)

            mk("TextLabel", {
                Size                   = UDim2.new(1, -38, 1, 0),
                Position               = UDim2.new(0, 13, 0, 0),
                BackgroundTransparency = 1,
                Text                   = cfg2.Label or "Botao",
                TextColor3             = C.Text,
                TextSize               = 13,
                Font                   = Enum.Font.GothamSemibold,
                TextXAlignment         = Enum.TextXAlignment.Left,
                ZIndex                 = 14,
            }, w)

            mk("TextLabel", {
                Size                   = UDim2.new(0, 18, 1, 0),
                Position               = UDim2.new(1, -22, 0, 0),
                BackgroundTransparency = 1,
                Text                   = ">",
                TextColor3             = C.TextMut,
                TextSize               = 13,
                Font                   = Enum.Font.GothamBold,
                ZIndex                 = 14,
            }, w)

            local b2 = mk("TextButton", {
                Size                   = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text                   = "",
                ZIndex                 = 15,
                AutoButtonColor        = false,
            }, w)
            b2.MouseEnter:Connect(function() tw(w, {BackgroundColor3 = C.SurfHov}, 0.12) end)
            b2.MouseLeave:Connect(function() tw(w, {BackgroundColor3 = C.Surface},  0.12) end)
            b2.MouseButton1Click:Connect(function()
                playSound(A.SoundClick)
                tw(w, {BackgroundColor3 = C.BorderLt}, 0.06)
                task.wait(0.07)
                tw(w, {BackgroundColor3 = C.SurfHov}, 0.12)
                if cfg2.Callback then task.spawn(cfg2.Callback) end
            end)
        end

        function Tab:AddToggle(cfg2)
            cfg2 = cfg2 or {}
            local state = cfg2.Default == true

            local w = mk("Frame", {
                Size             = UDim2.new(1, 0, 0, 38),
                BackgroundColor3 = C.Surface,
                BorderSizePixel  = 0,
                ZIndex           = 13,
                LayoutOrder      = nextOrder(),
            }, page)
            corner(8, w)
            stroke(C.Border, 1, w)

            mk("TextLabel", {
                Size                   = UDim2.new(1, -56, 1, 0),
                Position               = UDim2.new(0, 13, 0, 0),
                BackgroundTransparency = 1,
                Text                   = cfg2.Label or "Toggle",
                TextColor3             = C.Text,
                TextSize               = 13,
                Font                   = Enum.Font.GothamSemibold,
                TextXAlignment         = Enum.TextXAlignment.Left,
                ZIndex                 = 14,
            }, w)

            local track = mk("Frame", {
                Size             = UDim2.new(0, 34, 0, 18),
                Position         = UDim2.new(1, -46, 0.5, -9),
                BackgroundColor3 = state and C.Toggle or C.ToggleOff,
                BorderSizePixel  = 0,
                ZIndex           = 14,
            }, w)
            corner(9, track)

            local knob = mk("Frame", {
                Size             = UDim2.new(0, 12, 0, 12),
                Position         = state and UDim2.new(0, 18, 0.5, -6) or UDim2.new(0, 3, 0.5, -6),
                BackgroundColor3 = C.White,
                BorderSizePixel  = 0,
                ZIndex           = 15,
            }, track)
            corner(6, knob)

            local ob = mk("TextButton", {
                Size=UDim2.new(1,0,1,0), BackgroundTransparency=1,
                Text="", ZIndex=16, AutoButtonColor=false,
            }, w)
            ob.MouseEnter:Connect(function() tw(w,{BackgroundColor3=C.SurfHov},0.12) end)
            ob.MouseLeave:Connect(function() tw(w,{BackgroundColor3=C.Surface},0.12) end)
            ob.MouseButton1Click:Connect(function()
                playSound(A.SoundClick)
                state = not state
                tw(track, {BackgroundColor3 = state and C.Toggle or C.ToggleOff}, 0.18)
                tw(knob,  {Position = state and UDim2.new(0,18,0.5,-6) or UDim2.new(0,3,0.5,-6)}, 0.18, Enum.EasingStyle.Back)
                if cfg2.Callback then task.spawn(cfg2.Callback, state) end
            end)

            local obj = {}
            function obj:Set(v)
                state = v
                tw(track, {BackgroundColor3 = state and C.Toggle or C.ToggleOff}, 0.18)
                tw(knob,  {Position = state and UDim2.new(0,18,0.5,-6) or UDim2.new(0,3,0.5,-6)}, 0.18, Enum.EasingStyle.Back)
            end
            function obj:Get() return state end
            return obj
        end

        function Tab:AddSlider(cfg2)
            cfg2 = cfg2 or {}
            local Min  = cfg2.Min     or 0
            local Max  = cfg2.Max     or 100
            local cur  = math.clamp(cfg2.Default or Min, Min, Max)

            local w = mk("Frame", {
                Size             = UDim2.new(1, 0, 0, 52),
                BackgroundColor3 = C.Surface,
                BorderSizePixel  = 0,
                ZIndex           = 13,
                LayoutOrder      = nextOrder(),
            }, page)
            corner(8, w)
            stroke(C.Border, 1, w)

            mk("TextLabel", {
                Size=UDim2.new(0.6,0,0,18), Position=UDim2.new(0,13,0,6),
                BackgroundTransparency=1, Text=cfg2.Label or "Slider",
                TextColor3=C.Text, TextSize=13, Font=Enum.Font.GothamSemibold,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14,
            }, w)

            local valLbl = mk("TextLabel", {
                Size=UDim2.new(0.4,0,0,18), Position=UDim2.new(0.6,-13,0,6),
                BackgroundTransparency=1, Text=tostring(cur),
                TextColor3=C.TextDim, TextSize=12, Font=Enum.Font.GothamSemibold,
                TextXAlignment=Enum.TextXAlignment.Right, ZIndex=14,
            }, w)

            local trk = mk("Frame", {
                Size=UDim2.new(1,-26,0,4), Position=UDim2.new(0,13,0,36),
                BackgroundColor3=C.ToggleOff, BorderSizePixel=0, ZIndex=14,
            }, w)
            corner(2, trk)

            local pct0 = (cur - Min) / (Max - Min)
            local fill = mk("Frame", {
                Size=UDim2.new(pct0,0,1,0), BackgroundColor3=C.White,
                BorderSizePixel=0, ZIndex=15,
            }, trk)
            corner(2, fill)

            local kn = mk("Frame", {
                Size=UDim2.new(0,12,0,12), Position=UDim2.new(pct0,-6,0.5,-6),
                BackgroundColor3=C.White, BorderSizePixel=0, ZIndex=16,
            }, trk)
            corner(6, kn)

            local dragging = false

            local function upd(x)
                local abs = trk.AbsolutePosition.X
                local wid = trk.AbsoluteSize.X
                if wid == 0 then return end
                local p = math.clamp((x - abs) / wid, 0, 1)
                cur = math.round(Min + p * (Max - Min))
                valLbl.Text = tostring(cur)
                tw(fill, {Size=UDim2.new(p,0,1,0)},     0.04)
                tw(kn,   {Position=UDim2.new(p,-6,0.5,-6)}, 0.04)
                if cfg2.Callback then task.spawn(cfg2.Callback, cur) end
            end

            trk.InputBegan:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true; playSound(A.SoundClick); upd(i.Position.X)
                end
            end)
            UserInputService.InputChanged:Connect(function(i)
                if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then upd(i.Position.X) end
            end)
            UserInputService.InputEnded:Connect(function(i)
                if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
            end)

            local obj = {}
            function obj:Set(v)
                cur = math.clamp(v, Min, Max)
                local p = (cur - Min) / (Max - Min)
                valLbl.Text = tostring(cur)
                tw(fill, {Size=UDim2.new(p,0,1,0)},         0.12)
                tw(kn,   {Position=UDim2.new(p,-6,0.5,-6)}, 0.12)
            end
            function obj:Get() return cur end
            return obj
        end

        function Tab:AddTextbox(cfg2)
            cfg2 = cfg2 or {}

            local w = mk("Frame", {
                Size=UDim2.new(1,0,0,52), BackgroundColor3=C.Surface,
                BorderSizePixel=0, ZIndex=13, LayoutOrder=nextOrder(),
            }, page)
            corner(8, w)
            stroke(C.Border, 1, w)

            mk("TextLabel", {
                Size=UDim2.new(1,-26,0,18), Position=UDim2.new(0,13,0,5),
                BackgroundTransparency=1, Text=cfg2.Label or "Campo",
                TextColor3=C.Text, TextSize=13, Font=Enum.Font.GothamSemibold,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14,
            }, w)

            local ibg = mk("Frame", {
                Size=UDim2.new(1,-26,0,22), Position=UDim2.new(0,13,0,24),
                BackgroundColor3=C.BG3, BorderSizePixel=0, ZIndex=14,
            }, w)
            corner(6, ibg)
            stroke(C.Border, 1, ibg)

            local tb = mk("TextBox", {
                Size=UDim2.new(1,-16,1,0), Position=UDim2.new(0,8,0,0),
                BackgroundTransparency=1,
                PlaceholderText=cfg2.Placeholder or "Digite aqui...",
                PlaceholderColor3=C.TextMut,
                Text=cfg2.Default or "",
                TextColor3=C.Text, TextSize=12, Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left,
                ClearTextOnFocus=false, ZIndex=15,
            }, ibg)

            tb.Focused:Connect(function()   tw(ibg, {BackgroundColor3 = C.BG2}, 0.12) end)
            tb.FocusLost:Connect(function(enter)
                tw(ibg, {BackgroundColor3 = C.BG3}, 0.12)
                if enter and cfg2.Callback then task.spawn(cfg2.Callback, tb.Text) end
            end)

            local obj = {}
            function obj:Get() return tb.Text end
            function obj:Set(v) tb.Text = tostring(v) end
            return obj
        end

        function Tab:AddDropdown(cfg2)
            cfg2 = cfg2 or {}
            local opts2 = cfg2.Options or {}
            local sel   = cfg2.Default or (opts2[1] or "Selecionar")
            local open  = false

            local w = mk("Frame", {
                Size=UDim2.new(1,0,0,38), BackgroundColor3=C.Surface,
                BorderSizePixel=0, ZIndex=13, LayoutOrder=nextOrder(),
                ClipsDescendants=false,
            }, page)
            corner(8, w)
            stroke(C.Border, 1, w)

            mk("TextLabel", {
                Size=UDim2.new(0.5,0,1,0), Position=UDim2.new(0,13,0,0),
                BackgroundTransparency=1, Text=cfg2.Label or "Opcao",
                TextColor3=C.Text, TextSize=13, Font=Enum.Font.GothamSemibold,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=14,
            }, w)

            local sb = mk("TextButton", {
                Size=UDim2.new(0,128,0,24), Position=UDim2.new(1,-140,0.5,-12),
                BackgroundColor3=C.BG3, Text="", ZIndex=14, AutoButtonColor=false,
            }, w)
            corner(6, sb)
            stroke(C.Border, 1, sb)

            local selLbl = mk("TextLabel", {
                Size=UDim2.new(1,-20,1,0), Position=UDim2.new(0,7,0,0),
                BackgroundTransparency=1, Text=sel,
                TextColor3=C.Text, TextSize=11, Font=Enum.Font.Gotham,
                TextXAlignment=Enum.TextXAlignment.Left, ZIndex=15,
            }, sb)

            mk("TextLabel", {
                Size=UDim2.new(0,14,1,0), Position=UDim2.new(1,-16,0,0),
                BackgroundTransparency=1, Text="v",
                TextColor3=C.TextMut, TextSize=9, Font=Enum.Font.GothamBold,
                ZIndex=15,
            }, sb)

            local dl = mk("Frame", {
                Size=UDim2.new(0,128,0,0), Position=UDim2.new(1,-140,1,3),
                BackgroundColor3=C.BG2, BorderSizePixel=0,
                ClipsDescendants=true, ZIndex=20, Visible=false,
            }, w)
            corner(8, dl)
            stroke(C.BorderLt, 1, dl)

            local di = mk("Frame", {
                Size=UDim2.new(1,0,0,1),
                BackgroundTransparency=1, ZIndex=21,
            }, dl)
            pad(4, 5, 4, 5, di)
            listLayout(2, di)

            for _, opt in ipairs(opts2) do
                local ob2 = mk("TextButton", {
                    Size=UDim2.new(1,0,0,26), BackgroundTransparency=1,
                    BackgroundColor3=C.Surface, Text=opt,
                    TextColor3=C.TextDim, TextSize=11, Font=Enum.Font.Gotham,
                    TextXAlignment=Enum.TextXAlignment.Left,
                    ZIndex=22, AutoButtonColor=false,
                }, di)
                corner(5, ob2)
                pad(0, 0, 0, 6, ob2)

                ob2.MouseEnter:Connect(function()
                    tw(ob2, {BackgroundTransparency = 0.5, BackgroundColor3 = C.Surface, TextColor3 = C.Text}, 0.1)
                end)
                ob2.MouseLeave:Connect(function()
                    tw(ob2, {BackgroundTransparency = 1, TextColor3 = C.TextDim}, 0.1)
                end)
                ob2.MouseButton1Click:Connect(function()
                    playSound(A.SoundClick)
                    sel = opt; selLbl.Text = opt
                    open = false
                    tw(dl, {Size = UDim2.new(0, 128, 0, 0)}, 0.18, Enum.EasingStyle.Quart)
                    task.wait(0.19); dl.Visible = false
                    if cfg2.Callback then task.spawn(cfg2.Callback, opt) end
                end)
            end

            sb.MouseEnter:Connect(function() tw(sb, {BackgroundColor3 = C.Surface}, 0.12) end)
            sb.MouseLeave:Connect(function() tw(sb, {BackgroundColor3 = C.BG3},     0.12) end)
            sb.MouseButton1Click:Connect(function()
                playSound(A.SoundClick)
                open = not open
                if open then
                    local h = math.min(#opts2 * 28 + 8, 150)
                    dl.Visible = true; dl.Size = UDim2.new(0, 128, 0, 0)
                    tw(dl, {Size = UDim2.new(0, 128, 0, h)}, 0.2, Enum.EasingStyle.Quart)
                else
                    tw(dl, {Size = UDim2.new(0, 128, 0, 0)}, 0.15)
                    task.wait(0.16); dl.Visible = false
                end
            end)

            local obj = {}
            function obj:Get() return sel end
            function obj:Set(v)
                sel = v; selLbl.Text = v
                if cfg2.Callback then task.spawn(cfg2.Callback, v) end
            end
            return obj
        end

        return Tab
    end

    function Win:Notify(notifCfg) Notify(notifCfg) end

    return Win
end

return RiquelmeUI
