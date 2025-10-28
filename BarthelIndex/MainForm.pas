unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ComCtrls;

type
  TFormMain = class(TForm)
    GroupBox1: TGroupBox;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EditPatientID: TEdit;
    EditPatientName: TEdit;
    DateTimePickerEval: TDateTimePicker;
    GroupBox2: TGroupBox;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label10: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label13: TLabel;
    Label14: TLabel;
    LabelTotalScore: TLabel;
    ComboBox1: TComboBox;
    ComboBox2: TComboBox;
    ComboBox3: TComboBox;
    ComboBox4: TComboBox;
    ComboBox5: TComboBox;
    ComboBox6: TComboBox;
    ComboBox7: TComboBox;
    ComboBox8: TComboBox;
    ComboBox9: TComboBox;
    ComboBox10: TComboBox;
    ButtonSave: TButton;
    ButtonLoad: TButton;
    ButtonClear: TButton;
    SaveDialog1: TSaveDialog;
    OpenDialog1: TOpenDialog;
    procedure CalculateTotal(Sender: TObject);
    procedure ButtonSaveClick(Sender: TObject);
    procedure ButtonLoadClick(Sender: TObject);
    procedure ButtonClearClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    function GetScoreFromComboBox(ComboBox: TComboBox): Integer;
    procedure UpdateTotalScore;
    procedure InitializeUI;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  InitializeUI;
  UpdateTotalScore;
end;

procedure TFormMain.InitializeUI;
begin
  // フォームタイトルと各種ラベルを日本語に設定
  Caption := 'バーセルインデックス評価管理システム';

  GroupBox1.Caption := '患者情報';
  Label1.Caption := '患者ID:';
  Label2.Caption := '患者名:';
  Label3.Caption := '評価日付:';

  GroupBox2.Caption := '評価項目';
  Label4.Caption := '1. 食事';
  Label5.Caption := '2. 車椅子からベッドへの移動';
  Label6.Caption := '3. 整容（身だしなみ）';
  Label7.Caption := '4. トイレ動作';
  Label8.Caption := '5. 入浴';
  Label9.Caption := '6. 歩行';
  Label10.Caption := '7. 階段昇降';
  Label11.Caption := '8. 更衣';
  Label12.Caption := '9. 排便コントロール';
  Label13.Caption := '10. 排尿コントロール';
  Label14.Caption := '合計得点:';

  ButtonSave.Caption := '保存';
  ButtonLoad.Caption := '読み込み';
  ButtonClear.Caption := 'クリア';

  // 保存・読み込みダイアログのフィルタ
  SaveDialog1.Filter := 'バーセルインデックスデータ (*.bi)|*.bi|すべてのファイル (*.*)|*.*';
  OpenDialog1.Filter := 'バーセルインデックスデータ (*.bi)|*.bi|すべてのファイル (*.*)|*.*';

  // ComboBox1 - 食事
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add('0点: 全介助');
  ComboBox1.Items.Add('5点: 一部介助');
  ComboBox1.Items.Add('10点: 自立');

  // ComboBox2 - 移動
  ComboBox2.Items.Clear;
  ComboBox2.Items.Add('0点: 全介助');
  ComboBox2.Items.Add('5点: 多大な介助が必要');
  ComboBox2.Items.Add('10点: 少し介助が必要');
  ComboBox2.Items.Add('15点: 自立');

  // ComboBox3 - 整容
  ComboBox3.Items.Clear;
  ComboBox3.Items.Add('0点: 全介助');
  ComboBox3.Items.Add('5点: 自立');

  // ComboBox4 - トイレ動作
  ComboBox4.Items.Clear;
  ComboBox4.Items.Add('0点: 全介助');
  ComboBox4.Items.Add('5点: 介助が必要');
  ComboBox4.Items.Add('10点: 自立');

  // ComboBox5 - 入浴
  ComboBox5.Items.Clear;
  ComboBox5.Items.Add('0点: 全介助');
  ComboBox5.Items.Add('5点: 自立');

  // ComboBox6 - 歩行
  ComboBox6.Items.Clear;
  ComboBox6.Items.Add('0点: 歩行不可 or 50m未満');
  ComboBox6.Items.Add('5点: 車椅子で50m');
  ComboBox6.Items.Add('10点: 歩行器で50m、監視or杖で介助が必要');
  ComboBox6.Items.Add('15点: 50m自立');

  // ComboBox7 - 階段昇降
  ComboBox7.Items.Clear;
  ComboBox7.Items.Add('0点: 不可');
  ComboBox7.Items.Add('5点: 介助が必要');
  ComboBox7.Items.Add('10点: 自立');

  // ComboBox8 - 更衣
  ComboBox8.Items.Clear;
  ComboBox8.Items.Add('0点: 全介助');
  ComboBox8.Items.Add('5点: 介助が必要');
  ComboBox8.Items.Add('10点: 自立');

  // ComboBox9 - 排便コントロール
  ComboBox9.Items.Clear;
  ComboBox9.Items.Add('0点: 失禁頻回 or 浣腸、座薬');
  ComboBox9.Items.Add('5点: 時々失禁(1回/週)');
  ComboBox9.Items.Add('10点: コントロール良好');

  // ComboBox10 - 排尿コントロール
  ComboBox10.Items.Clear;
  ComboBox10.Items.Add('0点: 失禁頻回 or 尿閉');
  ComboBox10.Items.Add('5点: 時々失禁(1回/週)');
  ComboBox10.Items.Add('10点: コントロール良好');
end;

function TFormMain.GetScoreFromComboBox(ComboBox: TComboBox): Integer;
var
  ScoreStr: string;
  PosColon: Integer;
