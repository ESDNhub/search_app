module Dbla
  class Repository  < Blacklight::AbstractRepository
    extend Deprecation
    self.deprecation_horizon = 'blacklight 6.0'

    def search params = {}
      data = nil
      #TODO Move this into a SearchBuilder, add a generator
      if params['q']
        q = "?api_key=#{api_key}&q=#{params['q']}"
        fq = []
        blacklight_config.facet_fields.each do |f|
          # byebug
          # [fiendName, facetConfig]
          next unless f[0] =~ /^(sourceResource|provider|object|intermediateProvider|dataProvider|relation)/
          fqv = f[0]
          fqv = fqv + ':' + f[1].pin if f[1].pin
          fq << fqv
        end
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
        q << '&provider="Empire+State+Digital+Network"+OR+"New+York+Public+Library"'
        uri = URI.encode(url + q)
        parsed_uri = URI.parse(uri)
        data = get(parsed_uri)
      end
      Response.new(data, params,{})
    end
  end


end
