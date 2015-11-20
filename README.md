# Flashman 

This is a gem for recording your terminal activity on a gif file.  
You can also record any other window of your application.  
**The gem works only for MacOS X!**

![out](https://github.com/deepneko/flashman/blob/master/img/flashman.gif "out")

## Installation

You need to install [gifsicle](https://www.lcdf.org/gifsicle/ "gifsicle") at first.

    $ brew install gifsicle

Then, please install flashman from rubygems.

    $ gem install flashman

## Usage

Start to record your Terminal.

    $ flashman

Stop the recording. It could take a while.

    $ flashstop

The output file 'out.gif' is placed at the directory where flashman was executed.

    $ open out.gif

## Options

Specify other terminal or application with -w.

    $ flashman -w iTerm

flashman records the window every second by default. You can change the interval with -i.

    $ flashman -i 0.5

You can change the playback speed of the output file with -s. 2 means the speed will be doubled.

    $ flashman -s 2

See the detailed description with -h.

    $ flashman -h

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/deepneko/flashman.

