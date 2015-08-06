#!/usr/bin/env ruby2.1

class BrandFactoryRecommender
  attr_accessor :minimum

  def parse_raw(lines)
    minimum = lines.shift.to_i
    parse_logs lines
  end

  def parse_brand_log(line)
    log_tuple = line.split(',').freeze
    brand = log_tuple.last.freeze
    factories = log_tuple[0..1]
    {
      brand: brand,
      factories: factories
    }
  end

  def parse_logs(lines)
    @history = {}

    lines.each.sort do |line|
      log_tuple = parse_brand_log line
    end
  end
end

input_lines = STDIN.read.split("\n")
recommender = BrandFactoryRecommender.new
recommender.parse_raw input_lines
