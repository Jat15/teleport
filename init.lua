--[[
Teleport ver 0.9 par Jat
Licence GPLv2 or later for code
Licence WTFPL for image
teleport_pierre_*.png and teleport_portail*.png by AndrOn
--]]

--Variable
----Fixe
local couleurs = {
	"red",
	
	"magenta",
	"dark_green",
	
	"pink",
	"brown",
	"blue",
	
	"orange",
	"cyan",
	"black",
	"yellow",
	
	"green",
	"violet",
	"grey",
	"dark_grey",
	"white"
}
local timer=0
local version=30112013

--Fixe DHD
local facedir={{x=1,z=1},{x=1,z=-1},{x=-1,z=-1},{x=-1,z=1}}

local hudclavier = {
	actif={
		{x=0.4,y=0.4,z=0.4},
		
		{x=0.4,y=0.2,z=0.2},
		{x=0.2,y=0.2,z=0.4},
		
		{x=0.2,y=0,z=0.2},
		{x=0.4,y=0,z=0},
		{x=0,y=0,z=0.4},
		
		{x=0.4,y=-0.2,z=-0.2},
		{x=0.2,y=-0.2,z=0},
		{x=0,y=-0.2,z=0.2},
		{x=-0.2,y=-0.2,z=0.4},
	
		{x=0.4,y=-0.4,z=-0.4},
		{x=0.2,y=-0.4,z=-0.2},
		{x=-0,y=-0.4,z=0},
		{x=-0.2,y=-0.4,z=0.2},
		{x=-0.4,y=-0.4,z=0.4}
	},
}

hudclavier.desactif={
		{x=hudclavier.actif[1].x,y=-0.5,z=hudclavier.actif[1].z},
		
		{x=hudclavier.actif[2].x,y=-0.5,z=hudclavier.actif[2].z},
		{x=hudclavier.actif[3].x,y=-0.5,z=hudclavier.actif[3].z},
		
		{x=hudclavier.actif[4].x,y=-0.5,z=hudclavier.actif[4].z},
		{x=hudclavier.actif[5].x,y=-0.5,z=hudclavier.actif[5].z},
		{x=hudclavier.actif[6].x,y=-0.5,z=hudclavier.actif[6].z},
		
		{x=hudclavier.actif[7].x,y=-0.5,z=hudclavier.actif[7].z},
		{x=hudclavier.actif[8].x,y=-0.5,z=hudclavier.actif[8].z},
		{x=hudclavier.actif[9].x,y=-0.5,z=hudclavier.actif[9].z},
		{x=hudclavier.actif[10].x,y=-0.5,z=hudclavier.actif[10].z},
		
		{x=hudclavier.actif[11].x,y=-0.5,z=hudclavier.actif[11].z},
		{x=hudclavier.actif[12].x,y=-0.5,z=hudclavier.actif[12].z},
		{x=hudclavier.actif[13].x,y=-0.5,z=hudclavier.actif[13].z},
		{x=hudclavier.actif[14].x,y=-0.5,z=hudclavier.actif[14].z},
		{x=hudclavier.actif[15].x,y=-0.5,z=hudclavier.actif[15].z}
	}

local hudadresse={
	desactif={
		{x=-0.1,y=0.4,z=0.1},
		{x=0.1,y=0.4,z=-0.1},
		{x=-0.1,y=0.2,z=0.1},
		{x=0.1,y=0.2,z=-0.1}
	},
	actif={
		{x=-0.4,y=0.4,z=0.4},
		{x=0.4,y=0.4,z=-0.4},
		{x=-0.4,y=0.2,z=0.4},
		{x=0.4,y=0.2,z=-0.4}
	}
}

local hudprix={
	desactif={
		{x=-0.2,y=-0.6,z=-0.2}
	},
	actif={
		{x=0,y=0,z=0}
	}
}

--Chargée le fichier configuration
dofile(minetest.get_modpath("teleport").."/conf.lua")


