Do tasks below:

## check, test, lint
If using Cargo workspace, add --workspace argument as needed.

- cargo check
- cargo test
- cargo clippy --all-targets --all-features -- -D warnings
- cargo fmt

## git commit

- Reference current changes and commit them separately by change type as much as possible

## git push

- Confirm we're not on main branch.
- Create feature branch if necessary.
- Push changes.

## create pr

- Create pull request.
    - If there's a corresponding Issue, add "close: #{issue-number}" at the beginning.
