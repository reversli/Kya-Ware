-- dont mind this very ugly code and obviously skidded from tsg.lua. WE GOT PERMISSION (kind of). DM me on discord: qxkya#6909. if you have any better way of getting the remotes.

getgenv().remotes = {
   meleeAnimal = game:GetService("ReplicatedStorage").remoteInterface.interactions.meleeAnimal,
   take = game:GetService("ReplicatedStorage").remoteInterface.inventory.take,
   pickupItem = game:GetService("ReplicatedStorage").remoteInterface.inventory.pickupItem,
   plant = game:GetService("ReplicatedStorage").remoteInterface.interactions.plant,
   harvest = game:GetService("ReplicatedStorage").remoteInterface.interactions.harvest,
}

function getFunctionName(x)
   return debug.getinfo and debug.getinfo(x).name or debug.info and debug.info(x, "n")
end

for i, v in pairs(game.Players.LocalPlayer.PlayerGui.client.client:GetChildren()) do
   if i == 2 then
      v.Name = "meleePlayer"
   elseif i == 4 then
      v.Name = "chop"
   elseif i == 5 then
      v.Name = "mine"
   elseif i == 6 then
      v.Name = "hitStructure"
   end
end

local function shallowClone(tab)
   if not tab then
      return
   end
   local t = {}
   for i, v in next, tab do
      t[i] = v
   end
   return t
end

function findInFiOne(tab, typeOf, checkFunc)
   for i,v in next, tab do
      if type(v) == "table" then
         local value = rawget(v, "value")
         if typeof(value) == typeOf and checkFunc(value) then
            return value
         end

         for i2, v2 in next, v do
            if typeof(v2) == "table" then
               local value = rawget(v2, "value")
               if typeof(value) == typeOf and checkFunc(value) then
                  return value
               end
            end
         end
      end
   end
end

local codes = {}
local consts = {}

local upvals = {}
function getFiOneConstants(func)
   local upval
   if upvals[func] then
      upval = upvals[func]
      warn("found")
   else
      upval = debug.getupvalues(func)[1]
   end
   if typeof(upval) == "table" then
      local consts = rawget(upval, "const")
      if typeof(consts) == "table" then
         return consts
      end
   end
end

function getFiOneCode(func)
   local upval
   if upvals[func] then
      upval = upvals[func]
      warn("found")
   else
      upval = debug.getupvalues(func)[1]
   end
   if typeof(upval) == "table" then
      local code = rawget(upval, "code")
      if typeof(code) == "table" then
         return code
      end
   end
end

local FiOne = game.ReplicatedStorage:FindFirstChild("FiOne", true)
for i, v in next, getgc(true) do
   if typeof(v) == "table" then
      for _, v2 in next, v do
         if typeof(v2) == "function" then
            local consts = getFiOneConstants(v2)
            local found = consts and (table.find(consts, "FireServer") or table.find(consts, "InvokeServer"))

            if found then
               local upvals = debug.getupvalues(v2)
               local remote = findInFiOne(upvals, "Instance", function(x)
               return x:IsA("RemoteEvent") or x:IsA("RemoteFunction")
               end)

               if remote then
                  local code = getFiOneCode(v2)
                  local tab = shallowClone(v)
                  tab.FireServer = v2
                  table.remove(tab, table.find(tab, v2))
                  getgenv().remotes[remote.Name] = tab
               end
            end
         end
      end
   end

   if typeof(v) == "function" and getFunctionName(v) == "on_lua_error" then
      hookfunction(v, function() end)
   end
end

getgenv().savedRemotes = remotes
