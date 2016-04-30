require_relative 'feature_helpers'
RSpec.configure do |config|
  config.include Devise::TestHelpers, :type => :controller
  config.extend ControllerMacros, :type => :controller
  config.include FeatureHelpers
end