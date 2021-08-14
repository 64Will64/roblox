--[[
                                         _                   
                                        | |                  
__   ___ __    __ _ _ __  _   ___      _| |__   ___ _ __ ___ 
\ \ / / '__|  / _` | '_ \| | | \ \ /\ / / '_ \ / _ \ '__/ _ \
 \ V /| |    | (_| | | | | |_| |\ V  V /| | | |  __/ | |  __/
  \_/ |_|     \__,_|_| |_|\__, | \_/\_/ |_| |_|\___|_|  \___|
                           __/ |
                          |___/ 

 _                 _            _                            
| |               | |          | |                           
| |__  _   _   ___| | _____  __| |                           
| '_ \| | | | / __| |/ / _ \/ _` |                           
| |_) | |_| | \__ \   <  __/ (_| |                           
|_.__/ \__, | |___/_|\_\___|\__,_|                           
        __/ |                                                
       |___/
	   
   __ _              _ 
  / _(_)            | |
 | |_ ___  _____  __| |
 |  _| \ \/ / _ \/ _` |
 | | | |>  <  __/ (_| |
 |_| |_/_/\_\___|\__,_|

(Credit to 64Will64 for first managing to fix the script before I did!)
]]

spawn(function()
	while true do
		settings().Physics.AllowSleep = false
		game:GetService("RunService").Heartbeat:wait()
	end
end)

local options = {}

-- OPTIONS:

options.headscale = 3 -- how big you are in vr, 1 is default, 3 is recommended for max comfort in vr
options.forcebubblechat = true -- decide if to force bubblechat so you can see peoples messages

options.headhat = _G.headhat -- name of the accessory which you are using as a head
options.righthandhat = _G.righthandhat -- name of the accessory which you are using as your right hand
options.lefthandhat = _G.lefthandhat -- name of the accessory which you are using as your left hand

options.righthandrotoffset = Vector3.new(0,0,0)
options.lefthandrotoffset = Vector3.new(0,0,0)

--

local plr = game:GetService("Players").LocalPlayer
local char = plr.Character
--local backpack = plr.Backpack

local VR = game:GetService("VRService")
local input = game:GetService("UserInputService")

local cam = workspace.CurrentCamera

cam.CameraType = "Scriptable"

cam.HeadScale = options.headscale

game:GetService("StarterGui"):SetCore("VRLaserPointerMode", 0)
game:GetService("StarterGui"):SetCore("VREnableControllerModels", false)


local function createpart(size, name)
	local Part = Instance.new("Part", char)
	Part.CFrame = char.HumanoidRootPart.CFrame
	Part.Size = size
	Part.Transparency = 1
	Part.CanCollide = false
	Part.Anchored = true
	Part.Name = name
	return Part
end

local moveHandL = createpart(Vector3.new(1,1,2), "moveRH")
local moveHandR = createpart(Vector3.new(1,1,2), "moveLH")
local moveHead = createpart(Vector3.new(1,1,1), "moveH")

local handL
local handR
local head
local R1down = false

for i,v in pairs(char.Humanoid:GetAccessories()) do
	if v:FindFirstChild("Handle") then
		local handle = v.Handle
		
		if v.Name == options.righthandhat and not handR then
			handle:FindFirstChildOfClass("SpecialMesh"):Destroy()
			handR = v
		elseif v.Name == options.lefthandhat and not handL then
			handle:FindFirstChildOfClass("SpecialMesh"):Destroy()
			handL = v
		elseif v.Name == options.headhat and not head then
			handle.Transparency = 1
			head = v
		end
	end
end

char.Humanoid.AnimationPlayed:connect(function(anim)
	anim:Stop()
end)

for i,v in pairs(char.Humanoid:GetPlayingAnimationTracks()) do
	v:AdjustSpeed(0)
end

local torso = char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
torso.Anchored = true
char.HumanoidRootPart.Anchored = true

workspace.CurrentCamera.CFrame = CFrame.new(workspace.CurrentCamera.CFrame.Position)

input.UserCFrameChanged:connect(function(part,move)
	if part == Enum.UserCFrame.Head then
		--move(head,cam.CFrame*move)
		moveHead.CFrame = cam.CFrame*(CFrame.new(move.p*(cam.HeadScale-1))*move)
	elseif part == Enum.UserCFrame.LeftHand then
		--move(handL,cam.CFrame*move)
		moveHandL.CFrame = cam.CFrame*(CFrame.new(move.p*(cam.HeadScale-1))*move*CFrame.Angles(math.rad(options.righthandrotoffset.X),math.rad(options.righthandrotoffset.Y),math.rad(options.righthandrotoffset.Z)))
	elseif part == Enum.UserCFrame.RightHand then
		--move(handR,cam.CFrame*move)
		moveHandR.CFrame = cam.CFrame*(CFrame.new(move.p*(cam.HeadScale-1))*move*CFrame.Angles(math.rad(options.righthandrotoffset.X),math.rad(options.righthandrotoffset.Y),math.rad(options.righthandrotoffset.Z)))
	end
end)

local function Align(Part1,Part0,CFrameOffset) -- i dont know who made this function but 64will64 sent it to me so credit to whoever made it
	local AlignPos = Instance.new('AlignPosition', Part1);
	AlignPos.Parent.CanCollide = false;
	AlignPos.ApplyAtCenterOfMass = true;
	AlignPos.MaxForce = 67752;
	AlignPos.MaxVelocity = math.huge/9e110;
	AlignPos.ReactionForceEnabled = false;
	AlignPos.Responsiveness = 200;
	AlignPos.RigidityEnabled = false;
	local AlignOri = Instance.new('AlignOrientation', Part1);
	AlignOri.MaxAngularVelocity = math.huge/9e110;
	AlignOri.MaxTorque = 67752;
	AlignOri.PrimaryAxisOnly = false;
	AlignOri.ReactionTorqueEnabled = false;
	AlignOri.Responsiveness = 200;
	AlignOri.RigidityEnabled = false;
	local AttachmentA=Instance.new('Attachment',Part1);
	local AttachmentB=Instance.new('Attachment',Part0);
	AttachmentB.CFrame = AttachmentB.CFrame * CFrameOffset
	AlignPos.Attachment0 = AttachmentA;
	AlignPos.Attachment1 = AttachmentB;
	AlignOri.Attachment0 = AttachmentA;
	AlignOri.Attachment1 = AttachmentB;
end

head.Handle:BreakJoints()
handR.Handle:BreakJoints()
handL.Handle:BreakJoints()

Align(head.Handle,moveHead,CFrame.new(0,0,0))
Align(handR.Handle,moveHandR,CFrame.new(0,0,0))
Align(handL.Handle,moveHandL,CFrame.new(0,0,0))

input.InputChanged:connect(function(key)
	if key.KeyCode == Enum.KeyCode.ButtonR1 then
		if key.Position.Z > 0.9 then
			R1down = true
		else
			R1down = false
		end
	end
end)

input.InputBegan:connect(function(key)
	if key.KeyCode == Enum.KeyCode.ButtonR1 then
		R1down = true
	end
end)

input.InputEnded:connect(function(key)
	if key.KeyCode == Enum.KeyCode.ButtonR1 then
		R1down = false
	end
end)

game:GetService("RunService").RenderStepped:connect(function()
	if R1down then
		cam.CFrame = cam.CFrame:Lerp(cam.CoordinateFrame + (moveHandR.CFrame*CFrame.Angles(-math.rad(options.righthandrotoffset.X),-math.rad(options.righthandrotoffset.Y),math.rad(180-options.righthandrotoffset.X))).LookVector * cam.HeadScale/2, 0.5)
	end
end)

local function bubble(plr,msg)
	game:GetService("Chat"):Chat(plr.Character.Head,msg,Enum.ChatColor.White)
end

game:GetService("RunService").Heartbeat:Connect(function()
    for i,v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            v.Handle.Velocity = Vector3.new(0,30,0)
            v.Handle.CFrame = v.Handle.CFrame
        end
    end
end)
