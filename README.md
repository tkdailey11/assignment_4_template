# Assignment 4

## Overview

In this assignment, you will refactor your Assignment 3 code to
1)  allow users to set alerts on their searches
2)  automatically execute those searches on a schedule, and
3)  recognize when new results of a search have occurred.

This assignment is due by midnight on Sunday, April 16th via the same pull request method as other assignments.


## Requirements

Pass all the tests.  (No rubocop again.)  You can run the tests with 'rails test'
from the home directory.

Each failed test deducts 5 points.  There are 43 test blocks consisting of
113 assertions.  **I make no distinction between failures, errors, and skips.**
Your score will equal: 100 - ((count(failures) + count(errors) + count(skips)) * 5).

To help get you started, I've marked several areas in the project with # TODO
tags that point out functionality you need to add to pass the tests.  


## Overview:

## Create the ExecutedSearch Model

Remember the entity relationship diagram we went over in class?  Much of this assignment involves refactoring our existing models to fit that new schema.  The ExecutedSearch entity is a completely new entity/model, and there's a fair amount to it.  We're using this new model as a way of recording the results of youtube queries so we can compare them over time.  It's how we'll identify that we have an alert state.

I'm giving you the majority of the ExecutedSearch model.  You just need to write the
contents of the compare_to method.  See the model file for a description of what it takes as a parameter and what it should return. In general, it needs to implement a subtractive set
operation.  
```
For example, given
  Set A : { 1, 2, 3 }
  Set B : { 3, 4, 5 }
then
  comparing Set A to Set B should do A-B:
  Set A.compare_to(Set B) => { 1, 2 }
  and
  Set B.compare_to(Set A) => { 4, 5 }
```
In our code, the Set A and Set B are ExecutedSearch objects and their elements
are the videos associated with them through their has_many :videos relationship.  The system will call the ExecutedSearch.compare_to method on two search results.  (See youtube_search.rb for this call.)

Remember that reading the test code itself can help you understand what
your code needs to do.  (See test/models/executed_search_test.rb)

References:
  - Lecture Notes on Assignment 4, Creating the ExecutedSearch Model


### Refactor the YoutubeSearch Model

* Add a boolean attribute called alert_on_new_result
* Add a named scope that will return all objects that have their
  alert_on_new_result set to true.
* I've taken care of modifying the views to expose this new attribute
  but you may want look at the code to see what I did.  

References:
  - Lecture Notes on Assignment 4, Refactoring the YoutubeSearch Model


### Refactor the Alert Model

* Remove the user_id column
* Add a column called youtube_search_id as an integer type
* Add a column called criterion as an integer type
* Add a column called message as a string type
* Modify the associations in the class definition to belong to
  a youtube_search and have one user.  Be careful: the association
  to a user is not a direct one.

References:
  - Lecture Notes on Assignment 4, Refactoring the Alert Model


### Refactor the Video Model

* rename the youtube_search_id field to executed_search_id
* define the belongs_to association (to an executed_search)
  in the Video class definition.

References:
  - Lecture Notes on Assignment 4, Refactoring the Video Model


### Install the Whenever Gem

We'll use whenever to configure a cron job for running our automated searches.
You'll need to install this in your Gemfile, bundle it, and update the configuration
of the gem to run our searches every two hours.  See the lecture notes for details.

References:
  - [Whenever Gem](https://github.com/javan/whenever)
  - [Lecture Notes on Assignment 4, Automating the Searching]


--- 

A note on the testing:  When you first run the tests (before doing all the refactoring listed above), you will get a slew of error messages.  Don’t freak out.  Most of these error messages occur because I’ve defined fixtures expecting the final state of the database, and the starting state isn’t the same…thus the fixtures reference attributes of models that don’t exist or have different names.
