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
          'ConsultarNfseRps' => 'ConsultarNfseRpsEnvio',
          'CancelarNfse' => 'CancelarNfseEnvio'
        }
      end

      def tags
        {
          'EnviarLoteRpsSincronoEnvio' => 'EnviarLoteRpsSincrono',
          'ConsultarLoteRpsEnvio' => 'ConsultarLoteRps',
          'ConsultarNfseRpsEnvio' => 'ConsultarNfseRps',
          'CancelarNfseEnvio' => 'CancelarNfse'
        }
      end

      def encodings
        {
          'RecepcionarLoteRpsSincrono' => 'utf-8',
          'ConsultarLoteRps' => 'utf-8',
          'ConsultarNfseRps' => 'utf-8',
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
                  <nfse:#{method}Request>
                    <nfseCabecMsg>
                      <![CDATA[<?xml version="1.0" encoding="ISO-8859-1"?>
                        <ns1:cabecalho xmlns:xsi='http://www.w3.org/2001/XMLSchema-instance' xmlns:ns2='http://www.w3.org/2000/09/xmldsig#' xmlns:ns1='http://www.abrasf.org.br/nfse.xsd' xsi:schemaLocation='http://www.w3.org/2000/09/xmldsig# abrasfteste/xmldsig-core-schema20020212.xsd http://www.abrasf.org.br/nfse.xsd abrasfteste/nfse_v2-04.xsd'>
                          <ns1:versaoDados>2.04</ns1:versaoDados>
                        </ns1:cabecalho>]]>
                    </nfseCabecMsg>
                    <nfseDadosMsg>
                      <![CDATA[<?xml version="1.0" encoding="ISO-8859-1"?>#{msg}]]>
                    </nfseDadosMsg>
                  </nfse:#{method}Request>
                </nfse:#{method}>
              </soapenv:Body>
          </soapenv:Envelope>
        ).gsub(/>\s+</, "><").gsub(/\n/,'').strip
      end

    end
  end
end
