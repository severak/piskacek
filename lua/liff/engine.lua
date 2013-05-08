---
-- LIFF
---
-- An interactive fiction engine.
---

liff_gui.cls();
liff_gui.set_title('Pískáček');
liff_gui.set_room_title('Bar Sewer');
liff_gui.echo('Mňau!!');
liff_gui.echo('Item added no ' .. liff_gui.menu_add('Lachtan') )
liff_gui.echo('Item added no ' .. liff_gui.menu_add('Lachtan 2') )

liff_gui.menu_click = function(idx)
	liff_gui.echo('Kliknuto na '..idx)
	error('čau')
end