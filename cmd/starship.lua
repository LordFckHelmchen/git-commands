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
		return
	end

	if not os.isfile(path) then
		return
	end

	local f = io.open(path, "r")
	if not f then
		return
	end

	for line in f:lines() do
		local alias_name, alias_cmd = line:match("^%s*[dD][oO][sS][kK][eE][yY]%s+([^=]+)=(.*)$")
		if alias_name and alias_cmd then
			alias_name = trim(alias_name)
			alias_cmd = trim(alias_cmd)
			if alias_name ~= "" and alias_cmd ~= "" then
				os.setalias(alias_name, alias_cmd)
			end
		end
	end

	f:close()
end

local function load_aliases_once()
	local macrofile = os.getenv("CLINK_ALIASES_FILE")
	if macrofile and macrofile ~= "" then
		macrofile = path.normalise(macrofile)
		load_doskey_macrofile(macrofile)
		return
	end

	local profile_dir = os.getenv("LOCALAPPDATA")
	if not profile_dir or profile_dir == "" then
		return
	end

	-- Uses your generated macro file from the git-commands repo.
	local macrofile = profile_dir .. "\\..\\..\\Git\\git-commands\\bash\\clink_aliases.cmd"
	macrofile = path.normalise(macrofile)
	load_doskey_macrofile(macrofile)
end

load_starship_prompt()

if clink and clink.oninject then
	clink.oninject(load_aliases_once)
else
	load_aliases_once()
end