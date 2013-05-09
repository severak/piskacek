---
-- LIFF
---
-- An interactive fiction engine.
---

local liff = {}
liff.w = {}
liff.verbs = {}
liff.menu_ids = {}
liff.args = {}

liff.here = ''
liff.verb = ''
liff.mode = ''
liff.dialog = nil

function liff.definer(proto)
	local protoMT = {__index=proto}
	return function(def)
		setmetatable(def, protoMT)
		return def
	end
end

function liff.call(obj, fun, ...)
	if type(obj[fun])=='string' then
		liff_gui.echo(obj[fun])
		return true
	elseif type(obj[fun])=='function' then
		return obj[fun](obj, ...)
	else
		return nil
	end
end

function liff.list_verbs()
	liff_gui.menu_clear()
	liff.menu_ids={}
	for key,verb in pairs(liff.verbs) do
		if not verb.is_exit or (verb.is_exit and w[liff.here][key]) then
			local idx=liff_gui.menu_add(verb.title)
			liff.menu_ids[idx] = key
		end
	end
	liff.mode='verb'
end

function liff.enter_room(name)
	assert(w[name], 'Room '..name..' does not exists!')
	liff_gui.set_room_title(w[name].title)
	liff.call(w[name], 'desc')
	liff.here = name
	liff.list_verbs()
end

function liff.click_verb(code)
	local here=w[liff.here]
	local verb=liff.verbs[code]
	if verb.is_exit then
		if type(here[code])=='string' then
			liff_gui.cls()
			liff.enter_room(here[code])
			return
		end
	end
	if #verb.args==0 then
		liff.call(here,code)
	end -- zatim
end

function liff_gui.menu_click(idx)
	if liff.mode=='verb' then
		liff.click_verb(liff.menu_ids[idx])
	end
end

-- protos

liff.proto={}

liff.proto.room = {
	title = 'Nějaká místnost',
	desc = 'Nějaká místnost.',
	wait = 'Nic se neděje.'
}

-- defaults

liff.verbs.desc = {
	title = 'Rozhlédni se',
	args = {}
}

liff.verbs.wait = {
	title = 'Čekej',
	args = {}
}

liff.verbs.n = {
	title = 'Sever',
	args = {},
	is_exit = true
}

liff.verbs.s = {
	title = 'Jih',
	args = {},
	is_exit = true
}

liff.verbs.w = {
	title = 'Západ',
	args = {},
	is_exit = true
}
liff.verbs.e = {
	title = 'Východ',
	args = {},
	is_exit = true
}

-- globals

_G.liff = liff
_G.w = liff.w
_G.room = liff.definer(liff.proto.room)

function _G.game(def)
	--liff_gui.cls();
	liff_gui.set_title(def.title)
	liff.enter_room(def.startroom or error('Define startroom!'))
end

_G.echo = liff_gui.echo

return liff