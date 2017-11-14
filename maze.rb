require_relative 'graph'

class Maze

  UP = 1
  RIGHT = 2
  DOWN = 4
  LEFT = 8
  START = 16
  EXIT = 32
  MINE = 64

  attr_reader :w, :h # width, height

  def initialize(maze)
    %r{\((?<size>.*)\)\-\[(?<structure>.*)\]} =~ maze
    @h, @w = size.split(',').map(&:to_i)
    @structure = structure.split(',').map(&:to_i)
    @wh = @w*@h
    @start = 0
    @exit = 0
    @neighbors_cache = {}
    @mines = []
    @graph = Graph.new(@h*@w)
    generate
  end

  def generate()
    @structure.each_with_index do |c, i|
      @mines << i if c & MINE > 0
      @start = i if c & START > 0
      @exit = i if c & EXIT > 0
      neighbors(i).each do |n|
        @graph.add_edge(i, n); @graph.add_edge(n, i);
      end
    end
    @graph
  end

  def solve()
    puts "-" * 30
    paths = @graph.find_all_paths(@start, @exit)
    # find a shortest path with less than 'lives - 1' mines
    winner = paths.select { |path| (path & @mines).size <= (@lives - 1) }.min_by{ |path| path.size } || []

    puts "From #{@start}:#{pos2coord(@start)} to #{@exit}:#{pos2coord(@exit)}"
    puts "Shortest path: #{winner}"
    puts "Shortest path directions: #{path_directions(winner)}"
    mineHits = howManyMineHits(winner)
    puts "Mine hits: #{mineHits.length}. Mine positions: #{ mineHits.map{|m| pos2coord(m) } }"
    puts "-" * 30
  end

  def withLives(value)
    @lives = value.to_i
    self
  end

  # maze positions are cell indices from 0 to w*h-1
  # the following functions do conversions to and from coordinates
  def coord2pos(x, y)
    (y % h)*w+(x % w)
  end

  def pos2coord(p)
    [p % w, (p/w) % h]
  end

  def inspect
    "#<#{self.class.name} #{w}x#{h}>"
  end

  # returns reachable neighbors for p
  def neighbors(p)
    if ce=@neighbors_cache[p]
      return ce
    end
    res = []
    bits = @structure[p]
    res << p-w if bits & UP > 0 # north
    res << p+w if bits & DOWN > 0 # south
    res << p-1 if p%w > 0 && bits & LEFT > 0 # west
    res << p+1 if p%w < w-1  && bits & RIGHT > 0 # east
    # select reachable neighbors
    @neighbors_cache[p] = res.find_all { |t| t>=0 && t<@wh }
  end

  # report how many mines in a path
  def howManyMineHits(path)
    path.select { |i| @structure[i] & MINE > 0 }
  end

  # transform path indexes to "driving" directions
  def path_directions(path)
    directions = []
    return directions if path.size < 2
    (0...path.size-1).each do |i|
      diff = path[i].to_i - path[i+1].to_i
      if diff.abs >= w
        if diff > 0
          directions << 'up'
        else
          directions << 'down'
        end
      else
        if diff < 0
          directions << 'right'
        else
          directions << 'left'
        end
      end
    end
    directions
  end
end
