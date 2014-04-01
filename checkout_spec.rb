require_relative 'checkout'

describe Checkout do
  subject(:checkout) { described_class.new(:second_free, :strawberries_discount) }

  context '#total' do
    subject(:total) { checkout.total }

    specify "FR1,SR1,FR1,FR1,CF1" do
      %i(FR1 SR1 FR1 FR1 CF1).each { |item| checkout.scan(item) }

      expect(total).to eq(22.45)
    end

    specify "FR1,FR1" do
      2.times { checkout.scan(:FR1) }

      expect(total).to eq(3.11)
    end

    specify "SR1,SR1,FR1,SR1" do
      %i(SR1,SR1,FR1,SR1).each { |item| checkout.scan(item) }

      expect(total)
    end
  end
end
