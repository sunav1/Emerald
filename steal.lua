-- Emerald Hub GUI - Ultra Compatível
-- By: sunav7

-- Serviços
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Player
local player = Players.LocalPlayer

-- ScreenGui
local main = Instance.new("ScreenGui")
main.Name = "EmeraldHub"
main.Parent = player:WaitForChild("PlayerGui")
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Fundo principal
local Fundo = Instance.new("Frame")
Fundo.Name = "Fundo"
Fundo.Parent = main
Fundo.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
Fundo.BorderSizePixel = 0
Fundo.Position = UDim2.new(0.2937, 0, 0.3035, 0)
Fundo.Size = UDim2.new(0, 370, 0, 205)

-- UI Corner
local FundoUICorner = Instance.new("UICorner")
FundoUICorner.CornerRadius = UDim.new(0, 16)
FundoUICorner.Parent = Fundo

-- Sombra
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

-- Bar
local bar = Instance.new("Frame")
bar.Name = "bar"
bar.Parent = Fundo
bar.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
bar.BorderSizePixel = 0
bar.Position = UDim2.new(0, 0, 0, 0)
bar.Size = UDim2.new(1, 0, 1, 0)
bar.Active = true
bar.Selectable = true

local BarUICorner = Instance.new("UICorner")
BarUICorner.CornerRadius = UDim.new(0, 16)
BarUICorner.Parent = bar

-- Drag
local dragging = false
local dragStart = nil
local startPos = nil

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
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        local delta = input.Position - dragStart
        Fundo.Position = UDim2.new(
            startPos.X.Scale,
            startPos.X.Offset + delta.X,
            startPos.Y.Scale,
            startPos.Y.Offset + delta.Y
        )
    end
end)

-- Título
local TitleFrame = Instance.new("Frame")
TitleFrame.Name = "TitleFrame"
TitleFrame.Parent = bar
TitleFrame.BackgroundTransparency = 1
TitleFrame.Size = UDim2.new(1, 0, 0, 28)
TitleFrame.Position = UDim2.new(0, 0, 0.025, 0)

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

local TextLabel = Instance.new("TextLabel")
TextLabel.Parent = TitleFrame
TextLabel.BackgroundTransparency = 1
TextLabel.Size = UDim2.new(0, 140, 0, 23)
TextLabel.Font = Enum.Font.ArialBold
TextLabel.Text = "Emerald Hub"
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextScaled = true
TextLabel.TextWrapped = true

-- Botão minimizar
local MinBtn = Instance.new("ImageButton")
MinBtn.Name = "MinBtn"
MinBtn.Parent = bar
MinBtn.Size = UDim2.new(0, 22, 0, 22)
MinBtn.Position = UDim2.new(1, -30, 0, 6)
MinBtn.BackgroundTransparency = 1
MinBtn.Image = "rbxassetid://10734895698"
MinBtn.AutoButtonColor = true

-- Botão flutuante
local OpenBtn = Instance.new("ImageButton")
OpenBtn.Name = "OpenBtn"
OpenBtn.Parent = main
OpenBtn.Size = UDim2.new(0, 36, 0, 36)
OpenBtn.Position = UDim2.new(0, 16, 1, -52)
OpenBtn.BackgroundTransparency = 1
OpenBtn.Image = "rbxassetid://117483443949036"
OpenBtn.Visible = false
OpenBtn.AutoButtonColor = true

MinBtn.MouseButton1Click:Connect(function()
    Fundo.Visible = false
    OpenBtn.Visible = true
end)

OpenBtn.MouseButton1Click:Connect(function()
    Fundo.Visible = true
    OpenBtn.Visible = false
end)

-- ESP
local espEnabled = false
local espPlayers = {}

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
local espButton = Instance.new("TextButton")
espButton.Name = "ESPButton"
espButton.Parent = bar
espButton.BackgroundColor3 = Color3.fromRGB(85, 255, 0)
espButton.BorderSizePixel = 0
espButton.Position = UDim2.new(0.2027, 0, 0.1854, 0)
espButton.Size = UDim2.new(0, 230, 0, 39)
espButton.Font = Enum.Font.Arial
espButton.Text = "ESP PLAYER"
espButton.TextColor3 = Color3.fromRGB(0, 0, 0)
espButton.TextSize = 18
espButton.TextWrapped = true

local btnUICorner = Instance.new("UICorner")
btnUICorner.CornerRadius = UDim.new(0, 12)
btnUICorner.Parent = espButton

local grad = Instance.new("UIGradient")
grad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(142, 158, 171)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(238, 242, 243))
}
grad.Rotation = -90
grad.Parent = espButton

espButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    
    if espEnabled then
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player then
                createESP(plr)
            end
        end
        espButton.Text = "ESP PLAYER (ON)"
        espButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    else
        for _, plr in pairs(Players:GetPlayers()) do
            removeESP(plr)
        end
        espButton.Text = "ESP PLAYER"
        espButton.BackgroundColor3 = Color3.fromRGB(85, 255, 0)
    end
end)

-- ESP Connections
Players.PlayerAdded:Connect(function(plr)
    if espEnabled then
        plr.CharacterAdded:Connect(function(char)
            createESP(plr)
        end)
    end
end)

for _, plr in pairs(Players:GetPlayers()) do
    if plr ~= player and espEnabled then
        plr.CharacterAdded:Connect(function(char)
            createESP(plr)
        end)
    end
end

Players.PlayerRemoving:Connect(function(plr)
    removeESP(plr)
end)

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

