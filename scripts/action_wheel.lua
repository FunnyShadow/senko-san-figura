---@class ActionWheelClass アクションホイールを制御するクラス
---@field MainPage table アクションホイールのメインページ
---@field WordPage Page セリフ一覧のページ
---@field ConfigPage Page 設定のページ
---@field IsOpenWordPage boolean セリフ集のページを開いているかどうか
---@field LanguageList table 利用可能な言語のリスト（セリフ集に使う）
---@field ParentPage Page 現在開いているページの親ページ。アクションホイールを閉じた際に設定するページ。
---@field CurrentWordLanguage integer 現在のセリフの言語
---@field ActionWheelClass.ActionCount integer アクション再生中は0より大きくなるカウンター
---@field ActionCancelFunction function 現在再生中のアクションをキャンセルする処理
---@field IsOpenActionWheelPrev boolean 前チックにアクションホイールを開けていたかどうか
---@field CanBodyShake boolean ブルブルアクションができるかどうか
---@field ShakeSplashCount integer ブルブル時の水しぶきを出すタイミングを計るカウンター
---@field SweatCount integer 汗のタイミングを計るカウンター
---@field ActionWheelClass.CurrentCostumeState integer プレイヤーの現在のコスチュームの状態を示す：1. いつもの服, 2. 変装服, 3. メイド服A, 4. メイド服B, 5. 水着, 6. チアリーダーの服, 7. 清めの服, 8. 割烹着
---@field CurrentCostumeState integer プレイヤーのコスチュームの状態を示す：1. いつもの服, 2. 変装服, 3. メイド服A, 4. メイド服B, 5. 水着, 6. チアリーダーの服, 7. 清めの服, 8. 割烹着
---@field ActionWheelClass.CurrentPlayerNameState integer プレイヤーの現在の表示名の状態を示す：1. プレイヤー名, 2. Senko, 3. 仙狐, 4. Senko_san, 5. 仙狐さん, 6. Sen, 7. 仙, 8. セン
---@field PlayerNameState integer プレイヤーの表示名の状態を示す：1. プレイヤー名, 2. Senko, 3. 仙狐, 4. Senko_san, 5. 仙狐さん, 6. Sen, 7. 仙, 8. セン
---@field IsWetPrev boolean 前チックに濡れていたかどうか

ActionWheelClass = {}

MainPages = {}
WordPage = action_wheel:newPage()
ConfigPage = action_wheel:newPage()
IsOpenWordPage = false
LanguageList = LanguageClass.getLanguages()
ParentPage = nil
CurrentWordLanguage = General.indexof(LanguageList, client:getActiveLang())
ActionWheelClass.ActionCount = 0
ActionCancelFunction = nil
IsOpenActionWheelPrev = false
CanBodyShake = false
ShakeSplashCount = 0
SweatCount = 0
ActionWheelClass.CurrentCostumeState = ConfigClass.loadConfig("costume", 1)
CostumeState = ActionWheelClass.CurrentCostumeState
ActionWheelClass.CurrentPlayerNameState = ConfigClass.loadConfig("name", 1)
PlayerNameState = ActionWheelClass.CurrentPlayerNameState
IsWetPrev = false

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
---@param ignoreCooldown boolean|nil アニメーションのクールダウンを無視するかどうか
function runAction(action, actionCancelFunction, ignoreCooldown)
	if ActionWheelClass.ActionCount == 0 or ignoreCooldown then
		action()
		ActionCancelFunction = actionCancelFunction
	end
end

---ブルブル
---@param snow boolean アニメーションの際に雪のパーティクルを表示させるかどうか
function ActionWheelClass.bodyShake(snow)
	runAction(function ()
		if ActionWheelClass.ActionCount > 0 then
			ActionCancelFunction()
		end
		General.setAnimations("PLAY", "shake")
		sounds:playSound("minecraft:entity.wolf.shake", player:getPos(), 1, 1.5)
		FacePartsClass.setEmotion("UNEQUAL", "UNEQUAL", "CLOSED", 20, true)
		if WetClass.WetCount > 0 and not WetClass.IsWet then
			ShakeSplashCount = 20
		elseif snow then
			ShakeSplashCount = -20
		end
		WetClass.WetCount = 20
		ActionWheelClass.ActionCount = 20
	end, function ()
		General.setAnimations("STOP", "shake")
		ShakeSplashCount = 0
	end, true)
