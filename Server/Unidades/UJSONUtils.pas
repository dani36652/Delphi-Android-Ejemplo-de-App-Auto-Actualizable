unit UJSONUtils;

interface
uses
  System.Types, System.Classes, System.Generics.Collections,
  System.SysConst, System.SysUtils, System.StrUtils, System.UIConsts,
  System.UITypes, System.JSON, System.JSON.Builders, System.JSON.Converters,
  System.JSON.Types, System.JSON.Utils;

procedure CargarDatosUltimaVersion(FileName: string);
function GuardarDatosUltimaVersion(Nombre, Version, NotasVersion, RutaAPK: string): boolean;

implementation
uses
  Generales, UPrincipal, System.IOUtils;

procedure CargarDatosUltimaVersion(FileName: string);
var
  Jstr: string;
  JSONObj: TJSONObject;
begin
  try
    Jstr:= string.Empty;
    Jstr:= JSONFileToString(FileName);
    if not Jstr.IsEmpty then
    begin
      try
        JSONObj:= TJSONObject.ParseJSONValue(Jstr) as TJSONObject;
        Servidor.edtNombreArchivo.Text:= JSONObj.Values['nombrearchivo'].Value;
        Servidor.edtNombreArchivo.ReadOnly:= True;
        Servidor.edtVersion.Text:= JSONObj.Values['version'].Value;
        //Servidor.edtVersion.ReadOnly:= True;
        Servidor.mmoNotasVersion.Text:= JSONObj.Values['notas_ver'].Value;
        //Servidor.mmoNotasVersion.ReadOnly:= True;
        Servidor.edtRutaArchivo.Text:= JSONObj.Values['ruta'].Value;
        Servidor.edtRutaArchivo.ReadOnly:= True;
      finally
        if Assigned(JSONObj) then
          FreeAndNil(JSONObj);
        Jstr:= string.Empty;
      end;
    end else
    begin
      Servidor.edtNombreArchivo.Text:= string.Empty;
      Servidor.edtNombreArchivo.ReadOnly:= True;
      Servidor.edtVersion.Text:= string.Empty;
      //Servidor.edtVersion.ReadOnly:= True;
      Servidor.mmoNotasVersion.Text:= string.Empty;
      //Servidor.mmoNotasVersion.ReadOnly:= True;
      Servidor.edtRutaArchivo.Text:= string.Empty;
      Servidor.edtRutaArchivo.ReadOnly:= True;
    end;
  except on E: exception do
    begin
      EscribirLogExcepciones(E.ClassName + ': UJSONUtils.CargarDatosUltimaVersion: ' + E.Message);
    end;
  end;
end;

function GuardarDatosUltimaVersion(Nombre, Version, NotasVersion, RutaAPK: string): boolean;
var
  strLstJSON: TStringList;
  JSONObj: TJSONObject;
begin
  try
    strLstJSON:= TStringList.Create;
    JSONObj:= TJSONObject.Create;
    try
      JSONObj.AddPair('nombrearchivo', Nombre);
      JSONObj.AddPair('version', Version);
      JSONObj.AddPair('notas_ver', NotasVersion);
      JSONObj.AddPair('ruta', RutaAPK);
      JSONObj.AddPair('base64', FileToBase64(RutaAPK));
      strLstJSON.Clear;
      strLstJSON.Add(JSONObj.ToString);
      strLstJSON.SaveToFile(config_path);
      Result:= True;
    except on E: exception do
      begin
        EscribirLogExcepciones(E.ClassName + ': UJSONUtils.GuardarDatosUltimaVersion: ' + E.Message);
        Result:= False;
      end;
    end;
  finally
    if Assigned(JSONObj) then
      FreeAndNil(JSONObj);
    FreeAndNil(strLstJSON);
  end;
end;

end.
