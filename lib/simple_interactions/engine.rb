require "simple_interactions/helpers"

module SimpleInteractions
  class Engine < Rails::Engine
    initializer "simple_interactions.helpers" do
      ActionController::Base.send :include, Helpers
    end
  end
end
