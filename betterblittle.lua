-- Made by Xella, ported to graphics mode by SpartanSoftware
local floor = math.floor
local min = math.min
local concat = table.concat

local colorMap = {}
for i = 1, 16 do colorMap[2 ^ (i - 1)] = i end

local colorChar = {}
for i = 1, 16 do colorChar[i] = ("0123456789abcdef"):sub(i, i) end

local colorDistances

local function sRGBtoOklab(r, g, b)
    local function f(v) return v >= 0.04045 and ((v + 0.055) / (1 + 0.055)) ^ 2.4 or (v / 12.92) end
    r, g, b = f(r), f(g), f(b)
    local l = (0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b) ^ (1 / 3)
    local m = (0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b) ^ (1 / 3)
    local s = (0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b) ^ (1 / 3)
    return
        0.2104542553 * l + 0.7936177850 * m - 0.0040720468 * s,
        1.9779984951 * l - 2.4285922050 * m + 0.4505937099 * s,
        0.0259040371 * l + 0.7827717662 * m - 0.8086757660 * s
end

local function computeColorDistances(window, colorSpace)
    colorDistances = {}
    for c1 = 1, 16 do
        local r1, g1, b1 = window.getPaletteColor(2 ^ (c1 - 1))
        if colorSpace ~= "sRGB" then r1, g1, b1 = sRGBtoOklab(r1, g1, b1) end
        local distances = {}
        for c2 = 1, 16 do
            local r2, g2, b2 = window.getPaletteColor(2 ^ (c2 - 1))
            if colorSpace ~= "sRGB" then r2, g2, b2 = sRGBtoOklab(r2, g2, b2) end
            distances[c2] = (r2 - r1) ^ 2 + (g2 - g1) ^ 2 + (b2 - b1) ^ 2
        end
        colorDistances[c1] = distances
    end
end

local function drawBuffer(buffer, window, wx, wy)
    wx, wy = wx or 1, wy or 1
    local h, w = #buffer, #buffer[1]
    if not colorDistances then computeColorDistances(window) end
    term.setGraphicsMode(1)
    for charRow = 0, math.floor(h / 3) - 1 do
        local baseY = wy + charRow * 3
        local pixels = {}
        for dy = 0, 2 do
            pixels[dy + 1] = buffer[charRow * 3 + dy + 1]
        end
        term.drawPixels(wx, baseY, pixels)
    end
end

return {
    drawBuffer = drawBuffer,
    recomputeColorDistances = computeColorDistances
}
