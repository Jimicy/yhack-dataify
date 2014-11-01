require 'sinatra'
require 'sinatra/activerecord'
require 'json'

#models
require './models/collection'
require './models/data_time'

get '/' do
  erb :"index"
end

get '/example' do
  content_type :json
  [{start_date: DateTime.now - 2.hour, event_date: DateTime.now, seconds: 2.hour},
   {start_date: DateTime.now - 5.hour, event_date: DateTime.now - 4.hour, seconds: 1.hour},
   {start_date: DateTime.now - 7.hour, event_date: DateTime.now - 6.hour, seconds: 1.hour},
   {start_date: DateTime.now - 8.hour, event_date: DateTime.now - 7.hour, seconds: 1.hour},
   {start_date: DateTime.now - 9.hour, event_date: DateTime.now - 8.hour, seconds: 1.hour}
  ].to_json
end

get '/time' do
  data_times = DataTime.all
  p (data_times)
end

post '/time' do
  p params
  a = DataTime.new(start_date: DateTime.now - 2.hour, end_date: DateTime.now, seconds: 2.hour)
  a.save
end

get '/tweets/?:category?' do
  if params[:category]=="events"
    @tweets = EventTweet.order(event_date: :desc)
  elsif params[:category]=="tools"
    @tweets = ToolTweet.order(tweet_created_date: :desc)
  elsif params[:category]=="books"
    @tweets = BookTweet.order(tweet_created_date: :desc)
  elsif params[:category]=="blogs"
    @tweets = BlogTweet.order(tweet_created_date: :desc)
  else
    @tweets = Tweet.order(tweet_created_date: :desc)[0..10]
  end
  erb :"tweets/index"
end

#API
get '/api/tweets/?:category?' do
  #category = params[:category]
  content_type :json
  tweets_list = []

  if params[:category]=="events"
    tweets = EventTweet.order(event_date: :desc)
  elsif params[:category]=="tools"
    tweets = ToolTweet.order(tweet_created_date: :desc)
  elsif params[:category]=="books"
    tweets = BookTweet.order(tweet_created_date: :desc)
  elsif params[:category]=="blogs"
    tweets = BlogTweet.order(tweet_created_date: :desc)
  else
    tweets = Tweet.order(tweet_created_date: :desc)
  end

  tweets.each do |tweet|
    tweet_json = {twitter_handle: tweet.twitter_handle,
    user_name: tweet.user_name,
    profile_image_url: tweet.profile_image_url,
    retweet_count: tweet.retweet_count,
    favorite_count: tweet.favorite_count,
    city: tweet.city,
    text: tweet.text,
    media: tweet.media,
    html: tweet.html,
    tweet_created_date: tweet.tweet_created_date
    }
    tweets_list << tweet_json
   end
  tweets_list.to_json
end