--Engistre dans le cube la version teleport qui est utilisé
local place=true
minetest.register_globalstep(function(dtime)
	if not(place) then
		return
	end
		local mversion=minetest.get_meta(TELEPORT_SERVEUR):get_int("version")
		if mversion==nil or mversion<18062013 then
			minetest.get_meta(TELEPORT_SERVEUR):set_int("version",version)
		end
		if mversion<25062013 then
			minetest.get_meta(TELEPORT_SERVEUR):set_string("lestempo",nil)
			minetest.get_meta(TELEPORT_SERVEUR):set_int("version",version)
		end
		if mversion<version then
			local serveuradresse = minetest.deserialize(minetest.get_meta(TELEPORT_SERVEUR):get_string("lesadresse"))
			local nouveauxserveuxadresse={}
			if not serveuradresse then return end
			for key, val in pairs(serveuradresse) do
				--socle
				local adresse = minetest.deserialize(minetest.get_meta(val):get_string("adresse"))
				for c=1,table.getn(adresse) do
					adresse[c]=string.gsub(adresse[c], "teleport:pierre", "")
				end
				minetest.get_meta(val):set_string("adresse",minetest.serialize(adresse))
				--serveur
				nouveauxserveuxadresse[""..adresse[1]..","..adresse[2]..","..adresse[3]..","..adresse[4]..""] = val
			end
			minetest.get_meta(TELEPORT_SERVEUR):set_string("lesadresse",minetest.serialize(nouveauxserveuxadresse))
			minetest.get_meta(TELEPORT_SERVEUR):set_int("version",version)
		end
		place=false
end)

--Function

local function actualisation(pos)
	menservice = minetest.get_meta(pos):get_int("enservice")
	if menservice==0 then
		return true
	elseif not(os.difftime(os.time(),menservice)>TELEPORT_DUREE_VORTEX or os.difftime(os.time(),menservice)<0) then	
		return false
	else
		local portail=minetest.deserialize(minetest.get_meta(pos):get_string("portail"))
		if not(portail==nil) then
			for c=1,table.getn(portail) do
				minetest.remove_node(portail[c])
			end
		end
		minetest.get_meta(pos):set_int("enservice",nil)
		return true
	end
end

--Serveur central

