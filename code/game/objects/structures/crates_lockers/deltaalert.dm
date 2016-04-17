// -----------------------------
//        Sec Delta Alert Locker
// Only unlocks upon a delta alert or greater
// -----------------------------

/obj/structure/closet/secure_closet/deltaalert
	name = "emergency security closet"
	desc = "To be unlocked only in a state of Delta Alert or worse!"
	anchored = 1.0
	alert_locked = SEC_LEVEL_DELTA
	req_access = list(access_security)
	icon_state = "sec"