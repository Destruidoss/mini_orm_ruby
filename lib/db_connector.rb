require 'pg'

module DBConnector
  @@connection = nil

  def self.connection
    return @@connection if @@connection

    @@connection = PG.connect(
      host: 'LOCALHOST',
      port: 5432,
      dbname: 'tododb',
      user: 'joaonatal',
      password: '123456'
    )
    puts "[DBConnector] Connected to PostgreSQL!"
    @@connection
  end

  def self.disconnect
    if @@connection
      @@connection.close
      @@connection = nil
      puts "[DBConnector] Connection closed."
    end
  end
end
