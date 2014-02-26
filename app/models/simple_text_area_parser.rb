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
    remove_commas
    to_a
    input.uniq
  end

  def extract_lines_and_spaces
    @input = input.squish
  end

  def remove_commas
    @input = input.gsub(/,\s+/, " ").gsub(/,$/, "")
  end

  def to_a
    @input = input.split(" ")
  end
end

