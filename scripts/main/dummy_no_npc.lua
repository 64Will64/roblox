print("dummy but its not an npc apparently lmaoo")
for i,v in pairs(game.Players.LocalPlayer.Character) do
    if v:IsA("Shirt") or v:IsA("Pants") then
        v:Destroy()
    end
end
game.Players.LocalPlayer.Character.Head.Mesh:Destroy()
