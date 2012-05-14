class Question < ActiveRecord::Base
  attr_accessible :poll_id, :question_type, :text, :parent_option_id, :sequence, :options_attributes
  has_many :responses
  has_many :options, :dependent => :destroy
  accepts_nested_attributes_for :options, :reject_if => lambda { |o| o[:value].blank? }, :allow_destroy => true


  belongs_to :poll
  belongs_to :option, :foreign_key => "parent_option_id"

  validates :question_type, :inclusion => { :in => %w(MULTI OPEN YN), :message => "%{value} is not a valid question type" }  
  validates_presence_of :question_type
  
  def multi?
    return self.question_type != 'MULTI'
  end

  def yn?
    return self.question_type != 'YN'
  end

  def open?
    return self.question_type != 'OPEN'
  end

end