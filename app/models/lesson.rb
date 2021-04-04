class Lesson < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  include RankedModel
  ranks :row_order, with_same: :course_id
  
  validates :title, :course, presence: true
  validates :title, length:{maximum:70}
  validates_uniqueness_of :title, scope: :course_id

  # Course.find_each { |course| Course.reset_counters(course.id, :lessons) }
  has_many :comments, dependent: :nullify
  has_many :user_lessons, dependent: :destroy
  belongs_to :course, counter_cache: true
  has_rich_text :content

  has_one_attached :video
  has_one_attached :video_thumbnail
  validates :video, presence:true, content_type: [:mp4], size: { less_than: 50.megabytes , message: 'size should be under 50 megabytes' }
  validates :video_thumbnail, content_type: [:png, :jpg, :jpeg], size: { less_than: 500.kilobytes , message: 'size should be under 500 kiobytes' }

  validates :video_thumbnail, presence: true, if: :video_present?
  def video_present?
    self.video.present?
  end
  

  include PublicActivity::Model
  tracked owner: Proc.new{ |controller, model| controller.current_user }

  def viewed(user)
    self.user_lessons.where(user: user).present?
  end

  def prev
    course.lessons.where("row_order < ?", row_order).order(:row_order).last
  end

  def next
    course.lessons.where("row_order > ?", row_order).order(:row_order).first
  end
  

end
