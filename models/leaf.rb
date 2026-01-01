ATTR_START = '---'
ATTR_END = '---'
ARRAY_ATTRS = ['tags']
TAG_INDICATOR = '#'

class Leaf
    def initialize(filepath)
        @filepath = filepath
        begin
            load_from_file(filepath)
        rescue => error
            puts error
            self.reset
        end
    end

    def reset
        @raw = []
        @body = []
        @attributes = {}
    end

    def load_from_file(filepath)
        self.reset
        @raw = File.readlines(filepath).map(&:chomp)
        if self.has_frontmatter?
            ix, eof, key_values = 1, @raw.length, []
            until (ix >= eof) || (@raw[ix] == ATTR_END)
                @raw[ix].inspect
                key_values << @raw[ix].split(': ', 2)
                ix += 1
            end
            ix += 1 until (@raw[ix] != ATTR_END) && (@raw[ix] != '')
            @body = @raw[ix..-1]
            @attributes = {}
            key_values.each { |key, value| set_attr(key, value, false) }
        else
            @body = @raw
            @attributes = {}
            set_attr('title', 'untitled')
        end
        return true
    end

    def save_to_file(filepath = nil)
        filepath = @filepath unless filepath
        output = []
        output << ATTR_START
        @attributes.keys.each do |key|
            output << "#{key}: #{get_attr(key)}"
        end
        output << ATTR_END
        output += @body
        File.write(filepath, output.join("\n"))
    end

    def set_attr(key, value, and_save = true)
        if ARRAY_ATTRS.include?(key)
            @attributes[key] = value.split(' ')
        else
            @attributes[key] = value
        end
        save_to_file if and_save
    end

    def get_attr(key) # => returns string
        value = @attributes[key]
        return '' unless value
        return value.join(' ') if ARRAY_ATTRS.include?(key)
        return value
    end

    def tags
        return [] unless @attributes.key?('tags')
        return @attributes['tags']
    end

    def has_tag?(tag)
        tag = TAG_INDICATOR + tag unless tag[0] == TAG_INDICATOR
        return self.tags.include?(tag)
    end

    def has_frontmatter?
        return @raw.first == ATTR_END
    end

    def has_attributes?
        return !@attributes.empty?
    end

    def debug
        return [
            "attr=#{@attributes.inspect}",
            "body=#{@body.inspect}"
        ]
    end
end