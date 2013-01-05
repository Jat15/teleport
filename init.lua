--[[
Teleport V0.1 par Jat
Licence GPLv2 or later for code
Licence CC-BY-SA for image

--]]
--Variable utilisé
local a=0
--Pierre
--[[
minetest.register_node("teleport:pierre", {
	description = "Torch Wall",
	drawtype = "nodebox",
	tiles = {
		"teleport_icone_blue.png",
		"teleport_icone_blue.png",
		"teleport_icone_blue.png",
		"teleport_icone_blue.png",
		"teleport_icone_blue.png",
		"teleport_icone_blue.png",},
	
	paramtype = 'light',
	paramtype2 = "facedir",
		node_box = {
		type = "fixed",
		fixed = {
			--base
			{-0.1,-0.5,-0.4, 0.1,-0.4,0.4},
			{-0.2,-0.5,-0.3, 0.2,-0.4,0.3},
			{-0.3,-0.5,-0.2, 0.3,-0.4,0.2},
			--2
			{-0.05,-0.4,-0.35, 0.05,-0.3,0.35},
			{-0.15,-0.4,-0.25, 0.15,-0.3,0.25},
			{-0.25,-0.4,-0.15, 0.25,-0.3,0.15},
			
		},
	},
	sunlight_propagates = true,
	walkable = true,
	--selection_box = {
	--	type = "fixed",
	--	fixed = {-0.15, -0.45, 0.15, 0.15, 0.35, 0.5},
	--	},
	groups = {cracky=2}
	
})
--]]
--Teleport

