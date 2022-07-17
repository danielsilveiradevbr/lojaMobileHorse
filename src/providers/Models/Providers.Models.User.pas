unit Providers.Models.User;

interface

type
  TUser = class
  private
    FId: integer;
    FNome: string;
    FLogin: String;
    FTelefone: String;
    FSexo: integer;
  public
    property Id: Integer read FId write FId;
    property Nome: String read FNome write FNome;
    property Login: String read FLogin write FLogin;
    property Telefone: String read FTelefone write FTelefone;
    property Sexo: integer read FSexo write FSexo;
    function GetSexoAsString(): String;
  end;

implementation

{ TUser }

function TUser.GetSexoAsString: String;
begin
  result := 'Masculino';
  if FSexo = 1 then
    result := 'Feminino';
end;

end.
