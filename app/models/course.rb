class Course < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: :slugged

    validates :title, :short_description, :language, :level, :price, presence:true
    validates :description, presence:true, length:{minimum:5}
    validates :title, uniqueness: true, length:{maximum:100}
    validates :short_description, length:{maximum:300}
    validates :price, numericality: {greater_than_or_equal_to: 0}

    scope :published, -> { where(published:true) }
    scope :unpublished, -> { where(published:false) }
    scope :approved, -> { where(approved:true) }
    scope :unapproved, -> { where(approved:false) }

    has_rich_text :description
    belongs_to :user, counter_cache: true
    # User.find_each { |user| User.reset_counters(user.id, :courses) }

    has_many :lessons, dependent: :destroy, inverse_of: :course
    has_many :enrollments, dependent: :restrict_with_error
    has_many :user_lessons, through: :lessons
    has_many :course_tags, dependent: :destroy
    has_many :tags, through: :course_tags

    accepts_nested_attributes_for :lessons, reject_if: :all_blank, allow_destroy: true

    has_one_attached :avatar
    validates :avatar, presence:true, on: :update
    validates :avatar, content_type: [:png, :jpg, :jpeg], size: { less_than: 500.kilobytes , message: 'size should be under 500 kiobytes' }
    # validates :avatar, attached: true, content_type: [:png, :jpg, :jpeg], size: { less_than: 500.kilobytes , message: 'size should be under 500 kiobytes' }

    def to_s
        title
    end

    LANGUAGES=[:"English", :"Russian", :"Polish"]
    def self.languages
        LANGUAGES
    end

    LEVELS=[:"Beginner", :"Intermediate", :"Expert"]
    def self.levels
        LEVELS
    end

    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }

    def bought(user)
        self.enrollments.where(user_id: [user.id], course_id: [self.id]).any?
    end

    def update_rating
        if enrollments.any? && enrollments.where.not(rating: nil).any?
            update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
        else
            update_column :average_rating, (0)
        end
    end

    def progress(user)
        unless self.lessons_count == 0
            user_lessons.where(user: user).count / self.lessons_count.to_f*100
        end
    end

    def calculate_income
        update_column :income, (enrollments.map(&:price).sum)
        user.calculate_course_income
    end    
    

end
