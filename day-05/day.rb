def run
  input = parse_input(read_input)
  puts input.rearrange.top

  input = parse_input(read_input)
  puts input.rearrange2.top
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
  s, i = input.split("\n\n")
  instructions = i.split("\n").map do |line|
    _, n, _, from, _, to = line.split(" ")
    [n.to_i, from.to_i, to.to_i]
  end
  s = s.split("\n")
  s.pop
  stacks = Array.new((s.first.length + 1)/4) { [] }
  s.each do |line|
    i = 0
    until line.empty?
      crate = line.slice!(0, 4)
      stacks[i].unshift(crate[1]) unless crate[1] == " "
      i += 1
    end
  end
  Cargo.new(stacks, instructions)
end

### CODE HERE ###
Cargo = Struct.new(:stacks, :instructions) do
  def rearrange
    instructions.each do |n, from, to|
      n.times do
        self.stacks[to - 1].push(self.stacks[from - 1].pop)
      end
    end
    self
  end

  def rearrange2
    instructions.each do |n, from, to|
      self.stacks[to - 1].push(*self.stacks[from - 1].pop(n))
    end
    self
  end

  def top
    self.stacks.map(&:last).join
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
    expect(input.rearrange.top).to eq "CMZ"
  end

  it "should solve part 2" do
    expect(input.rearrange2.top).to eq "MCD"
  end
end

run if $PROGRAM_NAME == __FILE__ || $PROGRAM_NAME.end_with?("ruby-memory-profiler")
