-- Profession Knowledge Tracker - Data
-- Contains all knowledge point source definitions for The War Within

local addonName, PKT = ...

-- Profession SkillLine IDs (parent IDs that GetProfessionInfo returns)
PKT.SkillLineIDs = {
    Alchemy = 171,
    Blacksmithing = 164,
    Enchanting = 333,
    Engineering = 202,
    Inscription = 773,
    Jewelcrafting = 755,
    Leatherworking = 165,
    Tailoring = 197,
    Herbalism = 182,
    Mining = 186,
    Skinning = 393,
}

-- Reverse lookup table
PKT.SkillLineNames = {}
for name, id in pairs(PKT.SkillLineIDs) do
    PKT.SkillLineNames[id] = name
end

-- TWW Expansion SkillLine IDs (for specializations)
PKT.TWWSkillLineIDs = {
    Alchemy = 2871,
    Blacksmithing = 2872,
    Enchanting = 2874,
    Engineering = 2875,
    Inscription = 2878,
    Jewelcrafting = 2879,
    Leatherworking = 2880,
    Tailoring = 2883,
    Herbalism = 2877,
    Mining = 2881,
    Skinning = 2882,
}

-- Profession icons
PKT.ProfessionIcons = {
    Alchemy = "Interface\\Icons\\trade_alchemy",
    Blacksmithing = "Interface\\Icons\\trade_blacksmithing",
    Enchanting = "Interface\\Icons\\trade_engraving",
    Engineering = "Interface\\Icons\\trade_engineering",
    Inscription = "Interface\\Icons\\inv_inscription_tradeskill01",
    Jewelcrafting = "Interface\\Icons\\inv_misc_gem_01",
    Leatherworking = "Interface\\Icons\\trade_leatherworking",
    Tailoring = "Interface\\Icons\\trade_tailoring",
    Herbalism = "Interface\\Icons\\spell_nature_naturetouchgrow",
    Mining = "Interface\\Icons\\trade_mining",
    Skinning = "Interface\\Icons\\inv_misc_pelt_wolf_01",
}

