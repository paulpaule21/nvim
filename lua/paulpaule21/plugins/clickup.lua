return {
  "paulpaule21/clickup.nvim",
  config = function()
    require("clickup").setup({
      default_workspace_id = nil,
      default_list_id = nil,
    })
  end,
}
