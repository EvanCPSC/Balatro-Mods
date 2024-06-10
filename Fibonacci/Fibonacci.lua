--- STEAMODDED HEADER
--- MOD_NAME: Fibonacci
--- MOD_ID: fib
--- MOD_AUTHOR: [Surrealreal_]
--- MOD_DESCRIPTION: Adds Fibonacci hands
--- VERSION: 1.0.0


local fib_level = function(n, wants_mult)
    local memo_mult = {2, 3}
    local solve_mult = function(n)
        if n <= #memo_mult then
            return memo_mult[n]
        end
        local result = solve(n-2) + solve(n-1)
        memo_mult[n] = result
        return result
    end
    local memo_chips = {21, 34}
    local solve_chips = function(n)
        if n <= #memo_chips then
            return memo_chips[n]
        end
        local result = solve(n-2) + solve(n-1)
        memo_chips[n] = result
        return result
    end
    if (wants_mult) then
        return solve_mult(n)
    end
    return solve_chips(n)
end

local flib_level = function(n, wants_mult)
    local memo_mult = {5, 8}
    local solve_mult = function(n)
        if n <= #memo_mult then
            return memo_mult[n]
        end
        local result = solve(n-2) + solve(n-1)
        memo_mult[n] = result
        return result
    end
    local memo_chips = {55, 89}
    local solve_chips = function(n)
        if n <= #memo_chips then
            return memo_chips[n]
        end
        local result = solve(n-2) + solve(n-1)
        memo_chips[n] = result
        return result
    end
    if (wants_mult) then
        return solve_mult(n)
    end
    return solve_chips(n)
end

local new_hands = {
    {name = "Fibonacci",  mult = 3,  chips = 34, level_mult = fib_level(1, true), level_chips = fib_level(1, false), order = 1, example = {{'H_A', true},{'S_8', true},{'D_5', true},{'C_3', true},{'S_2', true}}, desc = {"Fibonacci Sequence"}},
    {name = "Flushonacci",  mult = 8,  chips = 89, level_mult = flib_level(1, true), level_chips = flib_level(1, false), order = 1, example = {{'H_A', true},{'H_8', true},{'H_5', true},{'H_3', true},{'H_2', true}}, desc = {"Fibonacci Sequence of the", "same suit"}}
}

function add_localization()
    for _, v in ipairs(new_hands) do
        G.localization.misc.poker_hands[v.name] = v.name
        G.localization.misc.poker_hand_descriptions[v.name] = v.desc
    end
    init_localization()
end




