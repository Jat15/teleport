--[[
Teleport ver 0.9 par Jat
Licence GPLv2 or later for code
Licence CC-BY-SA for image

--]]

--Variable

local couleurs = {"black","blue","brown","cyan","dark_green","dark_grey","green","grey","magenta","orange","pink","red","violet","white","yellow"}
local serveur = {x=-0,y=2,z=0}

--Function

local function autour(pos,node)
	position={{x=pos.x+1, y=pos.y, z=pos.z},{x=pos.x-1, y=pos.y, z=pos.z},{x=pos.x, y=pos.y, z=pos.z+1},{x=pos.x, y=pos.y, z=pos.z-1},{x=pos.x, y=pos.y+1, z=pos.z},{x=pos.x, y=pos.y-1, z=pos.z}}
	for c=1,table.getn(position) do	
		for d=1,table.getn(node) do	
			if minetest.env:get_node(position[c]).name==node[d] then
				return position[c]
			end
		end
	end
end

--Alias

minetest.register_alias("teleport","teleport:portail","teleport:socle","teleport:socle1","teleport:socle2","teleport:socle3","teleport:socle4")

--Serveur central

minetest.register_node("teleport:serveur", {
	description = "Portail a passe",
	tiles = {"teleport_portailentree.png"},
    is_ground_content = false,
    walkable = false,
    pointable = false,
	groups = {unbreakable=1},
	after_place_node = function(pos, placer)
		minetest.env:get_meta(pos):set_string("lesadresse",minetest.serialize({}))
		--privs["interact"] = true
	end,
})

--Portail

