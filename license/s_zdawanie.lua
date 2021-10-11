addEvent("license:do",true)
addEventHandler("license:do", resourceRoot, function(cost,selected)
	if tonumber(cost) <= getPlayerMoney(client) then
		takePlayerMoney(client,cost)
	end

	local veh=nil
	--if #getElementsWithinColShape(zone,"vehicle") >= 1 then outputChatBox("* Miejsce respu zajęte, poczekaj aż ktoś wyjedzie.",client) return end
	if selected == "A" then veh=createVehicle(586, 964.10, -1356.16, 12.78, 359.8, 0.0, 90.0)
	elseif selected == "B" then veh=createVehicle(436, 953.56, -1355.26, 13.11, 359.4, 360.0, 179.5)
	elseif selected == "C" then veh=createVehicle(459, 964.93, -1376.55, 13.44, 0.0, 0.0, 360.0)
	elseif selected == "L" then veh=createVehicle(593, 1436.16, 1299.77, 11.28, 360, 360, 360) end
	if not veh then return end
	if selected == "L" then
	setElementData(veh,"vehicle:desc","Egzamin licencji lotniczej\nKategoria "..selected.."")
	else
	setElementData(veh,"vehicle:desc","Egzamin prawa jazdy\nKategoria "..selected.."")
	end
	setElementData(veh,"vehicle:mileage",16442)
	setElementData(veh,"vehicle:fuel",100)
	setElementData(veh,"vehicle:lic",true)

	setElementDimension(client,0)
	setElementInterior(client,0)
	showPlayerHudComponent(client, "radar", true)
	warpPedIntoVehicle(client,veh)
	triggerClientEvent(client, "license:start", resourceRoot, selected, veh)
	--outputChatBox("* "..getPlayerName(client).." rozpoczął(ęła) egzamin prawa jazdy, kategoria: "..selected.."", root, 255, 0, 0)
end)

addEvent("license:vehdel", true)
addEventHandler("license:vehdel", resourceRoot, function(veh)
	destroyElement(veh)
end)

addEventHandler("onPlayerQuit", root, function()
	local veh=getPedOccupiedVehicle(source)
	if not veh then return end
	if getVehicleController(veh) ~= source then return end
	if not getElementData(veh,"vehicle:lic") then return end
	destroyElement(veh)
end)

addEventHandler("onVehicleDamage", resourceRoot, function(loss)
	local kierowca=getVehicleController(source)
	if not kierowca then return end
	if not getElementData(source,"vehicle:lic") then return end
	destroyElement(source)
	outputChatBox("* Uszkodziłeś(aś) pojazd, nie zdajesz egzaminu!", kierowca, 255, 0, 0)
	triggerClientEvent(kierowca, "license:finish", resourceRoot, true)
	setTimer(function()
	setElementPosition(kierowca, 932.77, -1445.83, 13.55)
	end, 3500,1)
end)

addEventHandler("onVehicleStartExit", resourceRoot, function()
	cancelEvent()
end)