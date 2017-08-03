Spree::LineItem.class_eval do
  has_many :digital_links, dependent: :destroy

  def digital?
    variant.digital? || variant.product.master.digital?
  end

  def create_digital_links
    digital_links.delete_all

    #include master variant digitals
    master = variant.product.master
    create_digital_links_for_variant(master) if master.digital?
    create_digital_links_for_variant(variant) unless variant.is_master
  end

  private

  def create_digital_links_for_variant(variant)
    variant.digitals.each do |digital|
      self.quantity.times do
        digital_links.create!(digital: digital)
      end
    end
  end
end
