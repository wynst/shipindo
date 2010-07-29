require File.expand_path(File.join(File.dirname(__FILE__), %w(.. test_helper)))

require 'shipindo/carriers/jne'

class Shipindo::Carrier::Jne
  public :parse_rates
end

class JneTest < Test::Unit::TestCase

  context "A Jne class" do
    setup do
      @jne = Shipindo::Carrier::Jne.new
    end

    should "raise ArgumentError when no destination_code defined" do
      assert_raises(ArgumentError) { @jne.find_rates(:origin => "Jakarta") }
    end

    should "parse rates" do
      doc  = Nokogiri::HTML.parse File.read('test/fixtures/jne.html')
      resp = @jne.parse_rates(doc)
      assert_equal "MEDAN",     resp[:origin]
      assert_equal "TANGERANG", resp[:destination]
      assert_equal 4,           resp[:rates].length
      assert_equal "REG",       resp[:rates][2][:service_name]
      assert_equal 15_000,      resp[:rates][3][:rate]
    end

    should "parse city list" do
      list = @jne.list_city('JAKARTA')
      assert_equal 6, list.length
      assert_equal "JAKARTA BARAT", list[1][:city]
      assert_equal "Q0dLMTAxMDBK",  list[1][:code]
      assert_equal "JAKARTA TIMUR", list[4][:city]
      assert_equal "Q0dLMTA1MDBK",  list[4][:code]
    end

  end

end

