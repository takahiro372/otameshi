object DataModule1: TDataModule1
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  Left = 192
  Top = 107
  Height = 150
  Width = 215
  object ADOConnection1: TADOConnection
    LoginPrompt = False
    Mode = cmShareDenyNone
    Provider = 'SQLOLEDB.1'
    Left = 24
    Top = 16
  end
  object ADOQueryPatients: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 24
    Top = 64
  end
  object ADOQueryEvaluations: TADOQuery
    Connection = ADOConnection1
    Parameters = <>
    Left = 120
    Top = 64
  end
end
