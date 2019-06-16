
### Git functions ###

def verify_no_commits_to_pull(branch)
  commitDiffCount = sh("git rev-list HEAD...origin/%{branch} --count" % branch).to_i
  
  UI.user_error!(
    "Expected no commits to pull on '%{branch}', but found %{commitDiffCount}" \
    % {branch: branch, commitDiffCount: commitDiffCount}
  ) unless commitDiffCount == 0
end

def tags_for_commit(committish)
  sh("git tag --points-at %{committish}" % committish)
end

def verify_commit_tags(committish, expectedTags)
  commitTags = tags_for_commit(committish: committish)
  
  UI.user_error!(
    "Expected tag '%{expectedTags}' on %{committish}; found '%{commitTags}'" \
    % {committish: committish, expectedTags: expectedTags, commitTags: commitTags}
  ) unless commitTags == expectedTags
end

### Shell functions ###

def run_script(script)
  sh(
    script, 
    error_callback: ->(result) { UI.user_error!("Script failed with error: " + result) }
  )
end
