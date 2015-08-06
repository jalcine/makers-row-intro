#!/usr/bin/env ruby2.1
require 'awesome_print'

class BrandFactoryRecommender
  attr_accessor :minimum

  def initialize
    @known_pairs
  end

  # Takes the raw input, be it from a file or STDIN and preps the recommender.
  def parse_raw(lines)
    minimum = lines.shift.to_i
    parse_logs(lines)
  end

  # Walks through every line and attempts to parse it.
  def parse_logs(lines)
    lines.each do |line|
      line_factories = line.split ','
      available_pairs = get_pairs_from_tokens(line_factories)
      add_new_pairs(available_pairs)
    end

    pairs
  end

  def add_new_pairs(pairs)
    pairs.each do |pair|
      @known_pairs << pair unless @known_pairs.include? pair
    end
  end

  def get_pairs_from_tokens(line_factories)
    pair_count = line_factories.count - 1
    return [] if pair_count == 0

    pairs = []
    until line_factories.empty?
      fetched_pair = [line_factories.shift, line_factories[0]]
      break if fetched_pair[1].nil?
      pairs << fetched_pair
    end

    pairs
  end
end

input_lines = STDIN.read.split("\n")
recommender = BrandFactoryRecommender.new
recommender.parse_raw input_lines