begin
  Result := 0;
  if ComboBox.ItemIndex >= 0 then
  begin
    ScoreStr := ComboBox.Items[ComboBox.ItemIndex];
    PosColon := Pos('点', ScoreStr);
    if PosColon > 0 then
    begin
      ScoreStr := Copy(ScoreStr, 1, PosColon - 1);
      try
        Result := StrToInt(ScoreStr);
      except
        Result := 0;
      end;
    end;
  end;
end;

procedure TFormMain.UpdateTotalScore;
var
  TotalScore: Integer;
begin
  TotalScore := 0;

  // 各評価項目のスコアを合計
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox1);   // 食事
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox2);   // 移動
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox3);   // 整容
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox4);   // トイレ動作
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox5);   // 入浴
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox6);   // 歩行
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox7);   // 階段昇降
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox8);   // 更衣
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox9);   // 排便コントロール
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox10);  // 排尿コントロール

  LabelTotalScore.Caption := IntToStr(TotalScore) + '点';
end;

procedure TFormMain.CalculateTotal(Sender: TObject);
begin
  UpdateTotalScore;
end;

procedure TFormMain.ButtonSaveClick(Sender: TObject);
var
  FileList: TStringList;
  I: Integer;
begin
  if SaveDialog1.Execute then
  begin
    FileList := TStringList.Create;
    try
      // 患者情報
      FileList.Add('[PatientInfo]');
      FileList.Add('PatientID=' + EditPatientID.Text);
      FileList.Add('PatientName=' + EditPatientName.Text);
      FileList.Add('EvalDate=' + DateToStr(DateTimePickerEval.Date));
      FileList.Add('');

      // 評価項目
      FileList.Add('[Evaluation]');
      FileList.Add('Item1=' + IntToStr(ComboBox1.ItemIndex));
      FileList.Add('Item2=' + IntToStr(ComboBox2.ItemIndex));
      FileList.Add('Item3=' + IntToStr(ComboBox3.ItemIndex));
      FileList.Add('Item4=' + IntToStr(ComboBox4.ItemIndex));
      FileList.Add('Item5=' + IntToStr(ComboBox5.ItemIndex));
      FileList.Add('Item6=' + IntToStr(ComboBox6.ItemIndex));
      FileList.Add('Item7=' + IntToStr(ComboBox7.ItemIndex));
      FileList.Add('Item8=' + IntToStr(ComboBox8.ItemIndex));
      FileList.Add('Item9=' + IntToStr(ComboBox9.ItemIndex));
      FileList.Add('Item10=' + IntToStr(ComboBox10.ItemIndex));
      FileList.Add('');

      // 合計点
      FileList.Add('[Score]');
      FileList.Add('TotalScore=' + LabelTotalScore.Caption);

      FileList.SaveToFile(SaveDialog1.FileName);
      ShowMessage('データを保存しました。');
    finally
      FileList.Free;
    end;
  end;
end;

procedure TFormMain.ButtonLoadClick(Sender: TObject);
var
  FileList: TStringList;
  I: Integer;
  Line, Key, Value: string;
  PosEqual: Integer;
begin
  if OpenDialog1.Execute then
  begin
    FileList := TStringList.Create;
    try
      FileList.LoadFromFile(OpenDialog1.FileName);

      for I := 0 to FileList.Count - 1 do
      begin
        Line := Trim(FileList[I]);
        if (Line = '') or (Line[1] = '[') then
          Continue;

        PosEqual := Pos('=', Line);
        if PosEqual > 0 then
        begin
          Key := Trim(Copy(Line, 1, PosEqual - 1));
          Value := Trim(Copy(Line, PosEqual + 1, Length(Line)));

          // 患者情報
          if Key = 'PatientID' then
            EditPatientID.Text := Value
          else if Key = 'PatientName' then
            EditPatientName.Text := Value
          else if Key = 'EvalDate' then
            DateTimePickerEval.Date := StrToDate(Value)
          // 評価項目
          else if Key = 'Item1' then
            ComboBox1.ItemIndex := StrToInt(Value)
          else if Key = 'Item2' then
            ComboBox2.ItemIndex := StrToInt(Value)
          else if Key = 'Item3' then
            ComboBox3.ItemIndex := StrToInt(Value)
          else if Key = 'Item4' then
            ComboBox4.ItemIndex := StrToInt(Value)
          else if Key = 'Item5' then
            ComboBox5.ItemIndex := StrToInt(Value)
          else if Key = 'Item6' then
            ComboBox6.ItemIndex := StrToInt(Value)
          else if Key = 'Item7' then
            ComboBox7.ItemIndex := StrToInt(Value)
          else if Key = 'Item8' then
            ComboBox8.ItemIndex := StrToInt(Value)
          else if Key = 'Item9' then
            ComboBox9.ItemIndex := StrToInt(Value)
          else if Key = 'Item10' then
            ComboBox10.ItemIndex := StrToInt(Value);
        end;
      end;

      UpdateTotalScore;
      ShowMessage('データを読み込みました。');
    finally
      FileList.Free;
    end;
  end;
end;

procedure TFormMain.ButtonClearClick(Sender: TObject);
var
  I: Integer;
begin
  if MessageDlg('すべての入力内容をクリアします。よろしいですか？',
                mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    EditPatientID.Text := '';
    EditPatientName.Text := '';
    DateTimePickerEval.Date := Now;

    ComboBox1.ItemIndex := -1;
    ComboBox2.ItemIndex := -1;
    ComboBox3.ItemIndex := -1;
    ComboBox4.ItemIndex := -1;
    ComboBox5.ItemIndex := -1;
    ComboBox6.ItemIndex := -1;
    ComboBox7.ItemIndex := -1;
    ComboBox8.ItemIndex := -1;
    ComboBox9.ItemIndex := -1;
    ComboBox10.ItemIndex := -1;

    UpdateTotalScore;
  end;
end;

end.
