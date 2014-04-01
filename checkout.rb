class Checkout
  Item = Struct.new(:code, :price)
  PRODUCTS = { FR1: 3.11, SR1: 5.00, CF1: 11.23 }

  def initialize(*keys)
    @discounts = build_discount_strategies(keys)
    @basket = []
  end

  def scan(code)
    raise "Unknown product with code `#{ code }`" unless PRODUCTS.has_key?(code)
    @basket << code
  end

  def total
    items = @basket.map { |code| Item.new(code, PRODUCTS[code]) }
    @discounts.each { |discount| discount.call(items) }
    items.reduce(0) { |sum, item| sum + item.price }
  end

  private

  def build_discount_strategies(keys)
    keys.map do |key|
      case key
      when :second_free
        ->(list) { list.group_by(&:code).values.each { |group| group.each_with_index { |item, i| item.price = 0 if i.odd? } } }
      when :strawberries_discount
        ->(list) do
          strawberries = list.select { |item| item == :SR1 }
          strawberries.each { |item| item.price = 4.5 unless item.price > 4.5 } if strawberries.size >= 3
        end
      else
        raise "Unsupported discount strategy `#{ key }`"
      end
    end
  end
end
