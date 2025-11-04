require 'pg'

module DBConnector
  @@connection = nil

  def self.connection
    return @@connection if @@connection

    @@connection = PG.connect(
      host: 'localhost',
      port: 5432,
      dbname: 'tododb',
      user: 'joaonatal',
      password: '123456'
    )
    puts "[DBConnector] Conectado ao PostgreSQL!"
    @@connection
  end

  def self.disconnect
    if @@connection
      @@connection.close
      @@connection = nil
      puts "[DBConnector] Conexão encerrada."
    end
  end
end
