require 'bitflyer'

module HasRealtimeClient
  def realtime_client
    @realtime_client ||= Bitflyer.realtime_client
  end
end