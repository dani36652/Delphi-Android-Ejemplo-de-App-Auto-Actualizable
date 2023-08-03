object WbModule: TWbModule
  Actions = <
    item
      MethodType = mtPost
      Name = 'Actualizacion_Android'
      PathInfo = '/update/android'
      OnAction = WbModuleActualizacion_AndroidAction
    end>
  Height = 230
  Width = 415
end
