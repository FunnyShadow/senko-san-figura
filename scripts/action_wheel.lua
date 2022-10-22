---@class ActionWheelClass アクションホイールを制御するクラス
---@field MainPage table アクションホイールのメインページ
---@field WordPages Page セリフ一覧のページ
---@field IsOpenWordPages boolean セリフ一覧のページを開いているかどうか
---@field CurrentWordLanguage integer 現在のセリフの言語
---@field ActionWheelClass.ActionCount integer アクション再生中は0より大きくなるカウンター
---@field ActionCancelFunction function 現在再生中のアクションをキャンセルする処理
---@field IsOpenActionWheelPrev boolean 前チックにアクションホイールを開けていたかどうか
---@field ShakeSplashCount integer ブルブル時の水しぶきを出すタイミングを計るカウンター
---@field SweatCount integer 汗のタイミングを計るカウンター
---@field CurrentPlayerNameState integer プレイヤーの現在の表示名の状態を示す：0. プレイヤー名, 1. Senko_san, 2. 仙狐さん
---@field PlayerNameState integer プレイヤーの表示名の状態を示す：0. プレイヤー名, 1. Senko_san, 2. 仙狐さん
---@field IsSynced boolean アバターの設定がホストと同期されたかどうか
---@field NextSyncCount integer 次の同期pingまでのカウンター

ActionWheelClass = {}

MainPages = {}
WordPages = action_wheel:createPage()
IsOpenWordPages = false
CurrentWordLanguage = LanguageClass.ActiveLanguage
ActionWheelClass.ActionCount = 0
ActionCancelFunction = nil
IsOpenActionWheelPrev = false
ShakeSplashCount = 0
SweatCount = 0
CurrentCostumeState = ConfigClass.DefaultCostume
CostumeState = ConfigClass.DefaultCostume
CurrentPlayerNameState = ConfigClass.DefaultName
PlayerNameState = ConfigClass.DefaultName
IsSynced = host:isHost()
NextSyncCount = 300

---アニメーションが再生中かどうかを返す
---@param modelName string モデル名
---@param animationName string アニメーションが名
---@return boolean
function isAnimationPlaying(modelName, animationName)
	return animations[modelName][animationName]:getPlayState() == "PLAYING"
end

---アクションの色の有効色/無効色の切り替え
---@param pageNumber integer メインアクションのページ番号
---@param actionNumber integer pageNumber内のアクションの番号
---@param enabled boolean 有効色か無効色か
function setActionEnabled(pageNumber, actionNumber, enabled)
	if enabled then
		MainPages[pageNumber]:getAction(actionNumber):title(LanguageClass.getTranslate("action_wheel__main_"..pageNumber.."__action_"..actionNumber.."__title")):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1)
	else
		MainPages[pageNumber]:getAction(actionNumber):title("§7"..LanguageClass.getTranslate("action_wheel__main_"..pageNumber.."__action_"..actionNumber.."__title")):color(42 / 255, 42 / 255, 42 / 255):hoverColor(1, 85 / 255, 85 / 255)
	end
end

---アクションを実行する。
---@param action function 実行するアクションの関数
---@param actionCancelFunction function アクションのキャンセル処理の関数
---@param ignoreCooldown boolean アニメーションのクールダウンを無視するかどうか
function runAction(action, actionCancelFunction, ignoreCooldown)
	if ActionWheelClass.ActionCount == 0 or ignoreCooldown then
		action()
		ActionCancelFunction = actionCancelFunction
	end
end

---ブルブル
---@param snow boolean アニメーションの際に雪のパーティクルを表示させるかどうか
function ActionWheelClass.bodyShake(snow)
	ActionCancelFunction = function()
		General.setAnimations("STOP", "shake")
		ShakeSplashCount = 0
	end
	General.setAnimations("PLAY", "shake")
	sounds:playSound("minecraft:entity.wolf.shake", player:getPos(), 1, 1.5)
	FacePartsClass.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 20, true)
	if WetClass.WetCount > 0 and not player:isWet() then
		ShakeSplashCount = 20
		WetClass.WetCount = 20
	elseif snow then
		ShakeSplashCount = -20
	end
	ActionWheelClass.ActionCount = 20
