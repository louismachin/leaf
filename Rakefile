task :test do
    require './models/leaf.rb'
    Dir['./tests/*.leaf'].each do |filepath|
        puts "Inspecting \"#{filepath}\""
        leaf = Leaf.new(filepath)
        puts leaf.debug
    end
end