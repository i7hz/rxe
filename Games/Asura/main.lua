repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

local Client = Players.LocalPlayer
local PlayerGui = Client.PlayerGui;
local Configs = {
    farmSpeed = 12
}

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

function AutoJob(b)
    while b do
        if b and Client.Character then
            --pcall(function()
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
                            OrionLib:MakeNotification({Name = "Auto Job", Content = "Clean Finished, estimated time finish: " .. tostring(curTime) .. "s", Time = 5})
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
            --end)
        end
        task.wait()
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
    Callback = AutoJob
})

SectionConfigs:AddSlider({
    Name = "Teleport Speed",
    Min = 1,
    Max = 12,
    Default = Configs.farmSpeed,
    Color = Color3.fromRGB(140, 0, 255),
    Increment = 1,
    ValueName = "MoveSpeed",
    Callback = function(v)
        Configs.farmSpeed = v;
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