#lib/pessoa.rb
require_relative 'base_record'
# == Modelo: Pessoa ==
class Pessoa < BaseRecord
  atributos(
    name:      :string,
    age:       :int,
    birthdate: :datetime,
    email:     :string,
    phone:     :string,
    status:    :string
  )
  tabela :pessoas

  # === Interface de Usuário ===
  def self.menu
    loop do
      puts "\n" + "=" * 40
      puts "      MINI-ORM - GERENCIADOR DE PESSOAS"
      puts "=" * 40
      puts "1 - Cadastrar pessoa"
      puts "2 - Listar todos"
      puts "3 - Buscar por ID"
      puts "4 - Atualizar pessoa"
      puts "5 - Apagar pessoa"
      puts "6 - Sair"
      print "Escolha (1-6): "
      opcao = gets.chomp

      case opcao
      when "1" then cadastrar
      when "2" then listar
      when "3" then buscar
      when "4" then atualizar
      when "5" then apagar
      when "6"
        puts "Adeus! Até a próxima!"
        break
      else
        puts "Opção inválida!"
      end
    end
  end

  def self.cadastrar
    print "Nome: "
    nome = gets.chomp
    print "Idade: "
    idade = gets.chomp.to_i
    print "Email: "
    email = gets.chomp
    print "Telefone: "
    telefone = gets.chomp
    print "Status (ativo/inativo): "
    status = gets.chomp

    pessoa = create(
      name: nome,
      age: idade,
      email: email,
      phone: telefone,
      status: status
    )
    puts "Pessoa criada com ID: #{pessoa.id}"
  end

  def self.listar
    pessoas = todos
    if pessoas.empty?
      puts "Nenhuma pessoa cadastrada."
    else
      puts "\nPESSOAS CADASTRADAS:"
      pessoas.each do |p|
        puts "#{p.id} | #{p.name} | #{p.email} | #{p.status}"
      end
    end
  end

  def self.buscar
    print "Digite o ID: "
    id = gets.chomp.to_i
    pessoa = find(id)
    if pessoa
      puts "Encontrada: #{pessoa.name} (#{pessoa.email})"
    else
      puts "ID não encontrado."
    end
  end

  def self.atualizar
    print "ID da pessoa: "
    id = gets.chomp.to_i
    pessoa = find(id)
    return puts "Não encontrado." unless pessoa

    print "Novo nome (Enter para manter): "
    novo_nome = gets.chomp
    pessoa.name = novo_nome unless novo_nome.empty?

    print "Novo email: "
    novo_email = gets.chomp
    pessoa.email = novo_email unless novo_email.empty?

    pessoa.save!
    puts "Atualizado com sucesso!"
  end

  def self.apagar
    print "ID para apagar: "
    id = gets.chomp.to_i
    delete(id)
  end
end

