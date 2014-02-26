require 'spec_helper'

describe SimpleTextAreaParser do
  let(:parser) {
    SimpleTextAreaParser.new("test@example.com,    \ntest2@example.com\n\ntest3@example.com,\n")
  }

  it 'parses lines and spaces' do
    parser.extract_lines_and_spaces.should eq "test@example.com, test2@example.com test3@example.com,"
  end

  it 'removes commas' do
    parser.extract_lines_and_spaces
    parser.remove_commas.should eq "test@example.com test2@example.com test3@example.com"
  end

  it 'parses to array' do
    parser.parse.should eq ["test@example.com", "test2@example.com", "test3@example.com"]
  end

  it 'only returns unique inputs' do
    parser = SimpleTextAreaParser.new("test@example.com, test@example.com, test@example.com")
    parser.parse.should eq ["test@example.com"]
  end
end

