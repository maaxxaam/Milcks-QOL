--- STEAMODDED HEADER
--- MOD_NAME: Keyboard Voucher
--- MOD_ID: keyboardvoucher
--- MOD_AUTHOR: [maaxxaam, Milck]
--- MOD_DESCRIPTION: Add keyboard shortcuts to the game
----------------------------------------------
------------MOD CODE -------------------------

---@class Keybindings
Keybindings = Object:extend()
Keybindings.MODS = {
    DEFAULT = 1, -- playing cards when possible, "joker" slots in shop
    JOKER = 2,
    CONSUMABLE = 3,
    VOUCHER = 4,
    BOOSTER = 5,
}
Keybindings.ACTIONS = {
    BUY = 1,
    SELL = 2,
    MOVE_LEFT = 3,
    MOVE_RIGHT = 4,
    ANOTHER_TEN = 5,
    USE = 6,
    HOVER = 7,
}
Keybindings.keys_to_nums = {
    ["1"] = 1,
    ["2"] = 2,
    ["3"] = 3,
    ["4"] = 4,
    ["5"] = 5,
    ["6"] = 6,
    ["7"] = 7,
    ["8"] = 8,
    ["9"] = 9,
    ["0"] = 10
}
Keybindings.keys_to_mods = {
    ["j"] = Keybindings.MODS.JOKER,
    ["c"] = Keybindings.MODS.CONSUMABLE,
    ["v"] = Keybindings.MODS.VOUCHER,
    ["b"] = Keybindings.MODS.BOOSTER,
}
Keybindings.keys_to_acts = {
    ["="] = Keybindings.ACTIONS.ANOTHER_TEN,
    [","] = Keybindings.ACTIONS.MOVE_LEFT,
    ["."] = Keybindings.ACTIONS.MOVE_RIGHT,
    ["s"] = Keybindings.ACTIONS.SELL,
    ["w"] = Keybindings.ACTIONS.BUY,
    ["u"] = Keybindings.ACTIONS.USE,
    ["h"] = Keybindings.ACTIONS.HOVER,
}
Keybindings.keys_to_run = {
    ["z"] = "sort_value",
    ["x"] = "sort_rank",
    ["return"] = "play",
    ["space"] = "discard",
    ["a"] = "run_info",
    ["d"] = "deck_info",
    ["lshift"] = "peek_deck",
    ["r"] = "reroll",
}
Keybindings.mod_active_type = Keybindings.MODS.DEFAULT
Keybindings.mod_last_type = Keybindings.MODS.DEFAULT
Keybindings.total_addition = 0
Keybindings.last_card = 1
Keybindings.press_state_callback = {
    [G.STATES.SELECTING_HAND] = function (key) Keybindings:hand_press_callback(key) end,
    [G.STATES.SHOP] = function (key) Keybindings:shop_press_callback(key) end,
    [G.STATES.BLIND_SELECT] = function (key) Keybindings:blind_press_callback(key) end,
    [G.STATES.ROUND_EVAL] = function (key) Keybindings:round_press_callback(key) end,
    [G.STATES.TAROT_PACK] = function (key) Keybindings:pack_press_callback(key) end,
    [G.STATES.PLANET_PACK] = function (key) Keybindings:pack_press_callback(key) end,
    [G.STATES.SPECTRAL_PACK] = function (key) Keybindings:pack_press_callback(key) end,
    [G.STATES.STANDARD_PACK] = function (key) Keybindings:pack_press_callback(key) end,
    [G.STATES.BUFFOON_PACK] = function (key) Keybindings:pack_press_callback(key) end,
}
Keybindings.release_state_callback = {
    [G.STATES.SELECTING_HAND] = function (key) Keybindings:hand_release_callback(key) end,
--    [G.STATES.SHOP] = function (key) Keybindings:shop_release_callback(key) end,
--    [G.STATES.BLIND_SELECT] = function (key) Keybindings:blind_release_callbac(key) endk,
--    [G.STATES.ROUND_EVAL] = function (key) Keybindings:round_release_callbac(key) endk,
--    [G.STATES.TAROT_PACK] = function (key) Keybindings:pack_release_callback(key) end,
--    [G.STATES.PLANET_PACK] = function (key) Keybindings:pack_release_callback(key) end,
--    [G.STATES.SPECTRAL_PACK] = function (key) Keybindings:pack_release_callback(key) end,
--    [G.STATES.STANDARD_PACK] = function (key) Keybindings:pack_release_callback(key) end,
--    [G.STATES.BUFFOON_PACK] = function (key) Keybindings:pack_release_callback(key) end,
}
Keybindings.hold_state_callback = {
--    [G.STATES.SELECTING_HAND] = function (key, dt) Keybindings:hand_hold_callback(key, dt) end,
    [G.STATES.SHOP] = function (key, dt) Keybindings:shop_hold_callback(key, dt) end,
--    [G.STATES.BLIND_SELECT] = function (key, dt) Keybindings:blind_hold_callback(key, dt) end,
--    [G.STATES.ROUND_EVAL] = function (key, dt) Keybindings:round_hold_callback(key, dt) end,
--    [G.STATES.TAROT_PACK] = function (key, dt) Keybindings:pack_hold_callback(key, dt) end,
--    [G.STATES.PLANET_PACK] = function (key, dt) Keybindings:pack_hold_callback(key, dt) end,
--    [G.STATES.SPECTRAL_PACK] = function (key, dt) Keybindings:pack_hold_callback(key, dt) end,
--    [G.STATES.STANDARD_PACK] = function (key, dt) Keybindings:pack_hold_callback(key, dt) end,
--    [G.STATES.BUFFOON_PACK] = function (key, dt) Keybindings:pack_hold_callback(key, dt) end,
}

