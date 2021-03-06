# == Schema Information
#
# Table name: data_import.import_codec_groups
#
#  id           :integer          not null, primary key
#  o_id         :integer
#  name         :string
#  error_string :string
#

class Importing::CodecGroup  < Importing::Base
  self.table_name = 'data_import.import_codec_groups'
  attr_accessor :file

  self.import_attributes = ['name']

  self.import_class = ::CodecGroup

end
