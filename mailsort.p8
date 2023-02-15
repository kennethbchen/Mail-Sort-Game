pico-8 cartridge // http://www.pico-8.com
version 41
__lua__
-- mailsort


-- board dimensions
rows=2
cols=3

max_time=15

function _init()
	
	state="menu"
	
	-- game state
	x=0
	y=0
	
	score=0
	
	start_time=time()
	
	current_letter={}
	
	-- countdown state
	last_second = flr(time())
	countdown = 3
	
end

function restart_game()
	_init()
	
	-- draw over letter stamp
	mset(7,12,36)
	mset(8,12,36)
	mset(7,13,36)
	mset(8,13,36)
	
	state="countdown"
end
-->8
-- draws

function _draw()

	if state=="menu" then
		draw_menu()
	elseif state=="countdown" then
		draw_countdown()
	elseif state=="game" then
		draw_game()
	elseif state=="gameover" then
		draw_game_over()
	end
						
end
-->8
-- updates

function _update()

	if state=="menu" then
		update_menu()
	elseif state=="countdown" then
		update_countdown()
	elseif state=="game" then
		update_game()
	elseif state=="gameover" then
		update_game_over()
	end
		
end


-->8
-- game state
function draw_game()
	cls(1)
		map()
		
		-- draw cursor
		xoffset = x * 32
		yoffset = y * 32
		rect(
			16+xoffset,
			16+yoffset,
			47+xoffset,
			47+yoffset,
			10)
		
		print("score: " .. 
										score ..
										"\n", 0,0,7)
		
		-- draw score and time
		local time_left = flr(max_time+1 -
										(time() - start_time))
		if (game_over) time_left=0
		
			print("\ntime: " ..
										time_left,
										0,0,7)


end

function update_game()
	
	-- aim
	if (btnp(⬅️)) x-=1
	if (btnp(➡️)) x+=1
	if (btnp(⬆️)) y-=1
	if (btnp(⬇️)) y+=1
	
	if (x<0) x=cols-1
	if (x>cols-1) x=0
	
	if (y<0) y=rows-1
	if (y>rows-1) y=0
	
	-- throw letter
	if (btnp(🅾️)) then
		if current_letter.x == x and
					current_letter.y == y then
		-- correct
		score += 1
		sfx(0)
		else
		-- incorrect
		score -= 1
		sfx(1)
		end
		
		randomize_letter()
		
	end
			-- check timer
	
		if max_time - (time() - start_time) < 0 then
			sfx(2)
			
			state="gameover"
		end

end

function randomize_letter()
	current_letter=
		{
			x=flr(rnd(cols)), 
			y=flr(rnd(rows))
		}
	
	-- draw letter stamp
	-- tl corner on map = 7,12
	-- tl sprite index = 64
	local offset = 
		(current_letter.x*2) + 
			current_letter.y*32
					
	mset(7,12,64+offset)
	mset(8,12,65+offset)
	mset(7,13,80+offset)
	mset(8,13,81+offset)							
end
-->8
-- game over state

function draw_game_over()
 cls(1)
 map()
 
 rectfill(17,24,110,64,13)
 
 local time_text = "time up!"
 local score_text = "score: " .. score
	local retry_text = "press ❎ to restart"
	
	print(time_text, hcenter(time_text), 32, 7)
	print(score_text, hcenter(score_text), 40, 7)
	print(retry_text, hcenter(retry_text), 48, 7)

end

function update_game_over()
	if (btnp(❎)) then
		restart_game()
	end
end
-->8
-- menu state

function draw_menu()
	cls(1)
	
	-- draw logo
	spr(70, 48, 16, 4, 4)
	
	local t1_text = "sort letters by"
	local t2_text = "matching symbols!"
	local sel_text = "➡️⬅️⬆️⬇️ - move"
	local sort_text = "🅾️ - sort"
	local play_text = "press 🅾️ to play"

	print(t1_text, hcenter(t1_text), 64, 7)						
	print(t2_text, hcenter(t2_text), 70, 7)						
	
	print(sel_text,  32, 84, 7)
	print(sort_text, hcenter(sort_text), 92, 7)
	print(play_text, hcenter(play_text), 112, 7)

end

-- update menu

function update_menu()
	if (btnp(🅾️)) then
		restart_game()
	end
end
-->8
-- countdown state

function draw_countdown()
	cls(1)
	map()
	
	-- draw cursor
		xoffset = x * 32
		yoffset = y * 32
		rect(
			16+xoffset,
			16+yoffset,
			47+xoffset,
			47+yoffset,
			10)
			
		print(countdown, hcenter("a"),8,7)
