vim.loader.enable()

_G.dd = function(...)
  Snacks.debug.inspect(...)
end

_G.bt = function(...)
  Snacks.debug.backtrace(...)
end

-- vim.print = _G.dd
-- vim.cmd.echo = function(...)
--   Snacks.notify(..., {})
-- end

require("config.init")
