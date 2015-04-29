# scan_plugins.rb
# March 28, 2010
#
# Description: scan a separate plugin directory and load scripts
# automagically.
#
# To use, set PATH to some working directory and create your plugin
# scripts there.  DirScanner will keep an eye on that directory and
# load (i.e., execute) any scripts which appear there.  Because each
# file will be executed as soon as it is changed, the Ruby files in
# PATH should consist ONLY of SketchUp plugins!
#
# Copyright:  John Jacobsen, NPX Designs, Inc.
#
# Permission to use, copy, modify, and distribute this software for
# any purpose and without fee is hereby granted, provided that the above
# copyright notice appear in all copies.
#
# USE OF THIS SOFTWARE IS AT YOUR OWN RISK!
# THIS SOFTWARE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR
# IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
# WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

require 'sketchup.rb'

PATH = "/path/to/my/working/sketchup/plugin/directory"

class DirScanner
   def initialize(path)
      @extra_plugin_path = path
      @sem = @extra_plugin_path+"/.sem"
   end
   def doload(checksem=false)
      Dir["#{@extra_plugin_path}/*.rb"].each() { |x|
         if (!checksem) or (File.mtime(x) > File.mtime(@sem))
            touch
            load(x)
            puts "(Re-)loaded #{x}"
         end
      }
      nil
   end
   def touch
      File.new(@sem, "w").close()
   end
   def scan
      doload
      UI::start_timer(1, true) {
         doload(true)
      }
   end
end


if (not file_loaded?("scan_plugins.rb"))
   DirScanner.new(PATH).scan
   file_loaded("scan_plugins.rb")
end

