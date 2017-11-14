class Graph

    def initialize(vertices)
      @vertices = vertices
      @graph = {}
      @all_paths = []
    end

    # function to add an edge to graph
    def add_edge(u,v)
      if @graph.has_key?(u)
        @graph[u] << v
      else
        @graph[u] = [v]
      end
      @graph[u].uniq!
    end

    # A recursive helper function to find all paths from 'u' to 'd'.
    def all_paths_util(u, d)
      # Mark the current node as visited and store in path
      @visited[u] = true
      @path << u

      # If current vertex is same as destination, then store it
      # current path[]
      if u == d
        @all_paths << @path.dup
      else
        # If current vertex is not destination
        # Recur for all the vertices adjacent to this vertex
        @graph[u].each do |i|
          if @visited[i] == false
            all_paths_util(i, d)
           end
         end
      end
      # Remove current vertex from path[] and mark it as unvisited
      @path.pop()
      @visited[u]= false
    end

    # Find all paths from 's' to 'd'
    # retun array of arrays containing all possible paths
    def find_all_paths(s, d)
      # Mark all the vertices as not visited
      @visited = [false] * @vertices

      @path = []

      # Call the recursive helper function to find all paths
      all_paths_util(s, d)

      return @all_paths.uniq
    end

end
