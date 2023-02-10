local Inviter = loadstring(game:HttpGet("https://raw.githubusercontent.com/RegularVynixu/Utilities/main/Discord%20Inviter/Source.lua"))()

--[[
Inviter.Prompt({
    name = "Kya-Ware Community",
    invite = "kyaware",
})
--]]

Inviter.Join("kyaware")

setclipboard("discord.gg/kyaware")
game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "Kya-Ware | ERROR";
	Text = "Kya-Ware is not updated for the latest version. Be patient and wait for an update. Join our discord for update announcements: discord.gg/kyaware";
	Duration = math.huge;
	Button1 = "Alright!";
})
