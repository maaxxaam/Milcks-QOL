--- STEAMODDED HEADER
--- MOD_NAME: Keyboard Voucher
--- MOD_ID: keyboardvoucher
--- MOD_AUTHOR: [maaxxaam, Milck, erijohnt]
--- MOD_DESCRIPTION: Add keyboard shortcuts to the game
----------------------------------------------
------------MOD CODE -------------------------


---@class KeyVoucher
KeyVoucher = Object:extend()
KeyVoucher.MODS = {
    DEFAULT = 1, -- playing cards when possible, "joker" slots in shop
    JOKER = 2,
    CONSUMABLE = 3,
    VOUCHER = 4,
    BOOSTER = 5,
}
KeyVoucher.mod_dict = {
    [KeyVoucher.MODS.JOKER] = {
        name = "Joker",
        colour = G.C.SECONDARY_SET.Joker,
    },
    [KeyVoucher.MODS.CONSUMABLE] = {
        name = "Consumable",
        colour = G.C.SECONDARY_SET.Tarot,
    },
    [KeyVoucher.MODS.VOUCHER] = {
        name = "Voucher",
        colour = G.C.VOUCHER,
    },
    [KeyVoucher.MODS.BOOSTER] = {
        name = "Booster",
        colour = G.C.BOOSTER,
    },
    [KeyVoucher.MODS.DEFAULT] = { 
        name = "Card",
        colour = G.C.SECONDARY_SET.Default,
    },
}
KeyVoucher.RUN_ACTIONS = {
    PLAY = 1,
    DISCARD = 2,
    HOVER_TAG = 3,
    PEEK_DECK = 4,
    REROLL = 5,
    SORT_RANK = 6,
    SORT_SUIT = 7,
    HELP = 8,
    RUN_INFO = 9,
    DECK_INFO = 10,
    ANOTHER_TEN = 11,
}
KeyVoucher.OVERLAY = {
    SELECTION_UP = 1,
    SELECTION_DOWN = 2,
    SELECTION_LEFT = 3,
    SELECTION_RIGHT = 4,
    MOVE_LEFT = 5,
    MOVE_RIGHT = 6,
    PRIMARY = 7,
    SECONDARY = 8,
}
KeyVoucher.mod_active_type = KeyVoucher.MODS.DEFAULT
KeyVoucher.mod_last_type = KeyVoucher.MODS.DEFAULT
KeyVoucher.meta_active_type = 0
KeyVoucher.total_addition = 0
KeyVoucher.last_card = 0
KeyVoucher.last_mouse_position = { x = 0, y = 0 }
KeyVoucher.key_movement = false
KeyVoucher.waiting_for_input = false
--KeyVoucher.overlay_objects = nil
--KeyVoucher.overlay_last_objects_len = 0
--KeyVoucher.overlay_selected = 0
KeyVoucher.settings_screen = nil
KeyVoucher.new_select = nil
KeyVoucher.selection = nil
KeyVoucher.hold_times = {
    [1] = 0,
    [2] = 0,
    [3] = 0,
    [4] = 0,
}
KeyVoucher.press_state_callback = {
    [G.STATES.SELECTING_HAND] = function (key) KeyVoucher:hand_press_callback(key) end,
    [G.STATES.SHOP] = function (key) KeyVoucher:shop_press_callback(key) end,
    [G.STATES.BLIND_SELECT] = function (key) KeyVoucher:blind_press_callback(key) end,
    [G.STATES.ROUND_EVAL] = function (key) KeyVoucher:round_press_callback(key) end,
    [G.STATES.TAROT_PACK] = function (key) KeyVoucher:pack_press_callback(key) end,
    [G.STATES.PLANET_PACK] = function (key) KeyVoucher:pack_press_callback(key) end,
    [G.STATES.SPECTRAL_PACK] = function (key) KeyVoucher:pack_press_callback(key) end,
    [G.STATES.STANDARD_PACK] = function (key) KeyVoucher:pack_press_callback(key) end,
    [G.STATES.BUFFOON_PACK] = function (key) KeyVoucher:pack_press_callback(key) end,
}
KeyVoucher.release_state_callback = {
    [G.STATES.SELECTING_HAND] = function (key) KeyVoucher:hand_release_callback(key) end,
--    [G.STATES.SHOP] = function (key) KeyVoucher:shop_release_callback(key) end,
--    [G.STATES.BLIND_SELECT] = function (key) KeyVoucher:blind_release_callbac(key) endk,
--    [G.STATES.ROUND_EVAL] = function (key) KeyVoucher:round_release_callbac(key) endk,
--    [G.STATES.TAROT_PACK] = function (key) KeyVoucher:pack_release_callback(key) end,
--    [G.STATES.PLANET_PACK] = function (key) KeyVoucher:pack_release_callback(key) end,
--    [G.STATES.SPECTRAL_PACK] = function (key) KeyVoucher:pack_release_callback(key) end,
--    [G.STATES.STANDARD_PACK] = function (key) KeyVoucher:pack_release_callback(key) end,
--    [G.STATES.BUFFOON_PACK] = function (key) KeyVoucher:pack_release_callback(key) end,
}
KeyVoucher.hold_state_callback = {
--    [G.STATES.SELECTING_HAND] = function (key, dt) KeyVoucher:hand_hold_callback(key, dt) end,
    [G.STATES.SHOP] = function (key, dt) KeyVoucher:shop_hold_callback(key, dt) end,
--    [G.STATES.BLIND_SELECT] = function (key, dt) KeyVoucher:blind_hold_callback(key, dt) end,
--    [G.STATES.ROUND_EVAL] = function (key, dt) KeyVoucher:round_hold_callback(key, dt) end,
--    [G.STATES.TAROT_PACK] = function (key, dt) KeyVoucher:pack_hold_callback(key, dt) end,
--    [G.STATES.PLANET_PACK] = function (key, dt) KeyVoucher:pack_hold_callback(key, dt) end,
--    [G.STATES.SPECTRAL_PACK] = function (key, dt) KeyVoucher:pack_hold_callback(key, dt) end,
--    [G.STATES.STANDARD_PACK] = function (key, dt) KeyVoucher:pack_hold_callback(key, dt) end,
--    [G.STATES.BUFFOON_PACK] = function (key, dt) KeyVoucher:pack_hold_callback(key, dt) end,
}
KeyVoucher.action_callbacks = {
    [KeyVoucher.OVERLAY.PRIMARY] = function () KeyVoucher:primary_action_callback() end,
    [KeyVoucher.OVERLAY.SECONDARY] = function () KeyVoucher:secondary_action_callback() end,
    [KeyVoucher.OVERLAY.MOVE_LEFT] = function () KeyVoucher:move_action_callback(-1) end,
    [KeyVoucher.OVERLAY.MOVE_RIGHT] = function () KeyVoucher:move_action_callback(1) end,
    [KeyVoucher.OVERLAY.SELECTION_UP] = function () KeyVoucher:select_action_callback("U") end,
    [KeyVoucher.OVERLAY.SELECTION_DOWN] = function () KeyVoucher:select_action_callback("D") end,
    [KeyVoucher.OVERLAY.SELECTION_RIGHT] = function () KeyVoucher:select_action_callback("R") end,
    [KeyVoucher.OVERLAY.SELECTION_LEFT] = function () KeyVoucher:select_action_callback("L") end,
}
KeyVoucher.run_callbacks = {
    [KeyVoucher.RUN_ACTIONS.HELP] = function () KeyVoucher:help_action_callback() end,
    [KeyVoucher.RUN_ACTIONS.ANOTHER_TEN] = function () KeyVoucher.total_addition = KeyVoucher.total_addition + 10 end,
    [KeyVoucher.RUN_ACTIONS.RUN_INFO] = function () G.FUNCS.run_info() end,
    [KeyVoucher.RUN_ACTIONS.DECK_INFO] = function () G.FUNCS.deck_info() end,
}
KeyVoucher.overlay_hints = { -- 1 = primary, 2 = secondary
    ["redeem"] = KeyVoucher.OVERLAY.PRIMARY,
    ["buy"] = KeyVoucher.OVERLAY.PRIMARY,
    ["use"] = KeyVoucher.OVERLAY.PRIMARY,
    ["buy_and_use"] = KeyVoucher.OVERLAY.SECONDARY,
    ["sell"] = KeyVoucher.OVERLAY.SECONDARY,
}
KeyVoucher.selection_types = {
    CARD = 1,
    BUTTON = 2,
    TABS = 3,
    CYCLE = 4,
}
KeyVoucher.ui_categories = {
    keys_to_nums = "Card selection",
    keys_to_mods = "Card areas",
    keys_to_run = "During the run",
    keys_to_overlay = "UI navigation",
}
KeyVoucher.ui_dict = {
    keys_to_nums = {
        [1] = {
            desc = "Select card 1",
            id_desc = "card1",
        },
        [2] = {
            desc = "Select card 2",
            id_desc = "card2",
        },
        [3] = {
            desc = "Select card 3",
            id_desc = "card3",
        },
        [4] = {
            desc = "Select card 4",
            id_desc = "card4",
        },
        [5] = {
            desc = "Select card 5",
            id_desc = "card5",
        },
        [6] = {
            desc = "Select card 6",
            id_desc = "card6",
        },
        [7] = {
            desc = "Select card 7",
            id_desc = "card7",
        },
        [8] = {
            desc = "Select card 8",
            id_desc = "card8",
        },
        [9] = {
            desc = "Select card 9",
            id_desc = "card9",
        },
        [10] = {
            desc = "Select card 10",
            id_desc = "card10",
        },
    },
    keys_to_overlay = {
        [KeyVoucher.OVERLAY.PRIMARY] = {
            desc = "Main action",
            id_desc = "main",
        },
        [KeyVoucher.OVERLAY.SECONDARY] = {
            desc = "Secondary action",
            id_desc = "secondary",
        },
        [KeyVoucher.OVERLAY.MOVE_LEFT] = {
            desc = "Move to the left",
            id_desc = "move_left",
        },
        [KeyVoucher.OVERLAY.MOVE_RIGHT] = {
            desc = "Move to the right",
            id_desc = "move_right",
        },
        [KeyVoucher.OVERLAY.SELECTION_UP] = {
            desc = "Navigate up",
            id_desc = "ui_up",
        },
        [KeyVoucher.OVERLAY.SELECTION_DOWN] = {
            desc = "Navigate down",
            id_desc = "ui_down",
        },
        [KeyVoucher.OVERLAY.SELECTION_LEFT] = {
            desc = "Navigate left",
            id_desc = "ui_left",
        },
        [KeyVoucher.OVERLAY.SELECTION_RIGHT] = {
            desc = "Navigate right",
            id_desc = "ui_right",
        },
    },
    keys_to_mods = {
        [KeyVoucher.MODS.JOKER] = {
            desc = "Select Jokers",
            id_desc = "joker_mod",
        },
        [KeyVoucher.MODS.CONSUMABLE] = {
            desc = "Select Consumable",
            id_desc = "consumable_mod",
        },
        [KeyVoucher.MODS.VOUCHER] = {
            desc = "Select Voucher",
            id_desc = "voucher_mod",
        },
        [KeyVoucher.MODS.BOOSTER] = {
            desc = "Select Booster Pack",
            id_desc = "booster_mod",
        },
    },
    keys_to_run = {
        [KeyVoucher.RUN_ACTIONS.SORT_RANK] = {
            desc = "Sort hand by rank",
            id_desc = "sort_rank",
        },
        [KeyVoucher.RUN_ACTIONS.SORT_SUIT] = {
            desc = "Sort hand by suit",
            id_desc = "sort_suit",
        },
        [KeyVoucher.RUN_ACTIONS.PLAY] = {
            desc = "Play hand",
            id_desc = "play",
        },
        [KeyVoucher.RUN_ACTIONS.DISCARD] = {
            desc = "Discard hand",
            id_desc = "discard",
        },
        [KeyVoucher.RUN_ACTIONS.PEEK_DECK] = {
            desc = "Peek at deck (hold)",
            id_desc = "peek",
        },
        [KeyVoucher.RUN_ACTIONS.REROLL] = {
            desc = "Reroll",
            id_desc = "reroll",
        },
        [KeyVoucher.RUN_ACTIONS.RUN_INFO] = {
            desc = "Run info",
            id_desc = "run_info",
        },
        [KeyVoucher.RUN_ACTIONS.DECK_INFO] = {
            desc = "Deck info",
            id_desc = "deck_info",
        },
        [KeyVoucher.RUN_ACTIONS.ANOTHER_TEN] = {
            desc = "Add 10 to selection",
            id_desc = "add_ten",
        },
        [KeyVoucher.RUN_ACTIONS.HOVER_TAG] = {
            desc = "Snap to blind tag",
            id_desc = "hover_tag",
        },
        [KeyVoucher.RUN_ACTIONS.HELP] = {
            desc = "Toggle Vimium info panel",
            id_desc = "vim_panel",
        },
    },
}

