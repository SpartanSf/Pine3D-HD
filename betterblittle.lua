-- Made by Xella, ported to graphics mode by SpartanSoftware
local term_drawPixels      = term.drawPixels
local term_setGraphicsMode = term.setGraphicsMode

local function drawBuffer(buffer, window, wx, wy)
    wx = wx or 1
    wy = wy or 1

    local h = #buffer
    local rows = math.floor(h / 3)

    term_setGraphicsMode(1)

    for i = 0, rows - 1 do
        local baseY = wy + i * 3
        term_drawPixels(wx, baseY, {
            buffer[i * 3 + 1],
            buffer[i * 3 + 2],
            buffer[i * 3 + 3],
        })
    end
end

return {
    drawBuffer = drawBuffer
}
