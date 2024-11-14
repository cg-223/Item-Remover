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
    --print(self.config and self.config.center and self.config.center.key and self.config.center.key)
    --print(self.config and self.config.blind and self.config.blind)
    
    local antiVal = nil
    if self.config.card then antiVal = self.config.center.key end
    if self.config.blind then antiVal = self.config.blind.key end
    if self.edition then antiVal = self.edition.key end
    local dontDisable = {
        bl_small = true,
        bl_big = true,
        j_joker = true,
        tag_handy = true,
        v_blank = true,
        c_incantation = true,
        c_pluto = true,
        c_strength = true,
        c_base,
        e_base,
    }
    if G.your_collection and G.your_collection[1] and G.your_collection[1].cards and self.config and antiVal and not dontDisable[antiVal] then
        for j = 1, #G.your_collection do
            for i = #G.your_collection[j].cards,1, -1 do
            if G.your_collection[j].cards[i] == self then
                self.debuff = not self.debuff
                mod.config["Disabled Things"][antiVal] = not mod.config["Disabled Things"][antiVal] or self.debuff
                --print(mod.config["Disabled Things"][antiVal])
                SMODS.save_mod_config(mod)
            end
            end
        end
    end
    return ret
end

local oldfunc = get_new_boss
function get_new_boss()
    
    local ret = oldfunc()
    if mod.config['Disabled Things'][ret] then
        local num = 0
        for k,v in pairs(G.P_BLINDS) do
            if mod.config['Disabled Things'][k] then
                num = num+1
            end
        end
        if num == #G.P_BLINDS - 2 then
            return 'bl_big'
        end
        return get_new_boss()
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




G.FUNCS.enable_all = function(e)
    mod.config["Disabled Things"]  = {

    }
end


local jimboTabs = function() return {
	{
		label = "Config",
		chosen = true,
		tab_definition_function = function()
			jimbo_nodes = {}
			settings = { n = G.UIT.C, config = { align = "tm", padding = 0.05 }, nodes = {} }

            settings.nodes[#settings.nodes + 1] =
                UIBox_button({button = 'enable_all', label = {"Reset Disabled"},  minw = 5, minh = 1.7, scale = 0.6, id = 'enable_all'})
			config = { n = G.UIT.R, config = { align = "tm", padding = 0 }, nodes = { settings } }
			jimbo_nodes[#jimbo_nodes + 1] = config
			return {
				n = G.UIT.ROOT,
				config = {
					emboss = 0.05,
					minh = 6,
					r = 0.1,
					minw = 10,
					align = "cm",
					padding = 0.2,
					colour = G.C.BLACK,
				},
				nodes = jimbo_nodes,
			}
		end,
	},
} 
end
SMODS.current_mod.extra_tabs = jimboTabs



----------------------------------------------
------------MOD CODE END----------------------
