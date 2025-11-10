#lib/product.rb
require_relative 'base_record'
# == Model: Product ==

class Product < BaseRecord
  atributes(
    product_name: :string,
    expiration_date: :datetime,
    price: :float,
    supplier: :string
  )
  table :product

#call menu
  def self.menu_interface_product
    loop do
      puts "\n" + "=" * 40
      puts "      MINI-ORM - MANAGER PRODUCT"
      puts "=" * 40
      puts "1 - register Product"
      puts "2 - list all Product in base"
      puts "3 - find ID especific"
      puts "4 - update Product"
      puts "5 - Delete Product through ID"
      puts "6 - Go to menu People"
      print "Make your choice between (1-6): "
      option = gets.chomp

      case option
      when "1" then register
      when "2" then list
      when "3" then find
      when "4" then update
      when "5" then delete
      when "6" 
        puts "By! See you!"
      People.menu_interface_people
        
      else
        puts "option invalid!"
        puts "By! See you!"
        break
      end
    end
  end


  def self.register
    print "product_name: "
    product_name = gets.chomp
    print "expiration_date: "
    if expiration_date = gets.chomp
    raise ArgumentError, "atributes missing" if atributes.nil?
    expiration_date.DateTime.strptime(expiration_date, '%Y-%m-%d')
    print "price: "
    price = gets.chomp
    print "supplier: "
    supplier = gets.chomp

    product = create(
      product_name: product_name,
      expiration_date:  expiration_date,
      price: price,
      supplier: supplier
    )

    puts "Product created with success! #{product.id}"
  end

  def self.list
    product = all
    if product.empty?
      puts "None product registered."
    else
      puts "\nProduct Registered: "
      product.each do |pr|
        puts "#{pr.id} | #{pr.product_name} | #{pr.expiration_date} | #{pr.price} | #{pr.supplier}"
      end
    end
  end

  def self.find
    print "Type the ID: "
    id = gets.chomp.to_i
    product = find(id)
    if product
      puts "Found #{product.product_name} (#{product.price})"
    else
      puts "ID not found."
    end
  end

  def self.update
    print "Product ID: "
    id =  gets.chomp.to_i
    product = find(id)
    return puts "Not found" unless product

    print "New Name (Press Enter for keep): "
    new_name = gets.chomp
    product.product_name = new_name unless new_name.empty?

    print "New Price: "
    new_price = gets.chomp
    product.price = new_price unless  new_price.empty?

    product.save!
    puts "Updated with success!"

  end
end
end
