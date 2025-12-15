local HttpService = game:GetService("HttpService")

local insert = table.insert
local concat = table.concat
local remove = table.remove
local tostring = tostring
local tonumber = tonumber
local typeof = typeof
local pairs = pairs
local ipairs = ipairs
local match = string.match
local rep = string.rep
local gmatch = string.gmatch

type JsonInput = table | string
type ToonInput = table | string

local Formatter = {}
Formatter.__index = Formatter

local INDENT = "  "

local function isArray(tbl: table): boolean
	for k in pairs(tbl) do
		if typeof(k) ~= "number" then
			return false
		end
	end
	return true
end

local function encodeValue(v: any): string
	if typeof(v) == "string" then
		return v
	end
	return tostring(v)
end

local function encodeToon(
	tbl: table,
	depth: number?,
	out: { string }?
): { string }
	depth = depth or 0
	out = out or {}

	for key, value in pairs(tbl) do
		local prefix = rep(INDENT, depth)

		if typeof(value) == "table" then
			if isArray(value) then
				local line = { prefix .. key .. "[" .. #value .. "]" }
				for _, v in ipairs(value) do
					insert(line, encodeValue(v))
				end
				insert(out, concat(line, ","))
			else
				insert(out, prefix .. key .. ",")
				encodeToon(value, depth + 1, out)
			end
		else
			insert(out, prefix .. key .. "," .. encodeValue(value))
		end
	end

	return out
end

function Formatter:JsonToToon(rawjson: JsonInput): string
	local data: table =
		typeof(rawjson) == "string"
			and HttpService:JSONDecode(rawjson)
			or rawjson

	local lines = encodeToon(data)
	return concat(lines, "\n")
end

local function parseLines(lines: { string }): table
	local root = {}
	local stack = { root }

	for _, line in ipairs(lines) do
		if line:match("^%s*$") then
			continue
		end

		local indent = match(line, "^(%s*)") or ""
		local depth = #indent / 2
		local content = line:sub(#indent + 1)

		while depth < #stack - 1 do
			remove(stack)
		end

		local current = stack[#stack]
		local key, rest = match(content, "^([^,]+),(.*)$")

		if not key then
			continue
		end

		if match(key, "%[") then
			local name = match(key, "^(.-)%[")
			local arr = {}

			for v in gmatch(rest, "[^,]+") do
				if v == "true" then
					insert(arr, true)
				elseif v == "false" then
					insert(arr, false)
				elseif tonumber(v) then
					insert(arr, tonumber(v))
				else
					insert(arr, v)
				end
			end

			current[name] = arr

		elseif rest == "" then
			current[key] = {}
			insert(stack, current[key])

		else
			if rest == "true" then
				current[key] = true
			elseif rest == "false" then
				current[key] = false
			elseif tonumber(rest) then
				current[key] = tonumber(rest)
			else
				current[key] = rest
			end
		end
	end

	return root
end

function Formatter:ToonToJson(toondata: ToonInput): string
	local text =
		typeof(toondata) == "table"
			and concat(toondata, "\n")
			or toondata

	local lines = {}
	for line in gmatch(text, "[^\n]+") do
		insert(lines, line)
	end

	local parsed = parseLines(lines)
	return HttpService:JSONEncode(parsed)
end

return Formatter
