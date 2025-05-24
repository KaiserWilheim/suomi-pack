local extension = Package:new("mygo")
extension.extensionName = "suomi_girlbands"

Fk:loadTranslationTable{
    ["mygo"] = "MyGO!!!!!",
}

extension:loadSkillSkels(require("packages.suomi_girlbands.pkg.mygo.skills"))

-- Takamatsu Tomori

local tomorin = General:new(extension, "takamatsu_tomori", "mygo", 4, 4, General.Female)

tomorin:addSkill("mygo_zhongli")
tomorin:addSkill("mygo_chaoban")
tomorin:addSkill("mygo_chunri")

Fk:loadTranslationTable{
    ["takamatsu_tomori"] = "高松灯",
    ["#takamatsu_tomori"] = "灯神",
    ["designer:takamatsu_tomori"] = "索米1973",
    ["cv:takamatsu_tomori"] = "羊宫妃那",
    ["illustrator:takamatsu_tomori"] = "",
}

-- Chihaya Anon

-- Kaname Raana

-- Nagasaki Soyo

local soyorin = General:new(extension, "nagasaki_soyo", "crychic", 6, 6, General.Female)

soyorin:addSkill("mygo_jiaxiao")
soyorin:addSkill("mygo_fubi")
soyorin:addRelatedSkill("mygo_jianqie")

Fk:loadTranslationTable{
    ["nagasaki_soyo"] = "长崎素世",
    ["#nagasaki_soyo"] = "挺王之王",
    ["designer:nagasaki_soyo"] = "索米1973",
    ["cv:nagasaki_soyo"] = "小日向美香",
    ["illustrator:nagasaki_soyo"] = "",
}

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