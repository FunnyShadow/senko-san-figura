---@class AnimationAction アニメーションアクションの抽象クラス

AnimationAction = {
	---コンストラクタ
	---@param canPlayAnimation function アニメーションが再生可能かどうかを判断し、booleanで返す関数
	---@param partToShow ModelPart|table|nil アニメーションの再生時に表示させるモデルパーツ
	---@param partToHide ModelPart|table|nil アニメーション停止時に非表示にするモデルパーツ
	---@param primaryAnimation Animation|nil 再生するメインのアニメーション。アニメーションの長さ取得にも使われる。
	---@param secondaryAnimation Animation|table|nil メインのアニメーションと同時に再生するアニメーション
	---@param additionalAnimationCount integer 追加のアニメーションカウント
	---@return table instance インスタンス化されたクラス
	new = function(canPlayAnimation, partToShow, partToHide, primaryAnimation, secondaryAnimation, additionalAnimationCount)
		local instance = General.instance(AnimationAction)
		instance.CheckFunction = canPlayAnimation --アニメーションが再生可能か確認する関数
		instance.CanPlayAnimation = false --アニメーションが再生可能かどうか
		instance.AnimationChecked = false --このチックでアニメーションが再生可能かどうかを確認したかどうか
		instance.IsAnimationPlaying = false --アニメーションが再生中かどうか
		instance.AnimationCount = 0 --アニメーションのタイミングを計るカウンター
		instance.AnimationLength = primaryAnimation and math.ceil(primaryAnimation:getLength() * 20) + additionalAnimationCount or 0 --メインのアニメーションの長さ
		instance.Animations = primaryAnimation and {primaryAnimation} or {} --再生・停止するアニメーションのリスト
		if secondaryAnimation then
			if type(secondaryAnimation) == "Animation" then
				table.insert(instance.Animations, secondaryAnimation)
			else
				for _, animationElement in ipairs(secondaryAnimation) do
					table.insert(instance.Animations, animationElement)
				end
			end
		end
		instance.PartToShow = {} --アニメーション再生時に表示させるモデルパーツ
		if partToShow then
			if type(partToShow) == "ModelPart" then
				table.insert(instance.PartToShow, partToShow)
			else
				for _, modelPart in ipairs(partToShow) do
					table.insert(instance.PartToShow, modelPart)
				end
			end
		end
		instance.PartToHide = {} --アニメーション停止時に非表示にするモデルパーツ
		if partToHide then
			if type(partToHide) == "ModelPart" then
				table.insert(instance.PartToHide, partToHide)
			else
				for _, modelPart in ipairs(partToHide) do
					table.insert(instance.PartToHide, modelPart)
				end
			end
		end
		instance.HideHeldItem = false --アニメーション再生中に手持ちアイテムを隠すかどうか
		events.TICK:register(function ()
			instance:onTickEvent()
		end)
		return instance
	end,

	---コンストラクタでtickイベントに登録される関数
	onTickEvent = function (self)
		if self.IsAnimationPlaying then
			self:onAnimationTick()
		end
		self.AnimationChecked = false
	end,

	---アクションが再生可能かどうかを返す。
	---@return boolean canPlayAction アクションが実行可能かどうか
	checkAction = function (self)
		if not self.AnimationChecked then
			self.CanPlayAnimation = self.CheckFunction()
			self.AnimationChecked = true
		end
		return self.CanPlayAnimation
	end,

	---アクションを再生する。
	play = function (self)
		for _, modelPart in ipairs(self.PartToShow) do
			modelPart:setVisible(true)
		end
		for _, animationElement in ipairs(self.Animations) do
			animationElement:play()
		end
		UmbrellaClass.EnableUmbrella = false
		self.IsAnimationPlaying = true
		self.AnimationCount = self.AnimationLength
	end,

	---アクションを停止する。
	stop = function (self)
		for _, modelPart in ipairs(self.PartToHide) do
			modelPart:setVisible(false)
		end
		for _, animationElement in ipairs(self.Animations) do
			animationElement:stop()
		end
		self.HideHeldItem = false
		for _, vanillaModelPart in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
			vanillaModelPart:setVisible(true)
			ArmsClass.ItemHeldContradicts = {true, true}
		end
		FacePartsClass.resetEmotion()
		UmbrellaClass.EnableUmbrella = true
		self.IsAnimationPlaying = false
		self.AnimationCount = 0
	end,

	---アニメーション再生中に毎チック実行される関数
	onAnimationTick = function (self)
		if self.HideHeldItem then
			for index, vanillaModelPart in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
				if player:getHeldItem(player:isLeftHanded() == (index == 1)) ~= "minecraft:air" then
					vanillaModelPart:setVisible(false)
					ArmsClass.ItemHeldContradicts[index] = true
				else
					vanillaModelPart:setVisible(true)
					ArmsClass.ItemHeldContradicts[index] = false
				end
			end
		else
			for _, vanillaModelPart in ipairs({vanilla_model.RIGHT_ITEM, vanilla_model.LEFT_ITEM}) do
				vanillaModelPart:setVisible(true)
				ArmsClass.ItemHeldContradicts = {true, true}
			end
		end
		if self.AnimationCount == 1 or not self:checkAction() then
			self:stop()
		end
		self.AnimationCount = (self.AnimationCount > 0 and not client:isPaused()) and self.AnimationCount - 1 or self.AnimationCount
	end
}

return AnimationAction