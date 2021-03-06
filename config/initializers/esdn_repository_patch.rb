module Dbla
  class Repository  < Blacklight::AbstractRepository
    extend Deprecation
    self.deprecation_horizon = 'blacklight 6.0'

    def find id, params = {}
      puts "find_url: " + "#{url}/#{id}?api_key=#{api_key}"
      data = get("#{url}/#{id}?api_key=#{api_key}")
      Response.new(data, params,{})
    end

    def search params = {}
      data = nil
      #TODO Move this into a SearchBuilder, add a generator
      #TODO handle searches with blank 'q' param
      if params['q']
        q = "?api_key=#{api_key}&q=#{CGI::escape(params['q'])}"
        fq = []
        blacklight_config.facet_fields.each do |f|
          # [fiendName, facetConfig]
          next unless f[0] =~ /^(sourceResource|provider|object|intermediateProvider|dataProvider|relation)/
          fqv = f[0]
          fqv = fqv + ':' + f[1].pin if f[1].pin
          fq << fqv
        end
        #byebug
        q << "&facets=#{fq.join(',')}" unless fq.empty?
        if params.page
          q << "&page=#{params.page}"
        end
        if params.rows
          q << "&page_size=#{params.rows}"
        end
        params.facet_filters do |facet_field, value|
          value = "\"#{value}\"" if value.index(' ')
          q << "&#{facet_field}=#{CGI::escape(value)}"
        end
        # byebug
        url_suffix =  URI.encode('&provider="Empire+State+Digital+Network"+OR+"New+York+Public+Library"')
        q << url_suffix
        puts "search_url: " + url + q
        data = get(url + q)
      end
      Response.new(data, params,{})
    end

    def get(uri)
      uri = URI(uri)
      #byebug
      Net::HTTP.start(uri.host, uri.port) do |http|
        request = Net::HTTP::Get.new uri
        response = http.request request
        return JSON.parse(response.body)
      end
    end
  end
end
