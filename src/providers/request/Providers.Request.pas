unit Providers.Request;

interface

uses
  Providers.Request.intf, System.JSON, System.Classes, RestRequest4D, Providers.Session,
  Rest.Types;

type
  IRequest = Providers.Request.intf.IRequest;
  IResponse = RestRequest4D.IResponse;
  TRequest = class(TInterfacedObject, IRequest)
  private
   FRequest: RestRequest4D.IRequest;
   function BaseURL(const AValue: String): IRequest;
   function Resource(const AValue: String): IRequest;
   function ResourceSuffix(const AValue: String): IRequest;
   function Get: IResponse;
   function Post: IResponse;
   function Delete: IResponse;
   function Put: IResponse;
   function AddParam(const AKey, AValue: String): IRequest;
   function ClearBody: IRequest;
   function AddBody(const ABody: TJSONObject; const AOwns: boolean = true): IRequest; overload;
   function AddBody(const ABody: TMemoryStream; const AOwns: boolean = true): IRequest; overload;
   function contentType(const AValue: String): IRequest;
   function ClearParams(): IRequest;
   procedure doBeforeExecute;
   constructor create;
   function renovarToken(): boolean;
   function execute(const AMethod: TRestRequestMethod): IResponse;
  public
    class function New: IRequest;
    destructor destroy; override;
  end;

implementation

uses
  System.SysUtils;

{ TRequest }

class function TRequest.New: IRequest;
begin
  result := TRequest.create();
end;

function TRequest.AddBody(const ABody: TMemoryStream;
  const AOwns: boolean): IRequest;
begin
  FRequest.addBody(ABody, AOwns);
  result := self;
end;

function TRequest.AddBody(const ABody: TJSONObject;
  const AOwns: boolean): IRequest;
begin
  FRequest.addBody(ABody, AOwns);
  result := self;
end;

function TRequest.AddParam(const AKey, AValue: String): IRequest;
begin
  FRequest.AddParam(AKey, AValue);
  result := self;
end;

function TRequest.BaseURL(const AValue: String): IRequest;
begin
  FRequest.baseURL(AValue);
  result := self;
end;

function TRequest.ClearBody: IRequest;
begin
  FRequest.ClearBody;
  result := self;
end;

function TRequest.ClearParams: IRequest;
begin
  FRequest.ClearParams;
  result := self;
end;

function TRequest.contentType(const AValue: String): IRequest;
begin
  FRequest.contentType(AValue);
  result := self;
end;

constructor TRequest.create;
begin
  FRequest := RestRequest4d.TRequest.new;
end;

destructor TRequest.destroy;
begin
  FRequest := nil;
  inherited;
end;

procedure TRequest.doBeforeExecute;
begin
  if not TSession.getInstance.token.access.trim().isEmpty then
    FRequest.token('bearer ' + TSession.getInstance.token.access);
end;

function TRequest.execute(const AMethod: TRestRequestMethod): IResponse;
begin
  doBeforeExecute;
  case AMethod of
    TRestRequestMethod.rmPost: Result := FRequest.post;
    TRestRequestMethod.rmGet: Result := FRequest.get;
    TRestRequestMethod.rmPut: Result := FRequest.put;
    else
      result := FRequest.Delete;
  end;
  if result.StatusCode = 401 then
    if renovarToken() then
      execute(AMethod);
end;

function TRequest.Get: IResponse;
begin
  result := execute(TRestRequestMethod.rmGet);
end;

function TRequest.Delete: IResponse;
begin
  result := execute(TRestRequestMethod.rmDelete);
end;

function TRequest.Post: IResponse;
begin
  result := execute(TRestRequestMethod.rmPost);
end;

function TRequest.Put: IResponse;
begin
  result := execute(TRestRequestMethod.rmPut);
end;

function TRequest.renovarToken: boolean;
begin
  var LResponse := RestRequest4d
                    .TRequest
                    .new
                    .token('bearer ' + TSession.getInstance().token.Refresh)
                    .baseUrl('http://localhost:9001')
                    .Resource('refresh')
                    .get;
  result := LResponse.StatusCode = 200;
  if result then
    TSession.getInstance.Token.Access := LResponse.JSONValue.GetValue<string>('access');
end;

function TRequest.Resource(const AValue: String): IRequest;
begin
  FRequest.Resource(AValue);
  result := self;
end;

function TRequest.ResourceSuffix(const AValue: String): IRequest;
begin
  FRequest.ResourceSuffix(AValue);
  result := self;
end;

end.
