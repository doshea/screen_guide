# encoding: utf-8

class ShowPicUploader < CarrierWave::Uploader::Base

  include CarrierWave::RMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper
  include Sprockets::Rails::Helper

  # Choose what kind of storage to use for this uploader:
  storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  #TODO Change these to more relevant sizes
  version :large_unaltered do
    process :resize_to_fit => [225, 225]
  end

  version :medium_altered, from_version: :large_unaltered do
    process :resize_to_fill => [100, 100]
  end

  version :medium_unaltered, from_version: :large_unaltered do
    process :resize_to_fit => [75, 75]
  end

  version :small_altered, from_version: :medium_altered do
    process :resize_to_fill => [50, 50]
  end

  version :thumb, from_version: :small_altered do
    process :resize_to_fill => [27, 27]
  end

end
