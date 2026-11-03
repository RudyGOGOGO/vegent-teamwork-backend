# Design Request 3/3: Vegent Project Refactor — From "Project Memory" to "Project Context", for Team Work Access

> To: Work-computer agent (Vegent core / Project system designer)
> From: Rudy, owner
> Workspace: `/Users/weizhang/Desktop/VegentUpstream`
> Companion documents (same delivery, design only):
> - Design Request 1/3: Team Work frontend v2 (dashboard, detail page, comments, Local vs. Team)
> - Design Request 2/3: Team Work backend + identity consistency (comments, member cascade, Project Context API, import)
> Task: **Propose the refactor design for Vegent's Project system, so that a local Project and a Team Work Project share the same concept and the same Context, and deliver a design document only. Do NOT implement yet.**
>
> **Revision note (2026-11-03, owner corrections): (1) There is NO data migration in this refactor — the current Project Memory feature is not in use by anyone, so there is no data to migrate and no backward-compatibility problem. Section 5 states this explicitly and replaces the original migration plan. (2) Terminology: the shared Project collection is "Project Context". An interim proposal, "Project Dossier", was tried and withdrawn by the owner on 2026-11-03 as too obscure; "Context" is restored throughout, and the richness of the collection is defined by the field list in Section 3.2, not by the word alone.**
>
> Send this entire document to the agent as the instruction. Do not shorten it, because the terminology change, the shared-vs-not-shared rule, and the no-migration rule are part of the instruction.

## 1. Background — the concept problem to fix

### 1.1 Team Work Project and Vegent Project are the same concept

A Team Work Project and a Vegent (local) Project are conceptually the same thing:

- A **multi-session collection** — many sessions, over time, working on the same work — that shares a common, Project-level collection of information.
- That shared collection is what makes a new session in the Project useful without re-describing the whole problem, and what makes a Team member's new session useful without re-describing the Project to them.

The difference is scope, not concept:

- **Local Project:** sessions are the user's own sessions only. No Team, no sharing, no other members.
- **Team Work Project:** sessions are Team members' sessions (each member's local sessions, linked to the Team Project), sharing the same Project-level collection, with Team membership, permissions, and a cloud backend for that collection.

A design that treats these as two unrelated concepts (a "local project" and a "team project" with different fields, different storage, and different UI) will make import, conversion, and sharing painful and error-prone. The refactor must unify them.

### 1.2 "Project Memory" is the wrong name — and the wrong model

Vegent's personal Project today is described as having a "Memory" mechanism (group memory: sessions in a group share a user-visible, editable group memory inherited at session start, with summarisation, view/edit/delete, and proposal-plus-approval for agent writes).

Owner judgment, to be reflected in this refactor design: **that name and that framing are not accurate, and they block Team Work access.**

- The Project-level collection is not "memory" in the sense of the Personal Agent's memory. The Personal Agent already has a real memory mechanism (user-level, long-term, personal — preferences, history, learned context, across Projects). Conflating Project-level shared information with Personal Agent memory confuses two different scopes: **user-level memory vs. Project-level shared work record.**
- The Project-level collection is better named and modelled as **Project Context**: a collection of Project information that any session in the Project — local or Team — can read and contribute to, within the Project's scope. Its richness is defined by the field list in Section 3.2 — background and goals, task breakdown and subtasks, progress, PR list, resources, decisions, members' comments, and open questions — not by a narrower prompt-context reading of the word.
- Project Context is a **context-sharing mechanism, not a memory mechanism.** It does not learn about the user, does not persist user preferences, and does not replace Personal Agent memory. It carries the Project's work forward: what the Project is, what it is trying to do, what tasks it contains, how far it has progressed, what PRs and resources belong to it, what has been discussed, and what remains open.

The refactor design must therefore:

1. Rename and remodel "Project Memory" as "Project Context" (see Section 3 for the exact rename rules — a rename in UI copy alone, without a data-model and API change, is not a refactor). There is no migration to design for this rename; see Section 5.
2. Define Project Context as a single, shared data structure that works for both local Projects and Team Work Projects, with a clear field list, a clear shared-vs-not-shared rule, and a clear local vs. cloud storage rule.
3. Show how a local Project's Context becomes a Team Work Project's Context on conversion, and how a Team Work Project's Context becomes a local session's Context on import, without sharing session execution content.

