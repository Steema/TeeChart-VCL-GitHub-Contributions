object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'GitHub Contributions'
  ClientHeight = 251
  ClientWidth = 827
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 827
    Height = 44
    Align = alTop
    TabOrder = 0
    object LUsername: TLabel
      Left = 8
      Top = 13
      Width = 99
      Height = 15
      Caption = 'GitHub UserName:'
    end
    object EUsername: TEdit
      Left = 113
      Top = 10
      Width = 121
      Height = 23
      TabOrder = 0
    end
    object BGetContributions: TButton
      Left = 248
      Top = 9
      Width = 153
      Height = 25
      Caption = 'Get Contributions'
      TabOrder = 1
      OnClick = BGetContributionsClick
    end
    object BTheme: TButton
      Left = 776
      Top = 9
      Width = 41
      Height = 25
      Caption = 'Dark'
      TabOrder = 2
      OnClick = BThemeClick
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 44
    Width = 827
    Height = 69
    Align = alTop
    TabOrder = 1
    object LFirstDayWeek: TLabel
      Left = 8
      Top = 38
      Width = 111
      Height = 15
      Caption = 'First day of the week:'
    end
    object Label1: TLabel
      Left = 8
      Top = 9
      Width = 57
      Height = 15
      Caption = 'Show Year:'
    end
    object CBYears: TComboBox
      Left = 71
      Top = 6
      Width = 97
      Height = 23
      Style = csDropDownList
      TabOrder = 0
      OnChange = CBYearsChange
    end
    object CBFirstDayOfWeek: TComboBox
      Left = 137
      Top = 35
      Width = 97
      Height = 23
      Style = csDropDownList
      ItemIndex = 0
      TabOrder = 1
      Text = 'Monday'
      OnChange = CBFirstDayOfWeekChange
      Items.Strings = (
        'Monday'
        'Sunday')
    end
  end
  object Chart1: TChart
    Left = 0
    Top = 113
    Width = 827
    Height = 138
    BackWall.Brush.Gradient.Direction = gdBottomTop
    BackWall.Brush.Gradient.EndColor = clWhite
    BackWall.Brush.Gradient.StartColor = 15395562
    BackWall.Brush.Gradient.Visible = True
    BackWall.Transparent = False
    Foot.Font.Color = clBlue
    Foot.Font.Name = 'Verdana'
    Gradient.Direction = gdBottomTop
    Gradient.EndColor = clWhite
    Gradient.MidColor = 15395562
    Gradient.StartColor = 15395562
    LeftWall.Color = clLightyellow
    Legend.Font.Name = 'Verdana'
    Legend.Shadow.Transparency = 0
    Legend.Visible = False
    RightWall.Color = clLightyellow
    Title.Font.Name = 'Verdana'
    Title.Text.Strings = (
      'TChart')
    Title.Visible = False
    AxisVisible = False
    BottomAxis.Axis.Color = 4210752
    BottomAxis.Grid.Color = clDarkgray
    BottomAxis.LabelsFormat.Font.Name = 'Verdana'
    BottomAxis.TicksInner.Color = clDarkgray
    BottomAxis.Title.Font.Name = 'Verdana'
    DepthAxis.Axis.Color = 4210752
    DepthAxis.Grid.Color = clDarkgray
    DepthAxis.LabelsFormat.Font.Name = 'Verdana'
    DepthAxis.TicksInner.Color = clDarkgray
    DepthAxis.Title.Font.Name = 'Verdana'
    DepthTopAxis.Axis.Color = 4210752
    DepthTopAxis.Grid.Color = clDarkgray
    DepthTopAxis.LabelsFormat.Font.Name = 'Verdana'
    DepthTopAxis.TicksInner.Color = clDarkgray
    DepthTopAxis.Title.Font.Name = 'Verdana'
    LeftAxis.Axis.Color = 4210752
    LeftAxis.Grid.Color = clDarkgray
    LeftAxis.LabelsFormat.Font.Name = 'Verdana'
    LeftAxis.TicksInner.Color = clDarkgray
    LeftAxis.Title.Font.Name = 'Verdana'
    RightAxis.Axis.Color = 4210752
    RightAxis.Grid.Color = clDarkgray
    RightAxis.LabelsFormat.Font.Name = 'Verdana'
    RightAxis.TicksInner.Color = clDarkgray
    RightAxis.Title.Font.Name = 'Verdana'
    TopAxis.Axis.Color = 4210752
    TopAxis.Grid.Color = clDarkgray
    TopAxis.LabelsFormat.Font.Name = 'Verdana'
    TopAxis.TicksInner.Color = clDarkgray
    TopAxis.Title.Font.Name = 'Verdana'
    View3D = False
    View3DWalls = False
    Align = alClient
    Color = clWhite
    TabOrder = 2
    DefaultCanvas = 'TGDIPlusCanvas'
    ColorPaletteIndex = 13
    object Series1: TPointSeries
      Active = False
      ClickableLine = False
      Pointer.InflateMargins = True
      Pointer.Style = psRectangle
      XValues.Name = 'X'
      XValues.Order = loAscending
      YValues.Name = 'Y'
      YValues.Order = loNone
    end
    object ChartTool1: TMarksTipTool
      Format.CustomPosition = True
      Format.Left = 0
      Format.TextAlignment = taCenter
      Format.Top = 0
      Format.Visible = False
      Series = Series1
    end
  end
end
