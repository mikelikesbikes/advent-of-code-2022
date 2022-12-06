def run
  input = parse_input(read_input)

  # code to run part 1 and part 2
  puts detect_start(input)
  puts detect_start_message(input)
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
def detect_start(s)
  i = 0
  while s[i, 4].chars.uniq.length != 4
    i += 1
  end
  i + 4
end

def detect_start_message(s)
  i = 0
  while s[i, 14].chars.uniq.length != 14
    i += 1
  end
  i + 14
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
    expect(detect_start("mjqjpqmgbljsphdztnvjfqwrcgsmlb")).to eq 7
    expect(detect_start("bvwbjplbgvbhsrlpgdmjqwftvncz")).to eq 5
    expect(detect_start("nppdvjthqldpwncqszvftbrmjlhg")).to eq 6
    expect(detect_start("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")).to eq 10
    expect(detect_start("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")).to eq 11
  end

  it "should solve part 2" do
    expect(detect_start_message("mjqjpqmgbljsphdztnvjfqwrcgsmlb")).to eq 19
    expect(detect_start_message("bvwbjplbgvbhsrlpgdmjqwftvncz")).to eq 23
    expect(detect_start_message("nppdvjthqldpwncqszvftbrmjlhg")).to eq 23
    expect(detect_start_message("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg")).to eq 29
    expect(detect_start_message("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw")).to eq 26
  end
end

run if $PROGRAM_NAME == __FILE__ || $PROGRAM_NAME.end_with?("ruby-memory-profiler")
