require 'mongo'

class Goal

  def initialize(db)
    @db = db.collection('goals')
  end

  def all()
    goals = @db.find({}).sort({sort: 1})
  end

end