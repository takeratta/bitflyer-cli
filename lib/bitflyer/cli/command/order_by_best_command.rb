require 'bitflyer'

class OrderByBestCommand
  def initialize
    @http_public_client = Bitflyer.http_public_client
    @http_private_client = Bitflyer.http_private_client(api_key, api_secret)
  end

  def run(options)
    amount = options.amount
    type = options.type
    if amount == nil || type == nil
      puts 'You need set amount by -a and type by -t'
      puts 'ex: bitflyer order_by_best -a 10 -t buy'
      return
    end

    ticker = @http_public_client.ticker('FX_BTC_JPY')
    price = type == 'buy' ? ticker['best_bid'] : ticker['best_ask']

    response = @http_private_client.send_child_order(
        product_code: 'FX_BTC_JPY',
        child_order_type: 'LIMIT',
        side: type.upcase,
        price: price,
        size: amount
    )
    if response['child_order_acceptance_id'].nil?
      puts 'An error has occurred' + response.to_s
    else
      puts "An order is created #{type} / #{price} / #{amount}"
    end
  end

  private

  def api_key
    ENV['BITFLYER_API_KEY']
  end

  def api_secret
    ENV['BITFLYER_API_SECRET']
  end
end