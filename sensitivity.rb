require 'rubystats'
require 'simple-random'

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
def find_probabilities(runs, num_simulations)

  number_of_simulations = num_simulations

  rand = SimpleRandom.new
  rand.set_seed

  # Initialize hash to hold alternatives and their beta distribution parameters
  alternatives = {}

  # Assign runs to the alternative_hash
  runs.each do |name, data|
    alpha = data[0] + 1
    beta = data[1] - data[0] + 1 # n - success + 1
    alternatives[name] = [alpha, beta]
  end

  wins = {}

  number_of_simulations.times do
    # Create a hash to hold the random draws from the beta distributions
    beta_draws = {}

    # Iterate through each alternative-parameter pair and make a random draw from its beta distribution
    alternatives.each do |name, parameters|
      alpha = parameters[0]
      beta = parameters[1]
      beta_draws[name] = rand.beta(alpha, beta)
    end

    # Find the winning alternative
    beta_draws.each do |name, draw|
      if draw == beta_draws.values.max
        wins[name] = wins[name].nil? ? 1 : wins[name] + 1
      end
    end
  end

  probabilities = {}

  wins.each do |name, num_wins|
    probabilities[name] = num_wins / number_of_simulations.to_f
  end

  puts probabilities.inspect
  return probabilities

end

runs = {}
runs["a"] = [10, 100]
runs["b"] = [5, 50]
runs["c"] = [3, 8]
runs["d"] = [1, 10]

probabilities = find_probabilities(runs, 1000)

probabilities.each do |name, probability|
  puts "Probability of #{name} being the champion: #{probability.to_f*100}%"
end
