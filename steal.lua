-- Emerald Hub (Mobile + ESP + Steal + Ragdoll fix) – por sunav7
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
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

-------------------------------------------------- STEAL GUI --
local stealBtn = mkBtn("STEAL", .61)
local savedCFrame=nil
stealBtn.MouseButton1Click:Connect(function()
    local hubGui = Instance.new("ScreenGui")
    hubGui.Name = "StealGui"
    hubGui.Parent = player:WaitForChild("PlayerGui")
    hubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Instance.new("Frame")
    frame.Name = "Fundo"
    frame.Size = UDim2.new(0, 370, 0, 130)
    frame.Position = UDim2.new(0.35, 0, 0.4, 0)
    frame.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
    frame.Parent = hubGui
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 16)

    local title = Instance.new("TextLabel")
    title.Text = "Emerald Hub"
    title.Size = UDim2.new(1, 0, 0, 28)
    title.Position = UDim2.new(0, 0, 0, 0)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.ArialBold
    title.TextColor3 = Color3.new(1, 1, 1)
    title.TextScaled = true
    title.Parent = frame

    local icon = Instance.new("ImageLabel")
    icon.Size = UDim2.new(0, 23, 0, 23)
    icon.Position = UDim2.new(0, 10, 0, 2)
    icon.BackgroundTransparency = 1
    icon.Image = "rbxassetid://117483443949036"
    icon.Parent = frame

    local setBtn = mkBtn("SET PLOT", 0.3)
    setBtn.Parent = frame
    setBtn.Position = UDim2.new(0.2, 0, 0.35, 0)

    local tpBtn = mkBtn("STEAL", 0.6)
    tpBtn.Parent = frame
    tpBtn.Position = UDim2.new(0.2, 0, 0.65, 0)

    setBtn.MouseButton1Click:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            savedCFrame = char.HumanoidRootPart.CFrame
            setBtn.Text = "PLOT SALVO"
        end
    end)

    tpBtn.MouseButton1Click:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") and savedCFrame then
            local hrp = char.HumanoidRootPart
            local tween1 = TweenService:Create(hrp, TweenInfo.new(1), {CFrame = hrp.CFrame + Vector3.new(0, 200, 0)})
            local tween2 = TweenService:Create(hrp, TweenInfo.new(1), {CFrame = savedCFrame})
            tween1:Play()
            tween1.Completed:Wait()
            tween2:Play()
        end
    end)
end)

-------------------------------------------------- Créditos ---
local cred=Instance.new("TextLabel",bar)
cred.BackgroundTransparency=1;cred.Position=UDim2.new(.42,0,.8976,0);cred.Size=UDim2.fromOffset(65,12)
cred.Font=Enum.Font.SourceSansBold;cred.Text="By: sunav7";cred.TextSize=14;cred.TextColor3=Color3.new();cred.ZIndex=3
