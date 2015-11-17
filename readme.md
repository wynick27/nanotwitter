This is Version 0.5


authentication
get /login
Generates user login form.

post /login
Checks user login information and puts session.

get /logout
Logout current user.

get /register
Generates register form.

post /register
Checks name conflict and add it to database.

User Interface
get /
if user logged in return its tweets
otherwise return all recent tweets of the site.

get /following
Shows the current user's followings.

get /followers
Shows the current user's followers.

get /user/:username
if user is matches the current user then show new tweet otherwise just show the user's tweets.

get /user/:username/followings
Shows the specific user's followings.

get /user/:username/followers
Shows the specific user's followers.

get /user/:username/follow
if user is matches the current user or not followed by current user then error otherwise follow the user.

get /user/:username/unfollow
if user is matches the current user or not followed by current user then error otherwise unfollow the user.


post /tweet/new
If user is not logged in then error
else post a new tweet in users profile.

post /tweet/:id/retweet
Retweet a specific post of other user, user cannot retweet his own tweets.
And user can also specify an optional comment.

post /tweet/:id/comments
Post a comment to a tweet.

post /tweet/:id/favourite
Add a tweet to its favourites.
