# Reviewing and closing

Three moments end a piece of the tree: the review of a feature, the closing of a feature, the
closing of a stage. Anything that leaves the machine needs the developer's word and follows
`docs/plans/README.md`.

## Reviewing a feature (`90-review.md`)

The review is the feature's last task, run in a fresh chat on purpose: a chat that did not write the
code reads it as a stranger would, and finds what the authors stopped seeing. It comes before the
team's own code review, not instead of it.

1. Read the feature's `BRIEF.md` and `STATUS.md`, then the feature's diff: the branch against its
   base as the remote has it (`git diff origin/<base>...HEAD` after a fetch; a local copy of the
   base may be stale or missing). Do not read the task chats' reasoning into the code; judge what
   is there.
2. Check against the brief's "Готово, когда": does each point hold? Run the project's checks.
3. Run the thing. Start the app or call the code the way a user will, and try the main path and the
   obvious ways to break it. A feature that passes its tests and fails in the hand is not done.
4. Look for what tasks tend to leave behind: seams between tasks, duplicated helpers, dead code,
   missing error paths, anything the project's rules forbid.
5. Sort what you find:
   - a few lines, clearly right → fix here, in a separate commit;
   - bigger → a new task file in this feature, numbered before `90-review.md`; the feature stays
     open until those are done, then the review runs again on the additions only;
   - decided not to fix now → the planner's `DEBT.md`.
6. Record the result in `90-review.md` and in `STATUS.md`, set the feature to "проверка", commit
   the plan.
7. Report what was found and fixed, and tell the developer what to try by hand and how to start it.
   Offer to push and open the pull request for the team's review. The feature is closed by the
   developer, not by the review.

## Closing a feature

Happens when the developer says so ("закрывай фичу"): in the review chat, or in a new chat that is
given the feature's path. The best moment is after the pull request is approved and before it
merges: review fixes still have their task files for context, and the cleanup rides in the same
pull request.

Before anything leaves the machine, confirm: every task including the review is "готово", the
working tree is clean, the checks are green, and the branch is up to date with its base the way the
project does that.

One "close it" from the developer covers this sequence:

1. Push the branch. Open the pull request if there is none: a title that says what the feature
   gives in plain words, a body in the project's template, a link to the plan folder.
2. Update the plan:
   - feature `STATUS.md`: "готово", the pull request link, the date, and the "Итог" section (see
     [Cleaning up](#cleaning-up-after-closing));
   - inside a stage, the stage's `STATUS.md`: the feature is "готово", and its open tails move
     there so they are not buried in a closed folder. A feature outside a stage keeps its open
     tails in its own `STATUS.md`, which stays.
3. Clean up the feature's task files as described in [Cleaning up](#cleaning-up-after-closing).
4. Push again, so the pull request carries the final plan.
5. Merge only when `docs/plans/README.md` lets the developer's agent merge and the project's
   conditions hold: required approvals, green CI. Otherwise report that the pull request is ready
   and leave the merge to whoever the project's rules name. A required review or a red CI is never
   merged around.

Report with links, and name the next file: the next feature's `BRIEF.md` for its planning chat, the
stage's `90-close.md` when this was its last feature, or nothing when the work is finished.

Review comments that arrive after closing are fixed on the branch. Update "Итог" when a fix changes
what it says. If the comments ask for real work, reopen the feature: new task files, the state back
to "в работе", and a new closing afterwards.

## Closing a stage (`90-close.md`)

Run in a fresh chat when every feature of the stage is "готово", usually after the last one has
merged.

1. Read the stage's `BRIEF.md`, `STATUS.md` and the tails collected from its features.
2. Walk the stage as a whole against the brief's "Готово, когда": use the product the way the stage
   promised, across features, not feature by feature again.
3. Go through the debt this stage recorded: what must be paid now becomes tasks (a small closing
   feature if there are several); the rest stays, with its entry updated.
4. Update the stage's `STATUS.md`: "готово", the date and the "Итог" section.
5. Clean up the stage's feature folders as described in
   [Cleaning up](#cleaning-up-after-closing).
6. Bring the change in the project's way. It touches only plan files: usually a small pull request,
   or the last feature's pull request when the stage is closed together with it.
7. Report what the stage delivered and what is left open. Releasing follows the project's own
   process, not this skill.

## Cleaning up after closing

A closed element keeps a summary and loses its working files. Later chats, and colleagues browsing
the folder, read the tree top down: stale task files cost context and get mistaken for pending
work. Nothing is lost, because everything is committed before anything is deleted.

| Closed | Deleted | Stays |
|---|---|---|
| Feature | its task files, `90-review.md` included | the feature's `BRIEF.md` and `STATUS.md` |
| Stage | its feature folders and `90-close.md` | the stage's `BRIEF.md` and `STATUS.md` |

Cleanup is part of closing, so the developer's word to close covers it. Do the steps in this order:

1. **Check that it is safe.** All of these hold, or nothing is deleted and the report says why:
   - the element and every child are "готово": no task in progress, nothing "заблокировано";
   - open tails are where they will survive, and debt is recorded;
   - the working tree is clean, so every plan file is already in a commit.
2. **Write "Итог"** in the `STATUS.md` that stays, for a reader who will never see the deleted
   files or any chat: what a user can do now, what was built with real paths and module names, the
   pull request, and the decisions and deviations later work relies on. For a stage, one line per
   feature, taken from the features' own "Итог".
3. **Snapshot.** Commit the plan with every file still in place, and note the hash.
4. **Delete** with `git rm` (`-r` for folders), so only committed files go. An untracked file in a
   folder about to be deleted means the snapshot missed it: stop and look.
5. **Record and commit.** Write the snapshot hash and the pull request into "Итог" as "Архив", then
   commit the deletion.
6. **Report** what was removed, the snapshot hash, and how to get it back:
   `git checkout <hash> -- <path>` restores the files, `git show <hash>:<path>` prints one.

"Архив" names the pull request as well as the hash because a squash merge leaves the snapshot commit
out of the base branch. It then lives in the pull request's history; on GitHub
`git fetch origin pull/<number>/head` brings it back after the branch is deleted.

Only a closing chat deletes plan files. Planning and task chats never do.
