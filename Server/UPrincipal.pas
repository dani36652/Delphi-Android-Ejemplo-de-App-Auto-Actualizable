unit UPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Edit, IdHTTPWebBrokerBridge, IdGlobal, Web.HTTPApp, System.NetEncoding,
  FMX.Controls.Presentation, FMX.Objects, FMX.Layouts, FMX.Memo.Types,
  FMX.ScrollBox, FMX.Memo;

type
  TServidor = class(TForm)
    ButtonStart: TButton;
    ButtonStop: TButton;
    EditPort: TEdit;
    lblPuerto: TLabel;
    ButtonOpenBrowser: TButton;
    ContenedorPrincipal: TLayout;
    LYContAccionesServidor: TLayout;
    lblTituloServidor: TLabel;
    LYBtnIniciar: TLayout;
    RectIniciar: TRectangle;
    LYBtnDetener: TLayout;
    RectDetener: TRectangle;
    LYBtnOpenBrowser: TLayout;
    RectOpenBrowser: TRectangle;
    LYContInfoApp: TLayout;
    lblTituloDetallesVersionActual: TLabel;
    lblTituloNombreArchivo: TLabel;
    edtNombreArchivo: TEdit;
    lblTituloVersion: TLabel;
    edtVersion: TEdit;
    lblTituloNotasVersion: TLabel;
    mmoNotasVersion: TMemo;
    lblTituloAPK: TLabel;
    LYContDatosArchivo: TLayout;
    edtRutaArchivo: TEdit;
    rectCargarArchivo: TRectangle;
    btnCargarArchivo: TButton;
    Layout1: TLayout;
    rectBtnGuardar: TRectangle;
    btnGuardar: TButton;
    procedure FormCreate(Sender: TObject);
    procedure ButtonStartClick(Sender: TObject);
    procedure ButtonStopClick(Sender: TObject);
    procedure ButtonOpenBrowserClick(Sender: TObject);
    procedure btnCargarArchivoClick(Sender: TObject);
    procedure edtNombreArchivoChangeTracking(Sender: TObject);
    procedure btnGuardarClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Servidor: TServidor;
  FServer: TIdHTTPWebBrokerBridge;
  config_path: string;

implementation
uses
  UServerActions;

{$R *.fmx}

procedure TServidor.btnCargarArchivoClick(Sender: TObject);
begin
  TServerActions.btnCargarArchivoClick(Sender);
end;

procedure TServidor.btnGuardarClick(Sender: TObject);
begin
  TServerActions.btnGuardarClick(Sender);
end;

procedure TServidor.ButtonOpenBrowserClick(Sender: TObject);
begin
  TServerActions.ButtonOpenBrowserClick(Sender);
end;

procedure TServidor.ButtonStartClick(Sender: TObject);
begin
  TServerActions.ButtonStartClick(Sender);
end;

procedure TServidor.ButtonStopClick(Sender: TObject);
begin
  TServerActions.ButtonStopClick(Sender);
end;

procedure TServidor.edtNombreArchivoChangeTracking(Sender: TObject);
begin
  TServerActions.edtNombreArchivoChangeTracking(Sender);
end;

procedure TServidor.FormCreate(Sender: TObject);
begin
  TServerActions.FormCreate(Sender);
end;

end.
