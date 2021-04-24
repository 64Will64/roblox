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
	   
]]

local options = {}

-- OPTIONS:

options.headscale = 3 -- how big you are in vr, 1 is default, 3 is recommended for max comfort in vr
options.forcebubblechat = true -- decide if to force bubblechat so you can see peoples messages

options.headhat = "MediHood" -- name of the accessory which you are using as a head
options.righthandhat = "Pal Hair" -- name of the accessory which you are using as your right hand
options.lefthandhat = "LavanderHair" -- name of the accessory which you are using as your left hand

options.righthandrotoffset = Vector3.new(0,0,0)
options.lefthandrotoffset = Vector3.new(0,0,0)

--

local plr = game:GetService("Players").LocalPlayer
local char = plr.Character
local backpack = plr.Backpack

local VR = game:GetService("VRService")
local input = game:GetService("UserInputService")

local cam = workspace.CurrentCamera

cam.CameraType = "Scriptable"

cam.HeadScale = options.headscale

game:GetService("StarterGui"):SetCore("VRLaserPointerMode", 0)
game:GetService("StarterGui"):SetCore("VREnableControllerModels", false)

local handL = char:FindFirstChild(options.lefthandhat).Handle
local handR = char:FindFirstChild(options.righthandhat).Handle
local head = char:FindFirstChild(options.headhat).Handle
local R1down = false

head:BreakJoints()
handR:BreakJoints()
handL:BreakJoints()

for i,v in pairs(char.Humanoid:GetAccessories()) do
	if v:FindFirstChild("Handle") then
		local handle = v.Handle
		
		if v.Name == options.righthandhat then
			handle:FindFirstChildOfClass("SpecialMesh"):Destroy()
		elseif v.Name == options.lefthandhat then
			handle:FindFirstChildOfClass("SpecialMesh"):Destroy()
		elseif v.Name == options.headhat then
			handle.Transparency = 1
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

workspace.CurrentCamera.CFrame = CFrame.new(char.Head.Position)

input.UserCFrameChanged:connect(function(part,move)
	if part == Enum.UserCFrame.Head then
		local rArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightLowerArm")
		local armcframe = rArm.CFrame * CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0)
		local cf = cam.CFrame*(CFrame.new(move.p*(cam.HeadScale-1))*move)
		head.CFrame = cf-- * CFrame.new(0,.5,-.5) * CFrame.Angles(math.rad(45),0,0)
	elseif part == Enum.UserCFrame.LeftHand then
		local rArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightLowerArm")
		local armcframe = rArm.CFrame * CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0)
		local cf = cam.CFrame*(CFrame.new(move.p*(cam.HeadScale-1))*move)
		handL.CFrame = cf-- * CFrame.new(0,.5,-.5) * CFrame.Angles(math.rad(45),0,0)
	elseif part == Enum.UserCFrame.RightHand then
		local rArm = char:FindFirstChild("Right Arm") or char:FindFirstChild("RightLowerArm")
		local armcframe = rArm.CFrame * CFrame.new(0, -1, 0, 1, 0, 0, 0, 0, 1, 0, -1, 0)
		local cf = cam.CFrame*(CFrame.new(move.p*(cam.HeadScale-1))*move)
		handR.CFrame = cf-- * CFrame.new(0,.5,-.5) * CFrame.Angles(math.rad(45),0,0)
	end
end)

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
		cam.CFrame = cam.CFrame:Lerp(cam.CoordinateFrame + (handR.CFrame*CFrame.Angles(-math.rad(options.righthandrotoffset.X),-math.rad(options.righthandrotoffset.Y),math.rad(180-options.righthandrotoffset.X))).LookVector * cam.HeadScale/2, 2)
	end
end)

local function bubble(plr,msg)
	game:GetService("Chat"):Chat(plr.Character.Head,msg,Enum.ChatColor.White)
end

if options.forcebubblechat == true then
	game.Players.PlayerAdded:connect(function(plr)
		plr.Chatted:connect(function(msg)
			game:GetService("Chat"):Chat(plr.Character.Head,msg,Enum.ChatColor.White)
		end)
	end)
	
	for i,v in pairs(game.Players:GetPlayers()) do
		v.Chatted:connect(function(msg)
			game:GetService("Chat"):Chat(v.Character.Head,msg,Enum.ChatColor.White)
		end)
	end
end

game:GetService("RunService").Heartbeat:Connect(function()
    for i,v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            v.Handle.Velocity = Vector3.new(0,30,0)
            v.Handle.CFrame = v.Handle.CFrame
        end
    end
end)
