local permanentID = nil -- Almacena la ID del jugador
local displayTime = 5000 -- Tiempo de duración en milisegundos (5000ms = 5 segundos)

-- Evento para recibir la ID desde el servidor
RegisterNetEvent('showPermanentID')
AddEventHandler('showPermanentID', function(id)
    permanentID = id
    -- Mostrar mensaje durante 5 segundos
    Citizen.SetTimeout(displayTime, function()
        permanentID = nil -- Borra el texto después de 5 segundos
    end)
end)

-- Función para dibujar texto en la pantalla (HUD)
function DrawHUDText(text, x, y, scale, r, g, b, a)
    SetTextFont(4)
    SetTextScale(scale, scale)
    SetTextColour(255, 255, 255, 255) -- Color del texto
    SetTextOutline()
    SetTextCentre(true) -- Centrar texto
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x, y)
end

-- Hilo para mostrar la ID en la pantalla por 5 segundos
CreateThread(function()
    while true do
        Wait(0) -- Renderizado constante
        if permanentID then
            DrawHUDText("#" .. permanentID, 0.5, 0.5, 0.6, 255, 255, 0, 255)
        end
    end
end)

