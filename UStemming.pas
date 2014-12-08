unit UStemming;

Interface

Uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  UStringContainers;

Type
  TStemming = Class(TObject)
  Private
    { Private declarations }
    Lexicon: TStringContainer;
    sRules, sMokassar: TStringList;
  Public
    DataPath: String;
    StemList, PatternList: TStringList;
    { Public declarations }
    constructor Create;
    destructor Destroy; override;

    Function Run(Input: string): string;

    function Normalization(Const s: string): string;
    function NormalizeValidation(const sWord: string): Boolean;
    procedure ReLoadPatterns;
    procedure AddMatchedRule(Msg: String);
    procedure AddStem(Msg: String);
    procedure AddToLog(sStem, sRule: string);
    function Validation(const sWord: string): Boolean;
    function VerbValidation(const sWord: string; var sSuffix: string): Boolean;
    function GetMokassarStem(const sWord: string; var Stem: String): Boolean;
    function isMatch(const sInput, sRule: string): Boolean;
    function ExtractStem(sInput, sRule: string; const sReplacement: string = '${stem}'): String;
    procedure LoadDictionary(var List: TStringList; const sFileName: TFileName; NameValueSep: Char;
      Sorting: Boolean = True);
  End;

Implementation

Uses
  System.RegularExpressions, System.IOUtils, System.Types, System.Math, UTools, UPublicConstant,
  JclStrings, UIniOptions;

function ByHighLength(List: TStringList; Index1, Index2: Integer): Integer;
var
  L1, L2: Integer;
begin
  L1 := Length(List[Index1]);
  L2 := Length(List[Index2]);

  Result := CompareValue(L2, L1);

  if Result = EqualsValue then
    Result := CompareStr(List[Index2], List[Index1]);
end;

function ByLowLength(List: TStringList; Index1, Index2: Integer): Integer;
var
  L1, L2: Integer;
begin
  L1 := Length(List[Index1]);
  L2 := Length(List[Index2]);

  Result := CompareValue(L1, L2);

  if Result = EqualsValue then
    Result := CompareStr(List[Index1], List[Index2]);
end;

procedure TStemming.LoadDictionary(var List: TStringList; const sFileName: TFileName;
  NameValueSep: Char; Sorting: Boolean);
begin
  with List do
  begin
    LoadFromFile(sFileName, TEncoding.UTF8);
    NameValueSeparator := NameValueSep;
    Sorted := Sorting
  end;
  { if Sorting then
    QuickSort(List, 0, List.Count - 1); }
end;

constructor TStemming.Create;
Begin
  DataPath := BasePath + IniOptions.MainDataDir;

  StemList := TStringList.Create;
  PatternList := TStringList.Create;

  sRules := TStringList.Create;
  sRules.LoadFromFile(DataPath + IniOptions.MainPatternFile);

  { sDict := TStringList.Create;
    LoadDictionary(sDict, DataPath + IniOptions.MainDictionaryFile, NativeTab); }
  Lexicon := TStringContainer.New(DataPath + IniOptions.MainDictionaryFile, TEncoding.UTF8);

  sMokassar := TStringList.Create;
  LoadDictionary(sMokassar, DataPath + IniOptions.MainMokassarDictionaryFile, NativeTab);
End;

destructor TStemming.Destroy;
Begin
  sRules.Free;
  // sDict.Free;
  Lexicon.Free;
  sMokassar.Free;

  StemList.Free;
  PatternList.Free;
End;

procedure TStemming.AddMatchedRule(Msg: String);
begin
  PatternList.Add(Msg);
end;

procedure TStemming.AddStem(Msg: String);
begin
  if (not ParamIsEmpty(Msg)) and (Find(StemList, Msg) = -1) then
    StemList.Add(Msg);
end;

procedure TStemming.AddToLog(sStem, sRule: string);
begin
  AddStem(sStem);
  AddMatchedRule(sRule);
end;

function TStemming.VerbValidation(const sWord: string; var sSuffix: string): Boolean;
const
  sVerbSuffix: array [0 .. 8] of string = ('*ش', '*نده', '*ا', '*ار', 'وا*', 'اثر*', 'فرو*',
    'پیش*', 'گرو*');
