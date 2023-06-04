5.times do |n|
  Post.create(title: "タイトル#{n}", content: "本文#{n}")
end
