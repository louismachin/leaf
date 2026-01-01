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
        puts "load_branches\t#{@dir}"
        Dir[@dir + '/*/*.branch'].each do |filepath|
            @branches << Branch.new(filepath)
        end
    end

    def load_leaves
        puts "load_leaves\t#{@dir}"
        Dir[@dir + '/*.tree'].each do |filepath|
            @leaves << Leaf.new(filepath)
        end
        Dir[@dir + '/*.branch'].each do |filepath|
            @leaves << Leaf.new(filepath)
        end
        Dir[@dir + '/*.leaf'].each do |filepath|
            @leaves << Leaf.new(filepath)
        end
    end

    def find(id)
        return find_branch(id) if id.end_with?('.branch')
        return find_leaf(id) if id.end_with?('.leaf')
    end

    def find_branch(id)
        @branches.each do |branch|
            return branch if [
                branch.id == id,
            #   branch.id + '.branch' == id,
            #   branch.id == id + '.branch',
            ].any?
        end
        return nil
    end

    def find_leaf(id)
        @leaves.each do |leaf|
            puts "find_leaf\t#{leaf.id} <=> #{id}"
            return leaf if [
                leaf.id == id,
            #   leaf.id + '.leaf' == id,
            #   leaf.id == id + '.leaf',
            ].any?
        end
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