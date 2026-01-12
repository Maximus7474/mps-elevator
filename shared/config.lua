Config = {}

--[[ Set Debug Mode ]]
Config.Debug = false
Config.DebugZones = false

--[[ Set to false if you do not want to be notified on updates ]]
Config.VersionCheck = true

Config.Options = {
    --[[ Use a Target Script ]]
    Target = true,
    --[[ Distance to Open Panel ]]
    Distance = 2.0,

    --[[ Only if Target is false ]]
    DrawMarker = true,
    --[[ Distance to show marker ]]
    MarkerDistance = 10,
    --[[ Marker list: https://docs.fivem.net/docs/game-references/markers/ ]]
    Marker = {
        marker = 2,
        color = { r = 255, g = 255, b = 255, a = 150 },
        size = { x = 0.75, y = 0.75, z = 0.75 }
    },

    --[[ Set the target Icon & Label - Not used if Target = false ]]
    Icon = "fa-solid fa-arrows-up-down",
    Label = "Elevator",

    --[[ Set the Text UI & Key to use ]]
    TextUI = "Press [%s] to open elevator panel",
    Key = { id = 38, name = "E" },

    --[[ Set to true if you want the UI to close automatically ]]
    CloseUI = true,

    --[[ if false teleports immediatly ]]
    ScreenFade = true,

    --[[ fade in and out duration in ms (ignore if ScreenFade is false) ]]
    FadeDuration = 500,
}