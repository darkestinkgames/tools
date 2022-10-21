math.randomseed(os.time())

-- -- -- >>> ядро

local tWidth, tHeight = 64, 48
local width, height

local tGrid
local uGrid

local cSelected
local uSelected


-- -- -- >>> енумерашки

local color_name = {}


-- -- -- >>> нове

local function newCell()end
local function newUnit()end
local function newPathPt()end


-- -- -- >>> функціонал

local function toKey(x,y)end
local function toGrid(sx,sy)end
local function toScreen(gx,gy)end

local function setColor(name)end
local function setPathPtVal(pp,val,from)end

local function getRadius(val)end
local function getCell(gx,gy)end
local function getCost(tile)end
local function getPt(grid,tile)end

local function initPathGrid(pp,mov)end

local function drawTile()end
local function drawHover()end
local function drawUnit()end
local function drawPathGrid(unit)end
local function drawPathLine(pp)end
local function drawPathQueue(unit)end

local function addQueue(unit,tile)end


-- -- -- >>> головняк

local main = {}

function main.new(w,h)end
function main.draw()end
function main.update(dt)end
function main.select()end
function main.deselect()end


-- -- -- >>>

return main