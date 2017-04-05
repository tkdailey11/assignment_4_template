# Assignment 3

## Overview

In this assignment, you will write code to issue a search against YouTube using
the Google Youtube Data API.  You'll save the results of that query as Video objects
and you'll save the search itself as a YoutubeSearch object.  This will prepare
the path for setting alerts on our next assignment.  You'll also finalize user
credentialling and authorization within the application.

## Requirements

Pass all the tests and <del>satisfy all the Rubocop checks.</del>  Nope.  Forget
rubocop for this assignment.  You still need to pass the rails tests though.
You can run the tests with 'rails test' from the home directory.

Each failed test deducts 5 points.  There are 29 test blocks consisting of
72 assertions.  **I make no distinction between failures, errors, and skips.**
Your score will equal: 100 - ((count(failures) + count(errors) + count(skips)) * 5).

To help get you started, I've marked several areas in the project with # TODO
tags that point out functionality you need to add to pass the tests.  


## Overview:

### Query the Google Youtube Data API

You need two things to talk to the Youtube API programmatically -- you must
establish a "project" within your Google account via the developers' console
and you must generate an API key that you'll pass along with your requests.
Both of these tasks are covered in the README for the Yt gem and via the
video link below.  You'll also have to enable the Youtube Data API service in
your project.  In general, here's what you need to do:

1.  Login to your google account and visit the Google Developers' Console (link
  below).  
2.  Create a project.  What you name it immaterial.
3.  Click on the Enable API button and select Youtube Data API in the next screen.  
4.  When you do step (3) you'll be prompted to create a set of credentials.  Select
  API Key, not OAuth or service key.  

You can experiment with issuing API calls using the link to the API Explorer below.
Note that this is a good way of verifying that your API key works.  Use the link
for youtube.videos.list to access the search interface.  Be sure to use the link
at the bottom of that page labeled Execute without OAuth, not the button
labeled Authorize and execute.  

Be sure to take a read through the online documentation for this api -- you'll
want to be comfortable with knowing how to query it and what the returned values
look like.


### Install the Yt Gem

Despite what I just said about understanding the Youtube API, we're going to use
a Ruby library that turns that API into something much more Rails-like, Yt.  Yt
is a gem that needs to be installed and configured in our apps.

Actually, I've done most of the work for you here.  The Gemfile already has the
yt gem added to it and the only thing you need to do is provide your API Key
to the gem.  The way to do this is to **set an environment variable named
YT_API_KEY to the API key you received in the prior stage**.  I've set things up
so the Rails app will read that environment variable into Yt upon startup.  If
you're interested, see application.rb in the /config directory.  The environment
variable MUST be named YT_API_KEY.  You can verify you've set your environment
correctly by running 'env' at the command prompt and finding YT_API_KEY and your
key in the listing of environment variables.  

Why are we doing this?  Because it's a secure method to pass a piece of sensitive
data to an application without exposing it in a source code repository.  btw, if
you ever find yourself putting a password or other sensitive information
in a source code file, stop!  Think.  Consider an alternative approach like
the environment variable method.  There are others -- e.g. in Amazon Web Services,
you can spin up machines with preset boot-up variables/values your code can access.

References:
  - [Yt Gem](https://github.com/Fullscreen/yt)
  - [Video on Getting API Key](https://www.youtube.com/watch?v=Im69kzhpR3I)
  - [The Google Developers Console](https://console.developers.google.com)
  - [The Google API Explorer for Youtube](https://developers.google.com/apis-explorer/?hl=en_US#p/youtube/v3/)
  - [The Gooogle API Explorer for Youtube Searching](https://developers.google.com/apis-explorer/?hl=en_US#p/youtube/v3/youtube.videos.list)


### Complete User Authentication

- Require passwords on user accounts (most of the time).

You'll need to ensure that you've included the has_secure_password directive
in your User model.  You'll also need to add a validation that ensures the
password exists.  But - be careful!  We want to ensure we have a password
when we're setting up a user account the first time, but after that, we want
to back off the presence validation so a user can update their profile without
having to enter their password (and its confirmation) if they're only changing
something like their name.  How would you modify the validation for password
presence to only apply to a new user record?  (Hint:  calling new_record? on
any ActiveRecord object will tell you if it is one...and see the Rails API
docs on validate to explore the options available to it.)

- Provide a login screen.

Build a form that includes fields for email and password.  You'll want
to use the user_session resource/model, i.e. think about a login as the
creation of a new user_session.  So, you'll want a new.html.erb template
in the user_sessions directory.  btw, the Hartl book uses 'session' to
refer to what I'm calling 'user_session' -- they are the same notion, but I
prefer user_session because it makes a bit more sense to me.  Don't let this
confuse you as you reference Hartl.

- Verify that the logging in user has correct credentials.

Authentication refers to the process of ensuring that a user is who they say
are.  We'll do this via the login screen.  You'll need to build a create
function in the UserSessionController that will verify the user's email
points to a user account that matches the password they provided.  

- Remember the user during the session.

You'll need to save the user_id to the session object and reference it
at appropriate times.  You should have a current_user function available
to all controllers and views that returns the currently-logged-in user.

- Provide a logout link.

Upon taking this like, the session object needs to "forget" about the user,
thus requring any additional requests to redirect to the login form.

References:
  - Hartl, Chapter 7, all sections
  - Harlt, Chapter 8, Sections 8.1, 8.2  (Ignore the later sections on cookies.)


### Complete User Authorization

- Ensure that a user cannot modify another user's profile.

Authorization means only allowing a user to do things in the application they
should do.  In this assignment, you'll need to apply authentication to
the profile editing to pass the tests.  Specifically, a user should not
be able to retrieve/edit a profile that does not match the current user.


References:
  - Hartl, Chapter 9, Section 9.2 Authorization


## Assumptions Made by the Tests

- The static pages setup from the prior assignment should still exist but
only the about and help pages are tested.  I've replaced the notion of a home
page with dashboard#index in this assignment.  The about page needs to have
"My name is..." in it and the help page needs to have "email" in it.  You don't
actually have to enter an email address on that page...my test only looks for the
"email" string.

- There are other assumptions, e.g. that the login screen will include a form
with fields for email and password, but these should be evident from the tests
themselves.
