require 'test/unit'

require_relative './schema'

class ShemaTest < Test::Unit::TestCase
  def test_sample()
    schema = S.array_of S.hash(
      name: S.string,
      age: S.int,
    )

    assert schema.validate [{
      name: 'Alice',
      age: 20,
    }, {
      name: 'Bob',
      age: 30,
    }]
  end

  def test_validateAny
    v = S.any
    assert v.validate(2)
    assert v.validate(3.14)
    assert v.validate('string')
    assert v.validate(:symbol)
    assert v.validate(true)
    assert v.validate(false)
    assert v.validate([1, 2, 3])
    assert v.validate({ foo: 'bar' })
    assert v.validate(nil)
    assert !v.validate(Class.new)
  end

  def test_validateInt
    v = S.int
    assert v.validate(2)
    assert !v.validate(3.14)
  end

  def test_validateFloat
    v = S.float
    assert v.validate(3.14)
    assert !v.validate(3)
  end

  def test_validateString
    v = S.string
    assert v.validate('string!')
    assert !v.validate(:symbol)
  end

  def test_validateSymbol
    v = S.symbol
    assert v.validate(:symbol)
    assert !v.validate('string')
  end

  def test_validateBool
    v = S.bool
    assert v.validate(true)
    assert v.validate(false)
    assert !v.validate(0)
  end

  def test_validateArrayOf
    v = S.array_of S.int
    assert v.validate([1, 2, 3])
    assert v.validate([])
    assert !v.validate([1, 2, '3'])
    assert !v.validate('1, 2, 3')
  end

  def test_validateTuple
    v = S.tuple [S.int, S.string, S.float]
    assert v.validate([1, 'str', 3.14])
    assert !v.validate([1, 'str', 3.14, 0])
    assert !v.validate([1, 2, 3])
    assert !v.validate([])
    assert !v.validate(2)
  end

  def test_validateNil
    v = S.nil()
    assert v.validate(nil)
    assert !v.validate(false)
  end

  def test_validateHash
    v = S.hash({
      'string_key' => S.string,
      :symbol_key => S.string,
      3 => S.string,
      3.14 => S.string,
      'nil_key' => S.nil,
    })
    assert v.validate({
      'string_key' => 'value',
      :symbol_key => 'value',
      3 => 'value',
      3.14 => 'value',
      'nil_key' => nil,
    })
    assert v.validate({
      'string_key' => 'value',
      :symbol_key => 'value',
      3 => 'value',
      3.14 => 'value',
      'nil_key' => nil,
      'other_key' => 'aaa',
    })
    assert !v.validate({
      'string_key' => 'value',
      :symbol_key => 'value',
      3 => 3,
      3.14 => 3.14,
      'nil_key' => nil,
    })
    assert !v.validate({
      'wrong_key' => 'value',
      :wrong_symbol => 'value',
      1 => 'value',
      1.1 => 'value',
      'nil_key' => nil,
    })
    assert !v.validate({})
    assert !v.validate({
      :symbol_key => 'value',
      3 => 'value',
      3.14 => 'value',
    })
  end
end
