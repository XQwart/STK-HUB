local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Общие переменные и функции
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local MarketplaceService = game:GetService("MarketplaceService")

-- Переменные игрока
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Общие переменные для скриптов
local speeds = 1
local speeds2 = 1
local nowe = false 
local nowe2 = false

-- Добавляем новые переменные для автофарма после существующих переменных
local itemFarmEnabled = false
local STEP_SIZE = 15
local INVENTORY_GAMEPASS_ID = 14597778

-- Добавляем веса предметов
local ITEM_WEIGHTS = {
    ["Gold Coin"] = 1,
    ["Mysterious Arrow"] = 5,
    ["Lucky Arrow"] = 10,
    ["Pure Rokakaka"] = 7,
    ["Rokakaka"] = 3,
    ["Rib Cage of The Saint's Corpse"] = 6,
    ["Steel Ball"] = 4,
    ["Diamond"] = 5,
    ["Quinton's Glove"] = 4,
    ["Stone Mask"] = 4,
    ["Ancient Scroll"] = 4,
    ["Zeppeli's Hat"] = 4,
    ["Clackers"] = 4,
    ["Dio's Diary"] = 4,
    ["Caesar's Headband"] = 4,
    ["Christmas Present"] = 8
}

-- Добавляем лимиты предметов
local ITEM_LIMITS = {
    ["Gold Coin"] = 45,
    ["Mysterious Arrow"] = 25,
    ["Lucky Arrow"] = 10,
    ["Pure Rokakaka"] = 10,
    ["Rokakaka"] = 25,
    ["Rib Cage of The Saint's Corpse"] = 20,
    ["Steel Ball"] = 10,
    ["Diamond"] = 30,
    ["Quinton's Glove"] = 10,
    ["Stone Mask"] = 10,
    ["Ancient Scroll"] = 10,
    ["Zeppeli's Hat"] = 10,
    ["Clackers"] = 10,
    ["Dio's Diary"] = 10,
    ["Caesar's Headband"] = 10,
    ["Christmas Present"] = 10
}

-- Функция обновления персонажа
local function updateCharacter()
    character = player.Character
    if character then
        humanoid = character:WaitForChild("Humanoid")
        
        -- Обновляем состояния если они были активны
        if SpeedToggle and SpeedToggle.CurrentValue then
            SpeedToggle:Set(false)
            SpeedToggle:Set(true)
        end
        
        if FlyToggle and FlyToggle.CurrentValue then
            FlyToggle:Set(false)
            FlyToggle:Set(true)
        end
        
        if NoClipToggle and NoClipToggle.CurrentValue then
            NoClipToggle:Set(false)
            NoClipToggle:Set(true)
        end
        
        if JumpPowerToggle and JumpPowerToggle.CurrentValue then
            humanoid.UseJumpPower = false
            humanoid.JumpHeight = JumpHeightSlider.CurrentValue
        end
    end
end

-- Подключаем обработчик события появления персонажа
player.CharacterAdded:Connect(updateCharacter)

-- Вспомогательные функции
local function getTorso(char)
    return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
end

local function cleanupBodyMovers(torso)
    for _, v in pairs(torso:GetChildren()) do
        if v:IsA("BodyGyro") or v:IsA("BodyVelocity") then
            v:Destroy()
        end
    end
end

local function setHumanoidStates(humanoid, enabled)
    local states = {
        "Climbing", "FallingDown", "Flying", "Freefall", 
        "GettingUp", "Jumping", "Landed", "Physics",
        "PlatformStanding", "Ragdoll", "Running",
        "RunningNoPhysics", "Seated", "StrafingNoPhysics",
        "Swimming"
    }
    
    for _, state in ipairs(states) do
        humanoid:SetStateEnabled(Enum.HumanoidStateType[state], enabled)
    end
end

