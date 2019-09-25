
if SERVER then
	util.AddNetworkString("defcon_send")
	util.AddNetworkString("defcon_request")
	
	net.Receive("defcon_request", function(len, ply)
		SendDefcon(ply)
	end)
	
	function SendDefcon(ply)
		net.Start("defcon_send")
			net.WriteDouble(defconget())
		if ply then
			net.Send(ply)
		else
			net.Broadcast()
		end
	end

	function SetDefcon(num)
		defcon = num
		SendDefcon()
	end
else
	net.Receive("defcon_send", function()
		defcon = net.ReadDouble()
	end)

end

function defconget()
	if SERVER then
		return defcon || 5
	else
		if !defcon then 
			net.Start("defcon_request")
			net.SendToServer()
			return 5
		else
			return defcon
		end
	end
end