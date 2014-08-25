function UserBPcheckChange(sender)

	boxstate = checkbox_getState(MyForm_UserBPcheck); --your checkbox 
	if boxstate == cbChecked then 
		userBP = true;
	elseif boxstate == cbUnhecked then 
		userBP = false;
	end 

end
	
function IP_editKeyPress(sender, key)
	if (key == "\r") then 
	  IP_editChange(sender);
	else
		return key
	end 
end

function IP_enc_editKeyPress(sender, key)
	if (key == "\r") then 
		IP_enc_editChange(sender);
	else
		return key
	end 
	
end

function bytesToHexString(bytes)
    local hexBytes = "";
	bytes = {string.byte(bytes, 1, #bytes)};
    
    for i,byte in ipairs(bytes) do 
        hexBytes = hexBytes .. string.format("%02x", byte);
    end

    return hexBytes;
end

function hexStringToBytes(hexBytes)
    local str_aux = "";
    local i;
	for i=1, string.len(hexBytes), 2  do --skip system
        str_aux = str_aux .. string.char(tonumber(string.sub(hexBytes, i, i+1), 16));
    end
    return str_aux;
end

	
function IP_editChange(sender)
	
	local aux_str = getProperty(MyForm_IP_edit, 'Text');
	if( string.len(aux_str) > 0 ) then
		--print("2encrypt" .. ":" .. aux_str)
				
		cipher = aeslua.encrypt(IP_key, aux_str, aeslua.AES128, aeslua.ECBMODE);
		
		--print("encrypted" .. ":" .. cipher)
		setProperty(MyForm_IP_enc_edit, 'Text', bytesToHexString(cipher));
	end
end
	
	
function IP_enc_editChange(sender)

	local aux_str = getProperty(MyForm_IP_enc_edit, 'Text');
	if( string.len(aux_str) > 0 ) then
		--print("2decrypt" .. ":" .. hexStringToBytes(aux_str) )
		decrypted = aeslua.decrypt(IP_key, hexStringToBytes(aux_str), aeslua.AES128, aeslua.ECBMODE);
		--print("decrypted" .. ":" .. decrypted)
		setProperty(MyForm_IP_edit, 'Text', decrypted);
		bOwnChange = true;
	end
end
	
function Country_editChange(sender)

	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'MyCountry') 
	memoryrecord_setValue(memrec1, control_getCaption(MyForm_Country_edit));

end

function Name_editChange(sender)

	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'MyName') 
	memoryrecord_setValue(memrec1, control_getCaption(MyForm_Name_edit));
	print(control_getCaption(MyForm_Name_edit))

end

	
function EnablePrivs_OnClick(sender)
	
	local memrec1 = 0
	
	-- local memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'isVIP') 
	-- memoryrecord_setValue(memrec1, 1);

	-- memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'stealth') 
	-- memoryrecord_setValue(memrec1, 1);

	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'TxtRestr') 
	memoryrecord_setValue(memrec1, '^');
	
	-- memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'MyIP') 
--	memoryrecord_setValue(memrec1, string.format('188.244.85.%d',math.random(20,230)));
	-- memoryrecord_setValue(memrec1, '180.240.102.104');

	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'sendMsgTimeOut') 
	memoryrecord_setValue(memrec1, 0);
	memoryrecord_freeze(memrec1);

	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'camTimeUp') 
	memoryrecord_setValue(memrec1, 0);
	memoryrecord_freeze(memrec1);

	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'timeOut') 
	memoryrecord_setValue(memrec1, 0);
	memoryrecord_freeze(memrec1);

	-- memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'myIPencrypted') 
	-- memoryrecord_setValue(memrec1, "0891c5efafe78ef37374eb3d69b3d7ea");
	-- '180.240.102.104' = 0891c5efafe78ef37374eb3d69b3d7ea

	-- memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'PVrestr') 
	-- memoryrecord_setValue(memrec1, 1);
	-- memoryrecord_freeze(memrec1);

	local str_section = "[ALL user limit] ";
	local address_offset = 0x17;	
	local AOBresults= "";
	
	-- All user limit
	if( not bAllUserLimit ) then
		
		AOBresults=AOBScan("83 C4 08 8B 95 48FFFFFF 8B C8 E8 ???????? 8B 55 08 83 F0 ?? ", "+X-C-W" );
		
		if ( AOBresults==nil) then 
			print(str_section .. 'WARNING: Pattern not found. Could not set room ownership')
		else
		
			count=stringlist_getCount(AOBresults) 
			
			if (count==1) then
			
				local this_address = string.format('%X', tonumber(stringlist_getString(AOBresults,0), 16)+address_offset);
				local this_val = readInteger(this_address);

				if bAnd(this_val, 0xFFFF0000) == 0x8D0F0000 then
					writeInteger(this_address, 0x850F0000 + bAnd(this_val, 0x0000FFFF) );		
					print(str_section .. 'Patched address '.. this_address)
					bAllUserLimit = true;
				else
					print(str_section .. 'Found ' .. string.format('%X',this_val) .. ' @ ' .. this_address)
					
					address_offset = address_offset + 2;
					local this_address = string.format('%X', tonumber(stringlist_getString(AOBresults,0), 16)+address_offset);
					local this_val = readInteger(this_address);

					if bAnd(this_val, 0xFFFF0000) == 0x8D0F0000 then
						writeInteger(this_address, 0x850F0000 + bAnd(this_val, 0x0000FFFF) );		
						print(str_section .. 'Patched address '.. this_address)
						bAllUserLimit = true;
					else
						print(str_section .. 'Found ' .. string.format('%X',this_val) .. ' @ ' .. this_address)
					end
						
				end
						
			else
				print(str_section .. 'WARNING: More than one pattern found, code change ?')
			end
				
		end	

	end
		
	-- VIP user limit
	if( not bVipLimit ) then
	
		str_section = "[VIP user limit] ";
		address_offset = 0x20;	
		AOBresults=AOBScan("8B 95 44FFFFFF 8B 8D 48FFFFFF E8 ???????? 8B 55 08 8B C8 8B 85 40FFFFFF 83 F1 ?? 83 F9 ?? ", "+X-C-W" );
	
		if ( AOBresults==nil) then 
			
			print(str_section .. 'WARNING: Patterns not found. Could not set room ownership')

		else
		
			count=stringlist_getCount(AOBresults) 
			
			if (count==1) then
			
				local this_address = string.format('%X', tonumber(stringlist_getString(AOBresults,0), 16)+address_offset);
				local this_val = readInteger(this_address);
							
				if bAnd(this_val, 0xFFFF0000) == 0x8F0F0000 then
					writeInteger(this_address, 0x8D0F0000 + bAnd(this_val, 0x0000FFFF) );		
					print(str_section .. 'Patched address '.. this_address)
					bVipLimit = true;
					
				else
					print(str_section .. 'Found ' .. string.format('%X',this_val) .. ' @ ' .. this_address)
				end
						
			else
				print(str_section .. 'WARNING: More than one pattern found, code change ?')
			end
				
		end	
	end
	
 
	
	-- Locked rooms
	
	if( bLockedRooms < 1 ) then
		
		str_section = "[Locked rooms] ";
		address_offset = 0x19;	
		AOBresults=AOBScan(" 8B 45 E4 8B 90 74010000 8B 4D E0 E8 ???????? 8B 4D 08 8B D0 8B 45 E4 85 ?? 0F?? ????????  ", "+X-C-W" );
		
		if ( AOBresults==nil) then 
			
			print(str_section .. 'WARNING: Patterns not found. Could not set room ownership')

		else
		
			count=stringlist_getCount(AOBresults) 
			
			if (count==1) then
			
				local this_address = string.format('%X', tonumber(stringlist_getString(AOBresults,0), 16)+address_offset);
				local this_val = readInteger(this_address);
							
				if bAnd(this_val, 0xFFFF0000) == 0x850F0000 then
					writeInteger(this_address, 0x840F0000 + bAnd(this_val, 0x0000FFFF) );		
					print(str_section .. 'Patched address '.. this_address)

					bLockedRooms = 1;
				else
					print(str_section .. 'Found ' .. string.format('%X',bAnd(this_val, 0xFFFF0000)) .. ' @ ' .. this_address)
				end
						
			else
				print(str_section .. 'WARNING: More than one pattern found, code change ?')
			end
				
		end	

	end

	if( bLockedRooms < 2 ) then
	
		address_offset = 0x18;	
		AOBresults=AOBScan(" 8B 90 74010000 8B 4D E0 E8 ???????? 8B 4D E0 8B D0 B8 04000000 85 D2 0F84 ???????? 8B 45 E4 8D 80 20020000 	", "+X-C-W" );
		
		if ( AOBresults==nil) then 
			
			print(str_section .. 'WARNING: Patterns not found. Could not set room ownership')
				
		else
		
			count=stringlist_getCount(AOBresults) 
			
			if (count==1) then
			
				local this_address = string.format('%X', tonumber(stringlist_getString(AOBresults,0), 16)+address_offset);
				local this_val = readInteger(this_address);
							
				if bAnd(this_val, 0xFFFF0000) == 0x840F0000 then
					writeInteger(this_address, 0x850F0000 + bAnd(this_val, 0x0000FFFF) );		
					print(str_section .. 'Patched address '.. this_address)
					bLockedRooms = 2;

					-- Con este bp aseguraremos que la passw de cada sala sea siempre la correcta.
					memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'keyRoomStr_pt') 
					MyIP_BPAddress=memoryrecord_getAddress(memrec1) 
					debug_setBreakpoint(MyIP_BPAddress, 1, bptWrite)
					
				else
					print(str_section .. 'Found ' .. string.format('%X',bAnd(this_val, 0xFFFF0000)) .. ' @ ' .. this_address)
				end
						
			else
				print(str_section .. 'WARNING: More than one pattern found, code change ?')
			end
				
		end	
		
	end	
	
	-- local AOBresults=AOBScan("83 C4 10 8B 45 C0 89 45 88 8B 88 DC000000 85 C9 0F84 ?? ?? ?? ?? 8D 49 01 8B 05 ?? ?? ?? ?? 83 EC 04 51 FF 75 9C 68 ?? ?? ?? ?? FF D0 83 C4 10 8B C8 83 F9 04 0F84 ?? ?? ?? ?? 83 F9 04 0F82 ?? ?? ?? ?? 8B 05 ?? ?? ?? ?? FF 75 9C 6A 05 51 68 ?? ?? ?? ?? FF D0 83 C4 10 8B 4D 88 8B 81 ?? ?? ?? ?? 85 C0 0F84 ?? ?? ?? ?? 8B 50 08 8B 8A A0000000 8D 55 8C 89 45 8C ", "+X-C-W" );
	
	-- if ( (not bRoomOwnershipPatched) and AOBresults==nil) then 
		
		-- print('WARNING: Pattern not found. Could not set room ownership')
		
	-- else

		-- count=stringlist_getCount(AOBresults) 
		
		-- if (count==1) then
		
			-- bRoomOwnershipPatched = true;
			
			-- local this_address = string.format('%X', tonumber(stringlist_getString(AOBresults,0), 16)+0x2C);
			-- local this_val = readQword(this_address);
						
			-- if bAnd(this_val,0xFFFF) == 0xD0FF then
				-- writeQword(this_address, bAnd(this_val,0xFFFFFFFFFFFF0000)+0x9090 );		
			-- else
				-- print('Found ' .. string.format('%X',this_val) .. ' @ ' .. this_address)
			-- end
			
			-- local this_address = string.format('%X', tonumber(stringlist_getString(AOBresults,0), 16)+0x56);
			-- local this_val = readQword(this_address);
						
			-- if bAnd(this_val,0xFFFF) == 0xD0FF then
				-- writeQword(this_address, bAnd(this_val,0xFFFFFFFFFFFF0000)+0x9090 );		
			-- else
				-- print('Found ' .. string.format('%X',this_val) .. ' @ ' .. this_address)
			-- end
					
		-- else
			-- print('WARNING: More than one pattern found, code change ?')
		-- end
			
	-- end
	
	-- memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'changingRoom') 
	-- local this_bpAddress=memoryrecord_getAddress(memrec1) 
	-- debug_setBreakpoint(this_bpAddress, 1, bptWrite)
				
	print('Privs Set')
	bPrivsSet = true;