var
  J: Integer;
  sTemp: string;
begin
  // اصلاح اعتبارسنجی فعل
  // افزودن پسوندهایی که مصدر فعل را میسازد مثل
  // بریدن : یدن
  // گفتن : ن
  // و ...
  // خواندن فایل ورد گرامر فارسی برای یافتن این پسوندهای مصدر ساز

  // مصدر جعلی : یدن
  // دن
  // ادن

  for J := 0 to High(sVerbSuffix) do
  begin
    if (J = 0) and (sWord[Length(sWord)] in ['ا', 'و']) then
      sTemp := StringReplace(sVerbSuffix[J], '*', sWord + 'ی', [])
    else
      sTemp := StringReplace(sVerbSuffix[J], '*', sWord, []);
    Result := NormalizeValidation(sTemp);
    if Result then
    begin
      sSuffix := sVerbSuffix[J];
      Break;
    end;
  end;
end;

Function TStemming.Run(Input: string): string;
var
  I, J, K, iStemLength: Integer;
  s, Pattern, sTag: string;
  sArr, sReplace: TStringDynArray;
Begin
  StemList.Clear;
  PatternList.Clear;
  Input := Normalization(Input);

  If ParamIsEmpty(Input) Then
    Exit('');

  if GetMokassarStem(Input, s) then
  begin
    AddToLog(s, '[جمع مکسر]');
    Exit(s);
  end
  else if NormalizeValidation(Input) then
  begin
    AddToLog(Input, '[فرهنگ لغت]');
    Exit(Input);
  end;

  For I := 0 To sRules.Count - 1 Do
  Begin
    sArr := Explode(sRules[I], ',');
    Pattern := sArr[0];
    sReplace := Explode(sArr[1], ';');
    sTag := sArr[2];
    iStemLength := StrToIntDef(sArr[3], 2);

    if isMatch(Input, Pattern) then
    begin
      K := 0;
      for J := 0 to High(sReplace) do
      begin
        if K > 0 Then
          Break;

        s := Trim(ExtractStem(Input, Pattern, sReplace[J]));

        if Length(s) < iStemLength then
          Continue;

        if sTag = 'K' then // Kasre Ezafe
        begin
          if StemList.Count = 0 then
          begin
            if GetMokassarStem(s, sTag) then
            begin
              AddToLog(sTag, Pattern + ' [جمع مکسر]');
              Inc(K);
            end
            else if NormalizeValidation(s) then
            begin
              AddToLog(s, Pattern);
              Inc(K);
            end
            else
              AddToLog('', Pattern + ' : {' + s + '}');
          end;
        end
        else if sTag = 'V' then
        begin
          if VerbValidation(s, sTag) then
          begin
            AddToLog(s, Pattern + ' : [' + sTag + ']');
            Inc(K);
          end
          else
            AddToLog('', Pattern + ' : {تمام وندها}');
        end
        else
        begin
          if NormalizeValidation(s) then
          begin
            AddToLog(s, Pattern);
            Inc(K);
          end
          else
            AddToLog('', Pattern + ' : {' + s + '}');
        end;

      end;
    end
  End;

  if StemList.Count = 0 then
    AddToLog(Input, '');

  if IniOptions.MainPatternCount <> 0 then
  begin
    if IniOptions.MainPatternCount < 0 then
      StemList.CustomSort(ByHighLength)
    Else
      StemList.CustomSort(ByLowLength);
    I := 0;
    while (I < StemList.Count) and (StemList.Count > Abs(IniOptions.MainPatternCount)) do
    begin
      StemList.Delete(I);
      PatternList.Delete(I);
    end;
  end;

  Result := StemList.CommaText;
end;

procedure TStemming.ReLoadPatterns;
begin
  // LoadDictionary(sDict, DataPath + IniOptions.MainDictionaryFile, NativeTab);
  Lexicon.LoadFromFile(DataPath + IniOptions.MainDictionaryFile, TEncoding.UTF8);
  LoadDictionary(sMokassar, DataPath + IniOptions.MainMokassarDictionaryFile, NativeTab);

  sRules.LoadFromFile(DataPath + IniOptions.MainPatternFile);
end;

function TStemming.ExtractStem(sInput, sRule: string;
  const sReplacement: string = '${stem}'): String;
