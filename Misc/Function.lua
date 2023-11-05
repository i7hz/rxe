getgenv().rxe = getgenv().rxe or {};
function rxe.get(identity: table, file: string, folder: string)
    assert(identity, 'Please provide identity, must follow [name, repository, branch]')

    local web = "https://raw.githubusercontent.com"
    local collector = {web, identity.name, identity.repository, identity.branch}
    
    local folder = (folder and table.insert(collector, folder))
    local file = (file and table.insert(collector, file))
    local url = table.concat(collector, '/')

    local req = (syn and syn.request) or request or http.request or http_request;

    success, response = pcall(function()
        return req({Url = url, Method = 'GET'});
    end)

    if success and response then
        return response.Body or response
    end
    
    return warn(response)
end

function rxe.decrypt(str: string, key: number)
    assert(key, "Please provide a key")
    
    local alphabet = {}
	local numbers = {}

	local only_chars = str:gsub('%d+', ''):gsub('-', ''):gsub('_', '')
	if #only_chars > 0 then
		for I = 1, #only_chars do
			local c = only_chars:sub(I,I)
			table.insert(alphabet, c)
		end
	end

	for c in string.gmatch(str, '-%d') do
		table.insert(numbers, tonumber(c:match('%d')))
	end

    for c in string.gmatch(str, '_%d') do
		table.insert(numbers, tonumber(c:match('%d')))
	end

	local only_num = str:gsub('%a+', ''):gsub('-%d', ''):gsub('_%d', '')
	if type(tonumber(only_num)) == 'number' then
		repeat
			local Wanted = only_num:match('%d%d');
			local S,E = only_num:find('%d%d');
			table.insert(numbers, tonumber(Wanted))
			if S and E then
				only_num = only_num:sub(0, S-1) .. only_num:sub(E+1, #only_num)
			end
		until #only_num <= 0
	end

	local sums = 0;
	if #alphabet > 0 then
		for _,v in pairs(alphabet) do
			local byte_t = v:byte();
			sums = sums + byte_t;
		end
	end

	if #numbers > 0 then
		for _,v in pairs(numbers) do
			sums = sums + v;
		end
	end

    if sums == key then
		return true;
    end
    return false
end