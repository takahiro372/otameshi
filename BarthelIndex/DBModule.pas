unit DBModule;

interface

uses
  SysUtils, Classes, DB, ADODB, Dialogs, IniFiles;

type
  TDataModule1 = class(TDataModule)
    ADOConnection1: TADOConnection;
    ADOQueryPatients: TADOQuery;
    ADOQueryEvaluations: TADOQuery;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    FConnectionString: string;
    function GetConnectionString: string;
    procedure LoadConnectionSettings;
    procedure SaveConnectionSettings(const Server, Database, Username, Password: string);
  public
    { Public declarations }
    function ConnectToDatabase: Boolean;
    procedure DisconnectFromDatabase;
    function IsConnected: Boolean;

    // Patient operations
    function InsertOrUpdatePatient(const PatientID, PatientName: string): Boolean;
    function PatientExists(const PatientID: string): Boolean;

    // Evaluation operations
    function SaveEvaluation(const PatientID, EvalType: string;
      EvalDate: TDateTime; const Scores: array of Integer;
      TotalScore: Integer; const Evaluator: string): Boolean;
    function LoadEvaluation(const PatientID, EvalType: string;
      var EvalDate: TDateTime; var Scores: array of Integer;
      var TotalScore: Integer): Boolean;
    function EvaluationExists(const PatientID, EvalType: string): Boolean;

    property ConnectionString: string read GetConnectionString;
  end;

var
  DataModule1: TDataModule1;

implementation

{$R *.dfm}

procedure TDataModule1.DataModuleCreate(Sender: TObject);
begin
  LoadConnectionSettings;
end;

function TDataModule1.GetConnectionString: string;
begin
  Result := FConnectionString;
end;

procedure TDataModule1.LoadConnectionSettings;
var
  IniFile: TIniFile;
  IniFileName: string;
  Server, Database, Username, Password: string;
begin
  IniFileName := ExtractFilePath(ParamStr(0)) + 'DBConfig.ini';

  if FileExists(IniFileName) then
  begin
    IniFile := TIniFile.Create(IniFileName);
    try
      Server := IniFile.ReadString('Database', 'Server', 'localhost');
      Database := IniFile.ReadString('Database', 'Database', 'BarthelIndexDB');
      Username := IniFile.ReadString('Database', 'Username', 'sa');
      Password := IniFile.ReadString('Database', 'Password', '');

      FConnectionString := 'Provider=SQLOLEDB.1;' +
        'Data Source=' + Server + ';' +
        'Initial Catalog=' + Database + ';' +
        'User ID=' + Username + ';' +
        'Password=' + Password + ';';
    finally
      IniFile.Free;
    end;
  end
  else
  begin
    // Default connection string
    FConnectionString := 'Provider=SQLOLEDB.1;' +
      'Data Source=localhost;' +
      'Initial Catalog=BarthelIndexDB;' +
      'Integrated Security=SSPI;';
  end;
end;

procedure TDataModule1.SaveConnectionSettings(const Server, Database, Username, Password: string);
var
  IniFile: TIniFile;
  IniFileName: string;
begin
  IniFileName := ExtractFilePath(ParamStr(0)) + 'DBConfig.ini';
  IniFile := TIniFile.Create(IniFileName);
  try
    IniFile.WriteString('Database', 'Server', Server);
    IniFile.WriteString('Database', 'Database', Database);
    IniFile.WriteString('Database', 'Username', Username);
    IniFile.WriteString('Database', 'Password', Password);
  finally
    IniFile.Free;
  end;

  LoadConnectionSettings;
end;

function TDataModule1.ConnectToDatabase: Boolean;
begin
  Result := False;
  try
    ADOConnection1.Close;
    ADOConnection1.ConnectionString := FConnectionString;
    ADOConnection1.LoginPrompt := False;
    ADOConnection1.Open;
    Result := ADOConnection1.Connected;
  except
    on E: Exception do
    begin
      ShowMessage('Database connection failed: ' + E.Message);
      Result := False;
    end;
  end;
end;

procedure TDataModule1.DisconnectFromDatabase;
begin
  if ADOConnection1.Connected then
    ADOConnection1.Close;
end;

function TDataModule1.IsConnected: Boolean;
begin
  Result := ADOConnection1.Connected;
end;

function TDataModule1.InsertOrUpdatePatient(const PatientID, PatientName: string): Boolean;
var
  SQL: string;
