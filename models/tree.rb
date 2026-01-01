class Tree < Branch
    def initialize(filepath)
        super
    end

    def debug
        return [
            "tree=\"#{self.title}\" (#{@filepath})",
            @branches.map { |branch| branch.debug },
            @leaves.map { |leaf| leaf.debug },
        ]
    end
end