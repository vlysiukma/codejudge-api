# frozen_string_literal: true

class User < ApplicationRecord
  has_secure_password

  has_many :submissions, dependent: :nullify

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 8 }, if: -> { password.present? }
  validates :username, length: { minimum: 1 }, allow_blank: true
  validates :role, inclusion: { in: %w[student instructor admin] }
end
