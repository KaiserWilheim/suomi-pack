local extension = Package:new("toge")
extension.extensionName = "suomi_girlbands"

Fk:loadTranslationTable{
    ["toge"] = "TOGETOGE",
}

extension:loadSkillSkels(require("packages.suomi_girlbands.pkg.toge.skills"))

-- Iseri Nina

local nina = General:new(extension, "iseri_nina", "toge", 3, 3, General.Female)

nina:addSkill("toge_renzhen")
nina:addSkill("toge_taoxue")
nina:addSkill("toge_xiaozhi")

Fk:loadTranslationTable{
    ["iseri_nina"] = "井芹仁菜",
    ["#iseri_nina"] = "小孩姐",
    ["illustrator:iseri_nina"] = "",
    ["cv:iseri_nina"] = "理名",
    ["designer:iseri_nina"] = "索米1973",
}

-- Kawaragi Momoka

local mmk = General:new(extension, "kawaragi_momoka", "toge", 4, 4, General.Female)

mmk:addSkill("toge_chugan")
mmk:addSkill("toge_xiyue")

Fk:loadTranslationTable{
    ["kawaragi_momoka"] = "河原木桃香",
    ["#kawaragi_momoka"] = "momoka",
    ["illustrator:kawaragi_momoka"] = "",
    ["cv:kawaragi_momoka"] = "夕莉",
    ["designer:kawaragi_momoka"] = "索米1973",
}

-- Awa Subaru

local subaru = General:new(extension, "awa_subaru", "toge", 4, 4, General.Female)

subaru:addSkill("toge_yanyuan")
subaru:addSkill("toge_maoxing")

Fk:loadTranslationTable{
    ["awa_subaru"] = "安和昴",
    ["#awa_subaru"] = "486",
    ["illustrator:awa_subaru"] = "",
    ["cv:awa_subaru"] = "美怜",
    ["designer:awa_subaru"] = "索米1973",
}

-- Ebizuka Tomo

local tomo = General:new(extension, "ebizuka_tomo", "toge", 4, 4, General.Female)

tomo:addSkill("toge_ciwei")
tomo:addSkill("toge_fennu")

Fk:loadTranslationTable{
    ["ebizuka_tomo"] = "海老冢智",
    ["#ebizuka_tomo"] = "残月复明",
    ["illustrator:ebizuka_tomo"] = "",
    ["cv:ebizuka_tomo"] = "凪都",
    ["designer:ebizuka_tomo"] = "索米1973",
}

-- Rupa

local rupa = General:new(extension, "rupa", "toge", 4, 4, General.Female)

rupa:addSkill("toge_wenrou")
rupa:addSkill("toge_beishang")

Fk:loadTranslationTable{
    ["rupa"] = "卢帕",
    ["#rupa"] = "RUPA",
    ["illustrator:rupa"] = "",
    ["cv:rupa"] = "朱李",
    ["designer:rupa"] = "索米1973",
}

return extension