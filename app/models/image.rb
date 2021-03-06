class Image < ApplicationRecord
  has_attached_file :photo, styles: { processed: ["800x800>",:jpg] }
  validates_attachment_content_type :photo, content_type: /\Aimage\/.*\z/

  validates :photo, attachment_presence: true
  validates :uid, presence: true, uniqueness: true
  before_validation :generate_uid, on: :create

  def relative_path
    photo.path(:processed).gsub("#{Rails.root}/", '')
  end

  def faces
    read_attribute(:faces).map(&:deep_symbolize_keys)
  end

  def processed_photo_url
    photo.url(:processed)
  end

  private

  def generate_uid
    self.uid = loop do
      uid = SecureRandom.urlsafe_base64

      break uid unless Image.where(uid: uid).exists?
    end
  end
end
