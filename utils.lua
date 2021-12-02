local M = {}

local FILENAME = function(puzzle, suffix) return string.format("%d/%02d", puzzle.year, puzzle.day) .. suffix end
local EXAMPLE_FILENAME = function(puzzle) return FILENAME(puzzle, ".example") end
local INPUT_FILENAME = function(puzzle) return FILENAME(puzzle, ".input") end


function M.enable_string_indexing()
    getmetatable("").__index = function (str, key) return string.sub(str, key, key) end
end


function M.read_raw(filename)
    local file = assert(io.open(filename, "r"), "File not found")   
    local input = file:read("*all")
    file:close()

    return input
end


function M.read_lines(filename)
    local lines = {}
    for line in io.lines(filename) do
        table.insert(lines, line)
    end
    
    return lines
end


function M.read_groups(filename)
    local input = M.read_raw(filename)

    input = string.gsub(input, "\n\n", "\t")
    input = string.gsub(input, "\n", " ")

    groups = {}
    for line in string.gmatch(input, "[^\t]+") do
        table.insert(groups, line)
    end

    return groups
end


function M.parse_input(input, parse_line)
    local list = {}
    
    for _, line in ipairs(input) do
        local element = parse_line(line)
        assert(element)

        table.insert(list, element)
    end

    return list
end


function M.check(puzzle, func, expected_value, read_input)
    local example_input = read_input(EXAMPLE_FILENAME(puzzle))
    local result = func(example_input)
    assert(result == expected_value, 
        "Assertion failed, result is " .. tostring(result) .. ", expected " .. tostring(expected_value))
end


function M.run(puzzle, func, read_input)
    local input = read_input(INPUT_FILENAME(puzzle))
    print(func(input))
end

return M