end

---衣装変更のアクションの名称を変更する。
function setCostumeChangeActionTitle()
	if CostumeState == ActionWheelClass.CurrentCostumeState then
		ConfigPage:getAction(1):title(LanguageClass.getTranslate("action_wheel__config__action_1__title").."§b"..LanguageClass.getTranslate("costume__"..CostumeClass.CostumeList[CostumeState]))
	else
		ConfigPage:getAction(1):title(LanguageClass.getTranslate("action_wheel__config__action_1__title").."§b"..LanguageClass.getTranslate("costume__"..CostumeClass.CostumeList[CostumeState]).."\n§7"..LanguageClass.getTranslate("action_wheel__close_to_confirm"))
	end
end

---名前変更のアクションの名称を変更する。
function setNameChangeActionTitle()
	if PlayerNameState == ActionWheelClass.CurrentPlayerNameState then
		ConfigPage:getAction(2):title(LanguageClass.getTranslate("action_wheel__config__action_2__title").."§b"..NameplateClass.NameList[PlayerNameState])
	else
		ConfigPage:getAction(2):title(LanguageClass.getTranslate("action_wheel__config__action_2__title").."§b"..NameplateClass.NameList[PlayerNameState].."\n§7"..LanguageClass.getTranslate("action_wheel__close_to_confirm"))
	end
end

