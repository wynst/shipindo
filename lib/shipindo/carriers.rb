require 'shipindo/carriers/jne'

module Shipindo

  module ClassMethods

    def find_city(options)
      options[:carrier] ||= 'jne'

      klass = find_carrier(options[:carrier])
      city = klass.new.find_city(options[:name])

      options.merge(city) if city
    end

    def find_rates(options)
      # jne is default for 99% Indonesia online shop..
      options[:carrier] ||= 'jne'

      klass = find_carrier(options[:carrier])
      klass.new.find_rates(options)
    end

    def find_carrier(name)
      case name.downcase
        when 'jne'
          Shipindo::Carrier::Jne
        else
          raise(NameError, "unknown carrier #{name}")
      end
    end

  end

  extend ClassMethods

end

