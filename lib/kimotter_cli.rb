require 'kimotter'

module KimotterCLI
  def self.execute(options={})
    parser = OptionParser.new{ |opts|
      opts.banner = "Usage: #{File.basename($0)} [options] [tweet_message]"
      opts.on("-d", "--debug", "Debug Mode"){ |v|
        options[:debug_mode] = true
      }
      opts.on("-f", "--force", "Force execute, ignore api limit"){ |v|
        options[:force_execute] = true
      }
      opts.on("-a", "--api=URL", "API Endpoint URL"){ |url|
        options[:api_endpoint] = url
      }
    }
    parser.parse!

    message = ARGV.shift
    unless message
      file = Tempfile.new('foo')
      file.close

      unless system(ENV['EDITOR'], file.path)
        raise "system command aborted"
      end
      message = File.read(file.path).chomp.gsub(/\n/, " ")
    end

    if message.empty?
      raise "please input message"
    end

    logger = options[:debug_mode] ? Logger.new(STDERR) : Logger.new(nil)
    api = options[:api_endpoint] || "http://api.ma.la/twitter/"
    kimotter = Kimotter.new(:api => api, :logger => logger)

    kimotter.fetch_api_limit
    if !options[:force_execute] and kimotter.api_limit?
      puts "u cant use this api now(api limit)"
      puts "try again later or retry with --force option (ignore API limit)"
      exit(1)
    end

    print kimotter.confirm_msg + "[y/N] "
    if user_input_line = $stdin.gets
      if user_input_line =~ /^(yes|y)$/i
        puts "hi kimoto. try to tweet your cool message"
        kimotter.tweet(message)
        puts "done!"
        exit(0)
      else
        puts "your tweet went to hell on earth. god damn it"
        exit(3)
      end
    else
      puts "omg?"
      exit(2)
    end
  end
end

