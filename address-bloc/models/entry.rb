require 'bloc_record/base'

class Entry < BlocRecord::Base
  # These must be accessors since we mutate them
  attr_accessor :name, :phone_number, :email

  def to_s
    "Name: #{name}\nPhone Number: #{phone_number}\nEmail: #{email}"
  end
end
