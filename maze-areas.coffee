# solve the problem described here:
# http://neil.fraser.name/news/2013/03/16/

fs = require 'fs'
_ = require 'lodash'

walkTheMaze = (maze) ->
  height = maze.length-1
  width = maze[0].length-1

  walkTheArea = (cell) ->
    area = { closed: true, size: 0 }
    stack = [cell]
    console.log 'new area!'
    while stack.length > 0
      cell = stack.shift()
      if (cell.y < 0 or cell.y > height or
      cell.x < 0 or cell.x > width)
        if area.closed
          console.log "  not closed in #{cell.x}, #{cell.y}!"
          area.closed = false
        continue
      continue if maze[cell.y][cell.x].wall or maze[cell.y][cell.x].marked
      console.log "  #{cell.x}  #{cell.y}"
      maze[cell.y][cell.x].marked = true
      area.size++
      stack.push { x: cell.x, y: cell.y + 1 }
      stack.push { x: cell.x, y: cell.y - 1 }
      stack.push { x: cell.x + 1, y: cell.y }
      stack.push { x: cell.x - 1, y: cell.y }
    area

  areas = []
  maxsize = 0
  maxarea = null
  closedAreaCount = 0
  for y in [0..height]
    for x in [0..width]
      continue if maze[y][x].wall or maze[y][x].marked
      area = walkTheArea { x, y }
      areas.push area
      closedAreaCount++ if area.closed
      if area.size > maxsize
        maxsize = area.size
        maxarea = area

  console.log "area count:        #{areas.length}"
  console.log "closed area count: #{closedAreaCount}"
  console.log "max area size:     #{maxsize/12}"


fs.readFile 'data.txt', 'utf8', (err, data) ->
  throw err if err
  lines = data.split('\n')
  maze = _.map (_.filter lines, (line) -> line.length > 0), (line) ->
    _.map line, (char) ->
      wall: char == '1'
      marked: false
  walkTheMaze maze

