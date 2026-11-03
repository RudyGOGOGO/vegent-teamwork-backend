# Design Optimization Requirements: Team Work Backend v2-additions — Complete Revision Requirements

> To: GPT (Team Work backend designer)
> From: Rudy, owner
> Design under revision: `/Users/weizhang/Desktop/VegentUpstream/TeamWork/Design/vegent-teamwork-backend-design-v2-additions.md`
> Version under revision: 2.1-additions, revision 1, 2026-11-03, DRAFT — NOT APPROVED
> Governing inputs (all must be read before revising; do not revise from Request 2/3 alone):
> - Team Work backend design requirements v2 (2026-11-02): Categories, Projects, members, tasks, progress, PR mirror, S3 resources, Dashboard, CRUD, archive/delete, revoked-cache grey rule
> - Design Request 2/3: Team Work backend design request v2 (2026-11-03): comments, identity-consistent member cascade, Project Context API, import, conversion
> - Design Request 3/3: Vegent Project refactor — Project Context (2026-11-03, as revised: no migration, "Project Context" restored): unified local / Team Project model, Context field list, import, conversion
> - Frontend requirements (requirements-only, 2026-11-03): outcomes and acceptance criteria only; layout prescriptions in earlier frontend documents are withdrawn and must NOT be used to define backend interfaces
> - Owner review of v2-additions revision 1 (2026-11-03) and owner decisions in Section 2 below, which supersede the corresponding parts of revision 1
>
> Task: **Revise the v2-additions design into a complete, implementable revision (v2-additions, revision 2), incorporating every requirement in this document. Deliver the revised design document only, then STOP. Do NOT implement, migrate, seed, package, create AWS resources, commit, or push on the basis of this document.**
>
> Send this entire document to the designer as the instruction. Do not shorten it, because the Context definition, the three-level hierarchy, the progress definition, the frozen mention contract, the warn-only content policy, the limit rules, and the Dashboard / archive / delete APIs are part of the instruction.

## 1. What "complete revision" means

Revision 1 is a serious, honest draft, but it is not implementable as written, for three structural reasons that this revision must fix:

1. **It defers its own foundation.** Baseline schema, task states, progress rules, Dashboard aggregates, and archive/delete states are all deferred to B00, while upper-layer contracts (comments, Context, conversion, endpoints) are written as if that foundation were settled. Revision 2 must reconcile the baseline first (Section 3) and then write every dependent contract against the reconciled baseline, with a traceability table showing, for each dependent contract, which baseline field, state, or rule it depends on.
2. **It leaves product definitions open where the owner has now decided.** Progress percent, Context scope, mention grammar, content blocking, limits, and Dashboard/archive/delete were left as open questions or pilot proposals in revision 1. Sections 4–11 below decide them. Revision 2 must implement those decisions, not re-open them as new open questions, and must list as open only what is genuinely still undecided (Section 14).
3. **It contains "base integration contract" placeholders where a real API is required.** Dashboard, Project list, Project creation, and resource download cannot remain placeholders, or the frontend design will deviate from the backend. Revision 2 must freeze those APIs with the same precision as the comment APIs (Section 10).

Retain what revision 1 got right, unless a section below explicitly changes it: atomic Team-removal cascade in one MySQL transaction, epoch-bound Project membership (a Team rejoin does not resurrect an old Project grant), read-time identity joins on every projection (no roster copy, no cached grant, no JWT-role shortcut), orphan / read-only ownership state with explicit transfer (no silent auto-assign, no silent auto-delete), comment revisions with soft-delete tombstones, and all-or-nothing conversion publication (a failed or missing selected resource creates no visible Project). If revision 2 changes any of those, it must state the change, the reason, and the owner approval it needs.

## 2. Owner decisions in this revision — these supersede revision 1

The following six decisions were given by the owner after reviewing revision 1. They are decisions, not proposals, and revision 2 must follow them:

1. **Context is complete Project information.** Project Context is everything shared about a Project: background and goals, task composition (including SubProjects, Section 5), progress, members, PR mirror metadata, resource metadata, decisions, comments, and open questions. The only exception is file bytes, which live in S3 because they are large; every other shared item lives in the database. Revision 1's rule "comments are excluded from default Context and cannot be inlined" is **withdrawn**.
2. **Three-level hierarchy with inherited membership.** The system supports Category → Project → SubProject, at most three levels. A SubProject's Team Members are exactly its parent Project's Team Members; there is no separate SubProject member management, no separate SubProject member list, and no distinction to maintain. SubProjects must be supported as independent Projects for Context and PR review (Section 5).
3. **Mention technical contract must be frozen.** The @-mention mechanism is a development-level technical contract, not a UX preference. Revision 2 must freeze it exactly — wire format, parsing, storage, validation, rendering contract, and error behaviour — so that an accurate frontend development request can be written from it without further backend clarification (Section 7).
4. **Comments are never rejected for content.** A comment must never be rejected because of what it contains. If a possible secret is detected, the system warns the author and suggests deletion, but it must not block, drop, or lose the comment the user wanted to post. Any comment content is supported, including code, diffs, and pasted discussion (Section 8).
5. **No arbitrary resource or Context limits.** Resource upload goes directly to S3; its limit is what S3 and the network can support for a single file, not an invented product limit. Project Context has no size limit: progress, tasks, comments, and other Context fields are short text and do not occupy significant bytes. Hard product limits that reject legitimate use (for example, a 2 MiB file cap or a 256 KiB Context cap) are **withdrawn** (Section 9).
6. **Dashboard, archive, and delete are mandatory, fully designed APIs.** They are not "base integration contracts" to be filled in later. Revision 2 must design their state machines, permissions, effects, and endpoints with the same precision as the comment APIs, or the frontend will be designed against a wrong assumption (Sections 10–11).

In addition, the owner has decided the progress question from the previous review (Section 6): because no clear, reliable percent formula was supplied, **progress percent is removed** and replaced by a member-updated qualitative progress description plus factual task counts. Revision 2 must not reintroduce a percent, a derived percent, or a percent-equivalent score under another name.

