class Tag < ActiveRecord::Base

  has_and_belongs_to_many :projects,
          :before_add => :increment_tag_counter,
          :before_remove => :decrement_tag_counter

  validates_uniqueness_of :name

  def increment_tag_counter (project)
    self.class.increment_counter(:count, id)
  end
  
  def decrement_tag_counter (project)
    self.class.decrement_counter(:count, id)
  end

end