Keybindings = Object:extend()
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
    ["j"] = KeyVoucher.MODS.JOKER,
    ["c"] = KeyVoucher.MODS.CONSUMABLE,
    ["v"] = KeyVoucher.MODS.VOUCHER,
    ["b"] = KeyVoucher.MODS.BOOSTER,
}
Keybindings.keys_to_overlay = {
    ["a"] = KeyVoucher.OVERLAY.MOVE_LEFT,
    ["d"] = KeyVoucher.OVERLAY.MOVE_RIGHT,
    ["s"] = KeyVoucher.OVERLAY.SECONDARY,
    ["w"] = KeyVoucher.OVERLAY.PRIMARY,
    ['left'] = KeyVoucher.OVERLAY.SELECTION_LEFT,
    ['right'] = KeyVoucher.OVERLAY.SELECTION_RIGHT,
    ['up'] = KeyVoucher.OVERLAY.SELECTION_UP,
    ['down'] = KeyVoucher.OVERLAY.SELECTION_DOWN,
}
Keybindings.keys_to_run = {
    ["z"] = KeyVoucher.RUN_ACTIONS.SORT_RANK,
    ["x"] = KeyVoucher.RUN_ACTIONS.SORT_SUIT,
    ["return"] = KeyVoucher.RUN_ACTIONS.PLAY,
    ["space"] = KeyVoucher.RUN_ACTIONS.DISCARD,
    ["lshift"] = KeyVoucher.RUN_ACTIONS.PEEK_DECK,
    ["r"] = KeyVoucher.RUN_ACTIONS.REROLL,
    ["h"] = KeyVoucher.RUN_ACTIONS.HOVER_TAG,
    ["/"] = KeyVoucher.RUN_ACTIONS.HELP,
    ["="] = KeyVoucher.RUN_ACTIONS.ANOTHER_TEN,
    ["f"] = KeyVoucher.RUN_ACTIONS.RUN_INFO,
    ["e"] = KeyVoucher.RUN_ACTIONS.DECK_INFO,
}

function Keybindings:save()
    compress_and_save('keybindings.jkr', self)
end

function Keybindings:load()
    local copy = STR_UNPACK(get_compressed('keybindings.jkr'))
    if copy then self = copy end
