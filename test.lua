require("aeslua");
local util = require("aeslua.util");

IP_key = "79566214843925";
room_key = "pZwq50ol87t";

cipher = aeslua.encrypt(IP_key, "a", aeslua.AES128, aeslua.ECBMODE);
decrypted = aeslua.decrypt(IP_key, cipher, aeslua.AES128, aeslua.ECBMODE);

print('Encrypted: ' .. util.toHexString(cipher));

print("TRUE: 43d5b32f13c1e5c6b96935452f8c8efc");

print('Decrypted: ' .. decrypted);