-- Создание окна
local Window = Rayfield:CreateWindow({
    Name = "STK Hub",
    Icon = 0,
    LoadingTitle = "STK Hub",
    LoadingSubtitle = "V 1.0.0",
    Theme = {
        TextColor = Color3.fromRGB(240, 240, 240),
        Background = Color3.fromRGB(25, 25, 25),
        Topbar = Color3.fromRGB(34, 34, 34),
        Shadow = Color3.fromRGB(20, 20, 20),
        
        NotificationBackground = Color3.fromRGB(20, 20, 20),
        NotificationActionsBackground = Color3.fromRGB(230, 230, 230),
        
        TabBackground = Color3.fromRGB(80, 80, 80),
        TabStroke = Color3.fromRGB(85, 85, 85),
        TabBackgroundSelected = Color3.fromRGB(255, 140, 0),
        TabTextColor = Color3.fromRGB(240, 240, 240),
        SelectedTabTextColor = Color3.fromRGB(50, 50, 50),
        
        ElementBackground = Color3.fromRGB(35, 35, 35),
        ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
        SecondaryElementBackground = Color3.fromRGB(25, 25, 25),
        ElementStroke = Color3.fromRGB(50, 50, 50),
        SecondaryElementStroke = Color3.fromRGB(40, 40, 40),
        
        SliderBackground = Color3.fromRGB(255, 140, 0),
        SliderProgress = Color3.fromRGB(255, 165, 0),
        SliderStroke = Color3.fromRGB(255, 180, 0),
        
        ToggleBackground = Color3.fromRGB(30, 30, 30),
        ToggleEnabled = Color3.fromRGB(255, 140, 0),
        ToggleDisabled = Color3.fromRGB(100, 100, 100),
        ToggleEnabledStroke = Color3.fromRGB(255, 165, 0),
        ToggleDisabledStroke = Color3.fromRGB(125, 125, 125),
        ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 100),
        ToggleDisabledOuterStroke = Color3.fromRGB(65, 65, 65),
        
        DropdownSelected = Color3.fromRGB(255, 140, 0),
        DropdownUnselected = Color3.fromRGB(30, 30, 30),
        
        InputBackground = Color3.fromRGB(30, 30, 30),
        InputStroke = Color3.fromRGB(65, 65, 65),
        PlaceholderColor = Color3.fromRGB(178, 178, 178)
    },
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "STK HUB"
    },
    
    Discord = {
        Enabled = true,
        Invite = "UdRgmCXW",
        RememberJoins = false
    },
    
    KeySystem = true,
    KeySettings = {
        Title = "STK HUB",
        Subtitle = "Key System",
        Note = "https://link-center.net/1273515/key-sript-password-day",
        FileName = "Key",
        SaveKey = true,
        GrabKeyFromSite = false,
        Key = {"55Ap%ySH1pheLHzK1Cc5@7{@105bbrnGm|3NZv|~EznOwkM*Wp0Y6CMVnJyBLs14"}
    }
})

-- Создание вкладок
local CharacterTab = Window:CreateTab("Character", 16346990319)
local ESPTab = Window:CreateTab("ESP", 12809023371)
local AutoFarmTab = Window:CreateTab("AutoFarm", 6947202399)
local MiscTab = Window:CreateTab("Misc", 10675474985)

-- Character Tab Elements
local SpeedToggle = CharacterTab:CreateToggle({
    Name = "Speed",
    CurrentValue = false,
    Flag = "ToggleSpeed", 
    Callback = function(Value)
        if Value and character then
            if FlyToggle and FlyToggle.CurrentValue then
                return -- Не включаем Speed если активен Fly
            end
            nowe2 = true
            local torso = getTorso(character)
            if torso then
                local bv = Instance.new("BodyVelocity", torso)
                bv.velocity = Vector3.new(0,0,0)
                bv.maxForce = Vector3.new(9e9, 0, 9e9)
                
                spawn(function()
                    while nowe2 and character and character.Parent do
                        wait()
                        if humanoid and humanoid.MoveDirection.Magnitude > 0 then
                            local moveDir = humanoid.MoveDirection
                            local yVel = bv.Velocity.Y
                            moveDir = Vector3.new(moveDir.X, yVel/50, moveDir.Z)
                            bv.velocity = moveDir * speeds2 * 50
                        else
                            local yVel = bv.Velocity.Y
                            bv.velocity = Vector3.new(0, yVel, 0)
                        end
                    end
                end)
            end
        else
            nowe2 = false
            if character then
                local torso = getTorso(character)
                if torso then
                    cleanupBodyMovers(torso)
                end
            end
        end
    end,
})

