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
    raise ArgumentError, "Atributes or tables missing" if self.class.atributes.nil? || self.class.table.nil?

    conn   = DBConnector.connection
    columns = self.class.atributes.keys
    values  = columns.map { |col| send(col) }

    if @id.nil?
      # INSERT
      placeholders = (1..values.size).map { |i| "$#{i}" }.join(", ")
      sql = "INSERT INTO #{self.class.table} (#{columns.join(', ')}) VALUES (#{placeholders}) RETURNING id;"

      result = conn.exec_params(sql, values)
      self.id = result[0]['id'].to_i
      puts "Registry saved with id #{id}."
    else
      # UPDATE
      set_clause = columns.map.with_index(1) { |c, i| "#{c} = $#{i}" }.join(", ")
      set_clause += ", updated_at = NOW()"
      sql = "UPDATE #{self.class.table} SET #{set_clause} WHERE id = $#{values.size + 1};"

      conn.exec_params(sql, values << id)
      puts "Registry updated with (id #{id})."
    end
  end

  # === Create using save! function ===
  #tap  show the result, after the execute
  def self.create(attrs)
    new(attrs).tap { |p| p.save! }
  end

  # === Defining Atributes ===
  def self.atributes(attrs = nil)
    unless attrs.nil?
      @atributes = attrs
      my_attr_accessor(*attrs.keys)
    end
    @atributes
  end

  # === Search ===
  def self.find!(id)
    raise ArgumentError, "atributes missing" if atributes.nil?
    raise ArgumentError, "table missing" if table.nil?

    conn = DBConnector.connection
    cols = atributes.keys.join(', ')
    sql = "SELECT #{cols}, id FROM #{table} WHERE id = $1 AND deleted_at IS NULL LIMIT 1;"
    result = conn.exec_params(sql, [id])

    raise StandardError, "Not found" if result.ntuples.zero?

    row = result[0]
    attrs = row.slice(*atributes.keys.map(&:to_s)).transform_keys(&:to_sym)
    attrs[:id] = row['id'].to_i
    new(attrs)
  end

  def self.find(id)
    find!(id)
  rescue
    nil
  end

  def self.find_by(**args)
    where(**args).first
    # how to use: People.find_by(email: "a")
  end

  def self.where(**args)
    raise ArgumentError, "Atributes not found, try again" if args.empty?
    conn = DBConnector.connection

    cols = args.keys.map.with_index { |key, value| "#{key} = $#{value + 1}"}.join(" AND ")
    val = args.values

    sql = "SELECT * FROM #{table} WHERE #{cols}"
    result = conn.exec_params(sql, val)

    result.map do |row|
      attrs = row.slice(*atributes.keys.map(&:to_s)).transform_keys(&:to_sym)
      attrs[:id] = row["id"].to_i if row["id"]
      new(attrs)
    end
  end

  def self.all
    conn = DBConnector.connection
    sql = "SELECT * FROM #{table} WHERE deleted_at IS NULL ORDER BY id;"
    result = conn.exec(sql)

    result.map do |row|
      attrs = row.slice(*atributes.keys.map(&:to_s)).transform_keys(&:to_sym)
      attrs[:id] = row['id'].to_i
      new(attrs)
    end
  end

  # def self.selected(*args)
  #   raise ArgumentError, "Atributes not found, try again"

  #   args
  #   conn = DBConnector.connection
  #   cols = args.map(&:to_s).join(", ")
  #   sql = "SELECT #{cols}, id FROM #{table}"
  #   result = conn.exec(sql)

  #   result.map do |row|
  #     attrs = row.slice(*args.keys.map(&:to_s)).transform_keys(&:to_sym)
  #     attr
  #   end
  # end

  # === Soft Delete ===
  def self.delete(id)
    return if id.nil?

    conn = DBConnector.connection
    sql = "UPDATE #{table} SET deleted_at = NOW() WHERE id = $1;"
    conn.exec_params(sql, [id])
    puts "Registry deleted (soft delete)."
  end

  # === Migrate ===
  def self.migrate!
    raise ArgumentError, "atributes missing" if atributes.nil?
    raise ArgumentError, "table missing" if table.nil?

    conn = DBConnector.connection

    # field of user
    field = atributes.map do |name, type|
      type_sql = case type
                 when :string then "VARCHAR(255)"
                 when :int then "INTEGER"
                 when :datetime then "TIMESTAMP"
                 when :float then "NUMERIC(25,10)"
                 else raise NotImplementedError, "Type #{type} not suported"
                 end
      "#{name} #{type_sql}"
    end.join(", ")

    # FIELDS created for news fields and functions
    field += ", updated_at TIMESTAMP DEFAULT NOW()"
    field += ", deleted_at TIMESTAMP"

    # CREATE THE TABLE NECESSARY FOR NEW FIELDS
    sql = "CREATE TABLE IF NOT EXISTS #{table} (id SERIAL PRIMARY KEY, #{field});"
    conn.exec(sql)

    # ADD Columns new
    atributes.each { |name, type| add_column!(table, name, type) }
    add_column!(table, :created_at, :datetime)
    add_column!(table, :updated_at, :datetime)
    add_column!(table, :deleted_at, :datetime)

    puts "Migrate finished for #{table}."
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
  def self.table(name = nil)
    @table = name unless name.nil?
    @table
  end
end
