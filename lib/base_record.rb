#libs/base_record.rb neccessaries for operation
require 'pg'
require_relative 'db_connector'
require_relative 'attr_accessor_man'

# == BaseRecord: Mini-ORM for PostgreSQL ==
# Provides CRUD with automatic migrations and soft delete.
class BaseRecord
  extend AttrAccessorMan
  attr_accessor :id

  # === INITIALIZE MAIN ===
  def initialize(attrs)
    attrs.each { |key, value| send("#{key}=", value) }
  end

  # === Persistency in datas like selects for consults and create tables and updates===
  def save!
    raise ArgumentError, "Atributes or tables missing" if self.class.atributos.nil? || self.class.tabela.nil?

    conn   = DBConnector.connection
    columns = self.class.atributos.keys
    values  = columns.map { |col| send(col) }

    if @id.nil?
      # INSERT
      placeholders = (1..values.size).map { |i| "$#{i}" }.join(", ")
      sql = "INSERT INTO #{self.class.tabela} (#{columns.join(', ')}) VALUES (#{placeholders}) RETURNING id;"

      result = conn.exec_params(sql, values)
      self.id = result[0]['id'].to_i
      puts "Registro salvo com id #{id}."
    else
      # UPDATE
      set_clause = columns.map.with_index(1) { |c, i| "#{c} = $#{i}" }.join(", ")
      set_clause += ", updated_at = NOW()"
      sql = "UPDATE #{self.class.tabela} SET #{set_clause} WHERE id = $#{values.size + 1};"

      conn.exec_params(sql, values << id)
      puts "Registro atualizado (id #{id})."
    end
  end

  # === Criação Rápida ===
  def self.create(attrs)
    new(attrs).tap { |p| p.save! }
  end

  # === Definição de Atributos ===
  def self.atributos(attrs = nil)
    unless attrs.nil?
      @atributos = attrs
      my_attr_accessor(*attrs.keys)
    end
    @atributos
  end

  # === Busca ===
  def self.find!(id)
    raise ArgumentError, "Atributos faltando" if atributos.nil?
    raise ArgumentError, "Tabela faltando" if tabela.nil?

    conn = DBConnector.connection
    cols = atributos.keys.join(', ')
    sql = "SELECT #{cols}, id FROM #{tabela} WHERE id = $1 AND deleted_at IS NULL LIMIT 1;"
    result = conn.exec_params(sql, [id])

    raise StandardError, "Não encontrado" if result.ntuples.zero?

    row = result[0]
    attrs = row.slice(*atributos.keys.map(&:to_s)).transform_keys(&:to_sym)
    attrs[:id] = row['id'].to_i
    new(attrs)
  end

  def self.find(id)
    find!(id)
  rescue
    nil
  end

  def self.todos
    conn = DBConnector.connection
    sql = "SELECT * FROM #{tabela} WHERE deleted_at IS NULL ORDER BY id;"
    result = conn.exec(sql)

    result.map do |row|
      attrs = row.slice(*atributos.keys.map(&:to_s)).transform_keys(&:to_sym)
      attrs[:id] = row['id'].to_i
      new(attrs)
    end
  end

  # === Soft Delete ===
  def self.delete(id)
    return if id.nil?

    conn = DBConnector.connection
    sql = "UPDATE #{tabela} SET deleted_at = NOW() WHERE id = $1;"
    conn.exec_params(sql, [id])
    puts "Registro apagado (soft delete)."
  end

  # === Migrate ===
  def self.migrate!
    raise ArgumentError, "Atributos faltando" if atributos.nil?
    raise ArgumentError, "Tabela faltando" if tabela.nil?

    conn = DBConnector.connection

    # field of user
    field = atributos.map do |nome, tipo|
      tipo_sql = case tipo
                 when :string then "VARCHAR(255)"
                 when :int then "INTEGER"
                 when :datetime then "TIMESTAMP"
                 else raise NotImplementedError, "Tipo #{tipo} não suportado"
                 end
      "#{nome} #{tipo_sql}"
    end.join(", ")

    # FIELDS INTERN 
    field += ", updated_at TIMESTAMP DEFAULT NOW()"
    field += ", deleted_at TIMESTAMP"

    # CREATE THE TABLE NECESSARY FOR NEW FIELDS
    sql = "CREATE TABLE IF NOT EXISTS #{tabela} (id SERIAL PRIMARY KEY, #{field});"
    conn.exec(sql)

    # ADD Columns new
    atributos.each { |nome, tipo| add_column!(tabela, nome, tipo) }
    add_column!(tabela, :created_at, :datetime)
    add_column!(tabela, :updated_at, :datetime)
    add_column!(tabela, :deleted_at, :datetime)

    puts "Migrate finished for #{tabela}."
  end

  # === SHOW COLUNS EXISTING IN DATABASE ===
  def self.column_exists?(table, column)
    conn = DBConnector.connection
    sql = "SELECT 1 FROM information_schema.columns WHERE table_name = $1 AND column_name = $2;"
   
    result = conn.exec_params(sql, [table.to_s, column.to_s])
    result.ntuples > 0
  end

  def self.add_column!(table, column, type)
    return if column_exists?(table, column)

    conn = DBConnector.connection
    sql_type = case type
               when :string then "VARCHAR(255)"
               when :int then "INTEGER"
               when :datetime then "TIMESTAMP"
               end

    sql = "ALTER TABLE #{table} ADD COLUMN #{column} #{sql_type};"
    conn.exec(sql)
    puts "Column #{column} add in table #{table}."
  end

  # === Name of table ===
  def self.tabela(name = nil)
    @tabela = name unless name.nil?
    @tabela
  end
end
