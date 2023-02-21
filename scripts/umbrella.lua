---@class Umbrella 傘を制御するクラス
---@field Umbrella.Enabled boolean 傘をさせるかどうか（他のクラスから操作）
---@field Umbrella.AlwaysUse boolean （傘をさせる時に）雨が降っていなくても常に傘をさすかどうか
---@field Umbrella.IsUsing boolean 傘をさしているかどうか
---@field Umbrella.IsUsingPrev boolean 前チックに傘をさしていたかどうか
---@field Umbrella.Sound boolean 傘の開閉音を再生するかどうか

Umbrella = {
	Enabled = true,
	AlwaysUse = Config.loadConfig("alwaysUmbrella", false),
	IsUsing = false,
	IsUsingPrev = false,
	Sound = Config.loadConfig("umbrellaSound", true)
}

events.TICK:register(function ()
	local playerPose = player:getPose()
	local activeItem = player:getActiveItem()
	local mainHeldItem = player:getHeldItem()
	Umbrella.IsUsing = (player:isInRain() or Umbrella.AlwaysUse or PhotoPose.CurrentPose == 7) and not player:isUnderwater() and activeItem.id ~= "minecraft:bow" and activeItem.id ~= "minecraft:crossbow" and (mainHeldItem.id ~= "minecraft:crossbow" or mainHeldItem.tag["Charged"] == 0) and not player:getVehicle() and playerPose ~= "FALL_FLYING" and playerPose ~= "SWIMMING" and player:getHeldItem(true).id == "minecraft:air" and Umbrella.Enabled
	if Umbrella.IsUsing then
		if not Umbrella.IsUsingPrev and Umbrella.Sound then
			sounds:playSound("minecraft:entity.bat.takeoff", player:getPos(), 0.5, 1.5)
		end
		if PhotoPose.CurrentPose == 0 then
			if player:isLeftHanded() then
				models.models.main.Avatar.Body.UmbrellaB:setPos(5.5)
				Arms.RightArmRotOffset = SitDown.IsAnimationPlaying and vectors.vec3(0, -10, 15) or vectors.vec3()
			else
				models.models.main.Avatar.Body.UmbrellaB:setPos(-5.5)
				Arms.LeftArmRotOffset = SitDown.IsAnimationPlaying and vectors.vec3(0, 10, -15) or vectors.vec3()
			end
		end
		models.models.main.Avatar.Body.UmbrellaB:setVisible(true)
	else
		if Umbrella.IsUsingPrev and Umbrella.Sound then
			sounds:playSound("minecraft:entity.bat.takeoff", player:getPos(), 0.5, 1.5)
			if PhotoPose.CurrentPose == 0 then
				Arms.RightArmRotOffset = vectors.vec3()
				Arms.LeftArmRotOffset = vectors.vec3()
			end
		end
		models.models.main.Avatar.Body.UmbrellaB:setVisible(false)
	end
	Umbrella.IsUsingPrev = Umbrella.IsUsing
end)


return Umbrella