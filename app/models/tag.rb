class Tag < ApplicationRecord

    validates :name, presence: true, length: { minimum:1, maximum:25 }, uniqueness:true
    has_many :course_tags
    has_many :courses, through: :course_tags

end