-- ============================================================================
-- ONE-TIME TREASURES (Permanent - 8 per profession, 3 KP each = 24 total)
-- ============================================================================
PKT.Treasures = {
    Alchemy = {
        { name = "Earthen Iron Powder",         questID = 83840, zone = "Dornogal",       mapID = 2339, x = 32.5, y = 60.1 },
        { name = "Metal Dornogal Frame",        questID = 83841, zone = "Isle of Dorn",   mapID = 2248, x = 57.7, y = 61.7 },
        { name = "Reinforced Beaker",           questID = 83842, zone = "Ringing Deeps",  mapID = 2214, x = 38.1, y = 24.1 },
        { name = "Engraved Stirring Rod",       questID = 83843, zone = "Ringing Deeps",  mapID = 2214, x = 60.8, y = 61.8 },
        { name = "Chemist's Purified Water",    questID = 83844, zone = "Hallowfall",     mapID = 2215, x = 42.6, y = 55.0 },
        { name = "Sanctified Mortar and Pestle",questID = 83845, zone = "Hallowfall",     mapID = 2215, x = 41.6, y = 55.8 },
        { name = "Dark Apothecary's Vial",      questID = 83847, zone = "Azj-Kahet",      mapID = 2255, x = 42.8, y = 57.3 },
        { name = "Nerubian Mixing Salts",       questID = 83846, zone = "City of Threads",mapID = 2216, x = 45.5, y = 13.2 },
    },

    Blacksmithing = {
        { name = "Dornogal Hammer",             questID = 83849, zone = "Dornogal",       mapID = 2339, x = 47.6, y = 26.2 },
        { name = "Ancient Earthen Anvil",       questID = 83848, zone = "Isle of Dorn",   mapID = 2248, x = 59.8, y = 61.8 },
        { name = "Earthen Chisels",             questID = 83851, zone = "Ringing Deeps",  mapID = 2214, x = 60.6, y = 53.8 },
        { name = "Ringing Hammer Vise",         questID = 83850, zone = "Ringing Deeps",  mapID = 2214, x = 47.7, y = 33.2 },
        { name = "Holy Flame Forge",            questID = 83852, zone = "Hallowfall",     mapID = 2215, x = 47.6, y = 61.0 },
        { name = "Radiant Tongs",               questID = 83853, zone = "Hallowfall",     mapID = 2215, x = 44.1, y = 55.6 },
        { name = "Spiderling's Wire Brush",     questID = 83855, zone = "Azj-Kahet",      mapID = 2255, x = 53.0, y = 51.3 },
        { name = "Nerubian Smith's Kit",        questID = 83854, zone = "City of Threads",mapID = 2216, x = 46.6, y = 22.7 },
    },

    Enchanting = {
        { name = "Silver Dornogal Rod",         questID = 83859, zone = "Dornogal",       mapID = 2339, x = 58.0, y = 56.9 },
        { name = "Grinded Earthen Gem",         questID = 83856, zone = "Isle of Dorn",   mapID = 2248, x = 57.6, y = 61.1 },
        { name = "Animated Enchanting Dust",    questID = 83861, zone = "Ringing Deeps",  mapID = 2214, x = 67.1, y = 65.9 },
        { name = "Soot-Coated Orb",             questID = 83860, zone = "Ringing Deeps",  mapID = 2214, x = 44.6, y = 22.3 },
        { name = "Essence of Holy Fire",        questID = 83862, zone = "Hallowfall",     mapID = 2215, x = 40.0, y = 70.5 },
        { name = "Enchanted Arathi Scroll",     questID = 83863, zone = "Hallowfall",     mapID = 2215, x = 48.6, y = 64.5 },
        { name = "Void Shard",                  questID = 83865, zone = "Azj-Kahet",      mapID = 2255, x = 57.3, y = 44.1 },
        { name = "Book of Dark Magic",          questID = 83864, zone = "City of Threads",mapID = 2216, x = 61.5, y = 21.7 },
    },

    Engineering = {
        { name = "Dornogal Spectacles",         questID = 83867, zone = "Dornogal",       mapID = 2339, x = 64.8, y = 52.8 },
        { name = "Rock Engineer's Wrench",      questID = 83866, zone = "Isle of Dorn",   mapID = 2248, x = 61.3, y = 69.5 },
        { name = "Earthen Construct Blueprints",questID = 83869, zone = "Ringing Deeps",  mapID = 2214, x = 64.5, y = 58.8 },
        { name = "Inert Mining Bomb",           questID = 83868, zone = "Ringing Deeps",  mapID = 2214, x = 42.7, y = 27.3 },
        { name = "Arathi Safety Gloves",        questID = 83871, zone = "Hallowfall",     mapID = 2215, x = 41.6, y = 48.9 },
        { name = "Holy Firework Dud",           questID = 83870, zone = "Hallowfall",     mapID = 2215, x = 46.3, y = 61.4 },
        { name = "Puppeted Mechanical Spider",  questID = 83872, zone = "Azj-Kahet",      mapID = 2255, x = 56.9, y = 38.6 },
        { name = "Emptied Venom Canister",      questID = 83873, zone = "City of Threads",mapID = 2216, x = 63.2, y = 11.3 },
    },

    Herbalism = {
        { name = "Dornogal Gardening Scythe",   questID = 83875, zone = "Dornogal",       mapID = 2339, x = 60.6, y = 29.2 },
        { name = "Ancient Flower",              questID = 83874, zone = "Isle of Dorn",   mapID = 2248, x = 57.5, y = 61.5 },
        { name = "Earthen Digging Fork",        questID = 83876, zone = "Ringing Deeps",  mapID = 2214, x = 44.1, y = 35.0 },
        { name = "Fungarian Slicer's Knife",    questID = 83877, zone = "Ringing Deeps",  mapID = 2214, x = 48.7, y = 65.8 },
        { name = "Arathi Garden Trowel",        questID = 83879, zone = "Hallowfall",     mapID = 2215, x = 47.7, y = 63.3 },
        { name = "Arathi Herb Pruner",          questID = 83878, zone = "Hallowfall",     mapID = 2215, x = 36.01, y = 55.0 },
        { name = "Tunneler's Shovel",           questID = 83881, zone = "City of Threads",mapID = 2216, x = 46.6, y = 15.9 },
        { name = "Web-Entangled Lotus",         questID = 83880, zone = "City of Threads",mapID = 2216, x = 54.8, y = 20.6 },
    },

    Inscription = {
        { name = "Dornogal Scribe's Quill",     questID = 83882, zone = "Dornogal",       mapID = 2339, x = 57.2, y = 46.9 },
        { name = "Historian's Dip Pen",         questID = 83883, zone = "Isle of Dorn",   mapID = 2248, x = 55.9, y = 60.0 },
        { name = "Runic Scroll",                questID = 83884, zone = "Ringing Deeps",  mapID = 2214, x = 48.6, y = 34.3 },
        { name = "Blue Earthen Pigment",        questID = 83885, zone = "Ringing Deeps",  mapID = 2214, x = 62.5, y = 58.15 },
        { name = "Calligrapher's Chiseled Marker",questID = 83887, zone = "Hallowfall",   mapID = 2215, x = 42.8, y = 49.1 },
        { name = "Informant's Fountain Pen",    questID = 83886, zone = "Hallowfall",     mapID = 2215, x = 43.2, y = 58.9 },
        { name = "Nerubian Texts",              questID = 83888, zone = "Azj-Kahet",      mapID = 2255, x = 55.9, y = 44.0 },
        { name = "Venomancer's Ink Well",       questID = 83889, zone = "City of Threads",mapID = 2216, x = 50.1, y = 30.6 },
    },

    Jewelcrafting = {
        { name = "Earthen Gem Pliers",          questID = 83891, zone = "Dornogal",       mapID = 2339, x = 34.8, y = 52.2 },
        { name = "Gentle Jewel Hammer",         questID = 83890, zone = "Isle of Dorn",   mapID = 2248, x = 63.5, y = 66.8 },
        { name = "Jeweler's Delicate Drill",    questID = 83893, zone = "Ringing Deeps",  mapID = 2214, x = 57.0, y = 54.6 },
        { name = "Carved Stone File",           questID = 83892, zone = "Ringing Deeps",  mapID = 2214, x = 48.5, y = 35.2 },
        { name = "Librarian's Magnifiers",      questID = 83895, zone = "Hallowfall",     mapID = 2215, x = 44.6, y = 50.9 },
        { name = "Arathi Sizing Gauges",        questID = 83894, zone = "Hallowfall",     mapID = 2215, x = 47.4, y = 60.6 },
        { name = "Nerubian Bench Blocks",       questID = 83897, zone = "Azj-Kahet",      mapID = 2255, x = 56.2, y = 58.8 },
        { name = "Ritual Caster's Crystal",     questID = 83896, zone = "City of Threads",mapID = 2216, x = 47.7, y = 19.4 },
    },

    Leatherworking = {
        { name = "Earthen Lacing Tools",        questID = 83898, zone = "Dornogal",       mapID = 2339, x = 68.2, y = 23.3 },
        { name = "Dornogal Craftsman's Flat Knife",questID = 83899, zone = "Isle of Dorn",mapID = 2248, x = 58.7, y = 30.7 },
        { name = "Underground Stropping Compound",questID = 83900, zone = "Ringing Deeps",mapID = 2214, x = 47.1, y = 34.8 },
        { name = "Earthen Awl",                 questID = 83901, zone = "Ringing Deeps",  mapID = 2214, x = 64.3, y = 65.4 },
        { name = "Arathi Leather Burnisher",    questID = 83903, zone = "Hallowfall",     mapID = 2215, x = 41.5, y = 57.8 },
        { name = "Arathi Beveler Set",          questID = 83902, zone = "Hallowfall",     mapID = 2215, x = 47.6, y = 65.1 },
        { name = "Curved Nerubian Skinning Knife",questID = 83905, zone = "Azj-Kahet",    mapID = 2255, x = 60.0, y = 53.9 },
        { name = "Nerubian Tanning Mallet",     questID = 83904, zone = "City of Threads",mapID = 2216, x = 55.2, y = 26.8 },
    },

    Mining = {
        { name = "Dornogal Chisel",             questID = 83907, zone = "Dornogal",       mapID = 2339, x = 36.6, y = 79.3 },
        { name = "Earthen Miner's Gavel",       questID = 83906, zone = "Isle of Dorn",   mapID = 2248, x = 58.2, y = 62.0 },
        { name = "Regenerating Ore",            questID = 83909, zone = "Ringing Deeps",  mapID = 2214, x = 66.2, y = 66.2 },
        { name = "Earthen Excavator's Shovel",  questID = 83908, zone = "Ringing Deeps",  mapID = 2214, x = 49.4, y = 27.5 },
        { name = "Arathi Precision Drill",      questID = 83910, zone = "Hallowfall",     mapID = 2215, x = 46.1, y = 64.4 },
        { name = "Devout Archaeologist's Excavator",questID = 83911, zone = "Hallowfall", mapID = 2215, x = 43.1, y = 56.8 },
        { name = "Heavy Spider Crusher",        questID = 83912, zone = "City of Threads",mapID = 2216, x = 46.8, y = 21.8 },
        { name = "Nerubian Mining Cart",        questID = 83913, zone = "City of Threads",mapID = 2216, x = 48.3, y = 40.8 },
    },

    Skinning = {
        { name = "Dornogal Carving Knife",      questID = 83914, zone = "Dornogal",       mapID = 2339, x = 28.8, y = 51.7 },
        { name = "Earthen Worker's Beams",      questID = 83915, zone = "Isle of Dorn",   mapID = 2248, x = 60.0, y = 28.0 },
        { name = "Artisan's Drawing Knife",     questID = 83916, zone = "Ringing Deeps",  mapID = 2214, x = 47.3, y = 28.3 },
        { name = "Fungarian's Rich Tannin",     questID = 83917, zone = "Ringing Deeps",  mapID = 2214, x = 65.8, y = 61.88 },
        { name = "Arathi Craftsman's Spokeshave",questID = 83919, zone = "Hallowfall",    mapID = 2215, x = 42.3, y = 53.8 },
        { name = "Arathi Tanning Agent",        questID = 83918, zone = "Hallowfall",     mapID = 2215, x = 49.3, y = 62.1 },
        { name = "Carapace Shiner",             questID = 83921, zone = "Azj-Kahet",      mapID = 2255, x = 56.6, y = 55.3 },
        { name = "Nerubian's Slicking Iron",    questID = 83920, zone = "City of Threads",mapID = 2216, x = 44.6, y = 49.3 },
    },

    Tailoring = {
        { name = "Dornogal Seam Ripper",        questID = 83922, zone = "Dornogal",       mapID = 2339, x = 61.5, y = 18.5 },
        { name = "Earthen Tape Measure",        questID = 83923, zone = "Isle of Dorn",   mapID = 2248, x = 56.2, y = 60.9 },
        { name = "Runed Earthen Pins",          questID = 83924, zone = "Ringing Deeps",  mapID = 2214, x = 48.9, y = 32.9 },
        { name = "Earthen Stitcher's Snips",    questID = 83925, zone = "Ringing Deeps",  mapID = 2214, x = 64.2, y = 60.3 },
        { name = "Arathi Rotary Cutter",        questID = 83926, zone = "Hallowfall",     mapID = 2215, x = 49.3, y = 62.3 },
        { name = "Royal Outfitter's Protractor",questID = 83927, zone = "Hallowfall",     mapID = 2215, x = 40.1, y = 68.1 },
        { name = "Nerubian Quilt",              questID = 83928, zone = "Azj-Kahet",      mapID = 2255, x = 53.3, y = 53.0 },
        { name = "Nerubian's Pincushion",       questID = 83929, zone = "City of Threads",mapID = 2216, x = 50.3, y = 16.6 },
    },
}


