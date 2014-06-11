require 'socket'

class Listener

  attr_accessor :socket

  def initialize(ip, port)
    @socket = UDPSocket.new
    @socket.bind(ip, port)
    puts "Bound to #{ip}:#{port}..."
  end

  def listen_loop
    loop do
     log_line = socket.recvfrom(4000)[0][5..-1]
     StatsParser.new(TF2LineParser::Parser.new(log_line).parse)
    end
  end

end
