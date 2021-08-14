local Player = game.Players.LocalPlayer
local Character = Player.Character
local Camera = workspace.CurrentCamera

local RunService = game:GetService("RunService")

Character.Archivable = true

RunService.Stepped:Connect(function()
        for i,v in pairs(Character:GetChildren()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end)

local Rig = Character:Clone()
Rig.Parent = Character
Rig.Name = "64Will64_Rig"

wait()

RunService.Stepped:Connect(function()
        for i,v in pairs(Rig:GetChildren()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end)

for _, RigLimbs in next, Rig:GetDescendants() do
    if RigLimbs:IsA("BasePart") then
        RigLimbs.Transparency = 1
    end
end

for _, RigHats in next, Rig:GetDescendants() do
    if RigHats:IsA("Accessory") then
        RigHats.Handle.Transparency = 1
    end
end

for i,v in next, Character.Humanoid:GetPlayingAnimationTracks() do
	v:Stop()
end
wait(.1)
Character.Animate.Disabled = true

Character.HumanoidRootPart.RootJoint:Destroy()

Character.HumanoidRootPart:Destroy()

Rig.Head.face:Destroy()

local function Align(PartToMove,TargetPart,Offset)
    local Position = Instance.new("AlignPosition", PartToMove)
    local Orientation = Instance.new("AlignOrientation", PartToMove)
    
    local AttachmentA = Instance.new("Attachment", PartToMove)
    local AttachmentB = Instance.new("Attachment", TargetPart)
    
    AttachmentB.CFrame = Offset
    
    Position.MaxVelocity = 30^11
    Orientation.MaxTorque = 30^11
    
    Position.MaxForce = 30^11
    Orientation.MaxAngularVelocity = 30^11
    
    Position.Responsiveness = 200
    Orientation.Responsiveness = 200
    
    Position.Attachment0 = AttachmentA
    Position.Attachment1 = AttachmentB
    Orientation.Attachment0 = AttachmentA
    Orientation.Attachment1 = AttachmentB
end

Align(Character.Torso,Rig.Torso, CFrame.new(0,0,0))
Align(Character["Right Arm"],Rig["Right Arm"], CFrame.new(0,0,0))
Align(Character["Left Arm"],Rig["Left Arm"], CFrame.new(0,0,0))
Align(Character["Right Leg"],Rig["Right Leg"], CFrame.new(0,0,0))
Align(Character["Left Leg"],Rig["Left Leg"], CFrame.new(0,0,0))

Camera.CameraSubject = Rig.Humanoid

RunService.Heartbeat:Connect(function()
    settings().Physics.AllowSleep = false
    if Rig.Humanoid.MoveDirection == Vector3.new(0,0,0) then
        for i,v in pairs(Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.Velocity = Vector3.new(15.69, 15.69, 15.69)
                v.RotVelocity = Vector3.new(1,0,0)
            end
        end
    else
        for i,v in pairs(Character:GetChildren()) do
            if v:IsA("BasePart") then
                v.Velocity = Vector3.new(30.69,0,0)
                v.CFrame = v.CFrame
            end
        end
    end
end)

for _, Joints in next, Character.Torso:GetChildren() do
    if Joints:IsA("Motor6D") and Joints.Name ~= "Neck" then
        Joints:Destroy()
    end
end

game.Players.LocalPlayer.Character = Rig

Rig.Humanoid.Died:Connect(function()
    game.Players.LocalPlayer.Character = Character
    local human2 = Character.Humanoid:Clone()
    human2.Parent = Character
    for i,v in pairs(Character:GetChildren()) do
        if v:IsA("BasePart") then
            v.Anchored = true
        end
    end
    Character.Humanoid:Destroy()
end)
