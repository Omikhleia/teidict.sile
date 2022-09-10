package = "teidict.sile"
version = "dev-1"
source = {
    url = "git+https://github.com/Omikhleia/teidict.sile.git",
}
description = {
  summary = "TEI (XML) dictionary support for the SILE typesetting system .",
  detailed = [[
    This package collection for the SILE typesetting system aims at supporting
    a specialized subset of the (XML) TEI P4 “Print Dictionary” standard.
  ]],
  homepage = "https://github.com/Omikhleia/teidict.sile",
  license = "MIT",
}
dependencies = {
   "lua >= 5.1",
   "resilient.sile",
   "couyards.sile",
}

build = {
   type = "builtin",
   modules = {
      ["sile.classes.teibook"]           = "classes/teibook.lua",
      ["sile.packages.teidict"]          = "packages/teidict/init.lua",
      ["sile.packages.teiabbr"]          = "packages/teiabbr/init.lua",
   }
}
