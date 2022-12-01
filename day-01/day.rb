def run
  input = parse_input(read_input)

  # code to run part 1 and part 2
  puts max_calories(input)
  puts max_calories(input, 3)
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
  input.split("\n\n").map do |elf|
    elf.split("\n").map do |line|
      line.to_i
    end
  end
end

### CODE HERE ###

def max_calories(input, n = 1)
  input.map(&:sum).sort.reverse.take(n).sum
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
    expect(max_calories(input)).to eq 24_000
    expect(max_calories(actual_input)).to eq 68_292
  end

  it "should solve part 2" do
    expect(max_calories(input, 3)).to eq 45_000
    expect(max_calories(actual_input, 3)).to eq 203_203
  end
end

run if $PROGRAM_NAME == __FILE__ || $PROGRAM_NAME.end_with?("ruby-memory-profiler")
