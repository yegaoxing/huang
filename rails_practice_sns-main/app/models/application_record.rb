class ApplicationRecord < ActiveRecord::Base
  
  @primary_class
  # primary_abstract_class
  
  self.abstract_class = true
end