-- ============================================================================
-- WEEKLY KNOWLEDGE SOURCES
-- ============================================================================

-- Weekly Trainer Quests (crafting orders for crafters, turn-in for gatherers)
-- These reset weekly and give 2-3 KP
-- Quest IDs sourced from Wowhead
PKT.WeeklyQuests = {
    -- Crafting professions (via Kala Clayhoof - crafting orders)
    -- "X Services Requested" quests
    Alchemy = { 
        questID = 84133, -- "Alchemy Services Requested"
        name = "Alchemy Services Requested",
        maxKP = 2,
        type = "crafting_orders",
    },
    Blacksmithing = { 
        questID = 84127, -- "Blacksmithing Services Requested"
        name = "Blacksmithing Services Requested",
        maxKP = 2,
        type = "crafting_orders",
    },
    Enchanting = { 
        questID = 84131, -- "Enchanting Services Requested" 
        name = "Enchanting Services Requested",
        maxKP = 3,
        type = "crafting_orders",
    },
    Engineering = { 
        questID = 84128, -- "Engineering Services Requested"
        name = "Engineering Services Requested",
        maxKP = 1,
        type = "crafting_orders",
    },
    Inscription = { 
        questID = 84129, -- "Inscription Services Requested"
        name = "Inscription Services Requested",
        maxKP = 2,
        type = "crafting_orders",
    },
    Jewelcrafting = { 
        questID = 84130, -- "Jewelcrafting Services Requested"
        name = "Jewelcrafting Services Requested",
        maxKP = 2,
        type = "crafting_orders",
    },
    Leatherworking = { 
        questID = 84126, -- "Leatherworking Services Requested"
        name = "Leatherworking Services Requested",
        maxKP = 2,
        type = "crafting_orders",
    },
    Tailoring = { 
        questID = 84132, -- "Tailoring Services Requested"
        name = "Tailoring Services Requested",
        maxKP = 2,
        type = "crafting_orders",
    },
    -- Gathering professions (turn-in to trainer)
    -- These are "Gathering X" quests from trainers
    Herbalism = { 
        questID = 83097, -- Weekly herbalism turn-in
        name = "Herbalism Weekly",
        maxKP = 3,
        type = "trainer_quest",
    },
    Mining = { 
        questID = 83103, -- Weekly mining turn-in
        name = "Mining Weekly",
        maxKP = 3,
        type = "trainer_quest",
    },
    Skinning = { 
        questID = 83106, -- Weekly skinning turn-in
        name = "Skinning Weekly",
        maxKP = 3,
        type = "trainer_quest",
    },
}

