require File.expand_path(File.join(File.dirname(__FILE__), %w(.. test_helper)))

require 'shipindo'

class CarriersTest < Test::Unit::TestCase

  context "A Shipindo class" do

    should "find class" do
      assert_equal("Shipindo::Carrier::Jne", Shipindo.find_carrier('jne').name)
      assert_raises(NameError) { Shipindo.find_carrier('kantor-pos') }
    end

    should "display valid rate" do
      data = Shipindo.find_rates(
        :origin       => "MEDAN",
        :destination  => "TANGERANG",
        :weight       => 2)

      assert_equal "jne",       data[:carrier]
      assert_equal "MEDAN",     data[:response][:origin]
      assert_equal "TANGERANG", data[:response][:destination]
      assert_equal 4,           data[:response][:rates].length
      assert_equal "SS",        data[:response][:rates][0][:service_name]
      assert_equal 330_000,     data[:response][:rates][0][:rate]
    end

  end

end

