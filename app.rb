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
      pair_regex = /#{pair.first},#{pair.last}/
      lines.each do |line|
        count += 1 if line.match(pair_regex)
      end
      { pair: pair, count: count }
    end

    pair_counts.delete_if { |v| v[:count] < 3 }
  end

  def add_new_pairs(pairs)
    pairs.each do |pair|
      @known_pairs << pair unless @known_pairs.include? pair
    end
  end

  def get_pairs_from_tokens(line_factories)
    pairs = []
    factories_count = line_factories.count
    return pairs if factories_count == 0

    upper_half = line_factories.slice(0, factories_count / 2)
    lower_half = line_factories.slice(factories_count / 2, factories_count - 1)

    upper_half.each do |entry|
      lower_half.each { |second_entry| pairs << "#{entry},#{second_entry}" }
    end

    pairs
  end

  def pretty_print(pairs)
    strings = pairs.map { |pair| pair[:pair].sort.join ',' }
    strings.sort
  end
end

input_lines = STDIN.read.split("\n")
recommender = BrandFactoryRecommender.new
recommended_factories = recommender.parse_raw input_lines
puts recommended_factories
