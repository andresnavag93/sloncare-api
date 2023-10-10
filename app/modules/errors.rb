module Errors
  class << self
    def translate(error)
      msg = 'custom_errors.global.'+ error.to_s
      return I18n.t msg
    end
  end
end