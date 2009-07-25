class Screenshot < ActiveRecord::Base
  belongs_to :app

  has_attachment :content_type => :image, :thumbnails => {:thumb => '130x130>'},
    :storage => :file_system, :path_prefix => 'public/assets/screenshots', :processor => :Rmagick

  validates_as_attachment
end
