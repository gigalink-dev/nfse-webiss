module NfseWebiss
  class Response
    def initialize(return_struct, tag, savon_response)
      @tag = tag
      @savon_response = savon_response
      @return_struct = return_struct
    end

    attr_reader :return_struct, :tag, :savon_response, :xml

    def retorno
      @retorno ||= parse_response
    end

    def [](key)
      retorno[key]
    end

    private

    def parse_response
      body = savon_response.hash[:envelope][:body]
      response, result, resposta = return_struct.map(&:snakecase).map(&:to_sym)

      if body[response]
        @xml = body[response][result][:output_xml].gsub('&', '&amp;') # TODO: arrumar esse gsub

        parsed = nori.parse(xml)
        parsed[resposta] || parsed
      else
        body
      end
    end

    def nori
      return @nori if @nori

      nori_options = {
        strip_namespaces: true,
        convert_tags_to: ->(tag) { tag.snakecase.to_sym }
      }

      @nori = Nori.new(nori_options)
    end
  end
end
