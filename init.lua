--[[
Teleport ver 0.9 par Jat
Licence GPLv2 or later for code
Licence WTFPL for image
teleport_pierre_*.png and teleport_portail*.png by AndrOn
--]]

--Chargée le fichier configuration
dofile(minetest.get_modpath("teleport").."/conf.lua")

--Variable
----Fixe
local couleurs = {"black","blue","brown","cyan","dark_green","dark_grey","green","grey","magenta","orange","pink","red","violet","white","yellow"}
local timer=0
local version=18062013

--Engistre dans le cube la version teleport qui est utilisé
local place=true
minetest.register_globalstep(function(dtime)
	if place then
		mversion=minetest.env:get_meta(TELEPORT_SERVEUR):get_int("version")
		if mversion==nil or mversion<version then
			mversion=minetest.env:get_meta(TELEPORT_SERVEUR):set_int("version",version)
		end
	end
end)




--Function

local function allentour(pos,node)
	local position={{x=pos.x+1, y=pos.y, z=pos.z},{x=pos.x-1, y=pos.y, z=pos.z},{x=pos.x, y=pos.y, z=pos.z+1},{x=pos.x, y=pos.y, z=pos.z-1},{x=pos.x, y=pos.y+1, z=pos.z},{x=pos.x, y=pos.y-1, z=pos.z}}
	for c=1,table.getn(position) do	
		for d=1,table.getn(node) do	
			if minetest.env:get_node(position[c]).name==node[d] then
				return position[c]
			end
		end
	end
end

minetest.register_globalstep(function(dtime)
	timer = timer+dtime
	if timer <= 1 then
		return
	end
	timer = 0
	local tempo=minetest.deserialize(minetest.env:get_meta(TELEPORT_SERVEUR):get_string("lestempo"))
	for pos,v in pairs(tempo) do 
		if os.difftime(os.time(),v)>TELEPORT_DUREE_VORTEX or os.difftime(os.time(),v)<0 then
			local portail=minetest.deserialize(minetest.env:get_meta(pos):get_string("portail"))
			if not(portail==nil) then
				for c=1,table.getn(portail) do
					minetest.env:remove_node(portail[c])
				end
			end
			tempo[pos]=nil
		end
	end
	minetest.env:get_meta(TELEPORT_SERVEUR):set_string("lestempo",minetest.serialize(tempo))
end)

--Serveur central

