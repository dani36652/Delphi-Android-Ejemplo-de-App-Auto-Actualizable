unit WebModule;

interface

uses
  System.SysUtils, System.Classes, Web.HTTPApp;

type
  TWbModule = class(TWebModule)
    procedure WbModuleActualizacion_AndroidAction(Sender: TObject;
      Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  WebModuleClass: TComponentClass = TWbModule;

implementation
uses
  UPrincipal, Generales, System.JSON, System.IOUtils;

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

procedure TWbModule.WbModuleActualizacion_AndroidAction(Sender: TObject;
  Request: TWebRequest; Response: TWebResponse; var Handled: Boolean);
var
  JSONObj: TJSONObject;
  JSONObj_Request: TJSONObject;
begin
  if Request.MethodType = TMethodType.mtPost then
  begin
    try
      JSONObj_Request:= TJSONObject.ParseJSONValue(Request.Content) as TJSONObject;
      if Assigned(JSONObj_Request) then
      begin

        if JSONFileToString(config_path).Trim.IsEmpty then
        begin
          Response.StatusCode:= 202;
          Response.Content:= 'No content';
          Response.SendResponse;
          if Assigned(JSONObj_Request) then
            FreeAndNil(JSONObj_Request);
          Exit;
        end;

        JSONObj:= TJSONObject.ParseJSONValue(JSONFileToString(config_path)) as TJSONObject;
        if JSONObj_Request.Values['descarga'].Value.Trim = '0' then
        begin
          //Si descarga = false
          JSONObj.RemovePair('ruta');
          JSONObj.RemovePair('base64');
          Response.StatusCode:= 200;
          Response.Content:= JSONObj.ToString;
          Response.SendResponse;
        end else
        if JSONObj_Request.Values['descarga'].Value.Trim = '1' then
        begin
          //Si descarga = true
          JSONObj.RemovePair('ruta');
          Response.StatusCode:= 200;
          Response.Content:= JSONObj.ToString;
          Response.SendResponse;
        end else
        begin
          //Otra información enviada que no sea descarga
          Response.StatusCode:= 403;
          Response.Content:= 'Bad request';
          Response.SendResponse;
        end;

        if Assigned(JSONObj) then
          FreeAndNil(JSONObj);

        if Assigned(JSONObj_Request) then
          FreeAndNil(JSONObj_Request);
      end else
      begin
        //Texto que no sea JSON
        Response.StatusCode:= 403;
        Response.Content:= 'Bad request';
        Response.SendResponse;
      end;
    except on E: exception do
      begin
        //Error interno del servidor
        EscribirLogExcepciones(E.ClassName + ': TWbModule.WbModuleActualizacion_AndroidAction: ' + E.Message);
        Response.StatusCode:= 500;
        Response.Content:= E.Message;
        Response.SendResponse;
      end;
    end;
  end else
  begin
    Response.StatusCode:= 403;
    Response.Content:= 'Bad request';
    Response.SendResponse;
  end;
end;

end.
