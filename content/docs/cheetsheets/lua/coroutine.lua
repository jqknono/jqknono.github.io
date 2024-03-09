local function foo(a)
    print("foo", a)
    return coroutine.yield(3 * a)
end

local co = coroutine.create(function(a)
    local b = foo(2 * a)
    local c = foo(3 * a)
    local d = coroutine.yield(4 * a)
    local e = coroutine.yield(5 * a)
    return 6
end)

print("main", coroutine.resume(co, 1))
print("main", coroutine.resume(co, 1))
print("main", coroutine.resume(co, 1))
print("main", coroutine.resume(co, 1))
print("main", coroutine.resume(co, 1))
print("main", coroutine.resume(co, 1))
print("main", coroutine.resume(co, 1))
