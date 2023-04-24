print(_VERSION)
print(nil)
print(true)
print(123)
print(123.456)
print("Hello" .. "World!")
print("Hello", "World!")

local function foo(a, b)
    print(a, b)
end
print(foo)

local t1 = coroutine.create(function()
    print("Hello")
    print("World")
end)
print(t1)

local t2 = {}
t2.foo = foo
print(t2)
t2.foo("hello", "lua")
