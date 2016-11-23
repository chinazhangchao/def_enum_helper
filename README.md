# DefEnumHelper

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/def_enum_helper`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'def_enum_helper'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install def_enum_helper

## Usage

```ruby
def_enum :YinYang, {YANG: "阳", YIN: "阴"}

puts YinYang::YANG  	#1
puts YinYang::YIN   	#2
y = YinYang[1]
puts y.index        	#1
puts y.display      	#阳
YinYang[:YANG]   		#same as YinYang[1]
YinYang["阳"]    		#same as YinYang[1]
YinYang.all         	#所有枚举的struct array [#<struct index=1, display="阳">, #<struct index=2, display="阴">]
puts YinYang.count  	#2
YinYang.each{|x| puts x}  #<struct index=1, display="阳"> #<struct index=2, display="阴">
puts to_hash_array #
puts YingYang.to_json_array  #[{"index":1,"display":"阳"},{"index":2,"display":"阴"}]

# 自定义枚举整数值
def_enum_with_index(:DataOperationType,
                    [:INSERT, 3, '插入'],
                    [:UPDATE, 4, '修改'],
                    [:DELETE, 5, '删除'])

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/def_enum_helper.

