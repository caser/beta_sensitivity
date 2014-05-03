require_relative 'find_probabilities'

# Test each scenario at 1,000; 10,000; and 25,000 simulations

# 4 different scenarios (A/B test):
# same volume, same conversion rate
# same volume, different conversion rate
# different volume, same conversion rate
# different volume, different conversion rate

# Repeat with 3 and 4 alternative MVT

# Scenario Structure:
# Run scenario and calculate the probability that each alternative is the winner
# Store probabilities in a hash
# Repeat 1,000 times
# Calculate mean & standard deviation

# Create method to calculate probabilities of each run being the winning alternative
# runs => runs["a"] = [successes, total_n]

include Sim

=begin
# Test module
runs = {}
runs["a"] = [10, 100]
runs["b"] = [5, 50]
runs["c"] = [3, 8]
runs["d"] = [1, 10]

probabilities = Sim::find_probabilities(runs, 1000)

probabilities.each do |name, probability|
  puts "Probability of #{name} being the champion: #{probability.to_f*100}%"
end
=end

# Given run information, test at 1,000; 10,000; and 25,000 simulations
# Return mean and standard deviation for each run probability of being the winner
# runs ~ runs["a"] = [successes, total_n]
def simulate(runs)
  # create storage variables
  simulations = {}
  runs.each do |name, data|
    simulations[name] = []
  end

  1000.times do
    # Simulate draws from the beta distribution
    probabilities = Sim::find_probabilities(runs, 1000)

    # Store probabilities in storage hash & arrays
    probabilities.each do |name, probability|
      simulations[name].push(probability)
    end
  end

  # calculate mean
  means = {}
  simulations.each do |name, probabilities|
    sum = 0
    probabilities.each do |prob|
      sum += prob
    end
    mean = sum / prob.length.to_f
    means[name] = mean
  end

  # calculate standard deviation
  stdevs = {}

  simulations.each do |name, probabilities|
    mean = means[name]
    variance = 0
    probabilities.each do |prob|
      diff = (prob - mean)^2
      variance += diff
    end
    stdev = Math.sqrt(variance)
    stdevs[name] = stdev
  end

  # TODO - test mean & stdev code
  # TODO - test whole method to see if it works

  # simulate 1,000 times, store probabilities in an array in a hash {[probability, probability, etc.]}
  # calculate mean and standard deviation, store in a hash
  # repeat for 10,000 and 25,000 iterations


end







