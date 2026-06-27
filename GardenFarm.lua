-- ============================================
-- GROW A GARDEN 2 - AUTO FARM SCRIPT v1.0
-- Для Xeno Executor
-- ============================================

-- Создаем GUI
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local AutoHarvestBtn = Instance.new("TextButton")
local AutoSellBtn = Instance.new("TextButton")
local AutoPlantBtn = Instance.new("TextButton")
local StatusLabel = Instance.new("TextLabel")
local CloseBtn = Instance.new("TextButton")

-- Настройки GUI
ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.Name = "GardenGUI"

MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(100, 200, 100)
MainFrame.Position = UDim2.new(0.5, -150, 0.3, 0)
MainFrame.Size = UDim2.new(0, 300, 0, 350)
MainFrame.Active = true
MainFrame.Draggable = true

Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.Text = "🌱 Garden Auto Farm"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 18

-- Кнопки
local function createButton(text, yPos, color)
    local btn = Instance.new("TextButton")
    btn.Parent = MainFrame
    btn.BackgroundColor3 = color
    btn.Size = UDim2.new(0.8, 0, 0, 40)
    btn.Position = UDim2.new(0.1, 0, 0, yPos)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.BackgroundTransparency = 0.1
    return btn
end

AutoHarvestBtn = createButton("🌾 Авто-Сбор (Вкл)", 50, Color3.fromRGB(0, 150, 0))
AutoSellBtn = createButton("💰 Авто-Продажа (Вкл)", 110, Color3.fromRGB(0, 150, 200))
AutoPlantBtn = createButton("🌱 Авто-Посадка (Вкл)", 170, Color3.fromRGB(150, 150, 0))

-- Статус
StatusLabel.Parent = MainFrame
StatusLabel.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
StatusLabel.Size = UDim2.new(0.9, 0, 0, 50)
StatusLabel.Position = UDim2.new(0.05, 0, 0, 230)
StatusLabel.Text = "Статус: Ожидание..."
StatusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.TextSize = 14
StatusLabel.TextWrapped = true

-- Кнопка закрыть
CloseBtn.Parent = MainFrame
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.Size = UDim2.new(0.2, 0, 0, 30)
CloseBtn.Position = UDim2.new(0.8, 0, 0, 0)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0

-- ============================================
-- ОСНОВНАЯ ЛОГИКА СКРИПТА
-- ============================================

local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")

local isHarvesting = true
local isSelling = true
local isPlanting = true

-- Функция для поиска кнопок в игре
local function findButton(texts)
    for _, text in ipairs(texts) do
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("TextButton") or v:IsA("ImageButton") then
                if v.Visible and v.Active then
                    local btnText = v.Text or ""
                    if string.lower(btnText):find(string.lower(text)) then
                        return v
                    end
                end
            end
        end
    end
    return nil
end

-- Функция для сбора урожая
local function harvest()
    local harvestBtn = findButton({"собрать", "harvest", "collect", "сбор"})
    if harvestBtn then
        if harvestBtn.Visible and harvestBtn.Active then
            StatusLabel.Text = "🌾 Собираем урожай..."
            fireclickdetector(harvestBtn)
            -- Альтернативный способ клика
            harvestBtn:Click()
            return true
        end
    end
    return false
end

-- Функция для продажи
local function sell()
    local sellBtn = findButton({"продать", "sell", "продажа"})
    if sellBtn then
        if sellBtn.Visible and sellBtn.Active then
            StatusLabel.Text = "💰 Продаем урожай..."
            fireclickdetector(sellBtn)
            sellBtn:Click()
            return true
        end
    end
    return false
end

-- Функция для посадки
local function plant()
    local plantBtn = findButton({"посадить", "plant", "seed"})
    if plantBtn then
        if plantBtn.Visible and plantBtn.Active then
            StatusLabel.Text = "🌱 Сажаем семена..."
            fireclickdetector(plantBtn)
            plantBtn:Click()
            return true
        end
    end
    return false
end