-- Patron Order tracking
-- These give the bulk of weekly KP for crafters (16-24 per week)
-- Tracked via the profession currency system when profession window is open
PKT.PatronOrdersMax = {
    Alchemy = 16,       -- 8 orders x 2 KP each
    Blacksmithing = 24, -- 8 orders x 3 KP each  
    Enchanting = 0,     -- Enchanters don't get patron orders
    Engineering = 16,   -- 8 orders x 2 KP each
    Inscription = 24,   -- 8 orders x 3 KP each
    Jewelcrafting = 16, -- 8 orders x 2 KP each
    Leatherworking = 24,-- 8 orders x 3 KP each
    Tailoring = 24,     -- 8 orders x 3 KP each
}

-- Weekly Treasure Drop Items (from world treasures/dirt piles)
-- These are items you get from opening treasures in the world
PKT.WeeklyTreasureItems = {
    Alchemy = {
        { itemID = 225234, questID = 83253, name = "Alchemical Sediment", kp = 2 },
        { itemID = 225235, questID = 83255, name = "Deepstone Crucible", kp = 2 },
    },
    Blacksmithing = {
        { itemID = 225232, questID = 83257, name = "Coreway Billet", kp = 1 },
        { itemID = 225233, questID = 83256, name = "Dense Bladestone", kp = 1 },
    },
    Enchanting = {
        { itemID = 225230, questID = 83259, name = "Crystalline Repository", kp = 1 },
        { itemID = 225231, questID = 83258, name = "Powdered Fulgurance", kp = 1 },
    },
    Engineering = {
        { itemID = 225228, questID = 83260, name = "Rust-Locked Mechanism", kp = 1 },
        { itemID = 225229, questID = 83261, name = "Earthen Induction Coil", kp = 1 },
    },
    Inscription = {
        { itemID = 225226, questID = 83264, name = "Striated Inkstone", kp = 2 },
        { itemID = 225227, questID = 83262, name = "Wax-Sealed Records", kp = 2 },
    },
    Jewelcrafting = {
        { itemID = 225224, questID = 83265, name = "Diaphanous Gem Shards", kp = 2 },
        { itemID = 225225, questID = 83266, name = "Deepstone Fragment", kp = 2 },
    },
    Leatherworking = {
        { itemID = 225222, questID = 83268, name = "Stone-Leather Swatch", kp = 1 },
        { itemID = 225223, questID = 83267, name = "Sturdy Nerubian Carapace", kp = 1 },
    },
    Tailoring = {
        { itemID = 225220, questID = 83270, name = "Chitin Needle", kp = 1 },
        { itemID = 225221, questID = 83269, name = "Spool of Webweave", kp = 1 },
    },
}

