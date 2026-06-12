-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
ItemList = {}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THREADSTARTSERVER
-----------------------------------------------------------------------------------------------------------------------------------------
CreateThread(function()
	for Index,v in pairs(List) do
		local Result = {}
		for Key,Recipe in pairs(v.List) do
			Result[#Result + 1] = {
				key = Key,
				price = Recipe.Amount,
				required = Recipe.Required
			}
		end

		ItemList[Index] = Result
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------
-- LOCATIONS
Location = {

	---------------------------------------------------------------------
	-- BANCADAS DAS FACÇÕES (distribuídas aleatoriamente, sem blueprint)
	---------------------------------------------------------------------
	{ Coords = vec3(1931.16, 711.54, 194.38), Mode = "rifle_bench", Circle = 0.5, Perm = "IRLANDA" },
	{ Coords = vec3(1233.12, -255.44, 76.36), Mode = "ammo_bench", Circle = 0.5, Perm = "GROTA" },
	{ Coords = vec3(181.3, 637.13, 207.44), Mode = "drugs_bench", Circle = 0.5, Perm = "VATICANO" },
	{ Coords = vec3(1320.14, -781.02, 79.09), Mode = "smg_bench", Circle = 0.5, Perm = "EGITO" },
	{ Coords = vec3(1392.84, 1128.51, 109.74), Mode = "pistol_bench", Circle = 0.5, Perm = "CARTEL" },
	{ Coords = vec3(805.09, 1838.38, 138.98), Mode = "rifle_bench", Circle = 0.5, Perm = "ROXOS" },          
	{ Coords = vec3(-2967.25, 2158.11, 41.89), Mode = "illegal_bench", Circle = 0.5, Perm = "HELIPA" },
	{ Coords = vec3(-3361.64, 1799.66, 26.13), Mode = "ammo_bench", Circle = 0.5, Perm = "FRANCA" },
	{ Coords = vec3(-3150.68, 1396.74, 24.75), Mode = "rifle_bench", Circle = 0.5, Perm = "ELEMENTS" },
	{ Coords = vec3(-1178.92, -1749.07, 8.53), Mode = "drugs_bench", Circle = 0.5, Perm = "ESCOCIA" },
	{ Coords = vec3(-571.56, 289.55, 79.18), Mode = "pistol_bench", Circle = 0.5, Perm = "TEQUILA" },
	{ Coords = vec3(-1563.3, 784.22, 189.19), Mode = "smg_bench", Circle = 0.5, Perm = "MEDELLIN" },
	{ Coords = vec3(-3368.14, 1132.21, 9.65), Mode = "drugs_bench", Circle = 0.5, Perm = "YAKUZA" },          
	{ Coords = vec3(119.9, 6735.54, 46.44), Mode = "illegal_bench", Circle = 0.5, Perm = "ALEMANHA" },
	{ Coords = vec3(1800.84, 4523.99, 40.39), Mode = "rifle_bench", Circle = 0.5, Perm = "PAQUISTAO" },
	{ Coords = vec3(2023.86, 3348.4, 46.79), Mode = "ammo_bench", Circle = 0.5, Perm = "MAGNATAS" },
	{ Coords = vec3(1396.58, -2490.4, 60.57), Mode = "drugs_bench", Circle = 0.5, Perm = "PSICO" },
	{ Coords = vec3(-2679.4, 1327.56, 144.25), Mode = "smg_bench", Circle = 0.5, Perm = "RUSSIA" },
	{ Coords = vec3(995.06, -1845.09, 21.38), Mode = "pistol_bench", Circle = 0.5, Perm = "INFINITY" },
	{ Coords = vec3(292.48, -2077.58, 17.71), Mode = "ammo_bench", Circle = 0.5, Perm = "ANONYMOUS" },       
	{ Coords = vec3(2549.75, 3749.74, 62.8), Mode = "illegal_bench", Circle = 0.5, Perm = "Aztecas" },
	{ Coords = vec3(2412.82, 5000.95, 38.28), Mode = "rifle_bench", Circle = 0.5, Perm = "FAZENNDINHA" },
	{ Coords = vec3(1012.57, -895.12, 17.81), Mode = "ammo_bench", Circle = 0.5, Perm = "BABEL" },
	--{ Coords = vec3(748.07, -548.99, 33.63), Mode = "smg_bench", Circle = 0.5, Perm = "ABSOLUT" },
	{ Coords = vec3(1963.92, 3841.81, 32.12), Mode = "pistol_bench", Circle = 0.5, Perm = "GRECIA" },
	{ Coords = vec3(-298.98, 1566.77, 360.89), Mode = "drugs_bench", Circle = 0.5, Perm = "ITALIA" },

	---------------------------------------------------------------------
	-- OUTRAS BANCADAS (mantidas)
	---------------------------------------------------------------------
	{ Coords = vec3(-327.11,-162.23,40.34), Mode = "Mecanico", Circle = 0.3, Perm = "Bennys" },
	{ Coords = vec3(1110.8,-2008.75,31.43), Mode = "Furnace", Circle = 0.3 },
	{ Coords = vec3(-591.42,-1064.43,22.33), Mode = "FoodRestaurante", Circle = 0.3, Perm = "Restaurante" },
	{ Coords = vec3(-591.42,-1059.73,22.33), Mode = "DrinkRestaurante", Circle = 0.3, Perm = "Restaurante" },
	{ Coords = vec3(87.62,-1670.45,29.18), Mode = "Essence", Circle = 0.5 },
}




-----------------------------------------------------------------------------------------------------------------------------------------
-- LIST
-----------------------------------------------------------------------------------------------------------------------------------------
List = {
	Essence = {
		List = {
			purple_essence = {
				Amount = 1,
				Required = {
					blue_essence = 10
				}
			},
			green_essence = {
				Amount = 1,
				Required = {
					purple_essence = 10
				}
			},
			red_essence = {
				Amount = 1,
				Required = {
					green_essence = 10
				}
			},
			pink_essence = {
				Amount = 1,
				Required = {
					red_essence = 10
				}
			}
		}
	},
	FoodRestaurante = {
		Permission = "Restaurante",
		List = {
			nigirizushi = {
				Amount = 3,
				Required = {
					fishfillet = 3,
					ricebag = 1
				}
			},
			sushi = {
				Amount = 2,
				Required = {
					fishfillet = 2,
					sugarbox = 1
				}
			},
			cupcake = {
				Amount = 3,
				Required = {
					milkbottle = 1,
					chocolate = 1,
					sugarbox = 1
				}
			},
			applelove = {
				Amount = 2,
				Required = {
					sugarbox = 1,
					apple = 1
				}
			},
			cookies = {
				Amount = 3,
				Required = {
					milkbottle = 1,
					chocolate = 1,
					sugarbox = 1
				}
			},
			hamburger2 = {
				Amount = 1,
				Required = {
					meatfillet = 1,
					mayonnaise = 1,
					ryebread = 1
				}
			},
			hamburger3 = {
				Amount = 1,
				Required = {
					meatfillet = 1,
					mayonnaise = 1,
					ryebread = 1
				}
			},
			pizzamozzarella = {
				Amount = 1,
				Required = {
					milkbottle = 1,
					ryebread = 1,
					water = 1,
					tomato = 1
				}
			},
			pizzabanana = {
				Amount = 1,
				Required = {
					milkbottle = 1,
					ryebread = 1,
					water = 1,
					banana = 1
				}
			},
			pizzachocolate = {
				Amount = 1,
				Required = {
					milkbottle = 1,
					ryebread = 1,
					water = 1,
					chocolate = 1
				}
			}
		}
	},
	DrinkRestaurante = {
		Permission = "Restaurante",
		List = {
			milkshake = {
				Amount = 1,
				Required = {
					milkbottle = 1,
					strawberry = 1
				}
			},
			cappuccino = {
				Amount = 1,
				Required = {
					milkbottle = 1,
					chocolate = 1,
					coffee = 1
				}
			},
			passionjuice = {
				Amount = 1,
				Required = {
					passion = 2,
					water = 1
				}
			},
			tangejuice = {
				Amount = 1,
				Required = {
					tange = 1,
					water = 1
				}
			},
			orangejuice = {
				Amount = 1,
				Required = {
					orange = 1,
					water = 1
				}
			},
			applejuice = {
				Amount = 1,
				Required = {
					apple = 1,
					water = 1
				}
			},
			grapejuice = {
				Amount = 1,
				Required = {
					grape = 1,
					water = 1
				}
			},
			lemonjuice = {
				Amount = 1,
				Required = {
					lemon = 1,
					water = 1
				}
			},
			bananajuice = {
				Amount = 1,
				Required = {
					banana = 1,
					water = 1
				}
			},
			acerolajuice = {
				Amount = 1,
				Required = {
					acerola = 1,
					water = 1
				}
			},
			strawberryjuice = {
				Amount = 1,
				Required = {
					strawberry = 1,
					water = 1
				}
			},
			blueberryjuice = {
				Amount = 1,
				Required = {
					blueberry = 1,
					water = 1
				}
			},
			coffeemilk = {
				Amount = 1,
				Required = {
					coffee = 1,
					milkbottle = 1
				}
			}
		}
	},
	Furnace = {
		List = {
			plastic = {
				Amount = 25,
				Required = {
					emptybottle = 3,
					WEAPON_PETROLCAN_AMMO = 5000
				}
			},
			glass = {
				Amount = 5,
				Required = {
					sand = 1
				}
			},
			latex = {
				Amount = 1,
				Required = {
					woodlog = 5,
					emptybottle = 1
				}
			},
			rubber = {
				Amount = 20,
				Required = {
					latex = 1
				}
			},
			aluminum = {
				Amount = 5,
				Required = {
					bauxite = 1
				}
			},
			copper = {
				Amount = 5,
				Required = {
					chalcopyrite = 1
				}
			}
		}
	},
	Mecanico = {
		List = {
			coilover = {
				Amount = 1,
				Required = {
					screws = 24,
					screwnuts = 24,
					copper = 725,
					aluminum = 725,
					metalspring = 4,
					sheetmetal = 10,
					roadsigns = 4,
					scotchtape = 2,
					insulatingtape = 2,
					scrapmetal = 425
				}
			},
			advtoolbox = {
				Amount = 1,
				Required = {
					screws = 2,
					screwnuts = 2,
					rubber = 100,
					copper = 85,
					aluminum = 75
				}
			},
			toolbox = {
				Amount = 1,
				Required = {
					screws = 1,
					screwnuts = 1,
					rubber = 50,
					copper = 18,
					aluminum = 15
				}
			},
			tyres = {
				Amount = 1,
				Required = {
					rubber = 35
				}
			},
			plate = {
				Amount = 1,
				Required = {
					copper = 50,
					aluminum = 45
				}
			},
			nitro = {
				Amount = 1,
				Required = {
					scotchtape = 2,
					insulatingtape = 1,
					screws = 2,
					screwnuts = 2,
					glass = 125,
					copper = 60,
					aluminum = 55
				}
			}
		}
	},
	pistol_bench = {
		List = {
			WEAPON_PISTOL = {
				Amount = 1,
				Required = {
					pistolbody = 1,
					weaponparts = 3,
					metalspring = 1,
					glass = 100,
					rubber = 100,
					plastic = 120,
					copper = 75,
					aluminum = 75
				}
			},
			WEAPON_PISTOL_MK2 = {
				Amount = 1,
				Required = {
					pistolbody = 1,
					weaponparts = 3,
					metalspring = 1,
					glass = 115,
					rubber = 115,
					plastic = 135,
					copper = 75,
					aluminum = 75
				}
			},
			WEAPON_HEAVYPISTOL = {
				Amount = 1,
				Required = {
					pistolbody = 1,
					weaponparts = 5,
					metalspring = 1,
					glass = 155,
					rubber = 155,
					plastic = 175,
					copper = 100,
					aluminum = 100
				}
			},
			WEAPON_SNSPISTOL = {
				Amount = 1,
				Required = {
					pistolbody = 1,
					weaponparts = 3,
					metalspring = 1,
					glass = 75,
					rubber = 100,
					plastic = 65,
					copper = 55,
					aluminum = 65
				}
			},
			WEAPON_SNSPISTOL_MK2 = {
				Amount = 1,
				Required = {
					pistolbody = 1,
					weaponparts = 3,
					metalspring = 1,
					glass = 75,
					rubber = 100,
					plastic = 110,
					copper = 75,
					aluminum = 75
				}
			},
			WEAPON_VINTAGEPISTOL = {
				Amount = 1,
				Required = {
					pistolbody = 1,
					weaponparts = 3,
					metalspring = 1,
					glass = 75,
					rubber = 75,
					plastic = 100,
					copper = 50,
					aluminum = 50
				}
			},
			WEAPON_PISTOL50 = {
				Amount = 1,
				Required = {
					pistolbody = 1,
					weaponparts = 5,
					metalspring = 1,
					glass = 155,
					rubber = 155,
					plastic = 165,
					copper = 100,
					aluminum = 100
				}
			},
			WEAPON_COMBATPISTOL = {
				Amount = 1,
				Required = {
					pistolbody = 1,
					weaponparts = 3,
					metalspring = 1,
					glass = 115,
					rubber = 125,
					plastic = 125,
					copper = 75,
					aluminum = 75
				}
			}
		}
	},
	smg_bench = {
		List = {
			WEAPON_APPISTOL = {
				Amount = 1,
				Required = {
					smgbody = 1,
					weaponparts = 5,
					metalspring = 2,
					glass = 145,
					rubber = 145,
					plastic = 155,
					copper = 100,
					aluminum = 100
				}
			},
			WEAPON_MACHINEPISTOL = {
				Amount = 1,
				Required = {
					smgbody = 1,
					weaponparts = 5,
					metalspring = 2,
					glass = 145,
					rubber = 145,
					plastic = 155,
					copper = 100,
					aluminum = 100
				}
			},
			WEAPON_MICROSMG = {
				Amount = 1,
				Required = {
					smgbody = 1,
					weaponparts = 5,
					metalspring = 2,
					glass = 225,
					rubber = 235,
					plastic = 275,
					copper = 175,
					aluminum = 175
				}
			},
			WEAPON_MINISMG = {
				Amount = 1,
				Required = {
					smgbody = 1,
					weaponparts = 5,
					metalspring = 2,
					glass = 225,
					rubber = 235,
					plastic = 275,
					copper = 175,
					aluminum = 175
				}
			},
			WEAPON_SMG = {
				Amount = 1,
				Required = {
					smgbody = 1,
					weaponparts = 5,
					metalspring = 2,
					glass = 275,
					rubber = 305,
					plastic = 315,
					copper = 225,
					aluminum = 225
				}
			},
			WEAPON_SMG_MK2 = {
				Amount = 1,
				Required = {
					smgbody = 1,
					weaponparts = 5,
					metalspring = 2,
					glass = 375,
					rubber = 305,
					plastic = 305,
					copper = 225,
					aluminum = 225
				}
			},
			WEAPON_GUSENBERG = {
				Amount = 1,
				Required = {
					smgbody = 1,
					weaponparts = 5,
					metalspring = 2,
					glass = 275,
					rubber = 305,
					plastic = 305,
					copper = 225,
					aluminum = 225
				}
			}
		}
	},
	rifle_bench = {
		List = {
			WEAPON_PUMPSHOTGUN = {
				Amount = 1,
				Required = {
					riflebody = 1,
					weaponparts = 5,
					metalspring = 1,
					glass = 225,
					rubber = 265,
					plastic = 255,
					copper = 175,
					aluminum = 175
				}
			},
			WEAPON_PUMPSHOTGUN_MK2 = {
				Amount = 1,
				Required = {
					riflebody = 1,
					weaponparts = 8,
					metalspring = 2,
					glass = 375,
					rubber = 425,
					plastic = 345,
					copper = 175,
					aluminum = 175
				}
			},
			WEAPON_SAWNOFFSHOTGUN = {
				Amount = 1,
				Required = {
					riflebody = 1,
					weaponparts = 5,
					metalspring = 1,
					glass = 225,
					rubber = 255,
					plastic = 265,
					copper = 175,
					aluminum = 175
				}
			},
			WEAPON_COMPACTRIFLE = {
				Amount = 1,
				Required = {
					riflebody = 1,
					weaponparts = 8,
					metalspring = 2,
					glass = 305,
					rubber = 325,
					plastic = 265,
					copper = 175,
					aluminum = 175
				}
			},
			WEAPON_CARBINERIFLE = {
				Amount = 1,
				Required = {
					riflebody = 1,
					weaponparts = 10,
					metalspring = 3,
					glass = 405,
					rubber = 405,
					plastic = 405,
					copper = 345,
					aluminum = 335
				}
			},
			WEAPON_CARBINERIFLE_MK2 = {
				Amount = 1,
				Required = {
					riflebody = 1,
					weaponparts = 10,
					metalspring = 3,
					glass = 405,
					rubber = 415,
					plastic = 375,
					copper = 355,
					aluminum = 375
				}
			},
			WEAPON_ADVANCEDRIFLE = {
				Amount = 1,
				Required = {
					riflebody = 1,
					weaponparts = 10,
					metalspring = 3,
					glass = 385,
					rubber = 405,
					plastic = 405,
					copper = 335,
					aluminum = 325
				}
			},
			WEAPON_BULLPUPRIFLE = {
				Amount = 1,
				Required = {
					riflebody = 1,
					weaponparts = 10,
					metalspring = 3,
					glass = 385,
					rubber = 465,
					plastic = 400,
					copper = 325,
					aluminum = 325
				}
			},
			WEAPON_BULLPUPRIFLE_MK2 = {
				Amount = 1,
				Required = {
					riflebody = 1,
					weaponparts = 10,
					metalspring = 3,
					glass = 305,
					rubber = 425,
					plastic = 425,
					copper = 300,
					aluminum = 425
				}
			},
			WEAPON_SPECIALCARBINE = {
				Amount = 1,
				Required = {
					riflebody = 1,
					weaponparts = 10,
					metalspring = 3,
					glass = 305,
					rubber = 425,
					plastic = 425,
					copper = 425,
					aluminum = 300
				}
			},
			WEAPON_SPECIALCARBINE_MK2 = {
				Amount = 1,
				Required = {
					riflebody = 1,
					weaponparts = 10,
					metalspring = 3,
					glass = 275,
					rubber = 400,
					plastic = 400,
					copper = 425,
					aluminum = 345
				}
			},
			WEAPON_TACTICALRIFLE = {
				Amount = 1,
				Required = {
					riflebody = 1,
					weaponparts = 10,
					metalspring = 3,
					glass = 275,
					rubber = 400,
					plastic = 400,
					copper = 345,
					aluminum = 425
				}
			},
			WEAPON_HEAVYRIFLE = {
				Amount = 1,
				Required = {
					riflebody = 1,
					weaponparts = 10,
					metalspring = 3,
					glass = 305,
					rubber = 425,
					plastic = 425,
					copper = 335,
					aluminum = 375
				}
			},
			WEAPON_ASSAULTRIFLE = {
				Amount = 1,
				Required = {
					riflebody = 1,
					weaponparts = 10,
					metalspring = 3,
					glass = 305,
					rubber = 425,
					plastic = 425,
					copper = 425,
					aluminum = 300
				}
			},
			WEAPON_ASSAULTRIFLE_MK2 = {
				Amount = 1,
				Required = {
					riflebody = 1,
					weaponparts = 10,
					metalspring = 3,
					glass = 275,
					rubber = 400,
					plastic = 400,
					copper = 425,
					aluminum = 345
				}
			}
		}
	},
	blueprint_bench = {
		List = {
			blueprint_gauze = {
				Amount = 1,
				Required = {
					blueprint_fragment = 2500
				}
			},
			blueprint_bandage = {
				Amount = 1,
				Required = {
					blueprint_fragment = 5500
				}
			}
		}
	},
	drugs_bench = {
		List = {
			cocaine = {
				Amount = 1,
				Required = {
					coke = 1
				}
			},
			cokesack = {
				Amount = 1,
				Required = {
					cocaine = 10
				}
			},
			joint = {
				Amount = 1,
				Required = {
					weed = 1
				}
			},
			weedsack = {
				Amount = 1,
				Required = {
					joint = 10
				}
			},
			meth = {
				Amount = 5,
				Required = {
					saline = 1,
					sulfuric = 1
				}
			},
			methsack = {
				Amount = 1,
				Required = {
					meth = 10
				}
			},
			crack = {
				Amount = 1,
				Required = {
					cocaine = 10,
					acetone = 2
				}
			},
			heroin = {
				Amount = 1,
				Required = {
					meth = 7,
					saline = 2,
					alcohol = 2,
					sulfuric = 2
				}
			},
			metadone = {
				Amount = 1,
				Required = {
					analgesic = 1,
					sulfuric = 2,
					alcohol = 2
				}
			},
			codeine = {
				Amount = 1,
				Required = {
					analgesic = 1,
					sulfuric = 2,
					alcohol = 2
				}
			},
			amphetamine = {
				Amount = 1,
				Required = {
					meth = 6,
					cocaine = 6
				}
			}
		}
	},
	Lester = {
		Permission = "Lester",
		List = {
			ballisticplate = {
				Amount = 1,
				Required = {
					tarp = 3,
					sheetmetal = 3,
					roadsigns = 3,
					copper = 20,
					aluminum = 15
				}
			},
			repairkit01 = {
				Amount = 1,
				Required = {
					sheetmetal = 1,
					roadsigns = 1,
					scotchtape = 1,
					copper = 10,
					aluminum = 12
				}
			},
			repairkit02 = {
				Amount = 1,
				Required = {
					sheetmetal = 2,
					roadsigns = 2,
					scotchtape = 2,
					copper = 20,
					aluminum = 25
				}
			},
			repairkit03 = {
				Amount = 1,
				Required = {
					sheetmetal = 4,
					roadsigns = 4,
					scotchtape = 4,
					copper = 70,
					aluminum = 75
				}
			},
			repairkit04 = {
				Amount = 1,
				Required = {
					sheetmetal = 10,
					roadsigns = 10,
					scotchtape = 10,
					copper = 130,
					aluminum = 100
				}
			},
			racesticket = {
				Amount = 1,
				Required = {
					plastic = 25,
					dirtydollar = 2025
				}
			},
			racestablet = {
				Amount = 1,
				Required = {
					screws = 4,
					copper = 100,
					aluminum = 100,
					metalspring = 1,
					sheetmetal = 2
				}
			},
			lockpick = {
				Amount = 1,
				Required = {
					copper = 30,
					aluminum = 30,
					sheetmetal = 2
				}
			},
			dismantle = {
				Amount = 1,
				Required = {
					plastic = 25,
					dirtydollar = 975
				}
			},
			handcuff = {
				Amount = 1,
				Required = {
					copper = 60,
					aluminum = 65
				}
			},
			hood = {
				Amount = 1,
				Required = {
					tarp = 5,
					rubber = 85
				}
			},
			blocksignal = {
				Amount = 1,
				Required = {
					plastic = 80
				}
			},
			WEAPON_SHOTGUN_AMMO = {
				Amount = 4,
				Required = {
					aluminum = 7,
					gunpowder = 1
				}
			},
			WEAPON_PISTOL_AMMO = {
				Amount = 15,
				Required = {
					copper = 10,
					gunpowder = 1
				}
			},
			WEAPON_SMG_AMMO = {
				Amount = 15,
				Required = {
					copper = 8,
					aluminum = 8,
					gunpowder = 1
				}
			},
			WEAPON_RIFLE_AMMO = {
				Amount = 15,
				Required = {
					copper = 10,
					aluminum = 15,
					gunpowder = 1
				}
			},
			ATTACH_FLASHLIGHT = {
				Amount = 1,
				Required = {
					scotchtape = 1,
					insulatingtape = 1,
					batteryaa = 1,
					batteryaaplus = 1,
					glass = 75,
					plastic = 75
				}
			},
			ATTACH_CROSSHAIR = {
				Amount = 1,
				Required = {
					scotchtape = 1,
					insulatingtape = 1,
					batteryaa = 1,
					batteryaaplus = 1,
					glass = 95,
					plastic = 95,
					copper = 25
				}
			},
			ATTACH_SILENCER = {
				Amount = 1,
				Required = {
					scotchtape = 5,
					insulatingtape = 5,
					emptybottle = 1,
					toothpaste = 1,
					plastic = 200,
					copper = 200
				}
			},
			ATTACH_MAGAZINE = {
				Amount = 1,
				Required = {
					scotchtape = 1,
					insulatingtape = 1,
					rubber = 95,
					plastic = 95,
					aluminum = 25
				}
			},
			ATTACH_GRIP = {
				Amount = 1,
				Required = {
					scotchtape = 1,
					insulatingtape = 1,
					electroniccomponents = 1,
					rubber = 65,
					plastic = 65
				}
			}
		}
	},
	ammo_bench = {
		List = {
	
			-- SHOTGUN (Curta distância / alto impacto)
			WEAPON_SHOTGUN_AMMO = {
				Amount = 4,
				Required = {
					aluminum = 12,
					gunpowder = 2
				}
			},
	
			-- PISTOL (Tier baixo)
			WEAPON_PISTOL_AMMO = {
				Amount = 10,
				Required = {
					copper = 15,
					gunpowder = 2
				}
			},
	
			-- SMG (Tier médio)
			WEAPON_SMG_AMMO = {
				Amount = 10,
				Required = {
					copper = 20,
					aluminum = 15,
					gunpowder = 2
				}
			},
	
			-- RIFLE (Tier alto)
			WEAPON_RIFLE_AMMO = {
				Amount = 8,
				Required = {
					copper = 30,
					aluminum = 25,
					gunpowder = 3
				}
			}
		}
	},
	illegal_bench = {
		List = {
			lockpick = {
				Amount = 1,
				Required = {
					copper = 30,
					aluminum = 30,
					sheetmetal = 2
				}
			},
			dismantle = {
				Amount = 1,
				Required = {
					plastic = 25,
					dirtydollar = 975
				}
			},
			handcuff = {
				Amount = 1,
				Required = {
					copper = 60,
					aluminum = 65
				}
			},
			hood = {
				Amount = 1,
				Required = {
					tarp = 5,
					rubber = 85
				}
			},
			blocksignal = {
				Amount = 1,
				Required = {
					plastic = 80
				}
			}
		}
	},
}