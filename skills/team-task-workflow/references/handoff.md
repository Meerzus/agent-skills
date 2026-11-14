# Handing work over and picking it up

The plan lives in the repository so that work can change hands at any point: after planning, between
two tasks, or in the middle of one. A handover is good when the colleague can start from the files
alone, without a call and without this chat.

## Handing over

The developer says "передаю", "отдаю фичу", or that someone else will continue.

1. **Bring the branch to a consistent point.** Finish the current task and commit it green, or park
   it: commit the part that passes the checks and describe the rest. Work that is not committed
   exists only on this machine and cannot be handed over. If the task is half done and red, ask the
   developer which they want: a commit clearly marked as work in progress, when the project allows
   one on a feature branch, or the changes stay local and the task is recorded as not started. Write
   down which it was.
2. **Fill "Передача" in the feature's `STATUS.md`:** the date and from whom; the state in two or
   three lines; the next file to paste, with its model and effort; and what the files do not say:
   traps, local setup, open questions, who to ask.
3. **Set "Ведёт"** to the colleague's login, or to "—" when it is not known yet.
4. **Commit the plan and push the branch.** Asking for the handover is the developer's word to
   push. Open a draft pull request when `docs/plans/README.md` says that is how work in progress is
   shared.
5. **Report:** the branch name, the file the colleague should paste first, and a short message the
   developer can send them as is.

A plan written for someone else from the start is the same thing without step 1: the planning chat
ends with "Ведёт: —" and a pushed branch.

## Picking up

The developer says "подхвати", "продолжи за ...", or pastes a file from a colleague's folder whose
"Ведёт" is not them.

1. **Get the branch.** The working tree must be clean first. Fetch, and check out the branch named
   in the feature's `STATUS.md`. If the developer gave only a name, find the folder under
   `docs/plans/*/` on the remote branches and confirm it is the one they mean.
2. **Read:** `docs/plans/README.md`, the feature's `BRIEF.md`, its `STATUS.md` with "Передача", the
   "Итог" of the finished tasks. Then skim the branch's diff against its base and judge the code as
   it is, not as the plan says it should be.
3. **Run the checks** before building on the branch. If they are red, say so before anything else:
   the previous developer should know, and the next task must not start on a broken base.
4. **Tell the developer** in a few lines what state the work is in and what comes next, and ask
   what stayed unclear. Questions only the planner can answer go to the planner through the
   developer; do not fill the gap with a guess.
5. **Set "Ведёт"** to the developer's login with the date, commit, and push, so the planner and
   everyone else see that the work is taken.
6. **Name the next file to paste.** A pick-up chat has read a lot; the task itself goes in a fresh
   chat unless the developer says otherwise.

The plan stays in the planner's folder; do not move it. Decisions in the brief are settled: when the
new developer disagrees with one, raise it, and record the outcome as a deviation rather than
re-planning quietly. The planner's name on the folder means they can still be asked why.
