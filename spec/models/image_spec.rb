# == Schema Information
#
# Table name: images
#
#  id                  :integer          not null, primary key
#  attachable_type     :string
#  height              :integer
#  key                 :string
#  main_image          :boolean          default(FALSE)
#  source_content_type :string
#  source_file_name    :string
#  source_file_size    :integer
#  source_updated_at   :datetime
#  token               :string
#  width               :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  attachable_id       :integer
#
# Indexes
#
#  index_images_on_attachable_type_and_attachable_id  (attachable_type,attachable_id)
#
require 'rails_helper'

RSpec.describe Image, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
