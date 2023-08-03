unit uREST;

interface

Uses
  Classes, SysUtils, IniFiles, System.Net.URLClient, System.Net.HttpClient,
  System.Net.HttpClientComponent;

type
  lPost = (lpUPDATE);

  rError=Record
  Code: Integer;
  CodeStr: String;
  Msg: String;
  End;

type tRest=Class(TComponent)
  private
    Cli: TNetHTTPClient;
    Req: TNetHTTPRequest;
    hdr: TNetHeaders;
    //IniF: TIniFile;
    vErr: rError;
    procedure NetHTTPClientRequestError(const Sender: TObject; const AError: string);
    procedure ProcesaMensaje(Response: IHTTPResponse);
    procedure InicializaErr;
    Procedure OnValidateCert(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate; var Accepted: Boolean);
  public
    vBaseURL: String;
    Constructor Create(AOwner: TCOmponent); Override;
    Procedure POST(Request: String; Tipo: lPost; Params: String = '');
    Procedure GET(Request: String; Tipo: lPost; Params: String = '');
    Procedure PUT(Request: String; Tipo: lPost);
    Procedure DELETE(Request: String; Tipo: lPost);
    Property Err: rError Read vErr;
    procedure SetvBaseURL(URL: string);
End;

implementation
uses UPrincipal, FMX.Dialogs, System.NetEncoding, IdHTTP;

{ tRestPOS }

constructor tRest.Create(AOwner: TCOmponent);
begin
  inherited Create(AOwner);
  Cli := TNetHTTPClient.Create(self);
  Cli.OnRequestError := NetHTTPClientRequestError;
  Cli.OnValidateServerCertificate := OnValidateCert;
  Req := TNetHTTPRequest.Create(self);
  Req.ResponseTimeout:= 5000;
  Req.ConnectionTimeout:= 5000;

  Cli.UserAgent := 'Mozilla/5.0';
  Cli.Accept := '*/*';
  Cli.ContentType := 'application/json; charset=utf-8';
  Cli.AcceptCharSet := 'charset=utf-8';
  Cli.ResponseTimeout:= 10000;
  Cli.ConnectionTimeout:= 10000;
  SetLength(hdr, 0);
  vBaseURL:= '';
end;

procedure tRest.DELETE(Request: String; Tipo: lPost);
var
  resp: TMemoryStream;
  res: IHTTPResponse;
  URL: String;
begin
  InicializaErr;
  resp := TMemoryStream.Create;

  try
    if Length(hdr) > 0 then
      res:= Cli.Delete(URL, resp, hdr) else res := Cli.Delete(URL, resp);
  finally
    if res <> nil then
      ProcesaMensaje(res);
  end;
end;

procedure tRest.GET(Request: String; Tipo: lPost; Params: string = '');
var
  resp: TMemoryStream;
  res: IHTTPResponse;
  URL: String;
begin
  InicializaErr;

  (*case Tipo of
    lpUPDATE:
      begin
        URL:= vBaseURL + '/update/android';
      end;
  end;*)
  resp := TMemoryStream.Create;

  try
    if Length(hdr) > 0 then
      res:= Cli.Get(URL, resp, hdr) else res := Cli.Get(URL, resp);
  finally
    if res <> nil then
      ProcesaMensaje(res);
  end;
end;

procedure tRest.InicializaErr;
begin
  vErr.Code := 0;
  vErr.Msg := '';
end;

procedure tRest.NetHTTPClientRequestError(const Sender: TObject;
  const AError: string);
begin
  vErr.Code := 500;
  vErr.Msg := AError;
end;

procedure tRest.OnValidateCert(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
  Accepted := true;
end;

procedure tRest.POST(Request: String; Tipo: lPost; Params: String = '');
var
  body: TStringStream;
  resp: TMemoryStream;
  res: IHTTPResponse;
  URL: String;
begin
  InicializaErr;

  case Tipo of
    lpUPDATE:
      begin
        URL:= vBaseURL + '/update/android';
      end;
  end;

  body := TStringStream.Create(Request);
  resp := TMemoryStream.Create;

  try
    if Length(hdr) > 0 then
      res := Cli.Post(URL, body, resp, hdr) else res:= Cli.Post(URL, body, resp);
  finally
    if res <> nil then
      ProcesaMensaje(res);
  end;
end;

procedure tRest.ProcesaMensaje(Response: IHTTPResponse);
begin
  vErr.Code := Response.StatusCode;
  vErr.CodeStr := Response.StatusText;
  vErr.Msg := Response.ContentAsString(TEncoding.UTF8);
end;

procedure tRest.PUT(Request: String; Tipo: lPost);
var
  asour, aresp: TMemoryStream;
  res: IHTTPResponse;
  URL: String;
begin
  InicializaErr;

  asour := TMemoryStream.Create;
  aresp := TMemoryStream.Create;

  try
    if Length(hdr) > 0 then
      res := Cli.Put(URL, asour, aresp) else res:= Cli.Put(URL, asour, aresp);
  finally
    if res <> nil then
      ProcesaMensaje(res);
  end;
end;

procedure tRest.SetvBaseURL(URL: string);
begin
  vBaseURL:= URL;
end;

end.
