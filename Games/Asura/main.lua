repeat task.wait() until game:IsLoaded()

--/ Auto Task/Job
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

getgenv().JobFarm = true;
local farmSpeed = 12

while getgenv().JobFarm do
    local Client = Players.LocalPlayer;
    local Character = Client.Character or Client.CharacterAdded:Wait();

    if Character then
        local Events = ReplicatedStorage.Events
        local CoreEvent = Events.EventCore
        local MainGui = Client.PlayerGui:FindFirstChild("Main")

        local firedArguments = {[1] = "Job"}
        local Job = MainGui.LabelJob.Text
        local TimeJob = MainGui.LabelJob2.Text
        local Paycheck = MainGui.LabelJob3.Text
        local CancelJob = MainGui.CancelJob

        if not CancelJob.Visible then
            repeat task.wait()
                CoreEvent:FireServer(unpack(firedArguments))
            until CancelJob.Visible and Client.PlayerGui:FindFirstChildWhichIsA("BillboardGui")
        end

        task.wait(1)

        local Billboard
        repeat
            Billboard = Client.PlayerGui:FindFirstChild("BillboardGui") or Client.PlayerGui:FindFirstChildOfClass("BillboardGui")
            task.wait()
        until Billboard

        if #Job > 0 and CancelJob.Visible and Billboard.Enabled then
            local TargetPart = Billboard.Adornee
            local PrimaryPart = Character:FindFirstChild("HumanoidRootPart")

            --: Cleaning
            if tostring(TargetPart):match("Entrance") then
                if CLient:DistanceFromCharacter(TargetPart.Position) > 40 then
                    local ModifyCFrame = PrimaryPart.CFrame + Vector3.new(0, -20, 0)
                    Tp(ModifyCFrame, farmSpeed)
                    local ModifyCFrame = TargetPart.CFrame + Vector3.new(0, -25, 0)
                    Tp(ModifyCFrame, farmSpeed)
                    local ModifyCFrame = TargetPart.CFrame
                    Tp(ModifyCFrame, farmSpeed)
                end

                local CleaningParts = workspace:FindFirstChild("CleaningParts")
                if CleaningParts then
                    local function getPart()
                        local playerCleanings = CleaningParts:FindFirstChildWhichIsA(Client.Name)
                        local objPart, clickDetect;
                        for _,part in pairs(playerCleanings:GetChildren()) do
                            if part:FindFirstChildWhichIsA("ClickDetector") then
                                objPart = part;
                                clickDetect = part:FindFirstChildWhichIsA("ClickDetector")
                            end
                        end
                        return objPart, clickDetect
                    end

                    local part,cd = getPart()
                    local finish = false;
                    Tp(part.CFrame + Vector3.new(0, 3.2, 0), farmSpeed*2)

                    repeat
                        pcall(function()
                            PrimaryPart.Anchored = false;
                            fireclickdetector(cd, 1)

                            if not part.Parent or not part.Parent == CleaningParts then
                                finish = true;
                            end
                        end)
                    until finish
                end
            else -- Delivery
                local ModifyCFrame = PrimaryPart.CFrame + Vector3.new(0, -20, 0)
                Tp(ModifyCFrame, farmSpeed)
                local ModifyCFrame = TargetPart.CFrame + Vector3.new(0, -25, 0)
                Tp(ModifyCFrame, farmSpeed)
                local ModifyCFrame = TargetPart.CFrame
                Tp(ModifyCFrame, farmSpeed*2)
            end
        end
    end
    task.wait()
end