local ftcsv = require('ftcsv')

local skip_types = {
  ['copy-paste-tool'] = true,
  ['upgrade-item'] = true,
  ['mining-tool'] = true,
  ['selection-tool'] = true
}

local translations = {}
local translations_requested = 0

----------------------------------------------------------------

local function translate_prototypes(prototypes)
  for _, data in pairs(prototypes) do
    game.player.request_translation(data.localised_name)
    translations_requested = translations_requested + 1
  end
end

local function dump_translations(cmd)
  translate_prototypes(game.item_prototypes)
  translate_prototypes(game.fluid_prototypes)
end

----------------------------------------------------------------

local function write_to_csv(data)
  local output = ftcsv.encode(data, ",")
  game.write_file("factorio_items.csv", output)
end

local function add_prototypes(result, prototypes, is_fluid)
  for _, data in pairs(prototypes) do

    local type = ''
    if is_fluid then
      type = 'fluid'
    else
      type = data.type
    end

    if not skip_types[type] then
      table.insert(result, {
        type = type,
        name = data.name,
        localised_name = translations[data.localised_name[1]]
      })
    end
  end
end

local function actually_dump_data()
  local result = {}

  add_prototypes(result, game.item_prototypes)
  add_prototypes(result, game.fluid_prototypes, true)

  write_to_csv(result)
end

----------------------------------------------------------------

script.on_event(defines.events.on_string_translated, function(event)
  translations_requested = translations_requested - 1
  if event.translated then
    translations[event.localised_string[1]] = event.result
  else
    translations[event.localised_string[1]] = ''
  end

  if translations_requested == 0 then
    actually_dump_data()
  end
end)

commands.add_command("dump_data", "Dumps item and fluid data for SandboxGameBridge.", dump_translations)

