# frozen_string_literal: true
module Delay

    def self.included(mod)
      mod.class_eval do
        def self.delayed(delay = self.delay)
          where("#{table_name}.created_at < ?", delay.ago)
        end

        def self.delay
          if RequestStore.store[:delay]
            RequestStore.store[:delay].to_i.seconds
          else
            90.seconds
          end
        end
      end
    end

end
