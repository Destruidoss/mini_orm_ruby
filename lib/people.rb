# #lib/people.rb
# require_relative 'base_record'
# # == Model: People ==
# class People < BaseRecord
#   atributes(
#     name:      :string,
#     age:       :int,
#     birthdate: :datetime,
#     email:     :string,
#     phone:     :string,
#     status:    :string
#   )
#   table :people

# #call menu
#   def self.menu_interface_people
#     loop do
#       puts "\n" + "=" * 40
#       puts "      MINI-ORM - MANAGER"
#       puts "=" * 40
#       puts "1 - register People"
#       puts "2 - list all People in base"
#       puts "3 - find ID especific"
#       puts "4 - update People"
#       puts "5 - Delete People through ID"
#       puts "6 - Go to menu Product"
#       puts "7 - Exit"
#       print "Make your choice between (1-6): "
#       option = gets.chomp

#       case option
#       when "1" then register
#       when "2" then list
#       when "3" then find
#       when "4" then update
#       when "5" then delete
#       when "6"
#         puts "By! See you!"
#         break
#       else
#         puts "option invalid!"
#       end
#     end
#   end

#   def self.register
#     print "name: "
#     name = gets.chomp
#     print "age: "
#     age = gets.chomp.to_i
#     print "Email: "
#     email = gets.chomp
#     print "Phone: "
#     phone = gets.chomp
#     print "Status (Active/Inactive): "
#     status = gets.chomp

#     people = create(
#       name: name,
#       age: age,
#       email: email,
#       phone: phone,
#       status: status
#     )
    
#     puts "People created with ID: #{people.id}"
#   end

#   def self.list
#     people = all
#     if people.empty?
#       puts "None people registered."
#     else
#       puts "\nPEOPLE REGISTERED:"
#       people.each do |p|
#         puts "#{p.id} | #{p.name} | #{p.email} | #{p.status}"
#       end
#     end
#   end

#   def self.find
#     print "Type the ID: "
#     id = gets.chomp.to_i
#     people = find(id)
#     if people
#       puts "Found: #{people.name} (#{people.email})"
#     else
#       puts "ID not found."
#     end
#   end

#   def self.update
#     print "Person ID: "
#     id = gets.chomp.to_i
#     people = find(id)
#     return puts "Not found." unless people

#     print "New Name (Press Enter for keep): "
#     new_name = gets.chomp
#     people.name = new_name unless new_name.empty?

#     print "New email: "
#     new_email = gets.chomp
#     people.email = new_email unless new_email.empty?

#     people.save!
#     puts "Updated with success!"
#   end

#   def self.delete
#     print "ID for delete: "
#     id = gets.chomp.to_i
#     delete(id)
#   end
# end


