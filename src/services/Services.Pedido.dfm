inherited ServicePedido: TServicePedido
  OldCreateOrder = True
  OnCreate = DataModuleCreate
  Height = 328
  Width = 481
  object mtPedidos: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 80
    Top = 40
    object mtPedidosid: TLargeintField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtPedidosid_cliente: TLargeintField
      FieldName = 'id_cliente'
      Origin = 'id_cliente'
    end
    object mtPedidosdata: TSQLTimeStampField
      FieldName = 'data'
      Origin = 'data'
    end
    object mtPedidosid_usuario: TLargeintField
      FieldName = 'id_usuario'
      Origin = 'id_usuario'
    end
    object mtPedidosnome_cliente: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome_cliente'
      Origin = 'nome_cliente'
      Size = 60
    end
    object mtPedidostotal: TCurrencyField
      FieldName = 'total'
    end
  end
  object mtCadastro: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 160
    Top = 72
    object mtCadastroid: TLargeintField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtCadastroid_cliente: TLargeintField
      FieldName = 'id_cliente'
      Origin = 'id_cliente'
    end
    object mtCadastrodata: TSQLTimeStampField
      FieldName = 'data'
      Origin = 'data'
    end
    object mtCadastroid_usuario: TLargeintField
      FieldName = 'id_usuario'
      Origin = 'id_usuario'
    end
    object mtCadastronome_cliente: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome_cliente'
      Origin = 'nome_cliente'
      Size = 60
    end
    object mtCadastrototal: TCurrencyField
      FieldName = 'total'
    end
  end
  object mtItens: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 256
    Top = 72
    object mtItensid: TLargeintField
      AutoGenerateValue = arAutoInc
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      ReadOnly = True
    end
    object mtItensid_pedido: TLargeintField
      FieldName = 'id_pedido'
      Origin = 'id_pedido'
    end
    object mtItensid_produto: TLargeintField
      FieldName = 'id_produto'
      Origin = 'id_produto'
    end
    object mtItensvalor: TFMTBCDField
      FieldName = 'valor'
      Origin = 'valor'
      Precision = 20
      Size = 4
    end
    object mtItensquantidade: TFMTBCDField
      FieldName = 'quantidade'
      Origin = 'quantidade'
      Precision = 20
      Size = 4
    end
    object mtItensnome_produto: TWideStringField
      AutoGenerateValue = arDefault
      FieldName = 'nome_produto'
      Origin = 'nome_produto'
      Size = 60
    end
    object mtItenstotal: TCurrencyField
      FieldName = 'total'
    end
  end
end
