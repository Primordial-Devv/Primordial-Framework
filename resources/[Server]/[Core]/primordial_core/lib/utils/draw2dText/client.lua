--- Draw 2D text on the screen with a given position, text, size and font.
---@param x number The X position on the screen (0.0 to 1.0).
---@param y number The Y position on the screen (0.0 to 1.0).
---@param text string The text to draw.
---@param size number The size of the text.
---@param font number The font of the text.
function PL.Utils.DrawText2D(x, y, text, size, font)
    size = size or 0.35 -- Taille du texte par défaut
    font = font or 0 -- Police du texte par défaut

    SetTextFont(font)
    SetTextProportional(1)
    SetTextScale(size, size)
    SetTextColour(255, 255, 255, 255)
    SetTextOutline()

    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

return PL.Utils.DrawText2D