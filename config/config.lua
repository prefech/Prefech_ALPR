Config = {}
Config.NoPerms = true
Config.AdminPerm = "jd.staff" -- Ace Permission needed to bypass AcePermissions below

Config.addPlatePerms = "" -- Ace Permission needed to add plates.
Config.delPlatePerms = "" -- Ace Permission needed to remove plates.
Config.clearPlatePerms = "" -- Ace Permission needed to clear all plates.
Config.SeePlatesPerm = "" -- Ace Permission needed to see the current tracked plates list.
Config.NotificationPerm = "" -- Ace Permission needed to get notifications.

Config.SyncDelay = 60 -- This is in seconds. the lower you go the more issues you will get
Config.BlipTime = 10 -- How long a located blip will stay on the map

Config.CameraBlips = false

Config.ChatPrefix = "Prefech"
Config.Notification =   "Loc: {{Street_Name}}\nHeading: {{Heading}}\nPostal: {{Postal}}"
-- Notification placeholders
-- {{Street_Name}}, {{Heading}}, {{Postal}}

Config.JD_logs = true
Config.LogsColor = "#F1F1F1"
Config.LogsChannelCommands = "Prefech_ALPRLogs"
Config.logsChannelAlert = "Prefech_ALPRAlert"

Config.versionCheck = "1.0.2"