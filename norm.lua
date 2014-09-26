norm = {
	modename = "Normal",

	cursor = cursor_uno,
	keys = {
		up = "up",
		down = "down",
		left = "left",
		right = "right",
		delete = "backspace",
		newline = "return",
		command_enter = "return",
		command_get = "escape"
	}
}

function norm:onload()
end

function norm:keypress(key, is_repeat)
	local c = norm.cursor
	if key == m.keys.command_get then
		command_input = ""
		command_mode = true
	elseif key == m.keys.delete and #lines >= 1 then
		editor:delete_char(c)
	elseif key == m.keys.newline then
		editor:newline(c)
	elseif key == m.keys.right then
		editor:move_right(c)
	elseif key == m.keys.down then
		editor:move_down(c)
	elseif key == m.keys.up then
		editor:move_up(c)
	elseif key == m.keys.left then
		editor:move_left(c)
	end
end

function norm:command_mode(key, is_repeat)
end

function norm:command_enter(s)
	if s:sub(1, 6) == "write " then
		editor:save_file(s:sub(7))
		return nil
	elseif s:sub(1, 5) == "edit " then
		editor:open_file(s:sub(6))
		return nil
	elseif s:sub(1, 4) == "quit" then
		editor:close()
		return nil
	end
	return true
end

function norm:textin(key)
	local c = norm.cursor
	if command_mode == false then
		editor:insert(c, key)
	end
end

function norm:draw()
	local c = norm.cursor
	local i = 10
	local inc = 20
	local lineno = 1
	for each, l in pairs(lines) do
		love.graphics.print(lineno .. "  ", 10, i)

		if each == c.line then
			love.graphics.print(l:sub(1, c.column-1) 
								.. "|"
								..lines[c.line]:sub(c.column),
								40, i)
		else
			love.graphics.print(l, 40, i)
		end
		i = i + inc
		lineno = lineno + 1
	end
	love.graphics.print("Line: " .. c.line, 20, screen_height-50)
	love.graphics.print("Column: " .. c.column, 120, screen_height-50)
	love.graphics.print("Max lines: " .. #lines, 260, screen_height-50)
	if command_mode == true then
		love.graphics.print(">> " .. command_input .. "|", 10, screen_height-30)
	else 
		love.graphics.print(command_input, 10, screen_height-30)
	end
end