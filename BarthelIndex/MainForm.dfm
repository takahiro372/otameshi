object FormMain: TFormMain
  Left = 192
  Top = 107
  Width = 680
  Height = 600
  Caption = #12496#12540#12475#12523#12452#12531#12487#12483#12463#12473#35413#20385#31649#29702#12471#12473#12486#12512
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 656
    Height = 97
    Caption = #24739#32773#24773#22577
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 36
      Height = 12
      Caption = #24739#32773'ID:'
    end
    object Label2: TLabel
      Left = 16
      Top = 56
      Width = 48
      Height = 12
      Caption = #24739#32773#21517#65306
    end
    object Label3: TLabel
      Left = 320
      Top = 24
      Width = 60
      Height = 12
      Caption = #35413#20385#26085#20184#65306
    end
    object EditPatientID: TEdit
      Left = 64
      Top = 20
      Width = 121
      Height = 20
      TabOrder = 0
    end
    object EditPatientName: TEdit
      Left = 64
      Top = 52
      Width = 233
      Height = 20
      TabOrder = 1
    end
    object DateTimePickerEval: TDateTimePicker
      Left = 384
      Top = 20
      Width = 145
      Height = 20
      Date = 45000.000000000000000000
      Time = 45000.000000000000000000
      TabOrder = 2
    end
  end
  object GroupBox2: TGroupBox
    Left = 8
    Top = 112
    Width = 656
    Height = 393
    Caption = #35413#20385#38917#30446
    TabOrder = 1
    object Label4: TLabel
      Left = 16
      Top = 24
      Width = 24
      Height = 12
      Caption = #39135#20107
    end
    object Label5: TLabel
      Left = 16
      Top = 56
      Width = 132
      Height = 12
      Caption = #36554#26885#23376#12363#12425#12505#12483#12489#12408#12398#31227#21205
    end
    object Label6: TLabel
      Left = 16
      Top = 88
      Width = 84
      Height = 12
      Caption = #25972#23481'('#36523#12384#12375#12394#12415')'
    end
    object Label7: TLabel
      Left = 16
      Top = 120
      Width = 60
      Height = 12
      Caption = #12488#12452#12524#21205#20316
    end
    object Label8: TLabel
      Left = 16
      Top = 152
      Width = 24
      Height = 12
      Caption = #20837#27983
    end
    object Label9: TLabel
      Left = 16
      Top = 184
      Width = 24
      Height = 12
      Caption = #27497#34892
    end
    object Label10: TLabel
      Left = 16
      Top = 216
      Width = 48
      Height = 12
      Caption = #38542#27573#26119#38477
    end
    object Label11: TLabel
      Left = 16
      Top = 248
      Width = 24
      Height = 12
      Caption = #26356#34915
    end
    object Label12: TLabel
      Left = 16
      Top = 280
      Width = 96
      Height = 12
      Caption = #25490#20415#12467#12531#12488#12525#12540#12523
    end
    object Label13: TLabel
      Left = 16
      Top = 312
      Width = 96
      Height = 12
      Caption = #25490#23615#12467#12531#12488#12525#12540#12523
    end
    object Label14: TLabel
      Left = 400
      Top = 360
      Width = 60
      Height = 12
      Caption = #21512#35336#24471#28857#65306
    end
    object LabelTotalScore: TLabel
      Left = 472
      Top = 356
      Width = 60
      Height = 19
      Caption = '0'#28857
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = #65325#65331' '#65328#12468#12471#12483#12463
      Font.Style = [fsBold]
      ParentFont = False
    end
    object ComboBox1: TComboBox
      Left = 200
      Top = 20
      Width = 425
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 0
      OnChange = CalculateTotal
      Items.Strings = (
        '0'#28857': '#20840#20171#20171
        '5'#28857': '#19968#37096#20171#21161
        '10'#28857': '#33258#31435)
    end
    object ComboBox2: TComboBox
      Left = 200
      Top = 52
      Width = 425
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 1
      OnChange = CalculateTotal
      Items.Strings = (
        '0'#28857': '#20840#20171#20171
        '5'#28857': '#22810#22823#12394#20171#21161#12364#24517#35201
        '10'#28857': '#23569#12375#20171#21161#12364#24517#35201
        '15'#28857': '#33258#31435)
    end
    object ComboBox3: TComboBox
      Left = 200
      Top = 84
      Width = 425
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 2
      OnChange = CalculateTotal
      Items.Strings = (
        '0'#28857': '#20840#20171#20171
        '5'#28857': '#33258#31435)
    end
    object ComboBox4: TComboBox
      Left = 200
      Top = 116
      Width = 425
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 3
      OnChange = CalculateTotal
      Items.Strings = (
        '0'#28857': '#20840#20171#20171
        '5'#28857': '#20171#21161#12364#24517#35201
        '10'#28857': '#33258#31435)
    end
    object ComboBox5: TComboBox
      Left = 200
      Top = 148
      Width = 425
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 4
      OnChange = CalculateTotal
      Items.Strings = (
        '0'#28857': '#20840#20171#20171
        '5'#28857': '#33258#31435)
    end
    object ComboBox6: TComboBox
      Left = 200
      Top = 180
      Width = 425
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 5
      OnChange = CalculateTotal
      Items.Strings = (
        '0'#28857': '#27497#34892#19981#21487' or 50m'#26410#28288
        '5'#28857': '#36554#26885#23376#12391'50m
        '10'#28857': '#27497#34892#22120#12391'50m'#12289#35036#20855'or'#26564#12391#20171#21161#12364#24517#35201
        '15'#28857': '50m#33258#31435)
    end
    object ComboBox7: TComboBox
      Left = 200
      Top = 212
      Width = 425
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 6
      OnChange = CalculateTotal
      Items.Strings = (
        '0'#28857': '#19981#21487
        '5'#28857': #20171#21161#12364#24517#35201
        '10'#28857': '#33258#31435)
    end
    object ComboBox8: TComboBox
      Left = 200
      Top = 244
      Width = 425
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 7
      OnChange = CalculateTotal
      Items.Strings = (
        '0'#28857': '#20840#20171#20171
        '5'#28857': '#20171#21161#12364#24517#35201
        '10'#28857': '#33258#31435)
    end
    object ComboBox9: TComboBox
      Left = 200
      Top = 276
      Width = 425
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 8
      OnChange = CalculateTotal
      Items.Strings = (
        '0'#28857': '#22833#22833#22833#22833' or '#22833#23615#12289#20108#33144
        '5'#28857': #26178#12293#22833#22833'(1'#22238'/'#36913')'
        '10'#28857': '#12467#12531#12488#12525#12540#12523#33391#22909)
    end
    object ComboBox10: TComboBox
      Left = 200
      Top = 308
      Width = 425
      Height = 20
      Style = csDropDownList
      ItemHeight = 12
      TabOrder = 9
      OnChange = CalculateTotal
      Items.Strings = (
        '0'#28857': '#22833#22833#22833#22833' or '#23615#38996
        '5'#28857': #26178#12293#22833#22833'(1'#22238'/'#36913')'
        '10'#28857': '#12467#12531#12488#12525#12540#12523#33391#22909)
    end
  end
  object ButtonSave: TButton
    Left = 448
    Top = 520
    Width = 105
    Height = 33
    Caption = #20445#23384
    TabOrder = 2
    OnClick = ButtonSaveClick
  end
  object ButtonLoad: TButton
    Left = 336
    Top = 520
    Width = 105
    Height = 33
    Caption = #35501#12415#36796#12415
    TabOrder = 3
    OnClick = ButtonLoadClick
  end
  object ButtonClear: TButton
    Left = 224
    Top = 520
    Width = 105
    Height = 33
    Caption = #12463#12522#12450
    TabOrder = 4
    OnClick = ButtonClearClick
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'bi'
    Filter = #12496#12540#12475#12523#12452#12531#12487#12483#12463#12473#12487#12540#12479' (*.bi)|*.bi|'#12377#12409#12390#12398#12501#12449#12452#12523' (*.*)|*.*'
    Left = 24
    Top = 520
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'bi'
    Filter = #12496#12540#12475#12523#12452#12531#12487#12483#12463#12473#12487#12540#12479' (*.bi)|*.bi|'#12377#12409#12390#12398#12501#12449#12452#12523' (*.*)|*.*'
    Left = 64
    Top = 520
  end
end
