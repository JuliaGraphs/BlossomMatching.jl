mutable struct BlossomVStats{T}
	"""
	Number of shrink operations.
	"""
	num_shrink_op = zero(T)
	
	"""
	Number of expand operations.
	"""
	num_expand_op = zero(T)
	
	"""
	Number of grow operations.
	"""
	num_grow_op = zero(T)
	
	"""
	Number of augment operations.
	"""
	num_augment_op = zero(T)
	
	"""
	Time used for doing shrink operations.
	"""
	time_shrink_op = zero(T)
	
	"""
	Time used for doing expand operations.
	"""
	time_expand_op = zero(T)
	
	"""	
	Time used for doing grow operations.
	"""
	time_grow_op = zero(T)
	
	"""
	Time used for doing augment operations.
	"""
	time_augment_op = zero(T)

end
