---@class EarsClass けも耳を制御するクラス
---@field EyeTypeID table EarsRotTupeと角度を紐付けるテーブル
---@field EarsRotCount integer 耳の角度を変更するの時間を計るカウンター
---@field JerkEarsKey Keybind 耳を動かすキー
---@field JerkEarsCount integer 耳を動かす時間を計るカウンター

---@alias EarsRotType
---| "STAND"
---| "SLIGHTLY_DROOPING"
---| "DROOPING"

EarsClass = {}

EarsRotTypeID = {STAND = 0, SLIGHTLY_DROOPING = -20, DROOPING = -40}
EarsRotCount = 0
JerkEarsKey = keybind:create(LanguageClass.getTranslate("key_name__jerk_ears"), "key.keyboard.x")
JerkEarsCount = 0

---耳の角度を決定する。
---@param earRot EarsRotType 設定する耳の垂れ具合
---@param duration integer この耳の角度をを有効にする時間
---@param force boolean trueにすると以前のタイマーが残っていても強制的に適用する。
function EarsClass.SetEarsRot(earRot, duration, force)
	if EarsRotCount == 0 or force then
		models.models.main.Avatar.Head.Ears:setRot(EarsRotTypeID[earRot], 0, 0)
		EarsRotCount = duration
	end
end

--ping関数
function pings.jerk_ears()
	General.setAnimations("PLAY", "jerk_ears")
	WagTailCount = 5
end

events.TICK:register(function ()
	if EarsRotCount == 0 then
		EarsClass.SetEarsRot((General.PlayerCondition == "LOW" or player:getFrozenTicks() == 140) and "DROOPING" or (General.PlayerCondition == "MEDIUM" and "SLIGHTLY_DROOPING" or "STAND"), 0, false)
	end
	EarsRotCount = EarsRotCount > 0 and (client:isPaused() and EarsRotCount or EarsRotCount - 1) or 0
	JerkEarsCount = JerkEarsCount > 0 and (client:isPaused() and JerkEarsCount or JerkEarsCount - 1) or 0
end)

JerkEarsKey.onPress = function ()
	if JerkEarsCount == 0 then
		pings.jerk_ears()
	end
end

return EarsClass