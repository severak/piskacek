-- here comes the game

w.obyvak = room{
	title='Obyvák',
	desc='Jsi v obýváku. Místnosti vévodí obrovská stará televize, právě dávají zápas pražských es.',
	n='kuchyn'
}

w.kuchyn = room{
	title='Kuchyně',
	desc='Naše krásná kuchyně. V hrnci bublá cosi nepoživatelného.',
	s='obyvak'
}

game{
	title = 'Syrečky',
	startroom = 'obyvak'
}