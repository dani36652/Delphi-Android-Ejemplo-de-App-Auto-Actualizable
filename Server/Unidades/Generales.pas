unit Generales;

interface
uses
  System.Classes, System.Types, System.SysConst, System.SysUtils, System.StdConvs,
  System.StrUtils, System.NetEncoding;

procedure EscribirLogOperaciones(Mensaje: string);
procedure EscribirLogExcepciones(Mensaje: string);
function FileToBase64(FileName: string): string;
function Base64ToFile(Base64String: string; FileName: string): boolean;
function JSONFileToString(FileName: string): string;

implementation
uses
  System.IOUtils, UPrincipal;

procedure EscribirLogOperaciones(Mensaje: string);
var
 F: TextFile;
 FileName: string;
begin
  FileName := TPath.Combine(ExtractFilePath(ParamStr(0)),
  'LogOperacion.txt');
  AssignFile(F, FileName);
  if FileExists(FileName) then
  Append(F)
  else
  Rewrite(F);
  writeln(F, FormatDateTime('DD/MM/YYYY hh:nn:ss', Now) + '-' + Mensaje);
  CloseFile(F);
end;

procedure EscribirLogExcepciones(Mensaje: string);
var
 F: TextFile;
 FileName: string;
begin
  FileName := TPath.Combine(ExtractFilePath(ParamStr(0)),
  'LogExcepciones.txt');
  AssignFile(F, FileName);
  if FileExists(FileName) then
  Append(F)
  else
  Rewrite(F);
  writeln(F, FormatDateTime('DD/MM/YYYY hh:nn:ss', Now) + '-' + Mensaje);
  CloseFile(F);
end;

function FileToBase64(FileName: string): string;
var
  FileStream: TFileStream;
  Encoding: TNetEncoding;
  Buffer: TBytes;
begin
  FileStream := TFileStream.Create(FileName, fmOpenRead);
  try
    SetLength(Buffer, FileStream.Size);
    FileStream.ReadBuffer(Buffer[0], FileStream.Size);

    Encoding := TNetEncoding.Base64;
    Result := Encoding.EncodeBytesToString(Buffer);
  finally
    FreeAndNil(FileStream);
    SetLength(Buffer, 0); //Liberar en memoria (importante)
  end;
end;

function Base64ToFile(Base64String: string; FileName: string): boolean;
var
  Encoding: TNetEncoding;
  DecodedBytes: TBytes;
  FileStream: TFileStream;
begin
  try
    FileStream := TFileStream.Create(FileName, fmCreate);
    Encoding := TNetEncoding.Base64;
    try        
      DecodedBytes := Encoding.DecodeStringToBytes(Base64String);    
      FileStream.WriteBuffer(DecodedBytes[0], Length(DecodedBytes));
      Result:= True;
    except on E: exception do 
      begin
        Result:= False;
        EscribirLogExcepciones(E.ClassName + ': Generales.Base64ToFile: ' + E.Message);        
      end;
    end;
  finally
    FreeAndNil(FileStream);
    SetLength(DecodedBytes, 0);
  end;
end;

function JSONFileToString(FileName: string): string;
var
  LFileStream: TFileStream;
  LStringStream: TStringStream;
begin
  if not TFile.Exists(FileName) then 
    exit(string.Empty);
    
  try
    LFileStream := TFileStream.Create(FileName, fmOpenRead or fmShareDenyWrite); 
    LStringStream := TStringStream.Create('');
    try
      LStringStream.LoadFromStream(LFileStream);
      Result:= LStringStream.DataString;
    except on E: exception do  
      begin     
        Result:= string.Empty;
        EscribirLogExcepciones(E.ClassName + ': Generales.JSONFileToString: ' + E.Message);
      end;
    end;
  finally
    FreeAndNil(LFileStream);
    FreeAndNil(LStringStream);
  end;
end;

end.
