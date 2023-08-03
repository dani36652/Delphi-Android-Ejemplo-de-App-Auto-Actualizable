unit UServerActions;

interface
uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, IdHTTPWebBrokerBridge, IdGlobal, Web.HTTPApp,
  Winapi.Windows, ShellAPI,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo;

type TServerActions = class
  private
    class procedure ApplicationIdle(Sender: TObject; var Done: Boolean);
    class procedure StartServer;
  public
    class procedure FormCreate(Sender: TObject);
    class procedure ButtonStartClick(Sender: TObject);
    class procedure ButtonStopClick(Sender: TObject);
    class procedure ButtonOpenBrowserClick(Sender: TObject);
    class procedure btnCargarArchivoClick(Sender: TObject);
    class procedure edtNombreArchivoChangeTracking(Sender: TObject);
    class procedure btnGuardarClick(Sender: TObject);
end;

implementation
uses
  UPrincipal, Generales, UJSONUtils, System.IOUtils;

{ TServerActions }

class procedure TServerActions.ApplicationIdle(Sender: TObject;
  var Done: Boolean);
begin
  Servidor.ButtonStart.Enabled := not FServer.Active;
  Servidor.ButtonStop.Enabled := FServer.Active;
  Servidor.EditPort.Enabled := not FServer.Active;
end;

class procedure TServerActions.btnCargarArchivoClick(Sender: TObject);
var
  OpnDlg: TOpenDialog;
begin
  try
    OpnDlg:= TOpenDialog.Create(Servidor);
    OpnDlg.Title:= 'Seleccionar archivo';
    OpnDlg.Filter:= 'Android Application Package|*.apk';
    try
      if OpnDlg.Execute then
      begin
        Servidor.edtRutaArchivo.Text:= OpnDlg.FileName;
        Servidor.edtNombreArchivo.Text:= ExtractFileName(OpnDlg.FileName);
        Servidor.edtVersion.ReadOnly:= False;
        Servidor.edtVersion.SetFocus;
        Servidor.mmoNotasVersion.ReadOnly:= False;
        Servidor.edtRutaArchivo.GoToTextEnd;
      end else
      begin
        CargarDatosUltimaVersion(config_path);
      end;
    except on E: exception do
      begin
        EscribirLogExcepciones(E.ClassName + ': TServerActions.btnCargarArchivoClick: ' +
        E.Message);
        ShowMessage('No es posible cargar un archivo en este momento');
      end;
    end;
  finally
    FreeAndNil(OpnDlg);
  end;
end;

class procedure TServerActions.btnGuardarClick(Sender: TObject);
begin
  if GuardarDatosUltimaVersion(Servidor.edtNombreArchivo.Text.Trim, Servidor.edtVersion.Text.Trim,
  Servidor.mmoNotasVersion.Text.Trim, Servidor.edtRutaArchivo.Text) then
  begin
    CargarDatosUltimaVersion(config_path);
    ShowMessage('Se guardó la información capturada');
  end else
  begin
    CargarDatosUltimaVersion(config_path);
    ShowMessage('No se guardó la información capturada');
  end;
end;

class procedure TServerActions.ButtonOpenBrowserClick(Sender: TObject);
var
  LURL: string;
begin
  StartServer;
  LURL := Format('http://localhost:%s', [Servidor.EditPort.Text]);
  ShellExecute(0, nil, PChar(LURL), nil, nil, SW_SHOWNOACTIVATE);
end;

class procedure TServerActions.ButtonStartClick(Sender: TObject);
begin
  StartServer;
end;

class procedure TServerActions.ButtonStopClick(Sender: TObject);
begin
  FServer.Active := False;
  FServer.Bindings.Clear;
end;

class procedure TServerActions.edtNombreArchivoChangeTracking(Sender: TObject);
begin
  Servidor.btnGuardar.Enabled:=
  not Servidor.edtNombreArchivo.Text.Trim.IsEmpty and
  not Servidor.edtVersion.Text.Trim.IsEmpty and
  not Servidor.mmoNotasVersion.Text.Trim.IsEmpty and
  not Servidor.edtRutaArchivo.Text.Trim.IsEmpty;
end;

class procedure TServerActions.FormCreate(Sender: TObject);
begin
  FServer := TIdHTTPWebBrokerBridge.Create(Servidor);
  Application.OnIdle := ApplicationIdle;
  config_path:= ExtractFileDir(ParamStr(0)) + PathDelim + 'config.json';
  CargarDatosUltimaVersion(config_path);
end;

class procedure TServerActions.StartServer;
begin
  if not FServer.Active then
  begin
    FServer.Bindings.Clear;
    FServer.DefaultPort := StrToInt(Servidor.EditPort.Text);
    FServer.Active := True;
  end;
end;

end.
