// -----------------------------
//        Sec Red Alert Locker
// Only unlocks upon a red alert or greater
// -----------------------------

/obj/structure/closet/secure_closet/redalert
	name = "emergency security closet"
	desc = "To be unlocked only in a state of Red Alert or worse!"
	anchored = 1.0
	alert_locked = SEC_LEVEL_RED
	req_access = list(access_security)
	icon_state = "sec"