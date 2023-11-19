-- DCL API dictionary, formatted for Lua scripts
-- Last update: October 24, 2019
-- 1 is return type, 2 is name of the function, 3 is args, 4 is description, 5 is example code
return {
	["Environment Library"] = {
		{ "table", "getgenv", "", "Returns the environment that will be applied to each script ran by Rune CE." },
		{ "table", "getrenv", "", "Returns the global thread environment for the LocalScript context." },
		{ "table", "getreg", "", "Returns the Lua registry." },
		{ "table<object>", "getinstances", "", "Returns a list of all instances within the game." },
		{
			"table<BaseScript>",
			"getnilinstances",
			"",
			"Returns a list of all instances parented to nil within the game.",
		},
		{ "table<BaseScript>", "getscripts", "", "Returns a list of all scripts within the game." },
		{ "table<ModuleScript>", "getmodules", "", "Returns a list of all ModuleScripts within the game." },
		-- {
		-- 	"variant<LocalScript/ModuleScript/nil>",
		-- 	"getcallingscript",
		-- 	"",
		-- 	"Returns the script calling the current function.",
		-- },
	},
	["Closure Library"] = {
		{ "bool", "iscclosure", "function f", "Returns true if f is a CClosure." },
		{ "bool", "islclosure", "function f", "Returns true if f is an LClosure." },
	},
	["Encryption Library"] = {
		-- __PREFIX = "crypt",
		{ "string", "*prp base64_encode", "string Data", "Encodes Data in base64." },
		{ "string", "*prp base64_decode", "string Data", "Decodes Data from base64." },
	},
}
