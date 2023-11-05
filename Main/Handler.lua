assert(getgenv().key, "Unable to get key! to get key join discord server.")

loadstring(game:HttpGet('https://raw.githubusercontent.com/i7hz/rxe/main/Misc/Function.lua', true))();

repeat task.wait() until game:IsLoaded();

loadstring(rxe.get({name = 'i7hz', repository = 'rxe', branch = 'main'}, 'GameCheck.lua', 'Main'))()

if rxe.current_game then
    local path = 'Games/' .. rxe.current_game.path;
    local script = rxe.get({name = 'i7hz', repository = 'rxe', branch = 'main'}, 'main.lua', path)
    local key = rxe.current_game.key;
    local gameName = rxe.current_game.game_name;

    if game.Name == gameName then
        local keyCheck = rxe.decrypt(getgenv().key, key)
        if keyCheck then
            local success,msgError = pcall(function()
                return loadstring(script)();
            end)

            if not success then
                return error(msgError)
            end
        else
            return keyCheck
        end
    else
        return error('Sorry the game are updated! Please inform gouang if gouang doesn\'t know yet.')
    end

else
    return print("Sorry the script doesn't supported this game")
end