module Twitter
  module Bootstrap
      module Rails
        require 'twbs/bootstrap/rails/engine' if defined?(Rails)
      end
   end
end

#require 'less-rails'
require 'twbs/bootstrap/rails/bootstrap' if defined?(Rails)
