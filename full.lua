repeat wait() until game:IsLoaded()
local players = game:GetService("Players")
local player = players.LocalPlayer
repeat wait() until player:FindFirstChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LakizHub"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = player:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 260, 0, 320)
mainFrame.Position = UDim2.new(0.5, -130, 0.5, -160)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
mainFrame.BorderSizePixel = 3
mainFrame.BorderColor3 = Color3.fromRGB(150, 100, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local title = Instance.new("TextLabel")
title.Text = "Lakiz Hub"
title.Font = Enum.Font.GothamBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(200, 150, 255)
title.BackgroundTransparency = 1
title.Size = UDim2.new(1, 0, 0, 30)
title.Parent = mainFrame

local staminaButton = Instance.new("TextButton")
staminaButton.Size = UDim2.new(1, -20, 0, 35)
staminaButton.Position = UDim2.new(0, 10, 0, 40)
staminaButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
staminaButton.TextColor3 = Color3.fromRGB(255, 255, 255)
staminaButton.Font = Enum.Font.Gotham
staminaButton.TextSize = 16
staminaButton.Text = "[OFF] Infinite Stamina"
staminaButton.Parent = mainFrame

local pointsButton = Instance.new("TextButton")
pointsButton.Size = UDim2.new(1, -20, 0, 35)
pointsButton.Position = UDim2.new(0, 10, 0, 85)
pointsButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
pointsButton.TextColor3 = Color3.fromRGB(255, 255, 255)
pointsButton.Font = Enum.Font.Gotham
pointsButton.TextSize = 16
pointsButton.Text = "[OFF] Soon"
pointsButton.Parent = mainFrame

local moon = Instance.new("TextLabel")
moon.Text = "🌙"
moon.TextColor3 = Color3.fromRGB(255, 255, 255)
moon.Font = Enum.Font.Gotham
moon.TextSize = 20
moon.BackgroundTransparency = 1
moon.Size = UDim2.new(0, 30, 0, 30)
moon.Position = UDim2.new(1, -35, 1, -35)
moon.Parent = mainFrame

local infStamActive = false
local replicatedStorage = game:GetService("ReplicatedStorage")
local lightsaberRemotes = replicatedStorage:WaitForChild("LightsaberRemotes")
local originalPosition: CFrame? = nil

staminaButton.MouseButton1Click:Connect(function()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        local root = character:FindFirstChild("HumanoidRootPart")

        if not infStamActive then
            originalPosition = root.CFrame -- salva ANTES de ligar
        else
            lightsaberRemotes:WaitForChild("Unequip"):FireServer()

            task.delay(0.5, function()
                if originalPosition then
                    root.CFrame = originalPosition + Vector3.new(0, 0.2, 0)
                end

                task.delay(0.5, function()
                    lightsaberRemotes:WaitForChild("Equip"):FireServer()
                end)
            end)
        end

        infStamActive = not infStamActive
        staminaButton.Text = infStamActive and "[ON] Infinite Stamina" or "[OFF] Infinite Stamina"
    end
end)

task.spawn(function()
    while true do
        if infStamActive then
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") and character:FindFirstChild("Humanoid").Health > 0 then
                lightsaberRemotes:WaitForChild("MouseDown"):FireServer()
                lightsaberRemotes:WaitForChild("Attack"):FireServer(3, 1, false, false)
                lightsaberRemotes:WaitForChild("MouseUp"):FireServer()
                lightsaberRemotes:WaitForChild("Swing"):FireServer()
                lightsaberRemotes:WaitForChild("OnHit"):FireServer(character)
                lightsaberRemotes:WaitForChild("FinishSwingNoBounce"):FireServer()
                lightsaberRemotes:WaitForChild("ResetSwingDirection"):FireServer()

                local root = character:FindFirstChild("HumanoidRootPart")
                if root then
                    root.CFrame = root.CFrame + Vector3.new(0, 900, 0)
                end
            end
        end
        task.wait(0.1)
    end
end)
