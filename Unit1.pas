unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  System.Rtti, System.Generics.Collections, DateUtils,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  System.Net.HttpClient, System.Net.HttpClientComponent,
  System.JSON, System.JSON.Readers, System.JSON.Types, System.JSON.Builders,
  Vcl.StdCtrls, Vcl.ExtCtrls, VCLTee.TeEngine, VCLTee.TeeProcs, VCLTee.Chart,
  VCLTee.TeeSurfa, VCLTee.Series, VCLTee.TeeTools,
  Themes;

type
  TForm1 = class(TForm)
    EUsername: TEdit;
    BGetContributions: TButton;
    Panel1: TPanel;
    Panel2: TPanel;
    CBYears: TComboBox;
    Chart1: TChart;
    Series1: TPointSeries;
    ChartTool1: TMarksTipTool;
    CBFirstDayOfWeek: TComboBox;
    LFirstDayWeek: TLabel;
    LUsername: TLabel;
    Label1: TLabel;
    BTheme: TButton;
    procedure FormCreate(Sender: TObject);
    procedure BGetContributionsClick(Sender: TObject);
    procedure CBYearsChange(Sender: TObject);
    procedure CBFirstDayOfWeekChange(Sender: TObject);
    procedure BThemeClick(Sender: TObject);
  private
    { Private declarations }
    procedure DrawChart;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  gitHubContributions: TJSONObject;
  monthTitles: TArray<TAnnotationTool>;
  dayTitles: TArray<TAnnotationTool>;
  currentTheme: TTheme;

function DownloadWeb(aURL: string): string;
var httpClient: TNetHTTPClient;
begin
  httpClient := TNetHTTPClient.Create(nil);
  try
    Result := httpClient.Get(aURL).ContentAsString;
  finally
    httpClient.Free;
  end;
end;

function GetGitHubContributions(username: string): TJSONObject;
var
  response: string;
begin
  response := DownloadWeb(Format('https://github-contributions.vercel.app/api/v1/%s', [username]));
  Result := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(response), 0) as TJSONObject;
end;

procedure TForm1.BGetContributionsClick(Sender: TObject);
var
  iterator:     TJSONIterator;
  years:        TJSONArray;
begin
  Screen.Cursor := crHourGlass;
  CBYears.Enabled := False;
  CBYears.Clear;

  gitHubContributions := GetGitHubContributions(EUsername.Text);

  if not gitHubContributions.TryGetValue<TJSONArray>('years', years) then
    Exit;

  iterator := TJSONIterator.Create(TJsonObjectReader.Create(years));
  while iterator.Next do
  begin
    iterator.Recurse;
    iterator.Next;
    CBYears.Items.Add(iterator.AsString);
    iterator.Return;
  end;

  if CBYears.Items.Count>0 then
  begin
    CBYears.Enabled := True;
    CBYears.ItemIndex := 0;
    CBYearsChange(Self);

    CBFirstDayOfWeek.Enabled := True;
  end;

  Screen.Cursor := crDefault;
end;

function FormatMark(ADate: TDateTime): string;
begin
  Result := Format('%s %d', [TFormatSettings.Invariant.LongMonthNames[MonthOf(ADate)], DayOf(ADate)]);

  case DayOf(ADate) of
    1, 21, 31: Result:=Result + 'st';
    2, 22: Result:=Result + 'nd';
    3, 23: Result:=Result + 'rd';
    else
       Result:=Result + 'th';
  end;
end;

procedure CustomWeekDayOfTheYear(ADate: TDateTime; AFirstDayOfWeek: Integer; var AWeek, ADay: Integer);
var
  tmpYear: Word;
begin
  AWeek := WeekOfTheYear(ADate, tmpYear);
  if tmpYear < YearOf(ADate) then
    AWeek := -1
  else if tmpYear > YearOf(ADate) then
    AWeek := WeeksInYear(ADate)+1;

  ADay:=DayOfTheWeek(ADate);

  if (AFirstDayOfWeek = 1) then
  begin
    ADay:=(ADay mod 7) + 1;

    if DayOfTheWeek(ADate) = 7 then
    begin
      Inc(AWeek);
    end;
  end;
end;

procedure TForm1.BThemeClick(Sender: TObject);
begin
  if BTheme.Caption = 'Dark' then
  begin
    currentTheme:=GithubDarkTheme;
    BTheme.Caption:='Light';
  end
  else
  begin
    currentTheme:=StandardTheme;
    BTheme.Caption:='Dark';
  end;

  Self.Color:=currentTheme.Background;
  Self.Font.Color:=currentTheme.Text;
  EUsername.Color:=currentTheme.Background;
  CBYears.Color:=currentTheme.Background;
  CBFirstDayOfWeek.Color:=currentTheme.Background;

  Chart1.Color:=currentTheme.Background;

  for var i:=0 to High(monthTitles) do
    monthTitles[i].Shape.Font.Color:=currentTheme.Text;

  for var i:=0 to High(dayTitles) do
    dayTitles[i].Shape.Font.Color:=currentTheme.Text;

  DrawChart;
