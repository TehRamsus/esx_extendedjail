-- Made by Ramsus --
Config = {}
Config.Locale = 'en'

-- Locations
Config.OutsideLocation = vector3(1847.95, 2586.26, 45.60)
Config.JailSpawnLocation = vector3(1638.07, 2542.61, 45.56)
Config.PrisonBlip = vector3(1858.0, 2606.0, 45.0)
Config.OutsideLocationPJail = vector3(432.34, -984.17, 30.71)
Config.UpdateTime = 60000 -- MS

-- Escape
Config.DrawDistance = 10
Config.EscapeAttempt = vector3(1831.34, 2603.36, 44.9)
Config.Color = {r = 0, g = 0, b = 255}
Config.Item = 'bread'
Config.Job = 'police'
Config.AdminTitle = 'admin'
Config.Mhacking = false
Config.TimeToAlarm = math.random(2000, 5000)
Config.TimeToHack = math.random(2000, 10000)
Config.TimeAlarmLeft = 40000 -- MS

-- Jail Blip
Config.BlipSprite = 188
Config.BlipColor = 63
Config.BlipScale = 0.8

-- Discord Webhooks
Config.IsWebhookEnabled = false
Config.WebhookLink = "https://discord.com/api/webhooks/"
Config.BotName = "Server"
Config.Logo = "" -- Must end with .png

-- Uniforms
Config.Wear = {
		Male = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1']  = 8, 	['torso_2']  = 14,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 8,   ['pants_1']  = 64,
			['pants_2']  = 8,   ['shoes_1']  = 6,
			['shoes_2']  = 0, 	['helmet_1'] = -1,
			['helmet_2'] = 0, 	['bags_1'] = -1
		},
		Female = {
			['tshirt_1'] = 15,  ['tshirt_2'] = 0,
			['torso_1']  = 23, 	['torso_2']  = 0,
			['decals_1'] = 0,   ['decals_2'] = 0,
			['arms']     = 4,   ['pants_1']  = 41,
			['pants_2']  = 0,   ['shoes_1']  = 4,
			['shoes_2']  = 1, 	['helmet_1'] = -1,
			['helmet_2'] = 0, 	['bags_1'] = -1
		}
}