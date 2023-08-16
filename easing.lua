
local c1 = 1.70158
local c2 = c1 * 1.525
local c3 = c1 + 1
local c4 = (2 * math.pi) / 3
local c5 = (2 * math.pi) / 4.5
local d1 = 2.75
local n1 = 7.5625

local easing = {
  __README = 'Easing functions list, lua transecode by Darkest Ink Games'
}

function easing.bounce_in(x) return 1 - easing.bounce_out(1 - x) end
function easing.bounce_inout(x) return x < 0.5 and (1 - easing.bounce_out(1 - 2 * x)) / 2 or (1 + easing.bounce_out(2 * x - 1)) / 2 end
function easing.bounce_out(x) if (x < 1 / d1) then return n1 * x ^ 2 elseif (x < 2 / d1) then return n1 * (x - 1.5 / d1) ^ 2 + 0.75 elseif (x < 2.5 / d1) then return n1 * (x - 2.25 / d1) ^ 2 + 0.9375 else return n1 * (x - 2.625 / d1) ^ 2 + 0.984375 end end

function easing.back_in(x) return c3 * x * x * x - c1 * x * x end
function easing.back_inout(x) return x < 0.5 and (math.pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2 or (math.pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2 end
function easing.back_out(x) return 1 + c3 * math.pow(x - 1, 3) + c1 * math.pow(x - 1, 2) end

function easing.circ_in(x) return 1 - math.sqrt(1 - math.pow(x, 2)) end
function easing.circ_inout(x) return x < 0.5 and (1 - math.sqrt(1 - math.pow(2 * x, 2))) / 2 or (math.sqrt(1 - math.pow(-2 * x + 2, 2)) + 1) / 2 end
function easing.circ_out(x) return math.sqrt(1 - math.pow(x - 1, 2)) end

function easing.cubic_in(x) return x * x * x end
function easing.cubic_inout(x) return x < 0.5 and 4 * x * x * x or 1 - math.pow(-2 * x + 2, 3) / 2 end
function easing.cubic_out(x) return 1 - math.pow(1 - x, 3) end

function easing.elastic_in(x) return (x == 0 or x == 1) and x or -math.pow(2, 10 * x - 10) * math.sin((x * 10 - 10.75) * c4) end
function easing.elastic_inout(x) return (x == 0 or x == 1) and x or (x < .5 and -(math.pow(2, 20 * x - 10) * math.sin((20 * x - 11.125) * c5)) / 2 or (math.pow(2, -20 * x + 10) * math.sin((20 * x - 11.125) * c5)) / 2 + 1) end
function easing.elastic_out(x) return (x == 0 or x == 1) and x or math.pow(2, -10 * x) * math.sin((x * 10 - 0.75) * c4) + 1 end

function easing.expo_in(x) return x == 0 and 0 or math.pow(2, 10 * x - 10) end
function easing.expo_out(x) return x == 1 and 1 or 1 - math.pow(2, -10 * x) end

function easing.quad_in(x) return x * x end
function easing.quad_inout(x) return x < 0.5 and 2 * x * x or 1 - math.pow(-2 * x + 2, 2) / 2 end
function easing.quad_out(x) return 1 - (1 - x) * (1 - x) end

function easing.quart_in(x) return x * x * x * x end
function easing.quart_inout(x) return x < 0.5 and 8 * x * x * x * x or 1 - math.pow(-2 * x + 2, 4) / 2 end
function easing.quart_out(x) return 1 - math.pow(1 - x, 4) end

function easing.quint_in(x) return x * x * x * x * x end
function easing.quint_inout(x) return x < 0.5 and 16 * x * x * x * x * x or 1 - math.pow(-2 * x + 2, 5) / 2 end
function easing.quint_out(x) return 1 - math.pow(1 - x, 5) end

function easing.sine_in(x) return 1 - math.cos((x * math.pi) / 2) end
function easing.sine_inout(x) return -(math.cos(math.pi * x) - 1) / 2 end
function easing.sine_out(x) return math.sin((x * math.pi) / 2) end

return easing
