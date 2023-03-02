module NfseWebiss
  module Gateways
    class El < Base

      private

      def soap_service
        %w(NfseWSService nfseSOAP)
      end

      def return_struct(method, tag)
        %W(#{method}Response #{method}Response #{tags[tag]}Resposta)
      end

      def methods
        {
          'RecepcionarLoteRpsSincrono' => 'EnviarLoteRpsSincronoEnvio',
          'ConsultarLoteRps' => 'ConsultarLoteRpsEnvio',
          'ConsultarNfsePorRps' => 'ConsultarNfsePorRpsEnvio',
          'CancelarNfse' => 'CancelarNfseEnvio'
        }
      end

      def tags
        {
          'EnviarLoteRpsSincronoEnvio' => 'EnviarLoteRpsSincrono',
          'ConsultarLoteRpsEnvio' => 'ConsultarLoteRps',
          'ConsultarNfsePorRpsEnvio' => 'ConsultarNfsePorRps',
          'CancelarNfseEnvio' => 'CancelarNfse'
        }
      end

      def encodings
        {
          'RecepcionarLoteRpsSincrono' => 'utf-8',
          'ConsultarLoteRps' => 'utf-8',
          'ConsultarNfsePorRps' => 'utf-8',
          'CancelarNfse' => 'iso-8859-1'
        }
      end

      def template_folder
        'v204'
      end

      def build_envelope(method, msg)
        %(
          <?xml version="1.0" encoding="iso-8859-1"?>
          <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nfse="http://nfse.abrasf.org.br">
              <soapenv:Header></soapenv:Header>
              <soapenv:Body>
                <nfse:#{method}>
                  <![CDATA[<?xml version="1.0" encoding="ISO-8859-1"?>#{msg}]]>
                </nfse:#{method}>
              </soapenv:Body>
          </soapenv:Envelope>
        ).gsub(/>\s+</, "><").gsub(/\n/,'').strip
      end

    end
  end
end