end

function update_countdown()
		
		-- true once every second
		if flr(time()-last_second) != 0 then
			
			if (countdown>0)	sfx(3)
			last_second = flr(time())
			
			countdown-=1
		end
		
		if countdown<0 then
			sfx(4)
		 _init()
		 randomize_letter()
			state="game"
		end
end
-->8
-- utils

-- https://pico-8.fandom.com/wiki/centering_text
function hcenter(s)
  -- screen center minus the
  -- string length times the 
  -- pixels in a char's width,
  -- cut in half
  return 64-#s*2
end
__gfx__
00000000444444444444444444444444455555555555555555555555555555540000000000000000000000000000000000000000000000000000000000000000
00000000455555555555555555555554455555777777777777777755555555540000000000000000000000000000000000000000000000000000000000000000
00600600455555555555555555555554455555666666666666666655555555540000000000000000000000000000000000000000000000000000000000000000
00000000455555555555555555555554455555555577777777777777775555540000000000000000000000000000000000000000000000000000000000000000
06000060455555555555555555555554455555555566666666666666665555540000000000000000000000000000000000000000000000000000000000000000
00666600455555555555555555555554455555577777777777777777555555540000000000000000000000000000000000000000000000000000000000000000
00000000455555555555555555555554455555566666666666666666555555540000000000000000000000000000000000000000000000000000000000000000
00000000455555555555555555555554444444444444444444444444444444440000000000000000000000000000000000000000000000000000000000000000
00000000455555550000000055555554577777777777777744444444444444440000000000000000000000000000000000000000000000000000000000000000
00000000455555550000000055555554757777777777777744444444444444440000000000000000000000000000000000000000000000000000000000000000
00000000455555550000000055555554775777777777777755555555555555550000000000000000000000000000000000000000000000000000000000000000
00000000455555550000000055555554777577777777777755555555555555550000000000000000000000000000000000000000000000000000000000000000
00000000455555550000000055555554777757777777777744444444dddddddd0000000000000000000000000000000000000000000000000000000000000000
00000000455555550000000055555554777775777777777744444444dddddddd0000000000000000000000000000000000000000000000000000000000000000
00000000455555550000000055555554777777555555555555555555444444440000000000000000000000000000000000000000000000000000000000000000
00000000455555550000000055555554777777777777777755555555444444440000000000000000000000000000000000000000000000000000000000000000
00000000455555555555555555555554777777777777777555555555444444440000000000000000000000000000000000000000000000000000000000000000
00000000455555555555555555555554777777777777775755555555444444440000000000000000000000000000000000000000000000000000000000000000
00000000455555555555555555555554777777777777757755555555444444440000000000000000000000000000000000000000000000000000000000000000
00000000455555555555555555555554777777777777577755555555444444440000000000000000000000000000000000000000000000000000000000000000
00000000455555555555555555555554777777777775777755555555444444440000000000000000000000000000000000000000000000000000000000000000
00000000455555555555555555555554777777777757777755555555444444440000000000000000000000000000000000000000000000000000000000000000
00000000455555555555555555555554777777775577777755555555444444440000000000000000000000000000000000000000000000000000000000000000
00000000444444444444444444444444777777777777777755555555444444440000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888888888889999999999999999cccccccccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
87777777777777789777777777777779c77777777777777c00000000000000000000000000000000000000000000000000000000000000000000000000000000
87777788877777789777777997777779c7777ccc7777777c00077700077700000000000000007000000000000000000000000000000000000000000000000000
87777888777777789777777997777779c777cc77c7c7777c00700077700070000000000000007000000000000000000000000000000000000000000000000000
87777887787777789777997777997779c777cc77c777777c07000007000007000000000000007000000000000000000000000000000000000000000000000000
87777888778777789777977997797779c777cccccc77777c07000007000007000000000070007000000000000000000000000000000000000000000000000000
87777788878777789777779999777779c7777cccc7c7777c07000007000007000000000000007000000000000000000000000000000000000000000000000000
87777788888777789799799999979979c7777cccccc7777c07000007000007000000000000007000000000000000000000000000000000000000000000000000
87777887888777789799799999979979c777cc7ccc77777c07000007000007007777700070007000000000000000000000000000000000000000000000000000
87778887788777789777779999777779c777cccc777c777c07000007000007000000700070007000000000000000000000000000000000000000000000000000
87778877778877789777977997797779c7777cc77777777c07000007000007007777700070007000000000000000000000000000000000000000000000000000
87778877778877789777997777997779c77c777cc777777c07000007000007007000700070007000000000000000000000000000000000000000000000000000
87778877778877789777777997777779c77777cc7c77777c07000007000007007777700070007000000000000000000000000000000000000000000000000000
87778887788877789777777997777779c77777cccc77777c00000000000000000000000000000000000000000000000000000000000000000000000000000000
87777888888777789777777777777779c777777cc777777c00000000000000000000000000000000000000000000000000000000000000000000000000000000
88888888888888889999999999999999cccccccccccccccc00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbddddddddddddddddeeeeeeeeeeeeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000
b77777777777777bd77777777777777de77777777777777e00000000000000000000000000000000000000000000000000000000000000000000000000000000
b7777777bb77777bd77777dddd77777de77777777777777e00077700000000000000000000007000000000000000000000000000000000000000000000000000
b77bb777b777777bd777dd7ddddd777de77777777777777e00700000000000000000000000007000000000000000000000000000000000000000000000000000
b7777b77b7bbb77bd77d77777dddd77de77777777777777e07000000000000000000000000007000000000000000000000000000000000000000000000000000
b77777bbbb77777bd77d777777ddd77de77777777777777e07000000000000000000000000777770000000000000000000000000000000000000000000000000
b777777bb77bb77bd7d77777777ddd7de7777777e7777e7e07000000000000000000000000007000000000000000000000000000000000000000000000000000
b77bbb7bbbb7777bd7d77777777ddd7de7777777ee77ee7e00700000000777000007000000007000000000000000000000000000000000000000000000000000
b7777bbbbb77777bd7d77777777ddd7de77eee77eeeeee7e00077000007000700007077770007000000000000000000000000000000000000000000000000000
b7777777bb77777bd7d77777777ddd7de77e7e77ee7e7e7e00000700070000070007700000007000000000000000000000000000000000000000000000000000
b777777bbb77777bd77d777777ddd77de77e7777eeeeee7e00000700070000070007000000007000000000000000000000000000000000000000000000000000
b777777bb777777bd77d77777dddd77de77eeeeeeeeee77e00000700070000070007000000007000000000000000000000000000000000000000000000000000
b777777bb777777bd777dd7ddddd777de77eeeeeeee7777e00007000007000700007000000007000000000000000000000000000000000000000000000000000
b77777bbbb77777bd77777dddd77777de77eeeeeeee7777e07770000000777000007000000007000000000000000000000000000000000000000000000000000
b7777bbbbbb7777bd77777777777777de77eeeeeeeee777e00000000000000000000000000000000000000000000000000000000000000000000000000000000
bbbbbbbbbbbbbbbbddddddddddddddddeeeeeeeeeeeeeeee00000000000000000000000000000000000000000000000000000000000000000000000000000000
__label__
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
4444444444444444aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa44444444444444444444444444444444444444444444444444444444444444444444444444444444
4444444444444444a555555555555555555555555555555a45555555555555555555555555555554455555555555555555555555555555544444444444444444
5555555555555555a555555555555555555555555555555a45555555555555555555555555555554455555555555555555555555555555545555555555555555
5555555555555555a555555555555555555555555555555a45555555555555555555555555555554455555555555555555555555555555545555555555555555
4444444444444444a555555555555555555555555555555a45555555555555555555555555555554455555555555555555555555555555544444444444444444
4444444444444444a555555555555555555555555555555a45555555555555555555555555555554455555555555555555555555555555544444444444444444
5555555555555555a555555555555555555555555555555a45555555555555555555555555555554455555555555555555555555555555545555555555555555
5555555555555555a555555555555555555555555555555a45555555555555555555555555555554455555555555555555555555555555545555555555555555
4444444444444444a555555588888888888888885555555a4555555599999999999999995555555445555555cccccccccccccccc555555544444444444444444
4444444444444444a555555587777777777777785555555a4555555597777777777777795555555445555555c77777777777777c555555544444444444444444
5555555555555555a555555587777788877777785555555a4555555597777779977777795555555445555555c7777ccc7777777c555555545555555555555555
5555555555555555a555555587777888777777785555555a4555555597777779977777795555555445555555c777cc77c7c7777c555555545555555555555555
4444444444444444a555555587777887787777785555555a4555555597779977779977795555555445555555c777cc77c777777c555555544444444444444444
4444444444444444a555555587777888778777785555555a4555555597779779977977795555555445555555c777cccccc77777c555555544444444444444444
5555555555555555a555555587777788878777785555555a4555555597777799997777795555555445555555c7777cccc7c7777c555555545555555555555555
5555555555555555a555555587777788888777785555555a4555555597997999999799795555555445555555c7777cccccc7777c555555545555555555555555
4444444444444444a555555587777887888777785555555a4555555597997999999799795555555445555555c777cc7ccc77777c555555544444444444444444
4444444444444444a555555587778887788777785555555a4555555597777799997777795555555445555555c777cccc777c777c555555544444444444444444
5555555555555555a555555587778877778877785555555a4555555597779779977977795555555445555555c7777cc77777777c555555545555555555555555
5555555555555555a555555587778877778877785555555a4555555597779977779977795555555445555555c77c777cc777777c555555545555555555555555
4444444444444444a555555587778877778877785555555a4555555597777779977777795555555445555555c77777cc7c77777c555555544444444444444444
4444444444444444a555555587778887788877785555555a4555555597777779977777795555555445555555c77777cccc77777c555555544444444444444444
5555555555555555a555555587777888888777785555555a4555555597777777777777795555555445555555c777777cc777777c555555545555555555555555
5555555555555555a555555588888888888888885555555a4555555599999999999999995555555445555555cccccccccccccccc555555545555555555555555
4444444444444444a555555555555555555555555555555a45555555555555555555555555555554455555555555555555555555555555544444444444444444
4444444444444444a555557777777777777777555555555a45555577777777777777775555555554455555777777777777777755555555544444444444444444
5555555555555555a555556666666666666666555555555a45555566666666666666665555555554455555666666666666666655555555545555555555555555
5555555555555555a555555555777777777777777755555a45555555557777777777777777555554455555555577777777777777775555545555555555555555
4444444444444444a555555555666666666666666655555a45555555556666666666666666555554455555555566666666666666665555544444444444444444
4444444444444444a555555777777777777777775555555a45555557777777777777777755555554455555577777777777777777555555544444444444444444
5555555555555555a555555666666666666666665555555a45555556666666666666666655555554455555566666666666666666555555545555555555555555
5555555555555555aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa44444444444444444444444444444444444444444444444444444444444444445555555555555555
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444555555555555555555555555555555445555555555555555555555555555554455555555555555555555555555555544444444444444444
55555555555555554555555555555555555555555555555445555555555555555555555555555554455555555555555555555555555555545555555555555555
55555555555555554555555555555555555555555555555445555555555555555555555555555554455555555555555555555555555555545555555555555555
44444444444444444555555555555555555555555555555445555555555555555555555555555554455555555555555555555555555555544444444444444444
44444444444444444555555555555555555555555555555445555555555555555555555555555554455555555555555555555555555555544444444444444444
55555555555555554555555555555555555555555555555445555555555555555555555555555554455555555555555555555555555555545555555555555555
55555555555555554555555555555555555555555555555445555555555555555555555555555554455555555555555555555555555555545555555555555555
444444444444444445555555bbbbbbbbbbbbbbbb5555555445555555dddddddddddddddd5555555445555555eeeeeeeeeeeeeeee555555544444444444444444
444444444444444445555555b77777777777777b5555555445555555d77777777777777d5555555445555555e77777777777777e555555544444444444444444
555555555555555545555555b7777777bb77777b5555555445555555d77777dddd77777d5555555445555555e77777777777777e555555545555555555555555
555555555555555545555555b77bb777b777777b5555555445555555d777dd7ddddd777d5555555445555555e77777777777777e555555545555555555555555
444444444444444445555555b7777b77b7bbb77b5555555445555555d77d77777dddd77d5555555445555555e77777777777777e555555544444444444444444
444444444444444445555555b77777bbbb77777b5555555445555555d77d777777ddd77d5555555445555555e77777777777777e555555544444444444444444
555555555555555545555555b777777bb77bb77b5555555445555555d7d77777777ddd7d5555555445555555e7777777e7777e7e555555545555555555555555
555555555555555545555555b77bbb7bbbb7777b5555555445555555d7d77777777ddd7d5555555445555555e7777777ee77ee7e555555545555555555555555
444444444444444445555555b7777bbbbb77777b5555555445555555d7d77777777ddd7d5555555445555555e77eee77eeeeee7e555555544444444444444444
444444444444444445555555b7777777bb77777b5555555445555555d7d77777777ddd7d5555555445555555e77e7e77ee7e7e7e555555544444444444444444
555555555555555545555555b777777bbb77777b5555555445555555d77d777777ddd77d5555555445555555e77e7777eeeeee7e555555545555555555555555
555555555555555545555555b777777bb777777b5555555445555555d77d77777dddd77d5555555445555555e77eeeeeeeeee77e555555545555555555555555
444444444444444445555555b777777bb777777b5555555445555555d777dd7ddddd777d5555555445555555e77eeeeeeee7777e555555544444444444444444
444444444444444445555555b77777bbbb77777b5555555445555555d77777dddd77777d5555555445555555e77eeeeeeee7777e555555544444444444444444
555555555555555545555555b7777bbbbbb7777b5555555445555555d77777777777777d5555555445555555e77eeeeeeeee777e555555545555555555555555
555555555555555545555555bbbbbbbbbbbbbbbb5555555445555555dddddddddddddddd5555555445555555eeeeeeeeeeeeeeee555555545555555555555555
44444444444444444555555555555555555555555555555445555555555555555555555555555554455555555555555555555555555555544444444444444444
44444444444444444555557777777777777777555555555445555577777777777777775555555554455555777777777777777755555555544444444444444444
55555555555555554555556666666666666666555555555445555566666666666666665555555554455555666666666666666655555555545555555555555555
55555555555555554555555555777777777777777755555445555555557777777777777777555554455555555577777777777777775555545555555555555555
44444444444444444555555555666666666666666655555445555555556666666666666666555554455555555566666666666666665555544444444444444444
44444444444444444555555777777777777777775555555445555557777777777777777755555554455555577777777777777777555555544444444444444444
55555555555555554555555666666666666666665555555445555556666666666666666655555554455555566666666666666666555555545555555555555555
55555555555555554444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444445555555555555555
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
55555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555555
44444444444444444444444444444444444444445777777777777777777777777777777777777777777777754444444444444444444444444444444444444444
44444444444444444444444444444444444444447577777777777777777777777777777777777777777777574444444444444444444444444444444444444444
55555555555555555555555555555555555555557757777777777777777777777777777777777777777775775555555555555555555555555555555555555555
55555555555555555555555555555555555555557775777777777777777777777777777777777777777757775555555555555555555555555555555555555555
44444444444444444444444444444444444444447777577777777777777777777777777777777777777577774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777757777777777777777777777777777777777775777774444444444444444444444444444444444444444
55555555555555555555555555555555555555557777775555555555555555555555555555555555557777775555555555555555555555555555555555555555
55555555555555555555555555555555555555557777777777777777777777777777777777777777777777775555555555555555555555555555555555555555
44444444444444444444444444444444444444447777777777777777bbbbbbbbbbbbbbbb77777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777b77777777777777b77777777777777774444444444444444444444444444444444444444
55555555555555555555555555555555555555557777777777777777b7777777bb77777b77777777777777775555555555555555555555555555555555555555
55555555555555555555555555555555555555557777777777777777b77bb777b777777b77777777777777775555555555555555555555555555555555555555
dddddddddddddddddddddddddddddddddddddddd7777777777777777b7777b77b7bbb77b7777777777777777dddddddddddddddddddddddddddddddddddddddd
dddddddddddddddddddddddddddddddddddddddd7777777777777777b77777bbbb77777b7777777777777777dddddddddddddddddddddddddddddddddddddddd
44444444444444444444444444444444444444447777777777777777b777777bb77bb77b77777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777b77bbb7bbbb7777b77777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777b7777bbbbb77777b77777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777b7777777bb77777b77777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777b777777bbb77777b77777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777b777777bb777777b77777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777b777777bb777777b77777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777b77777bbbb77777b77777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777b7777bbbbbb7777b77777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777bbbbbbbbbbbbbbbb77777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777777777777777777777777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777777777777777777777777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777777777777777777777777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777777777777777777777777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777777777777777777777777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777777777777777777777777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777777777777777777777777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444447777777777777777777777777777777777777777777777774444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444
44444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444444

__map__
1616161616161616161616161616161600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1616161616161616161616161616161600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1616010202030102020301020203161600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1616114041131142431311444513161600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1616115051131152531311545513161600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1616040506070405060704050607161600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1616010202030102020301020203161600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1616116061131162631311646513161600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1616117071131172731311747513161600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1616040506070405060704050607161600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1616161616161616161616161616161600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1616161616141515151525161616161600000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
1717171717242424242424171717171700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2727272727242424242424272727272700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2727272727242424242424272727272700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
2727272727272727272727272727272700000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
__sfx__
010601011845124471244712447100400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000040000400004000000000000
011000000027000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200002000020000200
310800002405000000240500000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
011001000c0500040017400004001a400004001f4000040000400234000040026400004002b400004000040000400004000040000400004000040000400004000040000400004000040000000000000000000000
01140000240500040017400004001a400004001f400004001f40000400234000040026400004002b4000040000400004000040000400004000040000400004000040000400004000040000400004000000000000
00100000134000040017400004001a400004001f400004001f40000400234000040026400004002b4000040000400004000040000400004000040000400004000040000400004000040000400004000000000000
