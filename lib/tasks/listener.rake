require 'tf2_line_parser'
require 'eventmachine'

namespace :listener do

  class Handler < EM::Connection

    def receive_data(data)
      log_line = ActiveSupport::Multibyte::Chars.new(data).tidy_bytes
      matches = log_line[5..-1].to_s.match('(?\'secret\'\d*)(?\'line\'.*)')
      if matches && matches[:secret]
        match   = find_match(matches[:secret])
        save_line(matches[:line], match, matches[:secret])
      else
        puts "No secret or no match found for secret, discarding: #{log_line}"
      end
    end

    def save_line(line, match, secret)
      if match
        puts "#{match.id}: #{line}"
        LogLine.create!(:line => line, :match => match)
      else
        puts "NO MATCH FOUND FOR #{secret} - #{line}"
      end
    end

    def find_match(secret)
      Match.find_by_secret(secret)
    end
  end

  desc "listen"
  task :listen, [:host, :port] => :environment do |t, args|
    @host = args[:host]
    @port = args[:port]
    puts "Listening on #{@host}, #{@port}..."
    EM.run {
      host = @host
      port = @port
      EM::open_datagram_socket(host, port, Handler)
    }
  end
end
