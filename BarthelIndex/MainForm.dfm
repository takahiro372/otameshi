object FormMain: TFormMain
  Left = 192
  Top = 107
  Width = 680
  Height = 600
  Caption = 'Barthel Index Manager'
  Color = clBtnFace
  Font.Charset = SHIFTJIS_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'MS UI Gothic'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 12
  object GroupBox1: TGroupBox
    Left = 8
    Top = 8
    Width = 656
    Height = 97
    Caption = 'Patient Info'
    TabOrder = 0
    object Label1: TLabel
      Left = 16
      Top = 24
      Width = 50
      Height = 12
      Caption = 'Patient ID:'
    end
    object Label2: TLabel
      Left = 16
      Top = 56
      Width = 68
      Height = 12
      Caption = 'Patient Name:'
    end
    object Label3: TLabel
      Left = 320
      Top = 24
      Width = 80
      Height = 12
      Caption = 'Evaluation Date:'
    end
    object EditPatientID: TEdit
      Left = 96
      Top = 20
      Width = 121
      Height = 20
      TabOrder = 0
    end
    object EditPatientName: TEdit
      Left = 96
      Top = 52
      Width = 201
      Height = 20
      TabOrder = 1
    end
    object DateTimePickerEval: TDateTimePicker
      Left = 416
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
    Caption = 'Evaluation Items'
    TabOrder = 1
    object Label4: TLabel
      Left = 16
      Top = 24
      Width = 180
      Height = 12
      Caption = '1. Feeding'
    end
    object Label5: TLabel
      Left = 16
      Top = 56
      Width = 180
      Height = 12
      Caption = '2. Transfer (Bed to Chair)'
    end
    object Label6: TLabel
      Left = 16
      Top = 88
      Width = 180
      Height = 12
      Caption = '3. Grooming'
    end
    object Label7: TLabel
      Left = 16
      Top = 120
      Width = 180
      Height = 12
      Caption = '4. Toilet Use'
    end
    object Label8: TLabel
      Left = 16
      Top = 152
      Width = 180
      Height = 12
      Caption = '5. Bathing'
    end
    object Label9: TLabel
      Left = 16
      Top = 184
      Width = 180
      Height = 12
      Caption = '6. Mobility (Walking)'
    end
    object Label10: TLabel
      Left = 16
      Top = 216
      Width = 180
      Height = 12
      Caption = '7. Stairs'
    end
    object Label11: TLabel
      Left = 16
      Top = 248
      Width = 180
      Height = 12
      Caption = '8. Dressing'
    end
    object Label12: TLabel
      Left = 16
      Top = 280
      Width = 180
      Height = 12
      Caption = '9. Bowel Control'
    end
    object Label13: TLabel
      Left = 16
      Top = 312
      Width = 180
      Height = 12
      Caption = '10. Bladder Control'
    end
    object Label14: TLabel
      Left = 400
      Top = 360
      Width = 60
      Height = 12
      Caption = 'Total Score:'
    end
    object LabelTotalScore: TLabel
      Left = 472
      Top = 356
      Width = 48
      Height = 19
      Caption = '0 pts'
      Font.Charset = SHIFTJIS_CHARSET
      Font.Color = clWindowText
      Font.Height = -19
      Font.Name = 'MS UI Gothic'
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
    end
  end
  object ButtonSave: TButton
    Left = 448
    Top = 520
    Width = 105
    Height = 33
    Caption = 'Save'
    TabOrder = 2
    OnClick = ButtonSaveClick
  end
  object ButtonLoad: TButton
    Left = 336
    Top = 520
    Width = 105
    Height = 33
    Caption = 'Load'
    TabOrder = 3
    OnClick = ButtonLoadClick
  end
  object ButtonClear: TButton
    Left = 224
    Top = 520
    Width = 105
    Height = 33
    Caption = 'Clear'
    TabOrder = 4
    OnClick = ButtonClearClick
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'bi'
    Filter = 'Barthel Index Data (*.bi)|*.bi|All Files (*.*)|*.*'
    Left = 24
    Top = 520
  end
  object OpenDialog1: TOpenDialog
    DefaultExt = 'bi'
    Filter = 'Barthel Index Data (*.bi)|*.bi|All Files (*.*)|*.*'
    Left = 64
    Top = 520
  end
end
