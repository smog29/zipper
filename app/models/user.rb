class User < ApplicationRecord
  has_secure_password

  has_many_attached :files

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :password, format: {
    with: /\A(?=.*[A-Z])(?=.*[\W])/,
    message: "Must include at least one uppercase letter and one special character"
  }, allow_nil: true
end