## 3. Baseline reconciliation (B00) — do this first, in the revised design

Before writing any dependent contract, revision 2 must contain a baseline reconciliation section that:

- Lists every baseline table, field, state enum, and rule that revision 1 assumed or deferred: `categories`, `projects`, `project_members`, `project_tasks` (including SubProjects, Section 5), `project_prs`, `project_resources`, Dashboard aggregates, archive/delete states, task status transitions, and the exact task-state mapping that revision 1 deferred.
- For each item, states: the source document and section it comes from (backend v2, Request 2/3, or Request 3/3), the physical name and type as reconciled, and any conflict between revision 1's proposed contract and the baseline — with the owner's resolution, not a silent fix.
- States the authoritative source tree unambiguously. Revision 1 inspected identity code under `/Users/weizhang/Desktop/VegentSupport/identity-development/` while the candidate ZIP lives under `/Users/weizhang/Desktop/VegentUpstream/Lambda/`. Revision 2 must name one authoritative implementation tree for Team Work work, explain the relationship between the two paths, and must not write implementation instructions against two trees as if they were interchangeable.
- States what is still genuinely unknown after reconciliation, with a named resolver and what implementation work it blocks. A dependent contract whose baseline input is still unknown must be marked "blocked on B00 item X", not written as if settled.

No migration file may be authored in revision 2 until its baseline input is reconciled. The migration plan may list future files and their logical order, but it must not present a down_revision, a table definition, or a backfill rule that depends on an unreconciled baseline as if it were verified.

## 4. Project Context — complete, by definition

### 4.1 Definition (owner-decided)

Project Context is **all shared information about a Project**, structured, versioned, and importable. It is not a prompt context, not a summary, and not a "work state only" subset. It includes, at minimum:

- Project identity and structure: name, Category (or null), parent Project (for a SubProject, Section 5, or null), creator, creation time, status, and archive/orphan state.
- Background and task goals (full text).
- Task composition: tasks and SubProjects (Section 5), with title, description, status, assignee (name and current membership status), and updated time.
- Progress: qualitative status, qualitative note, and task counts (Section 6). No percent.
- Members: current eligible members (name, email, Project role creator/member, joined time, added-by) for display only. Membership itself is governed by identity and Project membership tables, not by Context text, and member labels in Context grant no authority.
- PR mirror metadata: title, validated URL, branch, status, reviewers, synced time. PR content itself lives in GitHub/Stash, not in Context.
- Resource metadata: name, type, size, version, uploader, updated time, and a backend-mediated download reference (resource id and version, never a bucket name, S3 key, or presigned URL in Context). File bytes live in S3 only (Section 9).
- Decisions: title, context, decision, status, decided time, and author, where the baseline provides a decision model; otherwise the designer must state explicitly that decisions are represented as comments or tasks, and why.
- Comments: comments are part of Context (Section 2, decision 1). Revision 2 must define exactly how comments appear in Context: by default, the Context payload must include either (a) the full comment list for the Project, paginated, or (b) a complete comment summary (count, latest comments, and a pointer to the full comment API) — the designer must pick one, state it, and justify it on completeness grounds. "Comments are excluded and cannot be inlined" is not an available option. Deleted comments appear only as tombstones in Context, never with original content.
- Open questions: open questions are part of Context. If the baseline has no dedicated open-question entity, the designer must state how an open question is represented (as a task in a defined status, as a comment with a defined tag/type, or as a dedicated field) and must not leave it to be inferred from task or comment text alone. A Project with open questions must be distinguishable, in Context and in Dashboard aggregates, from a Project with none.

For each Context field, revision 2 must state: field name, type, storage (MySQL table/field, or S3 reference for file bytes only), who can read it, who can write it, and whether it is included on import and on conversion. A field with no storage rule or no permission rule is not a complete Context field.

### 4.2 Explicitly NOT in Context

Session transcripts, chat history, tool calls and tool outputs, code diffs, execution logs, Personal Agent memory (user-level, across Projects), secrets, tokens, passwords, `.env`, local credentials, any other member's private local data, file bytes themselves, and any long-lived S3 capability (bucket name, raw key, presigned URL). A resource reference in Context is a logical id plus a backend download path, never a capability.

### 4.3 Context version, pagination, and coherence (revised)

