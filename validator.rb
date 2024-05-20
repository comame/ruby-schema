class V
  def self.int()
    self.new :int
  end

  def self.float()
    self.new :float
  end

  def self.string()
    self.new :string
  end

  def self.symbol()
    self.new :symbol
  end

  def self.bool()
    self.new :bool
  end

  def self.any()
    self.new :any
  end

  def self.array_of(schema)
    if schema.class != self
      raise ArgumentError, 'ínvalid schema'
    end

    self.new :array_of, schema
  end

  def self.tuple(schemas)
    if schemas.class != Array
      raise ArgumentError, 'invalid schmeas'
    end

    for s in schemas do
      if s.class != self
        raise ArgumentError, 'invalid schemas'
      end
    end

    self.new :tuple, schemas
  end

  def validate(v)
    valid_value_type? @kind, v
  end


  private_class_method :new

  def initialize(k, s = nil)
    @kind = k

    if k == :array_of
      @array_of = s
    end
    if k == :tuple
      @tuple = s
    end
  end

  private def valid_value_type?(k, v)
    case k
    when :any
      t = [Integer, Float, String, Symbol, TrueClass, FalseClass, Array, Hash]
      t.include? v.class
    when :int
      v.class == Integer
    when :float
      v.class == Float
    when :string
      v.class == String
    when :symbol
      v.class == Symbol
    when :bool
      t = [TrueClass, FalseClass]
      t.include? v.class
    when :array_of
      is_array_of?(@array_of, v)
    when :tuple
      is_tuple?(@tuple, v)
    else
      raise ArgumentError, sprintf('ínvalid kind %s', k)
    end
  end

  private def is_array_of?(schema, value)
    if value.class != Array
      return false
    end

    for v in value do
      if !schema.validate(v)
        return false
      end
    end

    return true
  end

  private def is_tuple?(schema, value)
    if value.class != Array
      return false
    end

    if schema.length != value.length
      return false
    end

    for i in 0...schema.length do
      if !schema[i].validate(value[i])
        return false
      end
    end

    return true
  end
end
