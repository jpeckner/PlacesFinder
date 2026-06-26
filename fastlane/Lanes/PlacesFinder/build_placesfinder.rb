
def generate_placesfinder(baseURL, apiKey, config = "Release")
  generate_config(baseURL, apiKey)
  generate_coordinode_files()
  generate_sourcery_files()
end

def generate_config(baseURL, apiKey)
  ENV["PLACESFINDER_BASE_URL"] = baseURL
  ENV["PLACESFINDER_API_KEY"] = apiKey
  run_script(
    [
      "cd Lanes/PlacesFinder",
      "chmod u+x generate_config.sh",
      "./generate_config.sh \"$PLACESFINDER_BASE_URL\" \"$PLACESFINDER_API_KEY\""
    ].join("\n")
  )
ensure
  ENV.delete("PLACESFINDER_BASE_URL")
  ENV.delete("PLACESFINDER_API_KEY")
end

def generate_coordinode_files()
  run_script(
    [
      "cd Lanes/PlacesFinder",
      "chmod u+x generate_coordinode_files.sh",
      "./generate_coordinode_files.sh"
    ].join("\n")
  )
end

def generate_sourcery_files()
  run_script(
    [
      "cd Lanes/PlacesFinder",
      "chmod u+x generate_sourcery_files.sh",
      "./generate_sourcery_files.sh"
    ].join("\n")
  )
end
