local donateButton
local donateWindow

function init()
    donateWindow = g_ui.displayUI('donate')
    donateWindow:hide()

    -- El panel derecho (donde va Donate) esta activo in-game; asegurar la creacion
    -- tanto al cargar como al entrar al juego (setupButton es idempotente).
    connect(g_game, { onGameStart = setupButton })
    addEvent(function()
        setupButton()
    end)
    if g_game.isOnline() then
        setupButton()
    end
end

function setupButton()
    if donateButton then
        return
    end

    -- Boton grande "Donate" en el panel derecho, justo donde estaba "Store"
    donateButton = modules.game_mainpanel.addStoreButton('donateButton',
        tr('Donate'), '/images/options/donate_large', toggle)

    -- Quitar el boton "Store" (inutil en un server 7.72)
    local parent = donateButton and donateButton:getParent()
    local storeBtn = parent and parent:getChildById('Store shop')
    if storeBtn then
        storeBtn:destroy()
    end
end

function terminate()
    disconnect(g_game, { onGameStart = setupButton })
    if donateWindow then
        donateWindow:destroy()
        donateWindow = nil
    end
    if donateButton then
        donateButton:destroy()
        donateButton = nil
    end
end

function toggle()
    if not donateWindow then
        return
    end
    if donateWindow:isVisible() then
        donateWindow:hide()
    else
        donateWindow:show()
        donateWindow:raise()
        donateWindow:focus()
    end
end