begin
  Result := False;
  if not IsConnected then Exit;

  try
    if PatientExists(PatientID) then
    begin
      // Update existing patient
      SQL := 'UPDATE Patients SET PatientName = :PatientName, ' +
             'UpdatedDate = GETDATE() WHERE PatientID = :PatientID';
    end
    else
    begin
      // Insert new patient
      SQL := 'INSERT INTO Patients (PatientID, PatientName) ' +
             'VALUES (:PatientID, :PatientName)';
    end;

    ADOQueryPatients.Close;
    ADOQueryPatients.SQL.Clear;
    ADOQueryPatients.SQL.Add(SQL);
    ADOQueryPatients.Parameters.ParamByName('PatientID').Value := PatientID;
    ADOQueryPatients.Parameters.ParamByName('PatientName').Value := PatientName;
    ADOQueryPatients.ExecSQL;
    Result := True;
  except
    on E: Exception do
    begin
      ShowMessage('Failed to save patient: ' + E.Message);
      Result := False;
    end;
  end;
end;

function TDataModule1.PatientExists(const PatientID: string): Boolean;
var
  SQL: string;
begin
  Result := False;
  if not IsConnected then Exit;

  try
    SQL := 'SELECT COUNT(*) AS RecCount FROM Patients WHERE PatientID = :PatientID';
    ADOQueryPatients.Close;
    ADOQueryPatients.SQL.Clear;
    ADOQueryPatients.SQL.Add(SQL);
    ADOQueryPatients.Parameters.ParamByName('PatientID').Value := PatientID;
    ADOQueryPatients.Open;

    Result := ADOQueryPatients.FieldByName('RecCount').AsInteger > 0;
    ADOQueryPatients.Close;
  except
    Result := False;
  end;
end;

function TDataModule1.SaveEvaluation(const PatientID, EvalType: string;
  EvalDate: TDateTime; const Scores: array of Integer;
  TotalScore: Integer; const Evaluator: string): Boolean;
var
  SQL: string;
begin
  Result := False;
  if not IsConnected then Exit;
  if Length(Scores) < 10 then Exit;

  try
    // First, ensure patient exists
    if not PatientExists(PatientID) then
      Exit;

    if EvaluationExists(PatientID, EvalType) then
    begin
      // Update existing evaluation
      SQL := 'UPDATE BarthelEvaluations SET ' +
             'EvaluationDate = :EvalDate, ' +
             'Item1_Feeding = :Item1, Item2_Transfer = :Item2, ' +
             'Item3_Grooming = :Item3, Item4_ToiletUse = :Item4, ' +
             'Item5_Bathing = :Item5, Item6_Mobility = :Item6, ' +
             'Item7_Stairs = :Item7, Item8_Dressing = :Item8, ' +
             'Item9_BowelControl = :Item9, Item10_BladderControl = :Item10, ' +
             'TotalScore = :TotalScore, EvaluatorName = :Evaluator, ' +
             'UpdatedDate = GETDATE() ' +
             'WHERE PatientID = :PatientID AND EvaluationType = :EvalType';
    end
    else
    begin
      // Insert new evaluation
      SQL := 'INSERT INTO BarthelEvaluations ' +
             '(PatientID, EvaluationType, EvaluationDate, ' +
             'Item1_Feeding, Item2_Transfer, Item3_Grooming, Item4_ToiletUse, ' +
             'Item5_Bathing, Item6_Mobility, Item7_Stairs, Item8_Dressing, ' +
             'Item9_BowelControl, Item10_BladderControl, TotalScore, EvaluatorName) ' +
             'VALUES (:PatientID, :EvalType, :EvalDate, ' +
             ':Item1, :Item2, :Item3, :Item4, :Item5, ' +
             ':Item6, :Item7, :Item8, :Item9, :Item10, :TotalScore, :Evaluator)';
    end;

    ADOQueryEvaluations.Close;
    ADOQueryEvaluations.SQL.Clear;
    ADOQueryEvaluations.SQL.Add(SQL);
    ADOQueryEvaluations.Parameters.ParamByName('PatientID').Value := PatientID;
    ADOQueryEvaluations.Parameters.ParamByName('EvalType').Value := EvalType;
    ADOQueryEvaluations.Parameters.ParamByName('EvalDate').Value := EvalDate;
    ADOQueryEvaluations.Parameters.ParamByName('Item1').Value := Scores[0];
    ADOQueryEvaluations.Parameters.ParamByName('Item2').Value := Scores[1];
    ADOQueryEvaluations.Parameters.ParamByName('Item3').Value := Scores[2];
    ADOQueryEvaluations.Parameters.ParamByName('Item4').Value := Scores[3];
    ADOQueryEvaluations.Parameters.ParamByName('Item5').Value := Scores[4];
    ADOQueryEvaluations.Parameters.ParamByName('Item6').Value := Scores[5];
    ADOQueryEvaluations.Parameters.ParamByName('Item7').Value := Scores[6];
    ADOQueryEvaluations.Parameters.ParamByName('Item8').Value := Scores[7];
    ADOQueryEvaluations.Parameters.ParamByName('Item9').Value := Scores[8];
    ADOQueryEvaluations.Parameters.ParamByName('Item10').Value := Scores[9];
    ADOQueryEvaluations.Parameters.ParamByName('TotalScore').Value := TotalScore;
    ADOQueryEvaluations.Parameters.ParamByName('Evaluator').Value := Evaluator;
    ADOQueryEvaluations.ExecSQL;

    Result := True;
  except
    on E: Exception do
    begin
      ShowMessage('Failed to save evaluation: ' + E.Message);
      Result := False;
    end;
  end;
