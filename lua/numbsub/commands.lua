local M = {}

local subst_counter = 0
local RegexUtil = require("numbsub.regex_util")

local function reset_counters()
	subst_counter = 0
end

-- Function to pad number with zeros to specified width or use format string
local function format_number(num, width, exclude_sign, fmt)
	if fmt then
		local ok, formatted = pcall(string.format, fmt, num)
		if ok then
			return formatted
		else
			print("Invalid format string:", fmt)
			return tostring(num)
		end
	end

	local num_str = tostring(math.abs(num))
	local num_len = #num_str

	if width then
		local pad_width = width - num_len
		local prefix = ""

		if num < 0 then
			prefix = "-"
			pad_width = pad_width - 1
		end

		if exclude_sign then
			prefix = ""
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

function Subst_num(
	start,
	step_value,
	n,
	current_value,
	mode,
	width,
	max_subst_counter,
	exclude_sign,
	loop_n,
	loop_total,
	format_string
)
	local result_value
	local raw_value

	if loop_n and subst_counter % (loop_n * n) == 0 and subst_counter ~= 0 then
		reset_counters()
	elseif loop_total and subst_counter % loop_total == 0 and subst_counter ~= 0 then
		reset_counters()
	end

	if mode == "ms" then
		raw_value = start + (math.floor(subst_counter / n) * step_value)
	elseif mode == "ma" then
		raw_value = current_value + step_value
	elseif mode == "mp" then
		raw_value = start + current_value + (math.floor(subst_counter / n) * step_value)
	elseif mode == "mr" or mode == "mR" then
		local max_value = start + (max_subst_counter * step_value)
		local decrement_step = math.floor(subst_counter / n) * step_value
		raw_value = max_value - decrement_step
	else
		error("Invalid mode. Use 'ms', 'ma', 'mp', 'mr' or 'mR'.")
	end

	subst_counter = subst_counter + 1
	return format_number(raw_value, width, exclude_sign, format_string)
end

function M.subst_with_num(args)
	local start, pattern, n, step_value, mode, confirm, width, exclude_sign, auto_width, loop_n, loop_total, format_string

	args = args:match("^%s*(.-)%s*$")
	local parts = vim.split(args, "%s+")
	for i = 1, #parts do
		local arg = parts[i]
		if arg:sub(1, 1) == "s" then
			start = tonumber(arg:sub(2))
		elseif arg:sub(1, 1) == "p" then
			pattern = arg:sub(2)
		elseif arg:sub(1, 1) == "n" then
			local num = tonumber(arg:sub(2))
			if not num then
				print("Invalid n value: " .. arg:sub(2))
				return
			end
			n = math.abs(num)
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
		elseif arg:sub(1, 1) == "l" then
			loop_n = tonumber(arg:sub(2))
			if not loop_n then
				print("Invalid loop count for l.")
				return
			end
		elseif arg:sub(1, 1) == "L" then
			loop_total = tonumber(arg:sub(2))
			if not loop_total then
				print("Invalid loop count for L.")
				return
			end
		elseif arg:sub(1, 4) == "fmt:" then
			format_string = arg:sub(5)
		elseif arg:match("^m[saprR]$") then
			mode = arg
		elseif arg == "c" then
			confirm = "c"
		else
			print("Invalid argument:", arg)
			return
		end
	end

	if pattern == nil or mode == nil then
		print(
			"Invalid arguments. Usage: :NumbSub p<pattern> m<s|a|p|r|R> [s<start>] [n<count>] [S<step>] [w|W|w<width>|W<width>] [l<loop>|L<loop>] [fmt:<format>] [c]"
		)
		return
	end

	start = start or 0
	step_value = step_value or 1
	n = n or 1
	reset_counters()

	local total_matches = 0
	for _, line in ipairs(vim.fn.getline(1, "$")) do
		total_matches = total_matches + #RegexUtil.get_vim_matches(pattern, line)
	end

	local max_subst_counter = (mode == "mr") and math.floor((total_matches - 1) / n) or (total_matches - 1)

	if auto_width and not format_string then
		local max_value, min_value
		local temp_counter = 0

		if mode == "ma" then
			for _, line in ipairs(vim.fn.getline(1, "$")) do
				for _, match in ipairs(RegexUtil.get_vim_matches(pattern, line)) do
					local current_value = tonumber(match)
					local result_value = current_value + step_value
					if not max_value or result_value > max_value then
						max_value = result_value
					end
					if not min_value or result_value < min_value then
						min_value = result_value
					end
				end
			end
		elseif mode == "mp" then
			for _, line in ipairs(vim.fn.getline(1, "$")) do
				for _, match in ipairs(RegexUtil.get_vim_matches(pattern, line)) do
					local current_value = tonumber(match)
					local result_value = start + current_value + (math.floor(temp_counter / n) * step_value)
					if not max_value or result_value > max_value then
						max_value = result_value
					end
					if not min_value or result_value < min_value then
						min_value = result_value
					end
					temp_counter = temp_counter + 1
				end
			end
		else
			local effective_steps = loop_n and (loop_n - 1)
				or loop_total and math.floor((loop_total - 1) / n)
				or math.floor((total_matches - 1) / n)
			if step_value >= 0 then
				max_value = start + (effective_steps * step_value)
				min_value = start
			else
				max_value = start
				min_value = start + (effective_steps * step_value)
			end
		end

		local digits_max = #tostring(math.abs(max_value))
		local digits_min = #tostring(math.abs(min_value))
		local has_negative = (max_value < 0 or min_value < 0)
		if digits_max <= 1 and digits_min <= 1 and not has_negative then
			width = nil
		else
			width = math.max(digits_max, digits_min)
			if not exclude_sign and has_negative then
				width = width + 1
			end
		end
	end

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

		return Subst_num(
			start,
			step_value,
			n,
			current_value,
			mode,
			width,
			max_subst_counter,
			exclude_sign,
			loop_n,
			loop_total,
			format_string
		)
	end

	local cmd = string.format(
		"%%s/\\(%s\\)/\\=v:lua._G.subst_with_num_helper()/g" .. (confirm ~= "" and confirm or ""),
		pattern
	)
	vim.cmd(cmd)
end

return M
