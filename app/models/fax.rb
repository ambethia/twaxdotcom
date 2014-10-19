class Fax < ActiveRecord::Base
  belongs_to :user
  has_many :pages
  mount_uploader :file, FaxUploader

  has_one :outgoing_tweet

  after_create :track

  def track
    Analytics.track(user_id: user.id, event: 'Receive Twax')
  end
  handle_asynchronously :track

  def permalink
    Rails.application.routes.url_helpers.fax_url(id, :host => ENV["DOMAIN_NAME"])
  end

  class << self

    def handle_incoming_fax(options)
      user = User.find(options.metadata.to_i)
      if user
        fax = user.faxes.create(options)
        Fax.convert_to_images(fax.id)
      else
        Fax.create(options)
      end
    end

    def convert_to_images(id)
      fax = Fax.find(id)

      tempfile = Tempfile.new("fax_id_#{fax.id}.pdf")
      File.open(tempfile.path, 'wb+') { |f| f.write fax.file.read }

      pdf = Grim.reap(tempfile.path)

      contents = ""
      pdf.each_with_index do |image, index|
        image_tempfile = Tempfile.new(["fax_#{fax.id}_page_#{index}", ".png"])
        text_tempfile = Tempfile.new(["fax_#{fax.id}_page_#{index}", ".txt"])

        image.save(image_tempfile.path)

        %x(tesseract #{image_tempfile.path} #{text_tempfile.path})

        File.open(text_tempfile.path + ".txt") do |file| # omfg so stupid, w/e
          contents << file.read + "\n"
        end

        fax.pages.create!(file: image_tempfile)

        image_tempfile.unlink
        text_tempfile.unlink
      end

      outgoing_tweet = fax.create_outgoing_tweet! do |tweet|
        tweet.user = fax.user
        tweet.message = contents.strip
      end
      tweet = outgoing_tweet.deliver
      outgoing_tweet.tweet_id = tweet.id
      outgoing_tweet.save

      tempfile.unlink
    end
    handle_asynchronously :convert_to_images
  end
end
