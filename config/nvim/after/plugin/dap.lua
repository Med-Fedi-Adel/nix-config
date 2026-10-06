local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

local lldb_dap = vim.fn.exepath("lldb-dap")
if lldb_dap == "" then
    lldb_dap = vim.fn.exepath("lldb-vscode")
end

if lldb_dap ~= "" then
    dap.adapters.lldb = {
        type = "executable",
        command = lldb_dap,
        name = "lldb",
    }

    local launch_file = {
        name = "Launch file",
        type = "lldb",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = false,
    }

    dap.configurations.c = { launch_file }
    dap.configurations.cpp = { launch_file }
    dap.configurations.rust = {
        {
            name = "Launch",
            type = "lldb",
            request = "launch",
            program = function()
                return vim.fn.input(
                    "Path to executable: ",
                    vim.fn.getcwd() .. "/target/debug/",
                    "file"
                )
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
    }
end

vim.keymap.set("n", "<leader>dc", function() dap.continue() end, { desc = "DAP continue" })
vim.keymap.set("n", "<leader>dt", function() dap.toggle_breakpoint() end, { desc = "DAP toggle breakpoint" })
vim.keymap.set("n", "<leader>di", function() dap.step_into() end, { desc = "DAP step into" })
vim.keymap.set("n", "<leader>do", function() dap.step_over() end, { desc = "DAP step over" })
vim.keymap.set("n", "<leader>dO", function() dap.step_out() end, { desc = "DAP step out" })
vim.keymap.set("n", "<leader>dx", function() dap.terminate() end, { desc = "DAP terminate" })
vim.keymap.set("n", "<leader>du", function() dapui.toggle() end, { desc = "DAP toggle UI" })
