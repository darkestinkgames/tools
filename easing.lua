
local c1 = 1.70158
local c2 = c1 * 1.525
local c3 = c1 + 1
local c4 = (2 * math.pi) / 3
local c5 = (2 * math.pi) / 4.5
local d1 = 2.75
local n1 = 7.5625

local easing = {}

function easing.easeOutBounce(x) if (x < 1 / d1) then return n1 * x ^ 2 elseif (x < 2 / d1) then return n1 * (x - 1.5 / d1) ^ 2 + 0.75 elseif (x < 2.5 / d1) then return n1 * (x - 2.25 / d1) ^ 2 + 0.9375 else return n1 * (x - 2.625 / d1) ^ 2 + 0.984375 end end
function easing.easeInBounce(x) return 1 - easing.easeOutBounce(1 - x) end
function easing.easeInOutBounce(x) return x < 0.5 and (1 - easing.easeOutBounce(1 - 2 * x)) / 2 or (1 + easing.easeOutBounce(2 * x - 1)) / 2 end

function easing.easeOutBack(x) return 1 + c3 * math.pow(x - 1, 3) + c1 * math.pow(x - 1, 2) end
function easing.easeInBack(x) return c3 * x * x * x - c1 * x * x end
function easing.easeInOutBack(x) return x < 0.5 and (math.pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2 or (math.pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2 end

function easing.easeInCirc(x) return 1 - math.sqrt(1 - math.pow(x, 2)) end
function easing.easeInOutCirc(x) return x < 0.5 and (1 - math.sqrt(1 - math.pow(2 * x, 2))) / 2 or (math.sqrt(1 - math.pow(-2 * x + 2, 2)) + 1) / 2 end
function easing.easeOutCirc(x) return math.sqrt(1 - math.pow(x - 1, 2)) end

function easing.easeInCubic(x) return x * x * x end
function easing.easeInOutCubic(x) return x < 0.5 and 4 * x * x * x or 1 - math.pow(-2 * x + 2, 3) / 2 end
function easing.easeOutCubic(x) return 1 - math.pow(1 - x, 3) end

function easing.easeInElastic(x) return (x == 0 or x == 1) and x or -math.pow(2, 10 * x - 10) * math.sin((x * 10 - 10.75) * c4) end
function easing.easeInOutElastic(x) return (x == 0 or x == 1) and x or (x < .5 and -(math.pow(2, 20 * x - 10) * math.sin((20 * x - 11.125) * c5)) / 2 or (math.pow(2, -20 * x + 10) * math.sin((20 * x - 11.125) * c5)) / 2 + 1) end
function easing.easeOutElastic(x) return (x == 0 or x == 1) and x or math.pow(2, -10 * x) * math.sin((x * 10 - 0.75) * c4) + 1 end

function easing.easeInExpo(x) return x == 0 and 0 or math.pow(2, 10 * x - 10) end
function easing.easeOutExpo(x) return x == 1 and 1 or 1 - math.pow(2, -10 * x) end

function easing.easeInOutQuad(x) return x < 0.5 and 2 * x * x or 1 - math.pow(-2 * x + 2, 2) / 2 end
function easing.easeInQuad(x) return x * x end
function easing.easeOutQuad(x) return 1 - (1 - x) * (1 - x) end

function easing.easeInOutQuart(x) return x < 0.5 and 8 * x * x * x * x or 1 - math.pow(-2 * x + 2, 4) / 2 end
function easing.easeInQuart(x) return x * x * x * x end
function easing.easeOutQuart(x) return 1 - math.pow(1 - x, 4) end

function easing.easeInOutQuint(x) return x < 0.5 and 16 * x * x * x * x * x or 1 - math.pow(-2 * x + 2, 5) / 2 end
function easing.easeInQuint(x) return x * x * x * x * x end
function easing.easeOutQuint(x) return 1 - math.pow(1 - x, 5) end

function easing.easeInOutSine(x) return -(math.cos(math.pi * x) - 1) / 2 end
function easing.easeInSine(x) return 1 - math.cos((x * math.pi) / 2) end
function easing.easeOutSine(x) return math.sin((x * math.pi) / 2) end

return easing
