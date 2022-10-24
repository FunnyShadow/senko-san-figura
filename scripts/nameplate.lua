---@class NameplateClass ネームプレート（プレイヤーの名前）を制御するクラス
---@field NameplateClass.NameList table 利用可能な名前のリスト

NameplateClass = {}

NameplateClass.NameList = {player:getName(), "Senko", "仙狐", "Senko_san", "仙狐さん"}

---プレイヤーの表示名を設定する。
---@param nameID integer 新しい表示名
function NameplateClass.setName(nameID)
	nameplate.ALL:setText(NameplateClass.NameList[nameID])
end

events.TICK:register(function()
	if animations["models.main"]["sit_down"]:getPlayState() == "PLAYING" then
		nameplate.ENTITY:setPos(0, -0.5, 0)
	else
		nameplate.ENTITY:setPos(0, 0, 0)
	end
end)

if ConfigClass.DefaultName >= 2 then
	NameplateClass.setName(ConfigClass.DefaultName)
end
nameplate.ENTITY:setBackgroundColor(233 / 255, 160 / 255, 70 / 255)
nameplate.ENTITY.shadow = true

return NameplateClass