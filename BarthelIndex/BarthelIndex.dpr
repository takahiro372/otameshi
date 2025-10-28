program BarthelIndex;

uses
  Forms,
  MainForm in 'MainForm.pas' {FormMain},
  DBModule in 'DBModule.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.Title := 'Barthel Index Manager';
  Application.CreateForm(TDataModule1, DataModule1);
  Application.CreateForm(TFormMain, FormMain);
  Application.Run;
end.
