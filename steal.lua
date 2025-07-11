-- Emerald Hub (Mobile + ESP + Steal + Ragdoll fix) – por sunav7

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local player = Players.LocalPlayer

--== GUI =======================================================
local main = Instance.new("ScreenGui")
main.Name, main.Parent, main.ResetOnSpawn = "main", player:WaitForChild("PlayerGui"), false
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Fundo = Instance.new("Frame")
Fundo.Name, Fundo.Parent, Fundo.ZIndex = "Fundo", main, 1
Fundo.BackgroundColor3 = Color3.fromRGB(52,52,52)
Fundo.BorderSizePixel  = 0
Fundo.Position         = UDim2.fromScale(.2937,.3035)
Fundo.Size             = UDim2.new(0,370,0,205)
Instance.new("UICorner",Fundo).CornerRadius = UDim.new(0,16)

local Shadow = Instance.new("Frame")
Shadow.Name, Shadow.Parent = "Shadow", Fundo
Shadow.AnchorPoint = Vector2.new(.5,.5)
Shadow.Position    = UDim2.fromScale(.5,.5)
Shadow.Size        = UDim2.new(1,8,1,8)
Shadow.BackgroundColor3 = Color3.new()
Shadow.BackgroundTransparency = .7
Shadow.BorderSizePixel = 0
Shadow.ZIndex = 0
Instance.new("UICorner",Shadow).CornerRadius = UDim.new(0,16)

-- camada clicável/draggable
local bar = Instance.new("Frame")
bar.Name, bar.Parent, bar.ZIndex = "bar", Fundo, 2
bar.BackgroundTransparency = 1
bar.Size = UDim2.fromScale(1,1)
bar.Active, bar.Selectable = true, true

--============  DRAG (Mobile) ==========================
local dragging, dragStart, startPos
local function beginDrag(input)
    dragging, dragStart, startPos = true, input.Position, Fundo.Position
    input.Changed:Connect(function()
        if input.UserInputState == Enum.UserInputState.End then dragging = false end
    end)
end
bar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        beginDrag(input)
    end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input.UserInputType==Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        Fundo.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

--============  Título  =======================================
local TitleFrame = Instance.new("Frame",bar)
TitleFrame.BackgroundTransparency=1
TitleFrame.Size = UDim2.new(1,0,0,28)
TitleFrame.Position = UDim2.fromScale(0,0.025)
TitleFrame.ZIndex=3
local UIL = Instance.new("UIListLayout",TitleFrame)
UIL.FillDirection = Enum.FillDirection.Horizontal
UIL.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIL.VerticalAlignment = Enum.VerticalAlignment.Center
UIL.Padding = UDim.new(0,6)

local img = Instance.new("ImageLabel",TitleFrame)
img.BackgroundTransparency=1
img.Size = UDim2.fromOffset(23,23)
img.Image="rbxassetid://117483443949036"
img.ZIndex=4

local txt = Instance.new("TextLabel",TitleFrame)
txt.BackgroundTransparency = 1
txt.Size = UDim2.fromOffset(140,23)
txt.Font = Enum.Font.ArialBold
txt.Text = "Emerald Hub"
txt.TextColor3 = Color3.new(1,1,1)
txt.TextScaled, txt.TextWrapped, txt.ZIndex = true, true, 4

--============ Minimizar e Reabrir ==========================
local function makeImageBtn(parent, name, pos, id, z)
    local b = Instance.new("ImageButton",parent)
    b.Name, b.Size, b.Position = name, UDim2.fromOffset(22,22), pos
    b.BackgroundTransparency=1
    b.Image="rbxassetid://"..id
    b.ZIndex=z
    return b
end

local MinBtn = makeImageBtn(bar,"MinBtn", UDim2.new(1,-30,0,6), 10734895698,5)
local OpenBtn = makeImageBtn(main,"OpenBtn",UDim2.new(0,16,1,-52), 117483443949036,10)
OpenBtn.Size = UDim2.fromOffset(36,36)
OpenBtn.Visible=false

