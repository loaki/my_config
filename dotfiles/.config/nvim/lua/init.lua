require('kitty-scrollback').setup({
    myconfig = function(kitty_data)
      return {
        kitty_get_text = {
            extent = (kitty_data.scrolled_by > kitty_data.lines) and 'all' or 'screen',
        },
      }
    end,
})
