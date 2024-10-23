local licenses = {}

MySQL.ready(function()
	local p = promise.new()
	MySQL.query('SELECT type, label FROM licenses', function(result)
		licenses = result
		p:resolve(true)
	end)
	Citizen.Await(p)
    PL.Print.Info(('%s Licenses Loaded'):format(#licenses))
end)

local function AddLicenseToPlayer(identifier, licenseType, cb)
	MySQL.insert('INSERT INTO user_licenses (type, owner) VALUES (?, ?)', {licenseType, identifier}, function(rowsChanged)
		if cb then
			cb(rowsChanged)
		end
	end)
end

local function RemoveLicenseFromPlayer(identifier, licenseType, cb)
	MySQL.update('DELETE FROM user_licenses WHERE type = ? AND owner = ?', {licenseType, identifier}, function(rowsChanged)
		if cb then
			cb(rowsChanged)
		end
	end)
end

local function GetLicenseName(licenseType, cb)
	MySQL.scalar('SELECT label FROM licenses WHERE type = ?', {licenseType}, function(result)
		if cb then
			cb({type = licenseType, label = result})
		end
	end)
end

local function GetPlayerLicenses(identifier, cb)
	MySQL.query('SELECT user_licenses.type, licenses.label FROM user_licenses LEFT JOIN licenses ON user_licenses.type = licenses.type WHERE owner = ?', {identifier},
	function(result)
		if cb then
			cb(result)
		end
	end)
end

local function CheckPlayerLicense(identifier, licenseType, cb)
	MySQL.scalar('SELECT type FROM user_licenses WHERE type = ? AND owner = ?', {licenseType, identifier}, function(result)
		if cb then
			if result then
				cb(true)
			else
				cb(false)
			end
		end
	end)
end

local function GetLicensesList(cb)
	cb(licenses)
end

local function IsLicenseValid(licenseType)
	local flag = false
	for i=1,#licenses do
		if licenses[i].type == licenseType then
			flag = true
			break
		end
	end
	return flag
end

RegisterNetEvent('primordial_core:server:addLicense')
AddEventHandler('primordial_core:server:addLicense', function(target, licenseType, cb)
	local sPlayer = PL.GetPlayerFromId(target)
	if sPlayer then
		if IsLicenseValid(licenseType) then
			AddLicenseToPlayer(sPlayer.getIdentifier(), licenseType, cb)
		else
			PL.Print.Error(('Missing license type in db ^5%s^0 or someone try to use lua executor ID: ^5%s^0'):format(licenseType, target))
		end
	end
end)

RegisterNetEvent('primordial_core:server:removeLicense')
AddEventHandler('primordial_core:server:removeLicense', function(target, licenseType, cb)
	local sPlayer = PL.GetPlayerFromId(source)
	if sPlayer then 
		if AllowedJobs[sPlayer.getSociety().name] then
			local xTarget = PL.GetPlayerFromId(target)
			if xTarget then
				RemoveLicenseFromPlayer(xTarget.getIdentifier(), licenseType, cb)
			end
		else
			lib.notify(sPlayer.source, {
				title = 'Your job is not allowed to remove the license',
				type = 'error',
			})
		end
	end
end)

AddEventHandler('primordial_core:server:getLicense', function(licenseType, cb)
	GetLicenseName(licenseType, cb)
end)

AddEventHandler('primordial_core:server:getLicenses', function(target, cb)
	local sPlayer = PL.GetPlayerFromId(target)
	if sPlayer then
		GetPlayerLicenses(sPlayer.getIdentifier(), cb)
	end
end)

AddEventHandler('primordial_core:server:checkLicense', function(target, licenseType, cb)
	local sPlayer = PL.GetPlayerFromId(target)
	if sPlayer then
		CheckPlayerLicense(sPlayer.getIdentifier(), licenseType, cb)
	end
end)

AddEventHandler('primordial_core:server:getLicensesList', function(cb)
	GetLicensesList(cb)
end)

lib.callback.register('primordial_core:server:getLicense', function(source, functionCallback, licenseType)
	local sPlayer = PL.GetPlayerFromId(source)
	if sPlayer then
		GetLicenseName(licenseType, functionCallback)
	end
end)

lib.callback.register('primordial_core:server:getLicenses', function(source, functionCallback, target)
	local sPlayer = PL.GetPlayerFromId(target)
	if sPlayer then
		GetPlayerLicenses(sPlayer.getIdentifier(), functionCallback)
	end
end)

lib.callback.register('primordial_core:server:checkLicense', function(source, functionCallback, target, licenseType)
	local sPlayer = PL.GetPlayerFromId(target)
	if sPlayer then
		CheckPlayerLicense(sPlayer.getIdentifier(), licenseType, functionCallback)
	end
end)

lib.callback.register('primordial_core:server:getLicensesList', function(source, functionCallback)
	GetLicensesList(functionCallback)
end)