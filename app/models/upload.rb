class Upload < ActiveRecord::Base
  belongs_to :user
  
  has_attachment :content_type => :image, :thumbnails => {:thumb => '500x500>', :mini => '100x100>'},
    :storage => :file_system, :path_prefix => 'public/assets', :processor => :Rmagick

  validates_as_attachment

  def self.find_thumbnails(thumbnail, options = {})
    with_scope :find => options do
      find_all_by_thumbnail(thumbnail, :order => 'created_at DESC')
    end
  end
end
