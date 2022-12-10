require "set"

def run
  input = parse_input(read_input)

  # code to run part 1 and part 2
  rope = Rope.build(2, input)
  rope.simulate
  puts rope.tail_positions.length

  rope = Rope.build(10, input)
  rope.simulate
  puts rope.tail_positions.length
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
    dir, n = line.split(" ")
    [dir, n.to_i]
  end
end

### CODE HERE ###
Rope = Struct.new(:instructions, :knots, :tail_positions) do
  def self.build(n, instructions)
    knots = Array.new(n) { [0, 0] }
    new(instructions, knots, Set.new([knots[-1].dup]))
  end

  def simulate
    instructions.each do |dir, n|
      n.times do
        # update head
        dxdy = case dir
        when "R" then knots[0][0] += 1
        when "D" then knots[0][1] += 1
        when "U" then knots[0][1] -= 1
        when "L" then knots[0][0] -= 1
        end

        # update knots
        0.upto(knots.length - 2) do |i|
          dist = [knots[i][0] - knots[i+1][0], knots[i][1] - knots[i+1][1]]
          if dist[0].abs > 1 || dist[1].abs > 1
            dist = dist.map do |d|
              if d < 0 then -1
              elsif d > 0 then 1
              else 0
              end
            end
            knots[i+1][0] += dist[0]
            knots[i+1][1] += dist[1]
          end
        end

        # insert tail
        tail_positions << knots[-1].dup
      end
    end
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
    rope = Rope.build(2, input)
    expect { rope.simulate }.to change { rope.tail_positions.length }.to(13)
  end

  it "should solve part 2" do
    rope = Rope.build(10, parse_input(<<~INPUT))
      R 5
      U 8
      L 8
      D 3
      R 17
      D 10
      L 25
      U 20
    INPUT
    expect { rope.simulate }.to change { rope.tail_positions.length }.to(36)
  end
end

run if $PROGRAM_NAME == __FILE__ || $PROGRAM_NAME.end_with?("ruby-memory-profiler")
