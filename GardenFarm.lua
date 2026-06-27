-- ============================================
-- GROW A GARDEN 2 - AUTO FARM
-- ИСПРАВЛЕННАЯ ВЕРСИЯ
-- ============================================

-- Проверка на повторный запуск
if _G.GardenFarm then
    _G.GardenFarm:Destroy()
end

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui")
local frame = Instance.new("Frame")
local title = Instance.new("TextLabel")
local harvestBtn = Instance.new("TextButton")
local sellBtn = Instance.new("TextButton")
local plantBtn = Instance.new("TextButton")
local closeBtn = Instance.new("TextButton")

-- Создаём GUI
gui.Parent = player:WaitForChild("PlayerGui")
gui.Name = "GardenFarm"
_G.GardenFarm = gui

frame.Parent = gui
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
frame.BorderSizePixel = 0
frame.Position = UDim2.new(0.5, -120, 0.4, 0)
frame.Size = UDim2.new(0, 240, 0, 200)
frame.Active = true
frame.Draggable = true
frame.ClipsDescendants = true

-- Заголовок
title.Parent = frame
title.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
title.Size = UDim2.new(1, 0, 0, 35)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "🌱 GARDEN FARM"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextScaled = true

-- Функция создания кнопок
local function makeBtn(text, y, color)
    local btn = Instance.new("TextButton")
    btn.Parent = frame
    btn.BackgroundColor3 = color
    btn.Size = UDim2.new(0.8, 0, 0, 35)
    btn.Position = UDim2.new(0.1, 0, 0, y)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.BorderSizePixel = 0
    return btn
end

harvestBtn = makeBtn("СОБРАТЬ", 45, Color3.fromRGB(0, 150, 0))
sellBtn = makeBtn("ПРОДАТЬ", 90, Color3.fromRGB(0, 130, 200))
plantBtn = makeBtn("ПОСАДИТЬ", 135, Color3.fromRGB(180, 130, 0))

-- Кнопка закрыть
closeBtn.Parent = frame
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40)
closeBtn.Size = UDim2.new(0.2, 0, 0, 30)
closeBtn.Position = UDim2.new(0.8, 0, 0, 2)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.BorderSizePixel = 0

-- Переменные состояния
local harvestOn = true
local sellOn = true
local plantOn = true

-- Функция поиска кнопок в игре
local function findButton(...)
    local texts = {...}
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("TextButton") or v:IsA("ImageButton") then
            if v.Visible and v.Active then
                local text = v.Text or ""
                for _, search in ipairs(texts) do
                    if string.find(string.lower(text), string.lower(search)) then
                        return v
                    end
                end
            end
        end
    end
    return nil
end

-- Функции действий
local function doHarvest()
    local btn = findButton("собрать", "harvest", "collect", "сбор")
    if btn then
        pcall(function()
            btn:Click()
            fireclickdetector(btn)
        end)
        return true
    end
    return false
end

local function doSell()
    local btn = findButton("продать", "sell")
    if btn then
        pcall(function()
            btn:Click()
            fireclickdetector(btn)
        end)
        return true
    end
    return false
end

local function doPlant()
    local btn = findButton("посадить", "plant", "seed")
    if btn then
        pcall(function()
            btn:Click()
            fireclickdetector(btn)
        end)
        return true
    end
    return false
end

-- Обновление кнопок
local function updateButtons()
    harvestBtn.BackgroundColor3 = harvestOn and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(80, 0, 0)
    harvestBtn.Text = harvestOn and "СОБРАТЬ" or "ВЫКЛ"
    
    sellBtn.BackgroundColor3 = sellOn and Color3.fromRGB(0, 130, 200) or Color3.fromRGB(80, 0, 0)
    sellBtn.Text = sellOn and "ПРОДАТЬ" or "ВЫКЛ"
    
    plantBtn.BackgroundColor3 = plantOn and Color3.fromRGB(180, 130, 0) or Color3.fromRGB(80, 0, 0)
    plantBtn.Text = plantOn and "ПОСАДИТЬ" or "ВЫКЛ"
end

-- Обработчики кнопок
harvestBtn.MouseButton1Click:Connect(function()
    harvestOn = not harvestOn
    updateButtons()
end)

sellBtn.MouseButton1Click:Connect(function()
    sellOn = not sellOn
    updateButtons()
end)

plantBtn.MouseButton1Click:Connect(function()
    plantOn = not plantOn
    updateButtons()
end)

closeBtn.MouseButton1Click:Connect(function()
    gui:Destroy()
    _G.GardenFarm = nil
end)

-- Главный цикл
spawn(function()
    while gui and gui.Parent do
        wait(1)
        if harvestOn then
            doHarvest()
        end
        if sellOn then
            doSell()
        end
        if plantOn then
            doPlant()
        end
    end
end)

print("✅ Garden Farm запущен!")
updateButtons()
