--
-- A (XML) TEI book class for SILE
-- 2021, 2022, The Sindarin Dictionary Project, Omikhleia, Didier Willis
-- License: MIT
--
-- This is the book-like class for (XML) TEI dictionaries.
-- It just defines the appropriate page masters, sectioning hooks
-- and loads all needed packages. The hard work processing the
-- XML content is done in the "teidict" package.
--
local plain = require("classes.plain")
local class = pl.class(plain)
class._name = "teibook"

class.defaultFrameset = {
  content = {
    left = "10%pw", -- was 8.3%pw
    right = "87.7%pw", -- was 86%pw
    top = "11.6%ph",
    bottom = "top(footnotes)"
  },
  folio = {
    left = "left(content)",
    right = "right(content)",
    top = "bottom(footnotes)+3%ph",
    bottom = "bottom(footnotes)+5%ph"
  },
  header = {
    left = "left(content)",
    right = "right(content)",
    top = "top(content)-5%ph", -- was -8%ph
    bottom = "top(content)-2%ph" -- was -3%ph
  },
  footnotes = {
    left = "left(content)",
    right = "right(content)",
    height = "0",
    bottom = "86.3%ph" -- was 83.3%ph
  }
}

function class:twoColumnMaster()
  local gutterWidth = "3%pw" -- self.options.gutter or "3%pw"
  self:defineMaster({
    id = "right",
    firstContentFrame = "contentA",
    frames = {
      contentA = {
        left = "10%pw", -- was 8.3%pw
        right = "left(gutter)",
        top = "11.6%ph",
        bottom = "top(footnotesA)",
        next = "contentB",
        balanced = true
      },
      contentB = {
        left = "right(gutter)",
        width ="width(contentA)",
        right = "87.7%pw", -- was 86%pw
        top = "11.6%ph",
        bottom = "top(footnotesB)",
        balanced = true
      },
      gutter = {
        left = "right(contentA)",
        right = "left(contentB)",
        width = gutterWidth
      },
      folio = {
        left = "left(contentA)",
        right = "right(contentB)",
        top = "bottom(footnotesB)+3%ph",
        bottom = "bottom(footnotesB)+5%ph"
      },
      header = {
        left = "left(contentA)",
        right = "right(contentB)",
        top = "top(contentA)-5%ph", -- was -8%ph
        bottom = "top(contentA)-2%ph" -- was -3%ph
      },
      footnotesA = {
        left =  "left(contentA)",
        right = "right(contentA)",
        height = "0",
        bottom = "86.3%ph" -- was 83.3%ph
      },
      footnotesB = {
        left = "left(contentB)",
        right = "right(contentB)",
        height = "0",
        bottom = "86.3%ph" -- was 83.3%ph
      },
    }
  })
  self:defineMaster({
    id = "left",
    firstContentFrame = "contentA",
    frames = {
      contentA = {
        left = "12.3%pw", -- was 14%pw
        right = "left(gutter)",
        top = "11.6%ph",
        bottom = "top(footnotesA)",
        next = "contentB",
        balanced = true
      },
      contentB = {
        left = "right(gutter)",
        width = "width(contentA)",
        right = "90%pw", -- was 91.7%pw,
        top = "11.6%ph",
        bottom = "top(footnotesB)",
        balanced = true
      },
      gutter = {
        left = "right(contentA)",
        right = "left(contentB)",
        width = gutterWidth
      },
      folio = {
        left = "left(contentA)",
        right = "right(contentB)",
        top = "bottom(footnotesB)+3%ph",
        bottom = "bottom(footnotesB)+5%ph"
      },
      header = {
        left = "left(contentA)",
        right = "right(contentB)",
        top = "top(contentA)-5%ph", -- was -8%ph
        bottom = "top(contentA)-2%ph" -- was -3%ph
      },
      footnotesA = {
        left = "left(contentA)",
        right = "right(contentA)",
        height = "0",
        bottom = "86.3%ph" -- was 83.3%ph
      },
      footnotesB = {
        left = "left(contentB)",
        right = "right(contentB)",
        height = "0",
        bottom = "86.3%ph" -- was 83.3%ph
      },
    }
  })
end

local pageStyle

function class.setPageStyleTitle (_)
  -- self:oneColumnMaster()
  -- Nothing to to for now, as the title page is generated
  -- via the TEI header, that normally comes first, and
  -- the initial page style is kind of ok for it.
  pageStyle = "cover"
