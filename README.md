# teidict.sile

[![license](https://img.shields.io/github/license/Omikhleia/teidict.sile)](LICENSE)
[![Luacheck](https://img.shields.io/github/workflow/status/Omikhleia/teidict.sile/Luacheck?label=Luacheck&logo=Lua)](https://github.com/Omikhleia/teidict.sile/actions?workflow=Luacheck)
[![Luarocks](https://img.shields.io/luarocks/v/Omikhleia/teidict.sile?label=Luarocks&logo=Lua)](https://luarocks.org/modules/Omikhleia/teidict.sile)

This package collection collection for the [SILE](https://github.com/sile-typesetter/sile)
aims at supporting the (XML) TEI P4 “Print Dictionary” standard — or, more precisely,
a certain subset of it, as suitable for the [Sindarin Dictionary project](https://github.com/Omikhleia/sindict).

The main pain point is that such a dictionary uses a heavily “semantic” structured
mark-up (i.e. a “lexical view”, encoding structure information such as part-of-speech
etc. without much concern for the exact textual representation in print form),
much more than a “presentational” mark-up. Some XML nodes may contain many things
one needs to ignore (such as spaces, mostly) or to supplement (such as punctuation,
parentheses, numbering… and again, proper spaces where needed). Without XPath to
check siblings, ascendants or descendants, it may become somewhat hard to get a nice
automated output (and even with XPath, it is not _that_ obvious). In other terms,
the solution proposed here is somewhat _ad hoc_ for a specific type of lexical TEI
dictionary and depends quite a lot on its structural organization.

Would you want to more about the supported structure and tags, you may refer
to the [Data Model](https://omikhleia.github.io/sindict/manual/DATA_MODEL.html)
of the Sindarin Dictionary project.

## Installation

These packages require SILE v0.14 or upper.

(LUAROCKS: LATER)

## License

All code is under the MIT License.

This repository also includes a simple dictionary example, a small XML (TEI) lexicon
(Almaqerin-French), which is under license CC-BY-NC-SA 2.0 as a special arrangement.

More generally, any example (i.e. anything in the "examples" folder) may have its own
license, and used here by courtesy of the author(s). Please check the license(s)
or ask, in case of doubts, for details and exact licensing terms.
