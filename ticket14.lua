local ArrayField =
	loadstring(game:HttpGet("https://raw.githubusercontent.com/UI-Interface/ArrayField/main/Source.lua"))()
local Maid = loadstring(
	game:HttpGet(
		"https://raw.githubusercontent.com/Quenty/NevermoreEngine/refs/heads/version2/Modules/Shared/Events/Maid.lua"
	)
)()

local Window = ArrayField:CreateWindow({
	Name = "dumpstring.lol - Elemental Grounds",
	LoadingTitle = "dumpstring.lol",
	LoadingSubtitle = "by dumpstring",
	KeySystem = false,
	KeySettings = {

		Key = { "Hello" },
	},
})

local GC = getconnections or get_signal_cons
if GC then
	for i, v in pairs(GC(game.Players.LocalPlayer.Idled)) do
		if v["Disable"] then
			v["Disable"](v)
		elseif v["Disconnect"] then
			v["Disconnect"](v)
		end
	end
else
	local VirtualUser = cloneref(game:GetService("VirtualUser"))
	game.Players.LocalPlayer.Idled:Connect(function()
		VirtualUser:CaptureController()
		VirtualUser:ClickButton2(Vector2.new())
	end)
end

local cleanupmaid = Maid.new()

cleanupmaid:GiveTask(function()
	ArrayField:Destroy()
end)

local Tab = Window:CreateTab("Main", "rewind")

local function questloop()
	local agorRoot = workspace:WaitForChild("NPCs"):WaitForChild("Agor"):WaitForChild("HumanoidRootPart")
	local agorProximityPrompt = workspace:WaitForChild("NPCs"):WaitForChild("Agor"):WaitForChild("ProximityPrompt")

	local toolName = game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Tool").Name

	local function reEquipTool()
		local player = game.Players.LocalPlayer
		local character = player.Character or player.CharacterAdded:Wait()
		local backpack = player:WaitForChild("Backpack")
		local tool = backpack:WaitForChild(toolName)
		tool.Parent = character
	end

	local function killSouls()
		local killedSouls = 0
		while killedSouls < 5 do
			local soul = nil
			repeat
				for _, v in ipairs(workspace.AiPlayerData:GetChildren()) do
					if v:GetAttribute("Strong_Soul") then
						local potentialSoul = workspace.AiCharacters:FindFirstChild(v.Name)
						if
							potentialSoul
							and potentialSoul:FindFirstChild("Humanoid")
							and potentialSoul.Humanoid.Health > 0
						then
							soul = potentialSoul
							break
						end
					end
				end
				task.wait(0.1)
			until soul

			local player = game.Players.LocalPlayer
			local character = player.Character or player.CharacterAdded:Wait()
			local hum = character:WaitForChild("Humanoid")
			local root = character:WaitForChild("HumanoidRootPart")
			local soulHum = soul:WaitForChild("Humanoid")
			local soulRoot = soul:WaitForChild("HumanoidRootPart")

			repeat
				if hum.Health <= 0 then
					player.CharacterAdded:Wait()
					task.wait(1)
					game:GetService("ReplicatedStorage")
						:WaitForChild("ClientRemotes")
						:WaitForChild("SpawnHandler")
						:FireServer(1)
					task.wait(1)
					reEquipTool()
					break
				end
				root.CFrame = soulRoot.CFrame
				mouse1click()
				task.wait()
			until soulHum.Health <= 0

			if soulHum.Health <= 0 then
				killedSouls += 1
			end
		end
	end

	while true do
		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = agorRoot.CFrame
		repeat
			fireproximityprompt(agorProximityPrompt)
			task.wait(0.1)
		until game.Players.LocalPlayer.PlayerGui:WaitForChild("GameUI"):WaitForChild("Dialogue").Visible

		task.wait(0.5)
		for _, v in
			ipairs(
				getconnections(
					game.Players.LocalPlayer.PlayerGui
						:WaitForChild("GameUI")
						:WaitForChild("Dialogue")
						:WaitForChild("ScrollingFrame")
						:WaitForChild("AvailableQuests").MouseButton1Click
				)
			)
		do
			v:Fire()
		end
		task.wait(0.2)
		for _, v in
			ipairs(
				getconnections(
					game.Players.LocalPlayer.PlayerGui
						:WaitForChild("GameUI")
						:WaitForChild("Dialogue")
						:WaitForChild("ScrollingFrame")
						:WaitForChild("1").MouseButton1Click
				)
			)
		do
			v:Fire()
		end
		task.wait(0.2)
		for _, v in
			ipairs(
				getconnections(
					game.Players.LocalPlayer.PlayerGui
						:WaitForChild("GameUI")
						:WaitForChild("Dialogue")
						:WaitForChild("ScrollingFrame")
						:WaitForChild("Accept").MouseButton1Click
				)
			)
		do
			v:Fire()
		end

		killSouls()

		game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = agorRoot.CFrame

		repeat
			fireproximityprompt(agorProximityPrompt)
			task.wait(0.1)
		until game.Players.LocalPlayer.PlayerGui:WaitForChild("GameUI"):WaitForChild("Dialogue").Visible
		task.wait(0.5)
		for _, v in
			ipairs(
				getconnections(
					game:GetService("Players").LocalPlayer.PlayerGui
						:WaitForChild("GameUI")
						:WaitForChild("Dialogue")
						:WaitForChild("ScrollingFrame")
						:WaitForChild("ActiveQuest").MouseButton1Click
				)
			)
		do
			v:Fire()
		end
		task.wait(0.2)
		for _, v in
			ipairs(
				getconnections(
					game:GetService("Players").LocalPlayer.PlayerGui
						:WaitForChild("GameUI")
						:WaitForChild("Dialogue")
						:WaitForChild("ScrollingFrame")
						:WaitForChild("Defeat Strong Souls").MouseButton1Click
				)
			)
		do
			v:Fire()
		end
		task.wait(0.2)
		for _, v in
			ipairs(
				getconnections(
					game:GetService("Players").LocalPlayer.PlayerGui
						:WaitForChild("GameUI")
						:WaitForChild("Dialogue")
						:WaitForChild("ScrollingFrame")
						:WaitForChild("Turn In Quest").MouseButton1Click
				)
			)
		do
			v:Fire()
		end
		task.wait(1)
	end
