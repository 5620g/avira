
do

function run(msg, matches)
  return [[
  👥 نرخ گروه های آنتی اسپم :
  
  💴 سوپرگروه یک ماهه 5000 تومان
  💷 سوپرگروه دو ماهه 9000 تومان
  💵 سوپرگروه چهار ماهه 15000 تومان
  
  ----------------------------------
  برای خرید به آیدی زیر مراجعه کنید :
  @mohammadarak
  ]]
end

return {
  patterns = {
    "^نرخ$"
    "^[!/#]([Nn]erkh)$"
    "^[Nn]erkh$"
  }, 
  run = run 
}

end