end

--ping関数
function pings.syncAvatarSetting(nameID, costumeID, autoShake, hideArmor)
	if not IsSynced then
		CurrentPlayerNameState = nameID
		CurrentCostumeState = costumeID
		NameplateClass.setName(CurrentPlayerNameState == 1 and player:getName() or (CurrentPlayerNameState == 2 and "Senko_san" or "仙狐さん"))
		if CurrentCostumeState == 0 then
			CostumeClass.resetCostume()
		else
			CostumeClass.setCostume(string.upper(CostumeClass.CostumeList[CurrentCostumeState]))
		end
		WetClass.AutoShake = autoShake
		ArmorClass.HideArmor = hideArmor
		IsSynced = true
	end
end

function pings.refuse_emote()
	General.setAnimations("PLAY", "refuse_emote")
	FacePartsClass.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 30, true)
	ActionCancelFunction = nil
	ActionWheelClass.ActionCount = 30
	SweatCount = 30
	if host:isHost() then
		print("§7"..LanguageClass.getTranslate("action_wheel__refuse_action"))
	end
end

function pings.main1_action1_left()
	runAction(function ()
		BroomCleaningClass.play()
		ActionWheelClass.ActionCount = 168
	end, function ()
		BroomCleaningClass.stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.main1_action1_left_alt()
	runAction(function ()
		VacuumCleaningClass.play()
		ActionWheelClass.ActionCount = 281
	end, function ()
		VacuumCleaningClass.stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.main1_action1_right()
	runAction(function ()
		ClothCleaningClass.play()
		ActionWheelClass.ActionCount = 198
	end, function ()
		ClothCleaningClass.stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.main1_action2()
	runAction(function ()
		HairCutClass.play()
		ActionWheelClass.ActionCount = 488
	end, function ()
		HairCutClass.stop()
		ActionWheelClass.ActionCount = 0
	end)
end

function pings.main1_action3()
	runAction(function ()
		FoxJumpClass.play()
		ActionWheelClass.ActionCount = 124
	end, function ()
		FoxJumpClass.stop()
		ActionWheelClass.ActionCount = 0
	end)
end

function pings.main1_action4()
	runAction(function()
		ActionWheelClass.bodyShake(false)
	end, function()
		General.setAnimations("STOP", "shake")
		ShakeSplashCount = 0
	end, false)
end

function pings.main2_action1_toggle()
	runAction(function ()
		SitDownClass.sitDown()
	end, nil, true)
end

function pings.main2_action1_untoggle()
	SitDownClass.standUp()
end

function pings.main2_action2()
	runAction(function ()
		TailCuddlingClass.play()
		ActionWheelClass.ActionCount = 380
	end, function ()
		TailCuddlingClass.stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.main2_action3()
	runAction(function ()
		EarpickClass.play()
		ActionWheelClass.ActionCount = 238
	end, function ()
		EarpickClass.stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.main2_action4()
	runAction(function ()
		TeaTimeClass.play()
		ActionWheelClass.ActionCount = 250
	end, function ()
		TeaTimeClass.stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.main2_action5()
	runAction(function ()
		MassaseClass.play()
		ActionWheelClass.ActionCount = 426
	end, function ()
		MassaseClass.stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.main3_action1(costumeID)
	if costumeID == 1 then
		CostumeClass.resetCostume()
	else
		CostumeClass.setCostume(string.upper(CostumeClass.CostumeList[costumeID]))
	end
	CurrentCostumeState = costumeID
end

function pings.main3_action2(nameID)
	NameplateClass.setName(nameID == 1 and player:getName() or (nameID == 2 and "Senko_san" or "仙狐さん"))
	CurrentPlayerNameState = nameID
end

function pings.main3_action3_toggle()
	WetClass.AutoShake = true
end

function pings.main3_action3_untoggle()
	WetClass.AutoShake = false
end

function pings.main3_action4_toggle()
	ArmorClass.HideArmor = true
end

function pings.main3_action4_untoggle()
	ArmorClass.HideArmor = false
end

events.TICK:register(function ()
	for i = 1, 2 do
		setActionEnabled(1, i, ActionWheelClass.ActionCount == 0 and BroomCleaningClass.CanBroomCleaning)
	end
	setActionEnabled(1, 3, ActionWheelClass.ActionCount == 0 and FoxJumpClass.CanFoxJump)
	setActionEnabled(1, 4, ActionWheelClass.ActionCount == 0 and not WardenClass.WardenNearby)
	setActionEnabled(2, 1, ActionWheelClass.ActionCount == 0 and SitDownClass.CanSitDown)
	setActionEnabled(2, 2, ActionWheelClass.ActionCount == 0 and TailCuddlingClass.CanCuddleTail)
	for i = 3, 5 do
		setActionEnabled(2, i, isAnimationPlaying("models.main", "sit_down") and ActionWheelClass.ActionCount == 0 and not WardenClass.WardenNearby)
	end
	local sitDownAction = MainPages[2]:getAction(1)
	sitDownAction:toggled((ActionWheelClass.ActionCount == 0 or isAnimationPlaying("models.main", "earpick") or isAnimationPlaying("models.main", "tea_time") or isAnimationPlaying("models.main", "massage") or (isAnimationPlaying("models.main", "sit_down") and isAnimationPlaying("models.main", "shake"))) and SitDownClass.CanSitDown and sitDownAction:isToggled())
	if ActionWheelClass.ActionCount > 0 then
		if (HurtClass.Damaged ~= "NONE" and ActionWheelClass.ActionCount > 0 and WardenClass.WardenNearby) or ((isAnimationPlaying("models.main", "earpick") or isAnimationPlaying("models.main", "tea_time") or isAnimationPlaying("models.main", "massage")) and not isAnimationPlaying("models.main", "sit_down")) or (isAnimationPlaying("models.main", "tail_cuddling") and not TailCuddlingClass.CanCuddleTail) or ((isAnimationPlaying("models.main", "broom_cleaning") or isAnimationPlaying("models.main", "vacuum_cleaning") or isAnimationPlaying("models.main", "cloth_cleaning") or isAnimationPlaying("models.main", "hair_cut")) and not BroomCleaningClass.CanBroomCleaning) or (isAnimationPlaying("models.main", "fox_jump") and not FoxJumpClass.CanFoxJump) then
			ActionCancelFunction();
			ActionWheelClass.ActionCount = 0
		end
	end
	local isOpenActionWheel = action_wheel:isEnabled()
	if host:isHost() then
		if not isOpenActionWheel and IsOpenActionWheelPrev then
			if CostumeState ~= CurrentCostumeState then
				pings.main3_action1(CostumeState)
				sounds:playSound("minecraft:item.armor.equip_leather", player:getPos())
				print(LanguageClass.getTranslate("action_wheel__main_3__action_2__done_first")..LanguageClass.getTranslate("costume__"..CostumeClass.CostumeList[CostumeState])..LanguageClass.getTranslate("action_wheel__main_3__action_2__done_last"))
			end
			if PlayerNameState ~= CurrentPlayerNameState then
				pings.main3_action2(PlayerNameState)
				sounds:playSound("minecraft:ui.cartography_table.take_result", player:getPos(), 1, 1)
				print(LanguageClass.getTranslate("action_wheel__main_3__action_3__done_first")..(PlayerNameState == 1 and player:getName() or (PlayerNameState == 2 and "Senko_san" or "仙狐さん"))..LanguageClass.getTranslate("action_wheel__main_3__action_3__done_last"))
			end
			if IsOpenWordPages then
				action_wheel:setPage(MainPages[3])
				IsOpenWordPages = false
			end
		end
		if NextSyncCount == 0 then
			pings.syncAvatarSetting(CurrentPlayerNameState, CurrentCostumeState, WetClass.AutoShake, ArmorClass.HideArmor)
			NextSyncCount = 300
		elseif not client:isPaused() then
			NextSyncCount = NextSyncCount - 1
		end
	end
	if ShakeSplashCount > 0 then
		if ShakeSplashCount % 5 == 0 then
			for _ = 1, 4 do
				particles:addParticle("minecraft:splash", player:getPos():add(math.random() - 0.5, math.random() + 0.5, math.random() - 0.5))
			end
		end
		ShakeSplashCount = ShakeSplashCount - 1
	elseif ShakeSplashCount < 0 then
		if ShakeSplashCount % 5 == 0 then
			for _ = 1, 6 do
				particles:addParticle("minecraft:block minecraft:snow_block", player:getPos():add(math.random() - 0.5, math.random() + 0.5, math.random() - 0.5))
			end
		end
		ShakeSplashCount = ShakeSplashCount + 1
	end
	if SweatCount > 0 then
		if SweatCount % 5 == 0 then
			for _ = 1, 4 do
				particles:addParticle("minecraft:splash", player:getPos():add(0, 2, 0))
			end
		end
		SweatCount = SweatCount - 1
	end
	ActionWheelClass.ActionCount = ActionWheelClass.ActionCount > 0 and ActionWheelClass.ActionCount - 1 or ActionWheelClass.ActionCount
	IsOpenActionWheelPrev = isOpenActionWheel
end)

for _ = 1, 3 do
	table.insert(MainPages, action_wheel:createPage())
end

--メインページのアクション設定
--アクション1-1. お掃除
MainPages[1]:newAction(1):item("amethyst_shard"):onLeftClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if BroomCleaningClass.CanBroomCleaning then
			if math.random() > 0.9 then
				pings.main1_action1_left_alt()
			else
				pings.main1_action1_left()
			end
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_1__unavailable"))
		end
	end
end):onRightClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if BroomCleaningClass.CanBroomCleaning then
			pings.main1_action1_right()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_1__unavailable"))
		end
	end
end)

--アクション1-2. 散髪
MainPages[1]:newAction(2):item("shears"):onLeftClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if BroomCleaningClass.CanBroomCleaning then
			pings.main1_action2()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_2__unavailable"))
		end
	end
end)

--アクション1-3. キツネジャンプ
MainPages[1]:newAction(3):item("snow_block"):onLeftClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if FoxJumpClass.CanFoxJump then
			pings.main1_action3()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_3__unavailable"))
		end
	end
end)

--アクション1-4. ブルブル
MainPages[1]:newAction(4):item("water_bucket"):onLeftClick(function()
	if ActionWheelClass.ActionCount == 0 then
		if WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			pings.main1_action4()
		end
	end
end)

--アクション2-1. おすわり（正座）
MainPages[2]:newToggle(1):toggleColor(233 / 255, 160 / 255, 69 / 255):item("oak_stairs"):onToggle(function ()
	if ActionWheelClass.ActionCount == 0 then
		if SitDownClass.CanSitDown then
			pings.main2_action1_toggle()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_2__action_1__unavailable"))
		end
	end
end):onUntoggle(function ()
	pings.main2_action1_untoggle()
end)

--アクション2-2. 尻尾モフモフ
MainPages[2]:newAction(2):item("yellow_wool"):onLeftClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if TailCuddlingClass.CanCuddleTail then
			pings.main2_action2()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_2__action_2__unavailable"))
		end
	end
end)

--アクション2-3. 耳かき
MainPages[2]:newAction(3):item("feather"):onLeftClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if isAnimationPlaying("models.main", "sit_down") then
			pings.main2_action3()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_2__action_3__unavailable"))
		end
	end
end)

--アクション2-4. ティータイム
MainPages[2]:newAction(4):item("flower_pot"):onLeftClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if isAnimationPlaying("models.main", "sit_down") then
			pings.main2_action4()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_2__action_4__unavailable"))
		end
	end
end)

