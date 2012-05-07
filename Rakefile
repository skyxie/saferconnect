
namespace :db do
  desc "Create database"
  task :create_database do
    conn = PGConn.open()
    conn.exec("CREATE DATABASE saferconnect WITH ENCODING=UTF8")
    conn.close()
  end
end

