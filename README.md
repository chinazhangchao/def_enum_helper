# DefEnumHelper

Define very powerful enum class.

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
# 默认枚举从1开始递增

def_enum :YinYang, {YANG: "阳", YIN: "阴"}

puts YinYang::YANG  	# 1
puts YinYang::YIN   	# 2
y = YinYang[1]
puts y.index        	# 1
puts y.display      	# 阳
YinYang[:YANG]   		# same as YinYang[1]
YinYang["阳"]    		# same as YinYang[1]
YinYang.all         	# 所有枚举的struct array [#<struct index=1, display="阳">, # <struct index=2, display="阴">]
puts YinYang.count  	# 2
YinYang.each{|x| puts x}  # <struct index=1, display="阳"> #<struct index=2, display="阴">
YinYang.map{|x| x}        # [#<struct  index=1, display="阳">, #<struct  index=2, display="阴">]
puts YinYang.to_hash_array # [{:index=>1, :display=>"阳"}, {:index=>2, :display=>"阴"}]
puts YingYang.to_json_array  # [{"index":1,"display":"阳"},{"index":2,"display":"阴"}]
```

```ruby
# 自定义枚举整数值

def_enum_with_index(:DataOperationType,
                    [:INSERT, 3, '插入'],
                    [:UPDATE, 4, '修改'],
                    [:DELETE, 5, '删除'])

puts DataOperationType::INSERT	# 3

```

```ruby
# 自定义枚举对象
CustomStruct = Struct.new(:index, :display, :short_name)

def_enum_struct_with_index(:Country,
                           {
                             CHINA: CustomStruct.new(1, '中华人民共和国', '中国'),
                             USA: CustomStruct.new(2, '美利坚合众国', '美国')
                         })

Country[:CHINA]			# <struct CustomStruct index=1, display="中华人民共和国", short_name="中国">

```

### License

(MIT License) - Copyright (c) 2016 Charles Zhang
