-- Emerald Hub (Mobile + ESP + Steal + Ragdoll fix + StealHub GUI) – por sunav7
local Players = game:GetService("Players")
local UIS     = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player  = Players.LocalPlayer

-------------------------------------------------- GUI -------
local main = Instance.new("ScreenGui")
main.Name = "main"
main.Parent = player:WaitForChild("PlayerGui")
main.ResetOnSpawn = false
main.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local Fundo = Instance.new("Frame")
Fundo.Name = "Fundo"
Fundo.Parent = main
Fundo.ZIndex = 1
Fundo.BackgroundColor3 = Color3.fromRGB(52,52,52)
Fundo.BorderSizePixel  = 0
Fundo.Position         = UDim2.fromScale(.2937,.3035)
Fundo.Size             = UDim2.new(0,370,0,205)
Instance.new("UICorner",Fundo).CornerRadius = UDim.new(0,16)

local Shadow = Instance.new("Frame")
Shadow.Name = "Shadow"
Shadow.Parent = Fundo
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
bar.Name = "bar"
bar.Parent = Fundo
bar.ZIndex = 2
bar.BackgroundTransparency = 1
bar.Size = UDim2.fromScale(1,1)
bar.Active = true
bar.Selectable = true

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

-------------------------------------------------- Minimizar -
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

-------------------------------------------------- Botão STEAL --
local function mkBtn(text, yPos)
    local b = Instance.new("TextButton", bar)
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
    return b
end

local stealBtn = mkBtn("STEAL", .6)
stealBtn.MouseButton1Click:Connect(function()
    local stealGui = Instance.new("ScreenGui")
    stealGui.Name = "StealHub"
    stealGui.Parent = player:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame", stealGui)
    frame.BackgroundColor3 = Color3.fromRGB(52,52,52)
    frame.Size = UDim2.new(0, 300, 0, 160)
    frame.Position = UDim2.fromScale(0.35, 0.35)
    frame.ZIndex = 10
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)

    local savedCFrame = nil

    local setBtn = Instance.new("TextButton", frame)
    setBtn.Size = UDim2.new(0, 240, 0, 40)
    setBtn.Position = UDim2.new(0, 30, 0, 30)
    setBtn.Text = "SET PLOT"
    setBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 127)
    Instance.new("UICorner", setBtn)

    local goBtn = Instance.new("TextButton", frame)
    goBtn.Size = UDim2.new(0, 240, 0, 40)
    goBtn.Position = UDim2.new(0, 30, 0, 90)
    goBtn.Text = "STEAL!"
    goBtn.BackgroundColor3 = Color3.fromRGB(255, 85, 0)
    Instance.new("UICorner", goBtn)

    setBtn.MouseButton1Click:Connect(function()
        local char = player.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            savedCFrame = char.HumanoidRootPart.CFrame
            setBtn.Text = "PLOT DEFINIDO"
        end
    end)

    goBtn.MouseButton1Click:Connect(function()
        local char = player.Character
        if not (char and savedCFrame) then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local target1 = hrp.CFrame + Vector3.new(0, 200, 0)
        local tween1 = TweenService:Create(hrp, TweenInfo.new(1, Enum.EasingStyle.Quad), {CFrame = target1})
        tween1:Play()
        tween1.Completed:Wait()

        task.wait(0.5)

        local tween2 = TweenService:Create(hrp, TweenInfo.new(1, Enum.EasingStyle.Quad), {CFrame = savedCFrame})
        tween2:Play()
    end)
end)

-------------------------------------------------- Créditos ---
local cred = Instance.new("TextLabel", bar)
cred.BackgroundTransparency = 1
cred.Position = UDim2.new(.42,0,.8976,0)
cred.Size = UDim2.fromOffset(65,12)
cred.Font = Enum.Font.SourceSansBold
cred.Text = "By: sunav7"
cred.TextSize = 14
cred.TextColor3 = Color3.new()
cred.ZIndex = 3
