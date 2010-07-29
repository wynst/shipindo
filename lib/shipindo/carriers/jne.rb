require 'nokogiri'
require 'restclient'

require 'shipindo/helpers/rupiah_to_float'

module Shipindo::Carrier

  class Jne

    def list_city(query, limit=1)
      # bug in JNE server, limit parameter is ignored
      resp = RestClient.get "http://www.jne.co.id/tariff.php?q=#{ query }&limit=#{ limit }"

      resp.body.split("\r\n").map do |item|
        city, code  = item.split("|")
        { :city => city, :code => code }
      end
    end

    def find_rates(options)
      if options[:origin] && options[:destination]
        options[:origin_code]      = list_city(options[:origin]).first[:code]
        options[:destination_code] = list_city(options[:destination]).first[:code]
        # another jne server flunk, response city name is from request parameters,
        # if there isn't any eg. using only code if cities, then it's displayed as empty.
        options[:from] = options[:origin]
        options[:to]   = options[:destination]
      end

      unless options[:origin_code] && options[:destination_code]
        raise(ArgumentError, "origin & destination or code must be defined")
      end

      options[:weight] ||= 1

      resp = RestClient.post "http://www.jne.co.id/index.php?mib=tariff&lang=IN", options

      doc  = Nokogiri::HTML.parse(resp.body)

      options[:response] = parse_rates(doc)
      options
    end

    protected

    def parse_rates(doc)
      h = {}
      h[:rates] = []

      # get estimates information
      l = doc.css("tr.trfH")
      if l.length >= 4

        get_info = Proc.new do |doc|
          td = doc.css('td')
          if td.length >= 3
            td[2].inner_html
          end
        end

        h[:origin]      = get_info.call(l[0])
        h[:destination] = get_info.call(l[1])
        h[:weight]      = get_info.call(l[2])
      end

      # get rates estimates
      doc.css("tr.trfC").each do |tr|
        t = tr.css("td")

        if t.length == 3
          h[:rates] << {
            :service_name => t[0].inner_html.strip,
            :service_type => t[1].inner_html,
            :rate         => t[2].inner_html.rp_to_f(
                                  :thousand_separator => ",",
                                  :cent_separator => ".")
          }
        end
      end
      h
    end
  end

end

