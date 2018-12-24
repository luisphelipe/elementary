# CONTROLERS
RULE          = 90
$ARRAY_LENGTH = 164
$SLEEP_TIME   = 0.05
$DOT          = '■'
$SPACE        = ' '


# unecessary to_bin implementarion :^)
def to_binary_string(int)
    binary = 0
    index = 1

    while int > 0 do
        binary += (int % 2) * index 
        index  *= 10
        int    /= 2
    end

    "%08d" % binary.to_s
end

# compute current cell state
def compute_with_rulestring(array, rulestring)
    array.each_with_index.map { |value, index| 
        # left and current cell values, converted from binary
        cell_state = (1 - array[index-1]) * 4 + (1 - value) * 2

        # right cell value, thernary check for end of array
        cell_state += 1 - (index == array.length() - 1 ? array[0] : array[index+1])

        # returns current cell state, based on choosen rulestring
        rulestring[cell_state].to_i        
    }
end

# parse array into printable string
def parse_string(array)
    array = array.map { |item|
        item == 1 ? $DOT : $SPACE
    }.join('')
end

def main
    # Generate initial array
    array = Array.new($ARRAY_LENGTH, 0);

    ## Random initial state
    # array.map! { 
    #     Random.rand(2)
    # }    
    
    # Some rules require specific initial state, below is for sierpinski (rule 90)
    array[$ARRAY_LENGTH/2 - 1] = 1

    choosen_rule = to_binary_string(RULE)

    while true do
        puts parse_string array
        array = compute_with_rulestring array, choosen_rule
        sleep($SLEEP_TIME)
    end
end

main