--アクション2-5. マッサージ
MainPages[2]:newAction(5):item("yellow_bed"):onLeftClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if isAnimationPlaying("models.main", "sit_down") then
			pings.main2_action5()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_2__action_5__unavailable"))
		end
	end
end)

--アクション3-1. 仙狐さんセリフ集
MainPages[3]:newAction(1):title(LanguageClass.getTranslate("action_wheel__main_3__action_1__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	IsOpenWordPages = true
	action_wheel:setPage(WordPages)
end)

--アクション3-2. 着替え
MainPages[3]:newScroll(2):title(LanguageClass.getTranslate("action_wheel__main_3__action_2__title").."§b"..LanguageClass.getTranslate("costume__"..CostumeClass.CostumeList[CostumeState])):item("leather_chestplate"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
	if direction == -1 then
		CostumeState = CostumeState == #CostumeClass.CostumeList and 1 or CostumeState + 1
	else
		CostumeState = CostumeState == 1 and #CostumeClass.CostumeList or CostumeState - 1
	end
	MainPages[3]:getAction(2):title(LanguageClass.getTranslate("action_wheel__main_3__action_2__title").."§b"..LanguageClass.getTranslate("costume__"..CostumeClass.CostumeList[CostumeState]))
end)

--アクション3-3. プレイヤーの表示名変更
MainPages[3]:newScroll(3):title(LanguageClass.getTranslate("action_wheel__main_3__action_3__title").."§b"..(PlayerNameState == 1 and player:getName() or (PlayerNameState == 2 and "Senko_san" or "仙狐さん"))):item("name_tag"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
	if direction == -1 then
		PlayerNameState = PlayerNameState == 3 and 1 or PlayerNameState + 1
	else
		PlayerNameState = PlayerNameState == 1 and 3 or PlayerNameState - 1
	end
	MainPages[3]:getAction(3):title(LanguageClass.getTranslate("action_wheel__main_3__action_3__title").."§b"..(PlayerNameState == 1 and player:getName() or (PlayerNameState == 2 and "Senko_san" or "仙狐さん")))
end)

--アクション3-4. 自動ブルブル
MainPages[3]:newToggle(4):title(LanguageClass.getTranslate("action_wheel__main_3__action_4__title")..LanguageClass.getTranslate("action_wheel__toggle_off")):toggleTitle(LanguageClass.getTranslate("action_wheel__main_3__action_4__title")..LanguageClass.getTranslate("action_wheel__toggle_on")):item("water_bucket"):color(170 / 255, 0, 0):hoverColor(1, 85 / 255, 85 / 255):toggleColor(0, 170 / 255, 0):onToggle(function ()
	pings.main3_action3_toggle()
	MainPages[3]:getAction(4):hoverColor(85 / 255, 1, 85 / 255)
end):onUntoggle(function ()
	pings.main3_action3_untoggle()
	MainPages[3]:getAction(4):hoverColor(1, 85 / 255, 85 / 255)
end)
if ConfigClass.AutoShake then
	local action = MainPages[3]:getAction(4)
	action:toggled(ConfigClass.AutoShake)
	action:hoverColor(85 / 255, 1, 85 / 255)
end

--アクション3-5. 防具の非表示
MainPages[3]:newToggle(5):title(LanguageClass.getTranslate("action_wheel__main_3__action_5__title")..LanguageClass.getTranslate("action_wheel__toggle_off")):toggleTitle(LanguageClass.getTranslate("action_wheel__main_3__action_5__title")..LanguageClass.getTranslate("action_wheel__toggle_on")):item("iron_chestplate"):color(170 / 255, 0, 0):hoverColor(1, 85 / 255, 85 / 255):toggleColor(0, 170 / 255, 0):onToggle(function ()
	pings.main3_action4_toggle()
	MainPages[3]:getAction(5):hoverColor(85 / 255, 1, 85 / 255)
end):onUntoggle(function ()
	pings.main3_action4_untoggle()
	MainPages[3]:getAction(5):hoverColor(1, 85 / 255, 85 / 255)
end)
if ConfigClass.HideArmor then
	local action = MainPages[3]:getAction(5)
	action:toggled(ConfigClass.HideArmor)
	action:hoverColor(85 / 255, 1, 85 / 255)
end

--アクション8（共通）. ページ切り替え
for index, mainPage in ipairs(MainPages) do
	mainPage:newScroll(8):title(LanguageClass.getTranslate("action_wheel__main__action_8__title")..index.."/"..#MainPages):item("arrow"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
		if MainPages[index - direction] then
			action_wheel:setPage(MainPages[index - direction])
		elseif index == 1 then
			action_wheel:setPage(MainPages[#MainPages])
		else
			action_wheel:setPage(MainPages[1])
		end
	end)
end

--セリフのページのアクション設定
--アクション1. 「存分に甘やかしてくれよう！」
WordPages:newAction(1):title(LanguageClass.getTranslate("action_wheel__word__action_1__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	host:sendChatMessage(LanguageClass.getTranslateWithLang("action_wheel__word__action_1__title", CurrentWordLanguage))
end)

--アクション2. 「存分にもふるがよい」
WordPages:newAction(2):title(LanguageClass.getTranslate("action_wheel__word__action_2__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	host:sendChatMessage(LanguageClass.getTranslateWithLang("action_wheel__word__action_2__title", CurrentWordLanguage))
end)

--アクション3. 「おかえりなのじゃ」
WordPages:newAction(3):title(LanguageClass.getTranslate("action_wheel__word__action_3__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	host:sendChatMessage(LanguageClass.getTranslateWithLang("action_wheel__word__action_3__title", CurrentWordLanguage))
end)

--アクション4. 「お疲れ様じゃ」
WordPages:newAction(4):title(LanguageClass.getTranslate("action_wheel__word__action_4__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	host:sendChatMessage(LanguageClass.getTranslateWithLang("action_wheel__word__action_4__title", CurrentWordLanguage))
end)

--アクション5. 「今日も大変だったのう」
WordPages:newAction(5):title(LanguageClass.getTranslate("action_wheel__word__action_5__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	host:sendChatMessage(LanguageClass.getTranslateWithLang("action_wheel__word__action_5__title", CurrentWordLanguage))
end)

--アクション6. 「うやん♪」
WordPages:newAction(6):title(LanguageClass.getTranslate("action_wheel__word__action_6__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	host:sendChatMessage(LanguageClass.getTranslateWithLang("action_wheel__word__action_6__title", CurrentWordLanguage))
end)

--アクション7. 「わらわはただの動く毛玉じゃ...」
WordPages:newAction(7):title(LanguageClass.getTranslate("action_wheel__word__action_7__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	host:sendChatMessage(LanguageClass.getTranslateWithLang("action_wheel__word__action_7__title", CurrentWordLanguage))
end)

--アクション8. 言語切り替え
WordPages:newScroll(8):title(LanguageClass.getTranslate("action_wheel__word__action_8__title")..LanguageClass.getTranslate("language__"..LanguageClass.LanguageList[LanguageClass.ActiveLanguage])):item("paper"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
	if LanguageClass.LanguageList[CurrentWordLanguage - direction] then
		CurrentWordLanguage = CurrentWordLanguage - direction
	elseif CurrentWordLanguage == 1 then
		CurrentWordLanguage = #LanguageClass.LanguageList
	else
		CurrentWordLanguage = 1
	end
	for i = 1, 7 do
		WordPages:getAction(i):title(CurrentWordLanguage == LanguageClass.ActiveLanguage and LanguageClass.getTranslateWithLang("action_wheel__word__action_"..i.."__title", CurrentWordLanguage) or LanguageClass.getTranslateWithLang("action_wheel__word__action_"..i.."__title", CurrentWordLanguage).."\n§7"..LanguageClass.getTranslate("action_wheel__word__action_8__bracket_begin")..LanguageClass.getTranslate("action_wheel__word__action_"..i.."__title")..LanguageClass.getTranslate("action_wheel__word__action_8__bracket_end"))
	end
	WordPages:getAction(8):title(LanguageClass.getTranslate("action_wheel__word__action_8__title")..LanguageClass.getTranslate("language__"..LanguageClass.LanguageList[CurrentWordLanguage]))
end)

action_wheel:setPage(MainPages[1])

return ActionWheelClass