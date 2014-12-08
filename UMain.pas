Unit UMain;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  Buttons, Vcl.ExtCtrls, UStemming, UStringContainers;

Type
  TfrmMain = Class(TForm)
    pnlMain: TPanel;
    lbl1: TLabel;
    Label1: TLabel;
    Label2: TLabel;
    edtWord: TEdit;
    btnOK: TBitBtn;
    mmoStemList: TMemo;
    mmoPatternList: TMemo;
    btnReLoadPattern: TBitBtn;
    Procedure FormCreate(Sender: TObject);
    Procedure FormDestroy(Sender: TObject);
    Procedure btnOKClick(Sender: TObject);
    procedure btnReLoadPatternClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  Private
    { Private declarations }
  Public
    { Public declarations }
    MyStemmer: TStemming;
    IsBatchProcessing: Boolean;
    sOutputFile, sInputFile: String;
    sInputs, sOutputs: TStringList;
  End;

Var
  frmMain: TfrmMain;

Implementation

{$R *.dfm}

Uses
  System.RegularExpressions, System.IOUtils, System.Types, System.Math, UTools, UPublicConstant,
  JclStrings, UIniOptions;

procedure TfrmMain.btnCloseClick(Sender: TObject);
{ var
  Idx: Integer;
  s: string;
  sArr: TStringDynArray;
  slSrc, slDst, slTemp: TStringList; }
begin
  (* slSrc := TStringList.Create;
    try
    slSrc.LoadFromFile(BasePath + DataDir + 'Dict.txt', TEncoding.UTF8);
    // slSrc.NameValueSeparator := NativeTab;
    slDst := TStringList.Create;
    slDst.Sorted := True;
    // slTemp := TStringList.Create;
    // slDst.LoadFromFile(BasePath + DataDir + 'PluralNouns.txt', TEncoding.UTF8);
    try
    for s in slSrc do
    begin
    sArr := Explode(s, NativeTab);
    // if StrCharCount(s, NativeTab) > 1 then
    if not ParamIsEmpty(sArr[1]) then
    Continue;

    if not slDst.Find(Trim(s), Idx) then
    begin
    slDst.Add(Trim(s));
    slDst.Sorted := True;
    end;

    // Idx := Find(slSrc, sArr[0]);
    // if Idx > -1 then
    // slSrc.Strings[Idx] := s
    // else
    // slSrc.Add(s);

    end;

    { for Idx := 0 to slSrc.Count - 1 do
    begin
    if Pos(NativeTab, slSrc.Strings[Idx]) = 0 then
    slSrc.Strings[Idx] := slSrc.Strings[Idx] + NativeTab;
    end; }

    // QuickSort(slDst, 0, slDst.Count - 1);
    // QuickSort(slTemp, 0, slTemp.Count - 1);
    slDst.SaveToFile(BasePath + DataDir + 'Dic_1.txt', TEncoding.UTF8);
    // slTemp.SaveToFile(BasePath + DataDir + 'Dic_1.txt', TEncoding.UTF8);
    finally
    slDst.Free;
    // slTemp.Free;
    end;
    finally
    slSrc.Free;
    end;
  *)
  Close;
end;

Procedure TfrmMain.FormCreate(Sender: TObject);
Begin
  UTools.OptimizeRamUsage;
  UTools.SetSysLocale(LANG_FARSI);
  UTools.SetAppBiDiMode(LANG_FARSI);

  sInputFile := ParamStr(1);
  // sInputFile := Copy(ParamStr(1), 2, MaxInt);
  IsBatchProcessing := (ParamCount > 1) and (TFile.Exists(sInputFile));
  if IsBatchProcessing then
  begin
    sInputs := TStringList.Create;
    sInputs.LoadFromFile(sInputFile);

    sOutputs := TStringList.Create;
    sOutputFile := sInputFile + '.out';
    if not ParamIsEmpty(ParamStr(2)) then
      sOutputFile := ParamStr(2);
  end;

  MyStemmer := TStemming.Create;
End;

Procedure TfrmMain.FormDestroy(Sender: TObject);
Begin
  MyStemmer.Free;

  if Assigned(sInputs) then
    sInputs.Free;
  if Assigned(sOutputs) then
    sOutputs.Free;
End;

Procedure TfrmMain.btnOKClick(Sender: TObject);
var
  I: Integer;
Begin
  mmoStemList.Clear;
  mmoPatternList.Clear;

  MyStemmer.Run(edtWord.Text);

  if IniOptions.MainPatternCount = 0 then
  begin
    mmoStemList.Lines.Assign(MyStemmer.StemList);
    mmoPatternList.Lines.Assign(MyStemmer.PatternList);
  end
  else
  begin
    for I := 0 to Min(Abs(IniOptions.MainPatternCount), MyStemmer.StemList.Count) - 1 do
    begin
      mmoStemList.Lines.Add(MyStemmer.StemList[I]);
      mmoPatternList.Lines.Add(MyStemmer.PatternList[I]);
    end;
  end;

  edtWord.SelectAll;
end;

procedure TfrmMain.btnReLoadPatternClick(Sender: TObject);
begin
  MyStemmer.ReLoadPatterns;
end;

End.
