Society = {}
Society.__index = Society

function Society:new(id, name, label, registration_number, account)
    local self = setmetatable({}, Society)
    self.id = id
    self.name = name
    self.label = label
    self.registration_number = registration_number
    self.account = account or 0
    self.employees = {}
    return self
end

function Society:loadFromDB(societyId)
    local result, error = MySQL.prepare.await('SELECT s.name, s.label, s.registration_number, a.balance FROM society s JOIN society_account a ON s.id = a.society_id WHERE s.id = ?', {societyId})
    if error then
        return nil, "Failed to load society: " .. error
    end

    if result then
        return Society:new(societyId, result.name, result.label, result.registration_number, result.balance)
    else
        return nil, "Society not found"
    end
end

function Society:addEmployee(identifier, name, grade)
    local exists, error = MySQL.prepare.await('SELECT * FROM society_employee WHERE identifier = ? AND society_id = ?', {identifier, self.id})
    if error then
        return false, "Error querying employee existence: " .. error
    end

    if exists then
        return false, "Player is already in the society"
    end

    local _, errorInsert = MySQL.prepare.await('INSERT INTO society_employee (identifier, name, grade, society_id) VALUES (?, ?, ?, ?)', {identifier, name, grade, self.id})
    if errorInsert then
        return false, "Error inserting employee: " .. errorInsert
    end

    self.employees[identifier] = { name = name, grade = grade }
    return true, "Player added to the society"
end

function Society:removeEmployee(identifier)
    local exists, error = MySQL.prepare.await('SELECT * FROM society_employee WHERE identifier = ? AND society_id = ?', {identifier, self.id})
    if error then
        return false, "Error querying employee existence: " .. error
    end

    if not exists then
        return false, "Player is not in the society"
    end

    local _, errorDelete = MySQL.prepare.await('DELETE FROM society_employee WHERE identifier = ? AND society_id = ?', {identifier, self.id})
    if errorDelete then
        return false, "Error removing employee: " .. errorDelete
    end

    self.employees[identifier] = nil
    return true, "Player removed from the society"
end

function Society:promoteEmployee(identifier)
    local employee = self.employees[identifier]

    if not employee then
        return false, "Player is not in the society"
    end

    local nextGrade = employee.grade + 1
    if not self.grades[nextGrade] then
        return false, "No grade to promote to"
    end

    local _, error = MySQL.prepare.await('UPDATE society_employee SET grade = ? WHERE identifier = ? AND society_id = ?', {nextGrade, identifier, self.id})
    if error then
        return false, "Error promoting employee: " .. error
    end

    employee.grade = nextGrade
    return true, "Player promoted"
end

function Society:addMoney(amount)
    if type(amount) ~= "number" then
        return false, "Amount must be a number"
    end

    if amount <= 0 then
        return false, "Amount must be positive"
    end

    self.account = self.account + amount
    local success, error = self:saveAccount()
    if not success then
        return false, "Failed to add money: " .. error
    end
    return true, "Money added to the society"
end

function Society:removeMoney(amount)
    if type(amount) ~= "number" then
        return false, "Amount must be a number"
    end

    if amount <= 0 then
        return false, "Amount must be positive"
    end

    if self.account < amount then
        return false, "Not enough money in the society"
    end

    self.account = self.account - amount
    local success, error = self:saveAccount()
    if not success then
        return false, "Failed to remove money: " .. error
    end
    return true, "Money removed from the society"
end

function Society:getBalance()
    return self.account
end

function Society:saveAccount()
    local _, error = MySQL.prepare.await('UPDATE society_account SET balance = ? WHERE society_id = ?', {self.account, self.id})
    if error then
        return false, error
    end
    return true
end

function Society:loadEmployees()
    local employees, error = MySQL.prepare.await('SELECT * FROM society_employee WHERE society_id = ?', {self.id})

    if error then
        return false, "Error loading employees: " .. error
    end

    if not employees or #employees == 0 then
        self.employees = {}
        return true
    end

    self.employees = {}

    for _, employee in pairs(employees) do
        self.employees[employee.identifier] = {
            name = employee.name,
            grade = employee.grade
        }
    end

    return true
end