local SpeedSlider = CharacterTab:CreateSlider({
    Name = "Speed Value",
    Range = {1, 10},
    Increment = 1,
    Suffix = "x", 
    CurrentValue = 1,
    Flag = "SpeedSlider",
    Callback = function(Value)
        speeds2 = Value
    end,
})

local FlyToggle = CharacterTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "ToggleFly",
    Callback = function(Value)
        if Value and character then
            if SpeedToggle and SpeedToggle.CurrentValue then
                SpeedToggle:Set(false)
                wait() -- Даем время на обработку отключения
            end
            if InfiniteJumpToggle and InfiniteJumpToggle.CurrentValue then
                InfiniteJumpToggle:Set(false)
                wait() -- Даем время на обработку отключения
            end
            nowe = true
            character.Animate.Disabled = true
            
            for _, track in pairs(humanoid:GetPlayingAnimationTracks()) do
                track:Stop()
            end
            
            setHumanoidStates(humanoid, false)
            humanoid:ChangeState(Enum.HumanoidStateType.Swimming)
            humanoid.PlatformStand = true
            
            local torso = getTorso(character)
            if torso then
                local bg = Instance.new("BodyGyro", torso)
                bg.P = 9e4
                bg.maxTorque = Vector3.new(9e9, 9e9, 9e9)
                bg.cframe = torso.CFrame
                
                local bv = Instance.new("BodyVelocity", torso)
                bv.velocity = Vector3.new(0,0.1,0)
                bv.maxForce = Vector3.new(9e9, 9e9, 9e9)
                
                spawn(function()
                    while nowe and character and character.Parent do
                        wait()
                        if humanoid and humanoid.MoveDirection.Magnitude > 0 then
                            bv.velocity = humanoid.MoveDirection * speeds * 50
                        else
                            bv.velocity = Vector3.new(0,0.1,0)
                        end
                        bg.cframe = workspace.CurrentCamera.CFrame
                    end
                end)
            end
        else
            nowe = false
            if character then
                character.Animate.Disabled = false
                setHumanoidStates(humanoid, true)
                humanoid.PlatformStand = false
                
                local torso = getTorso(character)
                if torso then
                    cleanupBodyMovers(torso)
                end
            end
        end
    end,
})

local FlySpeedSlider = CharacterTab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 10},
    Increment = 1,
    Suffix = "x",
    CurrentValue = 1,
    Flag = "FlySpeedSlider", 
    Callback = function(Value)
        speeds = Value
    end,
})

local JumpPowerToggle = CharacterTab:CreateToggle({
    Name = "JumpPower", 
    CurrentValue = false,
    Flag = "ToggleJumpPower",
    Callback = function(Value)
        if character and humanoid then
            pcall(function()
                if Value then
                    humanoid.UseJumpPower = false
                    humanoid.JumpHeight = JumpHeightSlider.CurrentValue
                else
                    if not InfiniteJumpToggle.CurrentValue then
                        humanoid.UseJumpPower = true
                    end
                end
            end)
        end
    end,
})

local JumpHeightSlider = CharacterTab:CreateSlider({
    Name = "JumpHeight",
    Range = {7.2, 500},
    Increment = 0.1,
    Suffix = "Height", 
    CurrentValue = 7.2,
    Flag = "JumpHeightSlider",
    Callback = function(Value)
        if character and humanoid then
            pcall(function()
                if JumpPowerToggle.CurrentValue then
                    humanoid.JumpHeight = Value
                elseif not InfiniteJumpToggle.CurrentValue then
                    humanoid.JumpHeight = Value
                end
            end)
        end
    end,
})

