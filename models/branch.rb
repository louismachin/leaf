class Branch < Leaf
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
        Dir[@dir + '/*/*.leaf'].each do |filepath|
            @leaves << Leaf.new(filepath)
        end
    end

    def debug
        return [
            "branch=\"#{self.title}\" #{@filepath}",
            @branches.map { |branch| branch.debug },
            @leaves.map { |leaf| leaf.debug },
        ]
    end
end