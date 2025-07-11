-- Emerald Hub GUI - Otimizado para Executores
-- By: sunav7

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Variáveis
local player = Players.LocalPlayer
local espEnabled = false
local espPlayers = {}

-- ScreenGui
local main = Instance.new("ScreenGui")
main.Name = "EmeraldHub"
main.Parent = player:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
main.ResetOnSpawn = false

-- Fundo principal
local Fundo = Instance.new("Frame")
Fundo.Name = "Fundo"
Fundo.Parent = main
Fundo.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
Fundo.BorderSizePixel = 0
Fundo.Position = UDim2.new(0.2937, 0, 0.3035, 0)
Fundo.Size = UDim2.new(0, 370, 0, 205)
Fundo.ZIndex = 1

-- UI Corner nas bordas do hub
local FundoUICorner = Instance.new("UICorner")
FundoUICorner.CornerRadius = UDim.new(0, 16)
FundoUICorner.Parent = Fundo

-- Sombra com UICorner e mesmo tamanho da GUI
local FrameShadow = Instance.new("Frame")
FrameShadow.Name = "FrameShadow"
FrameShadow.Parent = Fundo
FrameShadow.AnchorPoint = Vector2.new(0.5, 0.5)
FrameShadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
FrameShadow.BackgroundTransparency = 0.7
FrameShadow.BorderSizePixel = 0
FrameShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
FrameShadow.Size = UDim2.new(1, 8, 1, 8)
FrameShadow.ZIndex = -1

local ShadowUICorner = Instance.new("UICorner")
ShadowUICorner.CornerRadius = UDim.new(0, 16)
ShadowUICorner.Parent = FrameShadow

-- Bar (área interativa/draggable)
local bar = Instance.new("Frame")
bar.Name = "bar"
bar.Parent = Fundo
bar.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
bar.BorderSizePixel = 0
bar.Position = UDim2.new(0, 0, 0, 0)
bar.Size = UDim2.new(1, 0, 1, 0)
bar.Active = true
bar.Selectable = true
bar.ZIndex = 2

local BarUICorner = Instance.new("UICorner")
BarUICorner.CornerRadius = UDim.new(0, 16)
BarUICorner.Parent = bar

-- Sistema de Drag otimizado
local dragging = false
local dragStart = nil
local startPos = nil

local function updateDrag(input)
    if dragging and dragStart and startPos then
        local delta = input.Position - dragStart
        Fundo.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end

bar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = Fundo.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        updateDrag(input)
    end
end)

-- Título (Centralizado com imagem e texto lado a lado)
local TitleFrame = Instance.new("Frame")
TitleFrame.Name = "TitleFrame"
TitleFrame.Parent = bar
TitleFrame.BackgroundTransparency = 1
TitleFrame.Size = UDim2.new(1, 0, 0, 28)
TitleFrame.Position = UDim2.new(0, 0, 0.025, 0)
TitleFrame.ZIndex = 3

local TitleLayout = Instance.new("UIListLayout")
TitleLayout.Parent = TitleFrame
TitleLayout.FillDirection = Enum.FillDirection.Horizontal
TitleLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
TitleLayout.VerticalAlignment = Enum.VerticalAlignment.Center
TitleLayout.SortOrder = Enum.SortOrder.LayoutOrder
TitleLayout.Padding = UDim.new(0, 6)

local ImageLabel = Instance.new("ImageLabel")
ImageLabel.Parent = TitleFrame
ImageLabel.BackgroundTransparency = 1
ImageLabel.Size = UDim2.new(0, 23, 0, 23)
ImageLabel.Image = "rbxassetid://117483443949036"
ImageLabel.ZIndex = 4

local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = TitleFrame
TextLabel.BackgroundTransparency = 1
TextLabel.Size = UDim2.new(0, 140, 0, 23)
TextLabel.Font = Enum.Font.ArialBold
TextLabel.Text = "Emerald Hub"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextWrapped = true
TextLabel.ZIndex = 4

-- Botão de minimizar (imagem customizada)
local MinBtn = Instance.new("ImageButton")
MinBtn.Name = "MinBtn"
MinBtn.Parent = bar
MinBtn.Size = UDim2.new(0, 22, 0, 22)
MinBtn.Position = UDim2.new(1, -30, 0, 6)
MinBtn.BackgroundTransparency = 1
MinBtn.Image = "rbxassetid://10734895698"
MinBtn.ZIndex = 5
MinBtn.AutoButtonColor = true

