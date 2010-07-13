require 'machinist/active_record'

User.blueprint do 
  login { "user#{sn}" }
  email { "#{login}@example.com" }
  password              { "ffasdf" } 
  password_confirmation    { password } 
end


Ping.blueprint do
  user  
  latitude = (rand * 180 - 90).round 4
  longitude = (rand * 180 - 90).round 4
end

