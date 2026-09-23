-- Inline images in markdown via snacks.nvim + the kitty graphics protocol:
--   ![](file.png) / remote URLs  -> ImageMagick (`convert`)
--   ```mermaid blocks            -> `mmdc` (~/.local/bin wrapper around @mermaid-js/mermaid-cli,
--                                   installed in ~/.local/share/mermaid-cli, runs Chromium --no-sandbox)
--   $math$ / $$math$$            -> `tectonic` (~/.local/bin)
-- Needs a graphics-capable terminal (kitty/ghostty/wezterm) reached directly —
-- e.g. `kitten ssh`; the claude-manager TUI pane can't show images yet.
-- Under tmux, `allow-passthrough on`. Check with :checkhealth snacks.
return {
  'folke/snacks.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    image = {
      enabled = true,
      doc = { inline = true, float = true, max_width = 80, max_height = 40 },
      math = { enabled = true },
    },
  },
}
