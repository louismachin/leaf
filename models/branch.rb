class Branch < Leaf
    attr_reader :branches, :leaves

    def initialize(filepath)
        super
        @dir = File.dirname(filepath)
        @branches = []
        @leaves = []
        load_branches
        load_leaves
    end

    def load_branches
        Dir[@dir + '/*/*.branch'].each do |filepath|
            @branches << Branch.new(filepath)
        end
    end

    def load_leaves
        Dir[@dir + '/*.*'].each do |filepath|
            @leaves << Leaf.new(filepath)
        end
    end

    def find(id)
        return find_branch(id) if id.end_with?('.branch')
        return find_leaf(id) if id.end_with?('.leaf')
    end

    def find_branch(id)
        @branches.each { |branch| return branch if branch.id == id }
        return nil
    end

    def find_leaf(id)
        @leaves.each { |leaf| return leaf if leaf.id == id }
        return nil
    end

    def debug
        return [
            "branch=\"#{self.title}\" #{@filepath}",
            @branches.map { |branch| branch.debug },
            @leaves.map { |leaf| leaf.debug },
        ]
    end
end