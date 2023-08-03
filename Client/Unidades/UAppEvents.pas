unit UAppEvents;

interface
uses
  System.Classes, System.Types, System.SysConst, System.SysUtils,
  System.Generics.Collections, System.JSON, System.JSON.Builders,
  System.UITypes,
  System.JSON.Converters, System.JSON.Types, System.JSON.Utils;

type TAppEvents = class
  private
    class procedure ThreadUpdate_OnTerminate(Sender: TObject);
    class procedure ThreadDownloadUpdate_OnTerminate(Sender: TObject);
  public
    class procedure btnCheckUpdateClick(Sender: TObject);
    class procedure FormCreate(Sender: TObject);
    class procedure btnActualizarClick(Sender: TObject);
    class procedure FormKeyDown(Sender: TObject; var Key: Word;
    var KeyChar: Char; Shift: TShiftState);
end;

implementation
uses
  UPrincipal, UJSON, FMX.Dialogs, Generales, System.IOUtils,
  idGlobal, System.Threading;

{ TAppEvents }

class procedure TAppEvents.btnActualizarClick(Sender: TObject);
var
  ThreadDownloadUpdate: TThread;
  NombrePaqueteInstalado, NombrePaqueteServidor: string;
  UpdateFilename: string;
begin
  frmPrincipal.IndicadorDescargaUpdate.Enabled:= True;
  ThreadDownloadUpdate:= TThread.CreateAnonymousThread(
  procedure
  begin
    BASE_URL:= frmPrincipal.edtUrlServer.Text.Trim;
    AppUpdateInfo:= ObtenerInfoActualizacion(True);
    //Ya incluye extensión desde el servidor
    UpdateFilename:= TPath.GetDocumentsPath + PathDelim + AppUpdateInfo.Nombre;
    EliminarDescargasPrevias;
    if not Base64ToFile(AppUpdateInfo.base64, UpdateFilename) then
    begin
      TThread.Synchronize(nil,
      procedure
      begin
        ShowMessage('No fue posible actualizar');
      end);
      Exit;
    end;

    NombrePaqueteInstalado:= ObtenerNombrePaqueteInstalado.Trim;
    NombrePaqueteServidor:= ObtenerNombrePaqueteAPK(UpdateFilename);

    if (not NombrePaqueteInstalado.Trim.IsEmpty) and
    (not NombrePaqueteServidor.Trim.IsEmpty) then
    begin
      if NombrePaqueteInstalado.Equals(NombrePaqueteServidor) then
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          //Aquí instalar apk
          frmPrincipal.IndicadorDescargaUpdate.Enabled:= False;
          InstalarAPK(UpdateFilename);
        end);
      end else
      begin
        TThread.Synchronize(nil,
        procedure
        begin
          if TFile.Exists(UpdateFilename) then
            TFile.Delete(UpdateFilename);
          frmPrincipal.IndicadorDescargaUpdate.Enabled:= False;
          ShowMessage('No es posible instalar la aplicación descargada ya que ' +
          'los nombres de paquete no coinciden ' + sLineBreak +
          'instalado: ' + NombrePaqueteInstalado + sLineBreak +
          'descargado: ' + NombrePaqueteServidor);
        end);
      end;
    end;
  end);
  ThreadDownloadUpdate.FreeOnTerminate:= True;
  ThreadDownloadUpdate.OnTerminate:= ThreadDownloadUpdate_OnTerminate;
  ThreadDownloadUpdate.Start;
end;

class procedure TAppEvents.btnCheckUpdateClick(Sender: TObject);
var
  ThreadUpdate: TThread;
  VersionServidor, VersionActual: integer;
  StrVersionActual: string;
begin
  frmPrincipal.IndicadorProgreso.Enabled:= True;
  ThreadUpdate:= TThread.CreateAnonymousThread(
  procedure
  begin
    BASE_URL:= frmPrincipal.edtUrlServer.Text.Trim;
    AppUpdateInfo:= ObtenerInfoActualizacion(False);
    StrVersionActual:= ObtenerVersionAppInstalada;
    try
      if (not AppUpdateInfo.Version.Trim.IsEmpty) and
      (not StrVersionActual.Trim.IsEmpty) then
      begin
        VersionServidor:= AppUpdateInfo.Version.Replace('.', string.Empty).ToInteger;
        VersionActual:= StrVersionActual.Trim.Replace('.', string.Empty).ToInteger;
        if VersionServidor > VersionActual then
        begin
          TThread.Synchronize(nil,
          procedure
          begin
            frmPrincipal.IndicadorProgreso.Enabled:= False;
            frmPrincipal.lblNuevaVersionUpdateDialog.Text:= 'V' + AppUpdateInfo.Version.Trim;
            frmPrincipal.lblVersionInstaladaUpdateDialog.Text:= 'V' + StrVersionActual;
            frmPrincipal.mmoNotasVersion.Lines.Clear;
            frmPrincipal.mmoNotasVersion.Lines.Add(AppUpdateInfo.NotasVersion);
            frmPrincipal.rectFondoUpdateDialog.Visible:= True;
            frmPrincipal.rectFondoUpdateDialog.BringToFront;
          end);
        end;
      end;
    except
      TThread.Synchronize(nil,
      procedure
      begin
        frmPrincipal.IndicadorProgreso.Enabled:= False;
      end);
    end;
  end);
  ThreadUpdate.FreeOnTerminate:= True;
  ThreadUpdate.OnTerminate:= ThreadUpdate_OnTerminate;
  ThreadUpdate.Start;
end;

class procedure TAppEvents.FormCreate(Sender: TObject);
begin
  BASE_URL:= string.Empty;
  AppUpdateInfo.Nombre:= '';
  AppUpdateInfo.Version:= '';
  AppUpdateInfo.NotasVersion:= '';
  AppUpdateInfo.base64:= '';
end;

class procedure TAppEvents.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  if Key = vkHardwareBack then
  begin
    if frmPrincipal.rectFondoUpdateDialog.IsVisible then
    begin
      frmPrincipal.rectFondoUpdateDialog.Visible:= False;
      Key:= 0;
    end;
  end;
end;

class procedure TAppEvents.ThreadDownloadUpdate_OnTerminate(Sender: TObject);
begin
  if CurrentThreadId = MainThreadID then
  begin
    //Se está en el hilo principal
    frmPrincipal.IndicadorDescargaUpdate.Enabled:= False;
  end else
  begin
    //No se está en el hilo principal
    TThread.Synchronize(nil,
    procedure
    begin
      frmPrincipal.IndicadorDescargaUpdate.Enabled:= False;
    end);
  end;
end;

class procedure TAppEvents.ThreadUpdate_OnTerminate(Sender: TObject);
begin
  if CurrentThreadId = MainThreadID then
  begin
    frmPrincipal.IndicadorProgreso.Enabled:= False;
  end else
  begin
    TThread.Synchronize(nil,
    procedure
    begin
      frmPrincipal.IndicadorProgreso.Enabled:= False;
    end);
  end;
end;

end.
