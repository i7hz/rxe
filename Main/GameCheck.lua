assert(getgenv().rxe, 'Couldn\'t find the table');

local jsonFile = game:GetService('HttpService'):JSONDecode(rxe.get({name = "i7hz", repository = 'rxe', branch = 'main'}, 'Lists.json', 'Misc'))
local ct = (function()
    local response;
    for _,data in pairs(jsonFile) do
        if type(data['pid']) ~= 'table' and data['pid'] == game.PlaceId then
            response = data;
            break;
        end

        if type(data['pid']) == 'table' and (table.concat(data['pid'], ' ')):match(tostring(game.PlaceId)) then
            response = data;
            break;
        end
    end
    return response;
end)()

assert(ct, 'Sorry current game is not supported');

getgenv().rxe.current_game = ct;
return print(('Game found! %s'):format(ct['game_name'])) and true;