end

local keyupdate_ref = Controller.key_press_update
function Controller.key_press_update(self, key, dt)
    keyupdate_ref(self, key, dt)

    if tableContains(Keybindings.keys_to_overlay, key) then
        local action = Keybindings.keys_to_overlay[key]
        KeyVoucher.action_callbacks[action]()
    end

    if G.STAGE == G.STAGES.RUN then
        if KeyVoucher.press_state_callback[G.STATE] then
            KeyVoucher.press_state_callback[G.STATE](key)
        end

        if tableContains(Keybindings.keys_to_nums, key) then
            KeyVoucher:handle_selection(Keybindings.keys_to_nums[key])
        elseif tableContains(Keybindings.keys_to_mods, key) then
            KeyVoucher:handle_mods(Keybindings.keys_to_mods[key])
        elseif tableContains(Keybindings.keys_to_run, key) and tableContains(KeyVoucher.run_callbacks, Keybindings.keys_to_run[key]) then
            KeyVoucher.run_callbacks[Keybindings.keys_to_run[key]]()
        end
    end
end

-- 
--    ACTION CALLBACKS 
--

function KeyVoucher:select_action_callback(direction)
    KeyVoucher.key_movement = true
    G.CONTROLLER:navigate_focus(direction)
    G.E_MANAGER:add_event(Event({
        trigger = 'after',
        delay = 0.001, -- that's dodgy, but makes sure the following code runs next frame, when focus definitely should've been transferred
        blockable = false, 
        blocking = false,
        func = function()
            if not G.CONTROLLER.focused.target then return end
            KeyVoucher.selection = { item = G.CONTROLLER.focused.target }
            local item = G.CONTROLLER.focused.target
            -- Fill the selection table
            if KeyVoucher:find_cycle(item) then KeyVoucher.selection.type = KeyVoucher.selection_types.CYCLE end
            if item.config.button then KeyVoucher.selection.type = KeyVoucher.selection_types.BUTTON end
            if item.area then 
                KeyVoucher.selection.type = KeyVoucher.selection_types.CARD 
                local mode = KeyVoucher:getModFromArea(item.area)
                if mode > 0 then
                    KeyVoucher.mod_last_type = mode
                    KeyVoucher.mod_active_type = KeyVoucher.MODS.DEFAULT
                end
            end
            if item.config.id == "tab_shoulders" or item.config.id == "no_shoulders" then KeyVoucher.selection.type = KeyVoucher.selection_types.TABS end

            G.CURSOR.x = item.T.x + item.T.w / 2
            G.CURSOR.y = item.T.y + item.T.h / 2
            local tome = KeyVoucher:searchUIBoxWithID('ATTACH_TO_ME')
            if not tome then return true end
            for k, v in pairs(tome.children) do
                KeyVoucher:add_key_hint(v, KeyVoucher.overlay_hints[k])
            end
            return true
        end
    }))
end

function KeyVoucher:primary_action_callback()
    sendDebugMessage(tprint(KeyVoucher.selection))
    if KeyVoucher.selection.type == KeyVoucher.selection_types.CARD then
        local card = KeyVoucher.selection.item
        local area = card.area
        sendDebugMessage(tprint(card))

        -- BUY - Booster packs, vouchers, cards
        local buy_button = card.children.buy_button
        if buy_button and buy_button.UIRoot.config.button then
            if KeyVoucher.mod_last_type == KeyVoucher.MODS.BOOSTER then
                G.FUNCS.use_card(buy_button.UIRoot)
            elseif KeyVoucher.mod_last_type == KeyVoucher.MODS.VOUCHER then
                G.FUNCS.use_card(buy_button.UIRoot)
            else
                G.FUNCS.buy_from_shop(buy_button.UIRoot)
            end
            KeyVoucher:resetLastCard()
        end
        
        -- SELECT
        if (G.STATE == G.STATES.STANDARD_PACK or G.STATE == G.STATES.BUFFOON_PACK) and KeyVoucher.mod_last_type == KeyVoucher.MODS.DEFAULT then
            local use_button = card.children.use_button
            if use_button then
                if use_button.UIRoot.children[1].config.button then 
                    G.FUNCS.use_card({ config = { ref_table = card } }) 
                    KeyVoucher:resetLastCard()
                end
            end
        end

        -- USE
        sendDebugMessage(tprint(card.ability))
        if card.ability.consumeable and card:can_use_consumeable() then
            G.FUNCS.use_card({ config = { ref_table = card } })
            KeyVoucher:resetLastCard()
        end

        -- UN-/HIGHLIGHT
        if card.playing_card then
            local card = KeyVoucher.selection.item
            if not card.highlighted then
                card.area:add_to_highlighted(card)
            else
                card.area:remove_from_highlighted(card)
            end
        end
    elseif KeyVoucher.selection.type == KeyVoucher.selection_types.BUTTON then
        -- Click buttons
        local selection = G.CONTROLLER.focused.target
        if not selection then return end
        if selection.config.button then
            G.FUNCS[selection.config.button](selection)
        end
    end
end

