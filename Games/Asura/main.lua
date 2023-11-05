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
        local TweenInformation = TweenInfo.new(Client:DistanceFromCharacter(coordinate.Position) / TweeningSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)
        local newTween = TweenService:Create(PrimaryPart, TweenInformation, {CFrame = coordinate})
        newTween:Play()
        wait(Client:DistanceFromCharacter(coordinate.Position) / TweeningSpeed + 0.1)
    end
end

-- getgenv().JobFarm = true;
local farmSpeed = 12

-- while getgenv().JobFarm do
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

        local Deliverys = workspace.Delivery;
        local DeliveryFrom,DeliveryTo

        local Billboard = Client.PlayerGui:FindFirstChild("BillboardGui")

        if #Job > 0 and CancelJob.Visible and Billboard.Enabled then
            local TargetPart = Billboard.Adornee
            local PrimaryPart = Character:FindFirstChild("HumanoidRootPart")

            --: Cleaning
            if tostring(TargetPart):match("Entrance") then
                local ModifyCFrame = PrimaryPart.CFrame + Vector3.new(0, -20, 0)
                Tp(ModifyCFrame, farmSpeed)
                local ModifyCFrame = TargetPart.CFrame + Vector3.new(0, -25, 0)
                Tp(ModifyCFrame, farmSpeed)
                local ModifyCFrame = TargetPart.CFrame
                Tp(ModifyCFrame, farmSpeed)

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

                    repeat
                        local part,cd = getPart()
                        if part and cd then
                            Tp(part.CFrame)
                            PrimaryPart.CFrame = PrimaryPart.CFrame * CFrame.Angles(0, 0, math.rad(180))

                            fireclickdetector(cd, 1)
                        end
                        task.wait()
                    until not CancelJob.Visible
                end
            else -- Delivery
                local ModifyCFrame = PrimaryPart.CFrame + Vector3.new(0, -20, 0)
                Tp(ModifyCFrame, farmSpeed)
                local ModifyCFrame = TargetPart.CFrame + Vector3.new(0, -25, 0)
                Tp(ModifyCFrame, farmSpeed)
                local ModifyCFrame = TargetPart.CFrame
                Tp(ModifyCFrame, farmSpeed)
            end
        else
            CoreEvent:FireServer(unpack(firedArguments))
            task.wait()
        end
    end
    task.wait()
-- end