-- Поиск объектов для взаимодействия
local function findInteractableObjects()
    local objects = {}
    for _, v in pairs(Workspace:GetDescendants()) do
        if v:IsA("Model") or v:IsA("Part") then
            if v.Name and string.lower(v.Name):find("plant") or string.lower(v.Name):find("crop") or string.lower(v.Name):find("garden") then
                table.insert(objects, v)
            end
        end
    end
    return objects
end

-- Tween для перемещения
local function moveTo(position)
    if not position then return end
    local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
    if hrp then
        hrp.CFrame = CFrame.new(position)
        wait(0.1)
    end
end

-- Основной цикл фарма
local function farmLoop()
    while wait(0.5) do
        if not isHarvesting and not isSelling and not isPlanting then
            StatusLabel.Text = "⏸ Приостановлен"
            wait(1)
            continue
        end

        -- Авто-сбор
        if isHarvesting then
            local success = harvest()
            if success then
                wait(0.3)
            end
        end

        -- Авто-продажа
        if isSelling then
            local success = sell()
            if success then
                wait(0.3)
            end
        end

        -- Авто-посадка
        if isPlanting then
            local success = plant()
            if success then
                wait(0.3)
            end
        end

        -- Поиск объектов поблизости
        if not harvest() and not sell() and not plant() then
            StatusLabel.Text = "🔍 Ищем урожай..."
            
            -- Попытка найти объекты и подойти к ним
            local objects = findInteractableObjects()
            if #objects > 0 then
                for _, obj in ipairs(objects) do
                    if obj:FindFirstChild("Position") then
                        moveTo(obj.Position.Value)
                        wait(0.5)
                        break
                    end
                end
            else
                StatusLabel.Text = "⏳ Ожидаем урожай..."
                wait(2)
            end
        end
    end
end

-- ============================================
-- УПРАВЛЕНИЕ КНОПКАМИ
-- ============================================

AutoHarvestBtn.MouseButton1Click:Connect(function()
    isHarvesting = not isHarvesting
    AutoHarvestBtn.BackgroundColor3 = isHarvesting and Color3.fromRGB(0, 150, 0) or Color3.fromRGB(100, 0, 0)
    AutoHarvestBtn.Text = isHarvesting and "🌾 Авто-Сбор (Вкл)" or "🌾 Авто-Сбор (Выкл)"
    StatusLabel.Text = isHarvesting and "Сбор включен" or "Сбор выключен"
end)

AutoSellBtn.MouseButton1Click:Connect(function()
    isSelling = not isSelling
    AutoSellBtn.BackgroundColor3 = isSelling and Color3.fromRGB(0, 150, 200) or Color3.fromRGB(100, 0, 0)
    AutoSellBtn.Text = isSelling and "💰 Авто-Продажа (Вкл)" or "💰 Авто-Продажа (Выкл)"
    StatusLabel.Text = isSelling and "Продажа включена" or "Продажа выключена"
end)

AutoPlantBtn.MouseButton1Click:Connect(function()
    isPlanting = not isPlanting
    AutoPlantBtn.BackgroundColor3 = isPlanting and Color3.fromRGB(150, 150, 0) or Color3.fromRGB(100, 0, 0)
    AutoPlantBtn.Text = isPlanting and "🌱 Авто-Посадка (Вкл)" or "🌱 Авто-Посадка (Выкл)"
    StatusLabel.Text = isPlanting and "Посадка включена" or "Посадка выключена"
end)

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
    StatusLabel.Text = "Скрипт остановлен"
end)

-- ============================================
-- ЗАПУСК
-- ============================================

StatusLabel.Text = "✅ Скрипт запущен!"
wait(0.5)

-- Запускаем фарм в отдельном потоке
spawn(farmLoop)

-- Дополнительная функция для автоматической игры
game:GetService("VirtualUser"):CaptureController()
game:GetService("VirtualUser"):ClickButton2(Vector2.new())

print("🌱 Grow a Garden 2 - Auto Farm Script загружен!")
print("Настройки в меню скрипта")
