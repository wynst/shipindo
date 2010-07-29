require File.expand_path(File.join(File.dirname(__FILE__), %w(.. test_helper)))

require 'shipindo/helpers/rupiah_to_float'

class RupiahToFloatTest < Test::Unit::TestCase

  context "A RupiahToFloat string extension" do

    should "define aliases" do
      assert "TEST".respond_to? :rupiah_to_float
      assert "TEST".respond_to? :rp_to_f
    end

    should "parse rupiah" do
      assert_equal 16_000,    " 16.000,00 ".rupiah_to_float
      assert_equal 16_000.50, " 16000,50  ".rupiah_to_float
      assert_equal 1_600_000, " 1600000   ".rupiah_to_float
      assert_equal 16_000,    " Rp. 16,000.00 ".rupiah_to_float(
        :thousand_separator => ",",
        :cent_separator     => ".")
    end

  end

end