--Terminal
minetest.register_node("teleport:teleporta", {
	description = "Marche",
	tiles = {"teleport_teleporta.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
    diggable = false,
})
minetest.register_node("teleport:teleportb", {
	description = "Marche",
	tiles = {"teleport_teleportb.png"},
    is_ground_content = false,
    walkable = true,
    pointable = true,
    diggable = false,
})


--Icone
local marchandlist={"true","false","black","blue","cyan","green","grey","magenta","orange","pink","red","yellow","white"}

for a=1,table.getn(marchandlist) do
	minetest.register_node("teleport:icone_"..marchandlist[a].."", {
		description = "",
		tiles = {"teleport_icone_"..marchandlist[a]..".png"},
		is_ground_content = false,
		walkable = true,
		pointable = true,
		diggable = false,
	})
end


--Alias
minetest.register_alias("teleport", "teleport:teleporta")

--Function a modifier pour faire un mod
local function menu(marchand,p,node)
	local a=0
	local i=0
	for i = 1,table.getn(marchand)-1 do 
		for a = 1,table.getn(marchand[i]) do 
			if marchand[i][a]=="O" then
				if node.name==marchand[table.getn(marchand)][2] then
					minetest.env:add_node(p, {name=marchand[table.getn(marchand)][1]})
				else
					minetest.env:add_node(p, {name=marchand[table.getn(marchand)][2]})
				end
				p.x=p.x-a
				p.y=p.y+i
				break
			end
		end
	end
	for i = 1,table.getn(marchand)-1 do 
		for a = 1,table.getn(marchand[i]) do 
			if not(marchand[i][a]=="O") and not(marchand[i][a]=="") and node.name==marchand[table.getn(marchand)][2] then
				minetest.env:remove_node({x=p.x+a, y=p.y-i, z=p.z})
			elseif not(marchand[i][a]=="O") and not(marchand[i][a]=="") then
				minetest.env:add_node({x=p.x+a, y=p.y-i, z=p.z}, {name=""..marchand[i][a]..""})
			end
		end
	end
end

--Ecrire le fichier
fichier = {}
local write_gofile = function() 
	local output = ''						--	WRITE CHANGES TO FILE
	for name, coords in pairs(fichier) do 	output = output..name..':'..coords.x..','..coords.y..','..coords.z..';'	end
	local f = io.open(minetest.get_worldpath()..'/teleport.jat', "w")
    f:write(output)
    io.close(f)
end

local gonfile = io.open(minetest.get_worldpath()..'/teleport.jat', "r")  
if gonfile then
	local contents = gonfile:read()
	io.close(gonfile)
	if contents ~= nil then 
		local entries = contents:split(";") 
		for i,entry in pairs(entries) do
			local goname, coords = unpack(entry:split(":"))
			local p = {}
			p.x, p.y, p.z = string.match(coords, "^([%d.-]+)[, ] *([%d.-]+)[, ] *([%d.-]+)$")
			if p.x and p.y and p.z then
				fichier[goname] = {x = tonumber(p.x),y= tonumber(p.y),z = tonumber(p.z)}
			end
		end
	end
end

--Chatcommand
minetest.register_chatcommand("setteleport", {
	params = "<name>",
	description = "set /go destination",
	privs = {server=true},
	func = function(name, param)
		local target = minetest.env:get_player_by_name(name)
		if target then
			fichier[param] = target:getpos()
			write_gofile()
			minetest.chat_send_player(name, "teleport "..param.." set")
			return
		end
	end,
})

minetest.register_chatcommand("delteleport", {
	params = "<name>",
	description = "delete /go destination",
	privs = {server=true},
	func = function(name, param)
		if fichier[param] then 
			fichier[param] = nil
			write_gofile()
		end
	end,
})
minetest.register_chatcommand("listteleport", {
	params = "<goname>",
	description = "list all go destinations",
	privs = {server=true},
	func = function(name, param)
		for go, coords in pairs(fichier) do minetest.chat_send_player(name, "/go "..go.. ' at '..coords.x..','..coords.y..','..coords.z) end		
	end,
})

minetest.register_on_punchnode(function(p, node, player)
	--Teleporteur
		--Menu
	if node.name=="teleport:teleporta" or node.name=="teleport:teleportb" then
		--Toujour prendre la plus grand largeur pour chaque ligne (sauf la dernier ) et le "O" est le cube d'origine et la dernier ligne le cube "on" "off"
		menu({{"","teleport:icone_"..marchandlist[6].."","teleport:icone_"..marchandlist[7].."","teleport:icone_"..marchandlist[8].."","teleport:icone_"..marchandlist[9].."",""},
			{"teleport:icone_"..marchandlist[5].."","","teleport:icone_"..marchandlist[1].."","teleport:icone_"..marchandlist[2].."","","teleport:icone_"..marchandlist[10]..""},
			{"teleport:icone_"..marchandlist[4].."","","air","air","","teleport:icone_"..marchandlist[11]..""},
			{"teleport:icone_"..marchandlist[3].."","O","air","air","teleport:icone_"..marchandlist[13].."","teleport:icone_"..marchandlist[12]..""},
			{"teleport:teleporta","teleport:teleportb"}},p,node)
	end	

	--Interface
	for a=1,table.getn(marchandlist) do
		if node.name=="teleport:icone_"..marchandlist[a].."" then
			--Efface la selection
			if node.name=="teleport:icone_"..marchandlist[2].."" then
				minetest.env:remove_node({x=p.x, y=p.y-1, z=p.z})
				minetest.env:remove_node({x=p.x, y=p.y-2, z=p.z})
				minetest.env:remove_node({x=p.x-1, y=p.y-1, z=p.z})
				minetest.env:remove_node({x=p.x-1, y=p.y-2, z=p.z})
			elseif node.name=="teleport:icone_"..marchandlist[1].."" then
				local couleur={"","","",""}
				local i=0
				p.y=p.y-1
				node=minetest.env:get_node(p)
				couleur[1]=node.name
				p.x=p.x+1
				node=minetest.env:get_node(p)
				couleur[2]=node.name
				p.y=p.y-1
				p.x=p.x-1
				node=minetest.env:get_node(p)
				couleur[3]=node.name
				p.x=p.x+1
				node=minetest.env:get_node(p)
				couleur[4]=node.name
				for i=1,4 do
					couleur[i]=string.gsub(couleur[i], "teleport:icone_", "") 
				end
				if fichier[string.format("%s,%s,%s,%s", couleur[1], couleur[2], couleur[3], couleur[4])] == nil then return end
				minetest.env:remove_node({x=p.x, y=p.y, z=p.z})
				minetest.env:remove_node({x=p.x, y=p.y+1, z=p.z})
				minetest.env:remove_node({x=p.x-1, y=p.y, z=p.z})
				minetest.env:remove_node({x=p.x-1, y=p.y+1, z=p.z})
				player:setpos(fichier[string.format("%s,%s,%s,%s", couleur[1], couleur[2], couleur[3], couleur[4])])
			else
				local b=0
				local i=0
				local marchand={{"","teleport:icone_"..marchandlist[6].."","teleport:icone_"..marchandlist[7].."","teleport:icone_"..marchandlist[8].."","teleport:icone_"..marchandlist[9].."",""},
					{"teleport:icone_"..marchandlist[5].."","","teleport:icone_"..marchandlist[1].."","teleport:icone_"..marchandlist[2].."","","teleport:icone_"..marchandlist[10]..""},
					{"teleport:icone_"..marchandlist[4].."","","O","air","","teleport:icone_"..marchandlist[11]..""},
					{"teleport:icone_"..marchandlist[3].."","","air","air","teleport:icone_"..marchandlist[13].."","teleport:icone_"..marchandlist[12]..""}}
				for i = 1,table.getn(marchand) do 
					for b = 1,table.getn(marchand[i]) do 
						if marchand[i][b]=="teleport:icone_"..marchandlist[a].."" then
							p.x=p.x+(3-b)
							p.y=p.y-(3-i)
							break
						end			
					end
				end
				local c=0
				node=minetest.env:get_node(p)
				if node.name=="air" and c==0 then
					minetest.env:add_node(p, {name="teleport:icone_"..marchandlist[a]..""})
					c=1
				end
				
				p.x=p.x+1
				node=minetest.env:get_node(p)
				
				if node.name=="air" and c==0 then
					minetest.env:add_node(p, {name="teleport:icone_"..marchandlist[a]..""})
					c=2
				end
				
				p.x=p.x-1
				p.y=p.y-1
				node=minetest.env:get_node(p)
				
				if node.name=="air" and c==0 then
					minetest.env:add_node(p, {name="teleport:icone_"..marchandlist[a]..""})
					c=3
				end
				
				p.x=p.x+1
				node=minetest.env:get_node(p)
					
				if node.name=="air" and c==0 then
					minetest.env:add_node(p, {name="teleport:icone_"..marchandlist[a]..""})
					c=4
				end
			end
			break
		end
	end
		

end)