end;

function TDataModule1.LoadEvaluation(const PatientID, EvalType: string;
  var EvalDate: TDateTime; var Scores: array of Integer;
  var TotalScore: Integer): Boolean;
var
  SQL: string;
begin
  Result := False;
  if not IsConnected then Exit;
  if Length(Scores) < 10 then Exit;

  try
    SQL := 'SELECT * FROM BarthelEvaluations ' +
           'WHERE PatientID = :PatientID AND EvaluationType = :EvalType';

    ADOQueryEvaluations.Close;
    ADOQueryEvaluations.SQL.Clear;
    ADOQueryEvaluations.SQL.Add(SQL);
    ADOQueryEvaluations.Parameters.ParamByName('PatientID').Value := PatientID;
    ADOQueryEvaluations.Parameters.ParamByName('EvalType').Value := EvalType;
    ADOQueryEvaluations.Open;

    if not ADOQueryEvaluations.EOF then
    begin
      EvalDate := ADOQueryEvaluations.FieldByName('EvaluationDate').AsDateTime;
      Scores[0] := ADOQueryEvaluations.FieldByName('Item1_Feeding').AsInteger;
      Scores[1] := ADOQueryEvaluations.FieldByName('Item2_Transfer').AsInteger;
      Scores[2] := ADOQueryEvaluations.FieldByName('Item3_Grooming').AsInteger;
      Scores[3] := ADOQueryEvaluations.FieldByName('Item4_ToiletUse').AsInteger;
      Scores[4] := ADOQueryEvaluations.FieldByName('Item5_Bathing').AsInteger;
      Scores[5] := ADOQueryEvaluations.FieldByName('Item6_Mobility').AsInteger;
      Scores[6] := ADOQueryEvaluations.FieldByName('Item7_Stairs').AsInteger;
      Scores[7] := ADOQueryEvaluations.FieldByName('Item8_Dressing').AsInteger;
      Scores[8] := ADOQueryEvaluations.FieldByName('Item9_BowelControl').AsInteger;
      Scores[9] := ADOQueryEvaluations.FieldByName('Item10_BladderControl').AsInteger;
      TotalScore := ADOQueryEvaluations.FieldByName('TotalScore').AsInteger;
      Result := True;
    end;

    ADOQueryEvaluations.Close;
  except
    on E: Exception do
    begin
      ShowMessage('Failed to load evaluation: ' + E.Message);
      Result := False;
    end;
  end;
end;

function TDataModule1.EvaluationExists(const PatientID, EvalType: string): Boolean;
var
  SQL: string;
begin
  Result := False;
  if not IsConnected then Exit;

  try
    SQL := 'SELECT COUNT(*) AS RecCount FROM BarthelEvaluations ' +
           'WHERE PatientID = :PatientID AND EvaluationType = :EvalType';

    ADOQueryEvaluations.Close;
    ADOQueryEvaluations.SQL.Clear;
    ADOQueryEvaluations.SQL.Add(SQL);
    ADOQueryEvaluations.Parameters.ParamByName('PatientID').Value := PatientID;
    ADOQueryEvaluations.Parameters.ParamByName('EvalType').Value := EvalType;
    ADOQueryEvaluations.Open;

    Result := ADOQueryEvaluations.FieldByName('RecCount').AsInteger > 0;
    ADOQueryEvaluations.Close;
  except
    Result := False;
  end;
end;

end.
