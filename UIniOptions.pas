unit UIniOptions;

interface

uses
  Classes, SysUtils, IniFiles, Forms, Windows;

const
  csIniMainSection = 'Main';

  { Section: Main }
  csIniMainDataDir = 'DataDir';
  csIniMainPatternFile = 'PatternFile';
  csIniMainDictionaryFile = 'DictionaryFile';
  csIniMainMokassarDictionaryFile = 'MokassarDictionaryFile';
  csIniMainPatternCount = 'PatternCount';

type
  TIniOptions = class(TObject)
  private
    { Section: Main }
    FMainDataDir: string;
    FMainPatternFile: string;
    FMainDictionaryFile: string;
    FMainMokassarDictionaryFile: string;
    FMainPatternCount: Integer;
  public
    procedure LoadSettings(Ini: TIniFile);
    procedure SaveSettings(Ini: TIniFile);

    procedure LoadFromFile(const FileName: string);
    procedure SaveToFile(const FileName: string);

    { Section: Main }
    property MainDataDir: string read FMainDataDir write FMainDataDir;
    property MainPatternCount: Integer read FMainPatternCount write FMainPatternCount;
    property MainPatternFile: string read FMainPatternFile write FMainPatternFile;
    property MainDictionaryFile: string read FMainDictionaryFile write FMainDictionaryFile;
    property MainMokassarDictionaryFile: string read FMainMokassarDictionaryFile
      write FMainMokassarDictionaryFile;
  end;

var
  IniOptions: TIniOptions = nil;

implementation

procedure TIniOptions.LoadSettings(Ini: TIniFile);
begin
  if Ini <> nil then
  begin
    { Section: Main }
    FMainPatternCount := Ini.ReadInteger(csIniMainSection, csIniMainPatternCount, -1);
    FMainDataDir := Ini.ReadString(csIniMainSection, csIniMainDataDir, 'Data\');
    FMainPatternFile := Ini.ReadString(csIniMainSection, csIniMainPatternFile, 'Patterns.txt');
    FMainDictionaryFile := Ini.ReadString(csIniMainSection, csIniMainDictionaryFile, 'fa2.txt');
    FMainMokassarDictionaryFile := Ini.ReadString(csIniMainSection, csIniMainMokassarDictionaryFile,
      'MokassarDic.txt');
  end;
end;

procedure TIniOptions.SaveSettings(Ini: TIniFile);
begin
  if Ini <> nil then
  begin
    { Section: Main }
    Ini.WriteInteger(csIniMainSection, csIniMainPatternCount, FMainPatternCount);
    Ini.WriteString(csIniMainSection, csIniMainDataDir, FMainDataDir);
    Ini.WriteString(csIniMainSection, csIniMainPatternFile, FMainPatternFile);
    Ini.WriteString(csIniMainSection, csIniMainDictionaryFile, FMainDictionaryFile);
    Ini.WriteString(csIniMainSection, csIniMainMokassarDictionaryFile, FMainMokassarDictionaryFile);
  end;
end;

procedure TIniOptions.LoadFromFile(const FileName: string);
var
  Ini: TIniFile;
begin
  if FileExists(FileName) then
  begin
    Ini := TIniFile.Create(FileName);
    try
      LoadSettings(Ini);
    finally
      Ini.Free;
    end;
  end;
end;

procedure TIniOptions.SaveToFile(const FileName: string);
var
  Ini: TIniFile;
begin
  Ini := TIniFile.Create(FileName);
  try
    SaveSettings(Ini);
  finally
    Ini.Free;
  end;
end;

initialization

IniOptions := TIniOptions.Create;

finalization

IniOptions.Free;

end.
