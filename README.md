# Boing

Boing is a preloader-aware command runner for JRuby. It builds off the preload
capabilities of [Drip](https://github.com/flatland/drip) and adds per-command smarts for specific commands.

Boing is being created in response to the [Spring](https://github.com/jonleighton/spring) preloader being supported by
Rails 4.1. Spring preloads Ruby/Rails instances in the background in much the
same way as JRuby can do with Drip, but does it using forking. Because JRuby
already has Drip, Boing should only need to know how to safely preload and
reload the application.

Similar to Spring commands can be run with Boing using the format

```boing <command>```

Most commands will just run directly, with the assumption that they are
already in a preloaded JVM. (Boing will warn if used outside of a preloaded
JVM). Some Rails commands, however, will be run directly.

However, boing is also aware of a few rails commands that can be run directly
using a specific dripmain.rb preload script. Boing can generate this script
using ```boing dripmain```.

Finally, all background instances can be cleaned up with ```boing killall```,
which is equivalent to the ```drip kill``` command from Drip.

Note that there's a more work to do here and much more that Boing could do to
improve startup and application development interactivity.

## Installation

Add this line to your application's Gemfile:

    gem 'boing'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install boing

## Usage

To run a command in a preloaded VM:

```
boing <command>
```

To generate a dripmain.rb suitable for Rails:

```
boing dripmain
```

To kill all background VM instances:

```
boing killall
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