minetest.register_node("teleport:serveur", {
	description = "Portail a passe",
	tiles = {"teleport_portailentree.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
	groups = {unbreakable=1},
	on_construct = function(pos)
		minetest.get_meta(pos):set_int("version",version)
		minetest.get_meta(pos):set_string("lesadresse",minetest.serialize({}))
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
		minetest.get_meta(pos):set_string("teleportation",minetest.serialize())
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
	{nodenames = {"teleport:socle"},
    interval = 5,
    chance = 1,
    action = function(pos)
		actualisation(pos)
    end
})
minetest.register_abm(
	{nodenames = {"teleport:portailentree"},
    interval = 1,
    chance = 1,
    action = function(pos)
		local players = minetest.get_objects_inside_radius(pos, 1)
        for k, player in pairs(players) do
			if player:is_player() then
				player:setpos(minetest.deserialize(minetest.get_meta(pos):get_string("teleportation")))
			end
		end
    end
})

--Terminal

minetest.register_node("teleport:socle", {
	description = "Socle pour les pierres de teleportation",
	tiles = {"teleport_socle.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
	groups = {unbreakable=1},
	drop= "",
	after_place_node = function(pos, placer)
		minetest.get_meta(pos):set_string("adresse",minetest.serialize({"","","",""}))
		minetest.get_meta(pos):set_string("adressecompose",minetest.serialize({"","","","",""}))
		minetest.get_meta(pos):set_string("portail",minetest.serialize())
		placer:get_inventory():add_item("main", "teleport:dhd")
	end,
	on_destruct = function(pos)
		local adresse = minetest.deserialize(minetest.get_meta(pos):get_string("adresse"))
		local serveuradresse = minetest.deserialize(minetest.get_meta(TELEPORT_SERVEUR):get_string("lesadresse"))
		if not(adresse[1]=="" or adresse[2]=="" or adresse[3]=="" or adresse[4]=="") then
			serveuradresse[""..adresse[1]..","..adresse[2]..","..adresse[3]..","..adresse[4]..""] = nil
			minetest.get_meta(TELEPORT_SERVEUR):set_string("lesadresse",minetest.serialize(serveuradresse))
		end		
	end,
})

-- DHD

--Fuction

local function dhdspwan(pos, itemname, poscentrale)
	local obj = minetest.add_entity(pos, "teleport:clavier")
	obj:get_luaentity():set_item(minetest.serialize({itemname=itemname,pos=poscentrale}))
	return obj
end

local function bouger(liste,activer,poshud,timer)
	local nodeparam2 = minetest.get_node({x=poshud.x,y=poshud.y-1,z=poshud.z}).param2+1
	local status = {"actif","desactif"}
	if not(activer) then
		status = {"desactif","actif"}
	end
	for c=1,table.getn(liste["actif"]) do
		bo = minetest.get_objects_inside_radius({
			x=poshud.x+liste[status[2]][c].x*facedir[nodeparam2].x,
			y=poshud.y+liste[status[2]][c].y,
			z=poshud.z+liste[status[2]][c].z*facedir[nodeparam2].z},
			0.05
		)
		if table.getn(bo)>0 then
			if timer == true then
				bo[1]:get_luaentity().timer = os.time()
			end
		bo[1]:moveto({
			x=poshud.x+liste[status[1]][c].x*facedir[nodeparam2].x,
			y=poshud.y+liste[status[1]][c].y,
			z=poshud.z+liste[status[1]][c].z*facedir[nodeparam2].z
		})
		
		else
			return
		end
	end

end

--Support de dhd

minetest.register_node("teleport:dhd", {
	description = "dhd",
	drawtype = "nodebox",
	tiles = {"wool_white.png"},
	paramtype = "light",
	sunlight_propagates = true,
	walkable = true,
	groups = {unbreakable=1},
	legacy_wallmounted = true,
	paramtype2 = "facedir",
	node_box = {
		type = "fixed",
		fixed = {
		--socle
		{-0.3, -0.5, -0.3, 0.3, -0.3, 0.3},
		--colone
		{0.1, -0.3, -0.1, -0.1, 0.3, 0.1},
		--table
		{-0.1, 0.3, -0.1, 0.5, 0.5, 0.5},
		{-0.1, 0.3, 0.1, -0.3, 0.5, 0.5 },
		{-0.3, 0.3, 0.5, -0.5, 0.5, 0.3 },
		{0.1, 0.3, -0.1, 0.5, 0.5, -0.3 },
		{0.3, 0.3, -0.5, 0.5, 0.5, -0.3 },
		},
	},
	after_place_node = function(pos, placer)
		--status / 0 = init / 1 = pret a etre payer / 2 = payer
		minetest.get_meta(pos):set_int("status",0)
		placer:get_inventory():add_item("main", "teleport:portail 99")
		local obj=minetest.add_entity({x=pos.x,y=pos.y+1,z=pos.z}, "teleport:init")
		obj:get_luaentity():set_item(minetest.serialize({x=pos.x,y=pos.y+1,z=pos.z}))
		
	end,
	on_punch = function(pos, node, puncher)
		if minetest.get_meta(pos):get_int("status")>0 then
			pos={x=pos.x,y=pos.y+1,z=pos.z}
			local listeobj=minetest.get_objects_inside_radius(pos, 0.80)
			if table.getn(listeobj)<16 or table.getn(listeobj)>20 then
				for c=1,table.getn(listeobj) do
					if not(listeobj[c]:is_player()) then
						listeobj[c]:remove()
					end
				end	
				for c=1,table.getn(couleurs) do
					dhdspwan({x=pos.x+hudclavier["actif"][c].x*facedir[node.param2+1].x,y=pos.y+hudclavier["desactif"][1].y,z=pos.z+hudclavier["actif"][c].z*facedir[node.param2+1].z},"wool:"..couleurs[c].."",pos)
				end
				local obj=minetest.add_entity({x=pos.x+0*facedir[node.param2+1].x,y=pos.y+0,z=pos.z+0*facedir[node.param2+1].z}, "teleport:prix")
				obj:get_luaentity():set_item(minetest.serialize(pos))
			end
		end
	end,
	after_dig_node = function(pos, oldnode, oldmetadata)
		local pos = {x=pos.x,y=pos.y+1,z=pos.z}
		local listeobj=minetest.get_objects_inside_radius(pos, 0.80)
		for c=1,table.getn(listeobj) do
			if not(listeobj[c]:is_player()) then
				listeobj[c]:remove()
			end
		end
		possocle = minetest.deserialize(oldmetadata.fields.socle)
		if not(possocle==nil) then
			minetest.get_meta(possocle):set_string("posdhd",nil)
		end
	end,
})


--Hologramme

minetest.register_entity("teleport:clavier", {
	initial_properties = {
		physical = false,
		collisionbox = {-0.1,-0.1,-0.1, 0.1,0.1,0.1},
		visual = "sprite",
		visual_size = {x=0.13, y=0.13},
		textures = {""},
		is_visible = false,
	},
	itemname = "",
	pos = {},
	timer= nil,
	set_item = function(self, itemstring)
		local itemstring = minetest.deserialize(itemstring)
		self.itemname = itemstring["itemname"]
		self.pos = itemstring["pos"]
		self.timer = itemstring["timer"]
		local itemname = itemstring["itemname"]
		local item_texture = nil
		if minetest.registered_items[itemname] then
			item_texture = minetest.registered_items[itemname].inventory_image
		end
		prop = {
			is_visible = true,
			visual = "wielditem",
			textures = {itemname}
		}
		self.object:set_properties(prop)
	end,
	
	on_activate = function(self, staticdata)
		if string.sub(staticdata, 1, string.len("return")) == "return" then
			local data = minetest.deserialize(staticdata)
			if data and type(data) == "table" then
				self.itemname = staticdata["itemname"]
				self.pos = staticdata["pos"]
				self.timer = staticdata["timer"]
				self:set_item(staticdata)
			end
		end
		self.object:set_armor_groups({immortal=1})
	end,
	
	get_staticdata = function(self)
		return minetest.serialize({itemname = self.itemname, pos = self.pos, timer = self.timer})
	end,
	on_step= function(self, dtime)
		if (os.difftime(os.time(),self.timer)>TELEPORT_DUREE_VORTEX or os.difftime(os.time(),self.timer)<0) and self.timer~=nil then
			self.object:remove()
		end
	end,
	on_rightclick = function(self, hitter)
		local pos = self.object:getpos()
		local nodeparam2 = minetest.get_node({x=self.pos.x,y=self.pos.y-1,z=self.pos.z}).param2+1
		local possocle = minetest.deserialize(minetest.get_meta({x=self.pos.x,y=self.pos.y-1,z=self.pos.z}):get_string("socle"))
		local adressecompose = minetest.deserialize(minetest.get_meta(possocle):get_string("adressecompose"))
		if pos.y>self.pos.y-0.45 then
			efface = false
			--Regarde si on est dans la zone adresse desactif
			for c=1,table.getn(hudadresse.desactif) do
				local posa={x=self.pos.x+hudadresse.desactif[c].x*facedir[nodeparam2].x,y=self.pos.y+hudadresse.desactif[c].y,z=self.pos.z+hudadresse.desactif[c].z*facedir[nodeparam2].z}
				if (posa.x-0.05<=pos.x and pos.x<=posa.x+0.05) and 
				(posa.y-0.05<=pos.y and pos.y<=posa.y+0.05) and 
				(posa.z-0.05<=pos.z and pos.z<=posa.z+0.05) then	
					return
				end
			end
			
			--Regarde si on est dans la zone adresse actif
			for c=1,table.getn(hudadresse.actif) do
				local posa={x=self.pos.x+hudadresse.actif[c].x*facedir[nodeparam2].x,y=self.pos.y+hudadresse.actif[c].y,z=self.pos.z+hudadresse.actif[c].z*facedir[nodeparam2].z}
				if (posa.x-0.05<=pos.x and pos.x<=posa.x+0.05) and 
				(posa.y-0.05<=pos.y and pos.y<=posa.y+0.05) and 
				(posa.z-0.05<=pos.z and pos.z<=posa.z+0.05) then
					efface = true
					adressecompose[c] = ""
					minetest.get_meta(possocle):set_string("adressecompose",minetest.serialize(adressecompose))					
					break
				end
			end
			
			if efface then
				self.object:remove()
				return
			else
				for c=1,table.getn(hudadresse.actif) do
					local listobj=minetest.get_objects_inside_radius({x=self.pos.x+hudadresse.actif[c].x*facedir[nodeparam2].x,y=self.pos.y+hudadresse.actif[c].y,z=self.pos.z+hudadresse.actif[c].z*facedir[nodeparam2].z},0.05)
					if table.getn(listobj)==0 then
						--Visuelle
						dhdspwan(pos,self.itemname,self.pos)
						self.object:moveto({x=self.pos.x+hudadresse.actif[c].x*facedir[nodeparam2].x,y=self.pos.y+hudadresse.actif[c].y,z=self.pos.z+hudadresse.actif[c].z*facedir[nodeparam2].z})
						--Code
						local adresse = minetest.deserialize(minetest.get_meta(possocle):get_string("adresse"))
						local serveuradresse = minetest.deserialize(minetest.get_meta(TELEPORT_SERVEUR):get_string("lesadresse"))
						local status=minetest.get_meta({x=self.pos.x,y=self.pos.y-1,z=self.pos.z}):get_int("status")
						
						adressecompose[c] = string.gsub(self.itemname, "wool:", "")
						minetest.get_meta(possocle):set_string("adressecompose",minetest.serialize(adressecompose))
						if not(adressecompose[1]=="") and not(adressecompose[2]=="") and not(adressecompose[3]=="") and not(adressecompose[4]=="") then
						--Sauvegarde l'adresse
							if status==0 and serveuradresse[""..adressecompose[1]..","..adressecompose[2]..","..adressecompose[3]..","..adressecompose[4]..""]==nil then
								--Engistre dans le socle
								adresse[1]=adressecompose[1]
								adresse[2]=adressecompose[2]
								adresse[3]=adressecompose[3]
								adresse[4]=adressecompose[4]
								minetest.get_meta(possocle):set_string("adresse",minetest.serialize(adresse))
								--Envoie au  serveur
								serveuradresse[""..adressecompose[1]..","..adressecompose[2]..","..adressecompose[3]..","..adressecompose[4]..""] = possocle
								minetest.get_meta(TELEPORT_SERVEUR):set_string("lesadresse",minetest.serialize(serveuradresse))
								--Suppression des pierre
								local listeobj=minetest.get_objects_inside_radius(self.pos, 0.80)
								for c=1,table.getn(listeobj) do
									if not(listeobj[c]:is_player()) then
										listeobj[c]:remove()
									end
								end	
								minetest.get_meta({x=self.pos.x,y=self.pos.y-1,z=self.pos.z}):set_int("status",1)
							elseif status>0 and not(adresse[1]=="" or adresse[2]=="" or adresse[3]=="" or adresse[4]=="") and not(serveuradresse[""..adressecompose[1]..","..adressecompose[2]..","..adressecompose[3]..","..adressecompose[4]..""]==nil) then
								--Si l'adresse est valide
								local possoclereception = serveuradresse[""..adressecompose[1]..","..adressecompose[2]..","..adressecompose[3]..","..adressecompose[4]..""]
								if not(adresse[1]==adressecompose[1] and adresse[2]==adressecompose[2] and adresse[3]==adressecompose[3] and adresse[4]==adressecompose[4]) then
									--Si les deux point sont pas les meme
									--Verifie que les portail sont pas occupé
									if actualisation(possocle) and actualisation(possoclereception) then
										local portailenvoie=minetest.deserialize(minetest.get_meta(possocle):get_string("portail"))
										local portailreception=minetest.deserialize(minetest.get_meta(possoclereception):get_string("portail"))
										--Portail d'envoie
										for c1=1,table.getn(portailenvoie) do
											minetest.add_node(portailenvoie[c1], {name="teleport:portailentree"})
											minetest.get_meta(portailenvoie[c1]):set_string("teleportation",minetest.serialize({x=possoclereception.x,y=possoclereception.y+1,z=possoclereception.z}))
										end
										--Portail de reception
										for c1=1,table.getn(portailreception) do
											minetest.add_node(portailreception[c1], {name="teleport:portailsortie"})
										end
										--Temp
										minetest.get_meta(possocle):set_int("enservice", os.time())
										minetest.get_meta(possoclereception):set_int("enservice", os.time())
										
										--Adresse bouger et la mémoire effacé
										bouger(hudadresse,false,self.pos,true)
										for c1=1,table.getn(hudadresse.actif) do	
											adressecompose[c] = ""
										end
										minetest.get_meta(possocle):set_string("adressecompose",minetest.serialize(adressecompose))
										
										-- Clavier rétracté
										bouger(hudclavier,false,self.pos)
										
										--Prix bouger
										bouger(hudprix,true,self.pos)
									end
								end	
								
							end
						end
						return
					end
				end
			end
		end
	end,
})

minetest.register_entity("teleport:prix", {
	initial_properties = {
		physical = false,
		collisionbox = {-0.15,-0.15,-0.15, 0.15,0.15,0.15},
		visual = "sprite",
		textures = {"default_mese_crystal_fragment.png"},
		visual_size = {x=0.4, y=0.4},
		is_visible = true,
	},
	pos = {},
	on_activate = function(self, staticdata)
		if string.sub(staticdata, 1, string.len("return")) == "return" then
			local data = minetest.deserialize(staticdata)
			if data and type(data) == "table" then
				self.pos = data
				if self.pos.y then
					if self.object:getpos().y<self.pos.y-0.1 then
						prop = {
							collisionbox = {-0.1,-0.1,-0.1, 0.1,0.1,0.1},
							visual_size = {x=0.13, y=0.13},
						}
					else
						prop = {
							collisionbox = {-0.15,-0.15,-0.15, 0.15,0.15,0.15},
							visual_size = {x=0.4, y=0.4},
						}
					end
					self.object:set_properties(prop)
				end
				self:set_item(minetest.serialize(self.pos))
			end	
		end
		self.object:set_armor_groups({immortal=1})
	end,
	set_item = function(self, itemstring)
		self.pos = minetest.deserialize(itemstring)
	end,
	get_staticdata = function(self)
		return minetest.serialize(self.pos)
	end,
	on_rightclick = function(self, hitter)
		local pos = self.object:getpos()
		local actif = minetest.deserialize(minetest.get_meta({x=self.pos.x,y=self.pos.y-1,z=self.pos.z}):get_string("actif"))
		if table.getn(minetest.get_objects_inside_radius(self.pos, 0.80))>=16 and 20>=table.getn(minetest.get_objects_inside_radius(self.pos, 0.80)) then
			if hitter:get_wielded_item():get_name()=="default:mese_crystal_fragment" and pos.y>self.pos.y-0.1 then	
				--Rétrécire et bouger "le prix"
				
				bouger(hudprix,false,self.pos)
				
				prop = {
					collisionbox = {-0.1,-0.1,-0.1, 0.1,0.1,0.1},
					visual_size = {x=0.13, y=0.13},
				}
				self.object:set_properties(prop)

				--initialise les cube en position "clavier"
				bouger(hudclavier,true,self.pos)
				hitter:get_inventory():remove_item("main", "default:mese_crystal_fragment")	
				
			elseif pos.y<self.pos.y-0.1 then
				bouger(hudclavier,false,self.pos)
				bouger(hudprix,true,self.pos)
				prop = {
					collisionbox = {-0.15,-0.15,-0.15, 0.15,0.15,0.15},
					visual_size = {x=0.4, y=0.4},
				}
				self.object:set_properties(prop)
				hitter:get_inventory():add_item("main", "default:mese_crystal_fragment")
			end
		end
	end,
})

minetest.register_entity("teleport:init", {
	initial_properties = {
		physical = false,
		collisionbox = {-0.15,-0.15,-0.15, 0.15,0.15,0.15},
		visual = "sprite",
		textures = {"wool_white.png"},
		visual_size = {x=0.4, y=0.4},
		is_visible = true,
	},
	pos = {},
	on_activate = function(self, staticdata)
		if string.sub(staticdata, 1, string.len("return")) == "return" then
			local data = minetest.deserialize(staticdata)
			if data and type(data) == "table" then
				self.pos = data
				self:set_item(minetest.serialize(self.pos))
			end	
		end
		self.object:set_armor_groups({immortal=1})
	end,
	set_item = function(self, itemstring)
		self.pos = minetest.deserialize(itemstring)
	end,
	get_staticdata = function(self)
		return minetest.serialize(self.pos)
	end,
	on_rightclick = function(self, hitter)
		--init 
		posdhd={x=self.pos.x,y=self.pos.y-1,z=self.pos.z}
		local prb = false
		--trouver le socle
		local socle = minetest.find_nodes_in_area({x=posdhd.x-15,y=posdhd.y-15,z=posdhd.z-15},{x=posdhd.x+15,y=posdhd.y+15,z=posdhd.z+15},"teleport:socle" )
		if socle==nil then
			minetest.chat_send_player(hitter:get_player_name(), "Le socle na pas etait trouve !")
			prb = true
		else
			socle=socle[1]
			minetest.get_meta(posdhd):set_string("socle",minetest.serialize(socle))
		end
		--Regarde si y a déja un dhd
		local mposdhd=minetest.deserialize(minetest.get_meta(socle):get_string("posdhd"))
		if not(prb) and mposdhd==nil then			
			minetest.get_meta(socle):set_string("posdhd",minetest.serialize(posdhd))
		else
			minetest.chat_send_player(hitter:get_player_name(), "Il y a deja un Dhd en place !")
			prb = true
		end
		
		--Trouver les portail
		local portail=minetest.deserialize(minetest.get_meta(socle):get_string("portail"))
		if not(prb) and portail==nil then
			local lesportail=minetest.find_nodes_in_area({x=socle.x-15,y=socle.y-15,z=socle.z-15},{x=socle.x+15,y=socle.y+15,z=socle.z+15},"teleport:portail" )
			if table.getn(lesportail)>=1 then
				minetest.get_meta(socle):set_string("portail",minetest.serialize(lesportail))
				for c=1,table.getn(lesportail) do
					minetest.remove_node(lesportail[c])
				end
			else
				minetest.chat_send_player(hitter:get_player_name(), "Les portails ne sont pas dans la zone ou y en a aucun.")
				prb = true
			end
		end

		if not(prb) then
			local nodeparam2 = minetest.get_node({x=self.pos.x,y=self.pos.y-1,z=self.pos.z}).param2+1
			self.object:remove()
			--Vérifier si y a une adresse
			local adresse=minetest.deserialize(minetest.get_meta(socle):get_string("adresse"))
			if adresse[1]=="" and adresse[2]=="" and adresse[3]=="" and adresse[4]=="" then
				for c=1,table.getn(couleurs) do
					dhdspwan({x=self.pos.x+hudclavier.actif[c].x*facedir[nodeparam2].x,y=self.pos.y+hudclavier.actif[c].y,z=self.pos.z+hudclavier.actif[c].z*facedir[nodeparam2].z},"wool:"..couleurs[c].."",self.pos)
				end
			else
				minetest.get_meta({x=self.pos.x,y=self.pos.y-1,z=self.pos.z}):set_int("status",1)
			end
		end
	end,
})
