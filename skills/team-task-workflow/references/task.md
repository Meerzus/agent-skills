# Doing a task

The chat received a task file. It does that task, proves it works, commits, and leaves a record the
next chat can rely on, whoever runs it.

## Before touching code

1. Read `docs/plans/README.md`, then the feature's `BRIEF.md` and `STATUS.md` (the task file's
   header gives its own path; they sit next to it), and the "Итог" sections of the tasks before this
   one. They carry decisions and deviations that the task file, written earlier, may not know about.
2. Check the ground:
   - the checked-out branch is the one named in the feature's `STATUS.md`, and it has what the
     remote has: fetch and fast-forward first, because a colleague may have pushed. A branch that
     has diverged from its remote is not something to resolve by guessing;
   - "Ведёт" in `STATUS.md` names the developer in this chat. If it names someone else or nobody,
     this is a pick-up: go through [handoff.md](handoff.md) first, so two people do not build on
     the same branch without knowing;
   - every task under "Зависит от" is "готово";
   - the working tree is clean;
   - no earlier task of this feature is "заблокировано".

   If any of this fails, stop and tell the developer what you found. Uncommitted changes of unknown
   origin are someone's unfinished work, not something to build on or to discard.
3. Read what the task file lists under "Прочитать перед началом", and the project's own rules for
   the area (its agent instructions name them: framework docs to read first, forbidden content,
   package manager).
4. Mark the task "в работе" in the feature's `STATUS.md`.

## While working

- Stay inside the task. The file says what not to touch; respect it even when the neighbouring code
  looks wrong. Write what you noticed into the feature's tails or into the planner's `DEBT.md`
  instead.
- When the plan does not fit reality:
  - a detail (a different file name, an extra helper, a simpler approach with the same result):
    do the sensible thing and record it as a deviation;
  - something that changes what other tasks must do, or the feature's scope: stop at a consistent
    point and ask the developer. After their answer, update the affected task files so later chats
    are not misled. When the developer is not the planner, say in the deviation that the planner
    should hear about it.
- When the task turns out bigger than one chat: finish the part that stands alone, commit it green,
  and write the rest as a new task file placed right after this one, renumbering the tasks that
  follow. Say so in the report. A half-finished task with a clean commit and a clear continuation is
  a good outcome; a huge chat that runs out of context is not.
- Tests come with the code they test, in the same task, unless the feature's brief decided
  otherwise.

## Checks and the commit

Run the check command from `docs/plans/README.md` when code changed. A plan-only task needs no
checks.

**Green:** commit the code on the feature's branch in the project's commit format. The message
explains the code, not the plan behind it.

**Red:** fix it if the cause is in this task's work. If it is not fixable here (a failure outside
the task, a missing decision, an environment problem):
- do not commit, and leave the changes in the working tree;
- set the task to "заблокировано" in `STATUS.md` with the reason, the failing output in short, and
  what was already tried;
- stop and report. The developer decides whether this chat continues or a new one takes over.

Never commit with a red check to "unblock" the next task. The next chat, and the next person, trust
that the branch works.

## Record the result

1. Fill "Итог" at the bottom of the task file: the date, the commit hashes, what was done in two or
   three lines, deviations from the plan, tails.
2. Update the feature's `STATUS.md`: the task's state and hashes, new deviations and tails.
3. Add to the planner's `DEBT.md` anything knowingly left worse than it should be, with where it
   arose and why it was deferred. When `docs/plans/README.md` sends debt to the team's tracker
   instead, list the items in the report for the developer to file.
4. Commit the plan update as its own commit, after the code commit it describes.

Push only when `docs/plans/README.md` says tasks are pushed as they finish, or the developer asks.
Hashes are a convenience while the branch lives; a rebase or a squash merge changes them, which is
why the feature's final record is its pull request.

Write the result for a reader who has never seen this chat: full sentences, real file names, no
"as discussed".

## Report

A few lines to the developer: what now works, which checks ran and their result, the commits,
deviations if any, and the next file to paste with the model tier from its header. If this was the
last task before the review, the next file is `90-review.md`. Then stop: the next task belongs to a
new chat, even when it looks small.
