repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Client = Players.LocalPlayer
local PlayerGui = Client.PlayerGui;
local Configs = {
    farmSpeed = 12,
    roadworkFocus = "Stamina",
    Noclip = nil
}

local Part = Instance.new("Part")
do
    Part.Parent = workspace
    Part.CanCollide = true
    Part.Size = Vector3.new(5, 1, 5)
    Part.Anchored = true;

    task.spawn(function()
        RunService.Heartbeat:Connect(function()
            if Client.Character or Client.CharacterAdded:Wait() then
                local PrimaryPart = Client.Character:FindFirstChild("HumanoidRootPart")
                if PrimaryPart then
                    Part.CFrame = PrimaryPart.CFrame - Vector3.new(0, 3, 0)
                end
            end
        end)
    end)
end

Configs.Noclip = RunService.RenderStepped:Connect(function(deltaTime)
    for k,v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide == true and v ~= Part then
            v.CanCollide = false;
        end
    end    
end)

function Tp(coordinate: CFrame, speed: number)
    local Client = Players.LocalPlayer
    local Character = Client.Character or Client.CharacterAdded:Wait()
    local TweeningSpeed = speed or 6

    if Character then
        local PrimaryPart = Character:FindFirstChild("HumanoidRootPart")

        local TweenService = game:GetService"TweenService"
        local TweenInformation = TweenInfo.new(Client:DistanceFromCharacter(coordinate.Position) / TweeningSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.In)
        local newTween = TweenService:Create(PrimaryPart, TweenInformation, {CFrame = coordinate})
        newTween:Play()
        wait(Client:DistanceFromCharacter(coordinate.Position) / TweeningSpeed + 0.1)
    end
end

function GetJob()
    local Remote = ReplicatedStorage.Events.EventCore;
    local MainGui = PlayerGui:FindFirstChild("Main")
    local jobText, cancelJob = MainGui.LabelJob.Text, MainGui.CancelJob

    if not cancelJob.Visible and #jobText <= 1 then
        Remote:FireServer("Job")
        task.wait(1)
    end

    return cancelJob.Visible;
end

function GetLocation()
    local obj = PlayerGui:FindFirstChildOfClass("BillboardGui") or nil;
    return obj
end

function GetCleanParts()
    local Folder = workspace.CleaningParts
    if #Folder:GetChildren() > 0 then
        local PlayerParts = Folder[Client.Name];
        if PlayerParts and #PlayerParts:GetChildren() > 0 then
            local obj;
            for _,v in pairs(PlayerParts:GetChildren()) do
                obj = v;
                break;
            end
            return obj;
        end
    end
    return false
end

function GetInventory(items: string)
    local Backpack = PlayerGui.BackpackGui.Backpack;
    local function CheckHotbar()
        local Hotbar = Backpack.Hotbar:GetChildren()
        local tool,stack;
        for _,v in pairs(Hotbar) do
            if v:IsA("ImageButton") and v.ToolName.Text == items then
                tool = Client.Backpack:FindFirstChild(v.ToolName.Text);
                stack = v.StackNumber.Text
            end
        end
        return (tool and stack and {tool, stack}) or nil
    end

    local function CheckInventory()
        local Inventory = Backpack.Inventory.ScrollingFrame.UIGridFrame:GetChildren()
        local tool,stack;
        for _,v in pairs(Inventory) do
            if v:IsA("ImageButton") and v.ToolName.Text == items then
                tool = Client.Backpack:FindFirstChild(v.ToolName.Text)
                stack = v.StackNumber.Text                
            end
        end
        return (tool and stack and {tool, stack}) or nil
    end

    return CheckHotbar() or CheckInventory()
end

function AutoJob(b: boolean)
    while b do
        if b and Client.Character then
            pcall(function()
                repeat
                    task.wait()
                until GetJob() == true
    
                repeat
                    task.wait()
                until GetLocation()

                if GetLocation() then
                    local oldTm = os.clock()
                    local Target = GetLocation().Adornee
                    local Character = Client.Character or Client.CharacterAdded:Wait()
                    local PrimaryPart = Character:FindFirstChild("HumanoidRootPart")
                    local Speed = Configs.farmSpeed

                    if GetCleanParts() and PrimaryPart then
                        if Client:DistanceFromCharacter(Target.Position) > 100 then
                            local ModifyCFrame = PrimaryPart.CFrame + Vector3.new(0, -20, 0)
                            Tp(ModifyCFrame, Speed)

                            local ModifyCFrame = Target.CFrame + Vector3.new(0, -25, 0)
                            Tp(ModifyCFrame, Speed)

                            local ModifyCFrame = Target.CFrame
                            Tp(ModifyCFrame, Speed*2)
                        end

                        local Part = GetCleanParts();
                        local CD = Part and Part:FindFirstChildOfClass("ClickDetector")
                        if Part and CD then
                            local ModifyCFrame = Part.CFrame + Vector3.new(0, 3, 0)
                            Tp(ModifyCFrame, Speed)
                            repeat
                                task.wait(.5)
                                fireclickdetector(CD, 1)
                            until Part.Parent == nil or not workspace.CleaningParts[Client.Name]:IsAncestorOf(Part)
                            local curTime = os.clock() - oldTm
                            OrionLib:MakeNotification({Name = "Auto Job", Content = ("Clean Finished, estimated time finish: %.2fs"):format(tostring(curTime)), Time = 5})
                        end
                    else
                        if PrimaryPart and GetJob() and Target then
                            local ModifyCFrame = PrimaryPart.CFrame + Vector3.new(0, -20, 0)
                            Tp(ModifyCFrame, Speed)

                            local ModifyCFrame = Target.CFrame + Vector3.new(0, -25, 0)
                            Tp(ModifyCFrame, Speed)

                            local ModifyCFrame = Target.CFrame
                            Tp(ModifyCFrame, Speed*2)
                        end
                    end

                    task.wait(1)
                    GetJob()
                end
            end)
        end
        task.wait()
    end
