require 'csv'
require 'fog'

module ExportToCloud
  
  mattr_accessor :aws_access_key_id, :aws_secret_access_key, :s3_bucket, :path
  
  def self.included(base)
    base.extend(ClassMethods)
  end
  
  module ClassMethods

    def export_to_cloud
      columns = Person.column_names.collect {|x| x.titleize}
      
      file = File.open("#{Rails.root}/tmp/#{self.to_s}.csv", 'w') do |f|
        f.puts columns.to_csv
        self.find_each do |record|
          values = []
          record.attribute_names.each do |attr_name|
            value = record[attr_name]
            value = value.strftime('%Y-%m-%d at %I:%M%p') if value.respond_to?(:strftime)
            values.push value
          end
          f.puts values.to_csv      
        end
      end

      connection = Fog::Storage.new({
        :provider                 => 'AWS',
        :aws_access_key_id        => ExportToCloud.aws_access_key_id,
        :aws_secret_access_key    => ExportToCloud.aws_secret_access_key
      })
      
      directory = connection.directories.get(ExportToCloud.s3_bucket)
      path = "#{ExportToCloud.path}" if ExportToCloud.path.present?
      filename = "#{self.to_s.pluralize.downcase}-#{Time.now.to_formatted_s(:number)}.csv"
      
      file = directory.files.create(
        :key    => "#{path}#{filename}",
        :body   => File.open("#{Rails.root}/tmp/#{self.to_s}.csv"),
        :public => true
      )
      
      file.save
      
      File.delete("#{Rails.root}/tmp/#{self.to_s}.csv")
    end
  end

ActiveRecord::Base.send(:include, ExportToCloud)