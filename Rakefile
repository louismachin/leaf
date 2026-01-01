task :old do
    Dir['./tests/*.leaf'].each do |filepath|
        puts "Inspecting \"#{filepath}\""
        leaf = Leaf.new(filepath)
        puts leaf.debug
    end
end

require './models/leaf.rb'
require './models/branch.rb'
require './models/tree.rb'

task :test do
    Dir['./forest/*/*.tree'].each do |filepath|
        puts "filepath=#{filepath}"
        tree = Tree.new(filepath)
        puts tree.debug
    end
end
