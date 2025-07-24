Config = {}

Config.ShameyDebug = false

Config.Webhook = "https://discord.com/api/webhooks/..."

Config.Timer = 12

Config.BlipLabel = "Doctor's Office"

Config.DownedBlipDuration = 10 -- time in minutes

-- Clock-in locations
Config.Locations = {
	{
		id = "Valentine",
		label = "Valentine",
		x = -287.5495,
		y = 812.0929,
		z = 119.25,
		UseBlip = true,
		BlipSprite = -1739686743,
	},
	{
		id = "Annesburg",
		label = "Annesburg",
		x = 2922.968017578125,
		y = 1356.3135986328125,
		z = 44.70999908447265,
		UseBlip = true,
		BlipSprite = -1739686743,
	},
	{
		id = "StDenis",
		label = "St. Denis",
		x = 2732.4,
		y = -1233.83,
		z = 50.7,
		UseBlip = true,
		BlipSprite = -1739686743,
	},
	{
		id = "Rhodes",
		label = "Rhodes",
		x = 1372.4566650390625,
		y = -1305.1201171875,
		z = 77.75,
		UseBlip = true,
		BlipSprite = -1739686743,
	},
	{
		id = "Strawberry",
		label = "Strawberry",
		x = -1808.89,
		y = -434.0,
		z = 158.72,
		UseBlip = true,
		BlipSprite = -1739686743,
	},
	{
		id = "Blackwater",
		label = "Blackwater",
		x = -785.69,
		y = -1306.2,
		z = 43.81,
		UseBlip = true,
		BlipSprite = -1739686743,
	},
	{
		id = "Armadillo",
		label = "Armadillo",
		x = -3738.99,
		y = -2636.93,
		z = -12.4,
		UseBlip = true,
		BlipSprite = -1739686743,
	},
	{
		id = "Tumbleweed",
		label = "Tumbleweed",
		x = -5528.01,
		y = -2952.85,
		z = -0.5,
		UseBlip = true,
		BlipSprite = -1739686743,
	},
	{
		id = "Limpany",
		label = "Limpany",
		x = -390.7796936035156,
		y = -136.54624938964844,
		z = 48.31000137329101,
		UseBlip = true,
		BlipSprite = -1739686743,
	},
}

Config.Jobs = {
	{
		job = "doctor",
		jobGrade = {
			{grade = 1, paycheck = 8, abilities = {"map"}},
			{grade = 2, paycheck = 10, abilities = {"map"}},
			{grade = 3, paycheck = 12, abilities = {"map", "heal", "revive"}},
		},
	},
}

--------

Config.NancyModel = "CS_MP_MABEL"

Config.NancyLocations = {
	["Valentine"] = {
        id = "Valentine",
        coords = vector4(-279.5765380859375, 798.694091796875, 118.33354949951172, 196.76),
    },
    ["Tumbleweed"] = {
        id = "Tumbleweed",
        coords = vector4(-5527.64453125, -2945.9990234375, -1.56427097320556, 312.21),
    },
    ["Armadillo"] = {
        id = "Armadillo",
        coords = vector4(-3728.32, -2639.83, -13.76, 270.81),
    },
    ["Rhodes"] = {
        id = "Rhodes",
        coords = vector4(1371.6947021484375, -1316.645263671875, 77.34083557128906, 143.5),
    },
    ["StDenis"] = {
        id = "StDenis",
        coords = vector4(2721.33, -1236.19, 49.98, 177.8),
    },
    ["Strawberry"] = {
        id = "Strawberry",
        coords = vector4(-1800.56, -426.59, 156.51, 339.64),
    },
    ["Blackwater"] = {
        id = "Blackwater",
        coords = vector4(-791.46, -1306.74, 43.63, 83.07),
    },
    ["Annesburg"] = {
        id = "Annesburg",
        coords = vector4(2929.03000000, 1357.1600000, 44.29000000, 252.12),
    },
	["Limpany"] = {
        id = "Limpany",
        coords = vector4(-382.86, -129.2, 47.1, 337.91),
    },
	["Colter"] = {
		id = "Colter",
		coords = vector4(-1358.21, 2422.62, 307.85, 253.61),
	},
}

Config.NancyDistance = 1.5

Config.NancyPromptLabel = "Use /ReviveMe to be revived  |  Price: ~o~$%.2f"

Config.NancyPrice = 269

--------

