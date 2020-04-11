
def generate_placesfinder(baseURL, apiKey, config = "Release")
  generate_config(baseURL, apiKey)
  generate_coordinode_files()
  generate_sourcery_files()
  generate_project_files()
end

def generate_config(baseURL, apiKey)
  run_script(
    [
      "cd Lanes/PlacesFinder",
      "chmod u+x generate_config.sh",
      "./generate_config.sh '%{baseURL}' '%{apiKey}'" \
        % {baseURL: baseURL, apiKey: apiKey}
    ].join("\n")
  )
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

def generate_project_files()
  run_script(
    [
      "cd Lanes/PlacesFinder",
      "chmod u+x generate_project_files.sh",
      "./generate_project_files.sh",
    ].join("\n")
  )
end
