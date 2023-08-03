program UpdateClient;

uses
  System.StartUpCopy,
  FMX.Forms,
  UPrincipal in 'UPrincipal.pas' {frmPrincipal},
  uREST in 'Unidades\uREST.pas',
  UJSON in 'Unidades\UJSON.pas',
  UAppEvents in 'Unidades\UAppEvents.pas',
  UAppUpdate in 'Unidades\UAppUpdate.pas',
  Generales in 'Unidades\Generales.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TfrmPrincipal, frmPrincipal);
  Application.Run;
end.