end

local tptoitems = false
local notifyitems = false

local loopthread = nil

local Quest1Toggle = Tab:CreateToggle({
	Name = "Farm Quest (Level 65+)",
	CurrentValue = false,
	Callback = function(Value)
		if Value then
			loopthread = task.spawn(questloop)
		else
			task.cancel(loopthread)
			loopthread = nil
		end
	end,
})

cleanupmaid:GiveTask(function()
	tptoitems = false
	notifyitems = false
end)

workspace
	:WaitForChild("Spawn")
	:WaitForChild("Blocktal Grounds")
	:WaitForChild("Instances").ChildAdded
	:Connect(function(c)
		if c:IsA("Model") and c.PrimaryPart then
			task.wait(1.5)
			if tptoitems then
				if loopthread then
					repeat
						task.wait()
					until coroutine.isyieldable(loopthread)
					coroutine.yield(loopthread)
				end
				game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = c.PrimaryPart.CFrame + Vector3.new(0, 0, 5)
				workspace.CurrentCamera.CFrame =
					CFrame.lookAt(workspace.CurrentCamera.CFrame.Position, c.PrimaryPart.CFrame.Position)

				for i, v in ipairs(c:GetDescendants()) do
					if v:IsA("ClickDetector") then
						task.wait(0.1)
						fireclickdetector(v)
					end
				end

				if loopthread then
					coroutine.resume(loopthread)
				end
			end
			if notifyitems then
				ArrayField:Notify({
					Title = "New Item Spawned",
					Content = c.Name,
					Duration = 6.5,
					Image = 4483362458,
					Actions = {
						Accept = {
							Name = "Teleport",
							Callback = function()
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = c.PrimaryPart.CFrame
							end,
						},
						Accept2 = {
							Name = "Teleport & Click",
							Callback = function()
								game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = c.PrimaryPart.CFrame
									+ Vector3.new(0, 0, 5)
								workspace.CurrentCamera.CFrame = CFrame.lookAt(
									workspace.CurrentCamera.CFrame.Position,
									c.PrimaryPart.CFrame.Position
								)

								for i, v in ipairs(c:GetDescendants()) do
									if v:IsA("ClickDetector") then
										task.wait(0.1)
										fireclickdetector(v)
									end
								end
							end,
						},
					},
				})
			end
		end
	end)

local ItemSpawn = Tab:CreateToggle({
	Name = "TP & Auto Click Spawned Items",
	CurrentValue = false,
	Callback = function(Value)
		tptoitems = Value
	end,
})

local NotifyItemSpawn = Tab:CreateToggle({
	Name = "Notify Item Spawn",
	CurrentValue = false,
	Callback = function(Value)
		notifyitems = Value
	end,
})

local DestroyButton = Tab:CreateButton({
	Name = "Destroy",
	Callback = function()
		cleanupmaid:DoCleaning()
	end,
})
