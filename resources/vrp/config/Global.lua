-----------------------------------------------------------------------------------------------------------------------------------------
-- VARIABLES
-----------------------------------------------------------------------------------------------------------------------------------------
MaxRepair = 1
MinimumWeight = 15
PrisonCoords = vec3(1896.15,2604.44,45.75)
CreatorCoords = vec4(149.57,-158.09,-23.99,303.31)
-----------------------------------------------------------------------------------------------------------------------------------------
-- BANNED
-----------------------------------------------------------------------------------------------------------------------------------------
Banned = {
	Mute = true,
	Route = 9999998,
	Leave = vec3(242.71,-392.01,46.30)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVERINFO
-----------------------------------------------------------------------------------------------------------------------------------------
Currency = "$"
DiscordBot = true
BaseMode = "license"
Whitelisted = true
Liberation = "Token"
DisconnectReason = 30
NameDefault = "Indivíduo Indigente"
-----------------------------------------------------------------------------------------------------------------------------------------
-- SERVER
-----------------------------------------------------------------------------------------------------------------------------------------
ServerName = ""
ServerLink = ""
ServerAvatar = "https://i.imgur.com/Yih0uoA.png"
-----------------------------------------------------------------------------------------------------------------------------------------
-- MAINTENANCE
-----------------------------------------------------------------------------------------------------------------------------------------
Maintenance = false
--{
--	["11000010c6d36de"] = true
--}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SPAWNCOORDS
-----------------------------------------------------------------------------------------------------------------------------------------
SpawnCoords = {
	vec3(-1692.63,-1126.16,13.14)
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- TEXTUREPACK
-----------------------------------------------------------------------------------------------------------------------------------------
TexturePack = {
	{ Width = 19, Height = 20, Image = "E" },
	{ Width = 19, Height = 20, Image = "H" },
	{ Width = 72, Height = 72, Image = "Drop" },
	{ Width = 43, Height = 67, Image = "Races" },
	{ Width = 72, Height = 72, Image = "Normal" },
	{ Width = 102, Height = 20, Image = "EPress" },
	{ Width = 102, Height = 20, Image = "HPress" },
	{ Width = 72, Height = 72, Image = "Selected" },
	{ Width = 72, Height = 72, Image = "Marker" }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- GROUPS
-----------------------------------------------------------------------------------------------------------------------------------------
Groups = {
	Admin = {
		Permission = {
			Admin = true
		},
		Hierarchy = { "Administrador","Diretor","Moderador","Suporte","Ajudante" },
		Name = "Adminstradores",
		Service = true,
		Chat = true,
		Max = 30
	},
	PHZ = {
		Permission = {
			PHZ = true
		},
		Hierarchy = { "ComandoGeralPHZ","CoronelPHZ","TenenteCoronelPHZ","MajorPHZ","CapitaoPHZ","SubTenentePHZ","SargentoPHZ","CaboPHZ","SoldadoPHZ","AlunoPHZ" },
		Salary = { 10000,9750,9500,9250,9000,8750,8500,8250,8000,7750,7500,7250,7000,6750,6500 },
		Name = "PHZ",
		SecurityCam = true,
		Service = true,
		Type = "Work",
		Markers = 26,
		Banned = true,
		Chat = true
	},
	JURIDICO = {
		Permission = {
			JURIDICO = true
		},
		Hierarchy = {
			"DesembargadorJURIDICO",
			"JuizJURIDICO",
			"PromotorJURIDICO",
			"DefensorJURIDICO",
			"AdvogadoJURIDICO",
			"EstagiarioJURIDICO"
		},
		Salary = { 10000, 8750, 7500, 6250, 5000, 3750 },  -- Ajuste os valores conforme necessário
		Name = "JURIDICO",
		SecurityCam = true,
		Service = true,
		Type = "Work",
		Markers = 15,  -- ou outro número, se desejar
		Banned = true,
		Chat = true
	},
	LIDERJURIDICO = {
		Permission = {
			JURIDICO = true
		},
		Hierarchy = {
			"LIDERJURIDICO",
		},
		Name = "JURIDICO",
		SecurityCam = true,
		Service = true,
		Type = "Work",
		Markers = 15,  -- ou outro número, se desejar
		Banned = true,
		Chat = true
	},
	SEGURANCA = {
		Permission = {
			SEGURANCA = true
		},
		Hierarchy = {
			"DiretorSeguranca",
			"SupervisorSeguranca",
			"ChefeSeguranca",
			"SegurancaLider",
			"SegurancaPleno",
			"SegurancaJunior",
			"Vigilante",
			"Estagiario"
		},
		Salary = { 8000, 7000, 6000, 5000, 4000, 3000, 2000, 1500 }, -- Ajuste conforme necessidade
		Name = "SEGURANCA",
		SecurityCam = true, -- Se eles têm acesso a câmeras
		Service = true,     -- Precisa bater ponto
		Type = "Work",      -- Tipo trabalho
		Markers = 10,       -- Quantidade de marcadores
		Banned = true,
		Chat = true
	},
	EXERCITO = {
		Permission = {
			EXERCITO = true
		},
		Hierarchy = { "CoronelEXERCITO","Tenente-CoronelEXERCITO","MajorEXERCITO","CapitãoEXERCITO","TenenteEXERCITO","SubtenenteEXERCITO","SargentoEXERCITO","CaboEXERCITO","SoldadoEXERCITO","RecrutaEXERCITO" },
		Salary = { 10000,9750,9500,9250,9000,8750,8500,8250,8000,7750,7500,7250,7000,6750,6500 },
		Name = "EXERCITO",
		SecurityCam = true,
		Service = true,
		Type = "Work",
		Markers = 15,
		Banned = true,
		Chat = true
	},
	CIVIL = {
		Permission = {
			CIVIL = true
		},
		Hierarchy = { "ComandoGeralCivil","ComandanteCoreCIVIL","SubComandanteCoreCIVIL","DelegadoCIVIL","CoreCIVIL","Perito","EscravidaoCivil","Investigador","Agente","Recruta" },
		Salary = { 10000,9750,9500,9250,9000,8750,8500,8250,8000,7750,7500,7250,7000,6750,6500 },
		Name = "CIVIL",
		SecurityCam = true,
		Service = true,
		Type = "Work",
		Markers = 17,
		Banned = true,
		Chat = true
	},
	PRH = {
		Permission = {
			PRH = true
		},
		Hierarchy = { "ComandoGeralPRH","SubComandoPRH","DiretorPRH","InspetorChefePRH","InspetorPRH","AgenteEspecialPRH","AgentePRH","Classe3PRH","Classe2PRH","Classe1PRH" },
		Salary = { 10000,9750,9500,9250,9000,8750,8500,8250,8000,7750,7500,7250,7000,6750,6500 },
		Name = "PRH",
		SecurityCam = true,
		Service = true,
		Type = "Work",
		Markers = 18,
		Banned = true,
		Chat = true
	},
	TATICA = {
		Permission = {
			TATICA = true
		},
		Hierarchy = { "CoronelTatica","Ten.CoronelTatica","MajorTatica","CapitaoTatica","TenenteTatica","SubTenenteTatica","SargentoTatica","CaboTatica","SoldadoTatica","RecrutaTatica" },
		Salary = { 10000,9750,9500,9250,9000,8750,8500,8250,8000,7750,7500,7250,7000,6750,6500 },
		Name = "TATICA",
		SecurityCam = true,
		Service = true,
		Type = "Work",
		Markers = 17,
		Banned = true,
		Chat = true
	},
	HOSPITAL = {
		Permission = {
			HOSPITAL = true
		},
		Hierarchy = { "Diretor-Geral","Diretor Clínico","Diretor Técnico","Chefe de Corpo Clínico","Médico Supervisor","Médico Cirurgião","Médico Plantonista","Médico Especialista","Médico Clínico","Residente","Enfermeiro","Técnico de Enfermagem","Auxiliar de Enfermagem","Estagiário de Medicina","Estagiário de Enfermagem" },
		Salary = { 8750,8500,8250,8000,7750,7500,7250,7000,6750,6500,6250,6000,5750,5500,5250 },
		Service = true,
		Type = "Work",
		Markers = 34,
		Banned = true,
		Chat = true
	},

	-- =========================
	-- FACÇÕES (Service = false)
	-- =========================
	CARTEL = {
		Permission = { CARTEL = true },
		Hierarchy = { "LIDER CARTEL","SUB-LIDER CARTEL","GERENTE CARTEL","RESP ELITE CARTEL","ELITE CARTEL","MEMBRO CARTEL","NOVATO CARTEL","RECRUTADOR CARTEL" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	ELEMENTS = {
		Permission = { ELEMENTS = true },
		Hierarchy = { "LIDER ELEMENTS","SUB-LIDER ELEMENTS","GERENTE ELEMENTS","RESP ELITE ELEMENTS","ELITE ELEMENTS","MEMBRO ELEMENTS","NOVATO ELEMENTS","RECRUTADOR ELEMENTS" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	LUXURY = {
		Permission = { LUXURY = true },
		Hierarchy = { "LIDER LUXURY","SUB-LIDER LUXURY","GERENTE LUXURY","RESP ELITE LUXURY","ELITE LUXURY","MEMBRO LUXURY","NOVATO LUXURY","RECRUTADOR LUXURY" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	FAZENNDINHA = {
		Permission = { FAZENNDINHA = true },
		Hierarchy = { "LIDER FAZENNDINHA","SUB-LIDER FAZENNDINHA","GERENTE FAZENNDINHA","RESP ELITE FAZENNDINHA","ELITE FAZENNDINHA","MEMBRO FAZENNDINHA","NOVATO FAZENNDINHA","RECRUTADOR FAZENNDINHA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	ABSOLUT = {
		Permission = { ABSOLUT = true },
		Hierarchy = { "LIDER ABSOLUT","SUB-LIDER ABSOLUT","GERENTE ABSOLUT","RESP ELITE ABSOLUT","ELITE ABSOLUT","MEMBRO ABSOLUT","NOVATO ABSOLUT","RECRUTADOR ABSOLUT" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	MEDELLIN = {
		Permission = { MEDELLIN = true },
		Hierarchy = { "LIDER MEDELLIN","SUB-LIDER MEDELLIN","GERENTE MEDELLIN","RESP ELITE MEDELLIN","ELITE MEDELLIN","MEMBRO MEDELLIN","NOVATO MEDELLIN","RECRUTADOR MEDELLIN" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	RUSSIA = {
		Permission = { RUSSIA = true },
		Hierarchy = { "LIDER RUSSIA","SUB-LIDER RUSSIA","GERENTE RUSSIA","RESP ELITE RUSSIA","ELITE RUSSIA","MEMBRO RUSSIA","NOVATO RUSSIA","RECRUTADOR RUSSIA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	DEATHROSE = {
		Permission = { DEATHROSE = true },
		Hierarchy = { "LIDER DEATHROSE","SUB-LIDER DEATHROSE","GERENTE DEATHROSE","RESP ELITE DEATHROSE","ELITE DEATHROSE","MEMBRO DEATHROSE","NOVATO DEATHROSE","RECRUTADOR DEATHROSE" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	TEQUILA = {
		Permission = { TEQUILA = true },
		Hierarchy = { "LIDER TEQUILA","SUB-LIDER TEQUILA","GERENTE TEQUILA","RESP ELITE TEQUILA","ELITE TEQUILA","MEMBRO TEQUILA","NOVATO TEQUILA","RECRUTADOR TEQUILA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	UMBRELLA = {
		Permission = { UMBRELLA = true },
		Hierarchy = { "LIDER UMBRELLA","SUB-LIDER UMBRELLA","GERENTE UMBRELLA","RESP ELITE UMBRELLA","ELITE UMBRELLA","MEMBRO UMBRELLA","NOVATO UMBRELLA","RECRUTADOR UMBRELLA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	VANILLASUL = {
		Permission = { VANILLASUL = true },
		Hierarchy = { "LIDER VANILLASUL","SUB-LIDER VANILLASUL","GERENTE VANILLASUL","RESP ELITE VANILLASUL","ELITE VANILLASUL","MEMBRO VANILLASUL","NOVATO VANILLASUL","RECRUTADOR VANILLASUL" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	MAGNATAS = {
		Permission = { MAGNATAS = true },
		Hierarchy = { "LIDER MAGNATAS","SUB-LIDER MAGNATAS","GERENTE MAGNATAS","RESP ELITE MAGNATAS","ELITE MAGNATAS","MEMBRO MAGNATAS","NOVATO MAGNATAS","RECRUTADOR MAGNATAS" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	ORDEM = {
		Permission = { ORDEM = true },
		Hierarchy = { "LIDER ORDEM","SUB-LIDER ORDEM","GERENTE ORDEM","RESP ELITE ORDEM","ELITE ORDEM","MEMBRO ORDEM","NOVATO ORDEM","RECRUTADOR ORDEM" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	ILUMINATIS = {
		Permission = { ILUMINATIS = true },
		Hierarchy = { "LIDER ILUMINATIS","SUB-LIDER ILUMINATIS","GERENTE ILUMINATIS","RESP ELITE ILUMINATIS","ELITE ILUMINATIS","MEMBRO ILUMINATIS","NOVATO ILUMINATIS","RECRUTADOR ILUMINATIS" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	INFINITY = {
		Permission = { INFINITY = true },
		Hierarchy = { "LIDER INFINITY","SUB-LIDER INFINITY","GERENTE INFINITY","RESP ELITE INFINITY","ELITE INFINITY","MEMBRO INFINITY","NOVATO INFINITY","RECRUTADOR INFINITY" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	GRECIA = {
		Permission = { GRECIA = true },
		Hierarchy = { "LIDER GRECIA","SUB-LIDER GRECIA","GERENTE GRECIA","RESP ELITE GRECIA","ELITE GRECIA","MEMBRO GRECIA","NOVATO GRECIA","RECRUTADOR GRECIA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	BABEL = {
		Permission = { BABEL = true },
		Hierarchy = { "LIDER BABEL","SUB-LIDER BABEL","GERENTE BABEL","RESP ELITE BABEL","ELITE BABEL","MEMBRO BABEL","NOVATO BABEL","RECRUTADOR BABEL" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	BAHAMAS = {
		Permission = { BAHAMAS = true },
		Hierarchy = { "LIDER BAHAMAS","SUB-LIDER BAHAMAS","GERENTE BAHAMAS","RESP ELITE BAHAMAS","ELITE BAHAMAS","MEMBRO BAHAMAS","NOVATO BAHAMAS","RECRUTADOR BAHAMAS" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	MOTOCLUB = {
		Permission = { MOTOCLUB = true },
		Hierarchy = { "LIDER MOTOCLUB","SUB-LIDER MOTOCLUB","GERENTE MOTOCLUB","RESP ELITE MOTOCLUB","ELITE MOTOCLUB","MEMBRO MOTOCLUB","NOVATO MOTOCLUB","RECRUTADOR MOTOCLUB" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	ANONYMOUS = {
		Permission = { ANONYMOUS = true },
		Hierarchy = { "LIDER ANONYMOUS","SUB-LIDER ANONYMOUS","GERENTE ANONYMOUS","RESP ELITE ANONYMOUS","ELITE ANONYMOUS","MEMBRO ANONYMOUS","NOVATO ANONYMOUS","RECRUTADOR ANONYMOUS" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	ESCOCIA = {
		Permission = { ESCOCIA = true },
		Hierarchy = { "LIDER ESCOCIA","SUB-LIDER ESCOCIA","GERENTE ESCOCIA","RESP ELITE ESCOCIA","ELITE ESCOCIA","MEMBRO ESCOCIA","NOVATO ESCOCIA","RECRUTADOR ESCOCIA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	ANUBIS = {
		Permission = { ANUBIS = true },
		Hierarchy = { "LIDER ANUBIS","SUB-LIDER ANUBIS","GERENTE ANUBIS","RESP ELITE ANUBIS","ELITE ANUBIS","MEMBRO ANUBIS","NOVATO ANUBIS","RECRUTADOR ANUBIS" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	BRATVA = {
		Permission = { BRATVA = true },
		Hierarchy = { "LIDER BRATVA","SUB-LIDER BRATVA","GERENTE BRATVA","RESP ELITE BRATVA","ELITE BRATVA","MEMBRO BRATVA","NOVATO BRATVA","RECRUTADOR BRATVA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	MEXICO = {
		Permission = { MEXICO = true },
		Hierarchy = { "LIDER MEXICO","SUB-LIDER MEXICO","GERENTE MEXICO","RESP ELITE MEXICO","ELITE MEXICO","MEMBRO MEXICO","NOVATO MEXICO","RECRUTADOR MEXICO" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	VATICANO = {
		Permission = { VATICANO = true },
		Hierarchy = { "LIDER VATICANO","SUB-LIDER VATICANO","GERENTE VATICANO","RESP ELITE VATICANO","ELITE VATICANO","MEMBRO VATICANO","NOVATO VATICANO","RECRUTADOR VATICANO" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	ABUTRES = {
		Permission = { ABUTRES = true },
		Hierarchy = { "LIDER ABUTRES","SUB-LIDER ABUTRES","GERENTE ABUTRES","RESP ELITE ABUTRES","ELITE ABUTRES","MEMBRO ABUTRES","NOVATO ABUTRES","RECRUTADOR ABUTRES" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	ITALIA = {
		Permission = { ITALIA = true },
		Hierarchy = { "LIDER ITALIA","SUB-LIDER ITALIA","GERENTE ITALIA","RESP ELITE ITALIA","ELITE ITALIA","MEMBRO ITALIA","NOVATO ITALIA","RECRUTADOR ITALIA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	MEDUSA = {
		Permission = { MEDUSA = true },
		Hierarchy = { "LIDER MEDUSA","SUB-LIDER MEDUSA","GERENTE MEDUSA","RESP ELITE MEDUSA","ELITE MEDUSA","MEMBRO MEDUSA","NOVATO MEDUSA","RECRUTADOR MEDUSA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	IRLANDA = {
		Permission = { IRLANDA = true },
		Hierarchy = { "LIDER IRLANDA","SUB-LIDER IRLANDA","GERENTE IRLANDA","RESP ELITE IRLANDA","ELITE IRLANDA","MEMBRO IRLANDA","NOVATO IRLANDA","RECRUTADOR IRLANDA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	PSICO = {
		Permission = { PSICO = true },
		Hierarchy = { "LIDER PSICO","SUB-LIDER PSICO","GERENTE PSICO","RESP ELITE PSICO","ELITE PSICO","MEMBRO PSICO","NOVATO PSICO","RECRUTADOR PSICO" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	SINDICATO = {
		Permission = { SINDICATO = true },
		Hierarchy = { "LIDER SINDICATO","SUB-LIDER SINDICATO","GERENTE SINDICATO","RESP ELITE SINDICATO","ELITE SINDICATO","MEMBRO SINDICATO","NOVATO SINDICATO","RECRUTADOR SINDICATO" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	TALIBA = {
		Permission = { TALIBA = true },
		Hierarchy = { "LIDER TALIBA","SUB-LIDER TALIBA","GERENTE TALIBA","RESP ELITE TALIBA","ELITE TALIBA","MEMBRO TALIBA","NOVATO TALIBA","RECRUTADOR TALIBA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	ROXOS = {
		Permission = { ROXOS = true },
		Hierarchy = { "LIDER ROXOS","SUB-LIDER ROXOS","GERENTE ROXOS","RESP ELITE ROXOS","ELITE ROXOS","MEMBRO ROXOS","NOVATO ROXOS","RECRUTADOR ROXOS" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	REDLINE = {
		Permission = { REDLINE = true },
		Hierarchy = { "LIDER REDLINE","SUB-LIDER REDLINE","GERENTE REDLINE","RESP ELITE REDLINE","ELITE REDLINE","MEMBRO REDLINE","NOVATO REDLINE","RECRUTADOR REDLINE" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	PAQUISTAO = {
		Permission = { PAQUISTAO = true },
		Hierarchy = { "LIDER PAQUISTAO","SUB-LIDER PAQUISTAO","GERENTE PAQUISTAO","RESP ELITE PAQUISTAO","ELITE PAQUISTAO","MEMBRO PAQUISTAO","NOVATO PAQUISTAO","RECRUTADOR PAQUISTAO" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	EGITO = {
		Permission = { EGITO = true },
		Hierarchy = { "LIDER EGITO","SUB-LIDER EGITO","GERENTE EGITO","RESP ELITE EGITO","ELITE EGITO","MEMBRO EGITO","NOVATO EGITO","RECRUTADOR EGITO" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	HELIPA = {
		Permission = { HELIPA = true },
		Hierarchy = { "LIDER HELIPA","SUB-LIDER HELIPA","GERENTE HELIPA","RESP ELITE HELIPA","ELITE HELIPA","MEMBRO HELIPA","NOVATO HELIPA","RECRUTADOR HELIPA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	YAKUZA = {
		Permission = { YAKUZA = true },
		Hierarchy = { "LIDER YAKUZA","SUB-LIDER YAKUZA","GERENTE YAKUZA","RESP ELITE YAKUZA","ELITE YAKUZA","MEMBRO YAKUZA","NOVATO YAKUZA","RECRUTADOR YAKUZA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	FRANCA = {
		Permission = { FRANCA = true },
		Hierarchy = { "LIDER FRANCA","SUB-LIDER FRANCA","GERENTE FRANCA","RESP ELITE FRANCA","ELITE FRANCA","MEMBRO FRANCA","NOVATO FRANCA","RECRUTADOR FRANCA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	GROTA = {
		Permission = { GROTA = true },
		Hierarchy = { "LIDER GROTA","SUB-LIDER GROTA","GERENTE GROTA","RESP ELITE GROTA","ELITE GROTA","MEMBRO GROTA","NOVATO GROTA","RECRUTADOR GROTA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	JAMAICA = {
		Permission = { JAMAICA = true },
		Hierarchy = { "LIDER JAMAICA","SUB-LIDER JAMAICA","GERENTE JAMAICA","RESP ELITE JAMAICA","ELITE JAMAICA","MEMBRO JAMAICA","NOVATO JAMAICA","RECRUTADOR JAMAICA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	ALEMANHA = {
		Permission = { ALEMANHA = true },
		Hierarchy = { "LIDER ALEMANHA","SUB-LIDER ALEMANHA","GERENTE ALEMANHA","RESP ELITE ALEMANHA","ELITE ALEMANHA","MEMBRO ALEMANHA","NOVATO ALEMANHA","RECRUTADOR ALEMANHA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	ALEMANHA = {
		Permission = { ALEMANHA = true },
		Hierarchy = { "LIDER ALEMANHA","SUB-LIDER ALEMANHA","GERENTE ALEMANHA","RESP ELITE ALEMANHA","ELITE ALEMANHA","MEMBRO ALEMANHA","NOVATO ALEMANHA","RECRUTADOR ALEMANHA" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	TROPA_DO_PORTUGA = {
		Permission = { TROPA_DO_PORTUGA = true },
		Hierarchy = {
			"LIDER TROPA_DO_PORTUGA",
			"SUB-LIDER TROPA_DO_PORTUGA",
			"GERENTE TROPA_DO_PORTUGA",
			"RESP ELITE TROPA_DO_PORTUGA",
			"ELITE TROPA_DO_PORTUGA",
			"MEMBRO TROPA_DO_PORTUGA",
			"NOVATO TROPA_DO_PORTUGA",
			"RECRUTADOR TROPA_DO_PORTUGA"
		},
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	Families = {
		Permission = {
			Families = true
		},
		Hierarchy = { "Chefe","Subchefe","Conselheiro","General","Veterano","Executor","Operacional","Soldado","Novato","Aspirante" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	Marabunta = {
		Permission = {
			Marabunta = true
		},
		Hierarchy = { "Chefe","Subchefe","Conselheiro","General","Veterano","Executor","Operacional","Soldado","Novato","Aspirante" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},
	Aztecas = {
		Permission = {
			Aztecas = true
		},
		Hierarchy = { "Chefe","Subchefe","Conselheiro","General","Veterano","Executor","Operacional","Soldado","Novato","Aspirante" },
		SecurityCam = true,
		Domination = true,
		Service = false,
		Chest = true,
		Type = "Work"
	},

	Bennys = {
		Permission = {
			Bennys = true
		},
		Hierarchy = { "Dono","Gerente de Oficina","Supervisor de Oficina","Especialista Automotivo","Mecânico Sênior","Mecânico Pleno","Mecânico Júnior","Ajudante de Mecânico","Estagiário de Mecânica" },
		Salary = { 4000,3750,3500,3250,3000,2750,2500,2250,2000 },
		Service = true,
		Chest = true,
		Type = "Work"
	},
	Bahamas = {
		Permission = {
			Bahamas = true
		},
		Hierarchy = { "Dono","Sócio","Gerente","Maitré","Especialista","Cozinheiro Sênior","Cozinheiro Pleno","Cozinheiro Júnior","Ajudante de Cozinha","Estagiário de Cozinha" },
		Salary = { 4000,3750,3500,3250,3000,2750,2500,2250,2000,1750 },
		Service = true,
		Chest = true,
		Type = "Work"
	},
	Restaurante = {
		Permission = {
			Restaurante = true
		},
		Hierarchy = { "Dono","Sócio","Gerente","Maitré","Especialista","Cozinheiro Sênior","Cozinheiro Pleno","Cozinheiro Júnior","Ajudante de Cozinha","Estagiário de Cozinha" },
		Salary = { 4000,3750,3500,3250,3000,2750,2500,2250,2000,1750 },
		Service = true,
		Chest = true,
		Type = "Work"
	},
	Booster = {
		Permission = {
			Booster = true
		},
		Hierarchy = { "Membro" },
		Service = true,
		Salary = { 2500 },
		Block = true
	},
	Freecam = {
		Permission = {
			Freecam = true
		},
		Hierarchy = { "Membro" },
		Service = true,
		Block = true
	},
	Policia = {
		Permission = {
			PHZ = true,
			EXERCITO = true,
			CIVIL = true,
			PRH = true,
			TATICA = true
		},
		Hierarchy = { "Membro" },
		Block = true
	},
	Emergencia = {
		Permission = {
			PHZ = true,
			EXERCITO = true,
			CIVIL = true,
			PRH = true,
			TATICA = true,
			HOSPITAL = true
		},
		Hierarchy = { "Membro" },
		Block = true
	},
	Corredor = {
		Permission = {
			Corredor = true
		},
		Hierarchy = { "Jogador" },
		Markers = 46,
		Block = true
	},
	Boosting = {
		Permission = {
			Boosting = true
		},
		Hierarchy = { "Jogador" },
		Markers = 50,
		Block = true
	},

	-- FUELSTATIONS
	FuelStation01 = {
		Permission = {
			FuelStation01 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation02 = {
		Permission = {
			FuelStation02 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation03 = {
		Permission = {
			FuelStation03 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation04 = {
		Permission = {
			FuelStation04 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation05 = {
		Permission = {
			FuelStation05 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation06 = {
		Permission = {
			FuelStation06 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation07 = {
		Permission = {
			FuelStation07 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation08 = {
		Permission = {
			FuelStation08 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation09 = {
		Permission = {
			FuelStation09 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation10 = {
		Permission = {
			FuelStation10 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation11 = {
		Permission = {
			FuelStation11 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation12 = {
		Permission = {
			FuelStation12 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation13 = {
		Permission = {
			FuelStation13 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation14 = {
		Permission = {
			FuelStation14 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation15 = {
		Permission = {
			FuelStation15 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation16 = {
		Permission = {
			FuelStation16 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation17 = {
		Permission = {
			FuelStation17 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation18 = {
		Permission = {
			FuelStation18 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation19 = {
		Permission = {
			FuelStation19 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation20 = {
		Permission = {
			FuelStation20 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation21 = {
		Permission = {
			FuelStation21 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation22 = {
		Permission = {
			FuelStation22 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation23 = {
		Permission = {
			FuelStation23 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation24 = {
		Permission = {
			FuelStation24 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation25 = {
		Permission = {
			FuelStation25 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation26 = {
		Permission = {
			FuelStation26 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},
	FuelStation27 = {
		Permission = {
			FuelStation27 = true
		},
		Hierarchy = { "Proprietário","Gerente","Atendente","Frentista" },
		Service = true,
		Type = "Fuel",
		Block = true,
		Max = 3
	},

	-- PROPRIEDADES
	Mansao01 = { -- Exemplo de propriedade com painel/permissão
		Permission = {
			Mansao01 = true
		},
		Name = "Mansão",
		Hierarchy = { "Proprietário","Morador" },
		Type = "Propertys",
		Service = true,
		Max = 5
	},

	-- DOMINATION
	Lester = {
		Permission = {
			Lester = true
		},
		Hierarchy = { "Chefe","Subchefe","Membro" },
		Service = false
	},
	    -- =============================================
    -- GRUPOS DE LÍDERES (para baús exclusivos)
    -- =============================================
    CARTELLider = {
        Permission = { CARTELLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    ELEMENTSLider = {
        Permission = { ELEMENTSLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    LUXURYLider = {
        Permission = { LUXURYLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    FAZENNDINHALider = {
        Permission = { FAZENNDINHALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    ABSOLUTLider = {
        Permission = { ABSOLUTLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    MEDELLINLider = {
        Permission = { MEDELLINLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    RUSSIASemAcento = {
        Permission = { RUSSIASemAcento = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    DEATHROSELider = {
        Permission = { DEATHROSELider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    TEQUILALider = {
        Permission = { TEQUILALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    UMBRELLALider = {
        Permission = { UMBRELLALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    VANILLASULLider = {
        Permission = { VANILLASULLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    MAGNATASLider = {
        Permission = { MAGNATASLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    ORDEMLider = {
        Permission = { ORDEMLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    ILUMINATISLider = {
        Permission = { ILUMINATISLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    INFINITYLider = {
        Permission = { INFINITYLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    GRECIALider = {
        Permission = { GRECIALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    BABELLider = {
        Permission = { BABELLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    BAHAMASLider = {
        Permission = { BAHAMASLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    MOTOCLUBLider = {
        Permission = { MOTOCLUBLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    ANONYMOUSLider = {
        Permission = { ANONYMOUSLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    ESCOCIALider = {
        Permission = { ESCOCIALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    ANUBISLider = {
        Permission = { ANUBISLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    BRATVALider = {
        Permission = { BRATVALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    MEXICOLider = {
        Permission = { MEXICOLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    VATICANOLider = {
        Permission = { VATICANOLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    ABUTRESLider = {
        Permission = { ABUTRESLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    ITALIALider = {
        Permission = { ITALIALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    MEDUSALider = {
        Permission = { MEDUSALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    GRECIALider2 = { -- Se quiser evitar duplicata, mas vou deixar comentado, pois já tem GRECIALider
        Permission = { GRECIALider2 = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    RUSSIASemAcento2 = { -- Idem, já tem
        Permission = { RUSSIASemAcento2 = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    IRLANDALider = {
        Permission = { IRLANDALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    PSICOLider = {
        Permission = { PSICOLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    SINDICATOLider = {
        Permission = { SINDICATOLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    TALIBALider = {
        Permission = { TALIBALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    ROXOSLider = {
        Permission = { ROXOSLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    REDLINELider = {
        Permission = { REDLINELider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    PAQUISTAOLider = {
        Permission = { PAQUISTAOLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    EGITOLider = {
        Permission = { EGITOLider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    JAMAICALider = {
        Permission = { JAMAICALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
    ALEMANHALider = {
        Permission = { ALEMANHALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
	GROTALider = {
        Permission = { GROTALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
	HELIPALider = {
        Permission = { HELIPALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
	FRANCALider = {
        Permission = { FRANCALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
	YAKUZALider = {
        Permission = { YAKUZALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
	TROPA_DO_PORTUGALider = {
        Permission = { TROPA_DO_PORTUGALider = true },
        Hierarchy = { "Líder" },
        Service = false,
        Chest = true,
        Type = "Work"
    },
		-----------------------------------------------------------------------------------------------------------------------------------------
	-- VIP INICIANTE
	-----------------------------------------------------------------------------------------------------------------------------------------
	Iniciante = {
		Permission = {
			Iniciante = true
		},
		Hierarchy = { "MembroVIPIniciante" },
		Salary = { 500 },
		Name = "VIP Iniciante",
		Service = true,
		Type = "Vip",
		Chat = true
	},

	-----------------------------------------------------------------------------------------------------------------------------------------
	-- VIP BRONZE
	-----------------------------------------------------------------------------------------------------------------------------------------
	Bronze = {
		Permission = {
			Bronze = true
		},
		Hierarchy = { "MembroVIPBronze" },
		Salary = { 1000 },
		Name = "VIP Bronze",
		Service = true,
		Type = "Vip",
		Chat = true
	},

	-----------------------------------------------------------------------------------------------------------------------------------------
	-- VIP PRATA
	-----------------------------------------------------------------------------------------------------------------------------------------
	Prata = {
		Permission = {
			Prata = true
		},
		Hierarchy = { "MembroVIPPrata" },
		Salary = { 1500 },
		Name = "VIP Prata",
		Service = true,
		Type = "Vip",
		Chat = true
	},

	-----------------------------------------------------------------------------------------------------------------------------------------
	-- VIP PVP
	-----------------------------------------------------------------------------------------------------------------------------------------
	PVP = {
		Permission = {
			PVP = true
		},
		Hierarchy = { "MembroVIPPVP" },
		Salary = { 2000 },
		Name = "VIP PVP",
		Service = true,
		Type = "Vip",
		Chat = true
	},

	-----------------------------------------------------------------------------------------------------------------------------------------
	-- VIP OURO
	-----------------------------------------------------------------------------------------------------------------------------------------
	Ouro = {
		Permission = {
			Ouro = true
		},
		Hierarchy = { "MembroVIPOuro" },
		Salary = { 3000 },
		Name = "VIP Ouro",
		Service = true,
		Type = "Vip",
		Chat = true
	},

	-----------------------------------------------------------------------------------------------------------------------------------------
	-- VIP PLATINUM
	-----------------------------------------------------------------------------------------------------------------------------------------
	Platinum = {
		Permission = {
			Platinum = true
		},
		Hierarchy = { "MembroVIPPlatinum" },
		Salary = { 5000 },
		Name = "VIP Platinum",
		Service = true,
		Type = "Vip",
		Chat = true
	},

	-----------------------------------------------------------------------------------------------------------------------------------------
	-- VIP BLACK
	-----------------------------------------------------------------------------------------------------------------------------------------
	Black = {
		Permission = {
			Black = true
		},
		Hierarchy = { "MembroVIPBlack" },
		Salary = { 7500 },
		Name = "VIP Black",
		Service = true,
		Type = "Vip",
		Chat = true
	},
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHARACTERITENS
-----------------------------------------------------------------------------------------------------------------------------------------
CharacterItens = {
	soda = 4,
	identity = 1,
	hamburger = 5
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BOXES
-----------------------------------------------------------------------------------------------------------------------------------------
Boxes = {
	treasurebox = {
		Multiplier = { Min = 1, Max = 1 },
		List = {
			{ Item = "dollar", Chance = 100, Min = 4250, Max = 6250 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- UPPERLEVEL
-----------------------------------------------------------------------------------------------------------------------------------------
UpperLevel = {
	Trucker = {
		{
			{ Item = "bandage", Min = 1, Max = 2 },
			{ Item = "advtoolbox", Min = 1, Max = 1 }
		}
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- SKINSHOPINIT
-----------------------------------------------------------------------------------------------------------------------------------------
SkinshopInit = {
	mp_m_freemode_01 = {
		pants = { item = 4, texture = 1 },
		arms = { item = 0, texture = 0 },
		tshirt = { item = 15, texture = 0 },
		torso = { item = 273, texture = 0 },
		vest = { item = 0, texture = 0 },
		shoes = { item = 1, texture = 6 },
		mask = { item = 0, texture = 0 },
		backpack = { item = 0, texture = 0 },
		hat = { item = -1, texture = 0 },
		glass = { item = 0, texture = 0 },
		ear = { item = -1, texture = 0 },
		watch = { item = -1, texture = 0 },
		bracelet = { item = -1, texture = 0 },
		accessory = { item = 0, texture = 0 },
		decals = { item = 0, texture = 0 }
	},
	mp_f_freemode_01 = {
		pants = { item = 4, texture = 1 },
		arms = { item = 14, texture = 0 },
		tshirt = { item = 3, texture = 0 },
		torso = { item = 338, texture = 2 },
		vest = { item = 0, texture = 0 },
		shoes = { item = 1, texture = 6 },
		mask = { item = 0, texture = 0 },
		backpack = { item = 0, texture = 0 },
		hat = { item = -1, texture = 0 },
		glass = { item = 0, texture = 0 },
		ear = { item = -1, texture = 0 },
		watch = { item = -1, texture = 0 },
		bracelet = { item = -1, texture = 0 },
		accessory = { item = 0, texture = 0 },
		decals = { item = 0, texture = 0 }
	}
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- BARBERSHOPINIT
-----------------------------------------------------------------------------------------------------------------------------------------
BarbershopInit = {
	mp_m_freemode_01 = { 13,25,0,3,0,-1,-1,-1,-1,13,38,38,0,0,0,0,0.5,0,0,1,0,10,1,0,1,0.5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,38 },
	mp_f_freemode_01 = { 13,25,1,3,0,-1,-1,-1,-1,1,38,38,0,0,0,0,1,0,0,1,0,0,0,0,1,0.5,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,38 }
}
-----------------------------------------------------------------------------------------------------------------------------------------
-- THEME
-----------------------------------------------------------------------------------------------------------------------------------------
Theme = {
	shadow = true,
	main = "#006EFF",
	mainText = "#ffffff",
	currency = Currency,
	items = ListItem,
	groups = Groups,

	common = "#6fc66a",
	rare = "#6ac6c5",
	epic = "#c66a75",
	legendary = "#c6986a",
	accept = {
		letter = "#dcffe9",
		background = "#3fa466"
	},
	reject = {
		letter = "#ffe8e8",
		background = "#ad4443"
	},
	loading = {
		mode = "dark", -- [ Opções disponíveis: dark,light ],
		model = 2, -- [ Opções disponíveis: 1,2 ],
		progress = true -- [ Opções disponíveis: true, false ],
	},
	chat = {
		Importante = {
			background = "#9d194e",
			letter = "#f7c1d6"
		},
		PHZ = {
			background = "#16468b",
			letter = "#ffffff"
		},
		EXERCITO = {
			background = "#463939",
			letter = "#ffffff"
		},
		CIVIL = {
			background = "#2d402d",
			letter = "#ffffff"
		},
		PHZ = {
			background = "#2d402d",
			letter = "#ffffff"
		},
		TATICA = {
			background = "#2d402d",
			letter = "#ffffff"
		},
		HOSPITAL = {
			background = "#9f1918",
			letter = "#ffffff"
		},
		Families = {
			background = "#4d7a06",
			letter = "#ffffff"
		},
		Ballas = {
			background = "#430d8e",
			letter = "#ffffff"
		},
		Vagos = {
			background = "#948209",
			letter = "#ffffff"
		}
	},
	hud = {
		modes = {
			info = 3, -- [ Opções disponíveis: 1,2,3 ],
			icon = "fill", -- [ Opções disponíveis: fill,line ],
			status = 10, -- [ Opções disponíveis: 1 a 12 ],
			vehicle = 3 -- [ Opções disponíveis: 1,2,3 ]
		},
		logo = 75, -- tamanho da logo
		percentage = true,
		icons = "#FFFFFF",
		nitro = "#f69d2a",
		rpm = "#FFFFFF",
		fuel = "#f94c54",
		engine = "#ff4c55",
		health = "#76B984",
		armor = "#A66FED",
		hunger = "#F4B266",
		thirst = "#7FC8F8",
		oxygen = "#38F8F8",
		stress = "#E287C9",
		luck = "#F18A7C",
		dexterity = "#E4E76E",
		repose = "#7FCCC7",
		pointer = "#ef4444",
		progress = {
			background = "#FFFFFF",
			circle = "#006EFF",
			letter = "#FFFFFF"
		}
	},
	notifyitem = {
		add = {
			letter = "#dcffe9",
			background = "#3fa466"
		},
		remove = {
			letter = "#ffe8e8",
			background = "#ad4443"
		}
	},
	pause = {
		premium = true,
		propertys = true,
		store = true,
		battlepass = true,
		boxes = true,
		marketplace = true,
		skinweapon = true,
		ranking = true,
		statistics = true,
		daily = true,
		code = true,
		map = true,
		settings = true,
		hud = true,
		disconnect = true
	},
	scripts = {
		taximeter = {
			main = "#efcf2f",
			mainText = "#120b02"
		}
	}
}