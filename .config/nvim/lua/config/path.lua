local home = os.getenv("HOME")
if home then
  package.path = package.path .. ";" .. home .. "/?.lua"
end
