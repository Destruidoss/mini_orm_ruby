require 'pg'

conn = PG.connect(
  host: 'localhost',
  port: 5432,
  dbname: 'tododb',
  user: 'joaonatal',
  password: '123456'
)

conn.exec("CREATE TABLE IF NOT EXISTS pessoas (id SERIAL PRIMARY KEY, name VARCHAR, age INT, birthdate TIMESTAMP)")

conn.exec("INSERT INTO pessoas (name, age, birthdate) VALUES ('joao', 49, NOW())")

res = conn.exec("SELECT * FROM pessoas")
res.each { |row| puts row }