end

function AutoRoadwork(b: boolean)
    while b do
        if b and Client.Character then
            local Character = Client.Character or Client.CharacterAdded:Wait()
            local PrimaryPart = Character:FindFirstChild("HumanoidRootPart")
            local Speed = Configs.farmSpeed;

            if GetLocation() then
                local Target = GetLocation().Adornee

                local oldTm = os.clock()
                if PrimaryPart and Target then
                    local ModifyCFrame = PrimaryPart.CFrame + Vector3.new(0, -20, 0)
                    Tp(ModifyCFrame, Speed)

                    local ModifyCFrame = Target.CFrame + Vector3.new(0, -25, 0)
                    Tp(ModifyCFrame, Speed)

                    local ModifyCFrame = Target.CFrame
                    Tp(ModifyCFrame, Speed*2)
                end
                local curTime = os.clock() - oldTm
                OrionLib:MakeNotification({Name = "Roadwork Target", Content = "Reached at " .. Target.Name .. (", estimated time reached: %.2f"):format(curTime)})
            end

            if type(GetInventory("Roadwork Training")) == "table" and GetInventory("Roadwork Training")[1] then
                local RoadworkGui = PlayerGui.RoadworkGain
                local Tool, Stack = unpack(GetInventory("Roadwork Training"))

                local Stamina = RoadworkGui.Frame.Stamina
                local _Speed = RoadworkGui.Frame.Speed

                if not RoadworkGui.Frame.Visible then
                    Tool:EquipTool()
                    task.wait()
                    Tool:Activate()
                end

                if not GetLocation() and RoadworkGui.Frame.Visible then
                    if Configs.roadworkFocus == "Stamina" then
                        game:GetService("VirtualUser"):Button1Up(Stamina.AbsolutePosition)
                        Stamina:Activate()
                    elseif Configs.roadworkFocus == "Speed" then
                        game:GetService("VirtualUser"):Button1Up(_Speed.AbsolutePosition)
                        _Speed:Activate()
                    end
                end

                repeat
                    task.wait()
                until GetLocation()
            else
                local BuyRoadwork = workspace.Purchases.GYM['Roadwork Training']
                local Part = BuyRoadwork:FindFirstChildWhichIsA("Part")
                local ClickDetector = BuyRoadwork:FindFirstChildOfClass("ClickDetector");

                if Client:DistanceFromCharacter(Part.Position) >= 5 then
                    local ModifyCFrame = PrimaryPart.CFrame + Vector3.new(0, -20, 0)
                    Tp(ModifyCFrame, Speed)

                    local ModifyCFrame = Part.CFrame + Vector3.new(0, -25, 0)
                    Tp(ModifyCFrame, Speed)

                    local ModifyCFrame = Part.CFrame + Vector3.new(0, 3, 0)
                    Tp(ModifyCFrame, Speed)
                end

                if Client:DistanceFromCharacter(Part.Position) <= 5 then
                    repeat task.wait(.5)
                        local ModifyCFrame = Part.CFrame + Vector3.new(0, 3, 0)
                        Tp(ModifyCFrame, Speed)
                        fireclickdetector(ClickDetector, 1)
                    until tonumber(GetInventory('Roadwork Training')[2]) == 3
                end
            end
        end
    end
end

OrionLib:MakeNotification({Name = "Loaded", Content = "Thank you for using this services!", Time = 5})
local Window = OrionLib:MakeWindow({Name = "RXE | " .. rxe.current_game.game_name, HidePremium = false, SaveConfig = true, ConfigFolder = "RXE"})
local Tab1 = Window:MakeTab({
	Name = "Farm",
	Icon = "rbxassetid://4483345998",
	PremiumOnly = false
})

local SectionFarm = Tab1:AddSection({
	Name = "Enabled"
})
local SectionConfigs = Tab1:AddSection({
    Name = "Configuration"
})

