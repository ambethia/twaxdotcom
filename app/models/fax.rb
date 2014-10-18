class Fax < ActiveRecord::Base

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

      tempfile = Tempfile.new("fax_id_#{id}.pdf") do |f|
        f.write fax.file.read
      end

      Magick::Image.read(tempfile.path).each.with_index do |image, index|
        image_tempfile = Tempfile.new("fax_#{id}_page_#{index}.png")
        image.write(image_tempfile.path)
        fax.pages.create(file: image_tempfile)
      end

      Fax.tweet_fax(id)
    end

    handle_asynchronously :convert_to_images

    def tweet_fax(id)
      fax = Fax.find(id)
      # Tweet...
    end

    handle_asynchronously :convert_to_images
  end
end