Config.CraftingLocations = {
	{
        name = "Doctor's Office",
        id = "ValentineDoctorsOffice",
        Job = { "doctor" },
		x = -288.2, y = 805.1, z = 119.39,
        Blip = {
            enable = false,
            Hash = -758970771
        },
        Categories = { "items", "meds" },
    },
	{
        name = "Doctor's Office",
        id = "StDenisDoctorsOffice",
        Job = { "doctor" },
        x = 2721.38,
        y = -1233.06, 
        z = 50.57,
        Blip = {
            enable = false,
            Hash = -758970771
        },
        Categories = { "items", "meds" },
    },
	{
        name = "Doctor's Office",
        id = "RhodesDoctorsOffice",
        Job = { "doctor" },
        x = 1369.6138916015625,
        y = -1306.5523681640625, 
        z = 78.0199966430664,
        Blip = {
            enable = false,
            Hash = -758970771
        },
        Categories = { "items", "meds" },
    },
	{
        name = "Doctor's Office",
        id = "StrawberryDoctorsOffice",
        Job = { "doctor" },
        x = -1805.39794921875,
        y = -429.481201171875, 
        z = 158.8787841796875,
        Blip = {
            enable = false,
            Hash = -758970771
        },
        Categories = { "items", "meds" },
    },
	{
        name = "Doctor's Office",
        id = "BlackwaterDoctorsOffice",
        Job = { "doctor" },
		x = -787.52,
		y = -1302.68,
		z = 43.81,
        Blip = {
            enable = false,
            Hash = -758970771
        },
        Categories = { "items", "meds" },
    },
	{
        name = "Doctor's Office",
        id = "AnnesburgDoctorsOffice",
        Job = { "doctor" },
        x = 2924.962158203125, 
		y = 1354.08642578125, 
		z = 44.93999862670898,
        Blip = {
            enable = false,
            Hash = -758970771
        },
        Categories = { "items", "meds" },
    },
	{
        name = "Doctor's Office",
        id = "LimpanyDoctorsOffice",
        Job = { "doctor" },
        x = -389.05169677734375, 
		y = -133.47767639160156, 
		z = 48.31999969482422,
        Blip = {
            enable = false,
            Hash = -758970771
        },
        Categories = { "items", "meds" },
    },
	{
		name = "Doctor's Office",
		id = "ArmadilloDoctorsOffice",
		Job = { "doctor" },
		x = -3735.05,
		y = -2639.54,
		z = -12.4,
		Blip = {
			enable = false,
			Hash = -758970771
		},
		Categories = { "items", "meds" },
	},
}

Config.CraftingLocationsArray = {"ValentineDoctorsOffice", "StDenisDoctorsOffice",
								 "RhodesDoctorsOffice", "StrawberryDoctorsOffice",
								 "BlackwaterDoctorsOffice", "AnnesburgDoctorsOffice",
								 "LimpanyDoctorsOffice", "ArmadilloDoctorsOffice"}

Config.CraftingRecipes = {
	{
		UID = "Bandage",
        Text = "Bandage",
        SubText = "InvMax = 20",
        Desc = "Recipe: 3x Cloth",
        Items = {
            {
                name = "cloth",
                count = 3
            }
        },
        Reward ={
            {
                name = "bandage",
                count = 1
            }
        },
        Type = "item",
		JobList = {
			{
				job = "doctor",
				jobGrade = 1,
			},
			{
				job = "doctor",
				jobGrade = 2,
			},
			{
				job = "doctor",
				jobGrade = 3,
			},
		},
        Location = Config.CraftingLocationsArray,
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "items",
		TakeItems = true
    },
	{
		UID = "CocaineSoakedBandage",
        Text = "Cocaine Soaked Bandage",
        SubText = "InvMax = 10",
        Desc = "Recipe: 1x Bandage, 1x Water, 1x Cocaine",
        Items = {
            {
                name = "bandage",
                count = 1
            },
			{
                name = "water",
                count = 1
            },
			{
                name = "cocaine",
                count = 1
            },
        },
        Reward ={
            {
                name = "cocaine_soaked_bandage",
                count = 1
            }
        },
        Type = "item", -- indicate if it is 'weapon' or 'item'
        JobList = {
			{
				job = "doctor",
				jobGrade = 2,
			},
			{
				job = "doctor",
				jobGrade = 3,
			},
		},
        Location = Config.CraftingLocationsArray,
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "items",
		TakeItems = true
    },
	{
		UID = "Laudanum",
        Text = "Laudanum",
        SubText = "InvMax = 10",
        Desc = "Recipe: 1x Opium, 1x Moonshine",
        Items = {
            {
                name = "opium",
                count = 1
            },
			{
                name = "moonshine",
                count = 1
            },
        },
        Reward ={
            {
                name = "laudanum",
                count = 1
            }
        },
        Type = "item", -- indicate if it is 'weapon' or 'item'
        JobList = {
			{
				job = "doctor",
				jobGrade = 2,
			},
			{
				job = "doctor",
				jobGrade = 3,
			},
		},
        Location = Config.CraftingLocationsArray,
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "items",
		TakeItems = true
    },
	{
		UID = "MedicalGanja",
        Text = "Medical Ganja",
        SubText = "InvMax = 25",
        Desc = "Recipe: 1x Processed Ganja, 2x Lavender, 1x Rolling Paper",
        Items = {
            {
                name = "ganja",
                count = 1
            },
			{
                name = "Lavender",
                count = 2
            },
			{
                name = "rollingpaper",
                count = 1
            },
        },
        Reward ={
            {
				name = "MedicalGanja",
				count = 1
			},
        },
        Type = "item", -- indicate if it is 'weapon' or 'item'
        JobList = {
			{
				job = "doctor",
				jobGrade = 3,
			},
		},
        Location = Config.CraftingLocationsArray,
        UseCurrencyMode = false,
        CurrencyType = 0,
        Category = "items",
		TakeItems = true
    },
}