MinBtn.MouseButton1Click:Connect(function()
    Fundo.Visible, OpenBtn.Visible = false, true
end)
OpenBtn.MouseButton1Click:Connect(function()
    Fundo.Visible, OpenBtn.Visible = true, false
end)

--============  ESP ==========================================
local espEnabled=false
local espRefs = {}
local function attachESP(plr)
    if espRefs[plr] or not plr.Character then return end
    local h = Instance.new("Highlight")
    h.Name="PlayerESP"
    h.FillColor, h.OutlineColor = Color3.fromRGB(85,255,0), Color3.new(1,1,1)
    h.FillTransparency, h.OutlineTransparency = .3, 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = plr.Character
    espRefs[plr]=h
end
local function detachESP(plr)
    if espRefs[plr] then espRefs[plr]:Destroy(); espRefs[plr]=nil end
end
local function toggleESP()
    espEnabled = not espEnabled
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=player then
            if espEnabled then attachESP(p) else detachESP(p) end
        end
    end
end

-- Botão padrão com gradiente
local function makeBtn(text,posY)
    local b=Instance.new("TextButton",bar)
    b.Size = UDim2.new(0,230,0,39)
    b.Position = UDim2.new(.2027,0,posY,0)
    b.BackgroundColor3 = Color3.fromRGB(85,255,0)
    b.BorderSizePixel=0
    b.Font=Enum.Font.Arial
    b.Text=text
    b.TextColor3=Color3.new()
    b.TextSize=18
    b.TextWrapped=true
    b.ZIndex=3
    Instance.new("UICorner",b).CornerRadius=UDim.new(0,12)
    local grad = Instance.new("UIGradient", b)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(142,158,171)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(238,242,243))
    }
    grad.Rotation = -90
    return b
end

local espBtn = makeBtn("ESP PLAYER", .18)
espBtn.MouseButton1Click:Connect(function()
    toggleESP()
    espBtn.Text = espEnabled and "ESP PLAYER (ON)" or "ESP PLAYER"
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(255,100,100) or Color3.fromRGB(85,255,0)
end)

-- manter ESP se renascer
Players.PlayerAdded:Connect(function(p)
    p.CharacterAdded:Connect(function()
        if espEnabled and p~=player then task.wait(.1); attachESP(p) end
    end)
end)
for _,p in ipairs(Players:GetPlayers()) do
    p.CharacterAdded:Connect(function()
        if espEnabled and p~=player then task.wait(.1); attachESP(p) end
    end)
end
Players.PlayerRemoving:Connect(detachESP)

--============ Remover Ragdoll (com movimentação) =============
local RemoveBtn = makeBtn("REMOVER MEU RAGDOLL", 0.4)
RemoveBtn.MouseButton1Click:Connect(function()
    local char = workspace:FindFirstChild(player.Name)
    if char then
        local rag = char:FindFirstChild("RagdollClient")
        local hum = char:FindFirstChildWhichIsA("Humanoid")
        if rag then rag:Destroy() end
        if hum then
            hum.PlatformStand = false
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        RemoveBtn.Text = "RAGDOLL REMOVIDO"
        RemoveBtn.BackgroundColor3 = Color3.fromRGB(255,100,100)
    end
end)

--============ Botão STEAL (ir pro céu e voltar base) =========
local StealBtn = makeBtn("STEAL", 0.61)
local savedSpawnCFrame = nil
StealBtn.MouseButton1Click:Connect(function()
    local char = player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp = char.HumanoidRootPart
        savedSpawnCFrame = hrp.CFrame
        hrp.CFrame = hrp.CFrame + Vector3.new(0,200,0)
        task.delay(2, function()
            if savedSpawnCFrame then hrp.CFrame = savedSpawnCFrame end
        end)
    end
end)

--============ Créditos =======================================
local cred = Instance.new("TextLabel",bar)
cred.BackgroundTransparency=1
cred.Position = UDim2.new(.42,0,.8976,0)
cred.Size = UDim2.fromOffset(65,12)
cred.Font = Enum.Font.SourceSansBold
cred.Text = "By: sunav7"
cred.TextSize=14
cred.TextColor3 = Color3.new()
cred.ZIndex=3
