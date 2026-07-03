return {
    {
        "folke/snacks.nvim",
        opts = {
            picker = {
                sources = {
                    explorer = {
                        hidden = true,
                        layout = {
                            preview = true,
                            layout = {
                                box = "vertical",
                                position = "left",
                                border = "none",
                                backdrop = false,
                                height = 0,
                                width = 60,
                                { win = "input", height = 1, border = "bottom" },
                                { win = "list", border = "none" },
                                { win = "preview", title = "{preview}", height = 0.6, border = "top" },
                            },
                        },
                    }, -- <leader>e (File Explorer)
                    files = { hidden = true }, -- <leader>ff (Find Files)
                    smart = { hidden = true }, -- <leader><space> (Smart Find Files)
                },
            },
            styles = {
                lazygit = {
                    width = 0,
                    height = 0,
                },
            },
        },
    },
}
