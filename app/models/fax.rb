class Fax < ActiveRecord::Base
  belongs_to :user
  has_many :pages
  mount_uploader :file, FaxUploader

  class << self
    def handle_incoming_fax(options)
      Phaxio.get_fax_file(id: options[:phaxio_id], type: 'p') do |file|
        fax = Fax.create options.merge(file: file)
        Fax.convert_to_images(fax.id)
      end
    end

    handle_asynchronously :handle_incoming_fax

    def convert_to_images(id)
      fax = Fax.find(id)

      tempfile = Tempfile.new("fax_id_#{id}.pdf")
      File.open(tempfile.path, 'wb+') { |f| f.write fax.file.read }

      pdf = Grim.reap(tempfile.path)

      contents = ""
      pdf.each_with_index do |image, index|
        image_tempfile = Tempfile.new(["fax_#{id}_page_#{index}", ".png"])
        text_tempfile = Tempfile.new(["fax_#{id}_page_#{index}", ".txt"])

        saved = image.save(image_tempfile.path)

        puts "Starting tesseract"
        %x(tesseract #{image_tempfile.path} #{text_tempfile.path})

        # puts "Reading result"
        File.open(text_tempfile.path + ".txt") do |file|
          contents << file.read + "\n"
        end

        fax.pages.create!(file: image_tempfile)
      end

      tweet = OutgoingTweet.new
      tweet.fax = fax
      tweet.user = fax.user
      tweet.message = contents.strip
      tweet.save!

      # Fax.tweet_fax(id)
    end

    handle_asynchronously :convert_to_images

    def tweet_fax(id)
      fax = Fax.find(id)
      # Tweet...
    end

    handle_asynchronously :tweet_fax
  end
end
