#!/usr/bin/env ruby
# -*- encoding: utf-8 -*-

require 'open-uri'
require 'clockwork'

class WakeUpInstances
  def initialize(urls = [])
    @urls = urls
  end

  def run
    @urls.each do |url|
      access url
    end
  end

  def access(url)
    retry_count = 2
    begin
      open(url).read
    rescue => e
      retry_count -= 1
      if retry_count > 0
        sleep 10
        retry
      end
    end
  end
end

include Clockwork

handler do |job|
  puts "Running #{job}"
  wui = WakeUpInstances.new %w{
    http://api.yui-search.com/search?q=%E3%83%A9%E3%83%BC%E3%83%A1%E3%83%B3
    http://g.s5r.jp
    http://yuueki-api.s5r.jp
  }
  wui.run
end

every(1.hour, 'wake_up_instances.job')

