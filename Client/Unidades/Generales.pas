unit Generales;

interface
uses
  {$IFDEF ANDROID}
  Androidapi.JNI.Webkit, FMX.Dialogs.Android,
  Androidapi.JNI.Print,
  Androidapi.jni,fmx.helpers.android, Androidapi.Jni.app,
  Androidapi.Jni.GraphicsContentViewText, Androidapi.JniBridge,
  Androidapi.JNI.Os, Androidapi.Jni.Telephony,
  Androidapi.JNI.JavaTypes,Androidapi.Helpers,
  Androidapi.JNI.Widget,System.Permissions,
  Androidapi.Jni.Provider,Androidapi.Jni.Net,
  fmx.TextLayout,AndroidAPI.JNI.Support,
 {$ENDIF}
  System.Classes, System.SysConst, System.SysUtils, System.Generics.Collections,
  System.Types;

{$IFDEF ANDROID}
function ObtenerVersionAPK(ApkFileName: string): string;
function ObtenerVersionAppInstalada: string;
function ObtenerNombrePaqueteInstalado: string;
function ObtenerNombrePaqueteAPK(APKFileName: string): string;
procedure InstalarAPK(APKFileName: string);
{$ENDIF}
function Base64ToFile(Base64String: string; FileName: string): boolean;
procedure EliminarDescargasPrevias;

implementation
uses
  System.NetEncoding, FMX.Dialogs, System.IOUtils;

{$IFDEF ANDROID}
function ObtenerVersionAPK(ApkFileName: string): string;
var
 PackageManager: JPackageManager;
 packageInfo: JPackageInfo;
begin
  try
    PackageManager:= TAndroidHelper.Context.getPackageManager;
    packageInfo := PackageManager.getPackageArchiveInfo(StringToJString(ApkFileName),
    TJPackageManager.JavaClass.GET_ACTIVITIES);
    Result:= JStringToString(packageInfo.versionName);
  except
    Result:= string.Empty;
  end;
end;

function ObtenerVersionAppInstalada: string;
var
 PackageManager: JPackageManager;
 packageInfo: JPackageInfo;
begin
  try
    PackageManager:= TAndroidHelper.Context.getPackageManager;
    packageInfo := PackageManager.getPackageInfo(TAndroidHelper.Context.getPackageName,
    TJPackageManager.JavaClass.GET_ACTIVITIES);
    Result:= JStringToString(packageInfo.versionName);
  except
    Result:= string.Empty;
  end;
end;

function ObtenerNombrePaqueteInstalado: string;
var
 PackageManager: JPackageManager;
 packageInfo: JPackageInfo;
begin
  try
    PackageManager:= TAndroidHelper.Context.getPackageManager;
    packageInfo := PackageManager.getPackageInfo(TAndroidHelper.Context.getPackageName,
    TJPackageManager.JavaClass.GET_ACTIVITIES);
    Result:= JStringToString(packageInfo.packageName);
  except
    Result:= string.Empty;
  end;
end;

function ObtenerNombrePaqueteAPK(APKFileName: string): string;
var
 PackageManager: JPackageManager;
 packageInfo: JPackageInfo;
begin
  try
    PackageManager:= TAndroidHelper.Context.getPackageManager;
    packageInfo := PackageManager.getPackageArchiveInfo(StringToJString(ApkFileName),
    TJPackageManager.JavaClass.GET_ACTIVITIES);
    Result:= JStringToString(packageInfo.packageName);
  except
    Result:= string.Empty;
  end;
end;

procedure InstalarAPK(APKFileName: string);
var
Intent:JIntent;
Uri:JNet_Uri;
arch:JFile;
begin
  if TFile.Exists(APKFileName) then
  begin
    arch:=TJFile.JavaClass.init(StringToJString(APKFileName));
    arch.setReadable(true,false);
    if TJBuild_VERSION.JavaClass.SDK_INT>=24 then
    begin
      Uri:=TJcontent_FileProvider.JavaClass.getUriForFile(TAndroidHelper.Context,
      StringToJString(System.Concat(JStringToString(TAndroidHelper.Context.getPackageName),'.fileprovider')) ,
      arch);
    end else
    begin
      Uri:=TJnet_Uri.JavaClass.fromFile(arch);
    end;
    Intent:=TJIntent.Create;
    intent.putExtra(TJIntent.JavaClass.EXTRA_NOT_UNKNOWN_SOURCE, true);
    Intent.setAction(TJintent.JavaClass.ACTION_VIEW);
    Intent.setDataAndType(Uri,StringToJString('application/vnd.android.package-archive'));
    Intent.setFlags(TJIntent.JavaClass.FLAG_ACTIVITY_NEW_TASK);
    intent.addFlags(TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);
    TAndroidHelper.Context.startActivity(Intent);
  end;
end;
{$ENDIF}

function Base64ToFile(Base64String: string; FileName: string): boolean;
var
  Encoding: TNetEncoding;
  DecodedBytes: TBytes;
  FileStream: TFileStream;
begin
  try
    FileStream := TFileStream.Create(FileName, fmCreate);
    Encoding := TNetEncoding.Base64;
    try
      DecodedBytes := Encoding.DecodeStringToBytes(Base64String);
      FileStream.WriteBuffer(DecodedBytes[0], Length(DecodedBytes));
      Result:= True;
    except on E: exception do
      begin
        Result:= False;
        ShowMessage(E.ClassName + ': Generales.Base64ToFile: ' + E.Message);
      end;
    end;
  finally
    FreeAndNil(FileStream);
    SetLength(DecodedBytes, 0);
  end;
end;

procedure EliminarDescargasPrevias;
var
  i: integer;
  ApkFiles: TArray<string>;
begin
  try
    ApkFiles:= TDirectory.GetFiles(TPath.GetDocumentsPath + PathDelim, '*.apk');
    if Length(ApkFiles) > 0 then
    begin
      for i:= 0 to Length(ApkFiles) - 1 do
      begin
        TFile.Delete(ApkFiles[I]);
      end;
    end;
  except on E: exception do
    begin
      ShowMessage(E.ClassName + ': Generales.EliminarDescargasPrevias: ' + E.Message);
    end;
  end;
end;
end.
