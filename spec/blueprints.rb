require 'machinist/active_record'

User.blueprint do 
  login { "user#{sn}" }
  email { "email#{sn}@example.com" }
  password    { "123456" }
end

Ping.blueprint do
  user  
  lat { (rand * 180 - 90).round 4 }
  lon { (rand * 180 - 90).round 4 }
end

VcardField.blueprint do
  user
  name { 'tel' }
  value { '555-555555'}
end

Engagement.blueprint do
  user
  requester
  status { Engagement::STATUSES[:active] }
end

ClientApplication.blueprint do
  user
  name { "app#{sn}" }
  url { "http://#{name}.example.com" }
  key { "fsXOB85cyLXrs7Fyo25O" }
  secret { "N3s1FAvFq5EQuDcRJJkwMefNO0JBy9Gk7advS9kl " }
end

OauthToken.blueprint do
  user 
  client_application
  type { "AccessToken" }
  token { "K8nodvmGpt4PuTwuihzC" }
  secret { "K8nodvmGpt4PuTwuihzC" }
  authorized_at { Time.now }
end

