local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer or Players.PlayerAdded:Wait()
local PlayerGui = player:WaitForChild("PlayerGui")

-- Espera o personagem e HumanoidRootPart carregarem
local function waitForCharacter()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    return char, hrp
end

wait(1) -- espera extra para estabilidade

--------------------------------------------------
-- GUI --
--------------------------------------------------
local main = Instance.new("ScreenGui")
main.Name = "main"
main.Parent = PlayerGui
main.ResetOnSpawn = false
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Fundo = Instance.new("Frame")
Fundo.Name = "Fundo"
Fundo.Parent = main
Fundo.ZIndex = 1
Fundo.BackgroundColor3 = Color3.fromRGB(52,52,52)
Fundo.BorderSizePixel = 0
Fundo.Position = UDim2.fromScale(.2937,.3035)
Fundo.Size = UDim2.new(0,370,0,205)
Instance.new("UICorner",Fundo).CornerRadius = UDim.new(0,16)

local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.Parent = Fundo
Shadow.AnchorPoint = Vector2.new(.5,.5)
Shadow.Position = UDim2.fromScale(.5,.5)
Shadow.Size = UDim2.new(1,8,1,8)
Shadow.BackgroundColor3 = Color3.new()
Shadow.BackgroundTransparency = .7
Shadow.BorderSizePixel = 0
Shadow.ZIndex = 0
Instance.new("UICorner",Shadow).CornerRadius = UDim.new(0,16)

--------------------------------------------------
-- Drag --
--------------------------------------------------
local bar = Instance.new("Frame")
bar.Name = "bar"
bar.Parent = Fundo
bar.ZIndex = 2
bar.BackgroundTransparency = 1
bar.Size = UDim2.fromScale(1,1)
bar.Active = true
bar.Selectable = true

local dragging, dragStart, startPos
local function beginDrag(input)
    dragging = true
    dragStart = input.Position
    startPos = Fundo.Position
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

--------------------------------------------------
-- Título --
--------------------------------------------------
local TitleFrame = Instance.new("Frame",bar)
TitleFrame.BackgroundTransparency = 1
TitleFrame.Size = UDim2.new(1,0,0,28)
TitleFrame.Position = UDim2.fromScale(0,.025)
TitleFrame.ZIndex = 3
local UIL = Instance.new("UIListLayout",TitleFrame)
UIL.FillDirection = Enum.FillDirection.Horizontal
UIL.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIL.VerticalAlignment = Enum.VerticalAlignment.Center
UIL.Padding = UDim.new(0,6)

local img = Instance.new("ImageLabel",TitleFrame)
img.BackgroundTransparency = 1
img.Size = UDim2.fromOffset(23,23)
img.Image = "rbxassetid://117483443949036"
img.ZIndex = 4

local txt = Instance.new("TextLabel",TitleFrame)
txt.BackgroundTransparency = 1
txt.Size = UDim2.fromOffset(140,23)
txt.Font = Enum.Font.ArialBold
txt.Text = "Emerald Hub"
txt.TextColor3 = Color3.new(1,1,1)
txt.TextScaled = true
txt.TextWrapped = true
txt.ZIndex = 4

--------------------------------------------------
-- Minimizar --
--------------------------------------------------
local function imgBtn(parent,name,pos,id,z)
    local b = Instance.new("ImageButton",parent)
    b.Name = name
    b.Size = UDim2.fromOffset(22,22)
    b.Position = pos
    b.BackgroundTransparency = 1
    b.Image = "rbxassetid://"..id
    b.ZIndex = z
    return b
end
local MinBtn  = imgBtn(bar, "MinBtn",  UDim2.new(1,-30,0,6), 10734895698,5)
local OpenBtn = imgBtn(main,"OpenBtn", UDim2.new(0,16,1,-52),117483443949036,10)
OpenBtn.Size = UDim2.fromOffset(36,36)
OpenBtn.Visible = false

MinBtn.MouseButton1Click:Connect(function()
    Fundo.Visible = false
    OpenBtn.Visible = true
end)
OpenBtn.MouseButton1Click:Connect(function()
    Fundo.Visible = true
    OpenBtn.Visible = false
end)

--------------------------------------------------
-- Função Btn --
--------------------------------------------------
local function mkBtn(text, yPos)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,230,0,39)
    b.Position = UDim2.new(.2027,0,yPos,0)
    b.BackgroundColor3 = Color3.fromRGB(85,255,0)
    b.BorderSizePixel = 0
    b.Font = Enum.Font.Arial
    b.Text = text
    b.TextColor3 = Color3.new()
    b.TextSize = 18
    b.TextWrapped = true
    b.ZIndex = 3
    Instance.new("UICorner",b).CornerRadius = UDim.new(0,12)
    local g = Instance.new("UIGradient", b)
    g.Color = ColorSequence.new(Color3.fromRGB(142,158,171), Color3.fromRGB(238,242,243))
    g.Rotation = -90
    return b
end

--------------------------------------------------
-- STEAL GUI --
--------------------------------------------------
local stealBtn = mkBtn("STEAL", .61)
stealBtn.Parent = bar
local savedCFrame = nil

stealBtn.MouseButton1Click:Connect(function()
    local hubGui = Instance.new("ScreenGui")
    hubGui.Name = "StealGui"
    hubGui.Parent = PlayerGui
    hubGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    local frame = Fundo:Clone()
    frame.Parent = hubGui
    frame.Position = UDim2.new(0.35, 0, 0.4, 0)
    frame.Size = UDim2.new(0, 370, 0, 150)

    local setBtn = mkBtn("SET PLOT", 0.35)
    setBtn.Parent = frame
    local tpBtn = mkBtn("STEAL", 0.6)
    tpBtn.Parent = frame

    setBtn.MouseButton1Click:Connect(function()
        local char, hrp = waitForCharacter()
        if hrp then
            savedCFrame = hrp.CFrame
            setBtn.Text = "PLOT SALVO"
        end
    end)

    tpBtn.MouseButton1Click:Connect(function()
        local char, hrp = waitForCharacter()
        if hrp and savedCFrame then
            local tween1 = TweenService:Create(hrp, TweenInfo.new(1), {CFrame = hrp.CFrame + Vector3.new(0, 200, 0)})
            local tween2 = TweenService:Create(hrp, TweenInfo.new(1), {CFrame = savedCFrame})
            tween1:Play()
            tween1.Completed:Wait()
            tween2:Play()
        end
    end)
end)

--------------------------------------------------
-- Créditos --
--------------------------------------------------
local cred=Instance.new("TextLabel",bar)
cred.BackgroundTransparency=1
cred.Position=UDim2.new(.42,0,.8976,0)
cred.Size=UDim2.fromOffset(65,12)
cred.Font=Enum.Font.SourceSansBold
cred.Text="By: sunav7"
cred.TextSize=14
cred.TextColor3 = Color3.new()
cred.ZIndex=3
