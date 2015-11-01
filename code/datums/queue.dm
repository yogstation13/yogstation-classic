// Kn0ss0s
// Datum to create a queue of objects. FIFO.
// Large queues might be expensive. Best to keep to low length queues.

/datum/queue
	var/max = 5
	var/list/items

/datum/queue/New(size = 5)
	..()
	max = size
	items = new /list()

// Add an item to the end of the list, if the total is more than the max then pop the first index off and return it
/datum/queue/proc/enqueue(item)
	if(items.len == max)
		// If the length is at the maximum, then we need to pop off the first item and move the other indices left one.
		var/out = items[1]
		for(var/i = 1; i <= (items.len - 1); i++)
			items[i] = items[i+1]
		// Now the last index is set to the item
		items[items.len] = item

		return out
	else
		// Queue isn't full, just add to the end
		items += item

	// We only return an item if the queue was full
	return null

// Pop off the first entered object from the list, reducing the size of the queue by one
/datum/queue/proc/dequeue()
	if(items.len > 0)
		// If there are items in the queue, remove the first and move the indices down
		var/out = items[1]
		for(var/i = 1; i <= (items.len - 1); i++)
			items[i] = items[i+1]
		items.Cut(items.len)

		return out

	// If the queue is empty, nothing is returned
	return null