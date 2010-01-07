# Watch, dirt simple mechanism to tell if files have changed

Pass Watch a Dir.glob friendly path and a block that you'd like to 
be executed when something changes

    Watch.new("**/*") { puts "file added, removed or changed" }

## Why write another directory watcher? 

Simplicity.

If you've checked already, there are many implementations of the same kind of code.
[kicker](http://github.com/alloy/kicker/), [watchr](http://github.com/mynyml/watchr/) and [directory_watcher](http://github.com/TwP/directory_watcher/) are all pretty awesome, only the code bases are lengthy.


    | Library           | SLOC    |
    |:-----------------:|:--------:|
    |kicker             | 676      |
    |directory_watcher  | 478      |
    |watchr             | 268      |
    |watch              | 27       |

All three of these libraries of course had far different goals than I did for watch. They're all well tested and pretty awesome too. Use them if watch isn't enough for you.


## Note on Patches/Pull Requests
 
* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a
  future version unintentionally.
* Commit, do not mess with rakefile, version, or history.
  (if you want to have your own version, that is fine but bump version in a commit by itself I can ignore when I pull)
* Send me a pull request. Bonus points for topic branches.

## Copyright

Copyright (c) 2010 Ben Schwarz. See LICENSE for details.
