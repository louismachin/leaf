class Forest < Tree
    attr_reader :trees

    def initialize(filepath = './forest')
        super
        @dir = filepath if Dir.exist?(filepath)
        @trees = []
        load_trees
    end

    def load_trees
        Dir[@dir + '/*/*.tree'].each do |filepath|
            @trees << Tree.new(filepath)
        end
    end

    def load_leaves
        Dir[@dir + '/*/*.tree'].each do |filepath|
            @leaves << Leaf.new(filepath)
        end
        Dir[@dir + '/*/*.branch'].each do |filepath|
            @leaves << Leaf.new(filepath)
        end
        Dir[@dir + '/*/*.leaf'].each do |filepath|
            @leaves << Leaf.new(filepath)
        end
    end

    def find(id)
        return find_tree(id) if id.end_with?('.tree')
        return find_branch(id) if id.end_with?('.branch')
        return find_leaf(id) if id.end_with?('.leaf')
    end

    def find_tree(id)
        @trees.each { |tree| return tree if tree.id == id }
        return nil
    end

    def debug
        return [
            "forest=\"#{self.title}\" (#{@filepath})",
            @trees.map { |branch| branch.debug },
            @branches.map { |branch| branch.debug },
            @leaves.map { |leaf| leaf.debug },
        ]
    end
end