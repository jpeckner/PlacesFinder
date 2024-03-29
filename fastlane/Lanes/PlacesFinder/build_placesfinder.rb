
def generate_placesfinder(baseURL, apiKey, config = "Release")
  run_pod_install()
  generate_config(baseURL, apiKey)
  generate_coordinode_files()
  generate_sourcery_files()
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

def run_pod_install()
  run_script("bundle exec pod install")
end