--	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'isMyRoom') 
--	local thisBPAddress=memoryrecord_getAddress(memrec1) 
--
--	print('Breaking on write to ' .. bpAddress)
--	debug_setBreakpoint(thisBPAddress, 1, bptWrite)
	
	
	-- if bShieldsUp == 0 then
		-- print('Shields up!')
		-- bShieldsUp = 1;
	-- end
	
	
end


function debugger_onBreakpoint()

	-- check rejected first
	local bNoHit = true;
	
	local memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'timeOut') 
	memoryrecord_setValue(memrec1, 0);
	
	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'rejected') 
	local bRejected= tonumber(memoryrecord_getValue(memrec1)) 

	
	if bRejected == 1 then

		memoryrecord_setValue(memrec1,0) 
	
		print('rejected!')
		
--		if bShieldsUp == 0 then
--			-- not logged in, do trick to login
--
--			print('dodging ...')
--			
--			local AOBresults_accept=AOBScan("83 C4 10 8B 45 C0 89 45 88 8B 88 8C000000 ", "+X-C-W" );
--			local AOBresults_reject=AOBScan("C7 83 88000000 01000000 C7 83 90000000 00000000 C7 83 8C000000 01000000", "+X-C-W" );
--			
--			if AOBresults_accept==nil or AOBresults_reject==nil  then 
--				
--				print('WARNING: Reject or Accept pattern not found.')
--				
--			else
--
--				local count_accept=stringlist_getCount(AOBresults_accept) 
--				local count_reject=stringlist_getCount(AOBresults_reject) 
--			
--				print( count_accept .. ' ' .. count_reject)
--				
--				if count_accept~=1 or count_reject~=1 then 
--					print('trace not found ...')
--				
--				else
--					local accept_address = tonumber(stringlist_getString(AOBresults_accept, 0),16);
--					local reject_address = tonumber(stringlist_getString(AOBresults_reject, 0),16);
--
--					print('EIP: ' .. string.format('%X', EIP))
--					local dodge_address = accept_address - EIP - 42;
--					print('offset: ' .. string.format('%X', bAnd(dodge_address,0xFFFFFFFF)))
--
--					writeBytes(EIP+10, 0x90,0x90,0x90,0x90,0x90,0x90,0x90,0x90,0x90,0x90 ); -- jmp
--					writeBytes(EIP+10, 0xE9 ); -- jmp
--					writeQword(EIP+11,  bOr(bAnd(dodge_address,0xFFFFFFFF), 0x9090909000000000));		
--
--				end					
--			end
--		
--		else
		
--			-- being rejected
--			print('We are under attack !')
--			
--			bShieldsUp = 2;
--				
--			-- patch rejection
--			local AOBresults=AOBScan("8B 7D E8 8B 75 EC 8B 5D FC 8B 45 08 83 EC 0C 50 E8 ?? ?? ?? ?? 83 C4 10 33 C0 8B E5 5D", "+X-C-W" );
--			
--			if AOBresults==nil then 
--				
--				print('WARNING: Safe exit not found. Could not dodge :(')
--				
--			else
--
--				local safe_exit_address = tonumber(stringlist_getString(AOBresults, 0),16);
--
--				print('EIP: ' .. string.format('%X', EIP))
--				local dodge_address = safe_exit_address - EIP +5;
--				print('offset: ' .. string.format('%X', bAnd(dodge_address,0xFFFFFFFF)))
--
--				--writeBytes(EIP+10, 0x90,0x90,0x90,0x90,0x90,0x90,0x90,0x90,0x90,0x90 ); -- jmp
--				--writeBytes(EIP+10, 0xE9 ); -- jmp
--				--writeQword(EIP+11,  bOr(bAnd(dodge_address,0xFFFFFFFF), 0x9090909000000000));		
--				
--				print('Reject patched !')
--
--			end
		
--		end	
		
		--bNoHit = false; -- continue execution
		
	
	end

--	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'MyIP')
--	local this_IP = memoryrecord_getValue(memrec1);
--	
--	-- viejas IPs mias : 188.84.116.134
--	
--	if (bIPchanged and this_IP ~= '55.55.55.55')  then
--		print( 'IP changed' )
--		bIPchanged = false;
--		debug_removeBreakpoint(MyIP_BPAddress)
--
--		EnablePrivs_OnClick(nil);
--		
--		aux_str = memoryrecord_getValue(memrec1);
--
--		setProperty(MyForm_IP_edit, 'Text', aux_str);
--		--IP_editChange(nil)		
--		
--		-- memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'MyName') 
--		-- setProperty(MyForm_Name_edit, 'Text', memoryrecord_getValue(memrec1));
--
--		-- memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'MyCountry') 
--		-- setProperty(MyForm_Country_edit, 'Text', memoryrecord_getValue(memrec1));
--		
--		bNoHit = false; -- continue execution
--		
--	end
	
	-- memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'changingRoom') 
	-- local bChangingRoom=tonumber(memoryrecord_getValue(memrec1))

	-- if bPrivsSet and bChangingRoom == 1 then
		-- print('VIP off')
		-- memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'isVIP') 
		-- memoryrecord_setValue(memrec1, 0);
		-- bNoHit = false; -- continue execution
		
	-- elseif bPrivsSet and bChangingRoom == 0 then
		-- print('VIP on')
		-- memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'isVIP') 
		-- memoryrecord_setValue(memrec1, 1);
		-- bNoHit = false; -- continue execution
		
	-- end	
	
	
	
	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'tempPW') 
	local tempPW = memoryrecord_getValue(memrec1);
	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'keyRoomStr_val') 
	local keyRoomStr_val = memoryrecord_getValue(memrec1);
	if( not(tempPW == keyRoomStr_val) ) then

		print('Psw change to ' .. tempPW)
	
		memoryrecord_setValue(memrec1, tempPW)

		anonymize();
		
		bNoHit = false; -- continue execution
		
	end
	
	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'roomID') 
	local this_room_id = memoryrecord_getValue(memrec1);
	
	if( not(curr_room_ID == this_room_id) ) then
		
		if GoingPV_state == 1 then -- room change

			GoingPV_state = 2;

			
			print('Changing to ' .. dest_room_ID)

			memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'goingToRoom') 
			memoryrecord_setValue(memrec1, dest_room_ID) 
			curr_room_ID = dest_room_ID;

			bNoHit = false; -- continue execution
			
		elseif (GoingPV_state == 2) then

			print('Leaving PV')
		
			GoingPV_state = 0;

			deanonymize();
			
			debug_removeBreakpoint(bpAddress)
			
			bpSet = false;

			bNoHit = false; -- continue execution
			
		else
			print('Room change')
			
			GoingPV_state = 0; --Check room switch
			
		end
		
		
	end

	if( userBP and bNoHit ) then
		print('Breakpoint hit !')
	else
		print('Continuing ...')
		debug_continueFromBreakpoint(co_run); -- continue execution
	end
	
