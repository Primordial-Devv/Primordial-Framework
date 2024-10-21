Framework = {}

function Framework.PL()
    return GetResourceState("primordial_core") ~= "missing"
end

function Framework.QBCore()
    return GetResourceState("qb-core") ~= "missing"
end
