class Network
	constructor: (neurons) ->
		# Each neuron is represented by a value in this array
		@neurons = Array(neurons).fill(1)

		# Connect every neuron to every other neuron
		@connections = {}
		for i in [0...@neurons.length]
			for j in [0...@neurons.length]
				if j > i
					# To make it easier, make a record for i-j and j-i.
					# i-j will always equal j-i.
					@connections[i + '-' + j] = 0
					@connections[j + '-' + i] = 0

	propegate: (pat) ->
		# Assign each neuron their respective value from the input pattern.
		for i in [0...@neurons.length]
			@neurons[i] = pat[i]

		# Calculate each neurons value. Do 10 iterations to make sure we get a good value.
		for k in [0...10]
			for i in [0...@neurons.length]
				sum = 0
				for j in [0...@neurons.length]
					unless i is j
						sum += @neurons[j] * @connections[i + '-' + j]
				@neurons[i] = if sum >= 0 then 1 else -1
		
		@neurons

	# Add a pattern to the memory.
	train: (pat) ->
		for i in [0...pat.length]
			for j in [0...pat.length]
				if j > i
					@connections[i + '-' + j] += pat[i] * pat[j]
					@connections[j + '-' + i] += pat[i] * pat[j]


# Make a network with 8 nodes
nn = new Network(8)

# Train it with these two patterns
nn.train([-1, 1,-1, 1,-1, 1,-1, 1])
nn.train([ 1, 1, 1, 1, 1, 1, 1, 1])

# See which one of those two it remembers when it sees these!
# Note: Hopfield networks are sign-blind, so the signs may be inverted.
# (instead of remembering [1, -1, -1] it could remember [-1, 1, 1])
console.log nn.propegate([-1, -1, -1, -1, -1, -1,  1, -1])
console.log nn.propegate([-1,  1,  1, -1, -1,  1,  1,  1])
# Both of the above patterns remind the network of the second pattern.
# This input reminds it of the alternating one.
console.log nn.propegate([ 1,  1, -1, -1, -1,  1, -1,  1])
