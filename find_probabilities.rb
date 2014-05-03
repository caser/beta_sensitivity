require 'rubystats'
require 'simple-random'

module Sim
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
end