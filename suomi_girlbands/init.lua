local prefix = "packages.suomi_girlbands.pkg."

local mygo = require(prefix .. "mygo")
local toge = require(prefix .. "toge")

Fk:loadTranslationTable{
    ['suomi_girlbands'] = "少女乐队"
}

return {
    mygo,
    toge,
}