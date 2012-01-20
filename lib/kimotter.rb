# encoding: utf-8
require 'mechanize'
require 'nokogiri'
require 'logger'

class Kimotter
  class APILimit
    attr_accessor :limit
    attr_accessor :used

    def initialize
      @current = @max = nil
    end
  end

  attr_reader :confirm_msg

  def self.tweet(message, options={})
    raise ArgumentError unless message

    kimotter = self.new(options)
    kimotter.fetch_api_limit
    kimotter.tweet(message)
  end

  def initialize(options={})
    default_options = {
      :api => 'http://api.ma.la/twitter/',
      :logger => Logger.new(nil), # nop logger
      :user_agent => 'kimotter'
    }
    options = default_options.merge(options)

    @logger = options[:logger]
    @api = options[:api]

    @agent = Mechanize.new{ |agent|
      agent.user_agent = options[:user_agent]
    }

    @api_limit = APILimit.new
    @confirm_msg = nil

    @logger.info "setup finished"
  end

  def fetch_api_limit
    @logger.info "try to fetch api limit: URL is #{@api.inspect}"
    @agent.get(@api)
    @logger.info "successful fetched api limit"

    load_from_mala_html(@agent.page.body)
  end

  def load_from_mala_html(content_body)
    @logger.info "try to parse api limit information"
    doc = Nokogiri(content_body)
    body_text = doc.search("html > body").text

    if body_text =~ /API\s*Limit:\s*(\d+)\s*\/\s*(\d+)/
      @api_limit.used = Regexp.last_match(1).to_i
      @api_limit.limit = Regexp.last_match(2).to_i

      @logger.info "successful parsed api limit"
    else
      raise "not found api limit: #{body_text.inspect}"
    end

    begin
      @confirm_msg = doc.search("body > form > input[@type='checkbox']").first.next.text.chomp
    rescue => ex
      raise "not found confirm_msg: #{ex.inspect}"
    end
  end

  ## please overwrite this method if you need it
  def filter(message)
    message
  end

  def tweet(message)
    @logger.info "try to tweet: #{message.inspect}"
    @agent.page.form_with(:action => '/twitter/'){ |form|
      form.field_with(:name => 'status').value = filter(message)
      form.checkbox_with(:name => 'is_kimoto').check
      form.click_button
    }
    @logger.info "successful tweeted"
  end

  def api_limit?
    (@api_limit.used >= @api_limit.limit)
  end
end