minetest.register_node("teleport:serveur", {
	description = "Portail a passe",
	tiles = {"teleport_portailentree.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
	groups = {unbreakable=1},
	on_construct = function(pos)
		minetest.env:get_meta(pos):set_int("version",version)
		minetest.env:get_meta(pos):set_string("lesadresse",minetest.serialize({}))
		minetest.env:get_meta(pos):set_string("lestempo",minetest.serialize({}))
	end,
})

--Portail

--Node
minetest.register_node("teleport:portailentree", {
	description = "Portail a passe",
	tiles = {"teleport_portailentree.png"},
    is_ground_content = false,
    walkable = false,
    pointable = false,
	groups = {unbreakable=1},
	on_construct = function(pos)
		minetest.env:get_meta(pos):set_string("teleportation",minetest.serialize())
	end,
})
minetest.register_node("teleport:portailsortie", {
	description = "Portail active mais non passable",
	tiles = {"teleport_portailsortie.png"},
    is_ground_content = false,
    walkable = false,
    pointable = false,
	groups = {unbreakable=1},
})
minetest.register_node("teleport:portail", {
	description = "Portail pour la construction",
	tiles = {"teleport_portail.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
	groups = {unbreakable=1},
})

--ABM

minetest.register_abm(
	{nodenames = {"teleport:portailentree"},
    interval = 1.0,
    chance = 1,
    action = function(pos, node, active_object_count, active_object_count_wider)
		local players = minetest.env:get_objects_inside_radius(pos, 1)
        for k, player in pairs(players) do
			player:setpos(minetest.deserialize(minetest.env:get_meta(pos):get_string("teleportation")))
		end
    end
})

--Terminal

minetest.register_node("teleport:socle1", {
	description = "Socle pour les pierres de teleportation",
	tiles = {"teleport_socle1.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
	groups = {unbreakable=1},
	drop= "",
	after_place_node = function(pos, placer)
		minetest.env:get_meta(pos):set_int("numero", 2)
		placer:get_inventory():add_item('main', 'teleport:socle2')
	end,
})
minetest.register_node("teleport:socle2", {
	description = "Socle pour les pierres de teleportation",
	tiles = {"teleport_socle2.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
	groups = {unbreakable=1},
	drop= "",
	after_place_node = function(pos, placer)
		minetest.env:get_meta(pos):set_int("numero", 3)
		placer:get_inventory():add_item('main', 'teleport:socle3')
	end,
})
minetest.register_node("teleport:socle3", {
	description = "Socle pour les pierres de teleportation",
	tiles = {"teleport_socle3.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
	groups = {unbreakable=1},
	drop= "",
	after_place_node = function(pos, placer)
		minetest.env:get_meta(pos):set_int("numero", 4)
		placer:get_inventory():add_item('main', 'teleport:socle4')
	end,
})
minetest.register_node("teleport:socle4", {
	description = "Socle pour les pierres de teleportation",
	tiles = {"teleport_socle4.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
	groups = {unbreakable=1},
	drop= "",
	after_place_node = function(pos, placer)
		minetest.env:get_meta(pos):set_int("numero", 5)
		placer:get_inventory():add_item('main', 'teleport:portail 99')
	end,
})
minetest.register_node("teleport:socle", {
	description = "Socle pour les pierres de teleportation",
	tiles = {"teleport_socle.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
	groups = {unbreakable=1},
	drop= "",
	after_place_node = function(pos, placer)
		minetest.env:get_meta(pos):set_string("adresse",minetest.serialize({"","","",""}))
		minetest.env:get_meta(pos):set_string("adressecompose",minetest.serialize({"","","","",""}))
		minetest.env:get_meta(pos):set_string("lessocle",minetest.serialize({"","","",""}))
		minetest.env:get_meta(pos):set_string("portail",minetest.serialize())
		minetest.env:get_meta(pos):set_string("signalisation",minetest.serialize({}))
		placer:get_inventory():add_item('main', 'teleport:socle1')
	end,
	on_destruct = function(pos)
		local adresse = minetest.deserialize(minetest.env:get_meta(pos):get_string("adresse"))
		local socle = minetest.deserialize(minetest.env:get_meta(pos):get_string("lessocle"))
		local serveuradresse = minetest.deserialize(minetest.env:get_meta(TELEPORT_SERVEUR):get_string("lesadresse"))
		if not(adresse[1]=="" or adresse[2]=="" or adresse[3]=="" or adresse[4]=="") then
			serveuradresse[""..adresse[1]..","..adresse[2]..","..adresse[3]..","..adresse[4]..""] = nil
			minetest.env:get_meta(TELEPORT_SERVEUR):set_string("lesadresse",minetest.serialize(serveuradresse))
		end		
		for i=1,table.getn(socle) do
			if not(socle[i]=="") then
				minetest.env:remove_node(socle[i])
			end
		end
	end,
})

--Pierre / Signialisation

minetest.register_node("teleport:signalisation1", {
	description = "Signale",
	tiles = {"bobblocks_whiteblock.png"},
	is_ground_content = false,
	walkable = true,
	pointable = true,
	groups = {unbreakable=1},
})
minetest.register_node("teleport:signalisation2", {
	description = "Signale",
	tiles = {"bobblocks_whiteblock.png"},
	is_ground_content = false,
	walkable = true,
	pointable = true,
	groups = {unbreakable=1},
})
minetest.register_node("teleport:signalisation3", {
	description = "Signale",
	tiles = {"bobblocks_whiteblock.png"},
	is_ground_content = false,
	walkable = true,
	pointable = true,
	groups = {unbreakable=1},
})
minetest.register_node("teleport:signalisation4", {
	description = "Signale",
	tiles = {"bobblocks_whiteblock.png"},
	is_ground_content = false,
	walkable = true,
	pointable = true,
	groups = {unbreakable=1},
})
minetest.register_node("teleport:signalisation", {
	description = "Signale",
	tiles = {"bobblocks_whiteblock.png"},
	is_ground_content = false,
	walkable = true,
	pointable = true,
	groups = {unbreakable=1},
})
minetest.register_node("teleport:pierremulticouleur", {
		description = "Pierre pour admin",
		tiles = {"default_cobble.png"},
		is_ground_content = false,
		walkable = true,
		pointable = true,
		groups = {unbreakable=1},
		after_place_node = function(pos, placer)
		local autour=allentour(pos,{"teleport:socle"})
		if not(autour==nil) then
			local adressecompose=minetest.deserialize(minetest.env:get_meta(autour):get_string("adressecompose"))
			adressecompose[1]="teleport:pierremulticouleur"
			minetest.env:get_meta(autour):set_string("adressecompose",minetest.serialize(adressecompose))
			local portail=minetest.deserialize(minetest.env:get_meta(autour):get_string("portail"))
			if portail==nil then
				local prb = false
				--Trouver les 4 signialisation
				for c=1,4 do
					local varsignalisation=minetest.deserialize(minetest.env:get_meta(autour):get_string("signialisation"))
					local signialisation=minetest.env:find_nodes_in_area({x=autour.x-15,y=autour.y-15,z=autour.z-15},{x=autour.x+15,y=autour.y+15,z=autour.z+15},"teleport:signalisation"..c.."" )
					if signialisation=={} or not(1==table.getn(signialisation)) then
						minetest.chat_send_player(placer:get_player_name(), "Il vous manque la signialisation "..c.." ou il y en a trop.(optionelle)")
					else
						varsignialisation[c]=signialisation[1]
						minetest.env:get_meta(autour):set_string("signialisation",minetest.serialize(varsignialisation))
					end
				end
				--Trouver les 4 socle
				for c=1,4 do
					local lessocle=minetest.deserialize(minetest.env:get_meta(autour):get_string("lessocle"))
					local socle=minetest.env:find_nodes_in_area({x=autour.x-15,y=autour.y-15,z=autour.z-15},{x=autour.x+15,y=autour.y+15,z=autour.z+15},"teleport:socle"..c.."" )
					if socle==nil or not(1==table.getn(socle)) then
						minetest.chat_send_player(placer:get_player_name(), "Il vous manque le socle "..c.." ou il y en a trop. Il y a "..table.getn(socle).." socle.")
						prb = true
					else
						lessocle[c]=socle[1]
						minetest.env:get_meta(autour):set_string("lessocle",minetest.serialize(lessocle))
						minetest.env:get_meta(socle[1]):set_string("position",minetest.serialize(autour))
					end
				end
				--Trouver les portail
				if not(prb) then
					local lesportail=minetest.env:find_nodes_in_area({x=autour.x-15,y=autour.y-15,z=autour.z-15},{x=autour.x+15,y=autour.y+15,z=autour.z+15},"teleport:portail" )
					if table.getn(lesportail)>=1 then
						minetest.env:get_meta(autour):set_string("portail",minetest.serialize(lesportail))
						for c=1,table.getn(lesportail) do
							minetest.env:remove_node(lesportail[c])
						end
					else
						minetest.chat_send_player(placer:get_player_name(), "Les portails ne sont pas dans la zone ou y en a aucun.")
						prb = true
					end
				end
				--Suppresion de la pierre si il y a aucun probleme
				if not(prb) then
					minetest.env:remove_node(pos)
				end
			end	
		end
	end,
	on_destruct = function(pos)
		local autour=allentour(pos,{"teleport:socle"})
		if not(autour==nil) then
			local adressecompose=minetest.deserialize(minetest.env:get_meta(autour):get_string("adressecompose"))
			adressecompose[1]=""
			minetest.env:get_meta(autour):set_string("adressecompose",minetest.serialize(adressecompose))
		end
	end,
})
--Craft
minetest.register_node("teleport:pierre", {
	description = "Pierre vide",
	tiles = {"teleport_pierre_d.png","teleport_pierre_d.png","teleport_pierre_cote.png","teleport_pierre_cote.png","teleport_pierre_cote.png","teleport_pierre_cote.png"},
	is_ground_content = false,
	walkable = true,
	pointable = true,
	groups = {dig_immediate=3},
})
minetest.register_craft({
output = "teleport:pierre",
recipe = {
	{"", "default:mese",""},
	{"default:glass", "", "default:glass"},
	{"", "default:mese", ""},
}
})
for i = 1,table.getn(couleurs) do 
	--Pierre
	minetest.register_node("teleport:pierre"..couleurs[i].."", {
		description = "Pierre de couleur "..couleurs[i].."",
		tiles = {"teleport_pierre_d.png","teleport_pierre_d.png","teleport_pierre_cote.png^dye_"..couleurs[i]..".png","teleport_pierre_cote.png^dye_"..couleurs[i]..".png","teleport_pierre_cote.png^dye_"..couleurs[i]..".png","teleport_pierre_cote.png^dye_"..couleurs[i]..".png"},
		is_ground_content = false,
		walkable = true,
		pointable = true,
		groups = {dig_immediate=3},
		after_place_node = function(pos, placer)
			local autour=allentour(pos,{"teleport:socle1","teleport:socle2","teleport:socle3","teleport:socle4"})
			if not(autour == nil) then
				local possocle = minetest.deserialize(minetest.env:get_meta(autour):get_string("position"))
				local adressecompose = minetest.deserialize(minetest.env:get_meta(possocle):get_string("adressecompose"))
				local adresse = minetest.deserialize(minetest.env:get_meta(possocle):get_string("adresse"))
				local serveuradresse = minetest.deserialize(minetest.env:get_meta(TELEPORT_SERVEUR):get_string("lesadresse"))
				local lessocle=minetest.deserialize(minetest.env:get_meta(possocle):get_string("lessocle"))
				adressecompose[minetest.env:get_meta(autour):get_int("numero")]="teleport:pierre"..couleurs[i]..""
				minetest.env:get_meta(possocle):set_string("adressecompose",minetest.serialize(adressecompose))
				if not(adressecompose[2]=="") and not(adressecompose[3]=="") and not(adressecompose[4]=="") and not(adressecompose[5]=="") then
				--Sauvegarde l'adresse
					if adressecompose[1]=="teleport:pierremulticouleur" and (adresse[1]=="" or adresse[2]=="" or adresse[3]=="" or adresse[4]=="") and serveuradresse[""..adressecompose[2]..","..adressecompose[3]..","..adressecompose[4]..","..adressecompose[5]..""]==nil then
						--Engistre dans le socle
						adresse[1]=adressecompose[2]
						adresse[2]=adressecompose[3]
						adresse[3]=adressecompose[4]
						adresse[4]=adressecompose[5]
						minetest.env:get_meta(possocle):set_string("adresse",minetest.serialize(adresse))
						--Envoie au  serveur
						serveuradresse[""..adressecompose[2]..","..adressecompose[3]..","..adressecompose[4]..","..adressecompose[5]..""] = possocle
						minetest.env:get_meta(TELEPORT_SERVEUR):set_string("lesadresse",minetest.serialize(serveuradresse))
						--Suppression des pierre
						minetest.env:remove_node(allentour(possocle,{adressecompose[1]}))
						minetest.env:remove_node(allentour(lessocle[1],{adressecompose[2]}))
						minetest.env:remove_node(allentour(lessocle[2],{adressecompose[3]}))
						minetest.env:remove_node(allentour(lessocle[3],{adressecompose[4]}))
						minetest.env:remove_node(allentour(lessocle[4],{adressecompose[5]}))
					elseif not(adresse[1]=="" or adresse[2]=="" or adresse[3]=="" or adresse[4]=="") and not(serveuradresse[""..adressecompose[2]..","..adressecompose[3]..","..adressecompose[4]..","..adressecompose[5]..""]==nil) then
						--Si l'adresse est valide
						local possoclereception = serveuradresse[""..adressecompose[2]..","..adressecompose[3]..","..adressecompose[4]..","..adressecompose[5]..""]
						if not(adresse[1]==adressecompose[2] and adresse[2]==adressecompose[3] and adresse[3]==adressecompose[4] and adresse[4]==adressecompose[5]) then
							--Si les deux point sont pas les meme
							local tempo=minetest.deserialize(minetest.env:get_meta(TELEPORT_SERVEUR):get_string("lestempo"))
							local porte=true
							--Verifie que les portail sont pas occupé
							for pos,v in pairs(tempo) do
								if (pos.x==possoclereception.x and pos.y==possoclereception.y and pos.z==possoclereception.z) or (pos.x==possocle.x and pos.y==possocle.y and pos.z==possocle.z) then
									porte=false
									break
								end
							end
							if porte then
								local portailenvoie=minetest.deserialize(minetest.env:get_meta(possocle):get_string("portail"))
								local portailreception=minetest.deserialize(minetest.env:get_meta(possoclereception):get_string("portail"))
								--Portail d'envoie
								for c=1,table.getn(portailenvoie) do
									minetest.env:add_node(portailenvoie[c], {name="teleport:portailentree"})
									minetest.env:get_meta(portailenvoie[c]):set_string("teleportation",minetest.serialize({x=possoclereception.x,y=possoclereception.y+1,z=possoclereception.z}))
								end
								--Portail de reception
								for c=1,table.getn(portailreception) do
									minetest.env:add_node(portailreception[c], {name="teleport:portailsortie"})
								end
								--Temp
								tempo[possocle]=os.time()
								tempo[possoclereception]=os.time()
								minetest.env:get_meta(TELEPORT_SERVEUR):set_string("lestempo",minetest.serialize(tempo))
								--Suppression des pierre
								for c=1,4 do
									if 25==math.random(1,50) then	
										minetest.env:remove_node(allentour(lessocle[c],{adressecompose[c+1]}))
									else
										minetest.env:add_node(allentour(lessocle[c],{adressecompose[c+1]}), {name="teleport:pierre"})
									end
								end
							end
						end	
					end
				end
			end
		end,
		on_destruct = function(pos)
			local autour=allentour(pos,{"teleport:socle1","teleport:socle2","teleport:socle3","teleport:socle4"})
			if not(autour==nil) then
				local possocle = minetest.deserialize(minetest.env:get_meta(autour):get_string("position"))
				local adressecompose=minetest.deserialize(minetest.env:get_meta(possocle):get_string("adressecompose"))
				adressecompose[minetest.env:get_meta(autour):get_int("numero")]=""
				minetest.env:get_meta(possocle):set_string("adressecompose",minetest.serialize(adressecompose))
			end
		end,
	})
	--Signalisation
	minetest.register_node("teleport:signalisation"..couleurs[i].."", {
		description = "Signale les couleur "..couleurs[i].."",
		tiles = {"bobblocks_whiteblock.png^dye_"..couleurs[i]..".png"},
		is_ground_content = false,
		walkable = true,
		pointable = true,
		groups = {unbreakable=1},
		on_construct = function(pos)
			minetest.env:get_node_timer(pos):start(TELEPORT_DUREE_VORTEX)
		end,
		on_timer = function(pos,elapsed)
			minetest.env:add_node(pos, {name="teleport:signalisation"})
		end,
	})
	--Craft
	minetest.register_craft({
	output = "teleport:pierre"..couleurs[i].."",
	recipe = {
		{"dye:"..couleurs[i]..""},
		{"teleport:pierre"},
		}
	})
end