-- Weekly Gathering/Disenchant Knowledge Items
-- Gatherers get 5x blue + 1x purple per week
PKT.WeeklyGatheringItems = {
    Herbalism = {
        blue = { 
            itemID = 224264, 
            name = "Deepgrove Petal", 
            max = 5, 
            kp = 1, 
            questIDs = {81416, 81417, 81418, 81419, 81420} 
        },
        purple = { 
            itemID = 224265, 
            name = "Deepgrove Rose", 
            max = 1, 
            kp = 3, -- Note: Source code lists this as 4 points, user lists 3
            questID = 81421 
        },
    },
    Mining = {
        blue = { 
            itemID = 224583, 
            name = "Slab of Slate", 
            max = 5, 
            kp = 1, 
            questIDs = {83050, 83051, 83052, 83053, 83054} 
        },
        purple = { 
            itemID = 224584, 
            name = "Erosion Polished Slate", 
            max = 1, 
            kp = 3, 
            questID = 83049 
        },
    },
    Skinning = {
        blue = { 
            itemID = 224780, 
            name = "Toughened Tempest Pelt", 
            max = 5, 
            kp = 1, 
            questIDs = {81459, 81460, 81461, 81462, 81463} 
        },
        purple = { 
            itemID = 224781, 
            name = "Abyssal Fur", 
            max = 1, 
            kp = 2, 
            questID = 81464 
        },
    },
    Enchanting = { 
        -- Note: Looted from Disenchanting
        blue = { 
            itemID = 227659, 
            name = "Fleeting Arcane Manifestation", 
            max = 5, 
            kp = 1, 
            questIDs = {84290, 84291, 84292, 84293, 84294} 
        },
        purple = { 
            itemID = 227661, 
            name = "Gleaming Telluric Crystal", 
            max = 1, 
            kp = 4, -- Note: Source code lists this as 4 points, user lists 3
            questID = 84295 
        },
    },
}

