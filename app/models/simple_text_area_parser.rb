# This class feels a bit overkill.
# But, it allowed me to test it easier.
class SimpleTextAreaParser
  attr_reader :input

  def self.parse(input)
    new(input).parse
  end

  def initialize(input)
    @input = input
  end

  def parse
    extract_lines_and_spaces
    to_a
    remove_commas
    remove_quotes
    input.uniq
  end

  def extract_lines_and_spaces
    @input = input.squish
  end

  def to_a
    @input = input.split(" ")
  end

  def remove_commas
    @input = input.map { |email| email.gsub(/,/, "") }
  end

  def remove_quotes
    @input = input.map { |email| email.gsub(/"/, "") }
  end
end

