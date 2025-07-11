-- Emerald Hub (Mobile + ESP + Steal + Ragdoll fix) – por sunav7
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local player  = Players.LocalPlayer

-------------------------------------------------- GUI -------
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
Shadow.BackgroundColor3      = Color3.new()
Shadow.BackgroundTransparency = .7
Shadow.BorderSizePixel        = 0
Shadow.ZIndex                = 0
Instance.new("UICorner",Shadow).CornerRadius = UDim.new(0,16)

-------------------------------------------------- Drag ------
local bar = Instance.new("Frame")
bar.Name, bar.Parent, bar.ZIndex = "bar", Fundo, 2
bar.BackgroundTransparency, bar.Size = 1, UDim2.fromScale(1,1)
bar.Active, bar.Selectable = true, true

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

-------------------------------------------------- Título ----
local TitleFrame = Instance.new("Frame",bar)
TitleFrame.BackgroundTransparency, TitleFrame.Size = 1, UDim2.new(1,0,0,28)
TitleFrame.Position, TitleFrame.ZIndex = UDim2.fromScale(0,.025), 3
local UIL = Instance.new("UIListLayout",TitleFrame)
UIL.FillDirection = Enum.FillDirection.Horizontal
UIL.HorizontalAlignment, UIL.VerticalAlignment = Enum.HorizontalAlignment.Center, Enum.VerticalAlignment.Center
UIL.Padding = UDim.new(0,6)

local img = Instance.new("ImageLabel",TitleFrame)
img.BackgroundTransparency, img.Size, img.Image, img.ZIndex = 1, UDim2.fromOffset(23,23),
    "rbxassetid://117483443949036",4

local txt = Instance.new("TextLabel",TitleFrame)
txt.BackgroundTransparency, txt.Size = 1, UDim2.fromOffset(140,23)
txt.Font, txt.Text = Enum.Font.ArialBold, "Emerald Hub"
txt.TextColor3, txt.TextScaled, txt.TextWrapped, txt.ZIndex = Color3.new(1,1,1), true, true, 4

-------------------------------------------------- Minimizar -
local function imgBtn(parent,name,pos,id,z)
    local b = Instance.new("ImageButton",parent)
    b.Name, b.Size, b.Position = name, UDim2.fromOffset(22,22), pos
    b.BackgroundTransparency, b.Image, b.ZIndex = 1, "rbxassetid://"..id, z
    return b
end
local MinBtn  = imgBtn(bar, "MinBtn",  UDim2.new(1,-30,0,6), 10734895698,5)
local OpenBtn = imgBtn(main,"OpenBtn", UDim2.new(0,16,1,-52),117483443949036,10)
OpenBtn.Size, OpenBtn.Visible = UDim2.fromOffset(36,36), false

MinBtn.MouseButton1Click:Connect(function() Fundo.Visible,OpenBtn.Visible=false,true end)
OpenBtn.MouseButton1Click:Connect(function() Fundo.Visible,OpenBtn.Visible=true,false end)

-------------------------------------------------- Função Btn -
local function mkBtn(text, yPos)
    local b = Instance.new("TextButton", bar)
    b.Size = UDim2.new(0,230,0,39)
    b.Position = UDim2.new(.2027,0,yPos,0)
    b.BackgroundColor3 = Color3.fromRGB(85,255,0)
    b.BorderSizePixel, b.Font = 0, Enum.Font.Arial
    b.Text, b.TextColor3, b.TextSize, b.TextWrapped, b.ZIndex = text, Color3.new(), 18, true, 3
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,12)
    local g = Instance.new("UIGradient", b)
    g.Color = ColorSequence.new(Color3.fromRGB(142,158,171), Color3.fromRGB(238,242,243))
    g.Rotation = -90
    return b
end

-------------------------------------------------- ESP --------
local espEnabled=false
local espRefs={}
local function attach(plr)
    if espRefs[plr] or not plr.Character then return end
    local h=Instance.new("Highlight")
    h.Name="ESP";h.FillColor=Color3.fromRGB(85,255,0);h.OutlineColor=Color3.new(1,1,1)
    h.FillTransparency=.3;h.OutlineTransparency=0;h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent=plr.Character;espRefs[plr]=h
end
local function detach(plr) if espRefs[plr] then espRefs[plr]:Destroy();espRefs[plr]=nil end end
local function toggleESP()
    espEnabled=not espEnabled
    for _,p in ipairs(Players:GetPlayers()) do if p~=player then
        if espEnabled then attach(p) else detach(p) end end end
end

local espBtn=mkBtn("ESP PLAYER",.18)
espBtn.MouseButton1Click:Connect(function()
    toggleESP()
    espBtn.Text = espEnabled and "ESP PLAYER (ON)" or "ESP PLAYER"
    espBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(255,100,100) or Color3.fromRGB(85,255,0)
end)

Players.PlayerAdded:Connect(function(p) p.CharacterAdded:Connect(function()
    if espEnabled and p~=player then wait(.1);attach(p) end end) end)
for _,p in ipairs(Players:GetPlayers()) do p.CharacterAdded:Connect(function()
    if espEnabled and p~=player then wait(.1);attach(p) end end) end
Players.PlayerRemoving:Connect(detach)

-------------------------------------------------- Ragdoll ----
local ragBtn = mkBtn("REMOVER MEU RAGDOLL", .4)
ragBtn.MouseButton1Click:Connect(function()
    local char=workspace:FindFirstChild(player.Name)
    if char then
        local rag=char:FindFirstChild("RagdollClient")
        local hum=char:FindFirstChildWhichIsA("Humanoid")
        if rag then rag:Destroy() end
        if hum then hum.PlatformStand=false;hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
        ragBtn.Text="RAGDOLL REMOVIDO";ragBtn.BackgroundColor3=Color3.fromRGB(255,100,100)
    end
end)

-------------------------------------------------- STEAL ------
local stealBtn = mkBtn("STEAL", .61)
local savedCFrame=nil
stealBtn.MouseButton1Click:Connect(function()
    local char=player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local hrp=char.HumanoidRootPart
        savedCFrame=hrp.CFrame
        hrp.CFrame=hrp.CFrame+Vector3.new(0,200,0)
        delay(2,function() if savedCFrame then hrp.CFrame=savedCFrame end end)
    end
end)

-------------------------------------------------- Créditos ---
local cred=Instance.new("TextLabel",bar)
cred.BackgroundTransparency=1;cred.Position=UDim2.new(.42,0,.8976,0);cred.Size=UDim2.fromOffset(65,12)
cred.Font=Enum.Font.SourceSansBold;cred.Text="By: sunav7";cred.TextSize=14;cred.TextColor3=Color3.new();cred.ZIndex=3
