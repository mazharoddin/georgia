# encoding: utf-8
class CkeditorPictureUploader < CarrierWave::Uploader::Base

  include Ckeditor::Backend::CarrierWave
  require 'carrierwave/processing/mini_magick'
  include CarrierWave::MiniMagick

  if Rails.env.development?
    storage :file
  else
    storage :fog
  end

  def store_dir
    "system/ckeditor_assets/pictures/"
  end

  def extension_white_list
    Ckeditor.image_file_types
  end

    process :read_dimensions

  version :thumb do
    process resize_to_fill: [160, 120]
  end

  version :big_thumb do
    process resize_to_fill: [460, 280]
  end

  version :big_thumb_bw do
    process resize_to_fill: [460, 280]
    process colorspace: 'Gray'
  end

  version :content do
    process resize_to_limit: [800, 800]
  end

  def colorspace(tone)
    manipulate! do |img|
      img.colorspace(tone)
      img = yield(img) if block_given?
      img
    end
  end

end
