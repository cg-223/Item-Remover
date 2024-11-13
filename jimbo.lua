--- STEAMODDED HEADER
--- MOD_NAME: Item Remover
--- MOD_ID: ItemRemover
--- MOD_AUTHOR: [elial1]
--- MOD_DESCRIPTION: Prevent certain things from spawning, click on an item in the collection
--- PRIORITY: -1



local mod = SMODS.current_mod

if not mod.config["Disabled Things"] then
    mod.config["Disabled Things"]  = {

    }
end
mod.config["Disabled Things"] = mod.config["Disabled Things"] or {}
SMODS.load_mod_config(mod)

if not mod.config["Disabled Things"] then
    mod.config["Disabled Things"]  = {

    }
end
mod.config["Disabled Things"] = mod.config["Disabled Things"] or {}

local oldfunc = Card.click
function Card:click()
    local ret = oldfunc(self)
    if G.your_collection and G.your_collection[1] and G.your_collection[1].cards then
        for j = 1, #G.your_collection do
            for i = #G.your_collection[j].cards,1, -1 do
            if G.your_collection[j].cards[i] == self then
                self.debuff = not self.debuff
                mod.config["Disabled Things"][self.config.center.key] = not mod.config["Disabled Things"][self.config.center.key] or self.debuff
                print(mod.config["Disabled Things"][self.config.center.key])
                SMODS.save_mod_config(mod)
            end
            end
        end
    end
    return ret
end

local oldfunc = Card.init
function Card:init(X, Y, W, H, card, center, params)
    local ret = oldfunc(self,X, Y, W, H, card, center, params)
    if mod.config["Disabled Things"][self.config.center.key] then
        self.debuff = mod.config["Disabled Things"][self.config.center.key]
    end
    return ret
end


local oldfunc = get_current_pool
function get_current_pool(_type, _rarity, _legendary, _append)
    local _pool,_poolkey = oldfunc(_type,_rarity,_legendary,_append)
    local truepool = {}
    local truepoolsize = 0
    for i = 1, #_pool do
        if 
            (next(find_joker(_pool[i])) 
            and next(find_joker("Showman")))
            
            or (not (mod.config["Disabled Things"][_pool[i]] 
                and mod.config["Disabled Things"][_pool[i]] == true)) 
        then
            if _pool[i] ~= 'UNAVAILABLE' then 
                truepool[#truepool+1] = _pool[i]
                truepoolsize = truepoolsize+1
            end
        else
            --print(truepoolsize)
            --print(_pool[i])
        end
    end
    --print(#truepool)
    if truepoolsize == 0 and not next(find_joker("Showman")) then
        if _type == 'Tarot' or _type == 'Tarot_Planet' then truepool[#truepool + 1] = "c_strength"
        elseif _type == 'Planet' then truepool[#truepool + 1] = "c_pluto"
        elseif _type == 'Spectral' then truepool[#truepool + 1] = "c_incantation"
        elseif _type == 'Joker' then truepool[#truepool + 1] = "j_joker"
        elseif _type == 'Demo' then truepool[#truepool + 1] = "j_joker"
        elseif _type == 'Voucher' then truepool[#truepool + 1] = "v_blank"
        elseif _type == 'Tag' then truepool[#truepool + 1] = "tag_handy"
        else truepool[#truepool + 1] = "j_joker"
        end
        truepoolsize = truepoolsize+1
    end
    return truepool,_poolkey
end
----------------------------------------------
------------MOD CODE END----------------------
