class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  
  #-----------------------Associations-------------------#
  has_many :products, dependent: :destroy
  has_many :categories, :through  => :products

  #-----------------------Validations-------------------#
  validates_presence_of :first_name, :last_name, :shop_name
  validates :first_name, :last_name, length: {minimum: 4, maximum: 12}
  validates :shop_name, length: {minimum: 5, maximum: 20}
  
  #----------------------- Uploader -----------------------#
  mount_uploader :image, UserImageUploader

  #----------------------- User Admin Types -----------------------# 
  def self.admin_types
  	["AdminUser"]
  end

  #-----------------------Permalink-------------------#
  extend FriendlyId
  friendly_id :full_name, use: [:slugged]

  def full_name
    ("#{first_name} #{last_name}").titleize
  end

  #-----------Avoiding The Repeated Elements In The User Categories------------#
  def category_no_repeated
      self.categories.select(:id, :name, :slug, :color).uniq
  end

  #-----------------------print if user is banned or not-----------------------#
  def is_banned?
    self.ban ? "This user is banned" : "This user isn't banned"  
  end

end