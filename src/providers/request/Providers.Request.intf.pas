unit Providers.Request.intf;

interface

uses
  RestRequest4D, System.JSON, System.Classes;

type
 IRequest = interface
   ['{F19EBFB1-6943-45A9-9FEC-09F4C4488CB0}']
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
 end;

implementation

end.
