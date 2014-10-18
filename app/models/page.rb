class Page < ActiveRecord::Base
  belongs_to :fax
  mount_uploader :file, PageUploader
end
