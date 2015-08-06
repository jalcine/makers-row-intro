#!/usr/bin/env ruby2.1
require 'awesome_print'

class BrandFactoryRecommender
  attr_accessor :minimum

  def initialize
    clear_history
    @known_factories = []
  end

  def clear_history
    @history = {}
  end

  def update_history(brand_log)
    brand = brand_log[:brand]
    current_factories = @history[brand]
    @history[brand] = [] if current_factories.nil?
    @history[brand] += brand_log[:factories]
  end

  def sort_factories_in_history
    @history.each do |_, value|
      value.sort!
    end
  end

  def parse_raw(lines)
    minimum = lines.shift.to_i
    parse_logs lines
  end

  def parse_brand_log(line)
    log_tuple = line.split(',').freeze
    brand = log_tuple.last.freeze
    factories = log_tuple[0..1]
    @known_factories << factories
    {
      brand: brand,
      factories: factories
    }
  end

  def parse_logs(lines)
    clear_history

    # one 'n' loop
    lines.sort.each do |line|
      brand_log = parse_brand_log line
      update_history brand_log
    end

    # second 'n' loop
    @known_factories.each do |known_factory|

    end

    ap @history
  end
end

input_lines = STDIN.read.split("\n")
recommender = BrandFactoryRecommender.new
recommender.parse_raw input_lines