- Context version must be derived from Project content and the current eligible member set (Project id, context revision, eligible member ids and their current display names/emails, current creator identity). It must **not** include the requesting actor's identity, epoch, or token_version: two members looking at the same Project content must be able to compare versions, and a profile change by an unrelated actor must not be conflated with a Project change. If a profile change does affect a member's display name in Context, the version change must be attributable to that member's display data, not to the requester.
- Pagination is a transport mechanism, not a product limit. Context may be fetched in pages (cursor, section, limit), but there is **no hard Context size limit and no `CONTEXT_EXPORT_LIMIT` rejection** (Section 9). A large Project must be fetchable in full by paging through it; a single page may be bounded for transport, but the total must not be rejected. If a page's version changes mid-fetch, the server returns a version-mismatch error and the client restarts from the first page; the design must state the retry behaviour and must not leave a client in a livelock loop without a stated backoff or a snapshot alternative.
- Context reads use a coherent snapshot (revision 1's REPEATABLE READ projection is retained, unless the designer justifies a change), with authorization checked before any data is returned, and with no domain write or audit row for a read.

## 5. Hierarchy — Category / Project / SubProject, at most three levels

### 5.1 Why SubProjects exist (owner-stated use case)

In daily development, a Ticket is often too large to be one unit of work. It is split into multiple SubTickets, and each SubTicket can become an independent Project that Team Members need to understand — its own background, tasks, PRs, and discussion — in order to review its PRs. The system must support that directly, not force users to flatten SubTickets into tasks or into unrelated top-level Projects.

### 5.2 Rules (mandatory)

- **Maximum three levels, no more:** Level 1 Category → Level 2 Project → Level 3 SubProject. A SubProject cannot have a SubProject. A Category cannot contain a SubProject directly (a SubProject always has a parent Project). A Project with no Category (standalone Project) may still have SubProjects.
- **SubProject is a Project for Context and PR review:** A SubProject has its own name, background and goals, task composition, progress (qualitative, Section 6), PR mirror list, resources, comments, and Context payload, independent of its parent Project's. It can be opened, listed, imported, and converted independently (see below). Its Context is its own; it does not automatically inherit or duplicate its parent Project's tasks, PRs, resources, or comments, except where the designer explicitly defines a shared field and states it.
- **Membership is inherited, exactly, with no separate management:** A SubProject's Team Members are exactly its parent Project's Team Members, at all times. There is no SubProject member add, remove, re-add, or member list API. There is no SubProject member count distinct from the parent Project's member count. If a user is added to the parent Project, they are a member of all its SubProjects; if they are removed from the parent Project (or from the Team, with cascade), they lose access to all its SubProjects at the same time, under the same cascade and the same revoked-cache rules. The design must state how this inheritance is implemented — by query-time join to the parent Project's membership, by a derived membership row, or by another mechanism — and must prove, in its acceptance plan, that a SubProject cannot drift from its parent's membership.
- **Creation and management:** Any Project member may create a SubProject under a Project they are a member of (the same creation rule as for Projects, unless the designer justifies a creator-only rule for SubProjects with a reason and an owner approval). Only the parent Project's creator may manage the parent Project's members; SubProject creation does not confer member-management authority. The parent Project's creator is the SubProject's creator for display and for ownership purposes, unless the designer defines a SubProject creator field (the creating member) with a stated reason and a stated effect on permissions — in either case, SubProject member management remains inherited, never separate.
- **Listing and grouping:** SubProjects are listed grouped under their parent Project, which is grouped under its Category (or under "No Category" for a standalone Project). The design must define the list payload for a parent Project with SubProjects (parent summary plus SubProject summaries, or parent plus a SubProject list endpoint — pick one and state it) and the sort order within each level, consistent with backend v2 (Category order, then last activity, then creation).
- **Archive, delete, and orphan:** Archiving a parent Project archives its SubProjects (read-only, Section 11) unless the designer justifies independent SubProject archiving with a reason. Deleting a parent Project deletes (soft-deletes, Section 11) its SubProjects with it; a SubProject cannot outlive a deleted parent. An orphaned parent Project (creator lost, Section 11) makes its SubProjects read-only as well. A SubProject may be archived or deleted independently of its parent, by the parent Project's creator, without archiving or deleting the parent.
- **Import and conversion:** A SubProject can be imported into a local session independently, with its own Context, under the same import rules as a Project (Section 12). Converting a parent Project to a Team Project does **not** automatically convert its SubProjects unless they are explicitly selected in the conversion plan; converting a SubProject independently creates a Team SubProject only if its parent is already a Team Project, or creates the parent as part of the conversion — the designer must pick one, state it, and justify it. The design must not allow a Team SubProject to exist without a Team parent Project.

### 5.3 What the designer must freeze for SubProjects

For SubProjects, revision 2 must freeze: table and field definitions (including parent Project foreign key and the no-fourth-level constraint), creation/update/archive/delete endpoints and permissions, Context payload shape (including the parent Project reference), Dashboard aggregates (whether SubProject tasks/PRs count toward the parent Project's aggregates, toward their own aggregates, or both — pick one and state it), and the membership-inheritance implementation with its acceptance tests. A SubProject design that only says "like a Project, but nested" is not complete.

## 6. Progress — qualitative description, no percent (owner-decided)

### 6.1 Removal of percent

Revision 1's `progress.percent` (Section 7.1, "comes from baseline task completion rules") is **removed**. Revision 2 must not include a percent field, a derived percent, a completion rate, a progress score, or any numeric field that collapses Project progress into a single number, in the Context payload, in Dashboard aggregates, in Project summaries, or in any API DTO. If a legacy client or an earlier draft references a percent, revision 2 must state that it is withdrawn and must not be returned.

The reason, recorded here so the designer does not reintroduce it: no clear, reliable percent formula was supplied, and none can be supplied without arbitrary choices that make the number misleading — what counts in the denominator (archived, cancelled, blocked tasks), whether in-progress work counts as partial, how subtasks and SubProjects are weighted, whether a large task counts the same as a one-line task, and whether PR review counts. A single number that hides those choices is false precision. The owner prefers an honest qualitative description updated by Project members over a precise-looking number that is not reliable.

### 6.2 Replacement model (mandatory)

Progress is represented by three separate, non-collapsed pieces:

1. **Qualitative status (member-updated, not derived).** An enum, frozen in revision 2, with at least: `not_started`, `in_progress`, `blocked`, `in_review`, `completed`, `on_hold`. The designer may add a status only with a reason and a transition rule. Status is **not** derived from task counts: task counts may change without changing status, and status may change without task counts changing. Status changes are explicit member actions (below).
2. **Qualitative note (member-written, free text).** A short, human-written description of where the Project stands, for example what is done, what is blocked and why, and what is next. The note is stored with its author, updated time, and version, and its history is preserved (previous notes remain readable as history, or are recorded as progress events — the designer must pick one and state it). The note must not be auto-generated from task counts as if it were a human judgment; if an auto-generated summary is also provided, it must be a separate field, clearly labelled as derived, and must never overwrite the member-written note.
3. **Factual task counts (system-derived, not human-edited).** Counts by task status, derived from the current task list at read time: total, todo, in_progress, blocked, done. Counts are facts, not progress: they are displayed alongside status and note, never collapsed into a percent, never used for sorting or ranking Projects by "progress", and never presented as a progress bar that implies a percent. SubProject task counts are reported per SubProject; whether they also roll up into the parent Project's counts must be stated explicitly (Section 5.3) and must be consistent in Context, Dashboard, and list payloads.

### 6.3 Who updates, when, and with what audit

- **Who:** Any Project member may update qualitative status and note. Rationale: if only the creator may update, progress goes stale whenever the creator is away, which is worse than a member-updated status with history. The creator may correct a status or note, with the correction recorded as a new version, not as a silent overwrite.
- **How:** Status/note updates require the Project version (If-Match) and an idempotency key, like other mutations. A stale version returns 409 with current status/note, and the user re-applies their change. Every status/note update writes a progress event and an audit row with old status, new status, author, and time. There is no auto-update of status on task change, PR merge, or comment creation, unless the designer justifies a specific auto-transition (for example, all tasks done plus creator confirmation → `completed`) with an owner approval.
- **Archived and orphaned Projects:** An archived Project's status and note are frozen at archive time and are read-only until unarchived. An orphaned Project's status and note are read-only until ownership is transferred (Section 11). A deleted Project's status and note are not returned to members (Section 11).
- **Dashboard use:** Dashboard aggregates may show status distribution (how many Projects are `blocked`, how many are `in_review`, and so on) and task counts, but must not show an average percent, a total percent, or a percent-sorted list. A Dashboard that implies a percent by another name (for example, a progress bar filled to a computed fraction) is not acceptable.

## 7. Comments and @ mentions — frozen technical contract

### 7.1 What comments are (unchanged from revision 1, retained)

Comments are persistent, Project-scoped discussion in MySQL (`project_comments`, `comment_mentions`, `project_comment_revisions`), with structured mentions, flat replies (at most one level, reply-to a root, inheriting the root's task/PR/resource anchor), author-only edits, author-or-creator soft deletes with tombstones, revision history, and a manual "Mentioned me" filter. There is no IM, no notification, no presence, no read receipt, and no channel in this revision. Future IM may reuse stable comment ids, author ids, root/reply references, revisions, and mention relations (revision 1, Section 14.2, retained).

### 7.2 Frozen mention contract — this section is the frontend contract

The designer must freeze the following exactly, with examples, so that a frontend development request can be written from this section alone without further backend clarification. If revision 2 leaves any item below unspecified, it is incomplete.

**User experience (what the user sees and does):**

- Typing `@` in the comment composer opens a member picker listing only current Project members (for a SubProject, its parent Project's members, Section 5), searchable by name and email, with the Project creator highlighted where relevant. Selecting a member inserts a mention. The user never types a wire-format token by hand, and never needs to know the wire format.
- A mention is rendered as a highlighted, clickable chip showing the member's display name (and avatar initials where the frontend provides them), not as plain text. Clicking a chip navigates to that member's Project member entry (or to the Project member list, if no member profile page exists — the designer must state which, and the frontend contract must match it).
- A former member's mention (in an old comment) is rendered as a former-member chip with the original display label preserved, and is not clickable to a current member entry. A former member is never in the picker and never appears in "Mentioned me" results for new comments.

**Wire format (what the client sends and what the server stores):**

- Canonical stored token, frozen: `@[Display Name](user:<positive decimal user id>)`, where `<positive decimal user id>` is the identity user id, and Display Name is 1–100 characters, excluding brackets and newlines. This is the format revision 1 proposed, and it is retained as the canonical storage format because it is unambiguous, parseable, and self-describing. The frontend must generate this token from a picker selection; it must not ask the user to type it.
- Plain `@name` with no `(user:<id>)` suffix is ordinary text with **no** mention semantics, by design. It must not create a mention row, must not appear in "Mentioned me", and must not be converted to a chip on render.
- Escaping: a literal token opener is escaped as `\@[` and remains ordinary text. A malformed token that resembles the canonical grammar (for example, `@[Name](user:abc)`, `@[Name](user:)`, or an unclosed bracket) returns 422 `INVALID_MENTION` for the whole comment creation or edit, with a safe error message that does not echo the malformed input. The design must list the malformed cases it rejects, with examples.
- Client-supplied mentions: the client sends only `content` (with canonical tokens generated by the picker). No separately client-supplied `mentions` array is accepted in this revision, because a separate array can diverge from the text and create a second source of truth. The backend parses tokens from `content`, deduplicates by user id, validates each mentioned user as a current Project member at transaction time, substitutes the current display name into the stored canonical token, and writes one `comment_mentions` row per distinct mentioned user.
- Bounds, frozen (not pilot guesses to be re-approved later, unless the owner changes them): at most 10 distinct mentioned users per comment, at most 20 token occurrences per comment, comment content 1–4,000 Unicode characters (at most 16,384 UTF-8 bytes after LF/NFC normalization), whitespace-only content invalid. If the owner later changes a bound, it is a contract change, not a silent implementation choice.
- Mentions in edits: an existing historical token for a former member may be retained unchanged during an edit, at no greater occurrence count than the immediately prior version. It cannot be newly introduced, copied to another place in the same comment, reintroduced after removal from content, or retargeted to another user. A new mention of a former, removed, non-Team, or other-Project user returns 422 `INVALID_MENTION` for the whole edit.
- Storage: `comment_mentions` rows are structured data (comment id, mentioned user id, mentioned name snapshot, status active/removed, changed version), not only text. A member rename does not break a mention, because the structured row preserves the user id and the snapshot preserves the display label at creation. "Mentioned me" is defined exactly as: list comments in Projects the current user is a member of, where a `comment_mentions` row exists with `mentioned_user_id = current_user_id` and status `active`, excluding deleted comments. Mention filtering by another active user's id is permitted only inside the same visible Project and reveals no other Project.

**Examples (must appear in revision 2, verbatim in substance):**

- Valid: `Please review @[Chen Chang](user:23)` → one mention, user 23, chip "Chen Chang".
- Plain text, no mention: `Please review @Chen Chang` → no mention row, rendered as plain text.
- Escaped, no mention: `Please review \@[Chen Chang](user:23)` → no mention row, rendered as `@[Chen Chang](user:23)` without chip semantics.
- Malformed, rejected: `Please review @[Chen Chang](user:abc)` → 422 `INVALID_MENTION`, whole comment rejected, no partial rows.

**Rendering contract for the frontend:**

- The frontend renders a canonical token as a chip, a former-member token as a former-member chip, plain `@name` as plain text, and an escaped token as plain text without chip semantics. It must not render a token for a user who is not a current or former Project member as a current-member chip. It must not fetch a member profile by parsing a display name; it must use the structured user id from the comment DTO's `mentions` array.

### 7.3 Comment display, replies, edits, deletes (retained, with one clarification)

Retain revision 1's rules: newest-first listing with stable keyset pagination, filters by task/PR/resource/author/mentioned/parent combined with AND, author-only edits (creator cannot rewrite another author's words), author-or-creator soft deletes with tombstone (`content:"[deleted]"`, empty mentions, deletion flag), replies retained when a root is deleted, deleted comments excluded from "Mentioned me", and deleted comments cannot be edited or replied to. Clarification required in revision 2: an edited comment must show an "edited" label with edited time in its DTO, even though the revision diff itself is not exposed through a public revision API. A user must be able to tell that a comment was edited and when, without seeing its prior content through a normal API.

## 8. Content policy — warn, never reject, for comments

Revision 1's content-policy rejection (Section 6.1, 422 `CONTENT_NOT_ALLOWED` for credential patterns, script constructs, fenced code/diff blocks, and transcript/tool-output envelopes, with 503 and total loss on validator failure) is **withdrawn for comments** and replaced by the following owner-decided policy:

- **Any comment content is supported.** Code snippets, diff excerpts, pasted discussion, fenced code blocks, and transcript-like text pasted by a user are legitimate PR review and discussion content and must not be rejected. The backend must not reject a comment because it contains code, a diff, a transcript-like passage, or any other information the user chose to post.
- **Secrets are warned, not blocked.** If the backend detects a known secret pattern (for example, a credential/token/password assignment pattern, a private-key block, a credential-bearing URL, or a JWT-like bearer value), it must return a warning in the create/edit response — for example, `warnings: [{type: "possible_secret", message: "This comment appears to contain a credential or token. Consider removing it."}]` — and the comment is still created or edited. The warning must not contain the detected secret text, must not be logged with the secret text, and must not be stored in a way that leaks the secret through a later API. The author may then edit or delete the comment themselves; the system must not delete it automatically.
- **Validator failure must not lose a comment.** If the secret-pattern validator is unavailable, the comment is still created or edited, with a warning of type `validator_unavailable` (or no warning, if the designer justifies that choice), and never a 503 that discards the user's input. A user must never lose a comment they wrote because a validator was down.
- **Scope:** This warn-only policy applies to comment content and to other shared text fields that a user writes as discussion (for example, a progress note, Section 6). It does not change the rule for file resources: a resource file's bytes are not scanned as comment text, and a resource that contains a secret is governed by the resource policy in Section 9 (backend-mediated access, no inlining into Context, no public URL), not by comment rejection. The design must state this scope distinction explicitly, so a reader does not infer that warn-only for comments means secrets are allowed to be published as downloadable resources without any control.
- **No DLP guarantee is claimed.** Pattern matching cannot guarantee detection of every disguised secret, and the design must not claim a complete data-loss-prevention guarantee, must not silently add an external scanner or LLM classifier, and must not present the warning as a security approval. The warning is a helpful nudge to the author, not a security boundary.

## 9. Resources, Context limits, and transport — no arbitrary limits

### 9.1 Resource upload: direct to S3, backend-mediated

Revision 1's bounded backend proxy (2 MiB per file, backend-mediated byte proxy, no presigned URL in Context) is **replaced** for upload by the owner-decided model:

- **Upload is direct to S3, after a backend permission check.** The flow is: (1) the client requests an upload authorization from the backend for a declared resource (Project, resource name, media type, size, SHA256 where known); (2) the backend checks current Project membership and permission, validates the declared resource against the owner-approved media-type policy, and issues a short-lived, single-use, backend-generated presigned upload URL (or presigned POST) scoped to exactly that resource, that Project, and that actor; (3) the client uploads the file bytes directly to S3, without passing through Lambda; (4) the client notifies the backend, which verifies the object's existence, size, and checksum (where S3 provides it) before committing the resource metadata. The backend never receives the file bytes through Lambda, so Lambda payload limits do not cap file size.
- **Limit is S3 and network, not a product number.** The maximum file size is whatever S3 and the network can support for a single object (including multipart upload for large files, which the design must support or explicitly defer with a stated multipart plan). There is **no 2 MiB product limit, no 20-file product limit that rejects a legitimate Project, and no file-count limit that is not justified by S3 or by an owner-approved storage policy**. If the owner later imposes a storage quota, it is an owner-approved policy with a stated number and a stated error, not a pilot guess in the design.
- **Download is likewise backend-mediated, not public.** A download request is authorized by the backend (current Project membership, pinned resource version), and the backend then issues a short-lived presigned download URL (or, for small resources where the designer justifies it, streams through the backend) — the choice must be stated, with the security and size reasoning, but the URL must never be stored in Context, never be long-lived, never be bookmarkable as a permanent link, and never be issued without a current permission check. A download already authorized may finish; a download whose authorization is revoked before it starts is denied.
- **S3 object identity is internal.** Bucket name, raw S3 key, and version id are never returned in Context, in list payloads, or in error messages. Context and list payloads contain only logical resource metadata (id, name, type, size, version, uploader, updated time, and a backend download path by resource id). Existing Team resources cannot be attached to a Project by supplying their S3 key.
- **Staging and cleanup for conversion** (Section 12) follows the same direct-upload model: staged objects are private, immutable, and conditionally created; cleanup is by an approved operator job with a real operator actor, as in revision 1, but with no 2 MiB cap and with multipart support where the design requires it.

### 9.2 Context: no size limit

There is **no Context size limit**. Progress, tasks, comments, and other Context fields are short text and do not occupy significant bytes, and a Project's Context must be fetchable in full regardless of how many tasks, comments, or resources it has. Revision 1's 256 KiB total, 50/100 rows per section as a hard cap, and `CONTEXT_EXPORT_LIMIT` 422 are **withdrawn**. Pagination (Section 4.3) remains as a transport mechanism, with cursor and section parameters, but it must not reject a large Project. If a single field (for example, a background or a comment) exceeds a transport or database bound, the design must state that bound as a database/transport fact with its exact number and its error, not as a product limit invented for the design.

### 9.3 Other bounds: justify or remove

Any other bound proposed in revision 2 (comment length, task count, member count, rate limit, idempotency window, conversion session expiry) must either (a) be justified by a database, S3, Lambda, or network fact with its source, or (b) be listed as an owner-approved policy with a named approver and a stated effect when exceeded. Bounds that were pilot guesses in revision 1 (for example, 30 comments/minute, 120 reads/minute, 5 conversions/hour, 100 Projects/Team, 100 members/Project as a hard activation gate) must not be carried forward as product limits without that justification. A bound that would reject legitimate use — for example, a Team with more than 100 Projects, or a Project with more than 100 members — must be flagged as a blocking decision for the owner, not silently assumed.

## 10. Dashboard API — mandatory, fully designed

Revision 2 must design the Dashboard as a real API, not as a "base integration contract". The Dashboard is what the frontend's multi-Project view is built from; if it is vague, the frontend will be designed against a wrong assumption.

### 10.1 Endpoints (minimum, frozen)

- `GET /api/teams/{team_id}/dashboard` — Team Dashboard: aggregates over Projects the current user is a member of in that Team, filtered after authorization (never computed over hidden Projects and then filtered).
- `GET /api/teams/{team_id}/projects` — Project list, with filters (Category, status, qualitative progress status, blocked, needs PR review, mentioned me where applicable) and keyset pagination, returning only visible Projects and their SubProject summaries where applicable (Section 5.3).
- `GET /api/teams/{team_id}/projects/{project_id}` — Project detail, including background/goals, task counts, qualitative progress status and note, member count, open PR count, resource count, comment count, last activity, and SubProject list.
- `GET /api/teams/{team_id}/projects/{project_id}/dashboard` — Project Dashboard detail, if the designer distinguishes it from Project detail; otherwise the designer must state that Project detail *is* the Project Dashboard and must not invent a second, overlapping endpoint.

For each endpoint, revision 2 must freeze: permission (T then P per item, Section 3 predicates), query parameters and their validation, response DTO with every field and its type, sort order, pagination (cursor, limit, has_more), error codes (401, 403 Team, 404 Project, 422 validation, 429 rate, 503 unavailable), and the visibility rule (a nonmember receives 404 for a Project and no aggregate that reveals its existence, its count, or its members).

### 10.2 Aggregates (minimum, frozen)

Team Dashboard aggregates must include, at minimum, each computed only over visible Projects:

- Project counts: total visible Projects, by Category (including No Category), by qualitative progress status (not_started, in_progress, blocked, in_review, completed, on_hold), and by archived vs. active (Section 11).
- Task counts: total tasks, by status (todo, in_progress, blocked, done), and blocked task count, with SubProject tasks counted per the roll-up rule in Section 5.3 (stated, not assumed).
- PR counts: open PRs, open PRs where the current user is a reviewer (where reviewer data exists), and PRs by status (open, merged, closed) where the baseline provides it.
- Comment and mention counts: total comments, comments mentioning the current user (unread vs. read is *not* promised in this revision — if the designer proposes a read/unread model, it must be a separate, owner-approved addition, not an implied field), and latest comment time per Project where useful.
- Activity: last activity time per Project, and a Team-level recent activity list (latest progress events and latest comments, with Project, actor, type, and time, paginated), with no activity from hidden Projects.

No aggregate may include a percent, an average percent, or a percent-sorted list (Section 6). No aggregate may reveal a hidden Project's existence, title, member count, or activity. Team-level 403 suppresses the whole Team Dashboard (no partial aggregates, no zero-count success that implies the Team has no Projects).

### 10.3 Dashboard and Context consistency

Dashboard aggregates, Project list payloads, Project detail payloads, and Context payloads must agree on the same numbers for the same Project at the same version: task counts, PR counts, member counts, qualitative status, and last activity must not differ between endpoints for the same Project unless the design states a caching or snapshot reason and its invalidation rule. A Dashboard that shows different task counts from the Project detail for the same Project is a design failure, not a rounding difference.

## 11. Archive, delete, and orphan — state machine, fully designed

### 11.1 States (frozen)

Project states, frozen in revision 2: `active`, `archived`, `deleted` (soft-deleted, invisible to members, references retained), and `orphaned` as an ownership state orthogonal to active/archived (a Project can be active-and-orphaned or archived-and-orphaned; its ownership_state is `unassigned` with `ownership_lost_at` set). The designer must define the state enum exactly, including whether `deleted` is a status or a separate flag, and must not invent a fourth lifecycle state without a reason and an owner approval.

### 11.2 Archive

- **Who:** Project creator, or System Admin for any Project in any Team where the designer justifies System Admin archive authority (otherwise creator only — pick one and state it; do not leave it ambiguous).
- **Effect:** Archived Project content (background, tasks, PRs, resources, comments, Context) remains readable to current Project members. No new tasks, no new comments, no new PR sync, no new resource uploads, and no member changes are allowed while archived, except unarchive. Qualitative status and note are frozen at archive time (Section 6.3). SubProjects are archived with their parent (Section 5.2), unless independent SubProject archiving is defined.
- **Unarchive:** Creator (or System Admin, if archive authority above includes it) may unarchive, restoring the Project to `active` with its prior status, note, tasks, and members intact. Unarchive requires the Project version and writes an audit row and a progress event.
- **Endpoints:** `POST /api/teams/{team_id}/projects/{project_id}/archive` and `POST /api/teams/{team_id}/projects/{project_id}/unarchive`, with Project version, idempotency key, and audit. Archiving an already-archived Project is a no-op returning current state, not an error that implies a state change; archiving a deleted Project returns 404 under the visibility rule.

### 11.3 Delete

- **Who:** Project creator, or System Admin, with the same authority rule as archive (stated, not assumed).
- **Effect:** Delete is **soft delete only** in this revision. A deleted Project is invisible to members (404 under the visibility rule, with the revoked-cache rule applying only to previously cached Projects — a never-fetched deleted Project is never revealed), its tasks, PRs, resources, and comments are not returned in list, Dashboard, or Context payloads, and its S3 objects are **not** deleted (retained, with their metadata retained, until a retention decision under Section 14). There is **no hard-delete endpoint** in this revision. A hard delete, if ever needed, is a separate, owner-approved operator operation with its own retention and audit rules, not a frontend action.
- **Confirmation and audit:** Delete requires the Project version, an idempotency key, and an explicit confirmation (the API design must state what confirmation the client must send — for example, a `confirm: true` field or a name-match field — so a frontend cannot delete by accident on a single click). Delete writes an audit row with actor, time, reason (where supplied), and affected SubProject count. Delete does not delete audit rows, comment revisions, or progress history.
- **Reversibility:** A soft-deleted Project may be restored only by an approved operator operation in this revision, not by a member endpoint, unless the designer justifies a member restore endpoint with a reason and an owner approval. The design must state which, and must not leave restore as an implied capability.
- **Endpoints:** `DELETE /api/teams/{team_id}/projects/{project_id}` (soft delete, 204 on success, with the visibility and version rules above). Deleting an already-deleted Project returns 404 under the visibility rule, not a success that implies it was just deleted.

### 11.4 Orphan (creator lost)

Retain revision 1's orphan model, with the following clarifications required in revision 2:

- When a creator is removed from the Team (cascade, Section 12) or becomes ineligible (identity deactivation), the Project's `ownership_state` becomes `unassigned` with `ownership_lost_at` set, its historical creator id/name are retained, and the Project becomes read-only for remaining members: reads allowed, writes (tasks, comments, member changes, status/note updates, archive/unarchive, delete) return 409 `OWNERSHIP_REQUIRED`, except explicit ownership transfer.
- Transfer: for an assigned Project, only the current creator may transfer; for an orphaned Project, a current Project member who is also an identity Team Admin may transfer to another current Project member. No nonmember, including a global System Admin who is not a Project member, may transfer through a Project endpoint (see Section 12 for the operator exception and its approval). Transfer requires the Project version, writes an ownership history event and an audit row with old and new creator ids, and does not enroll the new creator if they were not already a Project member — the target must already be a current Project member.
- If no eligible transfer actor exists (for example, an orphaned Project with zero active members), the Project persists read-only and is recoverable only through the approved operator recovery path (Section 12), with a real operator actor and an explicit incident approval. It is never auto-deleted and never auto-assigned.

## 12. Member cascade, ownership, and System Admin — decisions required

Retain revision 1's cascade and ownership mechanics, subject to the following owner decisions that revision 2 must obtain or record as blocked:

- **I01 (identity integration):** Revision 2 must state, as a separate approval item, whether the owner approves extracting a noncommitting identity removal helper and running the Team + Project cascade in one transaction, with requalification of the identity candidate. If I01 is not approved, revision 2 must define the fallback that still achieves visible consistency — read-time identity joins plus a reviewed reconciliation job — and must state its latency and consistency limits honestly, rather than assuming I01.
- **I02 (System Admin and Project access):** Revision 2 must state, as a separate approval item, whether a global System Admin without Team + Project membership may read a Project for support/audit purposes, and if so, through which route (a dedicated, audited inspection route, not a Project endpoint) and with what audit. If I02 is not approved, System Admins have no Project access through Project endpoints, and the design must state how support and audit are performed without it. The design must not silently change identity v1's System Admin visibility rule in either direction.
- **Operator enrolment exception:** Revision 1's operator recovery path may explicitly enroll a target as a Project member if necessary for recovery. Revision 2 must state that this enrolment is an exception requiring owner-approved incident approval, a real operator actor, and an audit row, and that it does not create a general rule that an operator or an admin may enroll anyone into any Project. If the owner does not approve this exception, the operator path may transfer only to an already-eligible Project member, and a zero-member orphan remains read-only until an eligible member is created through normal Team/Project membership flows.
- **Cascade scope and failure:** Cascade includes active and archived Projects in the Team, excludes permanently purged objects, and rolls back the entire identity + Project operation if any cascade write fails (no partial Team removal with a success response). Task consequences are as in revision 1, P02: retain historical assignee id/name, flag `assignee_membership_status='former_member'` and `requires_reassignment=true` on unfinished tasks, no silent reassignment, removed assignee cannot update. Comment and mention consequences are as in revision 1, P03/P05: history preserved, former-member chip, no new activity by the removed person, no picker/feed access.
- **Project-only removal:** Creator-only, scoped Project membership id, creator cannot remove their own creator membership without first transferring, re-add creates a new membership row bound to the current identity membership id (never reactivates a historical row, never auto-restores on Team rejoin).

## 13. Import and conversion — retained, with SubProject and Context updates

Retain revision 1's import and conversion models, with the following updates required by Sections 4, 5, and 9:

- **Import (read-only Context import):** A Project or SubProject Context import is a historical local snapshot, not a sync promise. The client fetches the full Context (including comments per Section 4.1, paginated without a hard size limit), assembles it under one Context version, commits it locally, and then records a cloud-audited import receipt (actor-bound random UUID, Context version, no local path, session id, or device identity). There is no background or automatic two-way sync, no transcript synchronization, and no automatic progress/task/comment upload. Explicit user actions against ordinary Task/Progress/Comment APIs after import remain possible only while the user is a current Project member and the baseline driver/assignee/creator policy allows them, with version and idempotency checks — those actions are independent authenticated actions, not an import-sync promise, and the design and the frontend contract must label them as such.
- **Conversion (linked copy, all-or-nothing):** Converting a personal Project (or, independently, a SubProject under the rules in Section 5.2) creates a distinct Team Project (or Team SubProject) and preserves the original personal Project and its local execution/session data as a linked copy. The conversion plan contains only the strict shared DTO (name, background, goals, task drafts, initial member user ids, selected resource descriptors), with no session, chat, code, diff, tool result, arbitrary metadata, or unselected file. Every selected resource must be uploaded directly to S3 (Section 9.1) and verified before publication; a missing or failed selected resource prevents publication with no visible Project and no silently omitted resource. The user may abandon the session and start a revised plan without that resource, as a new conversion id, not as a silent retry mutation.
- **Local ownership trust boundary:** The backend can enforce Team creation authority and plan DTO policy, but cannot independently prove that an offline personal Project belonged to the converter. Revision 2 must state this trust boundary explicitly (revision 1, O08, retained) and must not invent a new identity endpoint, key, or claim to solve it. If server-attested local ownership is required, it is a separate, owner-approved local-export attestation revision, not part of this design.
- **Conversion of a Project with SubProjects:** The designer must freeze whether converting a parent Project converts its SubProjects, and if so, whether SubProjects are converted automatically, only if explicitly selected, or never (Section 5.2). The design must not allow a Team SubProject without a Team parent.

## 14. API checklist, open questions, and delivery

### 14.1 API checklist (minimum, all frozen in revision 2)

In addition to revision 1's E01–E20, revision 2 must freeze, with the same precision (method, path, permission, input, transaction/audit, success, specific failures, acceptance):

- SubProject CRUD and list: create SubProject under a Project, list SubProjects under a Project, get SubProject detail/Context, update SubProject info, archive/unarchive SubProject, delete (soft) SubProject.
- Dashboard: Team Dashboard, Project list, Project detail/Dashboard (Section 10).
- Archive/unarchive and soft delete for Projects and SubProjects (Section 11).
- Context with comments: Context payload including comments per Section 4.1, with pagination, version, and tombstone rules.
- Comment create/list/get/edit/delete with the frozen mention contract (Section 7) and warn-only policy (Section 8).
- Member list/add/remove/re-add, mention candidate list (via member list, no separate mention endpoint unless justified), ownership transfer, and Team-removal cascade (Section 12).
- Import receipt and conversion session/upload/commit, with direct S3 upload (Section 9.1, Section 13).
- Resource download (backend-mediated, short-lived presigned URL or justified stream, Section 9.1).

For every endpoint, revision 2 must state: permission predicate (T/P/C/A, with SubProject inheritance where applicable), required headers (Idempotency-Key, If-Match version or Context hash, as applicable), request DTO with every field, response DTO with every field, error codes from the frozen vocabulary, and acceptance test ids. An endpoint listed as "base integration contract" without this detail is incomplete.

### 14.2 Open questions remaining (designer must list, not invent)

After Sections 2–13, the following are the only kinds of open questions revision 2 may still list. Each must name a resolver and what is blocked if unresolved:

1. B00 baseline items still unreconciled after Section 3 (list each, with source and blocked dependent contract).
2. I01 identity integration approval (Section 12).
3. I02 System Admin Project access route (Section 12).
4. Operator enrolment exception approval (Section 12).
5. Dashboard aggregate details that depend on baseline PR/task states (Section 10, with the baseline item they depend on).
6. Retention and purge policy for deleted comments, revisions, audits, conversion sessions, and staged S3 objects (revision 1, O13, retained — no hard-delete endpoint is implied by listing this).
7. Storage quota, if the owner later imposes one (Section 9.1 — not a design guess).
8. Any other item where the baseline, the identity implementation, or S3 configuration leaves a value genuinely unknown (for example, exact S3 bucket/prefix/KMS policy, which remains owner-supplied deployment configuration, not a design invention).

Revision 2 must not re-list as open any item decided in Section 2 or Section 6. If the designer disagrees with a decision in Section 2 or Section 6, it must state the disagreement, the reason, and the alternative, and must still deliver the design as decided, with the disagreement flagged for owner review — it must not silently substitute its own decision.

### 14.3 Delivery — revised design only, then STOP

Deliver one revised design document, at `/Users/weizhang/Desktop/VegentUpstream/TeamWork/Design/vegent-teamwork-backend-design-v2-additions.md` (the same authoritative location as revision 1; do not create a second copy elsewhere), with:

- A changelog, revision 1 → revision 2, listing every change made in response to this document, section by section, including every withdrawn rule (comments excluded from Context, percent, 2 MiB / 256 KiB limits, content rejection, Dashboard/archive/delete placeholders) and its replacement.
- A traceability table: each requirement in this document → revised design section → API/DTO/DDL → acceptance test id.
- A frozen API/DTO/DDL contract for every endpoint in Section 14.1, with the SubProject, Dashboard, archive/delete, Context-with-comments, frozen mention, warn-only policy, direct S3, and qualitative progress contracts.
- An acceptance plan mapped to test ids (planned checks, not test code, not executed results), with BLOCKED, not PASS, for any check requiring an unavailable owner AWS, database, or S3 environment.
- A status header: Version 2.1-additions, revision 2, Date, Status: **DRAFT — NOT APPROVED**, and the stop gate below.

After delivering the revised design document, **STOP**. Do not write source code, migrations, tests, seed scripts, or packages. Do not create AWS resources, migrate a pilot database, seed a pilot Team/Project, commit, or push. Owner reviews revision 2, asks for changes if needed, and gives explicit approval — including I01, I02, and any remaining Section 14.2 items — before any implementation is authorized. A design document is not an approval, and approval of identity v1.1 / C03 is not approval of Team Work backend implementation.

**End of optimization requirements. Revise the Team Work backend design to a complete Context, a three-level Category / Project / SubProject hierarchy with inherited membership, qualitative progress with no percent, a frozen mention contract, warn-only comments, direct S3 resources with no arbitrary limits, and fully designed Dashboard, archive, and delete APIs, then stop for owner review.**
