class CacheRatings
  include SuckerPunch::Job

  def perform
    puts "Start caching infos for Ratings ..."
    sleep 3
    Rails.cache.write("beer top 3", Beer.best(3))
    Rails.cache.write("brewery top 3", Brewery.best(3))
    Rails.cache.write("recent ratings", Rating.recent)
    Rails.cache.write("style top 3", Style.best(3))
    Rails.cache.write("active user top 3", User.most_active_users(3))
    CacheRatings.perform_in(10.minutes)
  end
end