### 1.3 What must not change in this refactor

- Personal Agent memory is **not** being refactored here. It remains user-level, personal, and separate. The design must state, in its introduction, the distinction between Personal Agent memory and Project Context, with an example for each, so a reader does not merge them again.
- Local Vegent must keep working without login, without a Team, and without a cloud backend. The refactor must not make a local Project depend on the cloud, on a Team, or on a login.
- Local Vegent's session and grouping behaviour must be retained in the new design: grouped sessions appear only under their group, never in the time-based History list; History = ungrouped sessions only. This is a design requirement for the new Context model, not a migration of existing Memory data — there is no such data to migrate (Section 5).

## 2. Step 0 — map the current Vegent Project system (mandatory, before proposing)

As in the frontend auth design request, you do not know Vegent's Project system from this request alone. Your first step is to inspect the actual Vegent code in the workspace and produce a mapping. Do not skip this step and do not invent file paths, table names, or API names.

Map, at minimum:

- **Current Project / group model:** how a Project (group) is created, stored, listed, and opened in Vegent today; what fields it has; where its "Memory" lives (database table, file, or both); how sessions attach to a Project; how a session inherits the Project's shared information at session start.
- **Current Memory mechanism:** what is stored as "group memory" today (entries, summaries, decisions, pitfalls, TODOs, progress — list the actual entry types found in code, not the types assumed in this request); who can write it (user, agent, summarisation job); what the proposal-plus-approval rule actually is in code today; what the token-cost prompt actually is in code today (pre-job estimate, confirmation, post-job report — or a different rule); and what happens on summarisation, pruning, recompression, view/edit/delete.
- **Current session model:** what a "session" is in Vegent today (History conversation unit, not a Task/Team/taskId entity — verify this in code); how a session references its Project; what a session stores locally vs. what it inherits from the Project.
- **Current resource handling:** how a Project today references files (local file paths, uploaded files, or both); where those files live (local filesystem, Vegent storage, or elsewhere); and what a "resource" means in code today, if anything.
- **Current UI:** how Projects, groups, and History are shown in the sidebar and in Project views today, and where the word "Memory" appears in UI copy, settings, and help text today (list every occurrence found, so the rename in Section 3 can be complete).

Produce, as Section 1 of your design document, an inventory table with, for each item: Vegent file path (verified), current name/behaviour, and disposition (keep / rename / remodel / migrate / leave alone, with a reason). Any item you cannot find must be listed as "not found in Vegent, verified by search on [date]", not as "does not exist" on the basis of upstream Wegent alone.

If Step 0 shows that the workspace on this machine is not the Vegent Project system, or that a required file cannot be read, stop and report that as a blocker. Do not design against a different codebase.

## 3. Terminology and data model — Project Context (mandatory)

### 3.1 New terminology (use these names consistently, everywhere)

| Old term (to be retired) | New term (to use) | Meaning |
| --- | --- | --- |
| Project Memory / group memory | **Project Context** | The shared, Project-level collection of Project information (Section 3.2). Not user memory, not agent memory. |
| Group memory entry / memory item | **Context entry** (or a more specific name per entry type, if the designer proposes one — for example, Context note, Context decision, Context resource reference — with a reason) | One item in a Project's Context. |
| Personal Agent memory | **Personal Agent memory** (unchanged) | User-level, long-term, personal memory of the Personal Agent, across Projects. Distinct from Project Context. |
| Local Project | **Local Project** (unchanged, clarified) | A Project owned by one user, with sessions only from that user, with Project Context stored locally (or locally + cloud metadata only on conversion — see Section 5). |
| Team Work Project | **Team Work Project** (unchanged, clarified) | A Project in a Team, with sessions from Team members, with Project Context stored in the cloud backend (MySQL + S3, see Design Request 2/3) and imported into local sessions. |

The design must include a rename plan: every UI string, settings label, help text, API field name, database column/table name, and documentation reference that today says "Memory" for a Project-level collection must be listed, with its new name ("Context" / `context`). Because the current feature is unused and there is no data to migrate (Section 5), no alias, dual-write, or backward-compatibility shim is required or wanted: the old names are simply replaced in the new design. A UI-only rename, with the old table/field names still in the database and API, is not a complete refactor design.

