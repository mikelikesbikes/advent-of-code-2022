def run
  input = parse_input(read_input)

  # code to run part 1 and part 2
  puts input.pruneable_sizes
  puts input.find_prune_candidate.dir_size
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
  root = ElfDir.new(nil, "/", [], [])
  cwd = root
  input.split("\n").each do |line|
    args = line.split(" ")
    if args[0] == "$"
      if args[1] == "cd"
        if args[2] == ".."
          cwd = cwd.parent
        else
          cwd = cwd.find_dir(args[2])
        end
      end
    elsif args[0] == "dir"
      cwd.add_dir(ElfDir.new(cwd, args[1], [], []))
    else
      cwd.add_file(ElfFile.new(args[1], args[0].to_i))
    end
  end
  root
end

### CODE HERE ###
ElfDir = Struct.new(:parent, :name, :dirs, :files) do
  def add_file(file)
    files << file
  end

  def add_dir(dir)
    dirs << dir
  end

  def find_dir(name)
    if name == "/"
      return self unless self.parent
      return self.parent.find_dir(name)
    end

    dirs.find { |dir| dir.name == name }
  end

  def dir_size
    @dir_size ||= dirs.sum { |d| d.dir_size } + files.sum(&:size)
  end

  def flat_dirs
    [self].concat(dirs.flat_map { |d| d.flat_dirs })
  end

  def pruneable_sizes
    flat_dirs.select { |d| d.dir_size <= 100000 }.sum(&:dir_size)
  end

  def find_prune_candidate
    free = 70000000 - dir_size
    needed = 30000000 - free

    flat_dirs.select { |d| d.dir_size >= needed }.min_by(&:dir_size)
  end
end
ElfFile = Struct.new(:name, :size)

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
    expect(input.dir_size).to eq 48381165
    expect(input.pruneable_sizes).to eq 95437
  end

  it "should solve part 2" do
    expect(input.find_prune_candidate.dir_size).to eq 24933642
  end
end

run if $PROGRAM_NAME == __FILE__ || $PROGRAM_NAME.end_with?("ruby-memory-profiler")
