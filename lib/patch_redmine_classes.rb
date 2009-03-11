#require_dependency 'project'
#require_dependency 'user'
#require 'project'
#require_dependency 'project'
#require_dependency 'user'
 
# Patches Redmine's projects dynamically. Adds a relationship
# Issue +belongs_to+ to Deliverable
module TodosProjectPatch
  require_dependency 'project'

  def self.included(base) # :nodoc:
    Project.extend(ClassMethods)
 
    Project.send(:include, InstanceMethods)
 
    # Same as typing in the class
    Project.class_eval do
      #unloadable # Send unloadable so it will not be unloaded in development
      has_many :todos
      #raise ActiveRecord::RecordNotFound, "pie"
    end
 
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
  end
end
 
# Add module to Project. Will only work for production enviroments.
Project.send(:include, TodosProjectPatch)



# Patches Redmine's Users dynamically. 
# Adds relationships for accessing assigned and authored todos.
module TodosUserPatch
  
  require_dependency 'user'

  def self.included(base) # :nodoc:
    base.extend(ClassMethods)
 
    base.send(:include, InstanceMethods)
 
    # Same as typing in the class
    base.class_eval do
      unloadable # Send unloadable so it will not be unloaded in development
      
      #A user can 
      has_many :authored_todos, :class_name => 'Todo', :foreign_key => 'author_id', :order => 'position'
      has_many :assigned_todos, :class_name => 'Todo', :foreign_key => 'assigned_to_id', :order => 'position'
      
      #define a method to get the todos belonging to this user by UNIONing the above two collections
      def todos
        self.authored_todos | self.assigned_todos
      end
      #raise ActiveRecord::RecordNotFound, "pie"
    end
 
  end
  
  module ClassMethods
  end
  
  module InstanceMethods
  end
end
 
# Add module to User, once. Will only work for production enviroments.
User.send(:include, TodosUserPatch)


ActiveSupport::CoreExtensions::Time::Conversions::DATE_FORMATS.merge!(
          :default => "%d/%m/%Y",
          :short_day => "%b %d"
)

