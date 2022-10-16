unit Providers.Permision.Camera;

interface

uses
  System.Classes,
  {$IFDEF ANDROID}
  Androidapi.Helpers,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.OS,
  {$ENDIF}
  System.SysUtils,
  System.Permissions,
  FMX.DialogService,
  System.UITypes;

type
  TCameraPermision = class
    private
      FPermisionCamera: String;
      FPermissionReadExternalStorage: String;
      FPermissionWriteExternalStorage: String;
      procedure ValidatePermisionRequest(Sender: TObject; const APermissions: TArray<String>;
        const AGrandResult: TArray<TPermissionStatus>);
      constructor Create;
    public
      class function New: TCameraPermision;
      procedure Request;
  end;

implementation

{ TCameraPermision }

constructor TCameraPermision.Create;
begin
{$IFDEF ANDROID}
   FPermisionCamera := JStringToString(TJManifest_permission.JavaClass.CAMERA);
   FPermissionReadExternalStorage :=
     JStringToString(TJManifest_permission.JavaClass.READ_EXTERNAL_STORAGE);
   FPermissionWriteExternalStorage :=
     JStringToString(TJManifest_permission.JavaClass.WRITE_EXTERNAL_STORAGE);
{$ENDIF}
end;

class function TCameraPermision.New: TCameraPermision;
begin
  result := TCameraPermision.Create;
end;

procedure TCameraPermision.Request;
begin
  PermissionsService.RequestPermissions(
    [FPermisionCamera, FPermissionReadExternalStorage, FPermissionWriteExternalStorage],
    ValidatePermisionRequest)
end;

procedure TCameraPermision.ValidatePermisionRequest(Sender: TObject;
  const APermissions: TArray<String>;
  const AGrandResult: TArray<TPermissionStatus>);
begin
  self.disposeOf;
end;

end.
