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
    procedure InitializeComboBoxes;
  public
    { Public declarations }
  end;

var
  FormMain: TFormMain;

implementation

{$R *.dfm}

procedure TFormMain.FormCreate(Sender: TObject);
begin
  InitializeComboBoxes;
  UpdateTotalScore;
end;

procedure TFormMain.InitializeComboBoxes;
begin
  // ComboBox1 - Feeding
  ComboBox1.Items.Clear;
  ComboBox1.Items.Add('0: Total assistance');
  ComboBox1.Items.Add('5: Partial assistance');
  ComboBox1.Items.Add('10: Independent');

  // ComboBox2 - Transfer (Bed to Chair)
  ComboBox2.Items.Clear;
  ComboBox2.Items.Add('0: Total assistance');
  ComboBox2.Items.Add('5: Major assistance');
  ComboBox2.Items.Add('10: Minor assistance');
  ComboBox2.Items.Add('15: Independent');

  // ComboBox3 - Grooming
  ComboBox3.Items.Clear;
  ComboBox3.Items.Add('0: Needs help');
  ComboBox3.Items.Add('5: Independent');

  // ComboBox4 - Toilet Use
  ComboBox4.Items.Clear;
  ComboBox4.Items.Add('0: Dependent');
  ComboBox4.Items.Add('5: Needs help');
  ComboBox4.Items.Add('10: Independent');

  // ComboBox5 - Bathing
  ComboBox5.Items.Clear;
  ComboBox5.Items.Add('0: Dependent');
  ComboBox5.Items.Add('5: Independent');

  // ComboBox6 - Mobility (Walking)
  ComboBox6.Items.Clear;
  ComboBox6.Items.Add('0: Immobile or < 50m');
  ComboBox6.Items.Add('5: Wheelchair 50m');
  ComboBox6.Items.Add('10: Walks with help 50m');
  ComboBox6.Items.Add('15: Independent 50m');

  // ComboBox7 - Stairs
  ComboBox7.Items.Clear;
  ComboBox7.Items.Add('0: Unable');
  ComboBox7.Items.Add('5: Needs help');
  ComboBox7.Items.Add('10: Independent');

  // ComboBox8 - Dressing
  ComboBox8.Items.Clear;
  ComboBox8.Items.Add('0: Dependent');
  ComboBox8.Items.Add('5: Needs help');
  ComboBox8.Items.Add('10: Independent');

  // ComboBox9 - Bowel Control
  ComboBox9.Items.Clear;
  ComboBox9.Items.Add('0: Incontinent or catheter');
  ComboBox9.Items.Add('5: Occasional accident');
  ComboBox9.Items.Add('10: Continent');

  // ComboBox10 - Bladder Control
  ComboBox10.Items.Clear;
  ComboBox10.Items.Add('0: Incontinent or catheter');
  ComboBox10.Items.Add('5: Occasional accident');
  ComboBox10.Items.Add('10: Continent');
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
    PosColon := Pos(':', ScoreStr);
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

  // Sum all evaluation items
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox1);   // Feeding
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox2);   // Transfer
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox3);   // Grooming
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox4);   // Toilet Use
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox5);   // Bathing
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox6);   // Mobility
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox7);   // Stairs
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox8);   // Dressing
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox9);   // Bowel Control
  TotalScore := TotalScore + GetScoreFromComboBox(ComboBox10);  // Bladder Control

  LabelTotalScore.Caption := IntToStr(TotalScore) + ' pts';
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
      // Patient Information
      FileList.Add('[PatientInfo]');
      FileList.Add('PatientID=' + EditPatientID.Text);
      FileList.Add('PatientName=' + EditPatientName.Text);
      FileList.Add('EvalDate=' + DateToStr(DateTimePickerEval.Date));
      FileList.Add('');

      // Evaluation Items
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

      // Total Score
      FileList.Add('[Score]');
      FileList.Add('TotalScore=' + LabelTotalScore.Caption);

      FileList.SaveToFile(SaveDialog1.FileName);
      ShowMessage('Data saved successfully.');
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

          // Patient Information
          if Key = 'PatientID' then
            EditPatientID.Text := Value
          else if Key = 'PatientName' then
            EditPatientName.Text := Value
          else if Key = 'EvalDate' then
            DateTimePickerEval.Date := StrToDate(Value)
          // Evaluation Items
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
      ShowMessage('Data loaded successfully.');
    finally
      FileList.Free;
    end;
  end;
end;

procedure TFormMain.ButtonClearClick(Sender: TObject);
var
  I: Integer;
begin
  if MessageDlg('Clear all input data. Are you sure?',
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
