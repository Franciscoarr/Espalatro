--- STEAMODDED HEADER
--- MOD_NAME: Espalatro
--- MOD_ID: Espalatro
--- MOD_AUTHOR: [Francisarr]
--- MOD_DESCRIPTION: Los jokers más españoles
--- BADGE_COLOUR: AD1519

----------------------------------------------
------------MOD CODE -------------------------

--https://goo.su/I0Hukr

local jokers = {
    balatromotos = {
        name = "Balatro Motos",
        text = {
            "Por cada {C:attention}Reina{} jugada, hay un",
            "{C:green}1 de 5{} de generar una carta {C:tarot}Tarot{} aleatoria"
        },
        config = {
            extra = {
                chance = 5  
            }
        },
        pos = { x = 0, y = 0 },
        rarity = 1,
        cost = 5,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.individual then
                if context.cardarea == G.play then
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        if (context.other_card:get_id() == 12) and (pseudorandom('balatromotos') < (1/self.ability.extra.chance)) then
                            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                            return {
                                func = function()
                                    G.E_MANAGER:add_event(Event({
                                        trigger = 'before',
                                        delay = 0.0,
                                        func = function()
                                            local card = create_card('Tarot',G.consumeables, nil, nil, nil, nil, nil, 'balatromotos')
                                            card:add_to_deck()
                                            G.consumeables:emplace(card)
                                            G.GAME.consumeable_buffer = 0
                                            return true
                                        end
                                    }))
                                end,
                                sound = "balatromotos",
                                message = "¡Que entre la china!",
                                colour = G.Black,
                                card = self
                            }
                        end
                    end
                end
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    jimbasybalatras = {
        name = "Jimbas y Balatras",
        text = {    
            "{C:chips}+#1#{} fichas a cada carta {C:attention}jugada{}",
            "por cada {C:attention}2{} que no ha salido en tu mano",
            "{C:inactive}Actual {C:chips}+#2#{} fichas{C:inactive}"
        },
        config = {
            extra = {
                chips_per_two = 6
            }
        },
        pos = { x = 0, y = 0 },
        rarity = 1,
        cost = 4,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            self.config.extra = self.config.extra or {
                chips_per_two = 6,
                totalchips = 0
            }
            
            if context.cardarea == G.jokers then
                if context.joker_main then
                    local two_count = 0
                    for _, v in ipairs(G.deck.cards) do
                        if v:get_id() == 2 then
                            two_count = two_count + 1
                        end
                    end
                    local chips = self.config.extra.chips_per_two * two_count
                    self.config.extra.totalchips = chips
                end
            end
            
            if context.scoring_hand then
                if context.joker_main then
                    if self.config.extra.totalchips > 0 then
                        return {
                            chips = self.config.extra.totalchips,
                            card = self,
                            message = "JA JA JA",
                            sound = "jimbasybalatras"
                        }
                    end
                end
            end
        end,

        loc_def = function(self)
            local extra = self.config.extra or {
                chips_per_two = 6,
                totalchips = 0
            }
            return {
                extra.chips_per_two,
                extra.totalchips
            }
        end,
    },

    seatibiza = {
        name = "Seat Ibiza 2005",
        text = {
            "{X:red,C:white}X#1#{} multi por cada",
            "{C:money}$5{} que tengas",
            "{C:inactive}(Actual: multi {X:red,C:white}X#2#{C:inactive})"
        },
        config = {
            extra = {
                x_mult_per_5 = 0.1,
                current_x_mult = 1
            }
        },
        pos = { x = 0, y = 0 },
        rarity = 3,
        cost = 8,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if SMODS.end_calculate_context(context) then
                local dollars = G.GAME.dollars or 0
                local extra = self.ability.extra
                local mult = 1 + math.floor(dollars / 5) * extra.x_mult_per_5
                extra.current_x_mult = mult

                return {
                    Xmult_mod = mult,
                    card = self,
                    message = localize { type = 'variable', key = 'a_xmult', vars = { mult } }
                }
            end
        end,

        loc_def = function(self)
            local extra = self.ability.extra
            return {
                extra.x_mult_per_5,
                string.format("%.1f", extra.current_x_mult or 1)
            }
        end
    },

    antoniobalatro = {
        name = "Antonio Balatro",
        text = {
            "Si tienes el comodín",
            "{C:attention}Seat Ibiza 2005{},",
            "gana un {X:red,C:white}X4{} mult adicional"
        },
        config = { extra = {} },
        pos = { x = 0, y = 0 },
        rarity = 3,
        cost = 9,
        blueprint_compat = false,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.joker_main and context.full_hand and not context.blueprint then
                local has_seat_ibiza = false
                if G and G.jokers and G.jokers.cards then
                    for _, joker in ipairs(G.jokers.cards) do
                        if joker and joker.ability and joker.ability.name == "Seat Ibiza 2005" then
                            has_seat_ibiza = true
                            break
                        end
                    end
                end

                if has_seat_ibiza then
                    return {
                        Xmult_mod = 4,
                        card = self,
                        sound = "antoniobalatro",
                        message = localize { type = 'variable', key = 'a_xmult', vars = { 4 } }
                    }
                end
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    balatrorivas = {
        name = "Balatro Rivas",
        text = {
            "Cada vez que se juega una carta,",
            "Amador dice una de sus frases"
        },
        config = {
            extra = {}
        },
        pos = { x = 0, y = 0 },
        rarity = 1,
        cost = 2,
        blueprint_compat = false,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if not context or not context.individual or not context.cardarea or context.cardarea ~= G.play then
                return
            end

            local frases = {
                "¡Merengue, merengue!",
                "Amai",
                "¡Ay la Cuqui!",
                "Espartaco",
                "¡Aparcao!",
                "Pues te reviento",
                "¡Delantero Pichichi!",
                "¡A que te meto!",
                "¡Que vienen!",
                "Yo soy un vividor follador",
                "¡Tengo el salami en oferta!",
                "Soy un borderline",
                "¡Caña aquí!",
                "¡Ay mamá!",
                "Venga al lío",
                "¡Con dos cojones!"
            }

            local frase = pseudorandom_element(frases, pseudoseed('amador_rivas_frase'))

            if card_eval_status_text then
                card_eval_status_text(self, 'extra', nil, nil, nil, {
                    message = frase,
                    colour = G.C.BLACK
                })
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    alexelbalatro = {
        name = "AlexElBalatro",
        text = {
            "En tu {C:attention}último descarte{}",
            "destruye todas las cartas",
            "de {C:hearts}corazones{} y {C:diamonds}diamantes{}",
            "que {C:attention}selecciones{} para descartar"
        },
        config = {},
        pos = {x = 0, y = 0},
        rarity = 2,
        cost = 6,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.discard and context.other_card then
                if G.GAME.current_round.discards_left == 1 then
                    if context.other_card:is_suit("Hearts") or context.other_card:is_suit("Diamonds") then
                        if not G.GAME.mensajealexelbalatro then
                            G.GAME.mensajealexelbalatro = true
                            return {
                                message = "Vaya pedazo de mierda",
                                sound = "alexelbalatro",
                                card = self,
                                remove = true
                            }
                        else
                            return {
                                card = self,
                                remove = true
                            }
                        end
                    end
                end
                G.GAME.mensajealexelbalatro = false
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    balatrez360 = {
        name = "Balatrez360",
        text = {
            "En tu {C:attention}último descarte{}",
            "destruye todas las cartas",
            "de {C:spades}espadas{} y {C:clubs}treboles{}",
            "que {C:attention}selecciones{} para descartar"
        },
        config = {},
        pos = {x = 0, y = 0},
        rarity = 2,
        cost = 6,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.discard and context.other_card then
                if G.GAME.current_round.discards_left == 1 then
                    if context.other_card:is_suit("Spades") or context.other_card:is_suit("Clubs") then
                        if not G.GAME.mensajebalatrez360 then
                            G.GAME.mensajebalatrez360 = true
                            return {
                                message = "AAAA",
                                sound = "balatrez360",
                                card = self,
                                remove = true
                            }
                        else
                            return {
                                card = self,
                                remove = true
                            }
                        end
                    end
                end
                G.GAME.mensajebalatrez360 = false
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    jimbiano = {
        name = "Jimbiano",
        text = {
            "Cada vez que se elige una {C:attention}ciega{}",
            "aumenta aleatoriamente el nivel de una {C:attention}mano de póker{}"
        },
        config = {},
        pos = { x = 0, y = 0 },
        rarity = 2,
        cost = 7,
        blueprint_compat = false,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.setting_blind and not context.blueprint then
                local possible_hands = {}
                for k, v in pairs(G.GAME.hands) do
                    if v.visible then
                        table.insert(possible_hands, k)
                    end
                end
                if #possible_hands > 0 then
                    local k_chosen = pseudorandom_element(possible_hands, pseudoseed('jimbiano'))
                    update_hand_text({sound = 'button', volume = 0.7, pitch = 0.8, delay = 0.3}, {
                        handname = localize(k_chosen, 'poker_hands'),
                        chips = G.GAME.hands[k_chosen].chips,
                        mult = G.GAME.hands[k_chosen].mult,
                        level = G.GAME.hands[k_chosen].level
                    })
                    level_up_hand(self, k_chosen, false)

                    if card_eval_status_text then
                        card_eval_status_text(self, 'extra', nil, nil, nil, {
                            message = "¡Ignorante de la vida!",
                            colour = G.C.PURPLE,
                            sound = "jimbiano"
                        })
                    end
                end
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    mangelbalatrel = {
        name = "MangelBalatrel",
        text = {
            "Si juegas una mano que contiene 3 {C:attention}Reyes{}",
            "deshabilita la {C:attention}ciega jefe{}"
        },
        config = {
            extra = {
                last_hand = 0
            }
        },
        pos = { x = 0, y = 0 },
        rarity = 1,
        cost = 6,
        blueprint_compat = false,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            local extra = self.ability.extra
            if context.joker_main and context.full_hand and not context.blueprint then
                if G.GAME.blind and ((not G.GAME.blind.disabled) and (G.GAME.blind:get_type() == 'Boss')) then
                    local hand = context.full_hand
                    local king = 0
                    for i = 1, #hand do
                        if hand[i]:get_id() == 13 then
                            king = king + 1
                        end
                    end
                    if king >= 3 then
                        G.GAME.blind:disable()
                        card_eval_status_text(self, 'extra', nil, nil, nil, {
                            message = "¡Terremotoo!",
                            colour = G.C.RED,
                            sound = "mangelbalatrel"
                        })
                    end
                end
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    estrellagalicia = {
        name = "Estrella Galicia",
        text = {
            "Reactiva todas las cartas de",
            "valor {C:attention}2 al 10{} cuando se juegan"
        },
        config = {},
        pos = { x = 0, y = 0 },
        rarity = 2,
        cost = 6,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.repetition then
                if context.cardarea == G.play then
                    if context.other_card:get_id()>= 2 and context.other_card:get_id() <= 10 then
                        return {
                            message = "¡Otra cerveza!",
                            repetitions = 1,
                            colour = G.C.YELLOW,
                            card = self
                        }
                    end
                end
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    balatreloyjimbon = {                                           
        name = "Balatrelo y Jimbón",                                
        text = {
            "{C:mult}+2{} multi por cada carta en mano",
            "sin jugar que sea {C:attention}par{} y",
            "{C:chips}+15{} fichas por cada {C:attention}impar{}",
            "{C:inactive}Te van a hacer el Aquello...{}"           
        },
        config = {}, 
        pos = { x = 0, y = 0 },                           
        rarity = 1,                                  
        cost = 5,                                   
        blueprint_compat = true,                         
        eternal_compat = true,                             
        unlocked = true,                                    
        discovered = true,                                                           
        atlas = nil,                                     
        soul_pos = nil,                                    

        calculate = function(self, context)                
            if context.individual then
                if context.cardarea == G.hand and not context.end_of_round then
                    if context.other_card:get_id() <= 10 and context.other_card:get_id() >= 0 and context.other_card:get_id()%2 == 0 then
                        return {
                            mult = 2,
                            card = self
                        }
                    elseif ((context.other_card:get_id() <= 10 and context.other_card:get_id() >= 0 and context.other_card:get_id()%2 == 1) or (context.other_card:get_id() == 14)) then
                        return {
                            chips = 15,
                            card = self
                        }
                    end
                end
            end
            return nil
        end,

        loc_def = function(self)
            return {}
        end
    },

    jimbosanchez = {
        name = "Jimbo Sánchez",
        text = {
            "Al final de cada {C:attention}ronda{}, si tienes",
            "al menos {C:money}$10{}, pierdes {C:red}$10{} y",
            "este comodín gana {C:mult}+5{} mult",
            "Al final de cada {C:attention}mano{}, se aplica el mult acumulado",
            "{C:inactive}(Actual {C:mult}+#1#{C:inactive} multi)"
        },
        config = {
            extra = {
                mult_per_round = 5,
                money_lost_per_round = 10,
                accumulated_mult = 0,
                last_round_applied = -1
            }
        },
        pos = { x = 0, y = 0 },
        rarity = 1,
        cost = 5,
        blueprint_compat = false,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            local extra = self.ability.extra
            if context.end_of_round then
                if extra.last_round_applied ~= G.GAME.round and G.GAME.dollars >= extra.money_lost_per_round then
                    G.GAME.dollars = G.GAME.dollars - extra.money_lost_per_round
                    extra.accumulated_mult = extra.accumulated_mult + extra.mult_per_round
                    extra.last_round_applied = G.GAME.round

                    card_eval_status_text(self, 'extra', nil, nil, nil, {
                        message = "-$" .. extra.money_lost_per_round .. " | +" .. extra.mult_per_round .. " mult",
                        colour = G.C.RED,
                        sound = "jimbosanchez1"
                    })        
                end
            end

            if context.joker_main and context.full_hand and not context.blueprint then
                if extra.accumulated_mult > 0 then
                    return {
                        mult = extra.accumulated_mult,
                        message = "Son las 5, no he comido",
                        sound = "jimbosanchez2",
                        card = self
                    }
                end
            end
        end,

        loc_def = function(self)
            return {
                self.ability.extra.accumulated_mult
            }
        end
    },

    jimbowild = {
        name = "Jimbo Wild",
        text = {
            "Al final de cada jugada,",
            "{C:attention}sella{} aleatoriamente las cartas",
            "de tu mano sin sello",
            "{C:inactive}Olvidonaa...{}"
        },
        config = {},
        pos = { x = 0, y = 0 },
        rarity = 3,
        cost = 8,
        blueprint_compat = false,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.cardarea == G.jokers then
                if context.before then
                    local has_unselled = false
                    local any_selled = false
                    

                    for k, v in ipairs(context.scoring_hand) do
                        if not v.seal then
                            has_unselled = true
                            break
                        end
                    end
                    

                    if has_unselled then
                        for k, v in ipairs(context.scoring_hand) do
                            if not v.seal then
                                G.E_MANAGER:add_event(Event({
                                    func = function() 
                                        local seal_type = pseudorandom(pseudoseed('certsl'))
                                        if seal_type > 0.75 then v:set_seal('Red', true)
                                        elseif seal_type > 0.5 then v:set_seal('Blue', true)
                                        elseif seal_type > 0.25 then v:set_seal('Gold', true)
                                        else v:set_seal('Purple', true)
                                        end
                                        v:juice_up()
                                        G.GAME.blind:debuff_card(v)
                                        G.hand:sort()
                                        if context.blueprint_card then context.blueprint_card:juice_up() else self:juice_up() end
                                        any_selled = true
                                        return true
                                    end}))
                                playing_card_joker_effects({true})
                            end
                        end
                        
                        if not any_selled then
                            return {
                                message = "¡Hoy vengo a follaros!",
                                sound = "jimbowild",
                                card = self
                            }
                        end
                    end
                end
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    jimbiesta = {
        name = "Jimbiesta",
        text = {
            "{C:chips}+500{} fichas en la",
            "{C:attention}última mano{} de la ronda"
        },
        config = {
            extra = {
                chips = 500
            }
        },
        pos = { x = 0, y = 0 },
        rarity = 2,
        cost = 7,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        effect = 'Chips',
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            -- Aplica los chips si estás en la última mano de la ronda
            if context.joker_main and context.cardarea == G.jokers then
                if G.GAME.current_round.hands_left < 1 then
                    play_sound('jimbiesta')
                    return {
                        chips = self.ability.extra.chips
                    }
                end
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    balatrybait = {
        name = "BalatryBait",
        text = {
            "Según la rareza de los demás",
            "comodines sumará los siguientes multi:",
            "Común:{C:mult}+#1#{}, Inusual:{C:mult}+#2#{},",
            "Raro:{C:mult}+#3#{}, Legendario:{C:mult}+#4#{},"
        },
        config = {
            extra = {
                m1 = 5,
                m2 = 10,
                m3 = 15,
                m4 = 25,
                sounds = {  
                    [1] = 'balatrybait1',
                    [2] = 'balatrybait2', 
                    [3] = 'balatrybait3',
                    [4] = 'balatrybait4'
                }
            }
        },
        pos = { x = 0, y = 0 },
        rarity = 2,
        cost = 7,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.other_joker and self ~= context.other_joker then
                -- Verificar que el otro joker tenga configuración válida
                if context.other_joker.config and context.other_joker.config.center then
                    local rarity = context.other_joker.config.center.rarity or 1
                    local bonus = {
                        [1] = self.ability.extra.m1,
                        [2] = self.ability.extra.m2,
                        [3] = self.ability.extra.m3,
                        [4] = self.ability.extra.m4
                    }
                    
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            context.other_joker:juice_up(0.5, 0.5)
                            return true
                        end
                    }))
                    
                    return {
                        message = localize{type='variable', key='a_mult', vars={bonus[rarity]}},
                        mult_mod = bonus[rarity],
                        sound = self.ability.extra.sounds[rarity]  -- Sonido dinámico
                    }
                end
            end
        end,

        loc_def = function(self)
            return {
                self.ability.extra.m1,  
                self.ability.extra.m2,  
                self.ability.extra.m3,  
                self.ability.extra.m4,  
            }
        end
    },
	
	balatrica = {
        name = "Balatrica",
        text = {
            "Gana {X:red,C:white}X1{} por cada comodín",
            "de comida que tengas"
        },
        config = {},
        pos = { x = 0, y = 0 },
        rarity = 3,
        cost = 8,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,
        --SOLO FUNCIONA PARA LOS COMODINES VANILLA DEL JUEGO Y DE ESTE MOD
        calculate = function(self, context)
            if context.joker_main and context.cardarea == G.jokers then
                local count = 1
                for _, joker in ipairs(G.jokers.cards) do
                    if joker.ability.name == "Gros Michel" or joker.ability.name == "Egg" or joker.ability.name == "Ice Cream" or joker.ability.name == "Cavendish" or joker.ability.name == "Turtle Bean" or joker.ability.name == "Diet Cola" or joker.ability.name == "Popcorn" or joker.ability.name == "Ramen" or joker.ability.name == "Estrella Galicia" or joker.ability.name == "Roncola" then
                        count = count + 1
                    end
                end
                if count > 1 then
                    return {
                        Xmult_mod = count,
                        message = localize{type='variable', key='a_xmult', vars={count}},
						sound = "balatrica",
                        card = self
                    }
                end
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    balatroalonso = {
        name = "Balatro Alonso",
        text = {
            "Las cartas mejoradas ganan",
            "{C:chips}+33{} fichas permanente la",
            "primera vez que anotan"
        },
        config = {
            extra = {
                chips = 33
            }
        },
        pos = { x = 0, y = 0 },
        rarity = 1,
        cost = 5,
        blueprint_compat = false,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.individual and context.cardarea == G.play then
                local other_card = context.other_card
                if other_card.config.center ~= G.P_CENTERS.c_base and not (other_card.ability and other_card.ability.fernandoalonso_bonus_applied) then
                    other_card.ability = other_card.ability or {}
                    other_card.ability.perma_bonus = (other_card.ability.perma_bonus or 0) + self.ability.extra.chips
                    other_card.ability.fernandoalonso_bonus_applied = true  
                    return {
                        message = "¡33!",
                        colour = G.C.CHIPS,
                        card = self
                    }
                end
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    balatrente = {
        name = "Balatrente",
        text = {
            "Al seleccionar una {C:attention}ciega{}",
            "gana {C:money}5$"
        },
        config = {
            extra = { 
                cash = 5 
            } 
        },
        pos = { x = 0, y = 0 },
        rarity = 1,
        cost = 7,
        blueprint_compat = false,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.setting_blind and not context.blueprint then
                ease_dollars(self.ability.extra.cash)
                return {
                    message = "¿Nos hacemos unas pajillas?",
                    sound = "balatrente",
                    card = self
                }
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    roncola = {
        name = "Roncola",
        text = {
            "Al vender este comodín obtienes",
            "una etiqueta {C:attention}negativa{}, {C:attention}laminada{}",
            "o {C:attention}polícroma{}"
        },
        config = {},
        pos = { x = 0, y = 0 },
        rarity = 2,
        cost = 6,
        blueprint_compat = false,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.selling_self then
                G.E_MANAGER:add_event(Event({
                    func = (function()
                        --Holográfica no va, no se porque
                        local tags_elegir = {
                            'tag_negative',     
                            'tag_foil',       
                            'tag_polychrome' 
                        }
                        
                        local selected_tag = pseudorandom_element(tags_elegir, pseudoseed('roncola'))
                        
                        add_tag(Tag(selected_tag))
                        play_sound('generic1', 0.9 + math.random()*0.1, 0.8)
                        play_sound('holo1', 1.2 + math.random()*0.1, 0.4)
                        return true
                    end)
                }))
            end
        end,

        loc_def = function(self)
            return {}
        end
    },
	
	balatrorecio = {
        name = "Balatro Recio",
        text = {
            "Cada carta en tu baraja que no sea",
            "de {C:attetion}acero{}, {C:attetion}oro{}, {C:attetion}piedra{} o {C:attetion}base{}",
            "añade {X:red,C:white}X#1#{} al multiplicador",
            "{C:inactive}(Actual: multi {X:red,C:white}X#2#{})"
        },
        config = {
            extra = {
                contador_cartas = 0,
                multiplicador = 0.05,
                current_x_mult = 1
            }
        },
        pos = { x = 0, y = 0 },
        rarity = 1,
        cost = 6,

        blueprint_compat = false,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            self.config.extra = self.config.extra or {
                contador_cartas = 0,
                multiplicador = 0.05,
                current_x_mult = 1
            }
            
            if context.cardarea == G.jokers then
                if context.joker_main then
                    self.config.extra.contador_cartas = 0 
                    for k, v in pairs(G.playing_cards) do
                        if v.config.center ~= G.P_CENTERS.m_steel 
                        and v.config.center ~= G.P_CENTERS.m_gold 
                        and v.config.center ~= G.P_CENTERS.m_stone 
                        and v.config.center ~= G.P_CENTERS.c_base then 
                            self.config.extra.contador_cartas = self.config.extra.contador_cartas + 1 
                            local mult = 1 + (self.config.extra.multiplicador * self.config.extra.contador_cartas)
                            self.config.extra.current_x_mult = mult
                        end
                    end
                end
            end
            if context.scoring_hand then
                if context.joker_main then
                    if self.config.extra.contador_cartas > 0 then
                        local mult = 1 + (self.config.extra.multiplicador * self.config.extra.contador_cartas)
                        self.config.extra.current_x_mult = mult
                        return {
                            Xmult_mod = mult,
                            card = self,
                            message = localize { type = 'variable', key = 'a_xmult', vars = { mult } },
                            sound = "balatrorecio"
                        }
                    end
                end
            end
        end,

        loc_def = function(self)
            local extra = self.config.extra or {
                multiplicador = 0.05,
                current_x_mult = 1
            }
            return {
                extra.multiplicador,
                extra.current_x_mult
            }
        end,
    },

    balatropa = {
        name = "Balatropa",
        text = {
            "Crea una carta de {C:planet}planeta{}",
            "si se juega una mano",
            "con {C:money}$4{} o menos"
        },
        config = {},
        pos = { x = 0, y = 0 },
        rarity = 3,
        cost = 8,
        blueprint_compat = false,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.cardarea == G.jokers then
                if context.joker_main then
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        if G.GAME.dollars <= 4 then
                            G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                            G.E_MANAGER:add_event(Event({
                                trigger = 'before',
                                delay = 0.0,
                                func = (function()
                                        local card = create_card('Planet', G.consumeables, nil, nil, nil, nil, nil, 'estopa')
                                        card:add_to_deck()
                                        G.consumeables:emplace(card)
                                        G.GAME.consumeable_buffer = 0
                                    return true
                                end)}))
                            return {
                                message = localize('k_plus_planet'),
                                sound = 'balatropa',
                                card = self
                            }
                        end
                    end
                end
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    balatrorajoy = {
        name = "Balatro Rajoy",
        text = {
            "Al comienzo de cada ronda",
            "ganas {C:blue}1 mano{}",
            " o {C:red}1 descarte{} en esa ronda"
        },
        config = {},
        pos = { x = 0, y = 0 },
        rarity = 2,
        cost = 6,
        blueprint_compat = false,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.setting_blind and not context.blueprint then
                local choice = pseudorandom(pseudoseed('rajoy'))

                if choice < 0.5 then
                    G.GAME.current_round.hands_left = math.max(0, G.GAME.current_round.hands_left + 1)
                    return {
                        message = "+1 Mano",
                        sound = "balatrorajoy1",
                        colour = G.C.BLUE,
                        card = self
                    }
                else
                    G.GAME.current_round.discards_left = math.max(0, G.GAME.current_round.discards_left + 1)
                    return {
                        message = "+1 Descarte",
                        sound = "balatrorajoy2",
                        colour = G.C.RED,
                        card = self
                    }
                end
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    illojuan = {
        name = "IlloJuan",
        text = {
            "Cada vez que juegas una mano",
            "obtienes un bono aleatorio entre:",
            "{C:money}$20{}, {C:chips}+700{} fichas,",
            "{C:mult}+100{} mult o {X:red,C:white}X3{}"
        },
        config = {
            extra = {
                money = 20,
                chips = 700,
                mult = 100,
                xmult = 3
            }
        },
        pos = { x = 0, y = 0 },
        rarity = 4,
        cost = 12,
        blueprint_compat = true,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.full_hand and context.joker_main then
                local roll = pseudorandom('illojuan')

                if roll < 0.25 then
                    ease_dollars(self.ability.extra.money)
                    return {
                        message = "+$" .. self.ability.extra.money,
                        colour = G.C.MONEY,
                        card = self
                    }

                elseif roll < 0.5 then
                    return {
                        chips = self.ability.extra.chips,
                        colour = G.C.CHIPS,
                        card = self
                    }

                elseif roll < 0.75 then
                    return {
                        mult = self.ability.extra.mult,
                        colour = G.C.MULT,
                        card = self
                    }

                else
                    return {
                        Xmult_mod = self.ability.extra.xmult,
                        colour = G.C.XMULT,
                        card = self
                    }
                end
            end
        end,

        loc_def = function(self)
            return {}
        end

    },

    cajarural = {
        name = "Gorra de Caja Rural",
        text = {
            "Al ser {C:attention}vendido{}, duplica el",
            "valor de venta de todos los",
            "{C:attention}otros comodines{} en tu posesión"
        },
        config = {
            extra = {
                duplicador = 2
            }
        },
        pos = { x = 0, y = 0 },
        rarity = 2,
        cost = 7,
        blueprint_compat = false,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.selling_self then
                for k, v in ipairs(G.jokers.cards) do
                    if v ~= self and v.set_cost then
                        v.sell_cost = v.sell_cost * 2
                    end
                end
            end
        end,

        loc_def = function(self)
            return {}
        end
    },

    eljimbomc = {
        name = "ElJimboMC",
        text = {
            "Si juegas una mano de {C:attention}Repóquer{},",
            "{C:attention}Full de color{} o {C:attention}Cinco de color{},",
            "genera una carta {C:spectral}espectral{} aleatoria"
        },
        config = {},
        pos = { x = 0, y = 0 },
        rarity = 1,
        cost = 6,
        blueprint_compat = false,
        eternal_compat = true,
        unlocked = true,
        discovered = true,
        atlas = nil,
        soul_pos = nil,

        calculate = function(self, context)
            if context.full_hand and context.joker_main and not context.blueprint then
                local hand = context.scoring_name

                if hand == "Five of a Kind" or hand == "Flush House" or hand == "Flush Five" then
                    if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                        G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1

                        G.E_MANAGER:add_event(Event({
                            trigger = 'before',
                            delay = 0.0,
                            func = function()
                                local card = create_card('Spectral', G.consumeables)
                                card:add_to_deck()
                                G.consumeables:emplace(card)
                                G.GAME.consumeable_buffer = 0
                                return true
                            end
                        }))

                        return {
                            message = "¡EYEYEYEY!",
                            sound = "eljimbomc",
                            colour = G.C.SPECTRAL,
                            card = self
                        }
                    end
                end
            end
        end,

        loc_def = function(self)
            return {}
        end
    }

}

function SMODS.INIT.Espalatro()
    --localization for the info queue key
    G.localization.descriptions.Other["your_key"] = {
        name = "Example", --tooltip name
        text = {
            "TEXT L1",   --tooltip text.		
            "TEXT L2",   --you can add as many lines as you want
            "TEXT L3"    --more than 5 lines look odd
        }
    }
    init_localization()

    SMODS.Sound:register_global(
        {key = "balatromotos", path = "assets/sounds/balatromotos.ogg"},
        {key = "jimbasybalatras", path = "assets/sounds/jimbasybalatras.ogg"},
        {key = "antoniobalatro", path = "assets/sounds/antoniobalatro.ogg"},
        {key = "jimbiano", path = "assets/sounds/jimbiano.ogg"},
        {key = "mangelbalatrel", path = "assets/sounds/mangelbalatrel.ogg"},
        {key = "jimbosanchez1", path = "assets/sounds/jimbosanchez1.ogg"},
        {key = "jimbosanchez2", path = "assets/sounds/jimbosanchez2.ogg"},
        {key = "jimbowild", path = "assets/sounds/jimbowild.ogg"},
        {key = "jimbiesta", path = "assets/sounds/jimbiesta.ogg"},
        {key = "balatrybait1", path = "assets/sounds/balatrybait1.ogg"},
        {key = "balatrybait2", path = "assets/sounds/balatrybait2.ogg"},
        {key = "balatrybait3", path = "assets/sounds/balatrybait3.ogg"},
        {key = "balatrybait4", path = "assets/sounds/balatrybait4.ogg"},
        {key = "balatrente", path = "assets/sounds/balatrente.ogg"},
        {key = "balatrorecio", path = "assets/sounds/balatrorecio.ogg"},
        {key = "balatrorajoy1", path = "assets/sounds/balatrorajoy1.ogg"},
        {key = "balatrorajoy2", path = "assets/sounds/balatrorajoy2.ogg"},
        {key = "eljimbomc", path = "assets/sounds/eljimbomc.ogg"},
        {key = "balatropa", path = "assets/sounds/balatropa.ogg"},
        {key = "alexelbalatro", path = "assets/sounds/alexelbalatro.ogg"},
        {key = "balatrez360", path = "assets/sounds/balatrez360.ogg"},
		{key = "balatrica", path = "assets/sounds/balatrica.ogg"}
    )

    --Create and register jokers
    for k, v in pairs(jokers) do
        local joker = SMODS.Joker:new(v.name, k, v.config, v.pos, { name = v.name, text = v.text }, v.rarity, v.cost,
            v.unlocked, v.discovered, v.blueprint_compat, v.eternal_compat, v.effect, v.atlas, v.soul_pos)
        joker:register()

        if not v.atlas then --if atlas=nil then use single sprites. In this case you have to save your sprite as slug.png (for example j_examplejoker.png)
            SMODS.Sprite:new("j_" .. k, SMODS.findModByID("Espalatro").path, "j_" .. k .. ".png", 71, 95, "asset_atli")
                :register()
        end

        --add jokers calculate function:
        SMODS.Jokers[joker.slug].calculate = v.calculate
        --add jokers loc_def:
        SMODS.Jokers[joker.slug].loc_def = v.loc_def
        --Para Trancas y Barrancas
        if v.calculate_end_of_hand then
            SMODS.Jokers[joker.slug].calculate_end_of_hand = v.calculate_end_of_hand
        end

        --if tooltip is present, add jokers tooltip
        if (v.tooltip ~= nil) then
            SMODS.Jokers[joker.slug].tooltip = v.tooltip
        end
    end
    --Create sprite atlas
    SMODS.Sprite:new("youratlasname", SMODS.findModByID("Espalatro").path, "example.png", 71, 95, "asset_atli")
        :register()
end

----------------------------------------------
------------MOD CODE END----------------------
