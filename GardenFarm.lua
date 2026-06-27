local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local AutoHarvestBtn = Instance.new("TextButton")
local AutoSellBtn = Instance.new("TextButton")
local AutoPlantBtn = Instance.new("TextButton")
local CloseBtn = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "GardenGUI"

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
MainFrame.BorderSizePixel = 0
MainFrame.Position = UDim2.new(0.5, -130, 0.3, 0)
MainFrame.Size = UDim2.new(0, 260, 0, 220)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "🌱 GARDEN FARM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16

local function createButton(text, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = color
    btn.Size = UDim2.new(0.85, 0, 0, 35)
    btn.Position = UDim2.new(0.075, 0, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    return btn
end

AutoHarvestBtn = createButton("СОБРАТЬ", 45, Color3.fromRGB(0, 150, 0))
AutoSellBtn = createButton("ПРОДАТЬ", 90, Color3.fromRGB(0, 130, 200))
AutoPlantBtn = createButton("ПОСАДИТЬ", 135, Color3.fromRGB(180, 130, 0))

CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
CloseBtn.Size = UDim2.new(0.15, 0, 0, 25)
CloseBtn.Position = UDim2.new(0.85, 0, 0, 0)
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.BorderSizePixel = 0

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Works
