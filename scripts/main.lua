events.ENTITY_INIT:register(function ()
	--クラスのインスタンス化
	General = require("scripts/general")
	LanguageClass = require("scripts/language")
	NameplateClass = require("scripts/nameplate")

	--パーツ別クラス
	LegsClass = require("scripts/legs")
	FacePartsClass = require("scripts/face_parts")
	TailClass = require("scripts/tail")
	EarsClass = require("scripts/ears")

	--機能別クラス
	HurtClass = require("scripts/hurt")
	ActionWheelClass = require("scripts/action_wheel")
	SitDownClass = require("scripts/sit_down")
	EarpickClass = require("scripts/earpick")
	SleepClass = require("scripts/sleep")

	--初期化処理
	for _, vanillaModel in ipairs({vanilla_model.PLAYER, vanilla_model.ARMOR}) do
		vanillaModel:setVisible(false)
	end
	for _, modelPart in ipairs({models.models.main.Avatar.Body.BodyBottom, models.models.main.Avatar.Body.BodyBottom.Legs.RightLeg.RightLegBottom, models.models.main.Avatar.Body.BodyBottom.Legs.LeftLeg.LeftLegBottom, models.models.main.Avatar.RightArm.RightArmBottom, models.models.main.Avatar.LeftArm.LeftArmBottom}) do
		modelPart:setParentType("None")
	end
end)