local keyupdate_ref = Controller.key_press_update
function Controller.key_press_update(self, key, dt)
    keyupdate_ref(self, key, dt)
    if G.STAGE == G.STAGES.RUN then
        if Keybindings.press_state_callback[G.STATE] then
            Keybindings.press_state_callback[G.STATE](key)
        end

        if tableContains(Keybindings.keys_to_nums, key) then
            local affected_area = Keybindings:getAffectedArea(Keybindings.mod_active_type)
            if affected_area then
                num = Keybindings.keys_to_nums[key]
                local shorter_addition = Keybindings.total_addition % ((#affected_area.cards - 1) / 10 * 10)
                num = num + shorter_addition
                Keybindings.total_addition = 0
                if num > #affected_area.cards then num = #affected_area.cards end
                if Keybindings.mod_active_type ~= Keybindings.mod_last_type and Keybindings.mod_last_type ~= Keybindings.MODS.DEFAULT then
                    local affected_old = Keybindings:getAffectedArea(Keybindings.mod_last_type)
                    if affected_old then Keybindings:unhighlight(affected_old) end
                end
                if affected_area == G.hand then
                    local card = G.hand.cards[num]
                    if card.highlighted then
                        G.hand:remove_from_highlighted(card, false)
                        play_sound('cardSlide2', nil, 0.3)
                    else
                        G.hand:add_to_highlighted(card)
                        Keybindings.last_card = num
                        Keybindings.mod_last_type = Keybindings.mod_active_type
                        Keybindings.mod_active_type = Keybindings.MODS.DEFAULT
                    end
                elseif num > 0 then
                    Keybindings:unhighlight(affected_area)
                    affected_area:add_to_highlighted(affected_area.cards[num])
                    Keybindings.last_card = num
                    Keybindings.mod_last_type = Keybindings.mod_active_type
                    Keybindings.mod_active_type = Keybindings.MODS.DEFAULT
                end
            end
        end

        if tableContains(Keybindings.keys_to_run, key) then
            if Keybindings.keys_to_run[key] == "run_info" then
                local run_info_button = G.HUD:get_UIE_by_ID('run_info_button')
                if run_info_button.config.button == 'run_info' then
                    G.FUNCS.run_info()
                end
            elseif Keybindings.keys_to_run[key] == "deck_info" then
                G.FUNCS.deck_info()
            end
        end
        if tableContains(Keybindings.keys_to_mods, key) then
            local new_mode = Keybindings.keys_to_mods[key]
            if Keybindings.mod_active_type == new_mode then
                local affected_area = Keybindings:getAffectedArea(new_mode)
                if affected_area ~= nil then
                    Keybindings:unhighlight(affected_area)
                    if Keybindings.mod_last_type == new_mode then
                        Keybindings.mod_last_type = Keybindings.MODS.DEFAULT
                        Keybindings.mod_active_type = Keybindings.MODS.DEFAULT
                    else 
                        if #affected_area.cards > 0 then 
                            Keybindings.mod_last_type = new_mode
                            Keybindings.mod_active_type = Keybindings.MODS.DEFAULT
                            affected_area:add_to_highlighted(affected_area.cards[1]) 
                            Keybindings.last_card = 1
                        end
                    end
                end
            else 
                if new_mode ~= Keybindings.mod_last_type and Keybindings.mod_last_type ~= Keybindings.MODS.DEFAULT then
                    local affected_old = Keybindings:getAffectedArea(Keybindings.mod_last_type)
                    Keybindings:unhighlight(affected_old)
                end
                Keybindings.mod_active_type = new_mode
            end
        end
        if tableContains(Keybindings.keys_to_acts, key) then
            local action = Keybindings.keys_to_acts[key]
            if action == Keybindings.ACTIONS.HOVER then
                local area = Keybindings:getAffectedArea(Keybindings.mod_last_type)
                if area then
                    if area.cards[Keybindings.last_card].children.h_popup then
                        area.cards[Keybindings.last_card]:stop_hover()
                    else
                        area.cards[Keybindings.last_card]:hover()
                    end
                end
            elseif action == Keybindings.ACTIONS.SELL then
                local area = Keybindings:getAffectedArea(Keybindings.mod_last_type)
                if area and area.cards[Keybindings.last_card]:can_sell_card() then
                    area.cards[Keybindings.last_card]:sell_card()
                end
            elseif action == Keybindings.ACTIONS.USE then
                local area = Keybindings:getAffectedArea(Keybindings.mod_last_type)
                if area then
                    local card = area.cards[Keybindings.last_card]
                    if G.STATE == G.STATES.SHOP then
                        local buy_use_button = card.children.buy_and_use
                        if buy_use_button and buy_use_button.UIRoot.config.button then
                            G.FUNCS.buy_from_shop(buy_use_button.UIRoot)
                        end
                    else
                        if area.cards[Keybindings.last_card]:can_use_consumeable() then
                            G.FUNCS.use_card({ config = { ref_table = card } })
                        end
                    end
                end
            elseif action == Keybindings.ACTIONS.ANOTHER_TEN then
                Keybindings.total_addition = Keybindings.total_addition + 10
            elseif action == Keybindings.ACTIONS.BUY then
                local area = Keybindings:getAffectedArea(Keybindings.mod_last_type)
                if area then
                    local card = area.cards[Keybindings.last_card]
                    local buy_button = card.children.buy_button
                    if buy_button and buy_button.UIRoot.config.button then
                        print(tprint(buy_button.UIRoot.config))
                        if Keybindings.mod_last_type == Keybindings.MODS.BOOSTER then
                            G.FUNCS.use_card(buy_button.UIRoot)
                        elseif Keybindings.mod_last_type == Keybindings.MODS.VOUCHER then
                            G.FUNCS.use_card(buy_button.UIRoot)
                        else
                            G.FUNCS.buy_from_shop(buy_button.UIRoot)
                        end
                    end
                end
            end
        end

        if tableContains(Keybindings.keys_to_acts, key) then
            local action = Keybindings.keys_to_acts[key]
            if action == Keybindings.ACTIONS.MOVE_LEFT then
                local area = Keybindings:getAffectedArea(Keybindings.mod_last_type)
                if area then
                    local card = area.cards[Keybindings.last_card]
                    if Keybindings.last_card > 1 and card.states.drag.can then
                        area.cards[Keybindings.last_card] = area.cards[Keybindings.last_card - 1]
                        area.cards[Keybindings.last_card - 1] = card
                        Keybindings.last_card = Keybindings.last_card - 1
                    end
                end
            elseif action == Keybindings.ACTIONS.MOVE_RIGHT then
                local area = Keybindings:getAffectedArea(Keybindings.mod_last_type)
                if area then
                    local card = area.cards[Keybindings.last_card]
                    if Keybindings.last_card < #area.cards and card.states.drag.can then
                        area.cards[Keybindings.last_card] = area.cards[Keybindings.last_card + 1]
                        area.cards[Keybindings.last_card + 1] = card
                        Keybindings.last_card = Keybindings.last_card + 1
                    end
                end
            end
        end
    end
end

function Keybindings:hand_press_callback(key)
    if tableContains(Keybindings.keys_to_run, key) then
        if Keybindings.keys_to_run[key] == "play" and not G.deck_preview then
            local play_button = G.buttons:get_UIE_by_ID('play_button')
            if play_button.config.button == 'play_cards_from_highlighted' then
                G.FUNCS.play_cards_from_highlighted()
            end
        elseif Keybindings.keys_to_run[key] == "discard" then
            local discard_button = G.buttons:get_UIE_by_ID('discard_button')
            if discard_button.config.button == 'discard_cards_from_highlighted' then
                G.FUNCS.discard_cards_from_highlighted()
            end
        elseif Keybindings.keys_to_run[key] == "sort_value" then
            G.FUNCS.sort_hand_value()
        elseif Keybindings.keys_to_run[key] == "sort_rank" then
            G.FUNCS.sort_hand_suit()
        elseif Keybindings.keys_to_run[key] == "peek_deck" then
            G.buttons.states.visible = false
            G.deck_preview = UIBox{
                definition = G.UIDEF.deck_preview(),
                config = {align='tm', offset = {x=0,y=-0.8},major = G.hand, bond = 'Weak'}
            }
        end
    end
end

function Keybindings:blind_press_callback(key)
    if G.blind_select == nil then return end
    if tableContains(Keybindings.keys_to_run, key) == false then return end

    if Keybindings.keys_to_run[key] == "play" then
        local select_blind_button = G.blind_select:get_UIE_by_ID(G.GAME.blind_on_deck).UIBox:get_UIE_by_ID('select_blind_button')
        if select_blind_button then G.FUNCS.select_blind(select_blind_button) end
    elseif Keybindings.keys_to_run[key] == "discard" then
        local skip_blind_button = G.blind_select:get_UIE_by_ID(G.GAME.blind_on_deck)
        if skip_blind_button then G.FUNCS.skip_blind(skip_blind_button) end
    elseif Keybindings.keys_to_run[key] == "reroll" then
        local row_blind = G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext1')
        local choose_blind = row_blind.parent.parent
        local reroll_blind_button = choose_blind.children[3].children[1]
        if reroll_blind_button.config.button == "reroll_boss" then
            G.FUNCS.reroll_boss(reroll_blind_button)
        end
    end
end

function Keybindings:shop_press_callback(key)
    if G.shop == nil then return end
    if tableContains(Keybindings.keys_to_run, key) == false then return end

    if Keybindings.keys_to_run[key] == "play" then
        local next_round_button = G.shop:get_UIE_by_ID('next_round_button')
        G.FUNCS.toggle_shop(next_round_button)
    elseif Keybindings.keys_to_run[key] == "reroll" then
        local reroll_shop_button = G.shop:get_UIE_by_ID('next_round_button').parent.children[2]
        -- if config.button is empty, then we cannot reroll because player is bankrupt
        if reroll_shop_button.config.button then
            G.FUNCS.reroll_shop(reroll_shop_button)
        end
    end
end

function Keybindings:pack_press_callback(key)
    if tableContains(Keybindings.keys_to_run, key) == false then return end

    if Keybindings.keys_to_run[key] == "discard" then
        G.FUNCS.skip_booster()
    end
end

function Keybindings:round_press_callback(key)
    if tableContains(Keybindings.keys_to_run, key) == false then return end

    if Keybindings.keys_to_run[key] == "play" then
        G.FUNCS.cash_out(G.round_eval)
    end
end

local keyrelease_ref = Controller.key_release_update
function Controller.key_release_update(self, key, dt)
    keyrelease_ref(self, key, dt)
    if G.STAGE == G.STAGES.RUN then
        if Keybindings.release_state_callback[G.STATE] then
            Keybindings.release_state_callback[G.STATE](key)
        end
    end
end

function Keybindings:hand_release_callback(key)
    if tableContains(Keybindings.keys_to_run, key) == false then return end

    if Keybindings.keys_to_run[key] == "peek_deck" then
        if G.deck_preview then
            G.buttons.states.visible = true
            G.deck_preview:remove()
            G.deck_preview = nil
        end
    end
end

local keyhold_ref = Controller.key_hold_update
function Controller.key_hold_update(self, key, dt)
    keyhold_ref(self, key, dt)
    if G.STAGE == G.STAGES.RUN then
        if Keybindings.hold_state_callback[G.STATE] then
            Keybindings.hold_state_callback[G.STATE](key, dt)
        end

    end
end

function Keybindings:shop_hold_callback(key, dt)
    return
end

function tableContains(table, key)
  for k,v in pairs(table) do
    if k == key then
        return true
    end
  end
  return false
end

function Keybindings:getAffectedArea(type)
    if type == Keybindings.MODS.DEFAULT then
        if G.STATE == G.STATES.SHOP then
            return G.shop_jokers
        elseif G.STATE == G.STATES.STANDARD_PACk or G.STATE == G.STATES.BUFFOON_PACK or G.STATE == G.STATES.PLANET_PACK then
            return G.pack_cards
        else
            return G.hand
        end
    elseif type == Keybindings.MODS.JOKER then
        return G.jokers
    elseif type == Keybindings.MODS.CONSUMABLE then
        return G.consumeables
    elseif type == Keybindings.MODS.VOUCHER then
        if G.STATE == G.STATES.SHOP then
            return G.shop_vouchers
        else 
            return nil
        end
    elseif type == Keybindings.MODS.BOOSTER then
        if G.STATE == G.STATES.SHOP then
            return G.shop_booster
        elseif G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.TAROT_PACK then
            return G.pack_cards
        else 
            return nil
        end
    end

    return nil
end

function Keybindings:unhighlight(area)
    if #area.highlighted > 0 then
        for i = 1, #area.highlighted, 1 do
            area.highlighted[i]:stop_hover()
        end
    end
    area:unhighlight_all()
end

function tprint (tbl, indent)
    if not indent then indent = 0 end
    local toprint = string.rep(" ", indent) .. "{\r\n"
    indent = indent + 2 
    for k, v in pairs(tbl) do
        toprint = toprint .. string.rep(" ", indent)
        if (type(k) == "number") then
            toprint = toprint .. "[" .. k .. "] = "
        elseif (type(k) == "string") then
            toprint = toprint  .. k ..  "= "   
        end
        if (type(v) == "number") then
            toprint = toprint .. v .. ",\r\n"
        elseif (type(v) == "string") then
            toprint = toprint .. "\"" .. v .. "\",\r\n"
        elseif (type(v) == "table") then
            toprint = toprint .. "table ,\r\n" --tprint(v, indent + 2) .. ",\r\n"
        else
            toprint = toprint .. "\"" .. tostring(v) .. "\",\r\n"
        end
    end
    toprint = toprint .. string.rep(" ", indent-2) .. "}"
    return toprint
end
----------------------------------------------
------------MOD CODE END----------------------
