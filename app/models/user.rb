class User < ApplicationRecord
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :trackable, :confirmable
        
  
  rolify

  has_many :courses, dependent: :nullify
  has_many :enrollments, dependent: :nullify
  has_many :user_lessons, dependent: :nullify
  has_many :comments, dependent: :nullify
  
  after_create do
    UserMailer.new_user(self).deliver_later
  end
  
  def to_s
    email
  end

 

  def username
    self.email.split(/@/).first
  end

  extend FriendlyId
  friendly_id :email, use: :slugged

  after_create :assign_default_role
  def assign_default_role
    if User.count == 1
      self.add_role(:admin) if self.roles.blank?
      self.add_role(:teacher)
      self.add_role(:student)
    else
      self.add_role(:teacher) if self.roles.blank?
      self.add_role(:student)
    end
  end

  validate :must_have_a_role, on: :update

  def online?
    updated_at > 2.minutes.ago
  end

  def buy_course(course)
    self.enrollments.create(course: course, price: course.price)
  end

  def view_lesson(lesson)
    user_lesson = self.user_lessons.where(lesson: lesson)
    unless user_lesson.any?
      self.user_lessons.create(lesson: lesson)
    else
      user_lesson.first.increment!(:impressions)
    end
  end

  def calculate_course_income
    update_column :course_income, (courses.map(&:income).sum)
    update_column :balance, (course_income - enrollment_expenses)    
  end
  
  def calculate_enrollment_expenses
    update_column :enrollment_expenses, (enrollments.map(&:price).sum)
    update_column :balance, (course_income - enrollment_expenses)  
  end
  

  private 
  def must_have_a_role
    unless roles.any?
      errors.add(:roles, "Must have at least one role")
    end    
  end  
  
end
