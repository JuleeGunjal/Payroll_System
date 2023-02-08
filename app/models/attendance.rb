# frozen_string_literal: true

class Attendance < ApplicationRecord
  validates :month, presence: true
  validates :employee_id, presence: true

  belongs_to :employee
end
