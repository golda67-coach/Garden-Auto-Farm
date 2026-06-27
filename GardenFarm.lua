-- ============================================
-- ПРОСТОЙ АВТО-КЛИКЕР ДЛЯ GARDEN
-- ============================================

local player = game.Players.LocalPlayer

-- Создаём GUI
local gui = Instance.new("ScreenGui")
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.new(0, 200, 0, 150)
frame.Position = UDim2.new(0.5, -100, 0.4, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

local title = Instance.new("TextLabel")
title.Parent = frame
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
title.Text = "🌱 FARM"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local btn = Instance.new("TextButton")
btn.Parent = frame
btn.Size = UDim2.new(0.8, 0, 0, 35)
btn.Position = UDim2.new(0.1, 0, 0, 40)
btn.BackgroundColor3 = Color3.fromRGB(0, 150, 0)
btn.Text = "ВКЛ"
btn.TextColor3 = Color3.fromRGB(255, 255, 255)
btn.Font = Enum.Font.GothamBold
btn.TextSize = 14
btn.BorderSizePixel = 0

local close = Instance.new("TextButton")
close.Parent = frame
close.Size = UDim2.new(0.15, 0, 0, 25)
close.Position = UDim2.new(0.85, 0, 0, 2)
close.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
close.Text = "X"
close.TextColor3 = Color3.fromRGB(255, 255, 255)
close.Font = Enum.Font.GothamBold
close.TextSize = 14
close.BorderSizePixel = 0

local running = true

btn.MouseButton1Click:Connect(function()
    running = not running
    btn.BackgroundColor3 = running and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 0, 0)
    btn.Text = running and "ВКЛ" or "ВЫКЛ"
end)

close.MouseButton1Click:Connect(function()
    gui:Destroy()
end)

-- Поиск и клик по кнопкам
spawn(function()
    while gui and gui.Parent do
        wait(1)
        if running then
            for _, v in pairs(game:GetDescendants()) do
                if v:IsA("TextButton") and v.Visible and v.Active then
                    local t = string.lower(v.Text or "")
                    if string.find(t, "собрать") or string.find(t, "harvest") or 
                       string.find(t, "продать") or string.find(t, "sell") or
                       string.find(t, "посадить") or string.find(t, "plant") then
                        pcall(function()
                            v:Click()
                            fireclickdetector(v)
                            wait(0.3)
                        end)
                    end
                end
            end
        end
    end
end)

print("✅ Запущено!")
