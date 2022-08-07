inherited ServiceConsultaCliente: TServiceConsultaCliente
  object mtClientes: TFDMemTable
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    Left = 104
    Top = 40
    object mtClientesid: TLargeintField
      FieldName = 'id'
      Origin = 'id'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
    end
    object mtClientesnome: TWideStringField
      FieldName = 'nome'
      Origin = 'nome'
      Size = 60
    end
    object mtClientesstatus: TSmallintField
      FieldName = 'status'
      Origin = 'status'
    end
  end
end