--ping関数
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
		Smile:play(false)
		ActionWheelClass.ActionCount = Smile.AnimationLength
	end, function ()
		Smile:stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.main1_action1_right()
	runAction(function ()
		Smile:play(true)
		ActionWheelClass.ActionCount = Smile.AnimationLength
	end, function ()
		Smile:stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.main1_action2()
	runAction(function()
		ActionWheelClass.bodyShake(false)
	end, function()
		General.setAnimations("STOP", "shake")
		ShakeSplashCount = 0
	end, false)
end

function pings.main1_action3_left()
	runAction(function ()
		BroomCleaning:play()
		ActionWheelClass.ActionCount = BroomCleaning.AnimationLength
	end, function ()
		BroomCleaning:stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.main1_action3_left_alt()
	runAction(function ()
		VacuumCleaning:play()
		ActionWheelClass.ActionCount = VacuumCleaning.AnimationLength
	end, function ()
		VacuumCleaning:stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.main1_action3_right()
	runAction(function ()
		ClothCleaning:play()
		ActionWheelClass.ActionCount = ClothCleaning.AnimationLength
	end, function ()
		ClothCleaning:stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.main1_action4()
	runAction(function ()
		HairCut:play()
		ActionWheelClass.ActionCount = HairCut.AnimationLength
	end, function ()
		HairCut:stop()
		ActionWheelClass.ActionCount = 0
	end)
end

function pings.main1_action5()
	runAction(function ()
		FoxJump:play()
		ActionWheelClass.ActionCount = FoxJump.AnimationLength
	end, function ()
		FoxJump:stop()
		ActionWheelClass.ActionCount = 0
	end)
end

function pings.main1_action6()
	runAction(function ()
		TailBrush:play()
		ActionWheelClass.ActionCount = TailBrush.AnimationLength
	end, function ()
		TailBrush:stop()
		ActionWheelClass.ActionCount = 0
	end)
end

function pings.main1_action7()
	runAction(function ()
		Kotatsu:play()
	end, function ()
		Kotatsu:stop()
	end)
end

function pings.main2_action1_toggle()
	runAction(function ()
		SitDown:play()
	end, nil, true)
end

function pings.main2_action1_untoggle()
	SitDown:stop()
end

function pings.main2_action2()
	runAction(function ()
		TailCuddling:play()
		ActionWheelClass.ActionCount = TailCuddling.AnimationLength
	end, function ()
		TailCuddling:stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.main2_action3()
	runAction(function ()
		Earpick:play()
		ActionWheelClass.ActionCount = Earpick.AnimationLength
	end, function ()
		Earpick:stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.main2_action4()
	runAction(function ()
		TeaTime:play()
		ActionWheelClass.ActionCount = TeaTime.AnimationLength
	end, function ()
		TeaTime:stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.main2_action5()
	runAction(function ()
		Massage:play()
		ActionWheelClass.ActionCount = Massage.AnimationLength
	end, function ()
		Massage:stop()
		ActionWheelClass.ActionCount = 0
	end, false)
end

function pings.config_action1(costumeID)
	if costumeID == 1 then
		CostumeClass.resetCostume()
	else
		CostumeClass.setCostume(string.upper(CostumeClass.CostumeList[costumeID]))
	end
	ActionWheelClass.CurrentCostumeState = costumeID
	if host:isHost() then
		setCostumeChangeActionTitle()
	end
end

function pings.config_action2(nameID)
	NameplateClass.setName(nameID)
	ActionWheelClass.CurrentPlayerNameState = nameID
	if host:isHost() then
		setNameChangeActionTitle()
	end
end

function pings.config_action3_toggle()
	WetClass.AutoShake = true
end

function pings.config_action3_untoggle()
	WetClass.AutoShake = false
end

function pings.config_action4_toggle()
	ArmorClass.ShowArmor = true
end

function pings.config_action4_untoggle()
	ArmorClass.ShowArmor = false
end

function pings.config_action6_toggle()
	UmbrellaClass.UmbrellaSound = true
end

function pings.config_action6_untoggle()
	UmbrellaClass.UmbrellaSound = false
end

events.TICK:register(function ()
	if host:isHost() then
		CanBodyShake = not player:isUnderwater() and not player:isInLava() and not WardenClass.WardenNearby
		setActionEnabled(1, 1, ActionWheelClass.ActionCount == 0 and not WardenClass.WardenNearby)
		setActionEnabled(1, 2, ActionWheelClass.ActionCount == 0 and CanBodyShake)
		for i = 3, 4 do
			setActionEnabled(1, i, ActionWheelClass.ActionCount == 0 and BroomCleaning:checkAction())
		end
		setActionEnabled(1, 5, ActionWheelClass.ActionCount == 0 and FoxJump:checkAction())
		setActionEnabled(1, 6, ActionWheelClass.ActionCount == 0 and TailBrush:checkAction())
		setActionEnabled(1, 7, ActionWheelClass.ActionCount == 0 and Kotatsu:checkAction())
		setActionEnabled(2, 1, ActionWheelClass.ActionCount == 0 and SitDown:checkAction())
		setActionEnabled(2, 2, ActionWheelClass.ActionCount == 0 and TailCuddling:checkAction())
		for i = 3, 5 do
			setActionEnabled(2, i, General.isAnimationPlaying("models.main", "sit_down") and ActionWheelClass.ActionCount == 0 and not WardenClass.WardenNearby)
		end
		local sitDownAction = MainPages[2]:getAction(1)
		sitDownAction:toggled((ActionWheelClass.ActionCount == 0 or General.isAnimationPlaying("models.main", "earpick") or General.isAnimationPlaying("models.main", "tea_time") or General.isAnimationPlaying("models.main", "massage") or (General.isAnimationPlaying("models.main", "sit_down") and General.isAnimationPlaying("models.main", "shake"))) and SitDown:checkAction() and sitDownAction:isToggled())
		setActionEnabled(3, 1, not WardenClass.WardenNearby)
		local isOpenActionWheel = action_wheel:isEnabled()
		if not isOpenActionWheel and IsOpenActionWheelPrev then
			if CostumeState ~= ActionWheelClass.CurrentCostumeState then
				pings.config_action1(CostumeState)
				ConfigClass.saveConfig("costume", CostumeState)
				sounds:playSound("minecraft:item.armor.equip_leather", player:getPos())
				print(LanguageClass.getTranslate("action_wheel__config__action_1__done_first")..LanguageClass.getTranslate("costume__"..CostumeClass.CostumeList[CostumeState])..LanguageClass.getTranslate("action_wheel__config__action_1__done_last"))
			end
			if PlayerNameState ~= ActionWheelClass.CurrentPlayerNameState then
				pings.config_action2(PlayerNameState)
				ConfigClass.saveConfig("name", PlayerNameState)
				sounds:playSound("minecraft:ui.cartography_table.take_result", player:getPos(), 1, 1)
				print(LanguageClass.getTranslate("action_wheel__config__action_2__done_first")..NameplateClass.NameList[PlayerNameState]..LanguageClass.getTranslate("action_wheel__config__action_2__done_last"))
			end
			if ParentPage then
				action_wheel:setPage(ParentPage)
				IsOpenWordPage = false
				ParentPage = nil
			end
		end
		if WetClass.WetCount > 0 and not IsWetPrev then
			MainPages[1]:getAction(2):item("water_bucket")
		elseif WetClass.WetCount == 0 and IsWetPrev then
			MainPages[1]:getAction(2):item("bucket")
		end
		if WardenClass.WardenNearby and IsOpenWordPage then
			action_wheel:setPage(ParentPage)
			IsOpenWordPage = false
			ParentPage = nil
		end
		ActionWheelClass.ActionCount = ActionWheelClass.ActionCount > 0 and ActionWheelClass.ActionCount - 1 or ActionWheelClass.ActionCount
		IsOpenActionWheelPrev = isOpenActionWheel
		IsWetPrev = WetClass.WetCount > 0
	end
	if ShakeSplashCount > 0 then
		if ShakeSplashCount % 5 == 0 then
			for _ = 1, 4 do
				particles:newParticle("minecraft:splash", player:getPos():add(math.random() - 0.5, math.random() + 0.5, math.random() - 0.5))
			end
		end
		ShakeSplashCount = ShakeSplashCount - 1
	elseif ShakeSplashCount < 0 then
		if ShakeSplashCount % 5 == 0 then
			for _ = 1, 6 do
				particles:newParticle("minecraft:block minecraft:snow_block", player:getPos():add(math.random() - 0.5, math.random() + 0.5, math.random() - 0.5))
			end
		end
		ShakeSplashCount = ShakeSplashCount + 1
	end
	if SweatCount > 0 then
		if SweatCount % 5 == 0 then
			for _ = 1, 4 do
				particles:newParticle("minecraft:splash", player:getPos():add(0, 2, 0))
			end
		end
		SweatCount = SweatCount - 1
	end
end)

for _ = 1, 3 do
	table.insert(MainPages, action_wheel:newPage())
end

--メインページのアクション設定
--アクション1-1. にっこり
MainPages[1]:newAction(1):item("emerald"):onLeftClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			pings.main1_action1_left()
		end
	end
end):onRightClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			pings.main1_action1_right()
		end
	end
end)

--アクション1-2. ブルブル
MainPages[1]:newAction(2):item("bucket"):onLeftClick(function()
	if ActionWheelClass.ActionCount == 0 then
		if CanBodyShake then
			pings.main1_action2()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_2__unavailable"))
		end
	end
end)

--アクション1-3. お掃除
MainPages[1]:newAction(3):item("amethyst_shard"):onLeftClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if BroomCleaning:checkAction() then
			if math.random() > 0.9 then
				pings.main1_action3_left_alt()
			else
				pings.main1_action3_left()
			end
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_3__unavailable"))
		end
	end
end):onRightClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if BroomCleaning:checkAction() then
			pings.main1_action3_right()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_3__unavailable"))
		end
	end
end)

--アクション1-4. 散髪
MainPages[1]:newAction(4):item("shears"):onLeftClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if BroomCleaning:checkAction() then
			pings.main1_action4()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_4__unavailable"))
		end
	end
end)

--アクション1-5. キツネジャンプ
MainPages[1]:newAction(5):item("snow_block"):onLeftClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if FoxJump:checkAction() then
			pings.main1_action5()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_5__unavailable"))
		end
	end
end)

--アクション1-6. 尻尾の手入れ
MainPages[1]:newAction(6):item("sponge"):onLeftClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if TailBrush:checkAction() then
			pings.main1_action6()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_6__unavailable"))
		end
	end
end)

