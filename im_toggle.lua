-- check where to put this file
-- 		echo stdpath('config')  
-- put the below line to $vimrc
-- 		vim.api.nvim_set_keymap('i', '<Esc>', [[<Cmd>lua require('im_toggle').onEsc()<CR><Esc>]], { noremap = true, silent = true })
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
    void keybd_event(unsigned char bVk, unsigned char bScan, unsigned long dwFlags, void* dwExtraInfo);
]]

local user32 = ffi.load("user32")
local imm32 = ffi.load("imm32")

local KLF_ACTIVATE = 0x00000001
local IMC_GETOPENSTATUS = 0x00000005
local IMC_SETOPENSTATUS = 0x00000006
local WM_IME_CONTROL = 0x0283
local VK_SHIFT = 0x10
local KEYEVENTF_KEYUP = 0x0002

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
    print("IME stataus: " .. tostring(status))
    return status ~= ffi.cast("LPARAM", 0) and "on" or "off"
end

-- Function to activate IME
local function activateIm()
    setIme(1)
end

-- Function to deactivate IME
-- 测试发现，0 会进入“五笔” 的英文模式， 1 不会改变，中还是中，英还是英
local function inactivateIm()
    setIme(0)
end


-- 用于模拟中/英切换状态，true = 中文，false = 英文
local ime_sub_mode = true

-- 模拟按键：Shift
local function pressShiftKey()
    user32.keybd_event(VK_SHIFT, 0, 0, nil)              -- 按下 Shift
    user32.keybd_event(VK_SHIFT, 0, KEYEVENTF_KEYUP, nil) -- 松开 Shift

    -- 切换状态变量
    ime_sub_mode = not ime_sub_mode
    local mode_text = ime_sub_mode and "中" or "英"
    print("IME Mode: " .. mode_text)
end


local function onEsc()
    inactivateIm()
end

-- press i or a to insert mode
local function onInsert()
    pressShiftKey()
end

return {
    onEsc = onEsc,
    onInsert = onInsert,
}
