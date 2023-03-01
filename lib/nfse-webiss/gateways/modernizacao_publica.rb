module NfseWebiss
  module Gateways
    class ModernizacaoPublica < Base

      private

      def soap_service
        %w(NFEServicesService NFEServices)
      end

      def return_struct(method, tag)
        %W(#{method}Response #{method}Return #{tag}Resposta)
      end

      def methods
        {
          'RecepcionarLoteRps' => 'EnviarLoteRps',
          'RecepcionarLoteRpsSincrono' => 'EnviarLoteRpsSincrono',
          'GerarNfse' => 'GerarNfse',
          'CancelarNfse' => 'CancelarNfse',
          'SubstituirNfse' => 'SubstituirNfse',
          'ConsultarLoteRps' => 'ConsultarLoteRps',
          'ConsultarNfsePorRps' => 'ConsultarNfsePorRps',
          'ConsultarNfseServicoPrestado' => 'ConsultarNfse',
          'ConsultarNfseServicoTomado' => 'ConsultarNfse',
          'ConsultarNfsePorFaixa' => 'ConsultarNfseFaixa'
        }
      end

      def encodings
        {
          'RecepcionarLoteRps' => 'iso-8859-1',
          'RecepcionarLoteRpsSincrono' => 'iso-8859-1',
          'GerarNfse' => 'iso-8859-1',
          'CancelarNfse' => 'iso-8859-1',
          'SubstituirNfse' => 'iso-8859-1',
          'ConsultarLoteRps' => 'iso-8859-1',
          'ConsultarNfsePorRps' => 'iso-8859-1',
          'ConsultarNfseServicoPrestado' => 'iso-8859-1',
          'ConsultarNfseServicoTomado' => 'iso-8859-1',
          'ConsultarNfsePorFaixa' => 'iso-8859-1'
        }
      end

      def template_folder
        'v202'
      end

      def build_envelope(method, msg)
        %(
          <?xml version="1.0" encoding="iso-8859-1"?>
          <soapenv:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:def="http://DefaultNamespace">
             <soapenv:Header></soapenv:Header>
             <soapenv:Body>
                <def:#{method} soapenv:encodingStyle="http://schemas.xmlsoap.org/soap/encoding/">
                   <Nfsecabecmsg xsi:type="xsd:string"><![CDATA[<cabecalho xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns="http://www.abrasf.org.br/nfse.xsd" versao="2.02"><versaoDados>2.01</versaoDados></cabecalho>]]></Nfsecabecmsg>
                   <Nfsedadosmsg xsi:type="xsd:string"><![CDATA[#{msg}]]></Nfsedadosmsg>
                </def:#{method}>
             </soapenv:Body>
          </soapenv:Envelope>
        ).gsub(/>\s+</, "><").gsub(/\n/,'').strip
      end

    end
  end
end