SectionFarm:AddToggle({
    Name = "Auto Job",
    Default = false,
    Callback = function(v)
        AutoJob(v)
    end
})

SectionFarm:AddToggle({
    Name = "Auto Roadwork",
    Default = false,
    Callback = function(v)
        AutoRoadwork(v)
    end
})

SectionConfigs:AddToggle({
    Name = "Noclip",
    Default = true,
    Callback = function(v)
        if Configs.Noclip then
            Configs.Noclip:Disconnect()
        else
            Configs.Noclip = RunService.RenderStepped:Connect(function(deltaTime)
                for k,v in pairs(workspace:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide == true and v ~= Part then
                        v.CanCollide = false;
                    end
                end
            end)
        end
    end
})

SectionConfigs:AddSlider({
    Name = "Teleport Speed",
    Min = 1,
    Max = 20,
    Default = Configs.farmSpeed,
    Color = Color3.fromRGB(140, 0, 255),
    Increment = 1,
    ValueName = "MoveSpeed",
    Callback = function(v)
        Configs.farmSpeed = v;
    end
})

SectionConfigs:AddDropdown({
    Name = "Roadwork Focus",
    Default = Configs.roadworkFocus,
    Options = {"Stamina", "Speed"},
    Callback = function(v)
        Configs.roadworkFocus = v;
    end
})
-- while getgenv().JobFarm do
--     local Client = Players.LocalPlayer;
--     local Character = Client.Character or Client.CharacterAdded:Wait();

--     if Character then
--         local Events = ReplicatedStorage.Events
--         local CoreEvent = Events.EventCore
--         local MainGui = Client.PlayerGui:FindFirstChild("Main")

--         local firedArguments = {[1] = "Job"}
--         local Job = MainGui.LabelJob.Text
--         local TimeJob = MainGui.LabelJob2.Text
--         local Paycheck = MainGui.LabelJob3.Text
--         local CancelJob = MainGui.CancelJob

--         if not CancelJob.Visible then
--             repeat task.wait()
--                 CoreEvent:FireServer(unpack(firedArguments))
--             until CancelJob.Visible and Client.PlayerGui:FindFirstChildWhichIsA("BillboardGui")
--         end

--         task.wait(1)

--         local Billboard
--         repeat
--             Billboard = Client.PlayerGui:FindFirstChild("BillboardGui") or Client.PlayerGui:FindFirstChildOfClass("BillboardGui")
--             task.wait()
--         until Billboard

--         if #Job > 0 and CancelJob.Visible and Billboard.Enabled then
--             local TargetPart = Billboard.Adornee
--             local PrimaryPart = Character:FindFirstChild("HumanoidRootPart")

--             --: Cleaning
--             if tostring(TargetPart):match("Entrance") then
--                 if CLient:DistanceFromCharacter(TargetPart.Position) > 40 then
--                     local ModifyCFrame = PrimaryPart.CFrame + Vector3.new(0, -20, 0)
--                     Tp(ModifyCFrame, farmSpeed)
--                     local ModifyCFrame = TargetPart.CFrame + Vector3.new(0, -25, 0)
--                     Tp(ModifyCFrame, farmSpeed)
--                     local ModifyCFrame = TargetPart.CFrame
--                     Tp(ModifyCFrame, farmSpeed)
--                 end

--                 local CleaningParts = workspace:FindFirstChild("CleaningParts")
--                 if CleaningParts then
--                     local function getPart()
--                         local playerCleanings = CleaningParts:FindFirstChildWhichIsA(Client.Name)
--                         local objPart, clickDetect;
--                         for _,part in pairs(playerCleanings:GetChildren()) do
--                             if part:FindFirstChildWhichIsA("ClickDetector") then
--                                 objPart = part;
--                                 clickDetect = part:FindFirstChildWhichIsA("ClickDetector")
--                             end
--                         end
--                         return objPart, clickDetect
--                     end

--                     local part,cd = getPart()
--                     local finish = false;
--                     Tp(part.CFrame + Vector3.new(0, 3.2, 0), farmSpeed*2)

--                     repeat
--                         pcall(function()
--                             PrimaryPart.Anchored = false;
--                             fireclickdetector(cd, 1)

--                             if not part.Parent or not part.Parent == CleaningParts then
--                                 finish = true;
--                             end
--                         end)
--                     until finish
--                 end
--             else -- Delivery
--                 local ModifyCFrame = PrimaryPart.CFrame + Vector3.new(0, -20, 0)
--                 Tp(ModifyCFrame, farmSpeed)
--                 local ModifyCFrame = TargetPart.CFrame + Vector3.new(0, -25, 0)
--                 Tp(ModifyCFrame, farmSpeed)
--                 local ModifyCFrame = TargetPart.CFrame
--                 Tp(ModifyCFrame, farmSpeed*2)
--             end
--         end
--     end
--     task.wait()
-- end