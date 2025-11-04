require 'pg'
require_relative 'db_connector'
require_relative 'attr_accessor_man'

# module FerramentasDoJoao
#     def self.included(base)
#         base.extend(ClassMethods)
#     end

#  class Pessoa
#      include FerramentasDoJoao
   
#      atributos(name: :string, age: :int, birthdate: :datetime)
#      tabela :pessoas
#  end

Pessoa.migrate!

joao = Pessoa.new(name: "João", age: 30, birthdate: "1995-02-03")
joao.save!
puts joao.inspect

# print "teste 1: "
# pessoa_que_nao_existe = Pessoa.find(0) # esta funcao vai buscar a pessoa a base de dados a partir do ID
# puts pessoa_que_nao_existe.nil? ? "PASSADO" : "CHUMBADO"

# joao = Pessoa.new(name: "joao", age: 49, birthdate: "ontem") # esta funcao vai criar a pessoa na base de dados
# joao.save

# joao = Pessoa.find(0)

# print "teste 2: "
# puts joao.nil? ? "CHUMBADO" : "PASSADO"

# print "teste 3: "
# puts joao.name == "joao" ? "PASSADO" : "CHUMBADO"

# joao.name = "carlos"
# joao.save

# print "teste 4: "
# puts joao.name == "carlos" ? "PASSADO" : "CHUMBADO"


# joao = Pessoa.new(name: "João", age: 30, birthdate: "1995-02-03")
# joao.save

