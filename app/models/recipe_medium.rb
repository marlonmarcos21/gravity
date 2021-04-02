class RecipeMedium < ApplicationRecord
  include ImageUploader[:file]

  belongs_to :user
end