local NoClipToggle = CharacterTab:CreateToggle({
    Name = "NoClip",
    CurrentValue = false,
    Flag = "NoClipHorizontalToggle", 
    Callback = function(Value)
        if Value then
            _G.NoClipConnection = RunService.Stepped:Connect(function()
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if _G.NoClipConnection then
                _G.NoClipConnection:Disconnect()
                _G.NoClipConnection = nil
            end
            
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = true
                    end
                end
            end
        end
    end,
})

local InfiniteJumpToggle = CharacterTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(Value)
        if Value then
            pcall(function()
                if character and humanoid then
                    humanoid.UseJumpPower = false
                    if JumpPowerToggle.CurrentValue then
                        humanoid.JumpHeight = JumpHeightSlider.CurrentValue
                    else
                        humanoid.JumpHeight = 7.2
                    end
                end
            end)
            _G.InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
                if character and humanoid then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            pcall(function()
                if character and humanoid then
                    if not JumpPowerToggle.CurrentValue then
                        humanoid.UseJumpPower = true
                        humanoid.JumpHeight = JumpHeightSlider.CurrentValue
                    end
                end
            end)
            if _G.InfiniteJumpConnection then
                _G.InfiniteJumpConnection:Disconnect()
                _G.InfiniteJumpConnection = nil
            end
        end
    end,
})

-- ESP Tab Functions and Elements
local function createBillboardGui(part)
    local existingBillboard = part:FindFirstChild("BillboardGui")
    if existingBillboard then
        existingBillboard:Destroy()
    end

    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Size = UDim2.new(0, 100, 0, 50)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = part

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.TextColor3 = Color3.new(1, 1, 1)
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.TextScaled = true
    textLabel.Parent = billboardGui
    
    return billboardGui
end

local ItemColors = {
    ["Gold Coin"] = Color3.fromRGB(255, 215, 0),
    ["Diamond"] = Color3.fromRGB(0, 247, 255),
    ["Rokakaka"] = Color3.fromRGB(255, 0, 0),
    ["Pure Rokakaka"] = Color3.fromRGB(219, 112, 147),
    ["Mysterious Arrow"] = Color3.fromRGB(255, 255, 153),
    ["Steel Ball"] = Color3.fromRGB(0, 255, 0)
}

local function getItemColor(itemName)
    local originalName = string.match(itemName, "[^:]+$") or itemName
    originalName = string.gsub(originalName, "^%s*(.-)%s*$", "%1")
    return ItemColors[originalName] or Color3.new(1, 1, 1)
end

local function isModelFullyLoaded(model)
    local allInvisible = true
    local hasMeshParts = false
    
    for _, part in ipairs(model:GetDescendants()) do
        if part:IsA("MeshPart") then
            hasMeshParts = true
            if part.Transparency < 1 then
                allInvisible = false
                break
            end
        end
    end
    
    return not (hasMeshParts and allInvisible)
end

local function handleModel(model)
    task.wait(0.1)
    
    if model:IsA("Model") then
        if not isModelFullyLoaded(model) then
            return
        end
        
        local part = model:FindFirstChildWhichIsA("BasePart") or model:WaitForChild("BasePart", 5)
        if part then
            local proximityPrompt = model:FindFirstChild("ProximityPrompt") or model:WaitForChild("ProximityPrompt", 5)
            if proximityPrompt then
                local billboardGui = createBillboardGui(part)
                local textLabel = billboardGui:FindFirstChild("TextLabel")
                if textLabel then
                    textLabel.Text = proximityPrompt.ObjectText
                    textLabel.TextColor3 = getItemColor(proximityPrompt.ObjectText)
                    
                    proximityPrompt:GetPropertyChangedSignal("ObjectText"):Connect(function()
                        textLabel.Text = proximityPrompt.ObjectText
                        textLabel.TextColor3 = getItemColor(proximityPrompt.ObjectText)
                    end)
                end
            end
        end
    end
end

