module NfseWebiss
  module Gateways
    class Base
      def initialize(options = {})
        # define_methods
        @ssl_cert = options.delete(:ssl_cert)
        @options = options
      end

      def recepcionar_lote_rps_sincrono(body)
        request('RecepcionarLoteRpsSincrono', body)
      end

      def consultar_lote_rps(body)
        request('ConsultarLoteRps', body)
      end

      def cancelar_nfse(body)
        request('CancelarNfse', body)
      end

      private

      def methods
        {}
      end

      def return_struct(_method, _tag)
        []
      end

      def encodings
        {}
      end

      def template_folder
        ''
      end

      # def define_methods
      #   methods.keys.each do |method|
      #     eval <<-CODE
      #       def #{method.underscore}(body)
      #         request('#{method}', body)
      #       end
      #     CODE
      #   end
      # end

      def template_path
        File.expand_path("../../templates/#{template_folder}/", __FILE__)
      end

      def render_xml(template, data)
        partial = -> (t, d) { render_xml(t, d) }
        data_object = OpenStruct.new(data)
        data_object.define_singleton_method(:partial) do |t, d|
          partial.call(t, d)
        end
        file = File.read("#{template_path}/#{template}.haml")
        engine = ::Haml::Engine.new(file, { attr_wrapper: '"' })
        engine.render(data_object)
      end

      # private

      def certificate
        @ssl_cert ||= OpenSSL::PKCS12.new(File.read(@options[:ssl_cert_path]), @options[:ssl_cert_pass])
      end

      def request(method, data = {})
        service, port = soap_service
        operation = savon_client.operation(service, port, method)
        msg = render_xml('base', data.merge(template: method.underscore, tag: "#{methods[method]}"))
        operation.encoding = encodings[method]
        operation.xml_envelope = build_envelope(method, msg)
        Response.new(return_struct(method, methods[method]), methods[method], operation.call)
      # rescue Savon::Error
      end

      def savon_client
        @savon ||= Savon.new(@options[:wsdl], http_client)
      end

      def http_client
        client = Savon::HTTPClient.new
        client.client.send_timeout = 0
        client.client.receive_timeout = 0
        client.client.ssl_config.client_cert = certificate.certificate
        client.client.ssl_config.client_key = certificate.key
        client.client.ssl_config.verify_mode = OpenSSL::SSL::VERIFY_NONE
        client
      end
    end
  end
end
