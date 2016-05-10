do

local function set_pass(msg, pass, id)
  local hash = nil
  if msg.to.type == "chat" then
    hash = 'setpass:'
  end
  local name = string.gsub(msg.to.print_name, '_', '')
  if hash then
    redis:hset(hash, pass, id)
      return send_large_msg("chat#id"..msg.to.id, "ðŸ”± User of Group:\n["..name.."] has been set to:â€Œ\n\n "..pass.."\n\nNow user can join in pm by\njoin "..pass.." âšœ", ok_cb, true)
  end
end

local function is_used(pass)
  local hash = 'setpass:'
  local used = redis:hget(hash, pass)
  return used or false
end
local function show_add(cb_extra, success, result)
  --vardump(result)
    local receiver = cb_extra.receiver
    local text = "I added you toðŸ‘¥ "..result.title.."(ðŸ‘¤"..result.participants_count..")"
    send_large_msg(receiver, text)
end
local function added(msg, target)
  local receiver = get_receiver(msg)
  chat_info("chat#id"..target, show_add, {receiver=receiver})
end
local function run(msg, matches)
  if matches[1] == "user" and msg.to.type == "chat" and matches[2] then
    local pass = matches[2]
    local id = msg.to.id
    if is_used(pass) then
      return "Ø§ÛŒÙ† ÛŒÙˆØ²Ø± Ù†ÛŒÙ… Ù‚Ø§Ø¨Ù„ Ø§Ø³ØªÙØ§Ø¯Ù‡ Ù†ÛŒØ³Øª"
    end
    redis:del("setpass:", id)
    return set_pass(msg, pass, id)
  end
  if matches[1] == "join" and matches[2] then
    local hash = 'setpass:'
    local pass = matches[2]
    local id = redis:hget(hash, pass)
    local receiver = get_receiver(msg)
    if not id then
      return "Ú¯Ø±ÙˆÙ‡ÛŒ Ø¨Ø§ Ø§ÛŒÙ† ÛŒÙˆØ²Ø± Ù†ÛŒÙ… ÙˆØ¬ÙˆØ¯ Ù†Ø¯Ø§Ø±Ø¯"
    end
    chat_add_user("chat#id"..id, "user#id"..msg.from.id, ok_cb, false) 
  return added(msg, id)
  else
  return " Ù…Ù† Ù†Ù…ÛŒØªÙˆØ§Ù†Ù… Ø´Ù…Ø§ Ø±Ø§ Ø¨Ù‡"..string.gsub(msg.to.id.print_name, '_', ' ').."Ø§Ø¶Ø§ÙÙ‡ Ú©Ù†Ù…"
  end
  if matches[1] == "user" then
   local hash = 'setpass:'
   local chat_id = msg.to.id
   local pass = redis:hget(hash, chat_id)
   local receiver = get_receiver(msg)
   send_large_msg(receiver, "User for SuperGroup:["..msg.to.print_name.."]\n\n > "..pass)
 end
end

return {
  patterns = {
    "^/(user) (.*)$",
    "^/(user)$",
    "^([Jj]oin) (.*)$"
  },
  run = run
}
end
