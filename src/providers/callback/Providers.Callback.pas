unit Providers.Callback;

interface

uses
  Data.Db;

type
  TCallBackIdentify = reference to procedure(const AKey: String);
  TCAllBackDataSet = reference to procedure(const ADataSet: TDataSet);
  TCallbackInput = reference to procedure(const AResponse: String);

implementation

end.
