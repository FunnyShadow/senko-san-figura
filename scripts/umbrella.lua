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
	Umbrella.IsUsing = (player:isInRain() or Umbrella.AlwaysUse) and not player:isUnderwater() and activeItem.id ~= "minecraft:bow" and activeItem.id ~= "minecraft:crossbow" and (mainHeldItem.id ~= "minecraft:crossbow" or mainHeldItem.tag["Charged"] == 0) and not player:getVehicle() and playerPose ~= "FALL_FLYING" and playerPose ~= "SWIMMING" and player:getHeldItem(true).id == "minecraft:air" and Umbrella.Enabled
	local umbrella = models.models.main.Avatar.Body.UmbrellaB
	local rightArm = models.models.main.Avatar.Body.Arms.RightArm
	local leftArm = models.models.main.Avatar.Body.Arms.LeftArm
	if Umbrella.IsUsing then
		if not Umbrella.IsUsingPrev and Umbrella.Sound then
			sounds:playSound("minecraft:entity.bat.takeoff", player:getPos(), 0.5, 1.5)
		end
		if player:isLeftHanded() then
			rightArm:setParentType("Body")
			leftArm:setParentType("LeftArm")
			umbrella:setPos(5.5)
			animations["models.main"]["sit_down_right_umbrella"]:setPlaying(SitDown.IsAnimationPlaying)
		else
			leftArm:setParentType("Body")
			rightArm:setParentType("RightArm")
			umbrella:setPos(-5.5)
			animations["models.main"]["sit_down_left_umbrella"]:setPlaying(SitDown.IsAnimationPlaying)
		end
		umbrella:setVisible(true)
	else
		if Umbrella.IsUsingPrev and Umbrella.Sound then
			sounds:playSound("minecraft:entity.bat.takeoff", player:getPos(), 0.5, 1.5)
		end
		rightArm:setParentType("RightArm")
		leftArm:setParentType("LeftArm")
		for _, animationName in ipairs({"sit_down_right_umbrella", "sit_down_left_umbrella"}) do
			animations["models.main"][animationName]:stop()
		end
		umbrella:setVisible(false)
	end
	Umbrella.IsUsingPrev = Umbrella.IsUsing
end)


return Umbrella