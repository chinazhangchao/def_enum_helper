require 'def_enum_helper/version'

# Usage

# # 默认枚举从1开始递增

# def_enum :YinYang, {YANG: "阳", YIN: "阴"}

# puts YinYang::YANG    # 1
# puts YinYang::YIN     # 2
# y = YinYang[1]
# puts y.index          # 1
# puts y.display        # 阳
# puts y.symbol           # :YANG
# YinYang[:YANG]      # same as YinYang[1]
# YinYang["阳"]        # same as YinYang[1]
# YinYang.all           # 所有枚举的struct array [#<struct index=1, display="阳">, # <struct index=2, display="阴">]
# puts YinYang.count    # 2
# YinYang.each{|x| puts x}  # <struct index=1, display="阳"> #<struct index=2, display="阴">
# YinYang.map{|x| x}        # [#<struct  index=1, display="阳">, #<struct  index=2, display="阴">]
# puts YinYang.to_hash_array # [{:index=>1, :display=>"阳"}, {:index=>2, :display=>"阴"}]
# puts YinYang.to_json_array  # [{"index":1,"display":"阳"},{"index":2,"display":"阴"}]
# puts YinYang.keys           # [:YANG, :YIN]
# puts YinYang.indexes        # [1, 2]

# def_enum :YinYang, {YANG: "阳", YIN: "阴"}, symbol_name: :s, index_name: :i, display_name: :d

# # 自定义枚举整数值

# def_enum_with_index(:DataOperationType,
#                     [:INSERT, 3, '插入'],
#                     [:UPDATE, 4, '修改'],
#                     [:DELETE, 5, '删除'])

# puts DataOperationType::INSERT  # 3

# def_enum_with_index(:DataOperationType,
#                     [:INSERT, 3, '插入'],
#                     [:UPDATE, 4, '修改'],
#                     [:DELETE, 5, '删除'],
#                     symbol_name: :s,
#                     index_name: :i,
#                     display_name: :d)

# # 自定义枚举对象
# CustomStruct = Struct.new(:index, :display, :short_name)

# def_enum_struct_with_index(:Country,
#                            {
#                              CHINA: CustomStruct.new(1, '中华人民共和国', '中国'),
#                              USA: CustomStruct.new(2, '美利坚合众国', '美国')
#                          })

# Country[:CHINA]     # <struct CustomStruct index=1, display="中华人民共和国", short_name="中国">

DEFAULT_ENUM_BASE_INDEX = 1

def def_enum(module_name, enum_hash, enum_base: DEFAULT_ENUM_BASE_INDEX,
             symbol_name: :symbol, index_name: :index, display_name: :display)
  temp_struct = Struct.new(symbol_name, index_name, display_name)
  new_enum_hash = {}
  enum_hash.each do |k, v|
    new_enum_hash[k] = temp_struct.new(k, 0, v)
  end
  def_enum_struct(module_name, new_enum_hash,
                  enum_base: enum_base, symbol_name: symbol_name,
                  index_name: index_name, display_name: display_name)
end

def def_enum_struct(module_name, enum_hash, enum_base: DEFAULT_ENUM_BASE_INDEX,
                    symbol_name: :symbol, index_name: :index, display_name: :display)
  i = 0
  set_index = (index_name.to_s + '=').to_sym
  enum_hash.each do |_k, v|
    enum_value = enum_base + i
    v.public_send(set_index, enum_value)
    i += 1
  end

  def_enum_struct_with_index(module_name, enum_hash,
                             symbol_name: symbol_name, index_name: index_name,
                             display_name: display_name)
end

def def_enum_with_index(module_name, *value_array,
                        symbol_name: :symbol, index_name: :index, display_name: :display)
  h = {}
  temp_struct = Struct.new(symbol_name, index_name, display_name)
  value_array.each do |variable|
    h[variable[0]] = temp_struct.new(variable[0], variable[1], variable[2])
  end

  def_enum_struct_with_index(module_name, h, symbol_name: symbol_name,
                                             index_name: index_name, display_name: display_name)
end

def define_iterator_methods(m, enum_index_hash)
  m.define_singleton_method(:each) { |&blk| enum_index_hash.each_value { |v| blk.call(v) } }
  m.define_singleton_method(:map) { |&blk| enum_index_hash.values.map { |v| blk.call(v) } }

  m.define_singleton_method(:all) { enum_index_hash.values }
  m.define_singleton_method(:keys) { m.constants }
  m.define_singleton_method(:indexes) { enum_index_hash.keys }
end

def define_subscript_method(m, enum_index_hash, enum_display_hash)
  divisor = enum_index_hash.count

  m.define_singleton_method(:[]) do |k|
    case k
    when String
      enum_display_hash[k]
    when Symbol
      index =
        if is_a?(Module)
          const_get(k)
        else
          Kernel.const_get(k)
        end
      enum_index_hash[index]
    else
      enum_index_hash[k]
    end
  end
end

def define_convert_methods(m, enum_index_hash)
  m.define_singleton_method(:to_hash_array) { enum_index_hash.each_value.map(&:to_h) }

  m.define_singleton_method(:to_json_array) { to_hash_array.to_json }
end

def define_enum_methods(m, enum_index_hash, enum_display_hash)
  define_iterator_methods(m, enum_index_hash)

  m.define_singleton_method(:include?) { |n| n.is_a?(Symbol) ? constants.include?(n) : enum_index_hash.key?(n) }

  m.define_singleton_method(:member?) { |n| include?(n) }

  m.define_singleton_method(:count) { enum_index_hash.count }

  define_convert_methods(m, enum_index_hash)

  define_subscript_method(m, enum_index_hash, enum_display_hash)
end

def def_enum_struct_with_index(module_name, enum_hash, symbol_name: :symbol,
                               index_name: :index, display_name: :display)
  m = Module.new
  enum_index_hash = {}
  enum_display_hash = {}
  i = 0
  enum_hash.each do |k, v|
    v.define_singleton_method(symbol_name) { k } unless v.respond_to?(symbol_name)

    enum_value = v.public_send(index_name)
    m.const_set(k, enum_value)
    enum_index_hash[enum_value] = v
    enum_display_hash[v.public_send(display_name)] = v
    i += 1
  end

  define_enum_methods(m, enum_index_hash, enum_display_hash)

  if is_a?(Module)
    const_set(module_name, m)
  else
    Kernel.const_set(module_name, m)
  end
end
