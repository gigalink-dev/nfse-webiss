module NfseWebiss
  module Gateways
    class Webiss < Base

      SERVICOS = {
        'RecepcionarLoteRps' => 'EnviarLoteRps',
        'ConsultarSituacaoLoteRps' => 'ConsultarSituacaoLoteRps',
        'ConsultarNfsePorRps' => 'ConsultarNfsePorRps',
        'ConsultarNfse' => 'ConsultarNfse',
        'ConsultarLoteRps' => 'ConsultarLoteRps',
        'CancelarNfse' => 'CancelarNfse'
      }

    end
  end
end