end


function anonymize()

	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'MyGender_val') 
	old_Gender = memoryrecord_getValue(memrec1);
	memoryrecord_setValue(memrec1, 'wale');
	
	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'MyName') 
		
	local temp_str = memoryrecord_getValue(memrec1);		
	if string.len(temp_str) > 0 then
		old_Name = temp_str;
	end
	memoryrecord_setValue(memrec1, ' ');
	
	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'MyCountry') 

	local temp_str = memoryrecord_getValue(memrec1);		
	if string.len(temp_str) > 0 then
		old_Country = temp_str;
	end
	
	memoryrecord_setValue(memrec1, ' ');
	
	bAnonymized = true;
	
	--memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'MyIP') 
	--memoryrecord_setValue(memrec1, string.format('188.244.85.%d',math.random(20,230)));
	
end


function deanonymize()

	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'MyGender_val') 
	memoryrecord_setValue(memrec1, 'male');
	
	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'MyName') 
	memoryrecord_setValue(memrec1, old_Name);
	
	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'MyCountry') 
	memoryrecord_setValue(memrec1, old_Country);

	bAnonymized = false;
	--memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'MyIP') 
	--memoryrecord_setValue(memrec1, string.format('188.244.85.%d',math.random(20,230)));
	
end



function AnonymizerClick(sender)

	if bAnonymized then
	
		control_setCaption(MyForm_Anonymizer, 'Anonymize');
		deanonymize();
		
	else
	
		control_setCaption(MyForm_Anonymizer, 'DeAnonymize');
		anonymize();
		
	end
	

end


function rooms_list_OnDClick(sender)

	local SelectedItemIndex = listbox_getItemIndex(MyForm_rooms_list) 
	if SelectedItemIndex==-1 then return end 

	-- anonymize
	GoingPV_state = 1;
	
	anonymize();
	
	-- to do Age
	
	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'changingRoom') 
	bpAddress=memoryrecord_getAddress(memrec1) 
	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'roomID') 
	curr_room_ID = memoryrecord_getValue(memrec1);
	
	dest_room_ID = stringlist_getString(listbox_getItems(MyForm_rooms_list), SelectedItemIndex)	
	print('curr_room_ID ' .. curr_room_ID .. " going to " .. dest_room_ID )
	
	if not bpSet then 
		
		bpSet = true;
		
		print('Breaking on write to ' .. bpAddress)
		debug_setBreakpoint(bpAddress, 1, bptWrite)
		print('Ready to switch Room')
	end
	
end

function users_list_OnClick(sender)
	local SelectedItemIndex = listbox_getItemIndex(MyForm_users_list) 
	if SelectedItemIndex==-1 then return end 

	local user_id = stringlist_getString(listbox_getItems(MyForm_users_list), SelectedItemIndex);
	writeToClipboard(user_id);
end


function rooms_list_OnClick(sender)

	local SelectedItemIndex = listbox_getItemIndex(MyForm_rooms_list) 
	if SelectedItemIndex==-1 then return end 

	listbox_getItemIndex(MyForm_rooms_list)
	room_id = stringlist_getString(listbox_getItems(MyForm_rooms_list), SelectedItemIndex);
	writeToClipboard(room_id);
end

function GetUsers_OnClick(sender)
	
	results=AOBScan("06 67 65 6E 64 65 72 02 00 06 ");
	if (results==nil) then 
		print("No users found.")
		listbox_clear(MyForm_users_list)
		return 
	end
	
    count=stringlist_getCount(results) 

	print("Found "..count.." hits.")
	
	if (count>0) then
	
		--listbox_clear(MyForm_users_list)
		user_names = listbox_getItems(MyForm_users_list);
		local aux_val;
		
		for ii=0,count-1 do 
		--for ii=1,50 do 
			
			local bFound = false;
			
			--this_str = foundlist_getAddress(fl, ii)
			local gender_address = tonumber(stringlist_getString(results,ii), 16);
			-- parse fields

			local StartAddress = string.format("%08X",gender_address-170)--my start pointer 
			local EndAddress = string.format("%08X",gender_address-1)--my start pointer 
			local MyMemscan = createMemScan() 
			memscan_returnOnlyOneResult(MyMemscan, true) 
			--camtype
			memscan_firstScan(MyMemscan,soExactValue,vtByteArray, rtRounded, "07 63 61 6D 74 79 70 65 02 00", "", StartAddress,EndAddress, "*X*W*C", 0, "", true, true,false, false) 
			memscan_waitTillDone(MyMemscan);
			local cam_index = memscan_getOnlyResult(MyMemscan) 

			if( cam_index ~= nil ) then
			
				local cam_length = readBytes( string.format('%08X',cam_index+12), 1);
				
				-- print("Cam length "..cam_length)
				
				if( cam_length > 0 ) then
			
					local cam_val = readString( string.format('%08X',cam_index+13), 40);

					-- print("Cam val "..cam_val)
					--Name
					memscan_firstScan(MyMemscan,soExactValue,vtByteArray,rtRounded, "55 73 65 72 4E 61 6D 65 02 00", "", StartAddress,EndAddress, "*X*W*C", 0, "", true, true,false, false) 
					memscan_waitTillDone(MyMemscan);
					cam_index = memscan_getOnlyResult(MyMemscan) 
					
					local user_name = "??";
					if( cam_index ~= nil ) then
						-- print("ip_idx: " .. string.format('%08X',cam_index+12))
						user_name = readString( string.format('%08X',cam_index+11), 40);
					end					
					-- print("Username "..user_name)
					
					--IP
					StartAddress = string.format("%08X",gender_address)--my start pointer 
					EndAddress = string.format("%08X",gender_address+200)--my start pointer 
					
					memscan_firstScan(MyMemscan,soExactValue,vtByteArray, rtRounded, "02 69 70 02 00", "", StartAddress,EndAddress, "*X*W*C", 0, "", true, true,false, false) 
					memscan_waitTillDone(MyMemscan);
					cam_index = memscan_getOnlyResult(MyMemscan) 

					-- print("ip_idx: " .. string.format('%08X',cam_index+7))

					local ip_val = "??.??.??.??";
					if( cam_index ~= nil ) then
						ip_val = readString( string.format('%08X',cam_index+6), 40);
					end
						
					-- print("ip_val :" .. ip_val)
					
					memscan_firstScan(MyMemscan,soExactValue,vtByteArray, rtRounded, "0A 69 73 77 61 74 63 68 69 6E 67 02", "", StartAddress,EndAddress, "*X*W*C", 0, "", true, true,false, false) 
					memscan_waitTillDone(MyMemscan);
					cam_index = memscan_getOnlyResult(MyMemscan) 

					-- print("Iswatch: " .. string.format('%08X',cam_index+12))

					local is_watching = "??";
					if( cam_index ~= nil ) then
						is_watching = readString( string.format('%08X',cam_index+14), 40);
					end
						
					-- print("ip_val :" .. ip_val)
					
					
					
					if( ip_user[ip_val] == nil ) then
						ip_user[ip_val] = user_name .. " -> " .. is_watching .. " - IP = " .. ip_val;
					else
						aux_val = string.find( ip_user[ip_val], user_name);
						if( aux_val == nil ) then
							ip_user[ip_val] = "(" .. user_name .. ") -> " .. is_watching .. " - " .. ip_user[ip_val];
						end
					end
					
				end	
				
			end
			
		end 

		listbox_clear(MyForm_users_list)		
		local users_found = 0
		for ip_val,aux_val in pairs(ip_user) do
			strings_add(user_names, aux_val );
			users_found = users_found + 1;
		end
		
		print(string.format('%d Users found.',users_found))

	else
	  print("No addresses found")
	end	
	
	-- Admins
	results=AOBScan("61 64 6D 69 6E 5F 63 68 61 74");
	if (results==nil) then 
		results=AOBScan("63 68 61 74 5F 61 64 6D 69 ");
		if (results==nil) then 
			print("No Admins found.")
			return 
		end
	end
	
    count=stringlist_getCount(results) 

	print("Found "..count.." Admins.")
	
	if (count>0) then
	
		for ii=0,count-1 do 
		--for ii=1,50 do 
			
			--this_str = foundlist_getAddress(fl, ii)
			local gender_address = tonumber(stringlist_getString(results,ii), 16);
			-- parse fields

			local StartAddress = string.format("%08X",gender_address-650)--my start pointer 
			local EndAddress = string.format("%08X",gender_address)--my start pointer 
			local MyMemscan = createMemScan() 
			memscan_returnOnlyOneResult(MyMemscan, true) 

			memscan_firstScan(MyMemscan,soExactValue,vtByteArray, rtRounded, "07 69 73 41 64 6D 69 6E 01", "", StartAddress,EndAddress, "*X*W*C", 0, "", true, true,false, false) 
			memscan_waitTillDone(MyMemscan);
			local cam_index = memscan_getOnlyResult(MyMemscan) 

			local isAdmin = 0;
			if( not(cam_index == nil) ) then
				print("isSuperAdmin_idx: " .. string.format('%08X',cam_index+8))
				isAdmin = readInteger( string.format('%08X',cam_index+8) );
			end					
			
			--camtype
			memscan_firstScan(MyMemscan,soExactValue,vtByteArray, rtRounded, "0C 69 73 53 75 70 65 72 41 64 6D 69 6E 01", "", StartAddress,EndAddress, "*X*W*C", 0, "", true, true,false, false) 
			memscan_waitTillDone(MyMemscan);
			local cam_index = memscan_getOnlyResult(MyMemscan) 

			local isSuperAdmin = 0;
			if( not(cam_index == nil) ) then
				print("isSuperAdmin_idx: " .. string.format('%08X',cam_index+14))
				isSuperAdmin = readInteger( string.format('%08X',cam_index+14) );
			end					

			--if (isAdmin ~= 0 or isSuperAdmin ~= 0 ) then
			
				--Name
				memscan_firstScan(MyMemscan,soExactValue,vtByteArray,rtRounded, "55 73 65 72 4E 61 6D 65 02 00", "", StartAddress,EndAddress, "*X*W*C", 0, "", true, true,false, false) 
				memscan_waitTillDone(MyMemscan);
				cam_index = memscan_getOnlyResult(MyMemscan) 
				
				local user_name = "??";
				if( cam_index == nil ) then

				else
					 print("ip_idx: " .. string.format('%08X',cam_index+12))
					user_name = readString( string.format('%08X',cam_index+11), 40);
				end					
				 print("Username "..user_name)
				
				--IP
				memscan_firstScan(MyMemscan,soExactValue,vtByteArray, rtRounded, "02 69 70 02 00", "", StartAddress,EndAddress, "*X*W*C", 0, "", true, true,false, false) 
				memscan_waitTillDone(MyMemscan);
				cam_index = memscan_getOnlyResult(MyMemscan) 

				local ip_val = "??.??.??.??";
				if( cam_index ~= nil ) then
					 print("ip_idx: " .. string.format('%08X',cam_index+7))
					ip_val = readString( string.format('%08X',cam_index+6), 40);
				end
					
				 print("ip_val :" .. ip_val)
				
				memscan_firstScan(MyMemscan,soExactValue,vtByteArray, rtRounded, "0A 69 73 77 61 74 63 68 69 6E 67 02", "", StartAddress,EndAddress, "*X*W*C", 0, "", true, true,false, false) 
				memscan_waitTillDone(MyMemscan);
				cam_index = memscan_getOnlyResult(MyMemscan) 

				local is_watching = "??";
				if( cam_index ~= nil ) then
					 print("Iswatch: " .. string.format('%08X',cam_index+12))
					is_watching = readString( string.format('%08X',cam_index+12), 40);
				end
				
				if( ip_user[ip_val] == nil ) then
					ip_user[ip_val] = "(!) " .. user_name .. " -> " .. is_watching .. " - IP = " .. ip_val;
				else
					aux_val = string.find( ip_user[ip_val], user_name);
					if( aux_val == nil ) then
						ip_user[ip_val] = "(!) (" .. user_name .. ") -> " .. is_watching .. " - " .. ip_user[ip_val];
					end
				end			
			--end
		end
	end
				
	
