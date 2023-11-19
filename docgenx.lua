-- docgenx.lua
-- automatically builds our documentation into /docs
-- written by Louka --> https://github.com/LoukaMB

local docgen = {}

function docgen.tree()
	local tree = {}
	tree.categories = {}
	return tree
end

function docgen.category(tree, name)
	tree.categories[name] = {}
	return tree.categories[name]
end

function docgen.method(f_return, f_name, f_arguments, f_description, f_example)
	local method = {}
	method.retn = f_return
	method.exam = f_example
	method.args = f_arguments
	method.desc = f_description
	method.name = f_name:gsub("%*prp%s*", "")
	method.proprietary = f_name:find("%*prp") and true
	return method
end

function docgen.entry(category, idx, method)
	table.insert(category, idx, method)
end

function docgen.filestr(path)
	local io_f = io.open(path, "r")
	local f_str = io_f:read("*a")
	io_f:close()
	return f_str
end

function docgen.typename(str)
	return str:gsub("<", '<span class="CodeTypenameVariant">&lt;'):gsub(">", "&gt;</span>")
end

function docgen.build(tree)
	local document = docgen.header
	local css = docgen.filestr("docstyle.css")
	local body = ""

	for CategoryName, CategoryData in next, tree.categories do
		-- do something with categories. for now, not necessary
		body = body .. '<h1 class="CategoryTitle">' .. CategoryName .. "</h1>"

		for idx, MethodData in next, CategoryData do
			local methodargs = ""
			local bodyentry = docgen.entry
			if MethodData.args:len() ~= 0 then -- build argument list
				for argvt, argvn in MethodData.args:gmatch("([%w/<>]+) ([%w%.]+)") do
					methodargs = methodargs
						.. ('<span class="CodeTypename">%s</span> %s, '):format(docgen.typename(argvt), argvn)
				end
				methodargs = methodargs:gsub(",%s*$", "") -- erase extra comma
			else
				-- void argument list
				methodargs = '<span class="CodeTypename">void</span>'
			end

			if MethodData.proprietary then
				bodyentry = bodyentry:format(
					MethodData.name,
					"CodeDefinitionProprietary",
					docgen.typename(MethodData.retn),
					"#" .. MethodData.name,
					MethodData.name,
					methodargs,
					MethodData.desc,
					MethodData.exam
				)
				body = body .. bodyentry
			else
				bodyentry = bodyentry:format(
					MethodData.name,
					"CodeDefinition",
					docgen.typename(MethodData.retn),
					"#" .. MethodData.name,
					MethodData.name,
					methodargs,
					MethodData.desc,
					MethodData.exam
				)
				body = body .. bodyentry
			end
		end
	end

	document = document:format(css, body)
	return document
end

function docgen.loadapidef(path)
	local f = io.open(path, "r")
	local a = f:read("*a")
	local fn, err = loadstring(a)
	if fn then
		f:close()
		return fn()
	else
		f:close()
		error("shit happened, please fix: " .. err)
	end
end

function docgen.main()
	local api = docgen.loadapidef("docapi.lua")
	local tree = docgen.tree()
	for idx1, Library in next, api do
		local category = docgen.category(tree, idx1)
		local Libary_Prefix = (Library.__PREFIX and Library.__PREFIX .. ".") or ""
		for idx2, Method_Info in next, Library do
			if type(idx2) == "number" then
				local f_returntype, f_name, f_args, f_desc, f_example =
					Method_Info[1],
					Method_Info[2],
					Method_Info[3],
					Method_Info[4],
					Method_Info[5] or "No example provided"

				docgen.entry(
					category,
					idx2,
					docgen.method(f_returntype, Libary_Prefix .. f_name, f_args, f_desc, f_example)
				)
			end
		end
	end

	docgen.header = docgen.filestr("base_index.html")
	docgen.entry = docgen.filestr("base_entry.html")
	local document_string = docgen.build(tree)
	local out = io.open("index.html", "w")
	out:write(document_string)
	out:close()
end

return docgen.main()
