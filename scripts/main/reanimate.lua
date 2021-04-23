local Player = game.Players.LocalPlayer
local Character = Player.Character
local Camera = workspace.CurrentCamera

local RunService = game:GetService("RunService")

Character.Archivable = true


local Rig = Character:Clone()
Rig.Parent = Character

wait()

Character.HumanoidRootPart.RootJoint:Destroy()

Character.HumanoidRootPart:Destroy()

for _, Joints in next, Character.Torso:GetChildren() do
    if Joints:IsA("Motor6D") and Joints.Name ~= "Neck" then
        Joints:Destroy()
    end
end

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

Rig.Head.face:Destroy()

local function Align(PartToMove,TargetPart,Offset)
    local Position = Instance.new("AlignPosition", PartToMove)
    local Orientation = Instance.new("AlignOrientation", PartToMove)
    
    local AttachmentA = Instance.new("Attachment", PartToMove)
    local AttachmentB = Instance.new("Attachment", TargetPart)
    
    AttachmentB.CFrame = Offset
    
    Position.MaxVelocity = 9e9/2
    Orientation.MaxTorque = 9e9/2
    
    Position.MaxForce = 9e9/2
    Orientation.MaxAngularVelocity = 9e9/2
    
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
    for i,v in pairs(Character:GetChildren()) do
        if v:IsA("BasePart") then
            v.Velocity = Vector3.new(0,30,0)
            v.CFrame = v.CFrame
        end
    end
end)

Character.Humanoid.AnimationPlayed:connect(function(anim)
	anim:Stop()
end)

for i,v in pairs(Character.Humanoid:GetPlayingAnimationTracks()) do
	v:AdjustSpeed(0)
end

RunService.Stepped:Connect(function()
        for i,v in pairs(Character:GetChildren()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
end)

game.Players.LocalPlayer.Character = Rig
