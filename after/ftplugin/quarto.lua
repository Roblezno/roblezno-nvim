-- Install shared document mappings after Quarto's own filetype setup.
-- The Quarto plugin owns automatic Otter activation for these buffers.
require("config.markup").setup()