-- Treatise Items (1 per week from inscription crafting order)
PKT.TreatiseItems = {
    ["Alchemy"]        = { questID = 83725, itemID = 222546, name = "Algari Treatise on Alchemy" },
    ["Blacksmithing"]  = { questID = 83726, itemID = 222554, name = "Algari Treatise on Blacksmithing" },
    ["Enchanting"]     = { questID = 83727, itemID = 222550, name = "Algari Treatise on Enchanting" },
    ["Engineering"]    = { questID = 83728, itemID = 222621, name = "Algari Treatise on Engineering" },
    ["Herbalism"]      = { questID = 83729, itemID = 222552, name = "Algari Treatise on Herbalism" },
    ["Inscription"]    = { questID = 83730, itemID = 222548, name = "Algari Treatise on Inscription" },
    ["Jewelcrafting"]  = { questID = 83731, itemID = 222551, name = "Algari Treatise on Jewelcrafting" },
    ["Leatherworking"] = { questID = 83732, itemID = 222549, name = "Algari Treatise on Leatherworking" },
    ["Mining"]         = { questID = 83733, itemID = 222553, name = "Algari Treatise on Mining" },
    ["Skinning"]       = { questID = 83734, itemID = 222649, name = "Algari Treatise on Skinning" },
    ["Tailoring"]      = { questID = 83735, itemID = 222547, name = "Algari Treatise on Tailoring" },
}


-- ============================================================================
-- ONE-TIME SOURCES (besides treasures)
-- ============================================================================

-- Renown Books - Complete tracking data
-- Each book: itemID (for bag check), questID (for completion check), kp, faction, renown required
PKT.RenownBooks = {
    -- Council of Dornogal (Jewel-Etched) - Renown 12
    CouncilOfDornogal = {
        faction = "Council of Dornogal",
        renown = 12,
        vendor = "Auditor Balwurz",
        books = {
            Alchemy = { itemID = 224645, questID = 83058, name = "Jewel-Etched Alchemy Notes", kp = 10 },
            Blacksmithing = { itemID = 224647, questID = 83059, name = "Jewel-Etched Blacksmithing Notes", kp = 10 },
            Enchanting = { itemID = 224652, questID = 83060, name = "Jewel-Etched Enchanting Notes", kp = 10 },
            Tailoring = { itemID = 224648, questID = 83061, name = "Jewel-Etched Tailoring Notes", kp = 10 },
        },
    },
    -- Assembly of the Deeps (Machine-Learned) - Renown 12
    AssemblyOfTheDeeps = {
        faction = "Assembly of the Deeps",
        renown = 12,
        vendor = "Waxmonger Squick",
        books = {
            Mining = { itemID = 224651, questID = 83062, name = "Machine-Learned Mining Notes", kp = 15 },
            Engineering = { itemID = 224653, questID = 83063, name = "Machine-Learned Engineering Notes", kp = 10 },
            Inscription = { itemID = 224654, questID = 83064, name = "Machine-Learned Inscription Notes", kp = 10 },
        },
    },
    -- Hallowfall Arathi (Void-Lit) - Renown 14
    HallowfallArathi = {
        faction = "Hallowfall Arathi",
        renown = 14,
        vendor = "Auralia Steelstrike",
        books = {
            Herbalism = { itemID = 224656, questID = 83066, name = "Void-Lit Herbalism Notes", kp = 15 },
            Jewelcrafting = { itemID = 224655, questID = 83065, name = "Void-Lit Jewelcrafting Notes", kp = 10 },
            Leatherworking = { itemID = 224658, questID = 83067, name = "Void-Lit Leatherworking Notes", kp = 10 },
            Skinning = { itemID = 224659, questID = 83068, name = "Void-Lit Skinning Notes", kp = 15 },
        },
    },
    -- Cartels of Undermine (Undermine Treatise) - Renown 16 (Patch 11.1)
    CartelsOfUndermine = {
        faction = "Cartels of Undermine",
        renown = 16,
        vendor = "Smaks Topskimmer",
        books = {
            Alchemy = { itemID = 232499, questID = 85734, name = "Undermine Treatise on Alchemy", kp = 10 },
            Blacksmithing = { itemID = 232500, questID = 85735, name = "Undermine Treatise on Blacksmithing", kp = 10 },
            Enchanting = { itemID = 232501, questID = 85736, name = "Undermine Treatise on Enchanting", kp = 10 },
            Engineering = { itemID = 232507, questID = 85737, name = "Undermine Treatise on Engineering", kp = 10 },
            Herbalism = { itemID = 232503, questID = 85738, name = "Undermine Treatise on Herbalism", kp = 10 },
            Inscription = { itemID = 232504, questID = 85739, name = "Undermine Treatise on Inscription", kp = 10 },
            Jewelcrafting = { itemID = 232505, questID = 85740, name = "Undermine Treatise on Jewelcrafting", kp = 10 },
            Leatherworking = { itemID = 232506, questID = 85741, name = "Undermine Treatise on Leatherworking", kp = 10 },
            Mining = { itemID = 232509, questID = 85742, name = "Undermine Treatise on Mining", kp = 10 },
            Skinning = { itemID = 232508, questID = 85744, name = "Undermine Treatise on Skinning", kp = 10 },
            Tailoring = { itemID = 232502, questID = 85745, name = "Undermine Treatise on Tailoring", kp = 10 },
        },
    },
    -- K'aresh Trust (Ethereal Tome) - Renown 12 (Patch 11.2)
    KareshTrust = {
        faction = "K'aresh Trust",
        renown = 12,
        vendor = "Om'sirik",
        books = {
            Alchemy = { itemID = 235865, questID = 87255, name = "Ethereal Tome of Alchemy Knowledge", kp = 10 },
            Blacksmithing = { itemID = 235864, questID = 87266, name = "Ethereal Tome of Blacksmithing Knowledge", kp = 10 },
            Enchanting = { itemID = 235863, questID = 87265, name = "Ethereal Tome of Enchanting Knowledge", kp = 10 },
            Engineering = { itemID = 235862, questID = 87264, name = "Ethereal Tome of Engineering Knowledge", kp = 10 },
            Herbalism = { itemID = 235861, questID = 87263, name = "Ethereal Tome of Herbalism Knowledge", kp = 15 },
            Inscription = { itemID = 235860, questID = 87262, name = "Ethereal Tome of Inscription Knowledge", kp = 10 },
            Jewelcrafting = { itemID = 235859, questID = 87261, name = "Ethereal Tome of Jewelcrafting Knowledge", kp = 10 },
            Leatherworking = { itemID = 235858, questID = 87260, name = "Ethereal Tome of Leatherworking Knowledge", kp = 10 },
            Mining = { itemID = 235857, questID = 87259, name = "Ethereal Tome of Mining Knowledge", kp = 15 },
            Skinning = { itemID = 235856, questID = 87258, name = "Ethereal Tome of Skinning Knowledge", kp = 15 },
            Tailoring = { itemID = 235855, questID = 87257, name = "Ethereal Tome of Tailoring Knowledge", kp = 10 },
        },
    },
}

