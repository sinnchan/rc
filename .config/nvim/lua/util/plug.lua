return setmetatable({
  lazy = setmetatable({}, {
    __index = function(_, k) return function() return require(k) end end,
  }),
}, {
  __index = function(_, k)
    return (require(k))
  end
})
