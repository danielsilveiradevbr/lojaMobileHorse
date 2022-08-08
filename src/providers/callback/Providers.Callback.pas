unit Providers.Callback;

interface

uses
  Data.Db;

type
  TCallBackIdentify = reference to procedure(const AKey: String);
  TCAllBackDataSet = reference to procedure(const ADataSet: TDataSet);

implementation

end.
