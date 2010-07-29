module Shipindo
  module Helpers
    module RupiahToFloat
      # convert rupiah string to float
      # @param [Hash] options conversion options
      # @option options [String] :prefix ("Rp.") prefix to remove
      # @option options [String] :thousand_separator (".") separator for thousands
      # @option options [String] :cent_separator (",") separator for cents
      def rupiah_to_float(options={})
        options[:prefix]             ||= "Rp."
        options[:thousand_separator] ||= "."
        options[:cent_separator]     ||= ","

        text = self.gsub(options[:prefix],"").gsub(options[:thousand_separator],"")
        if text.include?(options[:cent_separator]) && options[:cent_separator] != "."
          text = text.gsub(options[:cent_separator], ".")
        end
        text.to_f
      end

      alias :rp_to_f :rupiah_to_float
    end
  end
end

class String
  include Shipindo::Helpers::RupiahToFloat
end