function edit_global_hand_list()
    local i = 1
    while (i <= #G.handlist) do
        local j = G.handlist[i]
        if (j == "Pair") then
            table.insert(G.handlist, i, "Fibonacci")
            i = i + 1
        elseif (j == "Straight") then
            table.insert(G.handlist, i, "Flushonacci")
            i = i + 1
        end
        i = i + 1
    end
end

local evaluate_poker_hand_ref = evaluate_poker_hand
local new_evaluate_poker_hand = function(hand)
    local results = evaluate_poker_hand_ref(hand)
    
    for _, v in ipairs(new_hands) do
        results[v.name] = {}
    end
    local get_smallfib = function(hand)
        if (#hand < 3) then
            return {}
        end
        local ret = {}
        local t = {}
        local count = 0
        local fib = {false, false, false, false, false}
        for i=1, #hand do
            if (hand[i].base.value == 'Ace') then
                if (fib[1]) then
                    count = count - 1
                else
                    t[i] = hand[i]
                end
                fib[1] = true
                count = count + 1
            end
            if (hand[i].base.value == '8') then
                if (fib[2]) then
                    count = count - 1
                else
                    t[i] = hand[i]
                end
                fib[2] = true
                count = count + 1
            end
            if (hand[i].base.value == '5') then
                if (fib[3]) then
                    count = count - 1
                else
                    t[i] = hand[i]
                end
                fib[3] = true
                count = count + 1
            end
            if (hand[i].base.value == '3') then
                if (fib[4]) then
                    count = count - 1
                else
                    t[i] = hand[i]
                end
                fib[4] = true
                count = count + 1
            end
            if (hand[i].base.value == '2') then
                if (fib[5]) then
                    count = count - 1
                else
                    t[i] = hand[i]
                end
                fib[5] = true
                count = count + 1
            end
        end
        if (count < 3) then
            return {}
        end
        table.insert(ret, t)
        return ret
    end

    local get_fibonacci = function(hand)
        if (G.jokers ~= nil) and (G.jokers.cards ~= nil) and (G.jokers.cards[1] ~= nil) then
            for i = 1, #G.jokers.cards do
                if (G.jokers.cards[i].ability.name == "Spiral Clock") and not G.jokers.cards[i].debuff then
                    if #get_smallfib(hand) > 0 then
                        return get_smallfib(hand)
                    end
                end
            end
        end
        if (#hand < 5) then
            return {}
        end
        local ret = {}
        local t = {}
        local fib = {false, false, false, false, false}
        for i=1, #hand do
            if (hand[i].base.value == 'Ace') then
                if (fib[1] == true) then
                    return {}
                end
                fib[1] = true
            end
            if (hand[i].base.value == '8') then
                if (fib[2] == true) then
                    return {}
                end
                fib[2] = true
            end
            if (hand[i].base.value == '5') then
                if (fib[3] == true) then
                    return {}
                end
                fib[3] = true
            end
            if (hand[i].base.value == '3') then
                if (fib[4] == true) then
                    return {}
                end
                fib[4] = true
            end
            if (hand[i].base.value == '2') then
                if (fib[5] == true) then
                    return {}
                end
                fib[5] = true
            end
        end
        for i=1, #fib do
            if (fib[i] == false) then
                return {}
            end
            t[#t+1] = hand[i]
        end
        table.insert(ret, t)
        return ret
    end
    

    if next(get_fibonacci(hand)) and (#results["Flush"] ~= 0) then
        results["Flushonacci"] = get_fibonacci(hand)
    end

    if next(get_fibonacci(hand)) then
        results["Fibonacci"] = get_fibonacci(hand)
    end
    

    return results
end

local new_create_UIBox_current_hands = function(simple)
    local hands = {}

    local ordered_hands = {}
    for k, v in pairs(G.GAME.hands) do
        ordered_hands[v.order] = k
    end

    for k, v in ipairs(ordered_hands) do
        hands[k] = create_UIBox_current_hand_row(v, simple)
    end

    local t = {
        n = G.UIT.ROOT, 
        config = {align = "cm", minw = 3, padding = 0.1, r = 0.1, colour = G.C.CLEAR}, 
        nodes = {{
            n = G.UIT.R, 
            config = {align = "cm", padding = 0.04}, 
            nodes = hands
        }},
    }

    return t
end

init_game_object_ref = Game.init_game_object
new_init_game_object = function()
    rv = init_game_object_ref()

    for _, new_hand in ipairs(new_hands) do
        local hand_to_insert = {
            visible = true, 
            order = 1, 
            mult = new_hand.mult, 
            chips = new_hand.chips, 
            s_mult = new_hand.mult, 
            s_chips = new_hand.chips, 
            level = 1, 
            l_mult = new_hand.level_mult, 
            l_chips = new_hand.level_chips, 
            played = 0, 
            played_this_round = 0, 
            example = new_hand.example
        }
        for k, v in pairs(rv.hands) do
            if v.s_chips * v.s_mult < hand_to_insert.s_chips * hand_to_insert.s_mult then
                v.order = v.order + 1
            else
                hand_to_insert.order = hand_to_insert.order + 1
            end
        end

        rv.hands[new_hand.name] = hand_to_insert
    end

    return rv
end

local new_get_poker_hand_info = function(_cards)
    local poker_hands = evaluate_poker_hand(_cards)
    local scoring_hand = {}
    local text, disp_text, loc_disp_text = 'NULL', 'NULL', 'NULL'

    local ordered_hands = {}
    for k, v in pairs(G.GAME.hands) do
        ordered_hands[v.order] = k
    end

    for _, v in ipairs(ordered_hands) do
        if next(poker_hands[v]) then
            text = v
            scoring_hand = poker_hands[v][1]
            break
        end
    end

    disp_text = text

    if text == 'Straight Flush' then
        local min = 10
        for j = 1, #scoring_hand do
            if scoring_hand[j]:get_id() < min then min =scoring_hand[j]:get_id() end
        end
        if min >= 10 then 
            disp_text = 'Royal Flush'
        end
    end



    loc_disp_text = localize(disp_text, 'poker_hands')
    return text, loc_disp_text, poker_hands, scoring_hand, disp_text
end

function add_planets()
    local fib = SMODS.findModByID('fib')

    local sprite_planets = SMODS.Sprite:new('new_planets', fib.path, 'Planets.png', 71, 95, 'asset_atli')
    sprite_planets:register()

    local phobos = SMODS.Planet:new("Phobos", 'phobos', {hand_type = 'Fibonacci'}, {x = 0, y = 0}, nil, nil, nil, nil, nil, nil, nil, 'new_planets')
    local deimos = SMODS.Planet:new("Deimos", 'deimos', {hand_type = 'Flushonacci'}, {x = 1, y = 0}, nil, nil, nil, nil, nil, nil, nil, 'new_planets')
    
    phobos:register()
    deimos:register()
    

end


function SMODS.INIT.BJ()


    add_localization()
    edit_global_hand_list()
    add_planets()
    
    evaluate_poker_hand = new_evaluate_poker_hand
    create_UIBox_current_hands = new_create_UIBox_current_hands
    G.FUNCS.get_poker_hand_info = new_get_poker_hand_info
    Game.init_game_object = new_init_game_object

    local loc_def = {
        ["name"] = "The Golden Ratio",
        ["text"] = {
            [1] = "{X:mult,C:white}X3# {} Mult if played hand",
            [2] = "contains a {C:attention}Fibonnaci{}."
        },
        ["unlock"] = {
            "Win a run",
            "without playing",
            "a {C:attention}Fibonacci{}."
        }
    }

    local loc_def2 = {
        ["name"] = "Spiral Clock",
        ["text"] = {
            [1] = "All {C:attention}Fibonaccis{} can be",
            [2] = "made with 3 or 4 cards"
        }
    }

    local loc_def3 = {
        ["name"] = "Recurring Joker",
        ["text"] = {
            [1] = "{C:chips}+144{} chips if played hand",
            [2] = "contains a {C:attention}Fibonacci{}."
        }
    }

    local loc_def4 = {
        ["name"] = "Cynical Joker",
        ["text"] = {
            [1] = "{C:mult}+13{} mult if played hand",
            [2] = "contains a {C:attention}Fibonacci{}."
        }
    }
    -- print("planet print: ", SMODS.Planets)
    -- SMODS.Planets.phobos.use = function(self, card, area, copier)
    --     self.level_mult = fib_level(self.level, true)
    --     self.level_chips = fib_level(self.level, false)
    -- end
    -- SMODS.Planets.deimos.use = function(self, card, area, copier)
    --     self.level_mult = flib_level(self.level, true)
    --     self.level_chips = flib_level(self.level, false)
    -- end

    local j_ratio = SMODS.Joker:new("The Golden Ratio", "ratio", {extra = {xmult = 3}}, {
        x = 0,
        y = 0
    }, loc_def, 3, 8, false, false, true, true)

    SMODS.Sprite:new("j_ratio", SMODS.findModByID("fib").path, "fibjokers.png", 71, 95, "asset_atli"):register();

    j_ratio:register()

    SMODS.Jokers["j_ratio"].unlock_condition = {type = 'win_no_hand', extra = 'Fibonacci'}

    -- TODO: Change how Spiral Clock works, add new joker
    local j_clock = SMODS.Joker:new("Spiral Clock", "clock", {extra = {odds = 7, times = 1}}, {
        x = 1,
        y = 0
    }, loc_def2, 2, 6, true, false, true, true)

    SMODS.Sprite:new("j_clock", SMODS.findModByID("fib").path, "fibjokers.png", 71, 95, "asset_atli"):register();

    j_clock:register()

    local j_recurring = SMODS.Joker:new("Recurring Joker", "recurring", {extra = {chips = 144}}, {
        x = 2,
        y = 0
    }, loc_def3, 1, 4, true, false, true, true)

    SMODS.Sprite:new("j_recurring", SMODS.findModByID("fib").path, "fibjokers.png", 71, 95, "asset_atli"):register();

    j_recurring:register()

    local j_cynical = SMODS.Joker:new("Cynical Joker", "cynical", {extra = {mult = 13}}, {
        x = 3,
        y = 0
    }, loc_def4, 1, 4, true, false, true, true)

    SMODS.Sprite:new("j_cynical", SMODS.findModByID("fib").path, "fibjokers.png", 71, 95, "asset_atli"):register();

    j_cynical:register()

    local get_smallfib = function(hand)
        if (#hand < 3) then
            return {}
        end
        local ret = {}
        local t = {}
        local count = 0
        local fib = {false, false, false, false, false}
        for i=1, #hand do
            if (hand[i].base.value == 'Ace') then
                if (fib[1]) then
                    count = count - 1
                else
                    t[i] = hand[i]
                end
                fib[1] = true
                count = count + 1
            end
            if (hand[i].base.value == '8') then
                if (fib[2]) then
                    count = count - 1
                else
                    t[i] = hand[i]
                end
                fib[2] = true
                count = count + 1
            end
            if (hand[i].base.value == '5') then
                if (fib[3]) then
                    count = count - 1
                else
                    t[i] = hand[i]
                end
                fib[3] = true
                count = count + 1
            end
            if (hand[i].base.value == '3') then
                if (fib[4]) then
                    count = count - 1
                else
                    t[i] = hand[i]
                end
                fib[4] = true
                count = count + 1
            end
            if (hand[i].base.value == '2') then
                if (fib[5]) then
                    count = count - 1
                else
                    t[i] = hand[i]
                end
                fib[5] = true
                count = count + 1
            end
        end
        if (count < 3) then
            return {}
        end
        table.insert(ret, t)
        return ret
    end

    local get_fibonacci = function(hand)
        if (G.jokers ~= nil) and (G.jokers.cards ~= nil) and (G.jokers.cards[1] ~= nil) then
            for i = 1, #G.jokers.cards do
                if (G.jokers.cards[i].ability.name == "Spiral Clock") and not G.jokers.cards[i].debuff then
                    if #get_smallfib(hand) > 0 then
                        return get_smallfib(hand)
                    end
                end
            end
        end
        if (#hand < 5) then
            return {}
        end
        local ret = {}
        local t = {}
        local fib = {false, false, false, false, false}
        for i=1, #hand do
            if (hand[i].base.value == 'Ace') then
                if (fib[1] == true) then
                    return {}
                end
                fib[1] = true
            end
            if (hand[i].base.value == '8') then
                if (fib[2] == true) then
                    return {}
                end
                fib[2] = true
            end
            if (hand[i].base.value == '5') then
                if (fib[3] == true) then
                    return {}
                end
                fib[3] = true
            end
            if (hand[i].base.value == '3') then
                if (fib[4] == true) then
                    return {}
                end
                fib[4] = true
            end
            if (hand[i].base.value == '2') then
                if (fib[5] == true) then
                    return {}
                end
                fib[5] = true
            end
        end
        for i=1, #fib do
            if (fib[i] == false) then
                return {}
            end
            t[#t+1] = hand[i]
        end
        table.insert(ret, t)
        return ret
    end

    SMODS.Jokers.j_ratio.calculate = function(self, context)
        if SMODS.end_calculate_context(context) then
            local hand = context.full_hand
            
            if #get_fibonacci(hand) > 0 then
                return {
                    message = localize{type='variable',key='a_xmult',vars={self.ability.extra.xmult}},
                    Xmult_mod = self.ability.extra.xmult,
                    card = self
                }
            else 
                return
            end
        end
    end

    SMODS.Jokers.j_recurring.calculate = function(self, context)
        if SMODS.end_calculate_context(context) then
            local hand = context.full_hand
            if #get_fibonacci(hand) > 0 then
                return {
                    message = localize{type='variable',key='a_chips',vars={self.ability.extra.chips}},
                    chips_mod = self.ability.extra.chips,
                    card = self
                }
            else 
                return
            end
        end
    end

    SMODS.Jokers.j_cynical.calculate = function(self, context)
        if SMODS.end_calculate_context(context) then
            local hand = context.full_hand
            if #get_fibonacci(hand) > 0 then
                return {
                    message = localize{type='variable',key='a_mult',vars={self.ability.extra.mult}},
                    mult_mod = self.ability.extra.mult,
                    card = self
                }
            else 
                return
            end
        end
    end

    G.localization.misc.challenge_names["c_all_fib"] = "The Inner Spiral"

    table.insert(G.CHALLENGES,#G.CHALLENGES+1, {name = 'The Inner Spiral',
                id = 'c_all_fib',
                rules = {
                    custom = {
                        
                    },
                    modifiers = {
                    }
                },
                jokers = {    
                    {id = 'j_clock'},
                    {id = 'j_fibonacci'},
                    {id = 'j_recurring'},
                    {id = 'j_cynical'},
                    {id = 'j_ratio'},
                },
                consumeables = {
                },
                vouchers = {
                },
                deck = {
                    type = 'Challenge Deck',
                    cards = {
                        {s = 'C', r = 'A'},
                        {s = 'C', r = 'A'},
                        {s = 'C', r = '8'},
                        {s = 'C', r = '8'},
                        {s = 'C', r = '5'},
                        {s = 'C', r = '5'},
                        {s = 'C', r = '3'},
                        {s = 'C', r = '3'},
                        {s = 'C', r = '2'},
                        {s = 'C', r = '2'},
                        {s = 'S', r = 'A'},
                        {s = 'S', r = 'A'},
                        {s = 'S', r = '8'},
                        {s = 'S', r = '8'},
                        {s = 'S', r = '5'},
                        {s = 'S', r = '5'},
                        {s = 'S', r = '3'},
                        {s = 'S', r = '3'},
                        {s = 'S', r = '2'},
                        {s = 'S', r = '2'},
                        {s = 'D', r = 'A'},
                        {s = 'D', r = 'A'},
                        {s = 'D', r = '8'},
                        {s = 'D', r = '8'},
                        {s = 'D', r = '5'},
                        {s = 'D', r = '5'},
                        {s = 'D', r = '3'},
                        {s = 'D', r = '3'},
                        {s = 'D', r = '2'},
                        {s = 'D', r = '2'},
                        {s = 'H', r = 'A'},
                        {s = 'H', r = 'A'},
                        {s = 'H', r = '8'},
                        {s = 'H', r = '8'},
                        {s = 'H', r = '5'},
                        {s = 'H', r = '5'},
                        {s = 'H', r = '3'},
                        {s = 'H', r = '3'},
                        {s = 'H', r = '2'},
                        {s = 'H', r = '2'},
                    }
                },
                restrictions = {
                    banned_cards = {
                        {id = 'j_jolly'},
                        {id = 'j_zany'},
                        {id = 'j_mad'},
                        {id = 'j_crazy'},
                        {id = 'j_sly'},
                        {id = 'j_wily'},
                        {id = 'j_clever'},
                        {id = 'j_devious'},
                        {id = 'j_hack'},
                        {id = 'j_runner'},
                        {id = 'j_splash'},
                        {id = 'j_sixth_sense'},
                        {id = 'j_superposition'},
                        {id = 'j_seance'},
                        {id = 'j_shortcut'},
                        {id = 'j_obelisk'},
                        {id = 'j_cloud_9'},
                        {id = 'j_trousers'},
                        {id = 'j_flower_pot'},
                        {id = 'j_wee'},
                        {id = 'j_duo'},
                        {id = 'j_trio'},
                        {id = 'j_family'},
                        {id = 'j_order'},
                        {id = 'j_8_ball'},
                        {id = 'c_pluto'},
                        {id = 'c_mercury'},
                        {id = 'c_venus'},
                        {id = 'c_earth'},
                        {id = 'c_mars'},
                        {id = 'c_jupiter'},
                        {id = 'c_saturn'},
                        {id = 'c_uranus'},
                        {id = 'c_neptune'},
                        {id = 'c_pluto'},
                        {id = 'c_planet_x'},
                        {id = 'c_ceres'},
                        {id = 'c_eris'},
                        {id = 'c_cubic'},
                        {id = 'c_octa'},
                        {id = 'c_dodeca'},
                        {id = 'c_icosa'},
                        {id = 'c_pi'},
                        {id = 'c_high_priestess'},
                        {id = 'v_telescope'},
                        {id = 'p_celestial_normal_2', ids = {
                            'p_celestial_normal_1','p_celestial_normal_2','p_celestial_normal_3','p_celestial_normal_4','p_celestial_jumbo_1','p_celestial_jumbo_2','p_celestial_mega_1','p_celestial_mega_2'
                        }}
                    },
                    banned_tags = {
                        {id = 'tag_meteor'}
                    },
                    banned_other = {
                        {id = 'bl_psychic', type = 'blind'},
                        {id = 'bl_eye', type = 'blind'},
                        {id = 'bl_ox', type = 'blind'},
                    }
                }
            }
        )


    init_localization()

end