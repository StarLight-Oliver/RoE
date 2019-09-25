-- Define the Emotes
EMOTE_HEALTH = 1
EMOTE_SCOUT = 2
EMOTE_AMMO = 3
EMOTE_ENEMY = 4

EMOTE_Info = {
	{
		mat = "star/cw/emotes/medic.png",
		sound = Sound("needhealth.mp3"),
		dietime = 10,
		basecol = Color(255,0,0,255),
		fadeto = Color(150,0,0,0)
	}, {
		mat = "doctor/emotes/scout2.png",
		dietime = 30,
		sound = Sound("needammo.mp3"),
		basecol = Color(200, 200,200,255),
		size = 512,
		fadeto = Color(100,100,100,0)
	}, {
		mat = "doctor/emotes/ammo.png",
		sound = Sound("needammo.mp3"),
		dietime = 7,
		basecol = Color(255,255,255,255),
		fadeto = Color(255,255,255,0)
	}, {
		mat = "doctor/emotes/target_spotted.png",
		dietime = 30,
		basecol = Color(255,255,255,255),
		size = 512,
		fadeto = Color(255,255,255,0)
	},
}

if SERVER then
	util.AddNetworkString("emote_send")
	
	function net_SendEmote(ent, enum, ply)
		if !ply then
			ply = ent
		end
				
		if EMOTE_Info[enum] then
			log(ply, "I have just used **" .. string.Replace(EMOTE_Info[enum].mat, "star/cw/emotes/", "") .. "** on thing **" .. ent:GetClass() .. "** !")
			if EMOTE_Info[enum].sound then
				ent:EmitSound(EMOTE_Info[enum].sound)
			end
			net.Start("emote_send")
				net.WriteEntity(ent)
				net.WriteDouble(enum)
			net.Broadcast()
		end
	end

else
	EMOTES = {}
	
	net.Receive("emote_send", function()
		local ent = net.ReadEntity()
		local num = net.ReadDouble()
		EMOTES[CurTime()] = {
			ent = ent,
			dietime = EMOTE_Info[num].dietime + CurTime(),
			num = num,
		}
	end)


end

