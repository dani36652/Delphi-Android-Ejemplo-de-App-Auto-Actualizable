unit UJSON;

interface
uses
  System.Classes, System.Types, System.SysConst, System.SysUtils,
  System.Generics.Collections, System.JSON, System.JSON.Builders,
  UAppUpdate,
  System.JSON.Converters, System.JSON.Types, System.JSON.Utils;

function ObtenerInfoActualizacion(const descarga:boolean = false): TAppUpdate;

implementation
uses
  UREST, UPrincipal, FMX.Dialogs;

function ObtenerInfoActualizacion(const descarga:boolean = false): TAppUpdate;
var
  REST: tRest;
  JSONObjDescarga: TJSONObject;
  JSONObj: TJSONObject;
begin
  try
    REST:= tRest.Create(nil);
    REST.SetvBaseURL(BASE_URL);
    JSONObjDescarga:= TJSONObject.Create;
    try
      case descarga of
        true:
          begin
            JSONObjDescarga.AddPair('descarga', '1');
          end;

        false:
          begin
            JSONObjDescarga.AddPair('descarga', '0');
          end;
      end;

      REST.POST(JSONObjDescarga.ToString, lpUPDATE, string.Empty);

      if REST.Err.Code = 200 then
      begin
        JSONObj:= TJSONObject.ParseJSONValue(REST.Err.Msg) as TJSONObject;
        Result.Nombre:= JSONObj.Values['nombrearchivo'].Value;
        Result.Version:= JSONObj.Values['version'].Value;
        Result.NotasVersion:= JSONObj.Values['notas_ver'].Value;
        if Assigned(JSONObj.FindValue('base64')) then
          Result.base64:= JSONObj.Values['base64'].Value;
      end else
      begin
        Result.Nombre:= '';
        Result.Version:= '';
        Result.NotasVersion:= '';
        Result.base64:= '';
      end;

    except on E: exception do
      begin
        Result.Nombre:= '';
        Result.Version:= '';
        Result.NotasVersion:= '';
        Result.base64:= '';
      end;
    end;
  finally
    FreeAndNil(REST);
    if Assigned(JSONObjDescarga) then
      FreeAndNil(JSONObjDescarga);
  end;
end;

end.