var
  Match: TMatch;
  I: Integer;
  M: TMatchCollection;
  sList: TStringList;
begin
  (* Result := '';
    sList := TStringList.Create;
    try
    M := TRegEx.Matches(sInput, sRule);
    I := 0;
    for I := 0 to M.Count - 1 do
    begin
    Match := M.Item[I];
    while Match.Success do
    begin
    sList.Add(Match.Groups.Item['stem'].Value);
    Match := Match.NextMatch;
    end;
    end;

    { Match := TRegEx.Match(sInput, sRule);
    while Match.Success do
    begin
    sList.Add(Match.Groups.Item['stem'].Value);
    Match := Match.NextMatch;
    end; }
    sList.Sort;

    if sList.Count > 0 then
    Result := sList[sList.Count - 1];

    Result := StringReplace(sReplacement, '${stem}', Result, [rfReplaceAll]);
    finally
    sList.Free;
    end; *)

  Result := TRegEx.Replace(sInput, sRule, sReplacement);
end;

function TStemming.isMatch(const sInput, sRule: string): Boolean;
begin
  Result := TRegEx.isMatch(sInput, sRule);
end;

function TStemming.Normalization(const s: string): string;
begin
  Result := PersianStr(s);
  Result := Trim(StringReplace(Result, 'ۀ', 'ه', [rfReplaceAll]));
  Result := Trim(StringReplace(Result, ZWNJ, NativeSpace, [rfReplaceAll]));
end;

function TStemming.GetMokassarStem(const sWord: string; var Stem: String): Boolean;
begin
  Stem := sMokassar.Values[sWord];
  Result := not ParamIsEmpty(Stem);
end;

function TStemming.Validation(const sWord: string): Boolean;
var
  Idx: Integer;
begin
  // Result := sDict.Find(sWord, Idx);
  Result := Lexicon.Validation(sWord);
end;

function TStemming.NormalizeValidation(const sWord: string): Boolean;
{ const
  sSuffix: array [0 .. 18] of string = ('كار', 'ناك', 'وار', 'آسا', 'آگین', 'بار', 'بان', 'دان',
  'زار', 'سار', 'سان', 'لاخ', 'مند', 'دار', 'مرد', 'کننده', 'گرا', 'نما', 'متر');
  sPrefix: array [0 .. 7] of string = ('بی', 'با', 'پیش', 'غیر', 'فرو', 'هم', 'نا', 'یک');
  var
  s: string;
  L, I: Integer; }
begin
  Result := Lexicon.NormalizeValidation(sWord);
  { L := Length(Trim(sWord)) - 1;
    Result := Self.Validation(sWord);
    if (not Result) and (Pos('ا', sWord) = 1) then
    Result := Self.Validation(StringReplace(sWord, 'ا', 'آ', []));

    if (not Result) and (Pos('ا', sWord) in [2 .. L]) then
    Result := Self.Validation(StringReplace(sWord, 'ا', 'أ', []));

    if (not Result) and (Pos('ا', sWord) in [2 .. L]) then
    Result := Self.Validation(StringReplace(sWord, 'ا', 'إ', []));

    if (not Result) and (Pos('ئو', sWord) in [2 .. L]) then
    Result := Self.Validation(StringReplace(sWord, 'ئو', 'ؤ', []));

    if (not Result) and (Pos(' ', sWord) in [2 .. L]) then
    Result := Self.Validation(StringReplace(sWord, ' ', '', []));

    // دیندار
    // دین دار
    if (not Result) then
    begin
    L := StrSuffixIndex(sWord, sSuffix);
    if L > -1 then
    begin
    if sSuffix[L] = 'مند' then
    Result := Self.Validation(StringReplace(sWord, sSuffix[L], 'ه ' + sSuffix[L], []))
    else
    Result := Self.Validation(StringReplace(sWord, sSuffix[L], ' ' + sSuffix[L], []));
    end;
    end;

    if (not Result) then
    begin
    L := StrPrefixIndex(sWord, sPrefix);
    if L > -1 then
    Result := Self.Validation(StringReplace(sWord, sPrefix[L], sPrefix[L] + ' ', []));
    end;
    }
end;

End.
