require 'test_helper'
require 'pry-nav'

class DHLTest < Test::Unit::TestCase
  def setup
    @carrier = DHL.new(site_id: 'CustomerTest', password: 'alkd89nBV', test: true)
    @packages  = TestFixtures.packages
    @locations = TestFixtures.locations
    @chocolate = @packages[:chocolate_stuff]

    mock_response = xml_fixture('dhl/rates')
    @carrier.expects(:ssl_post).returns(mock_response)
  end

  def test_find_rates_returnes_a_rate_response
    resp = @carrier.find_rates(@locations[:beverly_hills], @locations[:ottawa], [@chocolate])
    assert resp.success?
    assert resp.test
    assert resp.is_a?(RateResponse)
  end

  def test_find_rates_returns_rate_estimates
    resp = @carrier.find_rates(@locations[:beverly_hills], @locations[:ottawa], [@chocolate])
    resp.rates.each do |rate|
      assert rate.is_a?(ActiveMerchant::Shipping::RateEstimate)
    end
  end
end