end

function class.setPageStyleHeader (_)
  -- self:oneColumnMaster()
  -- Nothing to to for now, as the TEI header normally comes first
  -- and the initial page style is kind of ok for it.
  pageStyle = "header"
end

function class:setPageStyleEntries ()
  self:twoColumnMaster()
  self:switchMaster("right")
  self.firstContentFrame = "contentA"
  pageStyle = "entries"
end

function class:setPageStyleBackmatter ()
  self:twoColumnMaster()
  self:switchMaster("right")
  self.firstContentFrame = "contentA"

  pageStyle = "backmatter"
end

function class:setPageStyleImpressum()
  self:defineMaster({
    id = "right",
    firstContentFrame = "content",
    frames = self.defaultFrameset
  })
  self:mirrorMaster("right", "left")
  self:switchMaster(self:oddPage() and "right" or "left")
  self.firstContentFrame = "content"
  pageStyle = "backmatter"
end

function class:_init (options)
  plain._init(self, options)
  -- Page masters
  self:loadPackage("masters")
  self:defineMaster({
      id = "right",
      firstContentFrame = "content",
      frames = self.defaultFrameset
    })
  self.firstContentFrame = "content"
  self:loadPackage("twoside", { oddPageMaster = "right", evenPageMaster = "left" })
  self:mirrorMaster("right", "left")
  --self:switchMaster("right")

  self:loadPackage("resilient.styles")

  -- And all other packages needed by the teidict package
  self:loadPackage("counters")
  self:loadPackage("infonode")
  self:loadPackage("pdf")
  self:loadPackage("url")
  self:loadPackage("color")
  self:loadPackage("raiselower")
  self:loadPackage("rules")
  self:loadPackage("xmltricks")
  self:loadPackage("svg")
  self:loadPackage("teidict")


  local styles = self.packages["resilient.styles"]
  styles:defineStyle("teibook:titlepage", {}, { font = { family = "Libertinus Sans", size = "20pt" } })
  styles:defineStyle("teibook:impressum", {}, { font = { style = "italic", features = "+hlig,+salt" } })
end

function class:endPage ()
  if pageStyle == "entries" and SILE.scratch.info.thispage.teientry then
    -- Running headers in the dictionary section will have the following form:
    -- first-entry         - folio -       last-entry
    SILE.typesetNaturally(SILE.getFrame("header"), function ()
      SILE.settings:pushState()
      SILE.settings:toplevelState()
      SILE.settings:set("document.parindent", SILE.nodefactory.glue())
      SILE.settings:set("current.parindent", SILE.nodefactory.glue())
      SILE.settings:set("document.lskip", SILE.nodefactory.glue())
      SILE.settings:set("document.rskip", SILE.nodefactory.glue())
      local foliotext = "— " .. self.packages.counters:formatCounter(SILE.scratch.counters.folio).." —" -- Note: U+2014 — em dash

      -- Some boxing needed, so we can easilycenter the folio number in between
      -- first and last references
      local folio = SILE.call("hbox", {}, function()
        SILE.typesetter:typeset(foliotext)
      end)
      table.remove(SILE.typesetter.state.nodes)
      local first = SILE.call("hbox", {}, function ()
        SILE.call("first-entry-reference")
      end)
      local l = SILE.measurement("100%lw"):tonumber()
      SILE.typesetter:pushGlue({ width = l  / 2 - first.width:tonumber() - folio.width:tonumber() / 2 })

      SILE.typesetter:typeset(foliotext)

      SILE.call("hfill")
      --local last =
      SILE.call("hbox", {}, function ()
        SILE.call("last-entry-reference")
      end)
      SILE.typesetter:leaveHmode()

      SILE.settings:set("current.parindent", SILE.nodefactory.glue())
      --SILE.call("raise", { height = "0.475ex" }, function()
        SILE.call("fullrule", { thickness = "0.33pt" })
      --end)
      SILE.typesetter:leaveHmode()
      SILE.settings:popState()
    end)
  end
  return plain.endPage(self)
end

