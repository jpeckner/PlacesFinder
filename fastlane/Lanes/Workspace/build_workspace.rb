
def regenerate_all_artifacts(baseURL, apiKey)
  ensure_fresh_workspace()
  run_carthage_bootstrap()
  generate_placesfinder(baseURL, apiKey)
end

def ensure_fresh_workspace()
  ensure_git_status_clean

  reset_git_repo(
    exclude: [
        ".env",
        "Carthage"
    ]
  )

  clear_derived_data
end

def run_carthage_bootstrap()
  run_script(
    [
      "cd Lanes/Workspace",
      "chmod u+x run_carthage_bootstrap.sh",
      "./run_carthage_bootstrap.sh",
    ].join("\n")
  )
end

def generate_settings(tagVersion, tagBuild)
  version = "%{tagVersion} \(%{tagBuild}\)" % {tagVersion: tagVersion, tagBuild: tagBuild}

  run_script(
    [
      "cd Lanes/Workspace",
      "chmod u+x generate_settings_placesfinder.sh",
      "./generate_settings_placesfinder.sh -g '%{githubToken}' -v '%{version}'" \
        % {githubToken: ENV["PUBLIC_REPO_TOKEN"], version: version}
    ].join("\n")
  )
end
