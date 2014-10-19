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
      Phaxio.get_fax_file(id: options[:phaxio_id], type: 'p') do |file|
        user = User.find(options.metadata.to_i)
        if user
          faxe = user.faxes.create(options.merge(file: file))
          Fax.convert_to_images(fax.id)
        else
          # TODO: Tweet fax from our own account?
        end
      end
    end
    handle_asynchronously :handle_incoming_fax

    def convert_to_images(id)
      fax = Fax.find(id)

      tempfile = Tempfile.new("fax_id_#{fax.id}.pdf")
      File.open(tempfile.path, 'wb+') { |f| f.write fax.file.read }

      pdf = Grim.reap(tempfile.path)

      contents = ""
      pdf.each_with_index do |image, index|
        image_tempfile = Tempfile.new(["fax_#{fax.id}_page_#{index}", ".png"])
        text_tempfile = Tempfile.new(["fax_#{fax.id}_page_#{index}", ".txt"])
        cropped_tempfile = Tempfile.new(["fax_#{fax.id}_page_#{index}_cropped", ".png"])

        image.save(image_tempfile.path)

        %x(convert -crop 820x420+75+245 #{image_tempfile.path} #{cropped_tempfile.path})

        %x(tesseract #{cropped_tempfile.path} #{text_tempfile.path})

        File.open(text_tempfile.path + ".txt") do |file| # omfg so stupid, w/e
          contents << file.read + "\n"
        end

        fax.pages.create!(file: cropped_tempfile)

        cropped_tempfile.unlink
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
