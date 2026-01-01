ATTR_START = '---'
ATTR_END = '---'
ARRAY_ATTRS = ['tags']

class Ink
    def initialize(filepath)
        @filepath = filepath
        load_from_file(filepath)
    end

    def load_from_file(filepath)
        @raw = File.readlines(filepath).map(&:chomp)
        @attributes = {}
        if @raw.first == ATTR_START
            ix = 1
            key_values = []
            until @raw[ix] == ATTR_END
                key_values << @raw[ix].split(': ')
                ix += 1
            end
            until (@raw[ix] != ATTR_END) && (@raw[ix] != '')
                ix += 1
            end
            @body = @raw[ix..-1]
            key_values.each do |key, value|
                set_attr(key, value, false)
            end
        else
            @body = @raw
            set_attr('title', 'untitled')
        end
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

    def debug
        return [@attributes.inspect, @body.inspect]
    end
end