Config.UseItems = {

	-- BANDAGES
	bandage = {
		Name = "bandage",
		Thirst = 0,
		Hunger = 0,
		Stamina = 0,
		InnerCoreHealth = 15,
		OuterCoreHealth = 10,
		Type = "bandage",
		Audio = {
			RDRCoreFillUpSound = true,
		},
	  },
	  cocaine_soaked_bandage = {
		Name = "cocaine_soaked_bandage",
		Thirst = 0,
		Hunger = 0,
		Stamina = 10,
		InnerCoreHealth = 40,
		OuterCoreHealth = 20,
		Type = "bandage",
		Audio = {
			RDRCoreFillUpSound = true,
		},
	  },

	  -- MEDICINES
	  laudanum = {
		Name = "laudanum",
		Thirst = 50,
		Hunger = 0,
		Stamina = 30,
		InnerCoreHealth = 50,
		OuterCoreHealth = 30,
		PropName = "p_medicine_fty",
		PropAnimType = "drink",
		Type = "medicine",
		Effect = {
			Name = "KingCastleBlue",
			Duration = 40 * 1000,
		},
		Audio = {
			RDRCoreFillUpSound = true,
		},
	  },
	  potion_healing = {
		Name = "potion_healing",
		Thirst = 50,
		Hunger = 0,
		Stamina = 20,
		InnerCoreHealth = 25,
		OuterCoreHealth = 20,
		PropName = "p_tonic01x",
		PropAnimType = "drink",
		Type = "medicine",
		Effect = {
			Name = "KingCastleBlue",
			Duration = 40 * 1000,
		},
		Audio = {
			RDRCoreFillUpSound = true,
		},
	  },

	  -- OTHER
	  pickled_panther_eye = {
		Name = "pickled_panther_eye",
		Thirst = 0,
		Hunger = 0,
		Stamina = 0,
		InnerCoreHealth = 0,
		OuterCoreHealth = 0,
		Type = "other",
		Effect = {
			Name = "PhotoMode_FilterModern02",
			Duration = 30 * 60 * 1000,
			Strength = 0.75,
		},
		Audio = {
			RDRCoreFillUpSound = true,
		},
		SpecialAnimation = {
			AnimDict = "mp_amb_player@world_human_eat_almonds_bar@sober@male_a@base",
			AnimName = "base",
		},
		CooldownInSeconds = 30 * 60,
	  },

	  -- Swamp Witch
	  ElixirOfInnerStrength = {
		Name = "ElixirOfInnerStrength",
		Thirst = -400,
		Hunger = -500,
		Metabolism = 0,
		Stamina = -60,
		InnerCoreHealth = -60,
		OuterCoreHealth = 0,
		InnerCoreHealthGold = 0.0,
		OuterCoreHealthGold = 0.0,
		InnerCoreStaminaGold = 0.0,
		OuterCoreStaminaGold = 0.0,
		PropName = "p_tonic01x",
		PropAnimType = "drink",
		Type = "other",
		CooldownInSeconds = 5,
	  },
	  SacredPotionOfCleansing = {
		Name = "SacredPotionOfCleansing",
		Thirst = 10,
		Hunger = 0,
		Stamina = 45,
		InnerCoreHealth = 40,
		OuterCoreHealth = 35,
		PropName = "p_tonic01x",
		PropAnimType = "drink",
		Type = "medicine",
		Audio = {
			RDRCoreFillUpSound = true,
		},
	  },
	  EyesOfTheVampire = {
		Name = "EyesOfTheVampire",
		Thirst = 0,
		Hunger = 0,
		Stamina = 0,
		InnerCoreHealth = 0,
		OuterCoreHealth = 0,
		PropName = "p_tonic01x",
		PropAnimType = "drink",
		Type = "other",
		Effect = {
			Name = "PhotoMode_FilterModern02",
			Duration = 20 * 60 * 1000,
			Strength = 0.75,
		},
		Audio = {
			RDRCoreFillUpSound = true,
		},
		CooldownInSeconds = 21 * 60,
	  },
	  

	  -- One Year Anniversary Item
	  RainbowElixir = {
		Name = "RainbowElixir",
		Thirst = 125,
		Hunger = 0,
		Stamina = 0,
		InnerCoreHealth = 0,
		OuterCoreHealth = 0,
		Golds = {
			InnerCoreHealthGold = 300.0,
			OuterCoreHealthGold = 300.0,
			InnerCoreStaminaGold = 300.0,
			OuterCoreStaminaGold = 300.0,
		},
		Stress = -300,
		PropName = "s_inv_flask01x",
		PropAnimType = "drink",
		Type = "other",
		Effect = {
			Name = "MP_Region",
			Duration = 30 * 60 * 1000,
			Strength = 0.10,
		},
		Audio = {
			RainbowCoreFileName = "higay.ogg",
		},
		CooldownInSeconds = 5 * 60,
	  },

	  -- CIGARETTES
	  cigarette = {
		Name = "cigarette",
		Thirst = 0,
		Hunger = 0,
		Metabolism = 0,
		Stamina = 0,
		InnerCoreHealth = 0,
		OuterCoreHealth = 0,
		InnerCoreHealthGold = 0.0,
		OuterCoreHealthGold = 0.0,
		InnerCoreStaminaGold = 0.0,
		OuterCoreStaminaGold = 0.0,
		Type = "cigarette",
		CigaretteType = "cigarette",
		Stress = -50,
	  },
	  CigarettePremium = {
		Name = "CigarettePremium",
		Thirst = 0,
		Hunger = 0,
		Metabolism = 0,
		Stamina = 0,
		InnerCoreHealth = 0,
		OuterCoreHealth = 0,
		InnerCoreHealthGold = 0.0,
		OuterCoreHealthGold = 0.0,
		InnerCoreStaminaGold = 0.0,
		OuterCoreStaminaGold = 0.0,
		Type = "cigarette",
		CigaretteType = "cigarette",
		Stress = -60,
	  },
	  CigarettePremiumMint = {
		Name = "CigarettePremiumMint",
		Thirst = 0,
		Hunger = 0,
		Metabolism = 0,
		Stamina = 10,
		InnerCoreHealth = 0,
		OuterCoreHealth = 0,
		InnerCoreHealthGold = 0.0,
		OuterCoreHealthGold = 0.0,
		InnerCoreStaminaGold = 0.0,
		OuterCoreStaminaGold = 0.0,
		Type = "cigarette",
		CigaretteType = "cigarette",
		Stress = -60,
	  },
	  cigar = {
		Name = "cigar",
		Thirst = 0,
		Hunger = 0,
		Metabolism = 0,
		Stamina = 0,
		InnerCoreHealth = 0,
		OuterCoreHealth = 0,
		InnerCoreHealthGold = 0.0,
		OuterCoreHealthGold = 0.0,
		InnerCoreStaminaGold = 0.0,
		OuterCoreStaminaGold = 0.0,
		Type = "cigarette",
		CigaretteType = "cigar",
		Stress = -70,
	  },
	  CigarPremium = {
		Name = "CigarPremium",
		Thirst = 0,
		Hunger = 0,
		Metabolism = 0,
		Stamina = 0,
		InnerCoreHealth = 0,
		OuterCoreHealth = 0,
		InnerCoreHealthGold = 0.0,
		OuterCoreHealthGold = 0.0,
		InnerCoreStaminaGold = 0.0,
		OuterCoreStaminaGold = 0.0,
		Type = "cigarette",
		CigaretteType = "cigar",
		Stress = -80,
	  },
	  CigarCocaine = {
		Name = "CigarCocaine",
		Thirst = 0,
		Hunger = 0,
		Metabolism = 0,
		Stamina = 10,
		InnerCoreHealth = 10,
		OuterCoreHealth = 20,
		InnerCoreHealthGold = 0.0,
		OuterCoreHealthGold = 0.0,
		InnerCoreStaminaGold = 0.0,
		OuterCoreStaminaGold = 0.0,
		Type = "cigarette",
		CigaretteType = "cigar",
		Stress = -80,
	  },
	  ganja_cigarette = {
		Name = "ganja_cigarette",
		Thirst = 0,
		Hunger = -50,
		Metabolism = 0,
		Stamina = 0,
		InnerCoreHealth = 0,
		OuterCoreHealth = 0,
		InnerCoreHealthGold = 0.0,
		OuterCoreHealthGold = 0.0,
		InnerCoreStaminaGold = 0.0,
		OuterCoreStaminaGold = 0.0,
		Type = "cigarette",
		CigaretteType = "cigarette",
		Stress = -150,
		Effect = {
			Name = "playerdrugshalluc01",
			Duration = 40 * 1000,
			Strength = 0.05,
			ShouldFadeIn = true,
		},
	  },
	  MedicalGanja = {
		Name = "MedicalGanja",
		Thirst = 0,
		Hunger = -50,
		Metabolism = 0,
		Stamina = 0,
		InnerCoreHealth = 0,
		OuterCoreHealth = 0,
		InnerCoreHealthGold = 0.0,
		OuterCoreHealthGold = 0.0,
		InnerCoreStaminaGold = 0.0,
		OuterCoreStaminaGold = 0.0,
		Type = "cigarette",
		CigaretteType = "cigarette",
		Stress = -200,
		Effect = {
			Name = "playerdrugshalluc01",
			Duration = 40 * 1000,
			Strength = 0.10,
			ShouldFadeIn = true,
		},
	  },
}

