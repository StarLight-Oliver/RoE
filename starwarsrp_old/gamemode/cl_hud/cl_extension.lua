
function GetScreenRatio()
	local h, w = ScrH(),ScrW()
	if (h * (4 / 3)) == w then
		return 1
	elseif h * (16 / 9) == w then
		return 2
	elseif h * (1 + ((1 / 3 ) * 2)) == w then
		return 3
	else
		return false
	end
end

function playopensound(sound)
local d = vgui.Create("DFrame")
	d:SetSize(1,1)
	d:SetTitle("")
	d:SetDraggable(false)
	d:SetPos(0,0)
	d:ShowCloseButton(false)
	d.Paint = function(self,w,h)
		if !self.NextPlay then self.NextPlay = CurTime() - 1 end
		if self.NextPlay < CurTime() then
			surface.PlaySound( sound )
			self.NextPlay = CurTime() + 10
		end
	end
	timer.Simple(5, function()
		d:Remove()
	end)

end

function GetHTMLScript(URL)
		//Get ID
		local temp = string.Explode("/",URL)
		temp = string.Explode("v=",temp[#temp])
		temp = string.Explode("?",temp[#temp])
		local ID = temp[1]

		return [[
		<!DOCTYPE html>
		<html>
		  <body style="border: 0px;">
			<!-- 1. The <iframe> (and video player) will replace this <div> tag. -->

			<iframe id="player" type="text/html"
			src="http://www.youtube.com/embed/]]..ID..[[?enablejsapi=1"
			style="border: 2; position:fixed; top:0; left:0; right:0; bottom:0; width:100%; height:100%"
			frameborder="0"></iframe>


			<script>
			  // 2. This code loads the IFrame Player API code asynchronously.
			  var tag = document.createElement('script');

			  tag.src = "https://www.youtube.com/iframe_api";
			  var firstScriptTag = document.getElementsByTagName('script')[0];
			  firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

			  // 3. This function creates an <iframe> (and YouTube player)
			  //    after the API code downloads.
			  var player;
			  function onYouTubeIframeAPIReady() {
				player = new YT.Player('player', {
				  videoId: ']]..ID..[[',
				  events: {
					'onReady': onPlayerReady,
					'onStateChange': onPlayerStateChange
				  }
				});
			  }

			  // 4. The API will call this function when the video player is ready.
			  function onPlayerReady(event) {
				event.target.playVideo();
			  }

			  function onPlayerStateChange(event) {
			  }

			  function stopVideo() {
				player.stopVideo();
			  }
			</script>
		  </body>
		</html>]]
end
local cos, sin, floor, clamp, deg2rad, insert = math.cos, math.sin, math.floor, math.Clamp, math.rad, table.insert
function GeneratePartialPie(x, y, ang1, ang2, rad, thick, prec)
	prec = clamp(prec or 256, 6, 512)

	local vertices = {}
	local ang, dist
	local quality = floor(prec / 2)

	dist = rad
	for i = 1, quality do
		ang = deg2rad(ang1 + (ang2 - ang1) * i / quality)
		insert(vertices, {x = cos(ang) * dist + x, y = sin(ang) * dist + y})
	end

	dist = rad + thick
	for i = 0, quality - 1 do
		ang = deg2rad(ang1 + (ang2 - ang1) * (quality - i) / quality)
		insert(vertices, {x = cos(ang) * dist + x, y = sin(ang) * dist + y})
	end

	return vertices
end

function GeneratePieSlice(x, y, ang1, ang2, rad, prec)
	prec = clamp(prec or 256, 4, 1024)

	local vertices = {}
	local ang
	local quality = prec - 1

	insert(vertices, {x = x, y = y})

	for i = 1, quality do
		ang = deg2rad(ang1 + (ang2 - ang1) * i / quality)
		insert(vertices, {x = cos(ang) * rad + x, y = sin(ang) * rad + y})
	end

	return vertices
end
local mat = Material("star/cw/basehexagons.png")
function draw.bar(x,y, ang1, ang2, size, width, ang3, ang4, off)
	if !off then off = 0 end
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 1 )
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilFailOperation( STENCILOPERATION_INCR )
	render.SetStencilPassOperation( STENCILOPERATION_INCR )
	render.SetStencilZFailOperation( STENCILOPERATION_DECR )

	surface.DrawPoly(GeneratePieSlice(x, y, ang1, ang2, size + width) )

	render.SetStencilPassOperation( STENCILOPERATION_DECR )
	surface.DrawPoly(GeneratePieSlice(x, y, ang1, ang2, size) )


	render.SetStencilReferenceValue( 1 )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )

	--surface.DrawPoly(GeneratePieSlice(x, y, ang1, ang2, size + width) )
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(x - size - width,y - size - width, size+width+size+width, size+width+size+width)
	render.SetStencilEnable( false )

	surface.SetDrawColor(0, 0, 0, 255)

	local t = GeneratePartialPie(x, y, ang3 + off, ang4 + off, size, width, 256)
	insert(t, t[1])

	local oldshiz
	for _i, shiz in pairs(t) do
		if _i > 1 then

			surface.DrawLine(oldshiz.x, oldshiz.y, shiz.x, shiz.y)
		end
		oldshiz = shiz
	end
end


function draw.bar2(x,y, ang1, ang2, size, width, ang3, ang4, off)
	if !off then off = 0 end
	render.ClearStencil()
	render.SetStencilEnable( true )
	render.SetStencilReferenceValue( 1 )
	render.SetStencilCompareFunction(STENCILCOMPARISONFUNCTION_NEVER)
	render.SetStencilFailOperation( STENCILOPERATION_INCR )
	render.SetStencilPassOperation( STENCILOPERATION_INCR )
	render.SetStencilZFailOperation( STENCILOPERATION_DECR )

	surface.DrawPoly(GeneratePieSlice(x, y, ang1, ang2, size + width) )

	render.SetStencilPassOperation( STENCILOPERATION_DECR )
	surface.DrawPoly(GeneratePieSlice(x, y, ang1, ang2, size) )


	render.SetStencilReferenceValue( 1 )
	render.SetStencilCompareFunction( STENCILCOMPARISONFUNCTION_EQUAL )

	--surface.DrawPoly(GeneratePieSlice(x, y, ang1, ang2, size + width) )
	surface.SetMaterial(mat)
	surface.DrawTexturedRect(x - size - width,y - size - width, size+width+size+width, size+width+size+width)
	render.SetStencilEnable( false )

end

GRADIENT_HORIZONTAL = 0
GRADIENT_VERTICAL = 1
function draw.LinearGradient(x,y,w,h,from,to,dir,res)
	dir = dir or GRADIENT_HORIZONTAL
	if dir == GRADIENT_HORIZONTAL then res = (res and res <= w) and res or w
	elseif dir == GRADIENT_VERTICAL then res = (res and res <= h) and res or h end
	for i=1,res do
		surface.SetDrawColor(
			Lerp(i/res,from.r,to.r),
			Lerp(i/res,from.g,to.g),
			Lerp(i/res,from.b,to.b),
			Lerp(i/res,from.a,to.a)
		)
		if dir == GRADIENT_HORIZONTAL then surface.DrawRect(x + w * (i/res), y, w/res, h )
		elseif dir == GRADIENT_VERTICAL then surface.DrawRect(x, y + h * (i/res), w, h/res ) end
	end
end

function CenterBar(SlotNum,SlotMax,SlotSize)
    return -SlotMax * SlotSize / 2 + SlotNum * SlotSize
end
