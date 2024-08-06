-- check where to put this file
-- 		echo stdpath('config')  
-- put the below line to $vimrc
-- 		vim.api.nvim_set_keymap('i', '<Esc>', [[<Cmd>lua require('im_toggle').toggleIme()<CR><Esc>]], { noremap = true, silent = true })
--
local ffi = require("ffi")

-- Define Windows API functions and constants
ffi.cdef[[
    typedef void* HWND;
    typedef unsigned long WPARAM;
    typedef long LPARAM;
    typedef long LRESULT;
    HWND GetForegroundWindow();
    HWND ImmGetDefaultIMEWnd(HWND hwnd);
    LRESULT SendMessageA(HWND hWnd, unsigned int Msg, WPARAM wParam, LPARAM lParam);
    void* LoadKeyboardLayoutA(const char* pwszKLID, unsigned int Flags);
    void* ActivateKeyboardLayout(void* hkl, unsigned int Flags);
]]

local user32 = ffi.load("user32")
local imm32 = ffi.load("imm32")

local KLF_ACTIVATE = 0x00000001
local IMC_GETOPENSTATUS = 0x00000005
local IMC_SETOPENSTATUS = 0x00000006
local WM_IME_CONTROL = 0x0283

-- Function to get IME window
local function getIme()
    local hwnd = user32.GetForegroundWindow()
    assert(hwnd ~= ffi.cast("HWND", 0), "Error: GetForegroundWindow failed")
    local ime = imm32.ImmGetDefaultIMEWnd(hwnd)
    assert(ime ~= ffi.cast("HWND", 0), "Error: ImmGetDefaultIMEWnd failed")
    return ime
end

-- Function to set IME status
local function setIme(status)
    local ime = getIme()
    user32.SendMessageA(ime, WM_IME_CONTROL, IMC_SETOPENSTATUS, ffi.cast("LPARAM", status))
end

-- Function to get IME status
local function getInputMethod()
    local ime = getIme()
    local status = user32.SendMessageA(ime, WM_IME_CONTROL, IMC_GETOPENSTATUS, ffi.cast("LPARAM", 0))
    return status ~= ffi.cast("LPARAM", 0) and "on" or "off"
end

-- Function to activate IME
local function activateIm()
    setIme(1)
end

-- Function to deactivate IME
local function inactivateIm()
    setIme(0)
end

-- Function to toggle IME
local function toggleIme()
	print("xue: toggleIme...")
    local currentIm = getInputMethod()
    if currentIm == "on" then
        print("Disabling IME...")
        inactivateIm()
        print("IME Disabled.")
    else
        print("Enabling IME...")
        activateIm()
        print("IME Enabled.")
    end
end

return {
    toggleIme = toggleIme
}