Config.CooldownsInSeconds = {
	Bandages = 30,
	Medicines = 60,
}

-------- BALMS --------
Config.BalmAnimation = {
	PutOnAnimDict = "ai_gestures@arthur@standing@speaker",
	PutOnAnimName = "neutral_fidget_rubchin_l_002",
}

Config.HealingBalm = {
	ItemName = "balm_healing",

	InnerHealthMax = 10,
	OuterHealthMax = 25,
	IntervalInMilliseconds = 60 * 1000,
	IntervalMax = 3,
	
	UseNotification = "You apply the healing balm directly to your face.",
	EffectNotification = "You notice an effect from your healing balm.",
}



Config.Smoking = {
	Keys = {
		Stop = `INPUT_CONTEXT_B`, -- F
		Inhale = `INPUT_CONTEXT_RT`, -- LEFT-CLICK
		ChangeStance = `INPUT_CONTEXT_Y`, -- E
	},
	Anims = {
		Feminine = {
			SmokingABase = "amb_rest@world_human_smoking@female_a@base",
			SmokingBBase = "amb_rest@world_human_smoking@female_b@base",
			SmokingCBase = "amb_rest@world_human_smoking@female_c@base",
			SmokingAIdleB = "amb_rest@world_human_smoking@female_a@idle_b",
			SmokingBIdleB = "amb_rest@world_human_smoking@female_b@idle_b",
			SmokingCIdleA = "amb_rest@world_human_smoking@female_c@idle_a",
			SmokingCIdleB = "amb_rest@world_human_smoking@female_c@idle_b",
			SmokingAIdleA = "amb_rest@world_human_smoking@female_a@idle_a",
			SmokingBIdleA = "amb_rest@world_human_smoking@female_b@idle_a",
			TranisitionB = "amb_rest@world_human_smoking@female_b@trans",
		},
		Masculine = {
			SmokingABase = "amb_wander@code_human_smoking_wander@male_a@base",
			SmokingBBase = "amb_rest@world_human_smoking@nervous_stressed@male_b@base",
			SmokingCBase = "amb_rest@world_human_smoking@male_c@base",
			SmokingDBase = "amb_rest@world_human_smoking@male_d@base",
			SmokingBIdleA = "amb_rest@world_human_smoking@nervous_stressed@male_b@idle_a",
			SmokingBIdleC = "amb_rest@world_human_smoking@nervous_stressed@male_b@idle_c",
			SmokingCIdleA = "amb_rest@world_human_smoking@male_c@idle_a",
			SmokingDIdleA = "amb_rest@world_human_smoking@male_d@idle_a",
			SmokingDIdleC = "amb_rest@world_human_smoking@male_d@idle_c",
			SmokingAIdleA = "amb_rest@world_human_smoking@male_a@idle_a",
			TransitionA = "amb_rest@world_human_smoking@male_a@trans",
			TransitionD = "amb_rest@world_human_smoking@male_d@trans",
		},
	},
}