local ESPToggle = ESPTab:CreateToggle({
    Name = "Item ESP",
    CurrentValue = false,
    Flag = "ESPToggle",
    Callback = function(Value)
        local itemsFolder = workspace.Item_Spawns.Items
        
        if Value then
            for _, model in pairs(itemsFolder:GetChildren()) do
                handleModel(model)
            end
            
            _G.ESPConnection1 = itemsFolder.ChildAdded:Connect(handleModel)
            _G.ESPConnection2 = itemsFolder.ChildRemoved:Connect(function(model)
                if model:IsA("Model") then
                    local part = model:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local billboard = part:FindFirstChild("BillboardGui")
                        if billboard then
                            billboard:Destroy()
                        end
                    end
                end
            end)
        else
            if _G.ESPConnection1 then
                _G.ESPConnection1:Disconnect()
                _G.ESPConnection1 = nil
            end
            
            if _G.ESPConnection2 then
                _G.ESPConnection2:Disconnect()
                _G.ESPConnection2 = nil
            end
            
            for _, model in pairs(itemsFolder:GetChildren()) do
                if model:IsA("Model") then
                    local part = model:FindFirstChildWhichIsA("BasePart")
                    if part then
                        local billboard = part:FindFirstChild("BillboardGui")
                        if billboard then
                            billboard:Destroy()
                        end
                    end
                end
            end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Player Name ESP",
    CurrentValue = false,
    Flag = "PlayerNameESPToggle", 
    Callback = function(Value)
        local localPlayer = game:GetService("Players").LocalPlayer
        
        if Value then
            _G.PlayerNameESPConnection = game:GetService("Players").PlayerAdded:Connect(function(player)
                if player == localPlayer then return end
                
                local function createNameESP()
                    local character = player.Character
                    if character then
                        local head = character:WaitForChild("Head")
                        local humanoid = character:WaitForChild("Humanoid")
                        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        
                        local billboardGui = head:FindFirstChild("PlayerESP")
                        if not billboardGui then
                            billboardGui = Instance.new("BillboardGui")
                            billboardGui.Name = "PlayerESP"
                            billboardGui.Size = UDim2.new(0, 200, 0, 50)
                            billboardGui.StudsOffset = Vector3.new(0, 1, 0)
                            billboardGui.AlwaysOnTop = true
                            billboardGui.Parent = head
                        end
                        
                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Name = "NameLabel"
                        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        nameLabel.Position = UDim2.new(0, 0, 0, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Text = player.Name
                        nameLabel.TextColor3 = Color3.new(1, 1, 1)
                        nameLabel.TextScaled = true
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                        nameLabel.Parent = billboardGui
                    end
                end
                
                if player.Character then
                    createNameESP()
                end
                player.CharacterAdded:Connect(createNameESP)
            end)
            
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player == localPlayer then continue end
                
                local function createNameESP()
                    local character = player.Character
                    if character then
                        local head = character:WaitForChild("Head")
                        local humanoid = character:WaitForChild("Humanoid")
                        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
                        
                        local billboardGui = head:FindFirstChild("PlayerESP")
                        if not billboardGui then
                            billboardGui = Instance.new("BillboardGui")
                            billboardGui.Name = "PlayerESP"
                            billboardGui.Size = UDim2.new(0, 200, 0, 50)
                            billboardGui.StudsOffset = Vector3.new(0, 1, 0)
                            billboardGui.AlwaysOnTop = true
                            billboardGui.Parent = head
                        end
                        
                        local nameLabel = Instance.new("TextLabel")
                        nameLabel.Name = "NameLabel"
                        nameLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        nameLabel.Position = UDim2.new(0, 0, 0, 0)
                        nameLabel.BackgroundTransparency = 1
                        nameLabel.Text = player.Name
                        nameLabel.TextColor3 = Color3.new(1, 1, 1)
                        nameLabel.TextScaled = true
                        nameLabel.TextStrokeTransparency = 0
                        nameLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                        nameLabel.Parent = billboardGui
                    end
                end
                
                if player.Character then
                    createNameESP()
                end
                player.CharacterAdded:Connect(createNameESP)
            end
        else
            if _G.PlayerNameESPConnection then
                _G.PlayerNameESPConnection:Disconnect()
                _G.PlayerNameESPConnection = nil
            end
            
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player == localPlayer then continue end
                
                if player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    local humanoid = player.Character:FindFirstChild("Humanoid")
                    if humanoid then
                        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                    end
                    if head then
                        local billboardGui = head:FindFirstChild("PlayerESP")
                        if billboardGui then
                            local nameLabel = billboardGui:FindFirstChild("NameLabel")
                            if nameLabel then
                                nameLabel:Destroy()
                            end
                            if not billboardGui:FindFirstChild("HealthLabel") then
                                billboardGui:Destroy()
                            end
                        end
                    end
                end
                
                -- Восстанавливаем стандартное отображение ника
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
                end
            end
        end
    end
})

ESPTab:CreateToggle({
    Name = "Health ESP",
    CurrentValue = false,
    Flag = "PlayerHealthESPToggle", 
    Callback = function(Value)
        local localPlayer = game:GetService("Players").LocalPlayer
        
        if Value then
            _G.PlayerHealthESPConnection = game:GetService("Players").PlayerAdded:Connect(function(player)
                if player == localPlayer then return end
                
                local function createHealthESP()
                    local character = player.Character
                    if character then
                        local head = character:WaitForChild("Head")
                        local health = character:WaitForChild("Health")
                        local humanoid = character:WaitForChild("Humanoid")
                        
                        local billboardGui = head:FindFirstChild("PlayerESP")
                        if not billboardGui then
                            billboardGui = Instance.new("BillboardGui")
                            billboardGui.Name = "PlayerESP"
                            billboardGui.Size = UDim2.new(0, 200, 0, 50)
                            billboardGui.StudsOffset = Vector3.new(0, 1, 0)
                            billboardGui.AlwaysOnTop = true
                            billboardGui.Parent = head
                        end
                        
                        local healthLabel = Instance.new("TextLabel")
                        healthLabel.Name = "HealthLabel"
                        healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
                        healthLabel.BackgroundTransparency = 1
                        healthLabel.TextScaled = true
                        healthLabel.TextStrokeTransparency = 0
                        healthLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                        healthLabel.Parent = billboardGui
                        
                        local function updateHealth()
                            if not character:IsDescendantOf(game) or humanoid.Health <= 0 then
                                if healthLabel and healthLabel.Parent then
                                    healthLabel:Destroy()
                                end
                                return
                            end
                            
                            local currentHealth = health.Value
                            healthLabel.Text = math.floor(currentHealth)
                            
                            if currentHealth > 100 then
                                healthLabel.TextColor3 = Color3.new(0, 1, 0)
                            elseif currentHealth > 50 then
                                healthLabel.TextColor3 = Color3.new(1, 1, 0)
                            else
                                healthLabel.TextColor3 = Color3.new(1, 0, 0)
                            end
                        end
                        
                        updateHealth()
                        health:GetPropertyChangedSignal("Value"):Connect(updateHealth)
                        humanoid.Died:Connect(function()
                            if healthLabel and healthLabel.Parent then
                                healthLabel:Destroy()
                            end
                        end)
                    end
                end
                
                if player.Character then
                    createHealthESP()
                end
                player.CharacterAdded:Connect(createHealthESP)
            end)
            
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player == localPlayer then continue end
                
                local function createHealthESP()
                    local character = player.Character
                    if character then
                        local head = character:WaitForChild("Head")
                        local health = character:WaitForChild("Health")
                        local humanoid = character:WaitForChild("Humanoid")
                        
                        local billboardGui = head:FindFirstChild("PlayerESP")
                        if not billboardGui then
                            billboardGui = Instance.new("BillboardGui")
                            billboardGui.Name = "PlayerESP"
                            billboardGui.Size = UDim2.new(0, 200, 0, 50)
                            billboardGui.StudsOffset = Vector3.new(0, 1, 0)
                            billboardGui.AlwaysOnTop = true
                            billboardGui.Parent = head
                        end
                        
                        local healthLabel = Instance.new("TextLabel")
                        healthLabel.Name = "HealthLabel"
                        healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
                        healthLabel.Position = UDim2.new(0, 0, 0.5, 0)
                        healthLabel.BackgroundTransparency = 1
                        healthLabel.TextScaled = true
                        healthLabel.TextStrokeTransparency = 0
                        healthLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
                        healthLabel.Parent = billboardGui
                        
                        local function updateHealth()
                            if not character:IsDescendantOf(game) or humanoid.Health <= 0 then
                                if healthLabel and healthLabel.Parent then
                                    healthLabel:Destroy()
                                end
                                return
                            end
                            
                            local currentHealth = health.Value
                            healthLabel.Text = math.floor(currentHealth)
                            
                            if currentHealth > 100 then
                                healthLabel.TextColor3 = Color3.new(0, 1, 0)
                            elseif currentHealth > 50 then
                                healthLabel.TextColor3 = Color3.new(1, 1, 0)
                            else
                                healthLabel.TextColor3 = Color3.new(1, 0, 0)
                            end
                        end
                        
                        updateHealth()
                        health:GetPropertyChangedSignal("Value"):Connect(updateHealth)
                        humanoid.Died:Connect(function()
                            if healthLabel and healthLabel.Parent then
                                healthLabel:Destroy()
                            end
                        end)
                    end
                end
                
                if player.Character then
                    createHealthESP()
                end
                player.CharacterAdded:Connect(createHealthESP)
            end
        else
            if _G.PlayerHealthESPConnection then
                _G.PlayerHealthESPConnection:Disconnect()
                _G.PlayerHealthESPConnection = nil
            end
            
            for _, player in pairs(game:GetService("Players"):GetPlayers()) do
                if player == localPlayer then continue end
                
                if player.Character then
                    local head = player.Character:FindFirstChild("Head")
                    if head then
                        local billboardGui = head:FindFirstChild("PlayerESP")
                        if billboardGui then
                            local healthLabel = billboardGui:FindFirstChild("HealthLabel")
                            if healthLabel then
                                healthLabel:Destroy()
                            end
                            if not billboardGui:FindFirstChild("NameLabel") then
                                billboardGui:Destroy()
                            end
                        end
                    end
                end
            end
        end
    end
})

-- First, define all necessary helper functions
local function hasInventoryGamepass()
    return MarketplaceService:UserOwnsGamePassAsync(player.UserId, INVENTORY_GAMEPASS_ID)
end

local function getItemCount(itemName)
    local inventory = player.Backpack:GetChildren()
    local count = 0
    for _, item in pairs(inventory) do
        if item.Name == itemName then
            count = count + 1
        end
    end
    return count
end

local function handleProximityPrompt(prompt)
    if prompt.Enabled then
        fireproximityprompt(prompt)
    end
end

local function isInRange(item, maxDistance)
    if not character then return false end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return false end
    
    local itemPart = item:FindFirstChildWhichIsA("BasePart")
    if not itemPart then return false end
    
    return (rootPart.Position - itemPart.Position).Magnitude <= maxDistance
end

local function getDistanceToItem(item)
    if not character then return math.huge end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return math.huge end
    
    local itemPart = item:FindFirstChildWhichIsA("BasePart")
    if not itemPart then return math.huge end
    
    return (rootPart.Position - itemPart.Position).Magnitude
end

local function isItemVisible(item)
    local allInvisible = true
    for _, part in pairs(item:GetDescendants()) do
        if part:IsA("MeshPart") then
            if part.Transparency < 1 then
                allInvisible = false
                break
            end
        end
    end
    return not allInvisible
end

local noclipConnection = nil
local function setNoclip(enabled)
    if enabled then
        noclipConnection = RunService.Stepped:Connect(function()
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    elseif noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
end

local function teleportToItem(item)
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    local itemPart = item:FindFirstChildWhichIsA("BasePart")
    if not itemPart then return end
    
    local targetPos = itemPart.Position + Vector3.new(0, 3, 0)
    
    setNoclip(true)
    
    while (rootPart.Position - targetPos).Magnitude > 1 and itemFarmEnabled do
        local currentPos = rootPart.Position
        local direction = (targetPos - currentPos).Unit
        local nextPos = currentPos + direction * STEP_SIZE
        
        if (nextPos - currentPos).Magnitude > (targetPos - currentPos).Magnitude then
            nextPos = targetPos
        end
        
        rootPart.CFrame = CFrame.new(nextPos)
        wait(0.01)
    end
    
    setNoclip(false)
end

local function collectItem(item)
    local prompt = item:FindFirstChild("ProximityPrompt")
    if prompt then
        prompt.HoldDuration = 0
        fireproximityprompt(prompt)
    end
end

local function isSelectedItem(item)
    local prompt = item:FindFirstChild("ProximityPrompt")
    if not prompt then return false end
    
    if not isItemVisible(item) then return false end
    
    local itemName = prompt.ObjectText
    for _, selectedItem in ipairs(_G.SelectedItems or {}) do
        if itemName:find(selectedItem) then
            local itemCount = getItemCount(itemName)
            local baseLimit = ITEM_LIMITS[itemName] or 10
            local itemLimit = hasInventoryGamepass() and (baseLimit * 2) or baseLimit
            
            if itemCount >= itemLimit then
                if #(_G.SelectedItems or {}) == 1 then
                    itemFarmEnabled = false
                    AutoFarmToggle:Set(false)
                end
                return false
            end
            return true
        end
    end
    return false
end

local function getPriorityItem(items)
    local highestPriority = -1
    local priorityItems = {}
    
    for _, item in pairs(items) do
        if isSelectedItem(item) then
            local prompt = item:FindFirstChild("ProximityPrompt")
            if prompt then
                local itemName = prompt.ObjectText
                local weight = ITEM_WEIGHTS[itemName] or 1
                
                if weight > highestPriority then
                    highestPriority = weight
                    priorityItems = {item}
                elseif weight == highestPriority then
                    table.insert(priorityItems, item)
                end
            end
        end
    end
    
    -- Если есть несколько предметов с одинаковым приоритетом,
    -- выбираем ближайший
    if #priorityItems > 0 then
        table.sort(priorityItems, function(a, b)
            return getDistanceToItem(a) < getDistanceToItem(b)
        end)
        return priorityItems[1]
    end
    
    return nil
end

-- Add autofarm toggle
local AutoFarmToggle = AutoFarmTab:CreateToggle({
    Name = "ItemFarm",
    CurrentValue = false,
    Flag = "ItemFarmToggle",
    Callback = function(Value)
        itemFarmEnabled = Value
        
        if Value then
            spawn(function()
                while itemFarmEnabled do
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local itemsFolder = workspace.Item_Spawns.Items
                        local priorityItem = getPriorityItem(itemsFolder:GetChildren())
                        
                        if priorityItem then
                            teleportToItem(priorityItem)
                            wait(0.1)
                            collectItem(priorityItem)
                            wait(0.2)
                        end
                    end
                    wait(0.05)
                end
            end)
        end
    end
})

local AutofarmDropdown = AutoFarmTab:CreateDropdown({
    Name = "Item Selector",
    Options = {"Gold Coin", "Mysterious Arrow", "Lucky Arrow", "Pure Rokakaka", "Rokakaka", "Rib Cage of The Saint's Corpse", "Steel Ball", "Diamond", "Quinton's Glove", "Stone Mask", "Ancient Scroll", "Zeppeli's Hat", "Clackers", "Dio's Diary", "Caesar's Headband", "Christmas Present"},
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "AutofarmItems", 
    Callback = function(Options)
        _G.SelectedItems = Options
        print("Selected items:", table.concat(Options, ", "))
    end,
})

-- Add item weight sliders
for itemName, defaultWeight in pairs(ITEM_WEIGHTS) do
    AutoFarmTab:CreateSlider({
        Name = "Priority: " .. itemName,
        Range = {1, 10},
        Increment = 1,
        Suffix = "weight",
        CurrentValue = defaultWeight,
        Flag = "Weight_" .. itemName,
        Callback = function(Value)
            ITEM_WEIGHTS[itemName] = Value
        end,
    })
end


