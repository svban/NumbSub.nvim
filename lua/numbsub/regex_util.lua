local RegexUtil = {}

-- Function to get all matches for a Vim regex in the given text
function RegexUtil.get_vim_matches(pattern, text)
    local matches = {}
    local start_idx = 0 -- Use 0-based indexing for matchstrpos

    while true do
        local match_info = vim.fn.matchstrpos(text, pattern, start_idx)
        local start_pos = match_info[2]
        local end_pos = match_info[3]
        if start_pos == -1 then
            break
        end

        local match = string.sub(text, start_pos + 1, end_pos)
        table.insert(matches, match)
        start_idx = end_pos + 1
    end

    return matches
end

return RegexUtil
