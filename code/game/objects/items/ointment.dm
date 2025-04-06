/obj/item/salve
	name = "salve"
	desc = "An ingenious ointment sold by the apothecaries of Kingsfield. Used to treat burns."
	icon_state = "disinfectant2" //Placeholder
	possible_item_intents = list(/datum/intent/use)
	force = 1
	throwforce = 1
	sharpness = IS_BLUNT
	w_class = WEIGHT_CLASS_SMALL
	thrown_bclass = BCLASS_BLUNT
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BELT


	var/charges = 10         //Tune this to taste.
	var/burn_dam_healed = 5; //Tune this to taste.
	var/time_to_apply = 7 SECONDS

//Healing
/obj/item/salve/attack(mob/living/M, mob/living/user)
	. = ..()
	heal(M, user)

/obj/item/salve/proc/heal(mob/living/M, mob/living/user)
	if(!ishuman(M) || !ishuman(user))
		return
	var/mob/living/carbon/human/H = M
	var/mob/living/carbon/human/human_user = user

	var/obj/item/bodypart/affecting = H.get_bodypart(check_zone(user.zone_selected))
	if(!affecting)
		return
	if(affecting.burn_dam == 0)
		to_chat(user, "<span class='warning'>There are no burns to treat.</span>")
		return


	var/actual_delay = time_to_apply
	if(human_user.mind)
		actual_delay -= (human_user.mind.get_skill_level(/datum/skill/misc/medicine) * 10) //Copied from clothfibersthorn.dm

	//Play sound here
	playsound(src, 'sound/surgery/organ1.ogg', 100, FALSE)
	if(!do_after(user, actual_delay, M))
		return
	//Play sound here
	playsound(src, 'sound/surgery/organ1.ogg', 100, FALSE)


	//Update charges, limb damage values.
	affecting.heal_damage(0, burn_dam_healed, BODYPART_ORGANIC)
	charges --
	if(M == user)
		user.visible_message("<span class='notice'>[user] salves the burns on [user.p_their()] [affecting].</span>", "<span class='notice'>I salve the burns on my [affecting].</span>")
	else
		user.visible_message("<span class='notice'>[user] salves the burns on [M]'s [affecting].</span>", "<span class='notice'>I salve the burns on [M]'s [affecting].</span>")

