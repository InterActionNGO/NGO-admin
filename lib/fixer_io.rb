class FixerIo
  include HTTParty

  base_uri 'http://api.fixer.io'

  attr_reader :date, :base_currency, :to_currency

  def initialize(date, base_currency, to_currency)
    @date          = date
    @base_currency = base_currency
    @to_currency   = to_currency
  end

  def rate
    data['rates'][to_currency.to_s]
  end

  private

  def data
    @data ||= self.class.get("/#{date.to_date.to_s(:db)}",
      :query => {:base => @base_currency, :symbols => to_currency})
  end

end