### 3.2 Project Context — field list (shared set, for both local and Team Projects)

Project Context is a collection, not a single text blob. The design must define it as a structured set with, at minimum, the following fields / sub-collections. The designer may add a field only with a reason and a storage rule (local vs. cloud, MySQL vs. S3 vs. local file path).

**Core Context (required, shared in both local and Team Projects):**

- **Background and task goals:** Project background and task-goal introduction (text, required). This is the Project's "what and why".
- **Task composition:** tasks in the Project (title, description, status, assignee name where applicable — see Design Request 2/3 for the task model). Task status and progress are part of Context.
- **Creation time:** Project creation time (and, where available, creator name — for a local Project, the owner; for a Team Project, the creator).
- **Progress:** progress summary text + derived progress percent (from tasks, per backend v2) + last activity time.
- **Resources:** resource references — for a local Project, local file paths (and, where applicable, uploaded file references); for a Team Project, resource metadata (name, type, size, version, uploader) with S3 references via the backend (see Design Request 2/3, Section 7). The design must state, for each resource reference type, what is stored in Context (path / metadata / S3 key reference) and what is **not** stored (file bytes in Context itself, except where a small text resource is explicitly inlined with a reason).

**Optional Context (designer must decide, with a reason, whether each is in Context or in a separate Project table):**

- Decisions (title, context, decision, status) — if decisions are part of Context, state how they are versioned and who can change their status.
- PR list metadata (title, URL, branch, status, reviewers) — if PRs are part of Context, state that PR content itself is in GitHub/Stash, not in Context.
- Members (for a Team Project: name, email, role in Project — creator vs. member; for a local Project: owner only) — if members are part of Context, state that membership itself is governed by identity / Project membership tables, not by Context text.
- Comments (see Design Request 2/3) — if comments are part of Context, state whether they are included in the Context payload by default or fetched separately.

**Explicitly NOT in Project Context:**

- Session transcripts, chat history, tool calls, tool outputs, code diffs, execution logs.
- Personal Agent memory (user preferences, user history, learned user context).
- Secrets, tokens, passwords, `.env`, local credentials, or any other member's private local data.
- File bytes themselves (except where a small text resource is explicitly inlined with a reason — designer must state the size bound if this exception is used).

The design must include a table, for each field, with: field name, type, local storage, cloud storage (if any), who can read it, who can write it, and whether it is shared on import/conversion. A field with no storage rule or no permission rule is not a complete Context field.

### 3.3 Context vs. Memory — distinction to state in the design introduction

The design document's introduction must state, in plain language, with an example:

- **Personal Agent memory example:** "The agent remembers that Rudy prefers concise summaries and that his Team is Verizon Family" — user-level, across Projects, personal, not shared with a Team by default.
- **Project Context example:** "The Agent Delegation POC Project's Context says: background = prove delegation at minimum cognitive cost, tasks = agent form, geofence API, location history, progress = 68%, resources = Design Doc v3, Implementation Plan" — Project-level, shared by sessions in that Project (and, for a Team Project, by Team members in that Project), not user-level, not personal.
- **What happens when they interact:** a session in a Project reads both — Personal Agent memory (for how to work with this user) and Project Context (for what this Project is about) — but writes to them through different rules (Personal Agent memory via its own proposal/approval and token rules; Project Context via Project member permissions and, for agent writes, proposal-plus-approval where the current Vegent rule requires it — designer must state whether the current proposal-plus-approval rule for group memory carries over to Project Context, and why).

### 3.4 Context entry lifecycle (from current Memory lifecycle, remodelled)

The design must remodel the current Memory lifecycle (summarisation, view/edit/delete, pruning/recompression, proposal-plus-approval, token-cost prompt) for Project Context, and must state, for each operation:

- **View:** who can view Context (local: owner; Team: Project members), and where (Project view, session start inheritance, or both).
- **Edit:** who can edit Context (local: owner; Team: creator vs. member — designer must match backend v2 permissions, not invent a new rule), and whether edits are direct or proposal-plus-approval.
- **Summarise / prune / recompress:** when Context is summarised (user-triggered, agent-proposed, or automatic — designer must pick one primary trigger and state it), what the token-cost prompt is (carry over the current Vegent rule, or propose a changed rule with a reason), and what happens to old entries (archived, deleted, or versioned — designer must pick one).
- **Session start inheritance:** what a new session in a Project inherits from Context at start (full Context, a summary, or a selected subset — designer must pick one, with a token-cost justification), and what a session can add back to Context (and under what approval rule).
- **History:** Context edits must be versioned or audited (designer must state whether Context has versions, an audit log, or both, and how a user can see what changed and when).

## 4. Local Project vs. Team Work Project — one concept, two scopes

### 4.1 Unified Project model

The design must define a single Project model with a scope field (at minimum: `scope = local | team`, plus `team_id` nullable, `category_id` nullable for Team Projects, and `local_project_id` / `team_project_id` linkage fields where applicable — designer must propose the exact linkage model, with a reason).

- A Local Project has: owner = current user, scope = local, team_id = null, members = owner only, Context stored locally (database / file, per current Vegent storage, mapped in Step 0).
- A Team Work Project has: scope = team, team_id = Team id, category_id = Category id or null, creator = Project creator, members = Project members (creator-managed, per backend v2), Context stored in the cloud backend (MySQL + S3) and imported into local sessions.
- The same Project Context field list (Section 3.2) must work for both scopes, with storage differing only in where each field lives (local vs. cloud), not in what the field means.

### 4.2 UI distinction (frontend detail in Design Request 1/3, model here)

The backend / core model must support the frontend distinction in Request 1/3, Section 5:

- Every Project payload (local or Team) must include: scope, Team name (if Team), creator, member count, and a flag for whether it can be imported / converted (and, if not, why).
- A Local Project payload must not include Team member data, Team permissions, or cloud URLs. A Team Project payload must not include local file paths for other members' local files, or any other member's private local data.

### 4.3 Conversion and import — core model (frontend flows in Request 1/3, backend API in Request 2/3)

**Convert personal (local) Project → Team Work Project:**

1. Owner selects Team, Category (or No Category), and initial members from the Team roster.
2. The local Project's Context (Section 3.2) is copied to a new Team Project: background, goals, tasks, progress, resource metadata. Local file resources selected by the owner as shared resources are uploaded to S3 via the backend-mediated path; local file paths are **not** shared as-is (a local path is meaningless on another member's machine, and sharing it would leak local filesystem layout).
3. Session transcripts, tool outputs, and execution content are **not** converted. Local sessions remain local; they do not become Team sessions automatically.
4. After conversion, the design must state the linkage: does the original local Project become the linked local copy of the new Team Project, does it remain a separate local Project with a Team origin label, or is it replaced? Designer must pick one, with a reason, and must state what happens to the local Project's Context if the Team Project's Context later changes (no auto-sync, manual sync, or auto-sync — pick one, with a reason).

**Import Team Work Project → local session scope:**