end

--76 65 72 69 66 79 56 69 70 01 00

function GetSWF_versions_OnClick(sender)
	
	results=AOBScan("2E 73 77 66");
	if (results==nil) then 
		print("No users found.")
		listbox_clear(MyForm_users_list)
		return 
	end
	
    count=stringlist_getCount(results) 

	print("Found "..count.." hits.")
	
	local rooms_found = 0;
	
	if (count>0) then
	
		listbox_clear(MyForm_users_list)
		user_names = listbox_getItems(MyForm_users_list);
		local aux_val;

		local bFound = false;
		
		for ii=0,count-1 do 
		--for ii=1,50 do 
			
			bFound = false;
			
			--this_str = foundlist_getAddress(fl, ii)
			local gender_address = tonumber(stringlist_getString(results,ii), 16)+4;

			local cam_val = "";
			local aux_val = 0;
			local max_length = 50;
			local aux_address = gender_address-max_length;
			
			while( aux_address < gender_address ) do
				cam_val = readString( string.format('%08X',aux_address), max_length);
				aux_val = string.len(cam_val);
				if( aux_val > 0 ) then
					aux_address = aux_address + aux_val;
				else
					aux_address = aux_address + 1;
				end
			end

			if( cam_val ~= nil ) then
				cam_val = string.match(cam_val, ".*/(.+)");
				--print(cam_val);
				if( cam_val ~= nil ) then
					cam_val = string.match(cam_val, "(.+).swf.*");
					--print(cam_val);
					if( cam_val ~= nil ) then
						for jj=0,rooms_found-1 do 
							aux_val = string.find(strings_getString(user_names, jj), cam_val)
							if aux_val ~= nil then 
								bFound = true;
								break 
							end
						end
						
						if not bFound then
							strings_add(user_names, cam_val)
							rooms_found = rooms_found + 1;
						end
					end
				end
			end
		end 
		
		print(string.format('%d versions found.',rooms_found))

	else
	  print("No versions found")
	end	
	
end

function AOBSwap(aobIn,aobOut) 
 aobOut = aobOut:gsub('[^%w]','') -- remove all spaces 

 local hits = 0;
 local _aobOut='' 
 for i=1,#aobOut,2 do 
  _aobOut = _aobOut..aobOut:sub(i,i+1)..' '  -- add spaces (only the needed ones) 
 end 

 local address = 0 

--AOBScan("aobstring", protectionflags OPTIONAL, alignmenttype OPTIONAL, alignmentparam HALFOPTIONAL) 

 local aobs = AOBScan(aobIn, '+W*X-C', 1) -- you can change here: protection flags and alignment (e.g. writable, addresses dividable by 4) 
 if(aobs ~= nil) then 
   for i = 0,aobs.Count-1 do 
     address = aobs.String[i] 
     autoAssemble(address..[[: 
                  db ]].._aobOut) 
	 hits = hits + 1;
   end 
   aobs.destroy() 
   
 end 
 
 return hits
end


function GetRooms_OnClick(sender)
	--writeInteger("[[[[[pepflashplayer.dll+00C857E0]+410]+C]+764]+248]+130", 1)

--	ms=createMemScan()
--	memscan_firstScan(ms, soExactValue, vtByteArray, rtRounded, "72 6F 6F 6D 5F ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? 00", "0", 0x00000000, 0x7fffffff, "", fsmNotAligned, "", false, false, false, true) --change the last true to false if you do not wish case sensitivity
--	memscan_waitTillDone(ms)

--	--get the result of the scans
--	fl=createFoundList(ms)
--	foundlist_initialize(fl)
--	local count=foundlist_getCount(fl)

	results=AOBScan("70 61 73 73 77 6F 72 64 02 00 08 2A 2A 2A 2A 2A 2A 2A 2A 00 06 72 6F 6F 6D 49 44 02 00 19 72 6F 6F 6D 5F ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ?? ??");
	if (results==nil) then 
		print("No pv rooms found.")
		listbox_clear(MyForm_rooms_list)
		return 
	end
	
    count=stringlist_getCount(results) 

	print("Found "..count.." hits.")
	
	if (count>0) then
	
		listbox_clear(MyForm_rooms_list)
		room_names = listbox_getItems(MyForm_rooms_list);
		--string_clear(room_names);
		
		--local this_str = foundlist_getAddress(fl, 0)
		local this_str = tonumber(stringlist_getString(results,0), 16)+0x1e;
		strings_add(room_names, readString( string.format('%X',this_str), 25))
		local rooms_found = 1
		
		for ii=1,count-1 do 
		--for ii=1,50 do 
			
			local bFound = false;
			
			--this_str = foundlist_getAddress(fl, ii)
			this_str = tonumber(stringlist_getString(results,ii), 16)+0x1e;
			this_str = readString( string.format('%X',this_str), 25);

			aux_val = string.find(this_str, "room_")
			if aux_val == 1 and string.len(this_str) == 25 then 
			
				print("Processing "..this_str)
				local jj, aux_val;
				
				for jj=0,rooms_found-1 do 
					aux_val = string.find(strings_getString(room_names, jj), this_str)
					if not(aux_val == nil) then 
						bFound = true;
						break 
					end
				end
				
				if not bFound then
					strings_add(room_names, this_str)
					rooms_found = rooms_found + 1;
				end
			end				
		end 

	else
	  print("No addresses found")
	end


end

-- require("aeslua");
-- util = require("aeslua.util");

bAllUserLimit = false;
bVipLimit = false;
bLockedRooms = 0;


bIPchanged = true;

bRoomOwnershipPatched = false;

userBP = true;
bpSet = false;
bPrivsSet = false;
bOwnChange = false;

bShieldsUp = 0;
bAnonymized = false;
GoingPV_state = 0;

ip_user = {};

old_Name = 'AABUBU';
old_Country = 'Spain';
old_Age = '30';
old_Gender = 'male'

bpAddress = '';
addresslist = getAddressList() 

MyIP_BPAddress = nil;

listbox_clear(MyForm_rooms_list)

memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'rijndael_key') 
aux_address = memoryrecord_getAddress(memrec1);
strlength = readBytes(aux_address-1,1);
room_key = memoryrecord_getValue(memrec1);
room_key = string.sub(room_key, 1, strlength);

memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'rijndael_key5') 
aux_address = memoryrecord_getAddress(memrec1);
strlength = readBytes(aux_address-1,1);
--IP_key = memoryrecord_getValue(memrec1);
--IP_key = string.sub(IP_key, 1, strlength);
IP_key = "79566214843925";

memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'roomID') 
room_id = memoryrecord_getValue(memrec1);
curr_room_ID = room_id;
dest_room_ID = nil;

setProperty(MyForm_Name_edit, 'Text', old_Name);
setProperty(MyForm_Country_edit, 'Text', old_Country);

form_centerScreen(MyForm)
form_show(MyForm)

local pid_chrome=getProcessIDFromProcessName('chrome.exe')

if (pid_chrome==nil) then
	print('Start chrome first.')
else
	
	pid_found = getOpenedProcessID();
	
	if (pid_found ~= 0) then 

		--scan this process for the aob 
		results=AOBScan("35 35 2E 35 35 2E 35 35 2E 35 35");

		if (results==nil) then 
			print('AOB not found. This PID is not the one we are looking for. ')
			pid_found = nil;
			 
		else
			count=stringlist_getCount(results) 
			if (count==0) then
				--nothing found
				print('0 length. This PID is not the one we are looking for. ')
				pid_found = nil;
			end 
		end	

	end

	--print("Chrome found @ ".. pid)
	--print("Opened process @ ".. pid_found)
	
	if (pid_found == nil or pid_found == 0) then 

		openProcess(pid_chrome)
	
		pl=createStringlist()
		getProcesslist(pl)
		print('Looking for the correct process.')

		for i=strings_getCount(pl)-1, 0, -1  do --skip system
		  pid=strings_getString(pl, i)
		  --print(pid)
		  j=string.find(pid,'chrome')
		  if (j==nil) then
				 --print('Chrome not found')
			  else

			  --print("Found "..pid)
			  
			  j=string.find(pid,'-')
			  pid='0x'..string.sub(pid,1,j-1)
			  openProcess(tonumber(pid))

				--print("PID " .. pid .. " open")

				--scan this process for the aob
				results=AOBScan("35 35 2E 35 35 2E 35 35 2E 35 35");

				if (results~=nil) then

					count=stringlist_getCount(results)

					if (count>0) then
						--found something
						pid_found = pid;

						break;
					end
				end

			end

		end

	end

end

if (pid_found~=nil) then
	
	debugProcess()
	print('PID 0x' .. string.format('%X',pid_found)  .. ' (' .. string.format('%d',pid_found) .. ')  found ! :)')
