def run
  input = parse_input(read_input)

  # code to run part 1 and part 2
  puts [20, 60, 100, 140, 180, 220].map { |n| input.signal_strength(n) }.sum
  puts CRT.new(input).draw
end

def read_input(filename = "input.txt")
  if !STDIN.tty?
    ARGF.read
  else
    filename = File.expand_path(ARGV[0] || filename, __dir__)
    File.read(filename)
  end
end

Noop = Class.new
AddX = Struct.new(:value)
def parse_instruction(s)
  if s == "noop"
    Noop.new
  else
    AddX.new(s[5..-1].to_i)
  end
end

CPU = Struct.new(:values) do
  def self.build(instructions)
    values = instructions.flat_map do |ins|
      case ins
      when Noop then 0
      when AddX then [0, ins.value]
      end
    end
    values.unshift(1)
    new(values)
  end

  def x(n)
    values.take(n).sum
  end

  def signal_strength(n)
    x(n) * n
  end
end

class CRT
  attr_reader :cpu
  def initialize(cpu)
    @cpu = cpu
  end

  def draw
    (1..240).map do |n|
      sprite_pos = cpu.x(n)
      nm = ((n - 1) % 40) + 1
      nm >= sprite_pos && nm < (sprite_pos + 3) ? "#" : "."
    end.each_slice(40).map(&:join).join("\n")
  end
end

def parse_input(input)
  instructions = input.split("\n").map do |line|
    parse_instruction(line)
  end

  CPU.build(instructions)
end

### CODE HERE ###


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
    cpu = parse_input(<<~INSTRUCTIONS)
      noop
      addx 3
      addx -5
    INSTRUCTIONS

    expect(cpu.signal_strength(1)).to eq 1 * 1
    expect(cpu.signal_strength(2)).to eq 2 * 1
    expect(cpu.signal_strength(3)).to eq 3 * 1
    expect(cpu.signal_strength(4)).to eq 4 * 4
    expect(cpu.signal_strength(5)).to eq 5 * 4
    expect(cpu.signal_strength(6)).to eq 6 * -1

    expect(input.signal_strength(20)).to eq 420
    expect(input.signal_strength(60)).to eq 1140
    expect(input.signal_strength(100)).to eq 1800
    expect(input.signal_strength(140)).to eq 2940
    expect(input.signal_strength(180)).to eq 2880
    expect(input.signal_strength(220)).to eq 3960
  end

  it "should solve part 2" do
    expect(CRT.new(input).draw).to eq(<<~DISPLAY.chomp)
      ##..##..##..##..##..##..##..##..##..##..
      ###...###...###...###...###...###...###.
      ####....####....####....####....####....
      #####.....#####.....#####.....#####.....
      ######......######......######......####
      #######.......#######.......#######.....
    DISPLAY
  end
end

run if $PROGRAM_NAME == __FILE__ || $PROGRAM_NAME.end_with?("ruby-memory-profiler")
