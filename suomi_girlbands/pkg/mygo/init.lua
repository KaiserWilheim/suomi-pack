local extension = Package:new("mygo")
extension.extensionName = "suomi_girlbands"

Fk:loadTranslationTable{
    ["mygo"] = "MyGO!!!!!",
}

extension:loadSkillSkels(require("packages.suomi_girlbands.pkg.mygo.skills"))

-- Shiina Taki

local rikki = General:new(extension, "shiina_taki", "mygo", 4, 4, General.Female)

rikki:addSkill("mygo_zibei")
rikki:addSkill("mygo_yali")

Fk:loadTranslationTable{
    ["shiina_taki"] = "椎名立希",
    ["#shiina_taki"] = "说话之道",
    ["designer:shiina_taki"] = "索米1973",
    ["cv:shiina_taki"] = "林鼓子",
    ["illustrator:shiina_taki"] = "",
}

return extension