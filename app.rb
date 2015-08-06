#!/usr/bin/env ruby2.1
require 'awesome_print'

class BrandFactoryRecommender
  attr_accessor :minimum

  def initialize
    @known_pairs = []
  end

  # Takes the raw input, be it from a file or STDIN and preps the recommender.
  def parse_raw(lines)
    minimum = lines.shift.to_i
    pairs = parse_logs(lines)
    pretty_print(pairs)
  end

  # Walks through every line and attempts to parse it.
  def parse_logs(lines)
    lines.each do |line|
      line_factories = line.split ','
      available_pairs = get_pairs_from_tokens(line_factories)
      add_new_pairs(available_pairs)
    end

    pair_counts = @known_pairs.uniq.map do |pair|
      count = 0
      pair_regex = /#{pair[0]},#{pair[1]}/
      lines.each do |line|
        count += 1 if line.match(pair_regex)
      end
      { pair: pair, count: count }
    end

    pair_counts = pair_counts.delete_if do |value|
      value[:count] < 3
    end

    pair_counts
  end

  def add_new_pairs(pairs)
    pairs.each do |pair|
      @known_pairs << pair
    end
  end

  def get_pairs_from_tokens(line_factories)
    factories_count = line_factories.count
    return [] if factories_count == 0

    pairs = []
    until line_factories[1].nil?
      fetched_pair = [line_factories.shift, line_factories[0]]
      pairs << fetched_pair
    end

    pairs
  end
  
  def pretty_print(pairs)
    strings = pairs.map { |pair| pair[:pair].sort.join ',' }
    strings.sort.each { |str| puts str }
  end
end

input_lines = STDIN.read.split("\n")
recommender = BrandFactoryRecommender.new
recommender.parse_raw input_lines
