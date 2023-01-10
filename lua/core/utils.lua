_G.core = {}

core.load_user_config = function(module)
    if module == nil then
        module = "user"
        if core.user_config ~= nil then
            return core.user_config
        end
    else
        if core.user_config[module] ~= nil then
            return core.user_config[module]
        end
        module = "user." .. module
    end

    local ret, val = pcall(require, module)
    if ret ~= nil then
        return val
    end
    return nil
end

core.user_config = core.load_user_config()
