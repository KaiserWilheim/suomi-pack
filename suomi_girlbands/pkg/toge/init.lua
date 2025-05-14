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

-- Ebizuka Tomo

-- Rupa

return extension