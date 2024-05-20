require 'test/unit'

require './validator'

class ValidatorTest < Test::Unit::TestCase
  def test_validateAny
    v = V.any
    assert v.validate(2)
    assert v.validate(3.14)
    assert v.validate('string')
    assert v.validate(:symbol)
    assert v.validate(true)
    assert v.validate(false)
    assert v.validate([1, 2, 3])
    assert v.validate({ foo: 'bar' })
    assert !v.validate(Class.new)
  end

  def test_validateInt
    v = V.int
    assert v.validate(2)
    assert !v.validate(3.14)
  end

  def test_validateFloat
    v = V.float
    assert v.validate(3.14)
    assert !v.validate(3)
  end

  def test_validateString
    v = V.string
    assert v.validate('string!')
    assert !v.validate(:symbol)
  end

  def test_validateSymbol
    v = V.symbol
    assert v.validate(:symbol)
    assert !v.validate('string')
  end

  def test_validateBool
    v = V.bool
    assert v.validate(true)
    assert v.validate(false)
    assert !v.validate(0)
  end

  def test_validateArrayOf
    v = V.array_of V.int
    assert v.validate([1, 2, 3])
    assert v.validate([])
    assert !v.validate([1, 2, '3'])
    assert !v.validate('1, 2, 3')
  end

  def test_validateTuple
    v = V.tuple [V.int, V.string, V.float]
    assert v.validate([1, 'str', 3.14])
    assert !v.validate([1, 'str', 3.14, 0])
    assert !v.validate([])
    assert !v.validate(2)
  end
end
