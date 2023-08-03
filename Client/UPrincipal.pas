unit UPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  UAppUpdate,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs, FMX.Layouts,
  FMX.Edit, FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects,
  FMX.Memo.Types, FMX.ScrollBox, FMX.Memo;

type
  TfrmPrincipal = class(TForm)
    btnCheckUpdate: TButton;
    edtUrlServer: TEdit;
    LYContent: TLayout;
    ContenedorPrincipal: TLayout;
    rectFondoUpdateDialog: TRectangle;
    UpdateDlg: TRectangle;
    rectToolbarUpdateDialog: TRectangle;
    lblTituloActualizacionDisp: TLabel;
    LYNuevaVersionUpdateDialog: TLayout;
    lblTituloNuevaVersionUpdateDialog: TLabel;
    lblNuevaVersionUpdateDialog: TLabel;
    LYVersionInstaladaUpdateDialog: TLayout;
    lblTituloVersionInstaladaUpdateDialog: TLabel;
    lblVersionInstaladaUpdateDialog: TLabel;
    LYNotasVersion: TLayout;
    Label5: TLabel;
    mmoNotasVersion: TMemo;
    StyleBook1: TStyleBook;
    rectBtnActualizar: TRectangle;
    btnActualizar: TButton;
    IndicadorProgreso: TAniIndicator;
    IndicadorDescargaUpdate: TAniIndicator;
    procedure btnCheckUpdateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnActualizarClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmPrincipal: TfrmPrincipal;
  BASE_URL: string;
  AppUpdateInfo: TAppUpdate;

implementation
uses
  UAppEvents;

{$R *.fmx}

procedure TfrmPrincipal.btnActualizarClick(Sender: TObject);
begin
  TAppEvents.btnActualizarClick(Sender);
end;

procedure TfrmPrincipal.btnCheckUpdateClick(Sender: TObject);
begin
  TAppEvents.btnCheckUpdateClick(Sender);
end;

procedure TfrmPrincipal.FormCreate(Sender: TObject);
begin
  TAppEvents.FormCreate(Sender);
end;

procedure TfrmPrincipal.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  TAppEvents.FormKeyDown(Sender, Key, KeyChar, Shift);
end;

end.
