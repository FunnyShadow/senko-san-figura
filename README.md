# SenkoSan（仙狐さん）
TVアニメ「世話やきキツネの仙狐さん」（とその原作）に登場するキャラクターを再現した、MinecraftのスキンMod「[Figura](https://www.curseforge.com/minecraft/mc-mods/figura)」向けスキン「SenkoSan（仙狐さん）」です。

**このREADMEには本来、大量の画像（約44MB）が添付されており、通信量の軽減のため、必要最低限以外の画像は添付されおりません。全ての画像を確認したい方は[README（完全版）](./.github/workflows/README_full.md)をご覧ください。**

対応Figuraバージョン：[0.1.0-rc9](https://www.curseforge.com/minecraft/mc-mods/figura/files/4007916)

![メイン](README_images/メイン.jpg)

## 特徴
- 耳と尻尾のモデルが生えています。
  - 尻尾はプレイヤーの動きに合わせて揺れます。

  - 耳は**Xキー**、尻尾は**Zキー**で動かすことができます。

- 現在のHPや満腹度に応じてキャラクターの耳が垂れさがったり、表情が変わったりします。

- 時々瞬きします。
- [アクションホイール](#アクションホイール12)で様々なアニメーションを実行できます。

- [アクションホイール](#アクションホイール12)で座ることができます。
  - 座らないと実行できないアニメーションがあります。

- 就寝時は狐のような寝姿になります（第2話）。
  - 暗闇デバフを受けている時はまた別の寝姿（？）になります。

- 複数の衣装チェンジができます。
  - いつもの服

  - 変装服（第3話）

  - メイド服A（第6話）

  - メイド服B（第6話）

  - 今後もいくつか追加していく予定です。

- あなたの表示名をキャラクターの名前に変更できます。
  - 他のプレイヤーがこの名前を見えるようにするには、**他のプレイヤーもFiguraを導入し、あなたの信頼設定を十分上げる必要があります**。

- 水に触れると濡れてしまいます。
  - 水から上がると身震いして体に付いた水滴を飛ばします（[設定](#アバター設定について)でオフにできます）。

  - 尻尾は水にぬれるとしなびてしまいます（第5話）。

- 暗視が付与されていると頭上に狐火が出現します。
  - 濡れている場合は消えてしまいます。

- 特定のGUIが開いている間は眼鏡をかけます（第4話）。

- ウォーデンが付近いる（≒暗闇デバフを受けている）と、怯えて震えます。

  - 怯えている時は、エモートを拒否拒否するようになります。

## アクションホイール（1/2）
このアバターにはいくつかのアクションが用意されています。

![アクションホイール1](README_images/アクションホイール1.jpg)

### アクション1-1. お掃除
左クリックで箒掃除、右クリックで拭き掃除を行います。箒掃除にはレアパターンが存在します。

### アクション1-2. ブルブル
水から上がった際のブルブルを手動で実行できます。

### アクション1-3. おすわり
その場に座ります。もう一度アクション実行で立ち上がります。座っている時に動いたり、ジャンプしたり、スニークしたりすると自動で立ち上がります。

### アクション1-4. 耳かき
膝枕でプレイヤーの耳を掃除してくれます（スキンはプレイヤーのスキンになります）。このアクションを実行するには先に座って下さい。

### アクション1-5. お茶
ほうじ茶を飲んで一息つきます（第6話）。このアクションを実行するには先に座って下さい。

### アクション1-5. マッサージ
プレイヤーの肩をほぐしてくれます（第7話、スキンはプレイヤーのスキンになります）。このアクションを実行するには先に座って下さい。

## アクションホイール（2/2）
![アクションホイール2](README_images/アクションホイール2.jpg)

### アクション2-1. 衣装変更
アバターの衣装を変更します。スクロールで衣装を変更します。どんな衣装があるかは「[特徴](#特徴)」内の画像を確認して下さい。

### アクション2-2. 名前変更
プレイヤーの表示名を変更します。スクロールで表示名を選択します。ただし、他のプレイヤーが変更された名前を見るには、**そのプレイヤーもFiguraを導入し、あなたの信頼設定を十分上げる必要があります**。

## アバター設定について
[設定ファイル（./scripts/config.lua）](./scripts/config.lua)を編集することで、一部のアバターの初期値を変更できます。
- 2022/10/12現在、Figuraの仕様上ゲーム内での設定を提供できません。
- 下記以外の場所を編集しないで下さい。また、不正な値を設定しないで下さい。不具合のもととなります。

```lua
ConfigClass.DefaultCostume = 1
ConfigClass.DefaultName = 3
ConfigClass.AutoShake = true
ConfigClass.HideArmor = true
```

| 項目 | 説明 | 有効な値 | 初期値 |
| - | - | - | - |
| ``ConfigClass.DefaultCostume`` | アバター読み込み時に適用するコスチュームのIDです。詳しくは設定ファイル内の説明をご覧ください。 | ``integer`` 1 - 4 | 1 |
| ``ConfigClass.DefaultName`` | アバター読み込み時に適用するプレイヤーの表示名です。詳しくは設定ファイル内の説明をご覧ください。 | ``integer`` 1 - 3 | 3 |
| ``ConfigClass.AutoShake`` | 水から上がった際に自動で身震いするかどうかです。 | ``boolean`` | ``true`` |
| ``ConfigClass.HideArmor`` | 防具を隠すかどうかです。``false``にすると防具が表示されます。 | ``boolean`` | ``true`` |

## 注意事項
- このアバターは[Figuraコミュニティー](https://discord.gg/ekHGHcH8Af)に寄せられたリクエストの延長線上のアバターです。
- このアバターは現在開発中であり、今後もアップデートされる予定です。そのため、現在のバージョンとの仕様変更や互換性が失われる可能性があります。
- 漫画原作を読むつもりはありません。
- 不具合がありましたら、[Issues](https://github.com/Gakuto1112/SenkoSan/issues)までご連絡下さい。

## リンク集
- [Figura（CurseForge）](https://www.curseforge.com/minecraft/mc-mods/figura)
- [Figura（Modrinth）](https://modrinth.com/mod/figura)
- [TVアニメ「世話やきキツネの仙狐さん」オフィシャルサイト](http://senkosan.com/)
- [Amazon.co.jp_ 世話やきキツネの仙狐さんを観る _ Prime Video](https://www.amazon.co.jp/gp/video/detail/B07QJG9NP7)