-- Botão flutuante para reabrir o hub
local OpenBtn = Instance.new("ImageButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Parent = main
OpenBtn.Size = UDim2.new(0, 36, 0, 36)
OpenBtn.Position = UDim2.new(0, 16, 1, -52)
OpenBtn.BackgroundTransparency = 1
OpenBtn.Image = "rbxassetid://117483443949036"
OpenBtn.ZIndex = 10
OpenBtn.Visible = false
OpenBtn.AutoButtonColor = true

-- Funções de minimizar/maximizar
MinBtn.MouseButton1Click:Connect(function()
    Fundo.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Fundo.Visible = true
    OpenBtn.Visible = false
end)

-- ESP Player com Highlight e Chams
local function createESP(plr)
    if espPlayers[plr] then return end
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "PlayerESP"
    highlight.FillColor = Color3.fromRGB(85, 255, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.3
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    
    if plr.Character then
        highlight.Parent = plr.Character
    end
    
    espPlayers[plr] = highlight
end

local function removeESP(plr)
    if espPlayers[plr] then
        espPlayers[plr]:Destroy()
        espPlayers[plr] = nil
    end
end

-- Botão ESP
local function createButton(name, text, posY)
    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Parent = bar
    btn.BackgroundColor3 = Color3.fromRGB(85, 255, 0)
    btn.BorderSizePixel = 0
    btn.Position = UDim2.new(0.2027, 0, posY, 0)
    btn.Size = UDim2.new(0, 230, 0, 39)
    btn.Font = Enum.Font.Arial
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.TextSize = 18
    btn.TextWrapped = true
    btn.ZIndex = 3
    
    local btnUICorner = Instance.new("UICorner")
    btnUICorner.CornerRadius = UDim.new(0, 12)
    btnUICorner.Parent = btn
    
    local grad = Instance.new("UIGradient")
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(142, 158, 171)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(238, 242, 243))
    }
    grad.Rotation = -90
    grad.Parent = btn
    
    return btn
end

local espButton = createButton("ESPButton", "ESP PLAYER", 0.1854)

-- Função do ESP otimizada
espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    
    if espEnabled then
        -- Ativar ESP para todos os jogadores
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                createESP(plr)
            end
        end
        espButton.Text = "ESP PLAYER (ON)"
        espButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    else
        -- Desativar ESP para todos os jogadores
        for _, plr in pairs(Players:GetPlayers()) do
            removeESP(plr)
        end
        espButton.Text = "ESP PLAYER"
        espButton.BackgroundColor3 = Color3.fromRGB(85, 255, 0)
    end
end)

-- Sistema de ESP otimizado
local function setupESP()
    -- Conectar ESP para novos jogadores
    Players.PlayerAdded:Connect(function(plr)
        if espEnabled then
            plr.CharacterAdded:Connect(function(char)
                createESP(plr)
            end)
        end
    end)
    
    -- Conectar ESP para jogadores existentes
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= player and espEnabled then
            plr.CharacterAdded:Connect(function(char)
                createESP(plr)
            end)
        end
    end
    
    -- Limpar ESP quando jogador sai
    Players.PlayerRemoving:Connect(function(plr)
        removeESP(plr)
    end)
end

-- Créditos
local TextLabel_2 = Instance.new("TextLabel")
TextLabel_2.Parent = bar
TextLabel_2.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
TextLabel_2.BorderSizePixel = 0
TextLabel_2.Position = UDim2.new(0.4189, 0, 0.8976, 0)
TextLabel_2.Size = UDim2.new(0, 65, 0, 12)
TextLabel_2.Font = Enum.Font.SourceSansBold
TextLabel_2.Text = "By: sunav7"
TextLabel_2.TextColor3 = Color3.fromRGB(0, 0, 0)
TextLabel_2.TextSize = 14
TextLabel_2.TextWrapped = true
TextLabel_2.ZIndex = 3

-- Inicialização
setupESP()

-- Notificação de carregamento
print("Emerald Hub carregado com sucesso!")
print("Use o botão X para minimizar a interface")
print("ESP Player está funcionando!")

-- Proteção contra erros
local success, err = pcall(function()
    -- Código adicional aqui se necessário
end)

if not success then
    warn("Erro no Emerald Hub:", err)
end