-- Helper: Get all renown books for a profession
function PKT.GetRenownBooksForProfession(profName)
    local books = {}
    for factionKey, factionData in pairs(PKT.RenownBooks) do
        if factionData.books and factionData.books[profName] then
            local book = factionData.books[profName]
            table.insert(books, {
                name = book.name,
                itemID = book.itemID,
                questID = book.questID,
                kp = book.kp,
                faction = factionData.faction,
                renown = factionData.renown,
                vendor = factionData.vendor,
            })
        end
    end
    return books
end

-- Artisan's Consortium Books (Lyrendal in Dornogal)
-- 3 books per profession, increasingly expensive
PKT.ArtisanBooks = {
    -- These are sold by Lyrendal in Dornogal for Artisan's Acuity.
    -- Crafting professions: 10 KP each. Gathering professions: 15 KP each.

    -- Crafting (10 KP)
    Alchemy = {
        { itemID = 227409, questID = 81146, name = "Faded Alchemist's Research", kp = 10, cost = 200 },
        { itemID = 227420, questID = 81147, name = "Exceptional Alchemist's Research", kp = 10, cost = 300 },
        { itemID = 227431, questID = 81148, name = "Pristine Alchemist's Research", kp = 10, cost = 400 },
    },
    Blacksmithing = {
        { itemID = 227407, questID = 84226, name = "Faded Blacksmith's Diagrams", kp = 10, cost = 200 },
        { itemID = 227418, questID = 84227, name = "Exceptional Blacksmith's Diagrams", kp = 10, cost = 300 },
        { itemID = 227429, questID = 84228, name = "Pristine Blacksmith's Diagrams", kp = 10, cost = 400 },
    },
    Enchanting = {
        { itemID = 227411, questID = 81076, name = "Faded Enchanter's Research", kp = 10, cost = 200 },
        { itemID = 227422, questID = 81077, name = "Exceptional Enchanter's Research", kp = 10, cost = 300 },
        { itemID = 227433, questID = 81078, name = "Pristine Enchanter's Research", kp = 10, cost = 400 },
    },
    Engineering = {
        { itemID = 227412, questID = 84229, name = "Faded Engineer's Scribblings", kp = 10, cost = 200 },
        { itemID = 227423, questID = 84230, name = "Exceptional Engineer's Scribblings", kp = 10, cost = 300 },
        { itemID = 227434, questID = 84231, name = "Pristine Engineer's Scribblings", kp = 10, cost = 400 },
    },
    Inscription = {
        { itemID = 227408, questID = 80749, name = "Faded Scribe's Runic Notes", kp = 10, cost = 200 },
        { itemID = 227419, questID = 80750, name = "Exceptional Scribe's Runic Notes", kp = 10, cost = 300 },
        { itemID = 227430, questID = 80751, name = "Pristine Scribe's Runic Notes", kp = 10, cost = 400 },
    },
    Jewelcrafting = {
        { itemID = 227413, questID = 81259, name = "Faded Jeweler's Illustrations", kp = 10, cost = 200 },
        { itemID = 227424, questID = 81260, name = "Exceptional Jeweler's Illustrations", kp = 10, cost = 300 },
        { itemID = 227435, questID = 81261, name = "Pristine Jeweler's Illustrations", kp = 10, cost = 400 },
    },
    Leatherworking = {
        { itemID = 227414, questID = 80978, name = "Faded Leatherworker's Diagrams", kp = 10, cost = 200 },
        { itemID = 227425, questID = 80979, name = "Exceptional Leatherworker's Diagrams", kp = 10, cost = 300 },
        { itemID = 227436, questID = 80980, name = "Pristine Leatherworker's Diagrams", kp = 10, cost = 400 },
    },
    Tailoring = {
        { itemID = 227410, questID = 80871, name = "Faded Tailor's Diagrams", kp = 10, cost = 200 },
        { itemID = 227421, questID = 80872, name = "Exceptional Tailor's Diagrams", kp = 10, cost = 300 },
        { itemID = 227432, questID = 80873, name = "Pristine Tailor's Diagrams", kp = 10, cost = 400 },
    },

    -- Gathering (15 KP)
    Herbalism = {
        { itemID = 227415, questID = 81422, name = "Faded Herbalist's Notes", kp = 15, cost = 200 },
        { itemID = 227426, questID = 81423, name = "Exceptional Herbalist's Notes", kp = 15, cost = 300 },
        { itemID = 227437, questID = 81424, name = "Pristine Herbalist's Notes", kp = 15, cost = 400 },
    },
    Mining = {
        { itemID = 227416, questID = 81390, name = "Faded Miner's Notes", kp = 15, cost = 200 },
        { itemID = 227427, questID = 81391, name = "Exceptional Miner's Notes", kp = 15, cost = 300 },
        { itemID = 227438, questID = 81392, name = "Pristine Miner's Notes", kp = 15, cost = 400 },
    },
    Skinning = {
        { itemID = 227417, questID = 84232, name = "Faded Skinner's Notes", kp = 15, cost = 200 },
        { itemID = 227428, questID = 84233, name = "Exceptional Skinner's Notes", kp = 15, cost = 300 },
        { itemID = 227439, questID = 84234, name = "Pristine Skinner's Notes", kp = 15, cost = 400 },
    },
}
-- Kej Books (from City of Threads, 565 Kej each, 10 KP)
PKT.KejBooks = {
    Alchemy = { itemID = 224024, questID = 82633, name = "Theories of Bodily Transmutation, Chapter 8", kp = 10, cost = 565 },
    Blacksmithing = { itemID = 224038, questID = 82631, name = "Smithing After Saronite", kp = 10, cost = 565 },
    Enchanting = { itemID = 224050, questID = 82635, name = "Web Sparkles: Pretty and Powerful", kp = 10, cost = 565 },
    Engineering = { itemID = 224052, questID = 82632, name = "Clocks, Gears, Sprockets, and Legs", kp = 10, cost = 565 },
    Inscription = { itemID = 224053, questID = 82636, name = "Eight Views on Defense of the Weave", kp = 10, cost = 565 },
    Jewelcrafting = { itemID = 224054, questID = 82637, name = "Emergent Crystals of the Surface-Dwellers", kp = 10, cost = 565 },
    Leatherworking = { itemID = 224056, questID = 82626, name = "Uses for Leftover Husks (After You Take Them Apart)", kp = 10, cost = 565 },
    Tailoring = { itemID = 224036, questID = 82634, name = "And That's A Web-Wrap!", kp = 10, cost = 565 },
    Herbalism = { itemID = 224023, questID = 82630, name = "Herbal Embalming Techniques", kp = 10, cost = 565 },
    Mining = { itemID = 224055, questID = 82614, name = "A Rocky Start", kp = 10, cost = 565 },
    Skinning = { itemID = 224007, questID = 82596, name = "Uses for Leftover Husks (After You Take Them Apart)", kp = 10, cost = 565 },
}

-- Darkmoon Faire (Monthly, 3 KP each profession)
PKT.DarkmoonFaire = {
    kpPerProfession = 3,
    note = "Monthly event, first week of each month",
}
