# バーセルインデックス評価管理システム (Barthel Index Manager)

Delphi 6で作成されたバーセルインデックス（Barthel Index）の評価項目を管理するアプリケーションです。

## 重要な注意事項

**UIは英語表記になっています。** Delphi 6はUnicode非対応で、ANSI（Shift-JIS）のみサポートしているため、ソースコード内に日本語を含めるとコンパイル時に文字化けが発生します。そのため、UIは英語で表示されますが、機能は完全に動作します。

## 概要

バーセルインデックスは、日常生活動作（ADL）を評価するための標準的な指標です。
このアプリケーションは、10項目の評価を簡単に入力・管理し、自動的に合計点を計算します。

## 評価項目（全10項目）

| 日本語名 | 英語名 | スコア範囲 |
|---------|--------|-----------|
| 1. 食事 | Feeding | 0, 5, 10点 |
| 2. 車椅子からベッドへの移動 | Transfer (Bed to Chair) | 0, 5, 10, 15点 |
| 3. 整容（身だしなみ） | Grooming | 0, 5点 |
| 4. トイレ動作 | Toilet Use | 0, 5, 10点 |
| 5. 入浴 | Bathing | 0, 5点 |
| 6. 歩行 | Mobility (Walking) | 0, 5, 10, 15点 |
| 7. 階段昇降 | Stairs | 0, 5, 10点 |
| 8. 更衣 | Dressing | 0, 5, 10点 |
| 9. 排便コントロール | Bowel Control | 0, 5, 10点 |
| 10. 排尿コントロール | Bladder Control | 0, 5, 10点 |

**合計点範囲**: 0〜100点

## 主な機能

### 基本機能
- 患者情報の入力（患者ID、患者名、評価日付）
- 各評価項目のスコア選択（ドロップダウンリスト）
- 合計点の自動計算・リアルタイム表示
- 入力内容のクリア機能

### データ管理
- **ファイル保存・読み込み** (.biファイル形式)
- **SQL Serverデータベース連携** (NEW!)
  - 入院時 (Admission) と退院時 (Discharge) の評価を別々に記録
  - 患者マスタ管理
  - 評価履歴の保存・取得

## 動作環境

- **開発環境**: Delphi 6
- **対象OS**: Windows 95/98/ME/2000/XP/Vista/7/8/10/11
- **必要なコンポーネント**: 標準VCLコンポーネントのみ
- **文字コード**: ANSI (Shift-JIS)

## ファイル構成

```
BarthelIndex/
├── BarthelIndex.dpr      # プロジェクトファイル
├── MainForm.pas          # メインフォームのソースコード（英語UI）
├── MainForm.dfm          # メインフォームのUI定義
├── DBModule.pas          # データベース接続モジュール
├── DBModule.dfm          # データモジュールUI定義
├── CreateDatabase.sql    # SQL Serverデータベース作成スクリプト
├── DBConfig.ini.sample   # データベース接続設定サンプル
└── README.md             # このファイル（日本語説明）
```

## ビルド方法

### Delphi 6 IDEを使用する場合

1. Delphi 6を起動します
2. `BarthelIndex.dpr` を開きます
3. メニューから `Project` → `Compile BarthelIndex` を選択
4. エラーがなければ実行可能ファイル `BarthelIndex.exe` が生成されます

### コマンドラインからビルドする場合

```batch
cd BarthelIndex
dcc32 BarthelIndex.dpr
```

注: `dcc32.exe` へのパスが通っている必要があります。
通常は `C:\Program Files\Borland\Delphi6\Bin\dcc32.exe` にあります。

## 使用方法

### 1. 新規評価の入力

1. アプリケーションを起動します
2. 患者情報を入力します
   - **Patient ID**: 患者ID
   - **Patient Name**: 患者名
   - **Evaluation Date**: 評価日付（カレンダーから選択）
3. 各評価項目について、該当するスコアをドロップダウンから選択します
4. 合計点が自動的に計算され、**Total Score** として画面下部に表示されます

### 2. データの保存

1. すべての項目を入力後、**Save** ボタンをクリックします
2. 保存先とファイル名を指定します（拡張子は自動的に.biになります）
3. 保存をクリックすると「Data saved successfully.」というメッセージが表示されます

### 3. データの読み込み

1. **Load** ボタンをクリックします
2. 読み込みたい.biファイルを選択します
3. 開くをクリックすると、保存されたデータが画面に表示され、「Data loaded successfully.」というメッセージが表示されます

### 4. 入力内容のクリア

1. **Clear** ボタンをクリックします
2. 「Clear all input data. Are you sure?」という確認メッセージが表示されるので、**Yes** を選択します
3. すべての入力内容がクリアされます