1. A Team member selects a Team Project and chooses "Import to local session".
2. A local Project / local session scope is created (or linked, per the designer's linkage model) with the Team Project's Context (Section 3.2), so the user can immediately start work: write code, review a PR, or continue a task, in local Vegent.
3. Imported Context does **not** include other members' session transcripts, tool outputs, or execution content. The local session starts with Project Context, not with another member's chat history.
4. After import, the local session can (per Design Request 2/3, sync-back rule) push progress, task status, and comments back to the Team Project, or — if sync-back is deferred — the import is read-only Context import, labelled as such in the UI. The core design must state which, matching Request 2/3.
5. If the user is later removed from the Team Project, the local Project and its local sessions remain usable locally, but Team sync and Team Dashboard access become unavailable (grey rule, Request 1/3).

## 5. No migration — this feature is unused (owner-stated, mandatory)

**There is no data migration in this refactor, and the design must not invent one.**

Owner fact, to be taken as given: the current Project Memory feature is not in use by anyone. Therefore:

1. **No data to migrate.** There are no existing group memory entries, no user data, and no live Projects depending on the old Memory model that must be preserved, converted, or mapped to Context entries.
2. **No backward compatibility required.** The design needs no alias, no dual-write, no compatibility shim, no one-time migration script, and no rollback plan for old Memory data, because there is nothing to keep compatible with. Do not propose any of these as a safety measure — they would add complexity for a problem that does not exist.
3. **What Step 0 is still for.** Step 0 (Section 2) remains mandatory, but its purpose changes: it is an inventory of the current code and UI so the designer can (a) reuse what is sound in the new Context design, and (b) list any dead or unused "Memory" tables, files, fields, and UI strings so they can be removed outright in implementation, not migrated. If Step 0 finds any data that contradicts the owner's "unused" statement — for example, a populated table or an active user of the feature — the designer must stop and report that contradiction as a blocker, with evidence, rather than silently designing a migration around it.
4. **What the new design must still do.** The Context model is designed clean, from the field list in Section 3.2, for local and Team Projects alike. New Projects created under the Context model must show the grouping rule from Section 1.3 (grouped sessions only under their group, never in History). Personal Agent memory strings must **not** be changed to "Context" — the design must list the strings that stay as "Memory" (Personal Agent memory) separately, so the rename does not over-reach.
5. **Verification (design only, no test code yet).** Instead of a migration verification plan, the design must include a verification checklist for a fresh Context implementation: a new local Project and a new Team Project both show the Context fields in Section 3.2, sessions in a Project inherit the Context at session start per Section 3.4, and grouped sessions appear only under their group. Test code itself is a later implementation task.

## 6. Open questions, delivery, and stop gate

### 6.1 Open questions (designer must list, not invent)

1. Context entry types: keep current Memory entry types as Context entry types, or remodel them (Section 3.2)? If remodelled, what is the mapping?
2. Context storage for local Projects: current Vegent storage (mapped in Step 0) vs. a new table/file — pick one, with a reason.
3. Context versioning / audit: versions, audit log, or both (Section 3.4)?
4. Session start inheritance: full Context, summary, or subset — and token-cost justification (Section 3.4)?
5. Proposal-plus-approval for agent Context writes: carry over the current rule, change it, or remove it — with a reason (Section 3.4)?
6. Conversion linkage: original local Project becomes linked copy vs. remains separate with Team origin vs. replaced (Section 4.3)?
7. Sync-back after import: via existing endpoints vs. deferred read-only import (Section 4.3, matching Request 2/3)?
8. Resource conversion: local file paths → S3 upload selection — explicit per-file selection vs. all resources vs. none by default (Section 4.3)?
9. Unused "Memory" code found in Step 0: remove outright in implementation, or leave untouched — and, if Step 0 finds any data contradicting the owner's "unused" statement, how is that reported as a blocker (Section 5)?
10. Personal Agent memory interaction: how a session reads both Personal Agent memory and Project Context without merging them, and what the UI shows for each (Section 3.3)?

Each open question must name who can resolve it (owner, or a later design revision) and what is blocked if it is unresolved.

### 6.2 Delivery — design only, then STOP

Deliver one design document, in `/Users/weizhang/Desktop/VegentUpstream/` (location confirmed by the designer and stated in the header; do not create a second copy elsewhere), containing: Step 0 inventory (Section 2), terminology and rename plan (Section 3.1), Project Context field list with storage and permission per field (Section 3.2), Context vs. Memory distinction with examples (Section 3.3), Context lifecycle (Section 3.4), unified Project model (Section 4.1), UI distinction support (Section 4.2), conversion and import core model (Section 4.3), no-migration statement (Section 5), open questions (Section 6.1), changelog (what changed from current Vegent Project system and why), and status header **Version, Date, Status: DRAFT — NOT APPROVED**.

After delivering the design document, **STOP**. Do not write code, seed scripts, packages, or tests. Do not change Vegent's Project tables, files, or UI copy. Do not create AWS resources, migrate a pilot database, seed a pilot Team/Project, commit, or push. Owner reviews the design, asks for changes if needed, and gives explicit approval before any implementation is authorized. A design document is not an approval, and approval of identity v1.1 / C03 is not approval of this refactor.

**End of Project refactor design request. Rename Project Memory to Project Context, unify local and Team Projects on one Context model, and prepare Vegent for Team Work access, then stop for owner review.**