function KeyVoucher:move_action_callback(offset)
    local focused = KeyVoucher.key_movement and (G.CONTROLLER.focused.target) or nil
    if not focused then return end
    if KeyVoucher.selection.type == KeyVoucher.selection_types.CYCLE then
        local index = 2 + offset
        local button = KeyVoucher.selection.item.children[index]
        G.FUNCS[button.config.button](button)
    end
    if KeyVoucher.selection.type == KeyVoucher.selection_types.TABS then
        KeyVoucher:switch_tab(KeyVoucher.selection.item, offset)
    end
    if (KeyVoucher.selection.type == KeyVoucher.selection_types.CARD) then
        local card = KeyVoucher.selection.item
        local area = card.area
        local index = getKeyByValue(area.cards, card)
        local target = index + offset
        if (target < 1) or (target > #area.cards) then return end
        area.cards[index] = area.cards[target]
        area.cards[target] = card
        KeyVoucher:select_item_gamepad(area.cards[index])
    end
end

function KeyVoucher:secondary_action_callback()
    -- TODO: this looks wrong
    if KeyVoucher.selection.type == KeyVoucher.selection_types.CARD then return end
    local card = KeyVoucher.selection.item
    local area = card.area
    if card:can_sell_card() then
        G.FUNCS.sell_card({ config = { ref_table = card } })
        KeyVoucher:resetLastCard()
    end

    if G.STATE == G.STATES.SHOP and KeyVoucher.mod_last_type == KeyVoucher.MODS.DEFAULT then
        local buy_use_button = card.children.buy_and_use_button
        if buy_use_button and buy_use_button.UIRoot.config.button then
            G.FUNCS.buy_from_shop(buy_use_button.UIRoot)
            KeyVoucher:resetLastCard()
        end
    end
end

-- 
--    RUN HANDLERS
-- 

function KeyVoucher:handle_selection(num)
    local affected_area = KeyVoucher:getAffectedArea(KeyVoucher.mod_active_type)
    if affected_area == nil then return end

    local shorter_addition = 0
    if KeyVoucher.total_addition > 0 and #affected_area.cards > 10 then
        shorter_addition = KeyVoucher.total_addition % ((#affected_area.cards - 1) / 10 * 10) 
    end
    num = num + shorter_addition
    KeyVoucher.total_addition = 0
    if num > #affected_area.cards then num = #affected_area.cards end
    if num <= 0 then return end

    if KeyVoucher.mod_active_type ~= KeyVoucher.mod_last_type and KeyVoucher.mod_last_type ~= KeyVoucher.MODS.DEFAULT then
        local affected_old = KeyVoucher:getAffectedArea(KeyVoucher.mod_last_type)
        if affected_old then KeyVoucher:unhighlight(affected_old) end
    end
    local card = affected_area.cards[num]
    if affected_area == G.hand then
        if card.highlighted then
            G.hand:remove_from_highlighted(card, false)
            play_sound('cardSlide2', nil, 0.3)
        else
            G.hand:add_to_highlighted(card)
        end
    else
        KeyVoucher:unhighlight(affected_area)
    end
    KeyVoucher:select_item_gamepad(card)
    KeyVoucher.last_card = num
    KeyVoucher.mod_last_type = KeyVoucher.mod_active_type
    KeyVoucher.mod_active_type = KeyVoucher.MODS.DEFAULT
    KeyVoucher:update_selected_card()
    KeyVoucher:update_selected_mod()
    KeyVoucher:select_action_callback()
end

function KeyVoucher:handle_mods(new_mode)
    if KeyVoucher.mod_active_type ~= new_mode then
        if new_mode ~= KeyVoucher.mod_last_type and KeyVoucher.mod_last_type ~= KeyVoucher.MODS.DEFAULT then
            local affected_old = KeyVoucher:getAffectedArea(KeyVoucher.mod_last_type)
            if affected_old then KeyVoucher:unhighlight(affected_old) end
        end
        KeyVoucher.mod_active_type = new_mode
        KeyVoucher:update_selected_mod()
        return
    end -- else
    local affected_area = KeyVoucher:getAffectedArea(new_mode)
    if affected_area == nil or #affected_area.cards == 0 then return end

    KeyVoucher:unhighlight(affected_area)
    if KeyVoucher.mod_last_type == new_mode then -- Remove highlight
        KeyVoucher.mod_last_type = KeyVoucher.MODS.DEFAULT
        KeyVoucher.mod_active_type = KeyVoucher.MODS.DEFAULT
        KeyVoucher:update_selected_mod()
    else -- Hightlight first card
        KeyVoucher.mod_active_type = new_mode
        KeyVoucher:handle_selection(1)
    end
end

function KeyVoucher:find_cycle(item)
    if not item.children and
        #item.children ~= 3 then return false end
    local child = item.children[1]
    if not child then return false end
    if not child.config then return false end
    if child.config.button == "option_cycle" then return true
    else return false end
end

function KeyVoucher:switch_tab(item, tab_shift)
    if not item or not item.children then return end
    local tabs = item.children
    local selected_tab = -1 -- if not found
    for i, tab in ipairs(tabs) do
        if tab.children[1].config.chosen then
            selected_tab = i
            break
        end
    end
    if selected_tab == -1 then return end
    local new_tab = ((selected_tab + tab_shift + #tabs - 1) % (#tabs)) + 1
    tabs[selected_tab].children[1].config.chosen = nil
    tabs[new_tab].children[1].config.chosen = true
    G.FUNCS.change_tab(tabs[new_tab].children[1])
end

function KeyVoucher:add_key_hint(item, action)
    local tome = item.UIRoot.children[1].children[1].children[1]
    local txt = keysToKeyText(getKeyByValue(Keybindings.keys_to_overlay, action))
    tome.children.button_pip_kbd = UIBox{
    definition = {n=G.UIT.C, config = {align = "cm", colour=G.C.CLEAR}, nodes = {
            {n=G.UIT.T, config={text = txt, scale = 0.3, shadow = true}},
        }},
    config = {
        align= 'cm',
        offset = {x = 0.1, y = 0.02},
        major = tome, parent = tome, bond = 'Strong'}
    }
    tome.children.button_pip_kbd.states.collide.can = false
end

function KeyVoucher:select_item_gamepad(item)
    G.CONTROLLER:snap_to{ node = item }
end

function KeyVoucher:help_action_callback()
    if KeyVoucher.meta_active_type == KeyVoucher.OVERLAY.HELP then
        -- Help menu is already up, toggle it off
        G.keybind_help:remove()
        G.keybind_help = nil
        KeyVoucher.meta_active_type = 0
        return -- early
    end

    -- Show the help menu
    G.keybind_help = UIBox{
        definition = KeyVoucher:create_help_menu(),
        config = {align='cr', offset = {x=G.ROOM.T.x + 11,y=0},major = G.ROOM_ATTACH, bond = 'Weak'}
    }
    KeyVoucher:update_selected_card()
    KeyVoucher:update_selected_mod()
    KeyVoucher.meta_active_type = KeyVoucher.OVERLAY.HELP
end

function KeyVoucher:create_help_menu()
    return {n=G.UIT.ROOT, config={align = "cm", colour = G.C.JOKER_GREY, r = 0.1, emboss = 0.05, padding = 0.07}, nodes={
        {n=G.UIT.R, config = {align = "cm", padding= 0.03, colour = G.C.UI.TRANSPARENT_DARK, r=0.1}, nodes={
            {n=G.UIT.R, config = {align = "cm", padding= 0.05, colour = G.C.DYN_UI.MAIN, r=0.1}, nodes={
                {n=G.UIT.R, config={align = "cl", colour = G.C.DYN_UI.BOSS_DARK, r=0.1, padding = 0.08, minw = 100}, nodes={
                    {n=G.UIT.R, config={id = "keybind_tooltip_content", align = "cl", padding = 0.05}, nodes={
                        {n=G.UIT.R, config={align = "cl"}, nodes={
                            {n=G.UIT.T, config={text = "Selected: ", scale = 0.4, colour = G.C.WHITE, shadow = true}},
                            {n=G.UIT.C, config={colour = G.C.SECONDARY_SET.Default, shadow = true, padding = 0.15, r = 0.05}, nodes={
                                {n=G.UIT.T, config={id = "selected_card_name", text = "Selected: ", scale = 0.4, colour = G.C.WHITE, shadow = true}},
                            }},
                        }},
                    }},
                    {n=G.UIT.R, config={align = "cl", padding = 0.05}, nodes={
                        {n=G.UIT.R, config={align = "cl", r = 0.1, colour = G.C.BLACK}, nodes={
                            {n=G.UIT.C, config={colour = G.C.SECONDARY_SET.Default, padding = 0.1, r = 0.1, align="m"}, nodes={
                                {n=G.UIT.T, config={id = "selected_card_mod", text = "Voucher", scale = 0.3, colour = G.C.WHITE, shadow = true}},
                            }},
                            {n=G.UIT.T, config={text = " slot ", scale = 0.3, colour = G.C.WHITE}},
                            {n=G.UIT.C, config={colour = G.C.L_BLACK, padding = 0.1, r = 0.1, align="m"}, nodes={
                                {n=G.UIT.T, config={id = "selected_card_num", text = "1", scale = 0.3, colour = G.C.WHITE, shadow = true}},
                            }},
                        }},
                    }},
                    {n=G.UIT.R, config={align = "cl", padding = 0.05}, nodes={
                        {n=G.UIT.R, config={align = "cl", padding = 0.05}, nodes={
                            {n=G.UIT.T, config={text = "Will select: ", scale = 0.4, colour = G.C.WHITE}},
                            {n=G.UIT.C, config={colour = G.C.SECONDARY_SET.Default, shadow = true, padding = 0.15, r = 0.05, align="m"}, nodes={
                                {n=G.UIT.T, config={id = "selected_mod", text = "Cards", scale = 0.4, colour = G.C.WHITE, shadow = true}},
                            }},
                        }},
                    }},
                }},
            }},
        }},
    }}
end

function KeyVoucher:create_overlay_selection()
    return {n=G.UIT.ROOT, config={align = "cm", colour = G.C.UI.TRANSPARENT_DARK, minw = 0.5, minh = 0.5, outline = 1, outline_colour = G.C.RED, r = 0.1}, nodes={
        {n=G.UIT.R, nodes= {
            {n=G.UIT.T, config={id = "overlay_selection", scale = 0.3, colour = G.C.WHITE, text = "B"}, nodes=nil}
        }}
    }}
end

function KeyVoucher:update_selected_card()
    if not G.keybind_help then return end
    local label = G.keybind_help:get_UIE_by_ID("selected_card_name")
    local mod = G.keybind_help:get_UIE_by_ID("selected_card_mod")
    local num = G.keybind_help:get_UIE_by_ID("selected_card_num")
    if KeyVoucher.last_card == 0 then
        label.config.text = "Nothing selected"
        label.parent.config.colour = G.C.SECONDARY_SET.Default
        mod.config.text = ""
        num.config.text = ""
        mod.parent.parent.states.visible = false
    else
        local card = KeyVoucher:getAffectedArea(KeyVoucher.mod_last_type).cards[KeyVoucher.last_card]
        label.config.text = card.label 
        label.parent.config.colour = G.C.SECONDARY_SET[card.ability.set] or G.C.BOOSTER
        mod.parent.parent.states.visible = true
        mod.config.text = " " .. KeyVoucher.mod_dict[KeyVoucher.mod_last_type].name .. " "
        mod.parent.config.colour = KeyVoucher.mod_dict[KeyVoucher.mod_last_type].colour
        num.config.text = " " .. tostring(KeyVoucher.last_card) .. " "
    end
    G.keybind_help:recalculate()
    label.parent:juice_up(0.1, 0.2)
    label:juice_up(0.1, 0.1)
    KeyVoucher:slide_tooltip()
end

function KeyVoucher:update_selected_mod()
    if not G.keybind_help then return end
    local label = G.keybind_help:get_UIE_by_ID("selected_mod")
    label.config.text = KeyVoucher.mod_dict[KeyVoucher.mod_active_type].name
    label.parent.config.colour = KeyVoucher.mod_dict[KeyVoucher.mod_active_type].colour
    G.keybind_help:recalculate()
    label.parent:juice_up(nil, 0.2)
    label:juice_up(nil, 0.1)
    KeyVoucher:slide_tooltip()
end

function KeyVoucher:slide_tooltip()
    local coord = G.ROOM.T.x - G.keybind_help:get_UIE_by_ID("keybind_tooltip_content").T.w - 0.5
    G.E_MANAGER:add_event(Event({
        blockable = false,
        func = function()
            G.keybind_help.alignment.offset.x = coord
            return true
        end
    }))
end

-- 
--    RUN STATE PRESS CALLBACKS
-- 

function KeyVoucher:hand_press_callback(key)
    if tableContains(Keybindings.keys_to_run, key) == false then return end

    local action = Keybindings.keys_to_run[key]
    if action == KeyVoucher.RUN_ACTIONS.PLAY and not G.deck_preview then
        local play_button = G.buttons:get_UIE_by_ID('play_button')
        if play_button.config.button then
            G.FUNCS.play_cards_from_highlighted()
        end
    elseif action == KeyVoucher.RUN_ACTIONS.DISCARD then
        local discard_button = G.buttons:get_UIE_by_ID('discard_button')
        if discard_button.config.button then
            G.FUNCS.discard_cards_from_highlighted()
        end
    elseif action == KeyVoucher.RUN_ACTIONS.SORT_RANK then
        G.FUNCS.sort_hand_value()
    elseif action == KeyVoucher.RUN_ACTIONS.SORT_SUIT then
        G.FUNCS.sort_hand_suit()
    elseif action == KeyVoucher.RUN_ACTIONS.PEEK_DECK then
        G.buttons.states.visible = false
        G.deck_preview = UIBox{
            definition = G.UIDEF.deck_preview(),
            config = {align='tm', offset = {x=0,y=-0.8},major = G.hand, bond = 'Weak'}
        }
    end
end

function KeyVoucher:blind_press_callback(key)
    if G.blind_select == nil then return end
    if tableContains(Keybindings.keys_to_run, key) == false then return end

    local action = Keybindings.keys_to_run[key]
    if action == KeyVoucher.RUN_ACTIONS.HOVER_TAG then
        local current_blind = G.blind_select:get_UIE_by_ID(G.GAME.blind_on_deck)
        local skip_blind = G.blind_select:get_UIE_by_ID('tag_container', current_blind)
        if skip_blind then
            local tag_button = skip_blind.children[2].children[2]
            if tag_button.config.button then 
                KeyVoucher:select_item_gamepad(tag_button) 
            end
        end
    elseif action == KeyVoucher.RUN_ACTIONS.PLAY then
        local select_blind_button = G.blind_select:get_UIE_by_ID(G.GAME.blind_on_deck).UIBox:get_UIE_by_ID('select_blind_button')
        if select_blind_button then G.FUNCS.select_blind(select_blind_button) end
    elseif action == KeyVoucher.RUN_ACTIONS.DISCARD then
        local current_blind = G.blind_select:get_UIE_by_ID(G.GAME.blind_on_deck)
        local skip_blind_button = G.blind_select:get_UIE_by_ID('tag_container', current_blind)
        if skip_blind_button then G.FUNCS.skip_blind(skip_blind_button) end
    elseif action == KeyVoucher.RUN_ACTIONS.REROLL then
        local row_blind = G.blind_prompt_box:get_UIE_by_ID('prompt_dynatext1').parent.parent.children[3]
        if row_blind then
            local reroll_blind_button = row_blind.children[1]
            if reroll_blind_button.config.button == "reroll_boss" then
                G.FUNCS.reroll_boss(reroll_blind_button)
            end
        end
    end
end

function KeyVoucher:shop_press_callback(key)
    if G.shop == nil then return end
    if tableContains(Keybindings.keys_to_run, key) == false then return end

    local action = Keybindings.keys_to_run[key]
    if action == KeyVoucher.RUN_ACTIONS.PLAY then
        G.FUNCS.toggle_shop()
    elseif action == KeyVoucher.RUN_ACTIONS.REROLL then
        local reroll_shop_button = G.shop:get_UIE_by_ID('next_round_button').parent.children[2]
        -- if config.button is empty, then we cannot reroll because player is bankrupt
        if reroll_shop_button.config.button then
            G.FUNCS.reroll_shop(reroll_shop_button)
        end
    end
end

function KeyVoucher:pack_press_callback(key)
    if tableContains(Keybindings.keys_to_run, key) == false then return end

    if Keybindings.keys_to_run[key] == KeyVoucher.RUN_ACTIONS.DISCARD then
        G.FUNCS.skip_booster()
    end
end

function KeyVoucher:round_press_callback(key)
    if tableContains(Keybindings.keys_to_run, key) == false then return end

    if Keybindings.keys_to_run[key] == KeyVoucher.RUN_ACTIONS.PLAY and G.round_eval then
        local button = KeyVoucher:searchUIBoxWithID('cash_out_button')
        if button and button.config.button then
            G.FUNCS.cash_out(button)
        end
    end
end

local keyrelease_ref = Controller.key_release_update
function Controller.key_release_update(self, key, dt)
    keyrelease_ref(self, key, dt)
    if tableContains(Keybindings.keys_to_overlay, key) then
        local action = Keybindings.keys_to_overlay[key]
        if  action == KeyVoucher.OVERLAY.SELECTION_UP or
            action == KeyVoucher.OVERLAY.SELECTION_DOWN or
            action == KeyVoucher.OVERLAY.SELECTION_LEFT or
            action == KeyVoucher.OVERLAY.SELECTION_RIGHT then
            if KeyVoucher.hold_times[action] > 0 then
                KeyVoucher.hold_times[action] = 0
            end
        end
    end
    if G.STAGE == G.STAGES.RUN then
        if KeyVoucher.release_state_callback[G.STATE] then
            KeyVoucher.release_state_callback[G.STATE](key)
        end
    end
end

function KeyVoucher:hand_release_callback(key)
    if tableContains(Keybindings.keys_to_run, key) == false then return end

    if Keybindings.keys_to_run[key] == KeyVoucher.RUN_ACTIONS.PEEK_DECK then
        if G.deck_preview then
            G.buttons.states.visible = true
            G.deck_preview:remove()
            G.deck_preview = nil
        end
    end
end

function KeyVoucher:tag_hover(e)
    -- Most of the code here is copied from G.FUNCS.hover_tag_proxy - 
    -- however, we use a different variable name so engine wouldn't
    -- try to hide our infotip

    -- TODO: use gamepad instead
    e.parent.states.hover.is = not e.parent.states.hover.is
    e.states.hover.is = not e.states.hover.is
    e.parent.states.collide.is = not e.parent.states.collide.is
    e.states.collide.is = not e.states.collide.is
    local _sprite = e.config.ref_table:get_uibox_table()
    if e.parent.children.kalert then
        e.parent.children.kalert:remove()
        e.parent.children.kalert = nil
    else
        e.parent.children.kalert = UIBox{
            definition = G.UIDEF.card_h_popup(_sprite),
            config = {align="tm", offset = {x = 0, y = -0.1},
            major = e.parent,
            instance_type = 'POPUP'},
        }
        e.parent.children.kalert.states.collide.can = false
    end
    _sprite:juice_up(0.05, 0.02)
    play_sound('paper1', math.random()*0.1 + 0.55, 0.42)
    play_sound('tarot2', math.random()*0.1 + 0.55, 0.09)
end

local keyhold_ref = Controller.key_hold_update
function Controller.key_hold_update(self, key, dt)
    keyhold_ref(self, key, dt)
    if tableContains(Keybindings.keys_to_overlay, key) then
        local action = Keybindings.keys_to_overlay[key]
        if  action == KeyVoucher.OVERLAY.SELECTION_UP or
            action == KeyVoucher.OVERLAY.SELECTION_DOWN or
            action == KeyVoucher.OVERLAY.SELECTION_LEFT or
            action == KeyVoucher.OVERLAY.SELECTION_RIGHT then
            KeyVoucher.hold_times[action] = KeyVoucher.hold_times[action] + dt
            local threshold = 0.25 -- seconds between retriggers
            if KeyVoucher.hold_times[action] > threshold then
                KeyVoucher.action_callbacks[action]()
                KeyVoucher.hold_times[action] = KeyVoucher.hold_times[action] - threshold
            end
        end
    end
    if G.STAGE == G.STAGES.RUN then
        if KeyVoucher.hold_state_callback[G.STATE] then
            KeyVoucher.hold_state_callback[G.STATE](key, dt)
        end

    end
end

function KeyVoucher:shop_hold_callback(key, dt)
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

function KeyVoucher:getAffectedArea(type)
    if type == KeyVoucher.MODS.DEFAULT then
        if G.STATE == G.STATES.SHOP then
            return G.shop_jokers
        elseif G.STATE == G.STATES.STANDARD_PACK or G.STATE == G.STATES.BUFFOON_PACK or G.STATE == G.STATES.PLANET_PACK then
            return G.pack_cards
        else
            return G.hand
        end
    elseif type == KeyVoucher.MODS.JOKER then
        return G.jokers
    elseif type == KeyVoucher.MODS.CONSUMABLE then
        return G.consumeables
    elseif type == KeyVoucher.MODS.VOUCHER then
        if G.STATE == G.STATES.SHOP then
            return G.shop_vouchers
        else 
            return nil
        end
    elseif type == KeyVoucher.MODS.BOOSTER then
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

function KeyVoucher:getModFromArea(area)
    if area == G.shop_jokers or area == G.hand then
        return KeyVoucher.MODS.DEFAULT
    elseif area == G.jokers then
        return KeyVoucher.MODS.JOKER
    elseif area == G.consumeables then
        return KeyVoucher.MODS.CONSUMABLE
    elseif area == G.shop_vouchers then
        return KeyVoucher.MODS.VOUCHER
    elseif area == G.shop_booster then
        return KeyVoucher.MODS.BOOSTER
    elseif area == G.pack_cards and G.STATE == G.STATES.SPECTRAL_PACK or G.STATE == G.STATES.TAROT_PACK then
        return KeyVoucher.MODS.BOOSTER
    elseif area == G.pack_cards then return KeyVoucher.MODS.DEFAULT
    end
    return 0
end

function KeyVoucher:unhighlight(area)
    if #area.highlighted > 0 then
        for i = 1, #area.highlighted, 1 do
            area.highlighted[i]:stop_hover()
        end
    end
    area:unhighlight_all()
end

function KeyVoucher:resetLastCard()
    KeyVoucher.last_card = 0
    KeyVoucher.mod_last_type = KeyVoucher.MODS.DEFAULT
    KeyVoucher.mod_active_type = KeyVoucher.MODS.DEFAULT
    KeyVoucher:update_selected_mod()
    KeyVoucher:update_selected_card()
end

function tprint(tbl, indent)
    if not indent then indent = 0 end
    if not tbl then return "nil" end
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

function getTableType(t)
    if next(t) == nil then return "Empty" end
    local isArray = true
    local isDictionary = true
    for k, _ in next, t do
        if type(k) == "number" and k%1 == 0 and k > 0 then
            isDictionary = false
        else
            isArray = false
        end
    end
    if isArray then
        return "Array"
    elseif isDictionary then
        return "Dictionary"
    else
        return "Mixed"
    end
end

function KeyVoucher:searchUIBoxWithID(id)
    for k, category in pairs(G.I) do
        for i, v in ipairs(category) do
            if v.UIBox or v.UIRoot then
                local search = v:get_UIE_by_ID(id)
                if search then
                    if search.config.one_press then
                        -- one_press button need to be looked up once as well.
                        -- If we see a one_press button that we once returned,
                        -- we skip it.
                        if not search.looked_up then
                            search.looked_up = true
                            return search
                        end
                    elseif not search.looked_up and not search.REMOVED then
                        return search 
                    end
                end
            end
        end
    end
    return nil
end

function getKeyByValue(table, value)
    if not table then return nil end
    for k, v in pairs(table) do
        if v == value then return k end
    end
    return nil
end

function keysToKeyText(key_string)
    local key_dict = {
        -- Some of the button names are shortened to 5 letters or less
        -- Sorry, but we won't distinguish left from right sometimes because of that
        ["return"] = "ENTER",
        ["backspace"] = "BACK",
        ["capslock"] = "CAPS",
        ["kp0"] = "KP 0",
        ["kp1"] = "KP 1",
        ["kp2"] = "KP 2",
        ["kp3"] = "KP 3",
        ["kp4"] = "KP 4",
        ["kp5"] = "KP 5",
        ["kp6"] = "KP 6",
        ["kp7"] = "KP 7",
        ["kp8"] = "KP 8",
        ["kp9"] = "KP 9",
        ["kp."] = "KP .",
        ["kp/"] = "KP /",
        ["kp*"] = "KP *",
        ["kp-"] = "KP -",
        ["kp+"] = "KP +",
        ["kp="] = "KP =",
        ["kp,"] = "KP ,",
        ["kpenter"] = "KP >",
        ["insert"] = "INS",
        ["delete"] = "DEL",
        ["pageup"] = "PG UP",
        ["pagedown"] = "PG DN",
        ["numlock"] = "NUM L",
        ["scrolllock"] = "SCR L",
        ["escape"] = "ESC",
        ["sysreq"] = "SYSRQ",
        ["application"] = "APP",
        ["printscreen"] = "PRTSC",
        ["currencyunit"] = "CUNIT",
        ["lctrl"] = "CTRL",
        ["rctrl"] = "CTRL",
        ["lalt"] = "L ALT",
        ["ralt"] = "R ALT",
        ["lshift"] = "SHIFT",
        ["rshift"] = "SHIFT",
        -- Yeah, those are buttons. See https://www.love2d.org/wiki/KeyConstant
        ["calculator"] = "CALC",
        ["computer"] = "PC",
        ["appsearch"] = "APP S",
        ["apphome"] = "APP H",
        ["appback"] = "APP B",
        ["appforward"] = "APP F",
        ["apprefresh"] = "APP R",
        ["appbookmarks"] = "APP M",
    }
    if tableContains(key_dict, key_string) then
        return key_dict[key_string]
    elseif key_string == 'lgui' or key_string == 'rgui' then
        if love.system.getOS() == 'Windows' then 
            if key_string == 'lgui' then return 'L WIN' end
            if key_string == 'rgui' then return 'R WIN' end
        end
        if love.system.getOS() == 'OS X' then 
            if key_string == 'lgui' then return 'L CMD' end
            if key_string == 'rgui' then return 'R CMD' end
        end
    else return string.upper(key_string or '') end
end

-- 
--    OTHER GAME FUNCTION DECORATORS
-- 

local hijack_cash_out = G.FUNCS.cash_out
function G.FUNCS.cash_out(e)
    KeyVoucher:resetLastCard()
    hijack_cash_out(e)
end

local hijack_play_hand = G.FUNCS.play_cards_from_highlighted
function G.FUNCS.play_cards_from_highlighted(e)
    -- Remove hover from any playing cards
    if #G.hand.highlighted > 0 then
        for i = 1, #G.hand.highlighted, 1 do
            G.hand.highlighted[i]:stop_hover()
        end
    end
    KeyVoucher:resetLastCard()
    hijack_play_hand(e)
end

local hijack_reroll_shop = G.FUNCS.reroll_shop
function G.FUNCS.reroll_shop(e)
    KeyVoucher:resetLastCard()
    hijack_reroll_shop(e)
end

local hijack_end_consumable = G.FUNCS.end_consumeable
function G.FUNCS.end_consumeable(a, b)
    KeyVoucher:resetLastCard()
    hijack_end_consumable(a, b)
end

local hj_bt_press_update = Controller.button_press_update
function Controller:button_press_update(button, dt)
    sendDebugMessage("Called button press update with args: " .. button .. "\ndeltatime: " .. tostring(dt))
    hj_bt_press_update(self, button, dt)
end

local hj_bt_press = Controller.button_press
function Controller:button_press(button)
    sendDebugMessage("Called button press with arg: " .. button)
    hj_bt_press(self, button)
end

local hj_bt_release = Controller.button_release
function Controller:button_release(button)
    sendDebugMessage("Called button_release with arg: " .. button)
    hj_bt_release(self, button)
end

local hijack_update_focus = Controller.update_focus
function Controller:update_focus(dir)
    if self.HID ~= nil then
        local temp = self.HID.controller
        self.HID.controller = KeyVoucher.key_movement
        hijack_update_focus(self, dir)
        self.HID.controller = temp
    end
end

local hijack_set_cursor_position = Controller.set_cursor_position
function Controller:set_cursor_position()
    local cursor_position = { x = 0, y = 0 }
    cursor_position.x, cursor_position.y = love.mouse.getPosition()
    local tx = cursor_position.x/(G.TILESCALE*G.TILESIZE)
    local ty = cursor_position.y/(G.TILESCALE*G.TILESIZE)
    self:get_cursor_collision({x = tx, y = ty})
    local has_hoverable = false
    for k, v in pairs(self.collision_list) do
        if v.states.focus.can then
            has_hoverable = true
            break
        end
    end
    if (cursor_position.x ~= KeyVoucher.last_mouse_position.x or cursor_position.y ~= KeyVoucher.last_mouse_position.y) and has_hoverable then
        KeyVoucher.key_movement = false
        KeyVoucher.selection = nil
        KeyVoucher.last_mouse_position.x = cursor_position.x
        KeyVoucher.last_mouse_position.y = cursor_position.y
    end
    if not KeyVoucher.key_movement then
        hijack_set_cursor_position(self)
    end
end

local hijack_ = Controller.update
function Controller:update(dt)
    local cursor_position = { x = 0, y = 0 }
    cursor_position.x, cursor_position.y = love.mouse.getPosition()
    local tx = cursor_position.x/(G.TILESCALE*G.TILESIZE)
    local ty = cursor_position.y/(G.TILESCALE*G.TILESIZE)
    self:get_cursor_collision({x = tx, y = ty})
    local has_hoverable = 0
    for k, v in ipairs(self.collision_list) do
        if v.states.focus.can then
            has_hoverable = k
            break
        end
    end
    if (cursor_position.x ~= KeyVoucher.last_mouse_position.x or cursor_position.y ~= KeyVoucher.last_mouse_position.y) and has_hoverable ~= 0 then
        KeyVoucher.key_movement = false
        KeyVoucher.selection = nil
        KeyVoucher.last_mouse_position.x = cursor_position.x
        KeyVoucher.last_mouse_position.y = cursor_position.y
    end
    KeyVoucher.temp = self.HID.controller
    self.HID.controller = KeyVoucher.key_movement
    hijack_(self, dt)
    self.HID.controller = KeyVoucher.temp
end

local hj_axis = Controller.update_axis
function Controller:update_axis(dt)
    local temp = self.HID.controller
    self.HID.controller = KeyVoucher.temp
    hj_axis(self, dt)
    self.HID.controller = temp
end

local hook_settings = create_UIBox_settings
function create_UIBox_settings()
    local result = hook_settings()
    local tab_container = KeyVoucher:get_UIE_by_ID('tab_shoulders', result) or KeyVoucher:get_UIE_by_ID('no_shoulders', result)
    table.insert(tab_container.nodes, KeyVoucher:add_settings_tab_button())
    local tab_item = {
        label = 'Keyboard',
        chosen = false,
        tab_definition_function = function() return KeyVoucher:add_settings_screen() end,
      }
    table.insert(tab_container.config.ref_table.tabs, tab_item)
    return result
end

---
--- orderedPairs implementation
---

function __genOrderedIndex( t )
    local orderedIndex = {}
    for key in pairs(t) do
        table.insert( orderedIndex, key )
    end
    table.sort( orderedIndex )
    return orderedIndex
end

function orderedNext(t, state)
    -- Equivalent of the next function, but returns the keys in the alphabetic
    -- order. We use a temporary ordered key table that is stored in the
    -- table being iterated.

    local key = nil
    if state == nil then
        -- the first time, generate the index
        t.__orderedIndex = __genOrderedIndex( t )
        key = t.__orderedIndex[1]
    else
        -- fetch the next value
        for i = 1,table.getn(t.__orderedIndex) do
            if t.__orderedIndex[i] == state then
                key = t.__orderedIndex[i+1]
            end
        end
    end

    if key then
        return key, t[key]
    end

    -- no more value to return, cleanup
    t.__orderedIndex = nil
    return
end

function orderedPairs(t)
    -- Equivalent of the pairs() function on tables. Allows to iterate
    -- in order
    return orderedNext, t, nil
end

---

function KeyVoucher:add_settings_tab_button()
    local tab_item = {
        label = 'Keyboard',
        chosen = false,
        tab_definition_function = function() return KeyVoucher:add_settings_screen() end,
      }
    if not KeyVoucher.settings_screen then KeyVoucher.settings_screen = {} end
    KeyVoucher.settings_screen.button = UIBox_button({id = 'tab_but_' .. (tab_item.label), ref_table = tab_item, button = 'change_tab', label = {tab_item.label}, minh = 0.8, minw = 2.5, col = true, choice = true, scale = 0.5, chosen = false, func = nil, focus_args = {type = 'none'}})
    return KeyVoucher.settings_screen.button
end

function KeyVoucher:generate_settings_items()
    KeyVoucher.settings_screen.binding_items = {}
    for key, value in orderedPairs(KeyVoucher.ui_dict) do
        if not (key == "headers") then 
            if (#KeyVoucher.settings_screen.binding_items % KeyVoucher.settings_screen.items_per_page) == (KeyVoucher.settings_screen.items_per_page - 1) then
                table.insert(KeyVoucher.settings_screen.binding_items, KeyVoucher:add_empty_slot())
            end
            table.insert(KeyVoucher.settings_screen.binding_items, KeyVoucher:add_category_header({ header_text = KeyVoucher.ui_categories[key] }))
            for k, v in orderedPairs(value) do
                local key_txt = keysToKeyText(getKeyByValue(Keybindings[key], k) or '')
                local args = {
                    desc = v.desc,
                    id_desc = v.id_desc,
                    category = key,
                    key_text = key_txt,
                    key = k,
                    arr = Keybindings.keys_to_acts
                }
                table.insert(KeyVoucher.settings_screen.binding_items, KeyVoucher:add_bind_button(args))
            end
        end
    end
end

function KeyVoucher:add_settings_screen()
    if not KeyVoucher.settings_screen.selected_page then KeyVoucher.settings_screen.selected_page = 1 end
    KeyVoucher.settings_screen.key_options = {}
    KeyVoucher.settings_screen.items_per_page = 8

    KeyVoucher:generate_settings_items()
    
    -- adding pages
    KeyVoucher.settings_screen.item_count = #KeyVoucher.settings_screen.binding_items
    KeyVoucher.settings_screen.total_pages = math.ceil(KeyVoucher.settings_screen.item_count/KeyVoucher.settings_screen.items_per_page)
    for i = 1, KeyVoucher.settings_screen.total_pages do
        table.insert(KeyVoucher.settings_screen.key_options, localize('k_page')..' '..tostring(i)..'/'..tostring(KeyVoucher.settings_screen.total_pages))
    end

    KeyVoucher:populate_settings_page()

    KeyVoucher.settings_screen.root = {n=G.UIT.ROOT, config={align = "cm", colour = G.C.CLEAR}, nodes={
        {n=G.UIT.R, config={align = "tm", colour = G.C.CLEAR, padding = 0.1, minh = 6.6}, nodes={
            {n=G.UIT.O, config = {id = "binding_list_object", object = UIBox{config={}, definition=KeyVoucher.settings_screen.page} }},
        }}, 
        {n=G.UIT.R, config={id = "binding_option_container", align = "cm", colour = G.C.CLEAR}, nodes={
            create_option_cycle({options = KeyVoucher.settings_screen.key_options, w = 4.5, cycle_shoulders = true, opt_callback = 'keyvoucher_settings_change_page', current_option = KeyVoucher.settings_screen.selected_page, colour = G.C.RED, no_pips = true, focus_args = {snap_to = true, nav = 'wide'}})
        }},
    }}

    return KeyVoucher.settings_screen.root
end

function KeyVoucher:populate_settings_page()
    local end_index = KeyVoucher.settings_screen.selected_page * KeyVoucher.settings_screen.items_per_page
    if end_index > KeyVoucher.settings_screen.item_count then end_index = KeyVoucher.settings_screen.item_count end
    local start_index = (KeyVoucher.settings_screen.selected_page - 1) * KeyVoucher.settings_screen.items_per_page + 1
    KeyVoucher.settings_screen.page_items = {}
    for i = start_index, end_index do
        table.insert(KeyVoucher.settings_screen.page_items, KeyVoucher.settings_screen.binding_items[i])
    end
    KeyVoucher.settings_screen.page = 
        {n=G.UIT.ROOT, config = {id = "binding_list", colour = G.C.CLEAR}, nodes=KeyVoucher.settings_screen.page_items}
end

function KeyVoucher:add_bind_button(args)
    return {n=G.UIT.R, config = {align = "cm", ARGS = args, padding = 0.1}, nodes = {
        {n=G.UIT.C, config = {align = "cl", padding = 0.1, minw = 5, colour = G.C.CLEAR}, nodes = {
            {n=G.UIT.T, config = {text = args.desc, scale = 0.4, colour = G.C.WHITE, shadow = true}}
        }},
        UIBox_button({id = 'keybind-'..(args.category)..'-'..(args.id_desc), button = 'keyvoucher_activate_binding_change', label = {args.key_text}, minh = 0.6, minw = 2, col = true, choice = true, scale = 0.4, chosen = false, func = nil}),
        UIBox_button({id = 'keybind-'..(args.category)..'-'..(args.id_desc)..'-secondary', button = 'keyvoucher_activate_binding_change', label = {''}, minh = 0.6, minw = 2, col = true, choice = true, scale = 0.4, chosen = false, func = nil, colour = G.C.ORANGE}),
    }}
end

function KeyVoucher:add_category_header(args)
    return {n=G.UIT.R, config= {align = "cm", ARGS=args, padding = 0.1, minh = 0.8}, nodes = {
        {n=G.UIT.T, config = {text = args.header_text, scale = 0.5, colour = G.C.WHITE, shadow = true}}
    }}
end

function KeyVoucher:add_empty_slot(args)
    return {n=G.UIT.R, config= {align = "cm", ARGS=args, padding = 0.1, minh = 0.8}}
end

function G.FUNCS.keyvoucher_settings_change_page(args)
    if not args or not args.cycle_config then return end
    KeyVoucher.settings_screen.selected_page = args.to_key
    KeyVoucher:populate_settings_page()
    KeyVoucher.settings_screen.root.nodes[1].nodes = KeyVoucher.settings_screen.page_items
    local focused = G.CONTROLLER.focused.target or G.OVERLAY_MENU
    local blist = (focused.UIRoot ~= nil and focused) or focused.UIBox
    blist = blist:get_UIE_by_ID('binding_list_object')
    local bparent = blist.parent
    blist.config.object = UIBox{config={parent=blist}, definition=KeyVoucher.settings_screen.page}
end

function G.FUNCS.keyvoucher_activate_binding_change(args)
    sendDebugMessage(args.config.id)
    KeyVoucher.waiting_for_input = true
    local _, _, category, item = string.find(args.config.id, "keybind%-([^%-]+)%-([^%-]+)")
    local isSecondary = string.match(args.config.id, "-secondary$")
    sendDebugMessage(item..' '..(category)..' '..tostring(isSecondary))
    KeyVoucher.bind_to_fill = {
        --
    }
end

function KeyVoucher:get_UIE_by_ID(id, node)
    if node.config and node.config.id == id then return node end
    for k, v in pairs(node.nodes) do
        local res = self:get_UIE_by_ID(id, v)
        if res then
            return res
        elseif v.config.object and v.config.object.get_UIE_by_ID then
            res = v.config.object:get_UIE_by_ID(id, nil)
            if res then
                return res
            end
        end
    end
    return nil
end

----------------------------------------------
------------MOD CODE END----------------------
