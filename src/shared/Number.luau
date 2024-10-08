local suffixes = {
	"", "k", "m", "b", "t", "qd", "qn", "sx", "sp",
	"oc", "No", "De", "UDe", "DDe", "TDe", "QdDe", "QnDe", "SxDe",
	"SpDe", "OcDe", "NoDe", "Vt", "UVt", "DVt", "TVt", "QdVt", "QnVt",
	"SxVt", "SpVt", "OcVt", "NoVt", "Tg", "UTg", "DTg", "TTg", "QdTg",
	"QnTg", "SxTg", "SpTg", "OcTg", "NoTg", "qg", "Uqg", "Dqg", "Tqg",
	"Qdqg", "Qnqg", "Sxqg", "Spqg", "Ocqg", "Noqg", "Qg", "UQg", "DQg",
	"TQg", "QdQg", "QnQg", "SxQg", "SpQg", "OcQg", "NoQg", "sg", "Usg",
	"Dsg", "Tsg", "Qdsg", "Qnsg", "Sxsg", "Spsg", "Ocsg", "Nosg", "Sg",
	"USg", "DSg", "TSg", "QdSg", "QnSg", "SxSg", "SpSg", "OcSg", "NoSg",
	"Og", "UOg", "DOg", "TOg", "QdOg", "QnOg", "SxOg", "SpOg", "OcOg",
	"NoOg", "Ng", "UNg", "DNg", "QdNg", "QnNg", "SxNg", "SpNg", "OcNg",
	"NoNg", "Ce", "UCe", "DCe"
}

local Number = {}

function Number.isNan(val1: number)
    return val1 ~= val1
end

function Number.eq(val1: number, val2: number)
    return val1 == val2
end

function Number.me(val1: number, val2: number)
    return val1 > val2
end

function Number.le(val1: number, val2: number)
    return val1 < val2
end

function Number.meeq(val1: number, val2: number)
    return (val1 > val2) or (val1 == val2)
end

function Number.leeq(val1: number, val2: number)
    return (val1 < val2) or (val1 == val2)
end

function Number.ne(val1: number, val2: number)
    if val1 ~= val1 or val2 ~= val2 then return end
    return not (val1 == val2)
end

function Number.correct(val1: number)
    if val1 == 1/0 then
        val1 = 0
    elseif val1 == 0/0 then
        val1 = 0
    elseif val1 == -1/0 then
        val1 = 0
    elseif val1 == -0/0 then
        val1 = 0
    end
    return val1
end

function Number.add(val1: number, val2: number)
    return val1 + val2
end

function Number.div(val1: number, val2: number)
    return val1 / val2
end

function Number.sub(val1: number, val2: number)
    local sub = val1 - val2
    if sub <= 0 then return 0 end
    return sub
end

function Number.mul(val1: number, val2: number)
    return val1*val2
end

function Number.pow(base: number, exp: number)
    if exp == 0 then
        return 1
    end
    local res = 1
    local pos = exp > 0
    if not pos then
        exp = 0- exp
    end
    while exp > 0 do
        res = res*base
        exp = exp-1
    end
    if not pos then
        error('Negitave exp is not supporting in float point int')
    end
    return res
end

function Number.floor(val1: number)
    return (val1*100+0.5-(val1*100+0.5)%1)/100
end

function Number.log(val1, val2)
    return math.log(val1, val2)
end

function Number.log10(val1: number)
    local log = Number.log(val1, 10)
    return log
end

function Number.abs(val1: number)
    if val1 ~= val1 then return val1 end
    return (val1 < 0) and -val1 or val1
end

function Number.max(val1: number, val2: number)
    return (val1 > val2) and val1 or val2
end

function Number.min(val1: number, val2: number)
    return (val1 < val2) and val1 or val2
end

function Number.clamp(val1: number, min: number, max: number)
    if val1 ~= val1 or min ~= min or max ~= max then
        return nil
    end
    if min > max then
        min, max = max, min
    end
    return (val1 < min) and min or ((val1 > max) and max or val1)
end

type option = 'shortformat' | 'short'

function Number.shortformat(val1: number): string
    local index = 1
    while Number.meeq(val1, 1000) do
        val1 = val1 / 1000
        index = index + 1
    end
    return string.format('%.2f%s', val1, suffixes[index])
end

function Number.short(val1: number): string
    local mod = math.log10(val1)
    mod = math.floor(mod)
    local index = math.floor(mod/3)+1
    index = math.clamp(index, 1, #suffixes)
    val1 = val1/10^(3 * (index -1))
    val1 = math.floor(val1 * 100 ) / 100
    return val1..suffixes[index]
end

function Number.toScience(val1: number): string
    local exp = math.floor(math.abs(math.log10(val1)))
    exp = Number.correct(exp)
    local man = val1/10^exp
    return man .. 'e' .. exp
end

function Number.shortE(val: number, setting: option): string
    local meeq = Number.meeq
    if setting == 'shortformat' then
        local result
        if meeq(val, 10^30) then
            result = Number.toScience(val)
        end
        result = Number.shortformat(val)
        return result
    else
        local result 
        if meeq(val, 10^30) then
            result = Number.toScience(val)
        end
        result = Number.short(val)
        return result
    end
end

function Number.Comma(val1: number): string
    local meeq = Number.meeq
    if meeq(val1, 1000) then
        if meeq(val1, 10^12) then
            return '999,999,999,999+'
        end
        local format = tostring(math.floor(val1))
        local sep = ','
        for i = #format-3, 1, -3 do
            format = format:sub(1, i) .. sep .. format:sub(i+1)
        end
        return format
    else
        return val1
    end
end

function Number.Percentage(val1: number, val2: number, precision: number)
    precision = precision or 0
    local precentage = (val1/val2)*100
    local abs = math.abs(precentage)
    local dyn = precision
    local le = Number.le
    if le(abs, 0.000001) then
        dyn = math.max(precision, 8)
    elseif le(abs, 0.0001) then
        dyn = math.max(precision, 7)
    elseif le(abs, 0.01) then
        dyn = math.max(precision, 6)
    elseif le(abs, 1) then
        dyn = math.max(precision, 4)
    elseif le(abs, 10) then
        dyn = math.max(precision, 2)
    elseif le(abs, 100) then
        dyn = math.max(precision, 1)
    else
        dyn = 0
    end
    local form = '%.' .. dyn .. 'f%%'
    local format = string.format(form, precentage)
    return format:gsub('%.?0+%%', '%%')
end

function Number.CommaToShort(val: number)
    local result
    local meeq = Number.meeq
    if meeq(val, 1e12) then
        result = Number.short(val)
    else
        result = Number.Comma(val)
    end
    return result
end

function Number.Concat(val1: number): 'Returns 1,000 then 1Qg to 1e153'
    local result
    local meeq = Number.meeq
    local leeq = Number.leeq
    if meeq(val1, 1e153) then
        result = Number.toScience(val1)
    else
        result = Number.CommaToShort(val1)
    end
    return result
end


return table.freeze(Number)