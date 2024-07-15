local M = {}

local subst_counter = 0
local RegexUtil = require("numbsub.regex_util")

local function reset_counters()
	subst_counter = 0
end

-- Function to pad number with zeros to specified width
local function zero_pad(num, width, exclude_sign)
	local num_str = tostring(math.abs(num))
	local num_len = #num_str

	if width then
		local pad_width = width - num_len
		local prefix = ""

		if num < 0 then
			prefix = "-"
			pad_width = pad_width - 1 -- Account for the negative sign
		end

		if exclude_sign then
			prefix = "" -- Exclude sign, so no need to add it back
			if num < 0 then
				pad_width = width - num_len
				return "-" .. string.rep("0", pad_width) .. num_str
			else
				pad_width = width - num_len
				return string.rep("0", pad_width) .. num_str
			end
		else
			return prefix .. string.rep("0", pad_width) .. num_str
		end
	else
		return tostring(num)
	end
end

function subst_num(start, step_value, n, current_value, mode, width, max_subst_counter, exclude_sign)
	local result_value

	if mode == "ms" then
		result_value = zero_pad(start + (math.floor(subst_counter / n) * step_value), width, exclude_sign)
	elseif mode == "ma" then
		result_value = zero_pad(current_value + step_value, width, exclude_sign)
		zero_pad(start + current_value + (math.floor(subst_counter / n) * step_value), width, exclude_sign)
	elseif mode == "mp" then
		result_value =
			zero_pad(start + current_value + (math.floor(subst_counter / n) * step_value), width, exclude_sign)
	elseif mode == "mr" or mode == "mR" then
		local max_value = start + (max_subst_counter * step_value)
		local decrement_step = math.floor(subst_counter / n) * step_value
		result_value = zero_pad(max_value - decrement_step, width, exclude_sign)
	else
		error("Invalid mode. Use 'ms', 'ma', 'mp', 'mr' or 'mR'.")
	end

	-- Increment the subst_counter
	subst_counter = subst_counter + 1

	return result_value
end

function M.subst_with_num(args)
	-- Initialize variables
	local start, pattern, n, step_value, mode, confirm, width, exclude_sign, auto_width

	-- Trim any leading or trailing whitespace
	args = args:match("^%s*(.-)%s*$")

	-- Parse arguments
	local parts = vim.split(args, "%s+") -- Split by any whitespace character sequence (%s+)
	for i = 1, #parts do
		local arg = parts[i]
		if arg:sub(1, 1) == "s" then
			start = tonumber(arg:sub(2))
		elseif arg:sub(1, 1) == "p" and i ~= #parts then
			pattern = arg:sub(2)
		elseif arg:sub(1, 1) == "n" then
			n = math.abs(tonumber(arg:sub(2))) -- Ensure n is always positive
			if n == 0 then
				print("n should not be zero.")
				return
			end
		elseif arg:sub(1, 1) == "S" then
			step_value = tonumber(arg:sub(2))
			if step_value == nil then
				print("Invalid step value:", arg:sub(2))
				return
			end
			if step_value > 0 then
				mode = "ms"
			elseif step_value < 0 then
				mode = "mp"
			else
				print("Step value should not be zero.")
				return
			end
		elseif arg:sub(1, 1) == "w" then
			if arg:len() > 1 then
				width = tonumber(arg:sub(2))
				exclude_sign = true
			else
				auto_width = true
				exclude_sign = true
			end
		elseif arg:sub(1, 1) == "W" then
			if arg:len() > 1 then
				width = tonumber(arg:sub(2))
				exclude_sign = false
			else
				auto_width = true
				exclude_sign = false
			end
		elseif arg:match("^m[saprR]$") then
			mode = arg -- Assign the mode directly (ms, ma, mp, mr)
		elseif arg == "c" then
			confirm = "c"
		else
			print("Invalid argument:", arg)
			return
		end
	end

	-- Validate parsed arguments
	if pattern == nil or mode == nil then
		print(
			"Invalid arguments. Usage: :NumbSub p<pattern> m<s|a|p|r|R> [s<start>] [n<count>] [S<step>] [w|W|w<width>|W<width>] [c]"
		)
		return
	end
	start = start or 0 -- Default start to 0 if not provided
	step_value = step_value or 1 -- Default step_value to 1 if not provided
	n = n or 1 -- Default n to 1 if not provided

	reset_counters()

	-- Count the total number of substitutions to calculate the correct starting point for mr and mR mode
	local total_matches = 0
	local lines = vim.fn.getline(1, "$")
	for _, line in ipairs(lines) do
		local matches = RegexUtil.get_vim_matches(pattern, line)
		total_matches = total_matches + #matches
	end

	-- Calculate max_subst_counter based on the mode
	local max_subst_counter
	if mode == "mr" then
		max_subst_counter = math.floor((total_matches - 1) / n)
	else
		max_subst_counter = math.floor(total_matches - 1)
	end

	if auto_width then
		local max_value, min_value, max_width
		-- Calculate the value after all substitutions
		if mode == "ma" or mode == "mp" then
			for _, line in ipairs(vim.fn.getline(1, "$")) do
				local matches = RegexUtil.get_vim_matches(pattern, line)
				for _, match in ipairs(matches) do
					local current_value = tonumber(match)
					local result_value = start + current_value + (math.floor(subst_counter / n) * step_value)
					if not max_value or result_value > max_value then
						max_value = result_value
					end
					if not min_value or result_value < min_value then
						min_value = result_value
					end
					subst_counter = subst_counter + 1
				end
			end
			reset_counters()
		else
			max_value = start + (max_subst_counter * step_value)
			min_value = start
			-- Adjust min_value if step_value is negative
			if step_value < 0 then
				min_value = start + (max_subst_counter * step_value)
			end
		end

		-- Calculate the maximum width needed for padding
		max_width = math.max(#tostring(math.abs(max_value)), #tostring(math.abs(min_value)))
		-- Adjust width to include sign if necessary
		if not exclude_sign and (max_value < 0 or min_value < 0) then
			max_width = max_width + 1 -- Add one for the negative sign
		end

		width = max_width
	end

	-- Define a helper function for the substitution
	_G.subst_with_num_helper = function()
		local current_value
		if mode == "ma" or mode == "mp" then
			local current_value_str = vim.fn.matchstr(vim.fn.submatch(0), "-\\?\\d\\+")
			if current_value_str == "" then
				error("No numeric value found in the match")
			end
			current_value = tonumber(current_value_str)
			if current_value == nil then
				error("Failed to convert the matched value to a number")
			end
		else
			current_value = start
		end

		return subst_num(start, step_value, n, current_value, mode, width, max_subst_counter, exclude_sign)
	end

	-- Construct the Vim command for substitution
	local cmd = string.format(
		"%%s/\\(%s\\)/\\=v:lua._G.subst_with_num_helper()/g" .. (confirm ~= "" and confirm or ""),
		pattern
	)
	vim.cmd(cmd)
end

return M