minetest.register_node("teleport:portailentree", {
	description = "Portail a passe",
	tiles = {"teleport_portailentree.png"},
    is_ground_content = false,
    walkable = false,
    pointable = false,
	groups = {unbreakable=1},
	on_construct = function(pos)
		minetest.env:get_node_timer(pos):start(60)
	end,
	on_timer = function(pos,elapsed)
		minetest.env:add_node(pos, {name="teleport:signalisation"})
	end,
})
minetest.register_node("teleport:portailsortie", {
	description = "Portail active mais non passable",
	tiles = {"teleport_portailsortie.png"},
    is_ground_content = false,
    walkable = false,
    pointable = false,
	groups = {unbreakable=1},
	on_construct = function(pos)
		minetest.env:get_node_timer(pos):start(60)
	end,
	on_timer = function(pos,elapsed)
		minetest.env:add_node(pos, {name="teleport:signalisation"})
	end,
})
minetest.register_node("teleport:portail", {
	description = "Portail pour la construction",
	tiles = {"teleport_portail.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
	groups = {unbreakable=1},
})

--Terminal

minetest.register_node("teleport:socle1", {
	description = "Socle pour les pierres de teleportation",
	tiles = {"teleport_socle1.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
	groups = {unbreakable=1},
	after_place_node = function(pos, placer)
		minetest.env:get_meta(pos):set_int("numero", 2)
	end,
})
minetest.register_node("teleport:socle2", {
	description = "Socle pour les pierres de teleportation",
	tiles = {"teleport_socle2.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
	groups = {unbreakable=1},
		after_place_node = function(pos, placer)
		minetest.env:get_meta(pos):set_int("numero", 3)
	end,
})
minetest.register_node("teleport:socle3", {
	description = "Socle pour les pierres de teleportation",
	tiles = {"teleport_socle3.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
	groups = {unbreakable=1},
		after_place_node = function(pos, placer)
		minetest.env:get_meta(pos):set_int("numero", 4)
	end,
})
minetest.register_node("teleport:socle4", {
	description = "Socle pour les pierres de teleportation",
	tiles = {"teleport_socle4.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
	groups = {unbreakable=1},
		after_place_node = function(pos, placer)
		minetest.env:get_meta(pos):set_int("numero", 5)
	end,
})
minetest.register_node("teleport:socle", {
	description = "Socle pour les pierres de teleportation",
	tiles = {"teleport_socle.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
	groups = {unbreakable=1},
	after_place_node = function(pos, placer)
		minetest.env:get_meta(pos):set_string("adresse",minetest.serialize({"","","","",""}))
		minetest.env:get_meta(pos):set_string("adressecompose",minetest.serialize({"","","","",""}))
		minetest.env:get_meta(pos):set_string("portail",minetest.serialize())
		minetest.env:get_meta(pos):set_string("signalisation",minetest.serialize({}))
		minetest.env:get_meta(pos):set_string("etat",minetest.serialize())
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
			local autour=autour(pos,{"teleport:socle"})
			if autour==nil then
				placer:get_inventory():add_item('main', 'teleport:pierremulticouleur 1')
				minetest.env:remove_node(pos)
			else
				local adressecompose=minetest.deserialize(minetest.env:get_meta(autour):get_string("adressecompose"))
				table.insert(adressecompose, 1, "multicouleur")
				minetest.env:get_meta(pos):set_string("adressecompose",minetest.serialize(adressecompose))
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
							table.insert(varsignialisation, c, signialisation)
							minetest.env:get_meta(autour):set_string("signialisation",minetest.serialize(varsignialisation))
						end
					end
					--Trouver les 4 socle
					for c=1,4 do
						local socle=minetest.env:find_nodes_in_area({x=autour.x-15,y=autour.y-15,z=autour.z-15},{x=autour.x+15,y=autour.y+15,z=autour.z+15},"teleport:socle"..c.."" )
						if socle==nil or not(1==table.getn(socle)) then
							minetest.chat_send_player(placer:get_player_name(), "Il vous manque le socle "..c.." ou il y en a trop. Il y a "..table.getn(socle).." socle.")
							prb = true
						end
						minetest.env:get_meta(socle):set_string("position",minetest.serialize(autour))
--						minetest.chat_send_all(minetest.serialize(socle))
--						minetest.chat_send_all(minetest.env:get_meta(socle):get_string("position"))
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
						table.insert(adressecompose, 1, "")
						minetest.env:get_meta(pos):set_string("adressecompose",minetest.serialize(adressecompose))
						minetest.env:remove_node(pos)
					end
				end	
			end
		end,
		on_destruct = function(pos)
			local autour=autour(pos,{"teleport:socle"})
			if not(autour==nil) then
				local adressecompose=minetest.deserialize(minetest.env:get_meta(autour):get_string("adressecompose"))
				table.insert(adressecompose, 1, "")
				minetest.env:get_meta(pos):set_string("adressecompose",minetest.serialize(adressecompose))
			end
		end,
	})
for i = 1,table.getn(couleurs) do 
	--Pierre
	minetest.register_node("teleport:pierre"..couleurs[i].."", {
		description = "Pierre de couleur "..couleurs[i].."",
		tiles = {"default_cobble.png^dye_"..couleurs[i]..".png"},
		is_ground_content = false,
		walkable = true,
		pointable = true,
		groups = {dig_immediate=3},
		after_place_node = function(pos, placer)
			local autour=autour(pos,{"teleport:socle1","teleport:socle2","teleport:socle3","teleport:socle4"})
			if autour == nil then
				placer:get_inventory():add_item("main", "teleport:pierre"..couleurs[i].." 1")
				minetest.env:remove_node(pos)
			else
				local possocle = minetest.deserialize(minetest.env:get_meta(autour):get_string("position"))
				local adressecompose=minetest.deserialize(minetest.env:get_meta(possocle):get_string("adressecompose"))
				local adresse=minetest.deserialize(minetest.env:get_meta(possocle):get_string("adresse"))
				local serveuradresse=minetest.env:get_meta(serveur):get_string("adresse")
				table.insert(adressecompose, minetest.env:get_meta(autour):get_int("numero"), "teleport:pierre"..couleurs[i].."")
				minetest.env:get_meta(possocle):set_string("adressecompose",minetest.serialize(adressecompose))
				if not(adressecompose[2]=="") and not(adressecompose[3]=="") and not(adressecompose[4]=="") and not(adressecompose[5]=="") then
				--Sauvegarde l'adresse
					if adressecompose[1]=="teleport:pierremulticouleur" and (adresse[1]=="" or adresse[2]=="" or adresse[3]=="" or adresse[4]=="") then
						--Engistre dans le socle
						table.insert(adresse, 1, adressecompose[2])
						table.insert(adresse, 2, adressecompose[3])
						table.insert(adresse, 3, adressecompose[4])
						table.insert(adresse, 4, adressecompose[5])
						minetest.env:get_meta(possocle):set_string("adresse",minetest.serialize(adresse))
						--Envoie au  serveur
						serveuradresse[""..adressecompose[2]..","..adressecompose[3]..","..adressecompose[4]..","..adressecompose[5]..""] = possocle
						minetest.env:get_meta(serveur):set_string("adresse",minetest.serialize(serveuradresse))
					else
						--Si on prend l'adresse de la porte
						if not({adressecompose[2],adressecompose[3],adressecompose[4],adressecompose[5]}==adresse) then
							--Si l'adresse est valide
							if serveuradresse[""..adressecompose[2]..","..adressecompose[3]..","..adressecompose[4]..","..adressecompose[5]..""]==nil then
								local possoclereception=serveuradresse[""..adressecompose[2]..","..adressecompose[3]..","..adressecompose[4]..","..adressecompose[5]..""]
								local portailenvoie=minetest.deserialize(minetest.env:get_meta(possocle):get_string("portail"))
								local portailreception=minetest.deserialize(minetest.env:get_meta(possoclereception):get_string("portail"))
								--Portail d'envoie
								for c=1,table.getn(portailenvoie) do
									minetest.env:add_node(portailenvoie[c], {name="teleport:portailentree"})
									minetest.env:get_meta(portailenvoie[c]):set_string("adresse",minetest.serialize({x=possoclereception.x,y=possoclereception.y+1,z=possoclereception.z}))
								end
								--Portail de reception
								for c=1,table.getn(portailreception) do
									minetest.env:add_node(portailreception[c], {name="teleport:portailsortie"})
								end								
							end
						end
					end
				end
			end
		end,
		on_destruct = function(pos)
			local autour=autour(pos,{"teleport:socle1","teleport:socle2","teleport:socle3","teleport:socle4"})
			if not(autour==nil) then
				local possocle = minetest.deserialize(minetest.env:get_meta(autour):get_string("position"))
				local adressecompose=minetest.deserialize(minetest.env:get_meta(possocle):get_string("adressecompose"))
				table.insert(adressecompose, minetest.env:get_meta(autour):get_int("numero"), "")
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
			minetest.env:get_node_timer(pos):start(60)
		end,
		on_timer = function(pos,elapsed)
			minetest.env:add_node(pos, {name="teleport:signalisation"})
		end,
	})
end


