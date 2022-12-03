def run
  input = parse_input(read_input)

  # code to run part 1 and part 2
  puts score(input, method(:score_round))
  puts score(input, method(:score_round2))
end

def read_input(filename = "input.txt")
  if !STDIN.tty?
    ARGF.read
  else
    filename = File.expand_path(ARGV[0] || filename, __dir__)
    File.read(filename)
  end
end

RPS = {
  "A" => :rock,
  "B" => :paper,
  "C" => :scissors,
  "X" => :rock,
  "Y" => :paper,
  "Z" => :scissors
}
def parse_input(input)
  input.split("\n").map do |line|
    elf_throw, strategy = line.split(" ")
    [RPS[elf_throw], strategy]
  end
end

### CODE HERE ###
SCORE_SHAPE = {
  rock:     1,
  paper:    2,
  scissors: 3
}

LOSETO = {
  rock: :paper,
  paper: :scissors,
  scissors: :rock
}

def score_round(a, b)
  b = RPS[b]
  if a == b then SCORE_SHAPE[b] + 3
  elsif b == LOSETO[a] then SCORE_SHAPE[b] + 6
  else SCORE_SHAPE[b]
  end
end

def score_round2(a, b)
  case b
  when "X" then ((SCORE_SHAPE[a] + 1) % 3) + 1
  when "Y" then SCORE_SHAPE[a] + 3
  when "Z" then (SCORE_SHAPE[a] % 3) + 1 + 6
  end
end

def score(input, f)
  input.sum { |throws| f.call(*throws) }
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
    expect(score_round(:rock, "Y")).to eq 8
    expect(score_round(:paper, "X")).to eq 1
    expect(score_round(:scissors, "Z")).to eq 6

    expect(score(input, method(:score_round))).to eq 15
    expect(score(actual_input, method(:score_round))).to eq 12156
  end

  it "should solve part 2" do
    expect(score_round2(:rock, "Y")).to eq 4
    expect(score_round2(:paper, "X")).to eq 1
    expect(score_round2(:scissors, "Z")).to eq 7

    expect(score(input, method(:score_round2))).to eq 12
    expect(score(actual_input, method(:score_round2))).to eq 10835
  end
end

run if $PROGRAM_NAME == __FILE__ || $PROGRAM_NAME.end_with?("ruby-memory-profiler")
