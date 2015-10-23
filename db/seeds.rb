require_relative '../utils/seed_generator'
User.create name: 'weiyun',display_name:'Yun Wei' ,password:'',email:'weiyun@brandeis.edu', create_time:Faker::Date.backward(100)
User.create name: 'lizhongqi',display_name:'Zhongqi Li' ,password:'',email:'zhongqili@brandeis.edu', create_time:Faker::Date.backward(100)
User.create name: 'hanzhenyu',display_name:'Zhenyu Han' ,password:'',email:'zhenyuhan@brandeis.edu', create_time:Faker::Date.backward(100)
users=FakeData::gen_users(100)
users.each do |user|
  FakeData::gen_tweets(user,Random.rand(10))
  FakeData::gen_followers(user,Random.rand(30))
end