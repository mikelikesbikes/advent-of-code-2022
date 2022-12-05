def run
  input = parse_input(read_input)

  # code to run part 1 and part 2
  puts reconsider(input).length
  puts reconsider2(input).length
end

def read_input(filename = "input.txt")
  if !STDIN.tty?
    ARGF.read
  else
    filename = File.expand_path(ARGV[0] || filename, __dir__)
    File.read(filename)
  end
end

def parse_input(input)
  input.split("\n").map do |line|
    line.split(",").map { |s| parse_range(s) }
  end
end

def parse_range(s)
  b, e = s.split("-")
  b.to_i..e.to_i
end

### CODE HERE ###
def reconsider(input)
  input.select do |r1, r2|
    r1.cover?(r2) || r2.cover?(r1)
  end
end

def reconsider2(input)
  input.select do |r1, r2|
    r1.include?(r2.begin) || r2.include?(r1.begin)
  end
end

### TESTS HERE ###
require "rspec"

describe "day" do
  let(:input) do
    parse_input(File.read("test.txt"))
  end

  let(:actual_input) do
    parse_input(File.read("input.txt"))
  end

  it "should solve part 1" do
    expect(reconsider(input).length).to eq 2
  end

  it "should solve part 2" do
    expect(reconsider2(input).length).to eq 4
  end
end

run if $PROGRAM_NAME == __FILE__ || $PROGRAM_NAME.end_with?("ruby-memory-profiler")
