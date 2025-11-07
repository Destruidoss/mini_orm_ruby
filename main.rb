#main.rb archive principal for request operations and tests
require_relative 'lib/people'
require_relative 'lib/product'
# === Execução do programa inteiro ===
# People.migrate!
# People.menu_interface_people
Product.migrate!
Product.menu_interface_product

# === Execução do programa inteiro porem inserindo manualmente===
# criapessoa = Pessoa.new(name: "Maria", 
#                         age: 30, 
#                         birthdate: "1995-02-03", 
#                         email:  "teste@teste.com",
#                         phone:  "+351999999999",
#                         status: "ativo")
# criapessoa.save!
# puts criapessoa.inspect
# criapessoa.name = "maria silva"
# criapessoa.birthdate = "2000-01-01"
# criapessoa.save!
# Pessoa.delete(67)