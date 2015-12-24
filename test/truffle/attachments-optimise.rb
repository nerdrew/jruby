# -J-G:+TruffleCompilationExceptionsAreFatal

def foo
  foo = 14
  foo * 2
end

Truffle::Attachments.attach __FILE__, 5 do |binding|
  binding.local_variable_set(:foo, 100)
end

begin
  loop do
    x = foo
    raise "value not correct" unless x == 200
    Truffle::Primitive.assert_constant x
    Truffle::Primitive.assert_not_compiled
  end
rescue RubyTruffleError => e
  if e.message.include? 'Truffle::Primitive.assert_not_compiled'
    puts "attachments optimising"
    exit 0
  elsif e.message.include? 'Truffle::Primitive.assert_constant'
    puts "attachments not optimising"
    exit 1
  else
    puts "some other error"
    exit 1
  end
end

exit 1