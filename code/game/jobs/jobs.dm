
var/const/ENGSEC			=(1<<0)

var/const/CAPTAIN			=(1<<0)
var/const/HOS				=(1<<1)
var/const/WARDEN			=(1<<2)
var/const/DETECTIVE			=(1<<3)
var/const/OFFICER			=(1<<4)
var/const/CHIEF				=(1<<5)
var/const/ENGINEER			=(1<<6)
var/const/ATMOSTECH			=(1<<7)
var/const/ROBOTICIST		=(1<<8)
var/const/AI				=(1<<9)
var/const/CYBORG			=(1<<10)


var/const/MEDSCI			=(1<<1)

var/const/RD				=(1<<0)
var/const/SCIENTIST			=(1<<1)
var/const/CHEMIST			=(1<<2)
var/const/CMO				=(1<<3)
var/const/DOCTOR			=(1<<4)
var/const/GENETICIST		=(1<<5)
var/const/VIROLOGIST		=(1<<6)
var/const/MMEDIC			=(1<<7)
var/const/PARAMEDIC			=(1<<8)
var/const/PSYCH				=(1<<9)
var/const/TOUR				=(1<<10)
var/const/WAITER			=(1<<11)
var/const/CLERK				=(1<<12)



var/const/CIVILIAN			=(1<<2)

var/const/HOP				=(1<<0)
var/const/BARTENDER			=(1<<1)
var/const/BOTANIST			=(1<<2)
var/const/CHEF				=(1<<3)
var/const/JANITOR			=(1<<4)
var/const/LIBRARIAN			=(1<<5)
var/const/QUARTERMASTER		=(1<<6)
var/const/CARGOTECH			=(1<<7)
var/const/MINER				=(1<<8)
var/const/LAWYER			=(1<<9)
var/const/CHAPLAIN			=(1<<10)
var/const/CLOWN				=(1<<11)
var/const/MIME				=(1<<12)
var/const/ASSISTANT			=(1<<13)


var/list/assistant_occupations = list(
	"Assistant",
	"Cargo Technician",
	"Chaplain",
	"Lawyer",
	"Tourist",
	"Clerk",
	"Librarian",
	"Psychiatrist"
)


var/list/command_positions = list(
	"Captain",
	"Head of Personnel",
	"Head of Security",
	"Chief Engineer",
	"Research Director",
	"Chief Medical Officer"
)


var/list/engineering_positions = list(
	"Chief Engineer",
	"Station Engineer",
	"Atmospheric Technician",
)


var/list/medical_positions = list(
	"Chief Medical Officer",
	"Medical Doctor",
	"Geneticist",
	"Virologist",
	"Chemist",
	"Mining Medic",
	"Paramedic",
	"Psychiatrist"
)


var/list/science_positions = list(
	"Research Director",
	"Scientist",
	"Roboticist",
)


var/list/civilian_positions = list(
	"Head of Personnel",
	"Recovery Agent",
	"Bartender",
	"Botanist",
	"Chef",
	"Waiter",
	"Janitor",
	"Librarian",
	"Quartermaster",
	"Cargo Technician",
	"Shaft Miner",
	"Lawyer",
	"Chaplain",
	"Clown",
	"Mime",
	"Assistant",
	"Clerk",
	"Tourist"
)


var/list/security_positions = list(
	"Head of Security",
	"Warden",
	"Detective",
	"Security Officer"
)


var/list/nonhuman_positions = list(
	"AI",
	"Cyborg",
	"pAI"
)

var/list/yog_positions = list(
	"Waiter",
	"Tourist",
	"Mining Medic",
	"Clerk",
	"Paramedic",
	"Psychiatrist"
)

/proc/guest_jobbans(var/job)
	return ((job in command_positions) || (job in nonhuman_positions) || (job in security_positions))
