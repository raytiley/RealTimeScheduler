class TaskSetSerializer < ActiveModel::Serializer

  embed :ids, :include => true
  has_many :tasks
  attributes :id, :name, :schedule_ids

  def schedule_ids
    object.generate_schedule
  end
end
