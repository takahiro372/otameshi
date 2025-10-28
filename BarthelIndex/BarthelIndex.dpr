program BarthelIndex;

uses
  Forms,
  MainForm in 'MainForm.pas' {FormMain};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'バーセルインデックス評価管理システム';
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
