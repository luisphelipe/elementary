def to_binary_string(int)
    binary = 0
    index = 1

    while int > 0 do
        binary = binary + (int % 2) * index 
        index  = index * 10
        int    = int / 2
    end

    "%08d" % binary.to_s
end

# Some interesting rulestrings
RULE    = 110
rule22  = '00010110'
rule30  = '00011110'

# CONTROLERS
$CHOOSEN_RULE = to_binary_string(RULE)
# $CHOOSEN_RULE = rule22  
$ARRAY_LENGTH = 164
$SLEEP_TIME = 0.07
$DOT = '■'
$SPACE = ' '

# Expanded structure for verifying rule
$BASE_SET = {
    [true  ,true  ,true ] => nil, 
    [true  ,true  ,false] => nil, 
    [true  ,false ,true ] => nil, 
    [true  ,false ,false] => nil, 
    [false ,true  ,true ] => nil,
    [false ,true  ,false] => nil,
    [false ,false ,true ] => nil,
    [false ,false ,false] => nil
}

def parse_rule(rule, base)
    rule_set = base.clone()

    rule_set.each_with_index { |(key, value), index| 
        if rule[index] == '1'
            rule_set[key] = true
        else
            rule_set[key] = false    
        end
    } 

    rule_set
end

## This was how I implemented in the beggining
# def compute_rule_30(array)
#     array.each_with_index.map { |value, index| 
#         # Below is the rule30 formula
#         if index == array.length-1
#             array[index-1] ^ (value | array[0])
#         else
#             array[index-1] ^ (value | array[index+1])
#         end
#     }
# end

# Then i tried to make it run any rule, given a ruleset
def compute_with_ruleset(array, ruleset)
    array.each_with_index.map { |value, index| 
        if index == array.length-1
            cell_state = [array[index-1], value, array[0]]
        else
            cell_state = [array[index-1], value, array[index+1]]
        end

        ruleset[cell_state]        
    }
end

def parse_string(array)
    array = array.map { |item|
        item ? $DOT : $SPACE
    }.join('')
end

def main
    # Generate initial array with random booleans
    array = Array.new($ARRAY_LENGTH);
    array.map! { 
        if Random.rand(2) == 1
            true
        else
            false
        end
    }

    rule_set = parse_rule $CHOOSEN_RULE, $BASE_SET

    # compute_with_ruleset
    while true do
        puts parse_string array
        array = compute_with_ruleset array, rule_set
        sleep($SLEEP_TIME)
    end

    ## compute_rule_30, uncoment the method for it to work
    # while true do
    #     puts parse_string array
    #     array = compute_rule_30 array
    #     sleep(SLEEP_TIME)
    # end
end

main
