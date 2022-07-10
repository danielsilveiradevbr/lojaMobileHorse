unit Providers.Models.Token;

interface

type
  TToken = class
  private
    FAccess, FRefresh: String;
  public
    property Access: string read FAccess write FAccess;
    property Refresh: string read FRefresh write FRefresh;
  end;

implementation

end.
