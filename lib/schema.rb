class S
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

  def self.nil()
    self.new :nil
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

  def self.hash(schema)
    if schema.class != Hash
      raise ArgumentError, 'invalid schema'
    end

    self.new :hash, schema
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
    if k == :hash
      @hash = s
    end
  end

  private def valid_value_type?(k, v)
    case k
    when :any
      t = [Integer, Float, String, Symbol, TrueClass, FalseClass, Array, Hash, NilClass]
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
    when :nil
      v.class == NilClass
    when :array_of
      array_of?(@array_of, v)
    when :tuple
      tuple?(@tuple, v)
    when :hash
      hash?(@hash, v)
    else
      raise ArgumentError, sprintf('ínvalid kind %s', k)
    end
  end

  private def array_of?(schema, value)
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

  private def tuple?(schema, value)
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

  private def hash?(schema, value)
    if value.class != Hash
      return false
    end

    skeys = schema.keys
    vkeys = value.keys

    if skeys.length > vkeys.length
      return false
    end

    # value が schema よりも広いことを認めるために、すべての schema.keys が value.keys に含まれることだけを確認する
    for sk in skeys
      if !vkeys.include? sk
        return false
      end
    end

    for sk in skeys
      if !schema[sk].validate(value[sk])
        return false
      end
    end

    return true
  end
end
