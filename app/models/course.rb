class Course < ApplicationRecord
  belongs_to :user
  has_many :tuts, dependent: :destroy
  has_one_attached :thumbnail 

  has_many :payments
  has_many :users, through: :payments


  after_create :create_stripe_product_and_price
 

  # creates a product and sets price on stripe and saves both instance's IDs into the database. 
  def create_stripe_product_and_price
    product_course = Stripe::Product.create({
      name: self.title,
      description: self.description
    })
    update_column(:stripe_product_id, product_course.id)

    price_course = Stripe::Price.create({
        unit_amount: self.price * 100,
        currency: 'usd',
        product: self.stripe_product_id,
    })
    update_column(:stripe_price_id, price_course.id)
  end

  def self.ransackable_attributes(auth_object = nil)
    ["created_at", "description", "id", "price", "stripe_price_id", "stripe_product_id", "title", "updated_at", "user_id"]
  end
end
