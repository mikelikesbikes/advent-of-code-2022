def run
  input = parse_input(read_input)

  # code to run part 1 and part 2
  puts input.visible
  puts input.max_scenic_score
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
  grid = input.split("\n").map do |line|
    line.chars.map(&:to_i)
  end
  Forest.build(grid)
end

Forest = Struct.new(:grid) do
  def self.build(grid)
    new(grid)
  end

  def minx; 0; end
  def maxx; @maxx ||= grid[0].length - 1; end
  def miny; 0; end
  def maxy; @maxy ||= grid.length - 1; end

  def grid_at(x, y)
    grid[y][x]
  end

  def visible
    visible = 0
    grid.each_with_index do |row, y|
      row.each_with_index do |tree, x|
        if visible_left_at?(x, y) ||
           visible_up_at?(x, y) ||
           visible_right_at?(x, y) ||
           visible_down_at?(x, y)
          visible += 1
        end
      end
    end
    visible
  end

  def visible_left_at?(x, y)
    minx.upto(x - 1).all? do |x2|
      grid_at(x2, y) < grid_at(x, y)
    end
  end

  def visible_up_at?(x, y)
    miny.upto(y - 1).all? do |y2|
      grid_at(x, y2) < grid_at(x, y)
    end
  end

  def visible_right_at?(x, y)
    (x + 1).upto(maxx).all? do |x2|
      grid_at(x2, y) < grid_at(x, y)
    end
  end

  def visible_down_at?(x, y)
    (y + 1).upto(maxy).all? do |y2|
      grid_at(x, y2) < grid_at(x, y)
    end
  end

  def max_scenic_score
    scenic_score = 0
    grid.each_with_index do |row, y|
      row.each_with_index do |tree, x|
        ss = scenic_score_at(x, y)
        scenic_score = ss if ss > scenic_score
      end
    end
    scenic_score
  end

  def blocked_distance_left(x, y)
    return 0 if x == minx
    d = 1
    d += 1 while grid_at(x - d, y) < grid_at(x, y) && (x - d) > minx
    d
  end

  def blocked_distance_right(x, y)
    return 0 if x == maxx
    d = 1
    d += 1 while grid_at(x + d, y) < grid_at(x, y) && (x + d) < maxx
    d
  end

  def blocked_distance_up(x, y)
    return 0 if y == miny
    d = 1
    d += 1 while grid_at(x, y - d) < grid_at(x, y) && (y - d) > miny
    d
  end

  def blocked_distance_down(x, y)
    return 0 if y == maxy
    d = 1
    d += 1 while grid_at(x, y + d) < grid_at(x, y) && (y + d) < maxy
    d
  end

  def scenic_score_at(x, y)
    blocked_distance_left(x, y) *
      blocked_distance_up(x, y) *
      blocked_distance_right(x, y) *
      blocked_distance_down(x, y)
  end
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
    expect(input.visible).to eq 21
  end

  it "should solve part 2" do
    expect(input.scenic_score_at(2, 1)).to eq 4
    expect(input.scenic_score_at(2, 3)).to eq 8
    expect(input.max_scenic_score).to eq 8
  end
end

run if $PROGRAM_NAME == __FILE__ || $PROGRAM_NAME.end_with?("ruby-memory-profiler")
