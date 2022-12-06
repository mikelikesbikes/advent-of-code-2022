def run
  input = parse_input(read_input)

  # code to run part 1 and part 2
  puts detect_start(input, 4)
  puts detect_start(input, 14)
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
  input
end

### CODE HERE ###
def detect_start(s, n)
  i = 0
  i += 1 until s[i, n].match? /^(?:([a-z])(?!.*\1))*$/
  i + n
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
    expect(detect_start("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 4)).to eq 7
    expect(detect_start("bvwbjplbgvbhsrlpgdmjqwftvncz", 4)).to eq 5
    expect(detect_start("nppdvjthqldpwncqszvftbrmjlhg", 4)).to eq 6
    expect(detect_start("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 4)).to eq 10
    expect(detect_start("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 4)).to eq 11
  end

  it "should solve part 2" do
    expect(detect_start("mjqjpqmgbljsphdztnvjfqwrcgsmlb", 14)).to eq 19
    expect(detect_start("bvwbjplbgvbhsrlpgdmjqwftvncz", 14)).to eq 23
    expect(detect_start("nppdvjthqldpwncqszvftbrmjlhg", 14)).to eq 23
    expect(detect_start("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 14)).to eq 29
    expect(detect_start("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 14)).to eq 26
  end
end

run if $PROGRAM_NAME == __FILE__ || $PROGRAM_NAME.end_with?("ruby-memory-profiler")