## SQL Serverデータベース連携 (NEW!)

### データベースのセットアップ

#### 1. データベースの作成

SQL Server Management Studioまたはsqlcmdで以下を実行：

```sql
CREATE DATABASE BarthelIndexDB;
GO

USE BarthelIndexDB;
GO

-- CreateDatabase.sqlスクリプトを実行
-- SQL Server Management Studioで [ファイル] → [開く] → CreateDatabase.sqlを選択して実行
```

または、コマンドラインから：

```batch
sqlcmd -S localhost -i CreateDatabase.sql
```

#### 2. 接続設定ファイルの作成

1. `DBConfig.ini.sample` を `DBConfig.ini` にコピーします
2. `DBConfig.ini` を編集して、SQL Serverの接続情報を設定します：

```ini
[Database]
Server=localhost
Database=BarthelIndexDB
Username=sa
Password=YourPassword
```

**Windows認証を使用する場合**は、UsernameとPasswordを空にします：

```ini
[Database]
Server=localhost
Database=BarthelIndexDB
Username=
Password=
```

### データベースを使用した評価の記録

#### 1. データベースへの接続

1. アプリケーションを起動します
2. **DB Connect** ボタンをクリックします
3. 接続に成功すると「Connected to database successfully.」と表示され、ボタンが「DB Disconnect」に変わります

#### 2. 入院時評価の登録

1. 患者IDと患者名を入力します
2. **Evaluation Type** で **Admission** (入院時) を選択します
3. 評価日付を選択します
4. 10項目の評価スコアを入力します
5. **Save to DB** ボタンをクリックします
6. 「Evaluation saved to database successfully.」と表示されれば保存完了です

#### 3. 退院時評価の登録

1. 同じ患者IDを入力します（または入院時評価を読み込んだ状態）
2. **Evaluation Type** で **Discharge** (退院時) を選択します
3. 退院日の評価日付を選択します
4. 10項目の評価スコアを入力します（通常は入院時より改善しているはず）
5. **Save to DB** ボタンをクリックします

#### 4. データベースからの読み込み

1. 患者IDを入力します
2. **Evaluation Type** で読み込みたい評価タイプ (Admission または Discharge) を選択します
3. **Load from DB** ボタンをクリックします
4. データが見つかれば、評価内容が画面に表示されます

### データベーステーブル構造

#### Patients テーブル（患者マスタ）

| カラム名 | 型 | 説明 |
|---------|---|------|
| PatientID | VARCHAR(50) | 患者ID（主キー） |
| PatientName | NVARCHAR(100) | 患者名 |
| DateOfBirth | DATE | 生年月日 |
| Gender | CHAR(1) | 性別 (M/F) |
| CreatedDate | DATETIME | 作成日時 |
| UpdatedDate | DATETIME | 更新日時 |

#### BarthelEvaluations テーブル（評価データ）

| カラム名 | 型 | 説明 |
|---------|---|------|
| EvaluationID | INT IDENTITY | 評価ID（主キー） |
| PatientID | VARCHAR(50) | 患者ID（外部キー） |
| EvaluationType | VARCHAR(20) | 評価タイプ ('Admission' または 'Discharge') |
| EvaluationDate | DATE | 評価日付 |
| Item1_Feeding | INT | 食事 (0,5,10) |
| Item2_Transfer | INT | 移動 (0,5,10,15) |
| Item3_Grooming | INT | 整容 (0,5) |
| Item4_ToiletUse | INT | トイレ動作 (0,5,10) |
| Item5_Bathing | INT | 入浴 (0,5) |
| Item6_Mobility | INT | 歩行 (0,5,10,15) |
| Item7_Stairs | INT | 階段昇降 (0,5,10) |
| Item8_Dressing | INT | 更衣 (0,5,10) |
| Item9_BowelControl | INT | 排便コントロール (0,5,10) |
| Item10_BladderControl | INT | 排尿コントロール (0,5,10) |
| TotalScore | INT | 合計点 (0-100) |
| Notes | NVARCHAR(500) | 備考 |
| EvaluatorName | NVARCHAR(100) | 評価者名 |
| CreatedDate | DATETIME | 作成日時 |
| UpdatedDate | DATETIME | 更新日時 |

### 改善度の確認

データベースには、入院時と退院時の改善度を確認するためのビュー `vw_PatientEvaluationSummary` が用意されています：

```sql
SELECT * FROM vw_PatientEvaluationSummary;
```

このビューで以下の情報が確認できます：
- 患者ID、患者名
- 入院時評価日と入院時スコア
- 退院時評価日と退院時スコア
- スコアの改善度 (退院時スコア - 入院時スコア)
- 退院時の状態（Independent, Mild Dependency, など）

