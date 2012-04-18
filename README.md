export\_to_cloud
================

export\_to_cloud provides a simple way to export all rows of an ActiveRecord model in Rails to Amazon S3 as a time-stamped single CSV file.

Usage
=====

### Require the gem

    gem 'export_to_cloud', :git => "git://github.com/mattfordham/export_to_cloud.git"
    
### Configure

Create an initializer in 'config/initializers' called something like 'export\_to_cloud.rb'. Set the following config variables:

    ExportToCloud.aws_access_key_id = "your_access_id"
    ExportToCloud.aws_secret_access_key = "your_secret_key"
    ExportToCloud.s3_bucket = "your_bucket_name"
    ExportToCloud.path = "path/to/directory/" # set as an empty string if you want the CSV files to end up in the root of the bucket

### Call 
  
Call the method on any of your models, like so...

    Person.export_to_cloud
    
I usually make this call in a cron job or manually via the console. 

To Do
=====

Add some tests. If anyone has an idea how to pull if off, given the S3 integration, I'm all ears :)