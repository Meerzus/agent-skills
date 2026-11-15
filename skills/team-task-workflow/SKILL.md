---
name: team-task-workflow
description: A team's way of building features in small chats with the plan shared in the repository - each developer plans in docs/plans/<login>/ (features cut into tasks), each level is planned from a brief file in its own chat (interview first, then decomposition), each task is done in a fresh chat from a pasted task file, and status, deviations and debt are written to files on the feature's branch so a colleague can pick the work up. Use whenever a pasted message starts with a header naming this skill, or the project has docs/plans/README.md, and the developer asks to plan or split work ("распланируй фичу", "распиши на задачи", "напиши бриф"), adopt this process in a project, do the next task, hand work over or continue a colleague's ("передаю фичу", "подхвати за ..."), review or close a feature ("закрывай фичу"), or asks where the plan stands ("где мы", "что дальше") - even if they do not name the skill. Not for a project whose own instructions name a different planning skill.
---

# team task workflow

One long chat that plans, builds and reviews everything loses track of its own decisions and burns
limits on context it no longer needs. This workflow cuts work into pieces small enough that each one
is planned or built in a fresh chat, and keeps everything those chats need to know in files in the
repository. The next chat can then be anyone's: the same developer tomorrow, or a colleague who
takes the work over.

The developer drives it by hand: they open a new chat, set the model the file recommends, paste the
file's contents, and the chat does that one piece and hands control back. So every file must work
as a complete first message, and every chat must end by naming the next file to paste. A chat never
runs ahead of the developer: see [Where a chat stops](#where-a-chat-stops).

Two roles appear below. **The developer** is whoever is in the chat now. **The planner** is whoever
wrote the plan; the folder carries their login. They are often the same person, and nothing changes
when they are not.

## Where the plan lives

```
docs/plans/                     tracked in the code repository, on the same branches as the code
  README.md                     how this project uses the workflow: branches, checks, language
  <login>/                      one folder per developer: the plans they wrote
    DEBT.md                     tech debt this developer recorded
    <feature>/                  named after the ticket when there is one: PROJ-123-csv-export
      BRIEF.md
      STATUS.md
      01-<task>.md
      02-<task>.md
      90-review.md              always the last task of a feature
    <stage>/                    only for work too big for one feature
      BRIEF.md
      STATUS.md
      01-<feature>/             BRIEF.md, STATUS.md and tasks, as above
      90-close.md               closes the stage
```

| Level | What it is | Ends with |
|---|---|---|
| **Stage** | work too big for one feature; most work never needs one | its last feature merged |
| **Feature** | a slice someone can try by hand | a merged pull request |
| **Task** | one chat, one logical change | a commit on the feature's branch |

- **A folder per developer** keeps two people from numbering over each other and from editing the
  same files, which is where merge conflicts come from. The folder says who planned the work, not
  who is doing it: a colleague continues in the planner's folder, because every file's header
  carries its own path.
- **The plan travels with the code.** A feature's plan files are committed on that feature's branch,
  so whoever checks the branch out has both. A plan that exists only on one machine cannot be picked
  up, which is why handing work over includes pushing.
- **`docs/plans/README.md` holds what differs between projects:** how branches and pull requests
  work here, the check command, the commit format, the language of plan files, where debt goes.
  Read it at the start of every chat. Where it is silent, follow the project's contributing rules
  and agent instructions, and ask rather than invent. This skill never overrides a project's git
  rules.
- **A level is decomposed only when work reaches it.** A stage's chat writes briefs for its
  features; a feature's tasks are planned when that feature starts. Plans written far ahead go stale
  before anyone uses them.
- The tree shows work in progress. A closed feature keeps only its `BRIEF.md` and `STATUS.md`, and
  so does a closed stage.

## Which mode

The header of the pasted file says it. Without a header, go by what the developer asks.

| The chat starts with | Do | Read |
|---|---|---|
| a `BRIEF.md` (mode "план этапа / фичи") | interview the developer; after their answers and their "да", decompose one level down | [references/planning.md](references/planning.md) |
| a task file (mode "задача") | do the task, check, commit, record the result | [references/task.md](references/task.md) |
| `90-review.md` (mode "проверка фичи"), or "закрывай фичу" | review with fresh eyes; close and clean up on the developer's word | [references/closing.md](references/closing.md) |
| `90-close.md` (mode "закрытие этапа") | walk the stage as a whole, then clean up | [references/closing.md](references/closing.md) |
| new work: a ticket, "распланируй фичу", "напиши бриф" | write the brief in the developer's folder, and stop | [references/planning.md](references/planning.md#starting-new-work) |
| no `docs/plans/README.md` yet, "подключи процесс" | set the project up | [references/planning.md](references/planning.md#adopting-a-project) |
| "обнови модели", or the README has no "Модели" table | ask which models the team has, write the table | [references/planning.md](references/planning.md#the-projects-models) |
| "передаю", "подхвати", "продолжи за ..." | hand the work over, or pick a colleague's up | [references/handoff.md](references/handoff.md) |
| "где мы", "что дальше" | read the `STATUS.md` files in the developer's folder (or the colleague's they name) top down, answer with the state and the next file to paste | — |

File formats are in [assets/](assets/): `brief.md`, `status.md`, `task.md`, `debt.md`, and
`readme.md` for `docs/plans/README.md`. Copy the structure, keep the header block exactly, and drop
sections that would be empty.

## Where a chat stops

The plan is worth something only because the developer's answers are in it. A chat that writes the
brief, the questions, the answers and the tasks in one go has guessed those answers, and the
guesses then get built. So at each point below the chat ends its message and writes nothing more
until the developer replies.

| The chat has just | Its message ends with | Before the developer replies it does not |
|---|---|---|
| written a `BRIEF.md` for new work | the brief's path, and the brief as the next file to paste | ask the interview questions, create task files or child folders |
| asked a round of interview questions | the numbered questions, each with a recommended answer | answer them itself, create or change any file |
| summarised what was agreed | the summary and the question "подтверждаете?" | write files |
| written one level down: a stage's feature briefs, or a feature's task files | the report and the next file to paste | plan the level below, start a task, write code |
| finished a task | the report and the next file to paste | start the next task |

- **A recommended answer is a suggestion.** The developer has not answered until they answer. A
  request made once at the start ("распланируй фичу") is not an answer to questions asked later.
- **One chat writes one level.** A stage's chat writes feature briefs and no task files. A feature's
  chat writes task files and no code. New work gets a brief and nothing below it.
- **The only shortcut is the developer's own words** ("вопросов не задавай, реши сам", "продолжай
  здесь"). Then say in the brief which decisions were the chat's and not the developer's.
- If the agent cannot wait for a reply at all (a run with nobody to answer), it stops at the first
  of these points anyway and reports what it needs.

## What holds everywhere

1. **One chat, one piece.** A planning chat decomposes one level and stops. A task chat does one
   task and stops. Starting the next piece in the same chat is how context fills up and quality
   drops; name the next file instead. The developer may overrule this for a tiny follow-up.
2. **Files are the memory.** A chat knows nothing from earlier chats, and the next reader may be a
   colleague who was never in any of them. Before working, read the briefs and statuses above the
   pasted file and the results of the tasks before it. Before finishing, write down everything the
   next chat needs: what was done, what differs from the plan, what is left.
3. **Status moves up at closing.** A task chat edits its feature's `STATUS.md` and the planner's
   `DEBT.md` only. Closing a feature updates its stage. This keeps upper files from being rewritten
   by every chat.
4. **Nothing silently out of scope.** Something found outside the task goes into the feature's tails
   or into `DEBT.md`, not into the diff. A plan that turns out wrong is recorded as a deviation when
   small, and stops the chat for the developer's decision when it changes other tasks.
5. **The project's git rules win.** A task commits on the feature's branch: the code first, then the
   plan update as its own commit, so the status can name the code commit. Checks red and not fixable
   in this chat → no commit, mark the task blocked with the reason, stop. Pushing, opening a pull
   request and merging happen on the developer's word and the way `docs/plans/README.md` says.
6. **The plan is read by the whole team.** Write for a colleague who was not there: full sentences,
   real file names. No secrets, tokens, customer data or remarks about people. In a public
   repository the plan is public too.
7. **Closed work leaves a summary, not its files.** Closing a feature deletes its task files,
   closing a stage deletes its feature folders. The summary goes into the `STATUS.md` that stays,
   and everything is committed before anything is deleted, so every file can be restored from
   history. Only a closing chat deletes plan files.
8. **End every chat with the next step:** the file to paste next, with its model tier, or the
   decision the developer has to make.

## Models and effort

Every brief and task file names the model for the chat that will run it. The developer sets it
before pasting; a pasted message cannot switch the model.

Teams, machines and agents have different models, so a file names a **tier**, and the project says
which of its models each tier means.

| Chat | Tier | Effort |
|---|---|---|
| Planning a stage | strong (сильная) | high |
| Planning a feature | mid (средняя) | high |
| Task, mechanical (config, boilerplate by an existing pattern, renames) | small (малая) | medium |
| Task, ordinary | mid (средняя) | medium |
| Task, hard (disputed logic, a screen's design, concurrency, data migration) | mid (средняя) | high |
| Feature review, closing | mid (средняя) | high |

Pick the cheapest tier that does the piece well. Most of the work is ordinary. The strong tier in a
task only when the feature's planning chat writes down why that task needs it.

- **The names come from the "Модели" table in `docs/plans/README.md`** and from nowhere else. A
  header reads `Модель: средняя (<the table's name for that tier>)`. Do not write a model name from
  memory, the name of the model this chat runs on, or a name seen in another project: a colleague
  would be told to pick a model their agent does not have.
- **No table, or no model for the tier** → write the tier alone, and ask the developer for the
  line-up ([references/planning.md](references/planning.md#the-projects-models)). Do not rank
  unfamiliar models yourself; the developer knows which of theirs is the strong one.
- **Effort** is a setting only some agents have. The same table says whether this project's agent
  has it; when it does not, leave "усилие" out of every header and report.
- A developer whose own line-up differs from the table goes by the tier. One model may serve two
  tiers when the team has fewer models than tiers.
- If the chat can tell it runs on a clearly different tier than the header asks for, it says so in
  one line and carries on.
