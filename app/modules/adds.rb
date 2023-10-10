module Adds
  class << self
    def name_and_id(objs)
      n = 1
      for obj in objs
        obj._id = n
        if obj.respond_to? :name
          obj._name = obj.name
        elsif obj.respond_to? :user
          obj._name = obj.user.name
        else
          obj._name = obj.name
        end
        n += 1
      end
      return objs
    end
  end
end