end;

function IntensityThemeColor(AIntensity: Integer): TColor;
begin
  Result:=currentTheme.Grades[AIntensity];
end;

procedure TForm1.DrawChart;
var
  targetYear,
  tmpWeek,
  tmpDay,
  tmpIntensity: Integer;
  tmpYear: Word;
  tmpDate: TDateTime;
  tmpDateStr,
  tmpIntensityStr: string;
  contributions: TJSONArray;
  iterator: TJSONIterator;
  tmpFormatSettings: TFormatSettings;
begin
  Series1.Clear;
  Series1.Visible := False;

  tmpFormatSettings := FormatSettings;
  tmpFormatSettings.ShortDateFormat := 'yyyy-mm-dd';

  if (gitHubContributions = nil) or
     (not gitHubContributions.TryGetValue<TJSONArray>('contributions', contributions)) then
    Exit;

  if not TryStrToInt(CBYears.Items[CBYears.ItemIndex], targetYear) then
    Exit;

  iterator := TJSONIterator.Create(TJsonObjectReader.Create(contributions));

  while iterator.Next do
  begin
    iterator.Recurse;

    tmpDateStr := '';
    tmpIntensityStr := '';
    while iterator.Next do
    begin
      if iterator.Key = 'date' then
        tmpDateStr := iterator.AsString
      else if iterator.Key = 'intensity' then
        tmpIntensityStr := iterator.AsString;
    end;

    iterator.Return;

    if (tmpDateStr = '') or
       not TryStrToDate(tmpDateStr, tmpDate, tmpFormatSettings) then
      Continue;

    if (tmpIntensityStr = '') or
       not TryStrToInt(tmpIntensityStr, tmpIntensity) then
      Continue;

    if YearOf(tmpDate) <> targetYear then
      Continue;

    CustomWeekDayOfTheYear(tmpDate, CBFirstDayOfWeek.ItemIndex, tmpWeek, tmpDay);

    Series1.AddXY(tmpWeek, 7-tmpDay, FormatMark(tmpDate), IntensityThemeColor(tmpIntensity));
  end;

  Series1.Visible := True;
  Chart1.Show;
  Chart1.Draw;

  for var m:=0 to Length(monthTitles)-1 do
  begin
    tmpDate:=EncodeDate(targetYear, m+1, 1);

    with monthTitles[m] do
    begin
      Active:=True;
      Text:=TFormatSettings.Invariant.ShortMonthNames[MonthOf(tmpDate)];
      Top:=8;

      tmpWeek := WeekOfTheYear(tmpDate, tmpYear);
      if tmpYear = targetYear-1 then
        tmpWeek := 1;

      Left:=Chart1.Axes.Bottom.CalcPosValue(tmpWeek);
    end;
  end;

  for var d:=0 to Length(dayTitles)-1 do
  begin
    with dayTitles[d] do
    begin
      Active:=True;
      Text:=TFormatSettings.Invariant.ShortDayNames[(d+1)*2 + 1-CBFirstDayOfWeek.ItemIndex];
      Left:=10;
      Top:=Chart1.Axes.Left.CalcPosValue(6-(d*2) -1) - Abs(Font.Height div 2);
    end;
  end;
end;

procedure TForm1.CBFirstDayOfWeekChange(Sender: TObject);
begin
  CBYearsChange(Sender);
end;

procedure TForm1.CBYearsChange(Sender: TObject);
begin
  DrawChart;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  i: Integer;
begin
  EUsername.Text := 'sallar';
  CBYears.Enabled := False;
  CBFirstDayOfWeek.Enabled := False;

  Chart1.Hide;
  Chart1.AllowZoom := False;
  Chart1.AllowPanning := pmNone;
  Chart1.MarginTop := 20;
  Chart1.MarginLeft := 7;

  Series1.Pointer.Pen.Hide;
  Series1.Pointer.Selected.Hover.Pen.Color := clBlack;
  Series1.Pointer.Selected.Hover.Pen.Width := 1;
  Series1.Pointer.Size:=6;

  SetLength(monthTitles, 12);
  for i:=0 to Length(monthTitles)-1 do
  begin
    monthTitles[i] := TAnnotationTool(Chart1.Tools.Add(TAnnotationTool));
    monthTitles[i].Shape.Transparent := True;
    monthTitles[i].Active := False;
  end;

  SetLength(dayTitles, 3);
  for i:=0 to Length(dayTitles)-1 do
  begin
    dayTitles[i] := TAnnotationTool(Chart1.Tools.Add(TAnnotationTool));
    dayTitles[i].Shape.Transparent := True;
    dayTitles[i].Active := False;
  end;
end;

initialization
  CurrentTheme := StandardTheme;

end.

