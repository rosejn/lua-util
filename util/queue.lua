queue = {}

function queue.new()
  return {left  = 0,
          right = -1}
end


function queue.is_empty(q)
  if q.left > q.right then
     return true
  else
     return false
  end
end

function queue.push_left(q, v)
  local left = q.left - 1
  q.left = left
  q[left] = v
  return q
end


function queue.push_right(q, v)
  local right = q.right + 1
  q.right = right
  q[right] = v
  return q
end


function queue.pop_left(q)
  local left = q.left
  if queue.is_empty(q) then
     return nil
  end

  local v = q[left]
  q[left] = nil        -- to allow garbage collection
  q.left = left + 1
  return v
end


function queue.pop_right(q)
  local right = q.right
  if queue.is_empty(q) then
     return nil
  end

  local v = q[right]
  q[right] = nil         -- to allow garbage collection
  q.right = right - 1
  return v
end
