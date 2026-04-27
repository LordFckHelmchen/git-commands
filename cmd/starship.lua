local function load_starship_prompt()
	local handle = io.popen("starship init cmd")
	if not handle then
		return
	end

	local script = handle:read("*a")
	handle:close()
	if script and script ~= "" then
		load(script)()
	end
end

local function trim(text)
	return (text:gsub("^%s+", ""):gsub("%s+$", ""))
end

local function load_doskey_macrofile(path)
	if not os.isfile or not os.setalias then
		print("warning: os.isfile or os.setalias not available")
		return
	end

	if not os.isfile(path) then
		print("warning: doskey macro file not found: " .. path)
		return
	end

	local f = io.open(path, "r")
	if not f then
		print("warning: could not open doskey macro file: " .. path)
		return
	end

	local count = 0
	for line in f:lines() do
		local alias_name, alias_cmd = line:match("^%s*[dD][oO][sS][kK][eE][yY]%s+([^=]+)=(.*)$")
		if alias_name and alias_cmd then
			alias_name = trim(alias_name)
			alias_cmd = trim(alias_cmd)
			if alias_name ~= "" and alias_cmd ~= "" then
				local success = os.setalias(alias_name, alias_cmd)
				if not success then
					print("warning: failed to set alias '" .. alias_name .. "' = '" .. alias_cmd .. "'")
				else
					count = count + 1
				end
			end
		end
	end

	f:close()
	print("info: loaded " .. count .. " aliases from " .. path)
end

local function load_aliases_once()
	local macrofile = os.getenv("CLINK_ALIASES_FILE")
	if macrofile and macrofile ~= "" then
		macrofile = path.normalise(macrofile)
		load_doskey_macrofile(macrofile)
		return
	end

	local home_dir = os.getenv("USERPROFILE")
	if not home_dir or home_dir == "" then
		print("warning: USERPROFILE environment variable not set")
		return
	end

	-- Read from ~/Git/git-commands/cmd/clink_aliases.cmd
	local macrofile = home_dir .. "\\Git\\git-commands\\cmd\\clink_aliases.cmd"
	macrofile = path.normalise(macrofile)
	load_doskey_macrofile(macrofile)
end

load_starship_prompt()

if clink and clink.oninject then
	clink.oninject(load_aliases_once)
else
	load_aliases_once()
end
