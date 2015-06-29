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
          # [fiendName, facetConfig]
          next unless f[0] =~ /^(sourceResource|provider|object|intermediateProvider|dataProvider)/
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
        q << "&provider=Empire%20State%20Digital%20Network"
        puts url + q
        data = get(url + q)
      end
      Response.new(data, params,{})
    end
  end


end
