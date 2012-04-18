require 'csv'
require 'fog'

module ExportToCloud

  mattr_accessor :aws_access_key_id, :aws_secret_access_key, :s3_bucket, :path

  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods

    def export_to_cloud
      ExportToCloud::create_local_csv_file(self)
      ExportToCloud::send_to_s3(self)
      File.delete("#{Rails.root}/tmp/#{self.to_s}.csv")
    end

  end

  def self.create_local_csv_file(model_to_export)
    columns = model_to_export.column_names.collect {|x| x.titleize}

    file = File.open("#{Rails.root}/tmp/#{model_to_export.to_s}.csv", 'w') do |f|
      f.puts columns.to_csv
      model_to_export.find_each do |record|
        values = []
        record.attribute_names.each do |attr_name|
          value = record[attr_name]
          value = value.strftime('%Y-%m-%d at %I:%M%p') if value.respond_to?(:strftime)
          values.push value
        end
        f.puts values.to_csv      
      end
    end
  end
  
  def self.send_to_s3(model_to_export)
    connection = Fog::Storage.new({
      :provider                 => 'AWS',
      :aws_access_key_id        => ExportToCloud.aws_access_key_id,
      :aws_secret_access_key    => ExportToCloud.aws_secret_access_key
    })

    directory = connection.directories.get(ExportToCloud.s3_bucket)
    path = "#{ExportToCloud.path}" if ExportToCloud.path.present?
    filename = "#{model_to_export.to_s.pluralize.downcase}-#{Time.now.to_formatted_s(:number)}.csv"

    file = directory.files.create(
      :key    => "#{path}#{filename}",
      :body   => File.open("#{Rails.root}/tmp/#{model_to_export.to_s}.csv"),
      :public => true
    )

    file.save
  end
  
end

ActiveRecord::Base.send(:include, ExportToCloud)