-- Dictionaries are composed of plenty of small entry paragraphs, so we'd better
-- have our own vertical spacing commands...
--   teibook:smallskip is used between entries
--   teibook:medskip is used after milestones (i.e. heading letters)
--   teibook:bigskip is used before milestones
local skips = {
  small = "0.2em plus 0.15em minus 0.1em", -- regular smallskip is 3pt plus 1pt minus 1pt
  med = "0.6em", -- fixed, regular medskip is 6pt plus 2pt minus 2pt
  big = "1.8em plus 1.2em minus 0.6em" -- regular bigskip is 12pt plus 4pt minus 4pt
}

function class.declareSettings (_)
  plain:declareSettings()

  for k, v in pairs(skips) do
    SILE.settings:declare({
        parameter = "teibook." .. k .. "skipamount",
        type = "vglue",
        default = SILE.nodefactory.vglue(v),
        help = "Amount of a \\teibook:" .. k .. "skip"
      })
  end
end

function class:registerCommands ()
  plain:registerCommands()

  for k, _ in pairs(skips) do
    self:registerCommand("teibook:"..k .. "skip", function (_, _)
      SILE.typesetter:leaveHmode()
      SILE.typesetter:pushExplicitVglue(SILE.settings:get("teibook." .. k .. "skipamount"))
    end, "Skip vertically by a teibook:" .. k .. " amount")
  end

  self:registerCommand("first-entry-reference", function (_, _)
    local refs = SILE.scratch.info.thispage.teientry
    if refs then
      SILE.call("orth", refs[1].options, refs[1])
    end
  end, "Outputs the first entry reference on the page.")

  self:registerCommand("last-entry-reference", function (_, _)
    local refs = SILE.scratch.info.thispage.teientry
    if refs then
      SILE.call("orth", refs[#(refs)].options, refs[#(refs)])
    end
  end, "Outputs the last entry reference on the page")

  self:registerCommand("teibook:titlepage", function (_, content)
    -- the content contains the title
    self:setPageStyleTitle();
    SILE.call("nofolios")
    SILE.call("hbox", {}, {})
    SILE.call("vfill")
    SILE.call("style:apply", { name = "teibook:titlepage" }, function ()
      SILE.call("raggedleft", {}, function()
        SILE.process(content)
        SILE.typesetter:leaveHmode()
      end)
    end)
    SILE.call("vfill")
    SILE.call("hbox", {}, {})
    SILE.call("eject")
  end, "Generates the title page.")

  self:registerCommand("teibook:header", function (_, _)
    self:setPageStyleTitle();
    SILE.call("nofolios")
  end, "Enters the TEI header section.")

  self:registerCommand("teibook:entries", function (_, _)
    SILE.typesetter:leaveHmode()
    SILE.call("supereject")
    if self:oddPage() then
      SILE.typesetter:typeset("")
      SILE.typesetter:leaveHmode()
      SILE.call("supereject")
    end
    SILE.typesetter:leaveHmode()
    self:setPageStyleEntries();
    SILE.call("nofolios")
  end, "Enters the TEI dictionary section (i.e. a TEI.div0 typed as such).")

  self:registerCommand("teibook:backmatter", function (_, _)
    SILE.typesetter:leaveHmode()
    SILE.call("supereject")
    if self:oddPage() then
      SILE.typesetter:typeset("")
      SILE.typesetter:leaveHmode()
      SILE.call("nofoliothispage")
      SILE.call("supereject")
    end
    SILE.typesetter:leaveHmode()
    self:setPageStyleBackmatter();
    SILE.call("folios")
  end, "Enters the backmatter section (generated).")

  self:registerCommand("teibook:impressum", function (_, content)
    -- the content contains the impressum
    SILE.typesetter:leaveHmode()
    SILE.call("supereject")
    if self:oddPage() then
      SILE.typesetter:typeset("")
      SILE.typesetter:leaveHmode()
      SILE.call("nofoliothispage")
      SILE.call("supereject")
    end
    SILE.typesetter:leaveHmode()
    self:setPageStyleImpressum();
    SILE.call("nofolios")

    SILE.call("hbox", {}, {})
    SILE.call("vfill")
    SILE.typesetter:leaveHmode()
    SILE.call("style:apply", { name = "teibook:impressum" }, function ()
      SILE.call("center", {}, function()
        SILE.process(content)
      end)
    end)
    SILE.call("hbox", {}, {})
    SILE.typesetter:leaveHmode()
    SILE.call("break")
  end, "Enters the impressum section (generated).")
end

return class
