var/list/sting_paths
var/list/changeling_organ_paths
// totally stolen from the new player panel.  YAYY

/obj/effect/proc_holder/resource_ability/changeling/evolution_menu
	name = "-Evolution Menu-" //Dashes are so it's listed before all the other abilities.
	desc = "Choose our method of subjugation."
	dna_cost = 0

/obj/effect/proc_holder/resource_ability/changeling/evolution_menu/Click()
	if(!usr || !usr.mind || !usr.mind.changeling)
		return
	var/datum/changeling/changeling = usr.mind.changeling

	if(!sting_paths)
		sting_paths = init_paths(/obj/effect/proc_holder/resource_ability/changeling)

	var/dat = create_menu(changeling, usr)
	usr << browse(dat, "window=powers;size=600x700")//900x480


/obj/effect/proc_holder/resource_ability/changeling/evolution_menu/proc/create_menu(datum/changeling/changeling, mob/living/carbon/user)
	var/dat
	dat +="<html><head><title>Changling Evolution Menu</title></head>"

	//javascript, the part that does most of the work~
	dat += {"

		<head>
			<script type='text/javascript'>

				var locked_tabs = new Array();

				function updateSearch(){


					var filter_text = document.getElementById('filter');
					var filter = filter_text.value.toLowerCase();

					if(complete_list != null && complete_list != ""){
						var mtbl = document.getElementById("maintable_data_archive");
						mtbl.innerHTML = complete_list;
					}

					if(filter.value == ""){
						return;
					}else{

						var maintable_data = document.getElementById('maintable_data');
						var ltr = maintable_data.getElementsByTagName("tr");
						for ( var i = 0; i < ltr.length; ++i )
						{
							try{
								var tr = ltr\[i\];
								if(tr.getAttribute("id").indexOf("data") != 0){
									continue;
								}
								var ltd = tr.getElementsByTagName("td");
								var td = ltd\[0\];
								var lsearch = td.getElementsByTagName("b");
								var search = lsearch\[0\];
								//var inner_span = li.getElementsByTagName("span")\[1\] //Should only ever contain one element.
								//document.write("<p>"+search.innerText+"<br>"+filter+"<br>"+search.innerText.indexOf(filter))
								if ( search.innerText.toLowerCase().indexOf(filter) == -1 )
								{
									//document.write("a");
									//ltr.removeChild(tr);
									td.innerHTML = "";
									i--;
								}
							}catch(err) {   }
						}
					}

					var count = 0;
					var index = -1;
					var debug = document.getElementById("debug");

					locked_tabs = new Array();

				}

				function expand(id,name,desc,helptext,power,ownsthis){

					clearAll();

					var span = document.getElementById(id);

					body = "<table><tr><td>";

					body += "</td><td align='center'>";

					body += "<font size='2'><b>"+desc+"</b></font> <BR>"

					body += "<font size='2'><span class='danger'>"+helptext+"</span></font> <BR>"

					if(!ownsthis)
					{
						body += "<a href='?src=\ref[src];P="+power+"'>Evolve</a>"
					}
					body += "</td><td align='center'>";

					body += "</td></tr></table>";


					span.innerHTML = body
				}

				function clearAll(){
					var spans = document.getElementsByTagName('span');
					for(var i = 0; i < spans.length; i++){
						var span = spans\[i\];

						var id = span.getAttribute("id");

						if(!(id.indexOf("item")==0))
							continue;

						var pass = 1;

						for(var j = 0; j < locked_tabs.length; j++){
							if(locked_tabs\[j\]==id){
								pass = 0;
								break;
							}
						}

						if(pass != 1)
							continue;




						span.innerHTML = "";
					}
				}

				function addToLocked(id,link_id,notice_span_id){
					var link = document.getElementById(link_id);
					var decision = link.getAttribute("name");
					if(decision == "1"){
						link.setAttribute("name","2");
					}else{
						link.setAttribute("name","1");
						removeFromLocked(id,link_id,notice_span_id);
						return;
					}

					var pass = 1;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\[j\]==id){
							pass = 0;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs.push(id);
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "<span class='danger'>Locked</span> ";
					//link.setAttribute("onClick","attempt('"+id+"','"+link_id+"','"+notice_span_id+"');");
					//document.write("removeFromLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
					//document.write("aa - "+link.getAttribute("onClick"));
				}

				function attempt(ab){
					return ab;
				}

				function removeFromLocked(id,link_id,notice_span_id){
					//document.write("a");
					var index = 0;
					var pass = 0;
					for(var j = 0; j < locked_tabs.length; j++){
						if(locked_tabs\[j\]==id){
							pass = 1;
							index = j;
							break;
						}
					}
					if(!pass)
						return;
					locked_tabs\[index\] = "";
					var notice_span = document.getElementById(notice_span_id);
					notice_span.innerHTML = "";
					//var link = document.getElementById(link_id);
					//link.setAttribute("onClick","addToLocked('"+id+"','"+link_id+"','"+notice_span_id+"')");
				}

				function selectTextField(){
					var filter_text = document.getElementById('filter');
					filter_text.focus();
					filter_text.select();
				}

			</script>
		</head>


	"}

	//body tag start + onload and onkeypress (onkeyup) javascript event calls
	dat += "<body onload='selectTextField(); updateSearch();' onkeyup='updateSearch();'>"

	//title + search bar
	dat += {"

		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable'>
			<tr id='title_tr'>
				<td align='center'>
					<font size='5'><b>Changeling Evolution Menu</b></font><br>
					Hover over a power to see more information<br>
					Current ability choices remaining: [changeling.geneticpoints]<br>
					By rendering a lifeform to a husk, we gain enough power to alter and adapt our evolutions.<br>
					(<a href='?src=\ref[src];readapt=1'>Readapt</a>)<br>
					<p>
				</td>
			</tr>
			<tr id='search_tr'>
				<td align='center'>
					<b>Search:</b> <input type='text' id='filter' value='' style='width:300px;'>
				</td>
			</tr>
	</table>

	"}

	//player table header
	dat += {"
		<span id='maintable_data_archive'>
		<table width='560' align='center' cellspacing='0' cellpadding='5' id='maintable_data'>"}

	var/i = 1
	for(var/path in sting_paths)

		var/obj/effect/proc_holder/resource_ability/changeling/P = new path()
		if(P.dna_cost <= 0) //Let's skip the crap we start with. Keeps the evolution menu uncluttered.
			continue

		var/ownsthis = changeling.has_sting(P, user)

		var/color
		if(ownsthis)
			if(i%2 == 0)
				color = "#d8ebd8"
			else
				color = "#c3dec3"
		else
			if(i%2 == 0)
				color = "#f2f2f2"
			else
				color = "#e6e6e6"


		dat += {"

			<tr id='data[i]' name='[i]' onClick="addToLocked('item[i]','data[i]','notice_span[i]')">
				<td align='center' bgcolor='[color]'>
					<span id='notice_span[i]'></span>
					<a id='link[i]'
					onmouseover='expand("item[i]","[P.name]","[P.desc]","[P.helptext]","[P]",[ownsthis])'
					>
					<b id='search[i]'>Evolve [P][ownsthis ? " - Purchased" : (P.req_dna>changeling.absorbedcount ? " - Requires [P.req_dna] absorptions" : " - Cost: [P.dna_cost]")]</b>
					</a>
					<br><span id='item[i]'></span>
				</td>
			</tr>

		"}

		i++


	//player table ending
	dat += {"
		</table>
		</span>

		<script type='text/javascript'>
			var maintable = document.getElementById("maintable_data_archive");
			var complete_list = maintable.innerHTML;
		</script>
	</body></html>
	"}
	return dat


/obj/effect/proc_holder/resource_ability/changeling/evolution_menu/Topic(href, href_list)
	..()
	if(!(iscarbon(usr) && usr.mind && usr.mind.changeling))
		return

	if(href_list["P"])
		usr.mind.changeling.purchasePower(usr, href_list["P"])
	else if(href_list["readapt"])
		usr.mind.changeling.lingRespec(usr)
	var/dat = create_menu(usr.mind.changeling, usr)
	usr << browse(dat, "window=powers;size=600x700")
/////

/datum/changeling/proc/purchasePower(mob/living/carbon/user, sting_name, suppress_warning = 0)

	var/obj/effect/proc_holder/resource_ability/changeling/thepower = null

	if(!sting_paths)
		sting_paths = init_paths(/obj/effect/proc_holder/resource_ability/changeling)
	for(var/path in sting_paths)
		var/obj/effect/proc_holder/resource_ability/changeling/S = new path()
		if(S.name == sting_name)
			thepower = S

	if(thepower == null)
		if(!suppress_warning)
			user << "This is awkward. Changeling power purchase failed, please report this bug to a coder!"
		return

	if(absorbedcount < thepower.req_dna)
		if(!suppress_warning)
			user << "We lack the energy to evolve this ability!"
		return

	if(has_sting(thepower, user))
		if(!suppress_warning)
			user << "We have already evolved this ability!"
		return

	if(thepower.dna_cost < 0)
		if(!suppress_warning)
			user << "We cannot evolve this ability."
		return

	if(geneticpoints < thepower.dna_cost)
		if(!suppress_warning)
			user << "We have reached our capacity for abilities."
		return

	if(user.status_flags & FAKEDEATH)//To avoid potential exploits by buying new powers while in stasis, which clears your verblist.
		if(!suppress_warning)
			user << "We lack the energy to evolve new abilities right now."
		return

	geneticpoints -= thepower.dna_cost
	if(thepower.organtype)
		var/obj/item/organ/internal/ability_organ/changeling/theorgan = new thepower.organtype()
		theorgan.Insert(user) //this handles adding the power.
	else
		thepower.on_gain(user)
		non_organ_powers += thepower

//Reselect powers
/datum/changeling/proc/lingRespec(mob/living/carbon/user)
	if(!ishuman(user))
		user << "<span class='danger'>We can't remove our evolutions in this form!</span>"
		return
	if(canrespec)
		user << "<span class='notice'>We have removed our evolutions from this form, and are now ready to readapt.</span>"
		var/refund_points = 0
		for(var/obj/item/organ/internal/ability_organ/changeling/O in user.internal_organs)
			for(var/obj/effect/proc_holder/resource_ability/changeling/thepower in O.granted_powers)
				refund_points += thepower.dna_cost
		for(var/obj/effect/proc_holder/resource_ability/changeling/thepower in user.abilities)
			refund_points += thepower.dna_cost
		user.remove_changeling_powers(1, 1, 0)
		canrespec = 0
		user.make_changeling()
		geneticpoints = refund_points
		return 1
	else
		user << "<span class='danger'>You lack the power to readapt your evolutions!</span>"
		return 0

/mob/living/carbon/proc/make_changeling(var/createhuman = 0)
	if(!mind)
		return
	if(!ishuman(src) && !ismonkey(src))
		return
	if(!mind.changeling)
		mind.changeling = new /datum/changeling(gender)
	if(!sting_paths)
		sting_paths = init_paths(/obj/effect/proc_holder/resource_ability/changeling)
	if(!changeling_organ_paths)
		changeling_organ_paths = init_paths(/obj/item/organ/internal/ability_organ/changeling)
	remove_changeling_powers(1, 1, 1)
	//get free organs
	for(var/path in changeling_organ_paths)
		var/obj/item/organ/internal/ability_organ/changeling/chem_storage/organ = new path()
		if(organ.free_organ && !getorgan(path))
			organ.Insert(src)
	// purchase free powers.
	for(var/path in sting_paths)
		var/obj/effect/proc_holder/resource_ability/changeling/S = new path()
		if(!S.dna_cost)
			if(!mind.changeling.has_sting(S))
				mind.changeling.purchasePower(src, S.name, 1)

	var/mob/living/carbon/C = src		//only carbons have dna now, so we have to typecaste
	if(createhuman)
		C = new /mob/living/carbon/human()
	var/datum/changelingprofile/prof = mind.changeling.add_profile(C) //not really a point in typecasting here but somebody will probably get mad at me if i dont
	mind.changeling.first_prof = prof
	return 1

/datum/changeling/proc/reset(mob/living/carbon/the_ling)
	chosen_sting = null
	geneticpoints = initial(geneticpoints)
	sting_range = initial(sting_range)
	var/obj/item/organ/internal/ability_organ/changeling/chem_storage/chem_store = the_ling.getorgan(/obj/item/organ/internal/ability_organ/changeling/chem_storage)
	if(chem_store)
		chem_store.chem_storage = initial(chem_store.chem_storage)
		chem_store.chem_recharge_rate = initial(chem_store.chem_recharge_rate)
		chem_store.chem_charges = min(chem_store.chem_charges, chem_store.chem_storage)
		chem_store.chem_recharge_slowdown = initial(chem_store.chem_recharge_slowdown)
	mimicing = ""

/mob/living/carbon/proc/remove_changeling_powers(keep_free_powers = 0, keep_revive_powers = 0, keep_organs = 0)
	if(ishuman(src) || ismonkey(src))
		if(mind && mind.changeling)
			digitalcamo = 0
			mind.changeling.changeling_speak = 0
			mind.changeling.reset(src)
			if(mind.changeling.non_organ_powers)
				for(var/obj/effect/proc_holder/resource_ability/changeling/p in mind.changeling.non_organ_powers)
					if(!((p.dna_cost == 0 && keep_free_powers) || (istype(p, /obj/effect/proc_holder/resource_ability/changeling/revive) && keep_revive_powers)) )
						mind.changeling.non_organ_powers -= p
						p.on_lose(src)
		if(hud_used)
			hud_used.lingstingdisplay.icon_state = null
			hud_used.lingstingdisplay.invisibility = 101

		if(!keep_organs)
			for(var/obj/item/organ/internal/ability_organ/changeling/O in internal_organs)
				if(!(keep_free_powers && O.free_organ))
					O.Remove(src, 1)
					qdel(O)

/datum/changeling/proc/has_sting(obj/effect/proc_holder/resource_ability/changeling/power, mob/living/carbon/user)
	for(var/obj/effect/proc_holder/resource_ability/changeling/P in non_organ_powers)
		if(power.name == P.name)
			return 1
	if(user)
		for(var/obj/effect/proc_holder/resource_ability/changeling/P in user.abilities)
			if(power.name == P.name)
				return 1
	return 0
