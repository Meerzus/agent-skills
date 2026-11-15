# Planning: from a brief to the level below

A planning chat receives one `BRIEF.md` and turns it into the next level: a stage brief into
features, a feature brief into tasks. It interviews the developer first, because a decomposition
built on guesses has to be redone, and writes files only after the developer confirms the shared
understanding.

A planning chat therefore takes at least three messages from the chat, with the developer's replies
between them:

1. **Questions.** Read, then ask. The message ends with the questions. No file is created or
   changed.
2. **Summary.** After the answers (and further rounds if needed): what was agreed, and
   "подтверждаете?". The message ends there. Still no files.
3. **Files.** After the developer's "да": this level's files, one level down and no further, then
   the report.

If you are about to write a task file and the developer has not yet answered a question in this
chat, you have skipped steps 1 and 2: stop and ask.

## Contents

- [Before the interview](#before-the-interview)
- [The interview](#the-interview)
- [Cutting the level](#cutting-the-level)
- [Branches](#branches)
- [What to write](#what-to-write)
- [Finish](#finish)
- [Starting new work](#starting-new-work)
- [Adopting a project](#adopting-a-project)
- [The project's models](#the-projects-models)

## Before the interview

Read, in this order, whatever exists:

1. `docs/plans/README.md`, the project's agent instructions and its contributing rules.
2. The briefs above the pasted one, and the `STATUS.md` next to each: decisions already made,
   deviations and tails that land on this level.
3. The planner's `DEBT.md`: debt that this level could pay off or must not make worse.
4. The ticket the brief links to, when the tools at hand can open it.
5. For a feature: the code it will touch, and inside a stage the results of the features before it
   (the "Итог" in each closed feature's `STATUS.md`; its task files are gone by then).

Then mark this element as "планируется" in the parent's `STATUS.md` (a feature outside a stage has
no parent). That mark is the only file change allowed before the developer confirms the summary.

If `docs/plans/README.md` has no "Модели" table, the first round of questions also asks for the
line-up ([The project's models](#the-projects-models)).

Decisions recorded above this level are settled. Do not ask about them again; raise one only when it
contradicts another decision or the code, and say what contradicts what.

## The interview

Treat the level as a design tree: every decision opens the decisions that hang off it.

- Work in rounds. A round asks every question whose prerequisites are already settled, numbered,
  each with a recommended answer, worded so that "да" accepts the recommendation. A question that
  depends on another one still open waits for a later round.
- **A round ends the message.** After the last question, stop and wait. The recommended answers are
  there to make replying quick; they are not answers. Do not continue "assuming the
  recommendations" and do not write files "as a draft to adjust later".
- A brief with nothing left to decide is rare. If the pasted brief really has no open question, say
  so, give the summary, and still wait for the developer's "да" before writing files.
- Finding facts is the chat's job. What can be looked up in the code, the docs or the web is looked
  up, with a subagent when the search is wide and the agent has them, never asked. The decisions are
  the developer's.
- Keep going until no open decision is left. Then summarise what was agreed and wait for the
  developer to confirm before writing files.
- When a dedicated interviewing skill is installed (for example `grilling` from
  `mattpocock-skills`), load it and follow its format; these rules are the same thing in short, so
  the workflow does not depend on it.

Ask what changes the decomposition: where the boundaries go, what comes first, what "done" means,
what is deliberately left out, what should be tried by hand and when. A feature's chat mostly
settles technical choices and the order of tasks.

The answers are the valuable part of a plan for a colleague: they cannot be recovered from the
code. Record each decision in the brief with its reason, not only the outcome.

## Cutting the level

**Into features.** A feature is something a person can try by hand when it is done, and it ends in
one pull request of a size the team will actually review. Prefer a thin slice through all layers
over a layer finished in isolation: a schema nobody reads cannot be tried. Give each feature a line
on what will be possible after it. Do not invent a stage to hold one feature.

**Into tasks.** A task is one logical change that fits one chat without the context being
compressed: read a handful of files, change a handful, run the checks, commit. Usually three to
eight per feature. Order them so that the branch works after every one. If a task needs "and" to be
described, it is two tasks. Number with a gap-free two-digit prefix; the review is always
`90-review.md`.

At every level, write down what each child depends on, so a chat can refuse to start on a missing
foundation.

**One level only.** A stage's chat stops at feature briefs: the tasks of each feature are cut in
that feature's own chat, after its own interview. A feature's chat stops at task files: it writes
no code.

## Branches

`docs/plans/README.md` says how branches are named, where they start and how they merge. This
section only says which branch a plan file belongs to.

- **A feature's plan and code share the feature's branch.** Create the branch the project's way if
  it does not exist yet, and write its name into the feature's `STATUS.md`: a colleague finds the
  work by that name.
- **A stage has no branch of its own.** Its files change on the branch of the feature whose work
  changes them: the stage's planning is committed on its first feature's branch, and closing a
  feature updates the stage's `STATUS.md` on that feature's branch before the pull request merges.
  Features of one stage therefore run one after another, each branching after the previous one has
  merged. If the stage brief wants two at once, it also says who updates the stage's files.

## What to write

Use the formats in `assets/`, in the language `docs/plans/README.md` names.

1. **Rewrite the pasted `BRIEF.md`** into its final form: open questions become decisions, the
   breakdown lists the children with one line each. The header stays, with the mode unchanged, so
   the file still shows how it was planned.
2. **Create the children:**
   - stage → a folder per feature with a draft `BRIEF.md` (mode "план фичи"), plus `90-close.md`
     (mode "закрытие этапа");
   - feature → the task files (mode "задача"), plus `90-review.md` (mode "проверка фичи").

   A draft brief states what the element delivers, what is in and out, the decisions it inherits,
   what to read, the questions its own planning chat should settle, and when it counts as done. Its
   header names the model tier for that chat, with the name from the project's "Модели" table.

   A task file is instructions, not a discussion: the goal, what to read first, what to do, what not
   to touch, when it is done, how to check it. Name real files and commands. Leave the "how" to the
   task chat wherever the choice does not affect other tasks; over-specified tasks break on the
   first surprise in the code.
3. **Create this level's `STATUS.md`** listing the children as "не начато", with the branch name
   and "Ведёт" set to the developer's login, or to "—" when they plan for someone else.
4. **Update the parent's `STATUS.md`,** if there is a parent: this element is now "в работе".
5. **Decisions that reach beyond this feature** also go where the project keeps such decisions
   (its decisions document or ADRs), so people outside this plan see them.

## Finish

Commit the plan on the feature's branch as its own commit, in the project's commit format. Push
when the developer says so, and always when the work is being handed to someone else
([handoff.md](handoff.md)).

Report in a few lines: what was created, anything the developer should look at before work starts,
and the next file to paste with its model tier. That is the first child's brief, or the first task.
Then stop: the next piece belongs to a new chat.

## Starting new work

The developer brings a ticket or describes a feature, and there is no brief yet.

1. Make sure the project is set up ([Adopting a project](#adopting-a-project)) and find the
   developer's folder, `docs/plans/<login>/`. The login is their handle on the project's git host,
   in lowercase: `gh api user --jq .login` on GitHub. If it cannot be read, or a folder that looks
   like theirs already exists under another spelling, ask once and use the existing one.
2. Name the folder after the ticket when there is one (`PROJ-123-csv-export`), otherwise a short
   slug. Decide the level: a feature unless the work clearly needs several pull requests, and then a
   stage.
3. Create the branch the project's way. For a stage, this branch becomes its first feature's branch.
4. Write `BRIEF.md` with the matching mode: what it is and why, what is in and out, what is already
   decided, what to read, the ticket link, the questions planning should settle, when it is done.
   Open questions stay open in it: listing them is this chat's job, answering them is the
   developer's.
5. **Stop.** Commit the brief on the branch and end the message with its path, a two-line summary
   of what it says, and the brief as the next file to paste into a new chat. This chat creates
   nothing below the brief: no task files, no child folders, no `STATUS.md`.

   Planning continues in this same chat only if the developer says so ("продолжай здесь") and the
   chat is still short. It then starts from the top of this file, with the questions.

## Adopting a project

`docs/plans/README.md` exists → the project already uses the workflow: read it, and create only the
developer's folder (with `DEBT.md`) when it is first needed.

Otherwise set the project up, once:

1. **Who will see the plan.** Check the repository's visibility (`gh repo view --json visibility`
   on GitHub; ask when it cannot be read). In a public repository say plainly that briefs, answers
   and debt will be public, and continue only on an explicit yes.
2. **The folder can be tracked.** If `git check-ignore -q docs/plans/README.md` succeeds, the path
   is ignored: stop and ask, because a shared plan has to be committed.
3. **Learn the project's rules.** Look first: contributing guide, agent instructions, CI
   configuration, branch names on the remote, the style of recent commits. Then confirm in one
   round what could not be read: the base branch and branch naming, how pull requests merge and who
   merges them, the check command, the commit format, when to push, the language of plan files,
   where debt goes. The same round asks for the team's models
   ([The project's models](#the-projects-models)): they cannot be read from the repository.
4. **Write `docs/plans/README.md`** from [assets/readme.md](../assets/readme.md) with those answers.
5. **Point the agent instructions at it.** With the developer's OK, add one line to the project's
   agent instructions (`AGENTS.md`, `CLAUDE.md` or what the project uses) saying that plans live in
   `docs/plans/` and work goes through this skill. Skip it when the project has no such file.
6. **Commit it like any other change to a shared repository:** on a branch and through a pull
   request the project's way, or together with the first feature's branch.

## The project's models

Plan files name a model tier, and the "Модели" table in `docs/plans/README.md` says which model of
this team each tier means. The table is filled when the project is adopted, and again when the
developer says "обнови модели" or a chat finds it missing.

1. **Ask, do not guess.** Two questions, in one message, and then wait:
   - which models can be chosen in the agent the team uses here;
   - which of them is the strong one (planning a stage), the ordinary one (planning a feature,
     most tasks, reviews) and the small fast one (mechanical tasks). One model may take two tiers.

   Also ask whether that agent has an effort or reasoning-level setting, and its values.
2. **Do not rank models yourself**, even ones you think you know: names are reused, and the
   developer sees price and speed that the chat does not. Do not add models the developer did not
   name.
3. **Write the table** as the developer gave it, with the exact names shown in their agent's model
   picker, so a colleague can find them.
4. **Commit** the README change the project's way. Plan files written earlier keep their headers:
   the tier in them is still right, and a wrong name in brackets is fixed when the file is next
   edited.

Until the table exists, headers carry the tier alone: `Модель: средняя`.
