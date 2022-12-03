def run
  input = parse_input(read_input)

  # code to run part 1 and part 2
  puts priority_all(input)
  puts group_priority_all(input)
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
  input.split("\n")
end

SCORES = [*'a'..'z', *'A'..'Z'].each_with_index.each_with_object({}) do |(c, i), h|
  h[c] = i + 1
end
### CODE HERE ###
def priority(sack)
  l = sack.length / 2
  c1, c2 = sack[0...l], sack[l..-1]
  c = (c1.chars & c2.chars).first
  SCORES[c]
end

def priority_all(sacks)
  sacks.sum do |sack|
    priority(sack)
  end
end

def group_priority(group)
  c = (group[0].chars & group[1].chars & group[2].chars).first
  SCORES[c]
end

def group_priority_all(input)
  input = input.dup

  # find groups
  groups = []
  while input.length > 0
    first = input.shift
    second, third = input.permutation(2).find do |second, third|
      (first.chars & second.chars & third.chars).length == 1
    end
    groups << [first, second, third]
    input.delete(second)
    input.delete(third)
  end
  groups.sum do |group|
    group_priority(group)
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
    expect(priority(input[0])).to eq 16
    expect(priority(input[1])).to eq 38
    expect(priority(input[2])).to eq 42
    expect(priority(input[3])).to eq 22
    expect(priority(input[4])).to eq 20
    expect(priority(input[5])).to eq 19
    expect(priority_all(input)).to eq 157
  end

  it "should solve part 2" do
    expect(group_priority(input[0..2])).to eq 18
    expect(group_priority(input[3..5])).to eq 52
    expect(group_priority_all(input)).to eq 70
  end
end

run if $PROGRAM_NAME == __FILE__ || $PROGRAM_NAME.end_with?("ruby-memory-profiler")
