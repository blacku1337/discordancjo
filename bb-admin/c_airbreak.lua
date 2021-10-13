function DeveloperMode()
    if getElementData(localPlayer,"player:admin") == false then 
    	outputChatBox("* Nie posiadasz uprawnień.", 255, 0, 0)
    	return
    end
if getDevelopmentMode() == false then
setDevelopmentMode ( true )
else
setDevelopmentMode ( false )
end
end
addCommandHandler("devmode", DeveloperMode)
addCommandHandler("showmode", DeveloperMode)

local sx, sy = guiGetScreenSize()

function putPlayerInPosition(timeslice)
    local cx,cy,cz,ctx,cty,ctz = getCameraMatrix()
    ctx,cty = ctx-cx,cty-cy
    timeslice = timeslice*0.1   
    local tx, ty, tz = getWorldFromScreenPosition(sx / 2, sy / 2, 10)
    if isChatBoxInputActive() or isConsoleActive() or isMainMenuActive () or isTransferBoxActive () then return end 
    if getKeyState("lctrl") then timeslice = timeslice*4 end
    if getKeyState("lalt") then timeslice = timeslice*0.25 end
    local mult = timeslice/math.sqrt(ctx*ctx+cty*cty)
    ctx,cty = ctx*mult,cty*mult
    if getKeyState("2") then abx,aby = abx+ctx,aby+cty end
    if getKeyState("w") then abx,aby = abx+ctx,aby+cty end
    if getKeyState("s") then abx,aby = abx-ctx,aby-cty end
    if getKeyState("a") then  abx,aby = abx-cty,aby+ctx end
    if getKeyState("d") then abx,aby = abx+cty,aby-ctx end
    if getKeyState("space") then  abz = abz+timeslice end
    if getKeyState("lshift") then   abz = abz-timeslice end 
    local x,y = 650,650
    --dxDrawText ("Używaj W A S D, do poruszania się.\nSHIFT w dół, SPACJA w góre.\n\n* Pozycja:\n* X: "..abx.."\n* Y: "..aby.."\n* Z: "..abz.."", x, y ) 
    dxDrawText ("Pozycja:\nX: "..abx.."\nY: "..aby.."\nZ: "..abz.."\nDo poruszania użyj W,S,A,D\nZniżanie: Shift\nDo góry: Spacja\nPrzyspieszenie: CTRL\nSpowolnienie:ALT", x, y )

    if isPedInVehicle ( getLocalPlayer( ) ) then    
    local vehicle = getPedOccupiedVehicle( getLocalPlayer( ) )
    local angle = getPedCameraRotation(getLocalPlayer ( ))  
    setElementPosition(vehicle,abx,aby,abz)
    setElementRotation(vehicle,0,0,-angle)
    else
    local angle = getPedCameraRotation(getLocalPlayer ( ))  
    setElementRotation(getLocalPlayer ( ),0,0,angle)
    setElementPosition(getLocalPlayer ( ),abx,aby,abz)
    end
end
function toggleAirBrakec()
	if (not getElementData(localPlayer,"player:level")) then return end
	local levele = getElementData(localPlayer,"player:level")
    if levele then 
	if type(levele) == "number" then
		if levele < 1 then
    	outputChatBox("* Nie posiadasz uprawnień.", 255, 0, 0)
    	return end
	elseif type(levele) == "table" then
		if levele[1] < 1 then
    	outputChatBox("* Nie posiadasz uprawnień.", 255, 0, 0)
    	return end
	end
	toggleAirBrake()
	end
end
	
function toggleAirBrake()
    air_brake = not air_brake or nil
    if air_brake then
        
        if isPedInVehicle ( getLocalPlayer( ) ) then
        local vehicle = getPedOccupiedVehicle( getLocalPlayer( ) )
        abx,aby,abz = getElementPosition(vehicle)
        Speed,AlingSpeedX,AlingSpeedY = 0,1,1
        OldX,OldY,OldZ = 0
        setElementCollisionsEnabled ( vehicle, false )
        setElementFrozen(vehicle,true)
        setElementAlpha(getLocalPlayer(),0)
        addEventHandler("onClientPreRender",root,putPlayerInPosition)   
    else
        abx,aby,abz = getElementPosition(localPlayer)
        Speed,AlingSpeedX,AlingSpeedY = 0,1,1
        OldX,OldY,OldZ = 0
        setElementCollisionsEnabled ( localPlayer, false )
        addEventHandler("onClientPreRender",root,putPlayerInPosition)   
    end
    

    else
    if isPedInVehicle ( getLocalPlayer( ) ) then
        local vehicle = getPedOccupiedVehicle( getLocalPlayer( ) )
        abx,aby,abz = nil
        setElementFrozen(vehicle,false)
        setElementCollisionsEnabled ( vehicle, true )
        setElementAlpha(getLocalPlayer(),255)
        removeEventHandler("onClientPreRender",root,putPlayerInPosition)
        else
        abx,aby,abz = nil
        setElementCollisionsEnabled ( localPlayer, true )
        removeEventHandler("onClientPreRender",root,putPlayerInPosition)
        end
    end
end
bindKey("z","down",toggleAirBrakec)
