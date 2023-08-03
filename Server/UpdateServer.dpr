program UpdateServer;
{$APPTYPE GUI}

uses
  System.StartUpCopy,
  FMX.Forms,
  Web.WebReq,
  IdHTTPWebBrokerBridge,
  UPrincipal in 'UPrincipal.pas' {Servidor},
  WebModule in 'WebModule.pas' {WbModule: TWebModule},
  UServerActions in 'Unidades\UServerActions.pas',
  Generales in 'Unidades\Generales.pas',
  UJSONUtils in 'Unidades\UJSONUtils.pas';

{$R *.res}

begin
  if WebRequestHandler <> nil then
    WebRequestHandler.WebModuleClass := WebModuleClass;
  Application.Initialize;
  Application.CreateForm(TServidor, Servidor);
  Application.Run;
end.
