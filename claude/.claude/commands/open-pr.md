Create a pull request for the current branch and output the PR link.

Follow these steps:

1. Run these commands in parallel to understand the current state:
   - `git status` to see untracked/modified files
   - `git diff` to see staged and unstaged changes
   - `git log --oneline -20` to see recent commit style
   - Determine the base branch (usually `master`) and run `git diff master...HEAD` to see all changes on this branch
   - Check if the branch already tracks a remote (`git rev-parse --abbrev-ref --symbolic-full-name @{u}`)

2. If there are uncommitted changes, ask the user whether to commit them first or proceed without them.

3. Analyze ALL commits on this branch (not just the latest) and draft a PR title and body:
   - Title: concise, under 70 characters
   - Body: use this format:

```
## Summary
<1-3 bullet points describing what this PR does>

## Test plan
<bulleted checklist of how to test>
```

4. Push the branch to the remote if needed (`git push -u origin HEAD`).

5. Create the PR using `gh pr create`. Use a HEREDOC for the body to preserve formatting.

6. Output the PR URL prominently so it's easy to click.
