return {
  {
    -- amongst your other plugins
    {
      'akinsho/toggleterm.nvim',
      version = '*',
      opts = {
        size = 20,
        direction = 'float',
        start_in_insert = true,
        close_on_exit = true,
        shell = 'bash',
      },
    },
  },
}
