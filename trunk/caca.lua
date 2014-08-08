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
	
	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'goingToRoom') 
	bpAddress=memoryrecord_getAddress(memrec1) 
	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'roomID') 
	curr_room_ID = memoryrecord_getValue(memrec1);
	
	dest_room_ID = stringlist_getString(listbox_getItems(MyForm_rooms_list), SelectedItemIndex)	
	print('curr_room_ID ' .. curr_room_ID .. " going to " .. dest_room_ID )
	
	if not bpSet then 
		
		bpSet = true;
		
		print('Breaking on write to ' .. bpAddress)
		debug_setBreakpoint(bpAddress, 1, bptAccess)
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
	print('PID ' .. string.format('%X',pid_found)  .. ' found ! :)')
--
--	memrec1=addresslist_getMemoryRecordByDescription(addresslist, 'rejected') 
--	rejectBPAddress=memoryrecord_getAddress(memrec1) 
--	debug_setBreakpoint(rejectBPAddress, 1, bptWrite)
	
else
	print('AOB not found')
end