--アクション1-7. こたつ
MainPages[1]:newAction(7):item("campfire"):onLeftClick(function ()
	if ActionWheelClass.ActionCount == 0 then
		if Kotatsu:checkAction() then
			pings.main1_action7()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_1__action_7__unavailable"))
		end
	end
end)

--アクション2-1. おすわり（正座）
MainPages[2]:newAction(1):toggleColor(233 / 255, 160 / 255, 69 / 255):item("oak_stairs"):onToggle(function ()
	if ActionWheelClass.ActionCount == 0 then
		if SitDown:checkAction() then
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
		if TailCuddling:checkAction() then
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
		if General.isAnimationPlaying("models.main", "sit_down") then
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
		if General.isAnimationPlaying("models.main", "sit_down") then
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
		if General.isAnimationPlaying("models.main", "sit_down") then
			pings.main2_action5()
		elseif WardenClass.WardenNearby then
			pings.refuse_emote()
		else
			print(LanguageClass.getTranslate("action_wheel__main_2__action_5__unavailable"))
		end
	end
end)

--アクション3-1. 仙狐さんセリフ集
MainPages[3]:newAction(1):item("book"):onLeftClick(function ()
	if WardenClass.WardenNearby then
		if ActionWheelClass.ActionCount == 0 then
			pings.refuse_emote()
		end
	else
		action_wheel:setPage(WordPage)
		IsOpenWordPage = true
		ParentPage = MainPages[3]
	end
end)