## UIの対応表（英語→日本語）

| 英語表示 | 日本語の意味 |
|---------|-------------|
| Patient Info | 患者情報 |
| Patient ID | 患者ID |
| Patient Name | 患者名 |
| Evaluation Date | 評価日付 |
| Evaluation Items | 評価項目 |
| Evaluation Type | 評価タイプ |
| Admission | 入院時 |
| Discharge | 退院時 |
| Total Score | 合計得点 |
| Save to File | ファイルに保存 |
| Load from File | ファイルから読み込み |
| Save to DB | データベースに保存 |
| Load from DB | データベースから読み込み |
| DB Connect | データベース接続 |
| DB Disconnect | データベース切断 |
| Clear | クリア |
| Data saved successfully | データを保存しました |
| Data loaded successfully | データを読み込みました |
| Evaluation saved to database successfully | 評価をデータベースに保存しました |
| Evaluation loaded from database successfully | 評価をデータベースから読み込みました |
| Connected to database successfully | データベースに接続しました |
| Clear all input data. Are you sure? | すべての入力内容をクリアします。よろしいですか？ |

### スコア選択肢の対応表

各項目のドロップダウンリストには、以下のような選択肢が表示されます：

- **0: Total assistance** → 全介助
- **5: Partial assistance** → 一部介助
- **10: Independent** → 自立
- **15: Independent** → 自立（移動項目のみ）

## データファイル形式

保存されるデータファイル（.bi）はテキスト形式で、以下の構造を持ちます：

```ini
[PatientInfo]
PatientID=001
PatientName=Taro Yamada
EvalDate=2025/10/28

[Evaluation]
Item1=2
Item2=3
Item3=1
Item4=2
Item5=1
Item6=3
Item7=2
Item8=2
Item9=2
Item10=2

[Score]
TotalScore=85 pts
```

## スコアリングの目安

- **100点**: 完全に自立
- **60〜99点**: 軽度の介助が必要
- **40〜59点**: 中等度の介助が必要
- **20〜39点**: 重度の介助が必要
- **0〜19点**: 全介助が必要

## 技術的な詳細

### Delphi 6の制約について

Delphi 6（2001年リリース）はUnicodeに対応していないため、以下の制約があります：

1. **文字コード**: ANSI（Windows環境ではShift-JIS）のみサポート
2. **ソースコード**: UTF-8で保存された日本語文字列は文字化けする
3. **実行時**: String型はANSI文字列として扱われる

そのため、このアプリケーションでは以下の設計を採用しています：

- UIは英語表記にして文字化けを回避
- ソースコードはすべてASCII文字で記述
- 日本語の説明はこのREADMEファイルに記載

### より新しいDelphiバージョンでの動作

Delphi 2009以降のバージョンでは、String型がUnicode（UTF-16）に変更されているため、ソースコード内に直接日本語を記述できます。このアプリケーションをDelphi 2009以降でビルドする場合は、MainForm.pasのInitializeComboBoxes プロシージャ内の文字列を日本語に置き換えることができます。

## 注意事項

- このアプリケーションは評価記録を補助するものであり、医療診断を行うものではありません
- 実際の評価は、訓練を受けた医療従事者が実施してください
- データファイルには個人情報が含まれる可能性があるため、適切に管理してください
- Delphi 6は古いバージョンのため、最新のWindowsでの動作は保証されません

## トラブルシューティング

### ビルド時にエラーが発生する

- Delphi 6が正しくインストールされているか確認してください
- プロジェクトファイル（.dpr）とユニットファイル（.pas, .dfm）が同じディレクトリにあることを確認してください

### 実行時にエラーが発生する

- Windows互換モードで実行してみてください（Windows XP SP3互換モードを推奨）
- 管理者権限で実行してみてください

## ライセンス

このプログラムはサンプルプログラムとして提供されています。
ご自由にカスタマイズしてご使用ください。

## 更新履歴

- **2025-10-28 v2.0**: SQL Server対応版リリース
  - SQL Serverデータベース連携機能を追加
  - 入院時 (Admission) と退院時 (Discharge) の評価を別々に記録可能
  - 患者マスタ管理機能
  - データベース接続・切断機能
  - データベースからの評価保存・読み込み機能
  - 改善度確認用ビューの提供
  - ファイル保存機能も引き続き利用可能

- **2025-10-28 v1.0**: 初版リリース
  - 基本的な評価入力機能
  - ファイル保存・読み込み機能
  - 合計点自動計算機能
  - Delphi 6 ANSI制約に対応（英語UI）

## サポート

バグ報告や機能要望がある場合は、プロジェクトの管理者にお問い合わせください。