--
--	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'rejected') 
--	rejectBPAddress=memoryrecord_getAddress(memrec1) 
--	debug_setBreakpoint(rejectBPAddress, 1, bptWrite)
	
	local str_section = "[login func] ";
	local hits;
	
	hits = AOBSwap( 'd0 30 d0 66 c0 08 66 a8 10 27 61 99 10 d0 66 c0 08 66 a8 10 2c 01 61 f9 0f d0 66 c0 08 66 a9 10 66 f9 0f 2c 01 ab 2a 11 0f 00 00 29 d0 66 c0 08 66 a9 10 66 f9 0f 2c b6 0e ab 12 21 00 00 d0 2c 90 12 4f 91 0a 01 d0 66 c0 08 66 a8 10 26 61 99 10 d0 66 c0 08 66 a8 10 2c 91 12 61 f9 0f 47 d0 66 c0 08 66 a9 10 66 f9 0f 2c 92 12 ab 2a 11 0f 00 00 29 d0 66 c0 08 66 a9 10 66 f9 0f 2c 93 12 ab 12 19 00 00 d0 66 c0 08 66 a8 10 26 61 99 10 d0 66 c0 08 66 a8 10 2c 94 12 61 f9 0f 47 d0 66 c0 08 66 a9 10 66 f9 0f 2c 95 12 ab 2a 11 0f 00 00 29 d0 66 c0 08 66 a9 10 66 f9 0f 2c 96 12 ab 12 24 00 00 d0 66 c0 08 66 a8 10 26 61 99 10 d0 66 c0 08 66 a8 10 2c 94 12 61 f9 0f d0 66 9e 0a 2c 97 12 4f b4 01 01 47 d0 66 c0 08 66 a9 10 66 f9 0f 66 aa 10 24 04 0c 24 00 00 d0 66 c0 08 66 a8 10 26 61 99 10 d0 66 c0 08 66 a8 10 2c 98 12 61 f9 0f d0 66 9e 0a 2c 99 12 4f b4 01 01 47 d0 66 a7 0a 2c 01 14 19 00 00 d0 66 c0 08 66 a8 10 26 61 99 10 d0 66 c0 08 66 a8 10 2c 9a 12 61 f9 0f 47 d0 66 c0 08 66 ab 10 66 ac 10 66 f6 0f 2c 9d 12 14 24 00 00 d0 66 c0 08 66 a8 10 26 61 99 10 d0 66 c0 08 66 a8 10 2c 9e 12 61 f9 0f d0 66 9e 0a 2c 9f 12 4f b4 01 01 47 d0 66 c0 08 66 ad 10 66 ae 10 27 14 2c 00 00 d0 66 c0 08 66 a8 10 26 61 99 10 d0 2c a1 12 4f 91 0a 01 d0 66 c0 08 66 a8 10 2c a2 12 61 f9 0f d0 66 9e 0a 2c a3 12 4f b4 01 01 47 d0 66 c0 08 66 a8 10 2c a4 12 61 f9 0f d0 66 c0 08 66 a8 10 26 61 99 10 d0 66 c0 08 66 f4 0f 27 61 f5 0f d0 66 c0 08 66 af 10 26 61 99 10 d0 d0 66 c0 08 66 ab 10 66 ac 10 66 b0 10 68 a8 0a d0 d0 66 c0 08 66 a9 10 66 f9 0f 68 a6 0a d0 66 bc 08 66 b1 10 66 b2 10 d0 66 a6 0a 61 f9 0f d0 66 bc 08 66 b3 10 d0 66 a6 0a 61 f9 0f d0 66 bc 08 66 b1 10 66 b4 10 27 61 99 10 d0 66 bc 08 66 b1 10 66 b5 10 27 61 99 10 d0 66 bc 08 66 b1 10 66 b6 10 27 61 99 10 d0 66 a7 0a 2c ab 12 14 0e 00 00 d0 66 bc 08 66 b1 10 66 b4 10 26 61 99 10 d0 66 a7 0a 2c ac 12 14 0e 00 00 d0 66 bc 08 66 b1 10 66 b5 10 26 61 99 10 d0 66 a7 0a 2c ad 12 ab 2a 12 07 00 00 29 d0 66 9f 0a 26 ab 12 0e 00 00 d0 66 bc 08 66 b1 10 66 b6 10 26 61 99 10 d0 66 c0 08 66 a8 10 27 61 99 10 d0 4f d7 0a 00 d0 4f 8c 0a 00 d0 d0 66 a6 0a 68 9d 0a 47 ', 
			        'd0 30 d0 66 c0 08 66 a8 10 27 61 99 10 d0 66 c0 08 66 a8 10 2c 01 61 f9 0f d0 66 c0 08 66 a9 10 66 f9 0f 2c 01 ab 2a 11 0f 00 00 29 d0 66 c0 08 66 a9 10 66 f9 0f 2c b6 0e ab 12 21 00 00 d0 2c 90 12 4f 91 0a 01 d0 66 c0 08 66 a8 10 26 61 99 10 d0 66 c0 08 66 a8 10 2c 91 12 61 f9 0f 47 d0 66 c0 08 66 a9 10 66 f9 0f 2c 92 12 ab 2a 11 0f 00 00 29 d0 66 c0 08 66 a9 10 66 f9 0f 2c 93 12 ab 12 19 00 00 d0 66 c0 08 66 a8 10 26 61 99 10 d0 66 c0 08 66 a8 10 2c 94 12 61 f9 0f 47 d0 66 c0 08 66 a9 10 66 f9 0f 2c 95 12 ab 2a 11 0f 00 00 29 d0 66 c0 08 66 a9 10 66 f9 0f 2c 96 12 ab 12 24 00 00 d0 66 c0 08 66 a8 10 26 61 99 10 d0 66 c0 08 66 a8 10 2c 94 12 61 f9 0f d0 66 9e 0a 2c 97 12 4f b4 01 01 47 d0 66 c0 08 66 a9 10 66 f9 0f 66 aa 10 24 04 0c 24 00 00 d0 66 c0 08 66 a8 10 26 61 99 10 d0 66 c0 08 66 a8 10 2c 98 12 61 f9 0f d0 66 9e 0a 2c 99 12 4f b4 01 01 47 d0 66 a7 0a 2c 01 14 19 00 00 d0 66 c0 08 66 a8 10 26 61 99 10 d0 66 c0 08 66 a8 10 2c 9a 12 61 f9 0f 47 d0 66 c0 08 66 ab 10 66 ac 10 66 f6 0f 2c 9d 12 14 24 00 00 d0 66 c0 08 66 a8 10 26 61 99 10 d0 66 c0 08 66 a8 10 2c 9e 12 61 f9 0f d0 66 9e 0a 2c 9f 12 4f b4 01 01 47 d0 66 c0 08 66 a8 10 2c a4 12 61 f9 0f d0 66 c0 08 66 a8 10 26 61 99 10 d0 66 c0 08 66 f4 0f 27 61 f5 0f d0 66 c0 08 66 af 10 26 61 99 10 d0 d0 66 c0 08 66 ab 10 66 ac 10 66 b0 10 68 a8 0a d0 d0 66 c0 08 66 a9 10 66 f9 0f 68 a6 0a d0 66 bc 08 66 b1 10 66 b2 10 d0 66 a6 0a 61 f9 0f d0 66 bc 08 66 b3 10 d0 66 a6 0a 61 f9 0f d0 66 bc 08 66 b1 10 66 b4 10 27 61 99 10 d0 66 bc 08 66 b1 10 66 b5 10 27 61 99 10 d0 66 bc 08 66 b1 10 66 b6 10 27 61 99 10 d0 66 a7 0a 2c ab 12 14 0e 00 00 d0 66 bc 08 66 b1 10 66 b4 10 26 61 99 10 d0 66 a7 0a 2c ac 12 14 0e 00 00 d0 66 bc 08 66 b1 10 66 b5 10 26 61 99 10 d0 66 c0 08 66 a8 10 27 61 99 10 d0 66 8b 0a 66 d6 0d 24 33 61 be 11 d0 66 bc 08 66 b1 10 66 e4 11 d0 66 8b 0a 66 d6 0d 66 be 11 61 f9 0f d0 4f d7 0a 00 d0 4f 8c 0a 00 d0 d0 66 a6 0a 68 9d 0a d0 d0 66 a6 0a 85 61 fd 08 d0 d0 66 a4 0a 85 61 d0 09 d0 d0 66 a8 0a 75 61 fc 08 d0 66 bc 08 66 95 10 2c 88 14 61 f9 11 47 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 ')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end

	str_section = "[ignoreMe funct] ";

	hits = AOBSwap( 'd0 30 d0 66 9e 0a 2c ee 14 4f b4 01 01 d1 d0 66 bc 08 66 b7 10 66 b8 10 66 f9 0f 14 05 00 00 d0 4f 87 09 00 d0 66 bb 0a d1 4f bb 10 01 d0 66 8b 0a 66 d6 0d d0 66 bb 0a 61 e2 11 d0 66 8b 0a 4f c8 05 00 2c f0 14 d1 a0 2c f1 14 a0 82 d6 2c f2 14 d2 a0 2c b2 13 a0 d7 d0 66 bf 0a 2c ee 11 d3 55 01 4f 82 0d 01 d0 4f 9f 09 00 47 ', 
			        'd0 30 47 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 ')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end

	str_section = "[floodBan funct] ";

	hits = AOBSwap( 'd0 30 d0 26 68 a3 0a d0 66 bc 08 27 61 85 08 d0 4f b3 09 00 d0 2c f3 14 4f 91 0a 01 d0 66 9e 0a 2c f4 14 4f b4 01 01 47 ', 
			        'd0 30 47 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02  ')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end

	str_section = "[flagMe funct] ";

	hits = AOBSwap( 'd0 30 d1 2c f5 14 14 3e 00 00 d0 66 ab 0a 12 18 00 00 d0 66 8b 0a 66 d6 0d 26 61 e3 11 d0 66 8b 0a 4f c8 05 00 d0 4f dc 09 00 d0 26 68 c0 0a d0 26 68 cf 09 d0 66 97 0a 2c d6 08 20 d0 66 a6 0a 2c f7 14 4f f4 02 04 47 24 00 82 d6 10 1e 00 00 09 d0 66 d2 0a d2 66 e1 10 d1 14 0c 00 00 d0 66 9e 0a 2c f8 14 4f b4 01 01 47 d2 91 82 d6 d2 d0 66 d2 0a 66 aa 10 15 d6 ff ff d0 66 d2 0a d1 4f bb 10 01 d0 66 d2 0a 66 aa 10 d0 66 d4 0a 0e 36 00 00 d0 66 ab 0a 12 05 00 00 d0 4f dc 09 00 d0 66 9e 0a 2c f9 14 4f b4 01 01 d0 4f f9 09 00 d0 26 68 cf 09 d0 66 97 0a 2c d6 08 20 d0 66 a6 0a 2c f7 14 4f f4 02 04 47 d0 66 9e 0a 2c fa 14 4f b4 01 01 47 ', 
			        'd0 30 47 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 ')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end

	str_section = "[filterword funct] ";
	
	hits = AOBSwap( 'd0 30 24 00 d7 d1 82 d6 d1 46 ef 0d 00 85 d5 24 00 d7 10 23 00 00 09 d1 d0 66 ac 09 d3 66 e1 10 46 88 11 01 24 ff 13 0d 00 00 d0 66 9e 0a 2c ab 13 4f b4 01 01 26 48 c2 03 d3 d0 66 ac 09 66 fc 06 15 d1 ff ff d0 66 aa 09 4f b6 04 00 d0 26 68 a9 09 d0 66 97 0a 2c ac 13 20 d1 d0 66 a6 0a d0 66 d0 08 d0 66 95 09 d0 66 9d 0a 4f f4 02 07 d0 66 9e 0a 2c ad 13 d0 66 a6 0a a0 4f b4 01 01 27 48 ', 
			        'd0 30 24 00 d7 d1 82 d6 d1 46 ef 0d 00 85 d5 d0 66 97 0a 2c ac 13 20 d1 d0 66 a6 0a d0 66 d0 08 d0 66 95 09 d0 66 a6 0a 4f f4 02 07 27 48 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 ')

					
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end

	str_section = "[connectApp funct] ";
 	
	hits = AOBSwap( 'd0 30 d0 66 b4 0a 12 10 00 00 d0 4f f0 08 00 d0 66 c0 08 66 af 10 26 61 99 10 d0 66 97 0a d0 66 9b 0a d0 66 c6 0a a0 d0 66 9d 0a d0 66 a7 0a d0 66 a0 0a d0 66 a2 0a d0 66 a8 0a d0 66 a4 0a d0 66 9f 0a d0 66 a9 0a d0 66 a1 0a d0 66 b7 0a 4f db 10 0b 47', 
			        'd0 30 d0 66 b4 0a 12 10 00 00 d0 4f f0 08 00 d0 66 c0 08 66 af 10 26 61 99 10 d0 66 97 0a d0 66 9b 0a d0 66 c6 0a a0 d0 66 a6 0a d0 66 a7 0a d0 66 a0 0a d0 66 a2 0a d0 66 a8 0a d0 66 a4 0a d0 66 9f 0a d0 66 a9 0a d0 66 a1 0a d0 66 b7 0a 4f db 10 0b 47')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end
	
	str_section = "[changeRoom funct] ";

	hits = AOBSwap( 'd0 30 21 82 63 09 21 82 63 0a 21 82 63 0b d1 66 bb 0d 66 ac 10 66 f6 0f 82 d6 d0 d2 68 c6 0a d1 66 bb 0d 66 ac 10 66 fb 10 82 d7 d1 66 bb 0d 66 ac 10 66 fc 10 82 63 04 d1 66 bb 0d 66 ac 10 66 fd 10 82 63 05 d0 d1 66 bb 0d 66 ac 10 66 fe 10 68 93 09 d1 66 bb 0d 66 ac 10 66 ea 10 82 63 06 d1 66 bb 0d 66 ac 10 66 e8 10 82 63 07 d1 66 bb 0d 66 ac 10 66 e6 10 82 63 08 d2 d0 66 ce 0a 14 01 00 00 47 d2 20 14 01 00 00 47 d0 66 b6 0a d0 66 93 09 14 01 00 00 47 d1 66 bb 0d 66 ac 10 66 f6 0f 60 80 0e 14 01 00 00 47 62 04 62 06 0f 3c 00 00 d0 66 9e 0a 2c 93 13 2c 94 13 2c 95 13 4f a6 01 03 2c 96 13 d0 66 93 09 a0 2c 97 13 a0 62 06 a0 2c 98 13 a0 82 63 09 d0 66 bf 0a 2c ee 11 62 09 55 01 4f 82 0d 01 d0 4f 9f 09 00 47 62 05 12 2c 00 00 d0 66 9e 0a 2c 93 13 2c 94 13 2c 99 13 4f a6 01 03 2c 9a 13 82 63 0a d0 66 bf 0a 2c ee 11 62 0a 55 01 4f 82 0d 01 d0 4f 9f 09 00 47 62 04 d0 66 c2 0a 0e 35 00 00 d0 66 9e 0a 2c 93 13 2c 94 13 2c 9b 13 4f a6 01 03 2c 9c 13 d0 66 93 09 a0 2c 9d 13 a0 82 63 0b d0 66 bf 0a 2c ee 11 62 0b 55 01 4f 82 0d 01 d0 4f 9f 09 00 47 d3 2c f0 12 14 01 00 00 47 d3 2c 01 ab 96 2a 12 04 00 00 29 62 08 96 12 26 00 00 d0 d3 68 91 09 d0 66 bc 08 d0 66 ce 08 56 01 61 ff 10 d0 66 bf 08 26 61 85 08 d0 66 bf 08 66 80 11 4f 81 11 00 47 d0 26 68 cd 0a d0 66 bc 08 66 82 11 4f 83 11 00 d0 66 bc 08 66 82 11 2c 92 0b 2c a1 13 55 01 4f 84 11 01 d0 4f b3 09 00 d0 4f d6 0a 00 47', 
			        'd0 30 21 82 63 09 21 82 63 0a 21 82 63 0b d1 66 bb 0d 66 ac 10 66 f6 0f 82 d6 d0 d2 68 c6 0a d1 66 bb 0d 66 ac 10 66 fb 10 82 d7 d1 66 bb 0d 66 ac 10 66 fc 10 82 63 04 d1 66 bb 0d 66 ac 10 66 fd 10 82 63 05 d0 d1 66 bb 0d 66 ac 10 66 fe 10 68 93 09 d1 66 bb 0d 66 ac 10 66 ea 10 82 63 06 d1 66 bb 0d 66 ac 10 66 e8 10 82 63 07 d1 66 bb 0d 66 ac 10 66 e6 10 82 63 08 d2 d0 66 ce 0a 14 01 00 00 47 d2 20 14 01 00 00 47 d0 66 b6 0a d0 66 93 09 14 01 00 00 47 d1 66 bb 0d 66 ac 10 66 f6 0f 60 80 0e 14 01 00 00 47 d3 2c 01 ab 96 2a 12 04 00 00 29 62 08 96 12 38 00 00 d0 d0 66 a6 0a 85 61 fd 08 d0 d0 66 a4 0a 85 61 d0 09 d0 d3 68 91 09 d0 66 bc 08 d0 66 ce 08 56 01 61 ff 10 d0 66 bf 08 26 61 85 08 d0 66 bf 08 66 80 11 4f 81 11 00 47 d0 d0 66 fd 08 85 61 a6 0a d0 d0 66 d0 09 85 61 a4 0a d0 2c ab 12 68 a7 0a d0 26 68 cd 0a d0 66 bc 08 66 82 11 4f 83 11 00 d0 66 bc 08 66 82 11 2c 92 0b 2c a1 13 55 01 4f 84 11 01 d0 4f b3 09 00 d0 4f d6 0a 00 47 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 ')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end
	
	str_section = "[decryptStringRijndael function] ";

	hits = AOBSwap( 'd0 30 20 85 d6 5d 71 4a 71 00 80 71 d5 d1 d0 66 bf 08 66 80 11 66 f9 0f d0 66 e6 09 2c d1 0c 46 7c 03 85 d6 d2 d0 66 91 09 13 2e 00 00 d0 66 bf 08 66 80 11 2c 01 61 f9 0f d0 66 bf 08 66 c9 11 26 61 99 10 d0 66 bf 08 66 80 11 4f 81 11 00 d0 66 9e 0a 2c 92 14 4f b4 01 01 47 d2 d0 66 91 09 14 7a 00 00 d0 d2 68 b7 0a d0 66 9e 0a 2c 93 14 4f b4 01 01 d0 66 bf 08 27 61 85 08 d0 66 bf 08 66 c9 11 27 61 99 10 d0 26 68 cd 0a d0 66 bc 08 66 82 11 4f 83 11 00 d0 66 bc 08 66 82 11 2c 92 0b 2c 94 14 55 01 4f 84 11 01 d0 4f 87 09 00 d0 4f b6 09 00 d0 4f b3 09 00 d0 66 bc 08 20 61 ff 10 d0 66 bf 08 66 80 11 2c 01 61 f9 0f d0 66 bf 08 66 c9 11 27 61 99 10 d0 4f d6 0a 00 47 47  ', 
			        'd0 30 20 85 d6 5d 71 4a 71 00 80 71 d5 d1 d0 66 bf 08 66 80 11 66 f9 0f d0 66 e6 09 2c d1 0c 46 7c 03 85 d6 d0 2c a0 14 85 61 a6 0a d0 2c a0 14 85 61 a4 0a d0 2c a0 14 68 a7 0a d0 d0 66 91 09 85 61 b7 0a d0 66 9e 0a 2c 93 14 4f b4 01 01 d0 66 bf 08 27 61 85 08 d0 66 bf 08 66 c9 11 27 61 99 10 d0 26 68 cd 0a d0 66 bc 08 66 82 11 4f 83 11 00 d0 66 bc 08 66 82 11 2c 92 0b 2c 94 14 55 01 4f 84 11 01 d0 4f 87 09 00 d0 4f b6 09 00 d0 4f b3 09 00 d0 66 bc 08 20 61 ff 10 d0 66 bf 08 66 80 11 2c 01 61 f9 0f d0 66 bf 08 66 c9 11 27 61 99 10 d0 4f d6 0a 00 47 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 ')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end
	
	str_section = "[User info] ";

	hits = AOBSwap( 'd0 30 d0 66 bc 08 66 82 11 d1 66 ee 04 46 92 11 01 66 93 11 82 d6 d0 66 bc 08 66 82 11 d1 66 ee 04 46 92 11 01 66 f7 10 82 d7 d0 66 bc 08 66 82 11 d1 66 ee 04 46 92 11 01 66 f5 10 82 63 04 d0 66 bc 08 66 82 11 d1 66 ee 04 46 92 11 01 66 f4 10 82 63 05 d0 66 bc 08 66 82 11 d1 66 ee 04 46 92 11 01 66 f2 10 82 63 06 d0 66 bc 08 66 82 11 d1 66 ee 04 46 92 11 01 66 f3 10 82 63 07 62 04 24 12 0c 05 00 00 24 12 82 63 04 d0 66 bc 08 66 8e 11 2c c1 13 62 05 a0 2c c2 13 a0 62 04 a0 2c c3 13 a0 61 8f 11 62 04 60 80 0e 13 0b 00 00 d0 66 bc 08 66 8e 11 4f 90 11 00 47 ', 
			        'd0 30 d0 66 bc 08 66 82 11 d1 66 ee 04 46 92 11 01 66 93 11 82 d6 d0 66 bc 08 66 82 11 d1 66 ee 04 46 92 11 01 66 f7 10 82 d7 d0 66 bc 08 66 82 11 d1 66 ee 04 46 92 11 01 66 f5 10 82 63 04 d0 66 bc 08 66 82 11 d1 66 ee 04 46 92 11 01 66 f4 10 82 63 05 d0 66 bc 08 66 82 11 d1 66 ee 04 46 92 11 01 66 f2 10 82 63 06 d0 66 bc 08 66 82 11 d1 66 ee 04 46 92 11 01 66 f3 10 82 63 07 62 05 62 04 a0 82 63 05 d2 62 06 a0 82 63 04 d0 66 bc 08 66 8e 11 2c c1 13 62 05 a0 2c c2 13 a0 62 04 a0 2c c3 13 a0 61 8f 11 d0 66 bc 08 66 8e 11 4f 90 11 00 47 02 02 02 02 02 02 02 ')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end
	
	str_section = "[syncEventHandler2 function] ";
	hits = AOBSwap( 'd3 66 eb 10 2c 01 14 01 00 00 47 d3 66 eb 10 d0 66 bc 08 66 b7 10 66 b8 10 66 f9 0f 14 15 00 00 d0 66 bc 08 66 b7 10 66 c9 10 d3 66 ec 10 46 ed 10 00 61 b0 10 d3 66 eb 10 d0 66 bc 08 66 ee 10 66 b8 10 66 f9 0f 14 15 00 00 d0 66 bc 08 66 ee 10 66 c9 10 d3 66 ec 10 46 ed 10 00 61 b0 10 d3 66 eb 10 d0 66 bc 08 66 ef 10 66 b8 10 66 f9 0f 14 15 00 00 d0 66 bc 08 66 ef 10 66 c9 10 d3 66 ec 10 46 ed 10 00 61 b0 10 d0 66 b6 0a 2c e1 12 ab 2a 12 09 00 00 29 d0 66 96 09 25 9f 01 b0 12 8a 00 00 d3 66 f0 10 2c fe 12 ab 2a 11 09 00 00 29 d3 66 f1 10 2c ac 12 ab 12 70 00 00 d0 66 9e 09 2c 92 0b d3 66 eb 10 2c ee 06 d3 66 eb 10 2c ff 12 d3 66 f1 10 2c a1 0a d3 66 f0 10 2c 80 13 d3 66 f2 10 2c 81 13 d3 66 f3 10 2c 82 13 d3 66 f4 10 2c 83 13 d3 66 f5 10 2c 84 13 d3 66 f6 10 2c 86 13 d3 66 f7 10 55 0a 4f d7 05 01 d0 66 9e 09 d0 66 c1 0a 2c ff 12 2c 92 0b 56 03 60 0b 66 f8 10 60 0b 66 f9 10 56 02 4f 8c 07 02 d0 66 b6 0a 2c e1 12 ab 96 2a 12 09 00 00 29 d0 66 97 09 25 9f 01 b0 12 8a 00 00 d3 66 f0 10 2c fe 12 ab 2a 11 09 00 00 29 d3 66 f1 10 2c ac 12 ab 12 70 00 00 d0 66 9e 09 2c 92 0b d3 66 eb 10 2c ee 06 d3 66 eb 10 2c ff 12 d3 66 f1 10 2c a1 0a d3 66 f0 10 2c 80 13 d3 66 f2 10 2c 81 13 d3 66 f3 10 2c 82 13 d3 66 f4 10 2c 83 13 d3 66 f5 10 2c 84 13 d3 66 f6 10 2c 86 13 d3 66 f7 10 55 0a 4f d7 05 01 d0 66 9e 09 d0 66 c1 0a 2c ff 12 2c 92 0b 56 03 60 0b 66 f8 10 60 0b 66 f9 10 56 02 4f 8c 07 02 d0 66 b6 0a 2c e1 12 ab 96 2a 12 09 00 00 29 d0 66 97 09 25 9f 01 ad 12 70 00 00 d0 66 9e 09 2c 92 0b d3 66 eb 10 2c ee 06 d3 66 eb 10 2c ff 12 d3 66 f1 10 2c a1 0a d3 66 f0 10 2c 80 13 d3 66 f2 10 2c 81 13 d3 66 f3 10 2c 82 13 d3 66 f4 10 2c 83 13 d3 66 f5 10 2c 84 13 d3 66 f6 10 2c 86 13 d3 66 f7 10 55 0a 4f d7 05 01 d0 66 9e 09 d0 66 c1 0a 2c ff 12 2c 92 0b 56 03 60 0b 66 f8 10 60 0b 66 f9 10 56 02 4f 8c 07 02 d0 66 b6 0a 2c e1 12 ab 2a 12 09 00 00 29 d0 66 96 09 25 9f 01 ad 12 70 00 00 d0 66 9e 09 2c 92 0b d3 66 eb 10 2c ee 06 d3 66 eb 10 2c ff 12 d3 66 f1 10 2c a1 0a d3 66 f0 10 2c 80 13 d3 66 f2 10 2c 81 13 d3 66 f3 10 2c 82 13 d3 66 f4 10 2c 83 13 d3 66 f5 10 2c 84 13 d3 66 f6 10 2c 86 13 d3 66 f7 10 55 0a 4f d7 05 01 d0 66 9e 09 d0 66 c1 0a 2c ff 12 2c 92 0b 56 03 60 0b 66 f8 10 60 0b 66 f9 10 56 02 4f 8c 07 02 ', 
			       'd0 66 9e 09 2c 92 0b d3 66 eb 10 2c ee 06 d3 66 eb 10 2c ff 12 d3 66 f1 10 2c a1 0a d3 66 f0 10 2c 80 13 d3 66 f2 10 2c 81 13 d3 66 f3 10 2c 82 13 d3 66 f4 10 2c 83 13 d3 66 f5 10 2c 84 13 d3 66 f6 10 2c c0 13 d3 66 93 11 55 0a 4f d7 05 01 d0 66 9e 09 d0 66 c1 0a 2c ff 12 2c 92 0b 56 03 60 0b 66 f8 10 60 0b 66 f9 10 56 02 4f 8c 07 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 ')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end
	
	str_section = "[Priv rooms] ";
	hits = AOBSwap( '2c ec 12 2c ed 12 2c ee 12 2c 01 2c ef 12 2c f0 12 2c f1 12 d3 66 e7 10 55 06 4f d7 05 01', 
			       '2c ec 12 d3 66 e8 10 2c ee 06 d3 66 fb 0f 2c f1 12 d3 66 e7 10 55 05 4f d7 05 01 02 02 02')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end
	
	str_section = "[countdown function] ";
	hits = AOBSwap( 'd0 30 d0 66 fb 08 d0 66 fe 08 66 bc 10 a1 75 d6 d0 d0 d2 46 fc 09 01 68 fd 08 d0 2a d7 66 fc 08 91 63 04 d3 62 04 61 fc 08 08 04 08 03 d0 66 fd 08 2c b6 12 14 2e 00 00 d0 66 a7 0a 2c ac 12 ab 2a 12 07 00 00 29 d0 66 ab 0a 26 ab 12 11 00 00 d0 66 fe 08 4f f0 06 00 d0 66 fe 08 4f bd 10 00 47 d0 4f 86 09 00 47 ', 
			        'd0 30 47 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 ')
				   
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end
	
	str_section = "[countdown4 function] ";
	hits = AOBSwap( 'd0 30 d0 66 d1 09 d0 66 d2 09 66 bc 10 a1 75 d6 d0 d0 d2 46 fc 09 01 68 d0 09 d0 66 d0 09 2c b6 12 14 15 00 00 d0 4f dc 09 00 d0 26 68 cf 09 d0 66 9e 0a 2c c7 13 4f b4 01 01 47 ', 
			        'd0 30 47 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02')
				   
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end
	
	str_section = "[tempo66Expired function] ";
	hits = AOBSwap( 'd0 30 d0 4f 87 09 00 d0 66 bc 08 66 9f 10 26 61 99 10 47 ', 
			        'd0 30 47 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 ')
				   
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end
	
	str_section = "[SendMsg filters] ";
	hits = AOBSwap( 'd0 30 21 82 d6 21 82 d7 d0 66 bc 08 66 95 10 66 f9 0f 2c 01 14 01 00 00 47 d0 66 a9 09 12 25 00 00 2c a8 13 82 d6 d0 66 bf 0a 2c ee 11 d2 55 01 4f 82 0d 01 d0 4f 9f 09 00 d0 66 bc 08 66 95 10 2c 01 61 f9 0f 47 d0 66 c0 0a 12 24 00 00 2c a9 13 82 d7 d0 66 9e 0a 2c aa 13 4f b4 01 01 d0 66 bf 0a 2c ee 11 d3 55 01 4f 82 0d 01 d0 4f 9f 09 00 47 d0 66 bc 08 66 95 10 66 f9 0f 82 d5 d1 2c 01 13 12 00 00 d0 d1 4f b0 09 01 d0 66 bc 08 66 95 10 2c 01 61 f9 0f 47 ', 
			        'd0 30 21 82 d6 21 82 d7 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 d0 66 bc 08 66 95 10 66 f9 0f 82 d5 d1 2c 01 13 12 00 00 d0 d1 4f b0 09 01 d0 66 bc 08 66 95 10 2c 01 61 f9 0f 47 ')
				   
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end

	str_section = "[myLikes frame2] ";

	
	hits = AOBSwap( 'd0 66 8b 0a 66 d6 0d 66 be 11 60 80 0e 14 23 00 00 d0 66 8b 0a 66 d6 0d 24 00 61 be 11 d0 66 bc 08 66 b1 10 66 e4 11 d0 66 8b 0a 66 d6 0d 66 be 11 61 f9 0f ', 
			        '02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 d0 66 8b 0a 66 d6 0d 24 33 61 be 11 d0 66 bc 08 66 b1 10 66 e4 11 d0 66 8b 0a 66 d6 0d 66 be 11 61 f9 0f ')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end

	str_section = "[myLikes setVotesNumber] ";

	hits = AOBSwap( 'd0 30 d0 66 bc 08 66 b1 10 66 e4 11 d1 61 f9 0f d0 66 8b 0a 66 d6 0d d1 61 be 11 d0 66 8b 0a 4f c8 05 00 47 ', 
			        'd0 30 02 02 02 02 02 02 02 02 02 02 02 02 02 d0 66 8b 0a 66 d6 0d 24 33 61 be 11 d0 66 8b 0a 4f c8 05 00 47')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end
	
	-- d0 66 bc 08 66 85 11 66 86 11 66 f9 0f 82 d5 d0 66 90 09 82 d6 2c a4 13 82 d7 d0 66 97 0a 2c b3 14 20 d1 d3 d2 d0 66 95 09 4f f4 02 06
	-- QUEdan pendiente los mensajes PV, probe de poner este AOB en filterword por el tema de maxstack >= 7, y perdiamos la conexion con el serv
	-- tal vez estan filtrando por IP arriba.
	
	str_section = "[sendPVMsg func] ";
	
	hits = AOBSwap( 'd0 30 21 82 63 04 d0 66 bc 08 66 85 11 66 86 11 66 f9 0f 82 d5 d0 66 90 09 82 d6 2c a4 13 82 d7 d1 2c 01 ab 96 2a 12 08 00 00 29 d0 66 90 09 20 ab 96 12 37 00 00 d0 66 9f 0a 27 14 2e 00 00 2c a5 13 82 63 04 d0 66 bf 0a 2c ee 11 62 04 55 01 4f 82 0d 01 d0 4f 9f 09 00 d0 2c a6 13 4f 91 0a 01 d0 66 9e 0a 2c a7 13 4f b4 01 01 47 47 ', 
			        'd0 30 47 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 02 ')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end

	str_section = "[mainTimeOut replaced _ ] ";
	
	hits = AOBSwap( '13 6D 61 69 6E 54 69 6D 65 4F 75 74', 
			        '13 20 00 00 00 00 00 00 00 00 00 00 ')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end

	str_section = "[msgFromClient replaced LIKE RECEIVED] ";
	
	hits = AOBSwap( '4C 49 4B 45 20 52 45 43 45 49 56 45 44', 
			        '6D 73 67 46 72 6F 6D 43 6C 69 65 6E 74')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end

	
	-- Esta pendiente modificar createNR, pero tengo problemas con el tamaño de ambas funciones. Tal vez se pueda hacer en varias
	-- funciones ?
	str_section = "[createRoomHandler func] ";
	
	hits = AOBSwap( 'd0 30 2c 8e 14 d6 d0 66 bf 0a 2c ee 11 d2 55 01 4f 82 0d 01 d0 4f 9f 09 00 d0 2c 8f 14 4f da 0a 01 d0 66 9e 0a 2c 90 14 4f b4 01 01 47 ', 
			        'd0 30 d0 66 bc 08 d0 66 ce 08 56 01 61 ff 10 d0 66 c1 08 26 61 85 08 d0 66 c1 08 66 c6 11 4f 81 11 00 47 02 02 02 02 02 02 02 02 02 02' )
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end
	
	str_section = "[Tracker OFF] ";
	
	hits = AOBSwap( 'd0 66 9e 0a ?? ?? ?? 4f b4 01 01', 
			       '02 02 02 02 02 02 02 02 02 02 02')
	
	if( hits > 0 ) then
		print(str_section .. 'patched! (' .. hits .. ' hits)'  )
	else
		print(str_section .. 'WARNING: Could not patch :(')
	end


	
else
	print('AOB not found')
end