--アクション3-2. 設定ページ
MainPages[3]:newAction(2):title(LanguageClass.getTranslate("action_wheel__main_3__action_2__title")):item("comparator"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	action_wheel:setPage(ConfigPage)
	ParentPage = MainPages[3]
end)

--アクション8（共通）. ページ切り替え
for index, mainPage in ipairs(MainPages) do
	mainPage:newAction(8):title(LanguageClass.getTranslate("action_wheel__main__action_8__title")..index.."/"..#MainPages):item("arrow"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
		if MainPages[index - direction] then
			action_wheel:setPage(MainPages[index - direction])
		elseif index == 1 then
			action_wheel:setPage(MainPages[#MainPages])
		else
			action_wheel:setPage(MainPages[1])
		end
	end)
end

CurrentWordLanguage = CurrentWordLanguage == -1 and General.indexof(LanguageList, "en_us") or CurrentWordLanguage

--セリフのページのアクション設定
--アクション1. 「存分に甘やかしてくれよう！」
WordPage:newAction(1):title(LanguageClass.getTranslate("action_wheel__word__action_1__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	host:sendChatMessage(LanguageClass.getTranslate("action_wheel__word__action_1__title", LanguageList[CurrentWordLanguage]))
end)

--アクション2. 「存分にもふるがよい」
WordPage:newAction(2):title(LanguageClass.getTranslate("action_wheel__word__action_2__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	host:sendChatMessage(LanguageClass.getTranslate("action_wheel__word__action_2__title", LanguageList[CurrentWordLanguage]))
end)

--アクション3. 「おかえりなのじゃ」
WordPage:newAction(3):title(LanguageClass.getTranslate("action_wheel__word__action_3__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	host:sendChatMessage(LanguageClass.getTranslate("action_wheel__word__action_3__title", LanguageList[CurrentWordLanguage]))
end)

--アクション4. 「お疲れ様じゃ」
WordPage:newAction(4):title(LanguageClass.getTranslate("action_wheel__word__action_4__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	host:sendChatMessage(LanguageClass.getTranslate("action_wheel__word__action_4__title", LanguageList[CurrentWordLanguage]))
end)

--アクション5. 「今日も大変だったのう」
WordPage:newAction(5):title(LanguageClass.getTranslate("action_wheel__word__action_5__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	host:sendChatMessage(LanguageClass.getTranslate("action_wheel__word__action_5__title", LanguageList[CurrentWordLanguage]))
end)

--アクション6. 「うやん♪」
WordPage:newAction(6):title(LanguageClass.getTranslate("action_wheel__word__action_6__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	host:sendChatMessage(LanguageClass.getTranslate("action_wheel__word__action_6__title", LanguageList[CurrentWordLanguage]))
end)

--アクション7. 「わらわはただの動く毛玉じゃ...」
WordPage:newAction(7):title(LanguageClass.getTranslate("action_wheel__word__action_7__title")):item("book"):color(233 / 255, 160 / 255, 69 / 255):hoverColor(1, 1, 1):onLeftClick(function ()
	host:sendChatMessage(LanguageClass.getTranslate("action_wheel__word__action_7__title", LanguageList[CurrentWordLanguage]))
end)

--アクション8. 言語切り替え
WordPage:newAction(8):title(LanguageClass.getTranslate("action_wheel__word__action_8__title")..LanguageClass.getTranslate("language__"..LanguageList[CurrentWordLanguage])):item("paper"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
	if LanguageList[CurrentWordLanguage - direction] then
		CurrentWordLanguage = CurrentWordLanguage - direction
	elseif CurrentWordLanguage == 1 then
		CurrentWordLanguage = #LanguageList
	else
		CurrentWordLanguage = 1
	end
	local motherLanguage = General.indexof(LanguageList, client:getActiveLang())
	motherLanguage = motherLanguage == -1 and General.indexof(LanguageList, "en_us") or motherLanguage
	for i = 1, 7 do
		WordPage:getAction(i):title(CurrentWordLanguage == motherLanguage and LanguageClass.getTranslate("action_wheel__word__action_"..i.."__title", LanguageList[CurrentWordLanguage]) or LanguageClass.getTranslate("action_wheel__word__action_"..i.."__title", LanguageList[CurrentWordLanguage]).."\n§7"..LanguageClass.getTranslate("action_wheel__word__action_8__bracket_begin")..LanguageClass.getTranslate("action_wheel__word__action_"..i.."__title")..LanguageClass.getTranslate("action_wheel__word__action_8__bracket_end"))
	end
	WordPage:getAction(8):title(LanguageClass.getTranslate("action_wheel__word__action_8__title")..LanguageClass.getTranslate("language__"..LanguageList[CurrentWordLanguage]))
end)

--設定のページのアクション設定
--アクション1. 着替え
ConfigPage:newAction(1):item("leather_chestplate"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
	if direction == -1 then
		CostumeState = CostumeState == #CostumeClass.CostumeList and 1 or CostumeState + 1
	else
		CostumeState = CostumeState == 1 and #CostumeClass.CostumeList or CostumeState - 1
	end
	setCostumeChangeActionTitle()
end):onLeftClick(function ()
	CostumeState = ActionWheelClass.CurrentCostumeState
	setCostumeChangeActionTitle()
end)

--アクション2. プレイヤーの表示名変更
ConfigPage:newAction(2):item("name_tag"):color(200 / 255, 200 / 255, 200 / 255):hoverColor(1, 1, 1):onScroll(function (direction)
	if direction == -1 then
		PlayerNameState = PlayerNameState == #NameplateClass.NameList and 1 or PlayerNameState + 1
	else
		PlayerNameState = PlayerNameState == 1 and #NameplateClass.NameList or PlayerNameState - 1
	end
	setNameChangeActionTitle()
end):onLeftClick(function ()
	PlayerNameState = ActionWheelClass.CurrentPlayerNameState
	setNameChangeActionTitle()
end)

--アクション3. 自動ブルブル
ConfigPage:newAction(3):title(LanguageClass.getTranslate("action_wheel__config__action_3__title")..LanguageClass.getTranslate("action_wheel__toggle_off")):toggleTitle(LanguageClass.getTranslate("action_wheel__config__action_3__title")..LanguageClass.getTranslate("action_wheel__toggle_on")):item("water_bucket"):color(170 / 255, 0, 0):hoverColor(1, 85 / 255, 85 / 255):toggleColor(0, 170 / 255, 0):onToggle(function ()
	pings.config_action3_toggle()
	ConfigPage:getAction(3):hoverColor(85 / 255, 1, 85 / 255)
	ConfigClass.saveConfig("autoShake", true)
end):onUntoggle(function ()
	pings.config_action3_untoggle()
	ConfigPage:getAction(3):hoverColor(1, 85 / 255, 85 / 255)
	ConfigClass.saveConfig("autoShake", false)
end)
if ConfigClass.loadConfig("autoShake", true) then
	local action = ConfigPage:getAction(3)
	action:toggled(true)
	action:hoverColor(85 / 255, 1, 85 / 255)
end

--アクション4. 防具の非表示
ConfigPage:newAction(4):title(LanguageClass.getTranslate("action_wheel__config__action_4__title")..LanguageClass.getTranslate("action_wheel__toggle_off")):toggleTitle(LanguageClass.getTranslate("action_wheel__config__action_4__title")..LanguageClass.getTranslate("action_wheel__toggle_on")):item("iron_chestplate"):color(170 / 255, 0, 0):hoverColor(1, 85 / 255, 85 / 255):toggleColor(0, 170 / 255, 0):onToggle(function ()
	pings.config_action4_toggle()
	ConfigPage:getAction(4):hoverColor(85 / 255, 1, 85 / 255)
	ConfigClass.saveConfig("showArmor", true)
end):onUntoggle(function ()
	pings.config_action4_untoggle()
	ConfigPage:getAction(4):hoverColor(1, 85 / 255, 85 / 255)
	ConfigClass.saveConfig("showArmor", false)
end)
if ConfigClass.loadConfig("showArmor", false) then
	local action = ConfigPage:getAction(4)
	action:toggled(true)
	action:hoverColor(85 / 255, 1, 85 / 255)
end

--アクション5. 一人称視点での狐火の表示の切り替え
ConfigPage:newAction(5):title(LanguageClass.getTranslate("action_wheel__config__action_5__title")..LanguageClass.getTranslate("action_wheel__toggle_off")):toggleTitle(LanguageClass.getTranslate("action_wheel__config__action_5__title")..LanguageClass.getTranslate("action_wheel__toggle_on")):item("soul_torch"):color(170 / 255, 0, 0):hoverColor(1, 85 / 255, 85 / 255):toggleColor(0, 170 / 255, 0):onToggle(function ()
	FoxFireClass.FoxFireInFirstPerson = true
	ConfigPage:getAction(5):hoverColor(85 / 255, 1, 85 / 255)
	ConfigClass.saveConfig("foxFireInFirstPerson", true)
end):onUntoggle(function ()
	FoxFireClass.FoxFireInFirstPerson = false
	ConfigPage:getAction(5):hoverColor(1, 85 / 255, 85 / 255)
	ConfigClass.saveConfig("foxFireInFirstPerson", false)
end)
if ConfigClass.loadConfig("foxFireInFirstPerson", true) then
	local action = ConfigPage:getAction(5)
	action:toggled(true)
	action:hoverColor(85 / 255, 1, 85 / 255)
end

--アクション6. 傘の開閉音
ConfigPage:newAction(6):title(LanguageClass.getTranslate("action_wheel__config__action_6__title")..LanguageClass.getTranslate("action_wheel__toggle_off")):toggleTitle(LanguageClass.getTranslate("action_wheel__config__action_6__title")..LanguageClass.getTranslate("action_wheel__toggle_on")):item("red_carpet"):color(170 / 255, 0, 0):hoverColor(1, 85 / 255, 85 / 255):toggleColor(0, 170 / 255, 0):onToggle(function ()
	pings.config_action6_toggle()
	ConfigPage:getAction(6):hoverColor(85 / 255, 1, 85 / 255)
	ConfigClass.saveConfig("umbrellaSound", true)
end):onUntoggle(function ()
	pings.config_action6_untoggle()
	ConfigPage:getAction(6):hoverColor(1, 85 / 255, 85 / 255)
	ConfigClass.saveConfig("umbrellaSound", false)
end)
if ConfigClass.loadConfig("umbrellaSound", true) then
	local action = ConfigPage:getAction(6)
	action:toggled(true)
	action:hoverColor(85 / 255, 1, 85 / 255)
end

setCostumeChangeActionTitle()
setNameChangeActionTitle()
action_wheel:setPage(MainPages[1])

return ActionWheelClass