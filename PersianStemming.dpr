program PersianStemming;

uses
  Types,
  Forms,
  UTools,
  JclStrings,
  System.SysUtils,
  UMain in 'UMain.pas' {frmMain},
  UStemming in 'UStemming.pas',
  UIniOptions in 'UIniOptions.pas';

{$R *.res}

var
  I: Integer;
  sArr: TStringDynArray;

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  IniOptions.LoadFromFile(BasePath + 'Config.ini');

  Application.CreateForm(TfrmMain, frmMain);
  with frmMain do
  begin
    if IsBatchProcessing then
    begin
      for I := 0 to sInputs.Count - 1 do
      begin
        sArr := Explode(sInputs[I], NativeTab);
        sOutputs.Add(sInputs[I] + NativeTab + MyStemmer.Run(sArr[0]));
        Application.ProcessMessages;
      end;
      sOutputs.SaveToFile(sOutputFile, TEncoding.UTF8);
      Application.Terminate;
    end;
  end;
  Application.Run;

end.
