# Design Request 2/3: Team Work Backend + Identity Consistency — Comments, Member Cascade, Project Context API, Import

> To: GPT (Team Work backend designer)
> From: Rudy, owner
> Workspace: `/Users/weizhang/Desktop/VegentUpstream`
> Backend base: `vegent-identity/` (Contract 1.1, local implementation under C02/C03, candidate only, owner acceptance pending) + Team Work backend design requirements v2 (2026-11-02, categories / projects / members / PRs / S3 resources / Dashboard)
> Companion documents (same delivery, design only):
> - Design Request 1/3: Team Work frontend v2 (dashboard, detail page, comments, Local vs. Team)
> - Design Request 3/3: Vegent Project refactor — Project Context, import, conversion
> Task: **Propose the Team Work backend design v2 additions: comments, identity-consistent member management, Project Context API, and import support. Deliver a design document only. Do NOT implement yet.**
>
> Send this entire document to the agent as the instruction. Do not shorten it, because the member-consistency, comment, and shared-vs-not-shared rules are part of the instruction.

## 1. Background — what is already decided, and what is new here

Already decided (identity v1 + Team Work backend v2, do not reopen without a reason):

- Identity service: Lambda + Private API Gateway + RDS MySQL + Secrets Manager, Team-only, invite-only `@verizon.com`, JWT identity-only (60 min access, 30 day refresh, token_version invalidation), System Admin / Team Admin / Team Member, invitations with fixed email and inviter, pending count only for S/A, no SSO, no password-reset email.
- Team Work v2: Category max 2 layers (Category → Project, or standalone Project), any Team member can create Category/Project, only the Project creator manages Project members, Team roster is discoverable by all Team members, Project components = background/goals, tasks, members, creation time, progress, PR mirror list, resources (file bytes in S3, metadata in MySQL), Dashboard, CRUD + archive/delete semantics, revoked-cache grey rule (cached-only, never-fetched never revealed, failed fetch is not revocation).

New in this request (design these, do not assume they already exist):

1. **Comments** as first-class Project data in MySQL, with @ mentions, as the foundation for a future IM feature — but not IM itself.
2. **Identity-consistent member management:** a user deleted from the Team must disappear from the Team roster and must be kicked out of every Project in that Team, consistently, in backend data, in API responses, and in frontend-visible state — with no drifting copy of the roster in Team Work.
3. **Project Context API:** the backend must serve a Project's shared Context (not its session execution content) as a single, well-defined payload that local Vegent can import and that a personal Project can be converted from — see Design Request 3/3 for the Context definition.
4. **Import support:** the backend must support importing a Team Project into a local session scope, and converting a personal Project into a Team Project, without sharing session transcripts or execution content.

## 2. Design principles (mandatory)

1. **Identity is the source of truth for Team membership.** Team Work must never maintain a second, independent copy of the Team roster that can drift from identity. Every Team Work read and write must be checked against active Team membership in the identity tables, per request.
2. **Cloud = control + memory plane only.** Execution stays local. The backend stores Project Context, tasks, progress, PR metadata, resource metadata, and comments — never code, never session transcripts, never tool outputs, never secrets.
3. **History is preserved, never silently overwritten.** Comments, decisions, progress events, and member history are Project history. Removal changes access, not history (with the exceptions stated in Section 3).
4. **No backend change to identity v1 without an owner decision.** If this design needs a new identity endpoint, field, or permission, list it as an open question — do not change `vegent-identity/` identity tables, token rules, or candidate ZIP in this design.
5. **No implementation yet.** Deliver the design document only, then STOP for owner review. No code, migrations, seed scripts, packages, tests, AWS resources, pilot migration/seed, commit, or push.

## 3. Member consistency — Team deletion must cascade to Projects (mandatory)

This section fixes a data-consistency bug that would otherwise appear in the frontend: a user deleted from the Team still appearing in a Project's member list, @ picker, or comment author list as if they were still a member.

### 3.1 Source of truth and read-time defence

- **Single source:** Team membership is defined by `team_members` in identity (active status, Team id, user id). Project membership (`project_members`) is a subset of Team membership: a Project member row is valid only while the corresponding Team membership is active.
- **Read-time filter (defence in depth, mandatory):** every Team Work API response that lists Project members, Team members for discovery, @ mention candidates, comment authors' membership status, or Dashboard member counts must filter by active Team membership at query time, even if a stale `project_members` row still exists. A user removed from the Team must never appear as an active Project member, an @ candidate, or a discoverable Team member in any response, regardless of cascade timing.
- **No duplicated roster table:** the designer must not propose a second `team_roster` table in Team Work that copies identity data. Discovery must query identity's Team roster (or a read view over it, if the designer justifies a view), not a copy. If the designer proposes a materialized cache for performance, it must state its invalidation rule (on Team removal, within the same transaction or by a named job, with a maximum staleness bound) and why the read-time filter still makes it safe.

### 3.2 Cascade on Team removal — what must happen, in order

When a Team Admin (or System Admin) removes a user from a Team (identity v1 Team removal, soft remove, history preserved), the following must happen, as a single, audited operation (or as a transaction + a named, audited follow-up job if a single transaction is not feasible — designer must pick one and justify it, with a failure case):

1. The user's Team membership becomes `removed` in identity (existing behaviour, unchanged).
2. **All active Project memberships for that user in that Team become `removed`**, with `removed_by_user_id` = the Team remover, `removed_at` = removal time, and an audit row per Project (or a single audit row listing all affected Projects — designer must pick one and state it). Project history (tasks assigned to them, progress events, comments, PR reviews) remains, with their name preserved as historical author/assignee where applicable.
3. **Project tasks assigned to them:** the design must state what happens — options to evaluate: (a) tasks become unassigned, with a progress event noting the reassignment need; (b) tasks are reassigned to the Project creator, with an audit note; (c) tasks stay assigned but are flagged "assignee no longer a member" and cannot be updated by that assignee. Designer must pick one primary rule and state it. Tasks must never silently disappear, and a removed assignee must never be able to update a task after removal.
4. **Comments by them:** existing comments remain as Project history, with author name preserved, and — where the design proposes it — a "former member" label in the frontend (backend must provide a membership-status flag per comment author, not just a name string, so the frontend can render it correctly). New comments by them are rejected (403/404 per the visibility rule).
5. **@ mentions of them:** existing mentions remain as historical text + structured ids, but the mentioned user is no longer an @ candidate and no longer receives a "Mentioned me" listing for new comments. The design must state whether existing mentions in old comments are rendered as plain text, as a former-member chip, or as a removed-user placeholder — pick one.
6. **Project creator removed from Team:** if the removed user is a Project creator, ownership transfer applies (backend v2, Section 5, open question). The design in this request must propose a concrete transfer rule (see Section 6, open questions) and must state what happens if no transfer occurs (for example, Project becomes read-only until a new creator is assigned, never auto-deleted, never auto-transferred to a Team Admin without audit).
7. **Team Work cache invalidation:** the next Project list fetch by that user for that Team must return no Projects in that Team (Team removal suppresses all Team Work resources for that Team, identity v1). The frontend grey rule for Project removal (Section 4.2 of backend v2) applies per-Project; Team removal applies per-Team and must not be confused with it in API responses or UI copy.

### 3.3 Project member management — creator-only, with identity checks

- Add member: Project creator only, target must be an active Team member at add time (checked per request, not from a cached roster). Adding a non-Team member, a removed Team member, or a user from another Team is rejected (422 or 404 per the visibility rule — designer must pick one consistently).
- Remove member: Project creator only, soft remove, history preserved, with the grey-cache consequence for that Project (backend v2, Section 4.2) and with task/comment consequences per Sections 3.2(3)–(5) where applicable.
- Re-add member: creator re-adds, with a new membership row / reactivated row per the D1 uniqueness rule, and with a fresh fetch on the user's next list (not trusted stale cache).
- The design must state, for each member endpoint, the exact identity check (Team active? Project creator? Last-member guard? Ownership transfer?) and the exact error code, so the frontend can render enabled/disabled actions correctly.

## 4. Comments — backend design requirements

### 4.1 Data model (MySQL, not S3, not session transcript)

- `project_comments`: `id`, `project_id`, `task_id` (nullable), `pr_id` (nullable, mirror id), `resource_id` (nullable, metadata id), `parent_comment_id` (nullable, for replies — designer must state whether replies are threaded (nested) or flat with a reply-to reference, with a reason), `author_user_id`, `content` (text, required), `status` (`active` / `edited` / `deleted` — see Section 4.3 for delete semantics), `created_at`, `updated_at`, `edited_at` (nullable).
- `comment_mentions`: `id`, `comment_id`, `mentioned_user_id`, `created_at`. Mentions are structured data, not only `@name` text in content. On comment creation, the backend must parse mentions from content, validate each mentioned user is an active Project member at creation time, and write one row per valid mention. Invalid mentions (non-member, removed member, non-Team member) must be handled per the frontend design v2 rule (rejected vs. plain-text — designer must pick one consistently with Design Request 1/3).
- Content rules: no file bytes in a comment (attachments are Project resources, linked by `resource_id` or by a resource reference in content — designer must pick one). No secret, token, password, or code diff in comment content (designer must state whether this is validated, and what happens on violation — reject, or store with a warning, with a reason).
- Comments are Project information, not session execution content. A comment must never contain a session transcript, tool output, or local file content by default. If a user pastes such content, the design must state that it is their explicit action, not an automatic sync.

### 4.2 API requirements (design must freeze, not implement)

Minimum endpoints (method, path, auth, permission, request/response, error codes, pagination — designer must freeze each):

- Create comment: Project member only, with Project id, optional task/PR/resource link, content, and mentions (parsed by backend, returned as structured mentions). Idempotency key required (same rule as other mutations).
- List comments: Project member only, paginated by creation time (designer must pick newest-first vs. oldest-first as the default, matching frontend v2), filterable by task_id, pr_id, resource_id, author, and mentioned_user_id ("Mentioned me" = filter by current user id). List must include author name, Project role (creator vs. member), membership-status flag (active vs. former member), mentions (structured), and edited/deleted status.
- Get comment: Project member only.
- Edit comment: author only (or author + Project creator, if the design proposes it — state it), with edited flag and edited time, and with a 409 base-version rule if concurrent edits are possible (designer must state it).
- Delete comment: author or Project creator, soft delete only (status `deleted`, content preserved or replaced with "[deleted]" — designer must pick one, with a reason, and must state whether mentions and replies are affected).
- Reply: create comment with `parent_comment_id`, with the same permission and mention rules as a top-level comment.
- Mention candidates: list Project members for the @ picker (active Project members only, searchable by name, creator highlighted where relevant) — reuse the Project member list, do not create a second mention-candidate API unless justified.

Error codes consistent with identity v1 and backend v2: 401, 403 (not a member), 404 (Project/comment not found, with the visibility rule for non-members), 409 (version / idempotency), 422 (validation, including invalid mention, empty content, non-member mention), 429.

### 4.3 Comments as foundation for future IM — what is and is not promised

- **Promised now:** persistent, queryable, @-mentionable, Project-scoped discussion, with history, author, and attachment to task/PR/resource.
- **Not promised now:** real-time delivery, typing indicators, presence, read receipts, direct messages, channels, or notifications (push/email). If the design mentions notifications, it must label them as a future phase and state what the current design provides instead (for example, a "Mentioned me" filter that the user checks manually, not a push notification).
- **Extensibility seam:** the comment model must be designed so a future IM feature can reuse `project_comments` + `comment_mentions` (for example, by adding a channel/thread type or a delivery status, without changing the comment id or author model). The designer must state the seam explicitly: what a future IM layer would add, and what it would not need to change.

## 5. Project Context API and import — backend support for Design Request 3/3

### 5.1 What Project Context is (backend definition, to be refined by Request 3/3)

Project Context is the shared, Project-level information that can be imported into a local session and converted from a personal Project, **without** session execution content. It includes, at minimum:

- Project background and task goals, Project creation time, Project status, Category (or No Category).
- Task composition (tasks with title, description, status, assignee name — not session transcripts).
- Progress (derived percent, progress summary, last activity time).
- Resource metadata (name, type, size, version, uploader, S3 reference via backend — not file bytes in the Context payload itself, unless the designer justifies a small-text inclusion for design-doc text).
- PR mirror metadata (title, URL, branch, status, reviewers).
- Members (name, email, role in Project — creator vs. member — for display, not for granting local access).
- Comments (optionally, as Project information — designer must state whether comments are included in the Context payload by default, or fetched separately, with a reason).

Project Context **excludes**, explicitly: session transcripts, chat history, tool calls and tool outputs, code diffs, local file contents (except via resource references), secrets, tokens, passwords, and any other member's private local data.

### 5.2 Endpoints the design must freeze (not implement)

- **Get Project Context:** `GET` a single Project Context payload for a Project the user is a member of, with the fields in Section 5.1, a version / updated time for cache invalidation, and a permission check (Project member only, 404 for non-members). The payload must be small enough for a local import (designer must state a size bound or a pagination rule for large task/resource lists).
- **Import marker:** an endpoint or a field that records that a user imported a Team Project into their local scope (for example, `POST /projects/{id}/imports` with local project identifier, or a local-only record — designer must pick one and state whether the import itself is audited in the cloud, and what the local identifier is, without leaking local paths or secrets).
- **Convert personal Project to Team Project:** an endpoint that creates a Team Project from a personal Project Context payload (background, goals, tasks, resource metadata — with local files uploaded to S3 via the backend-mediated path, see backend v2 Section 7.2), with Team, Category, and initial members supplied by the converter (who must be a Team member), and with a clear statement of what is **not** converted (session transcripts, tool outputs, execution content). The design must state who can convert (personal Project owner only), what happens to the original local Project (linked, copied, or replaced — designer must pick one, with a reason), and what happens if a resource file cannot be uploaded (fail the whole conversion, or convert without that resource with a warning — designer must pick one).
- **Sync-back (progress / tasks / comments):** the design must state whether a local session, after import, can push progress, task status, and comments back to the Team Project via the existing Task / Progress / Comment endpoints, or whether sync-back is a separate, named follow-up. If sync-back is via existing endpoints, the design must state the permission check (Project member, driver/assignee rules where applicable) and the conflict rule (409 on stale version). If sync-back is deferred, the design must label import as "read-only Context import" in v2, not as two-way sync.

### 5.3 Security and privacy for Context and import

- Context payloads must never contain secrets, tokens, passwords, code, session transcripts, or tool outputs, even if the Project's resources contain them (resources are referenced, not inlined, unless the designer justifies a text inclusion with a redaction rule).
- Import must not grant the importer access to Projects they are not a member of, and must not reveal a Project's existence to a non-member (404 rule, backend v2 Section 4.1).
- Conversion must not share a personal Project's session transcripts or local-only files that the owner did not explicitly select as resources. The design must state the explicit selection step for resources on conversion.

## 6. Open questions, delivery, and stop gate

### 6.1 Open questions (designer must list, not invent)

1. Ownership transfer on creator removal from Team (Section 3.2(6)): primary rule, and read-only-until-transfer vs. auto-assign.
2. Task reassignment on member removal (Section 3.2(3)): unassign vs. reassign to creator vs. flagged-assignee.
3. Comment delete semantics: content preserved vs. "[deleted]" placeholder, and effect on mentions/replies (Section 4.2).
4. Comment attachment model: Project-only vs. Project + task/PR/resource (Section 4.1).
5. Mention of a removed member in an old comment: plain text vs. former-member chip vs. placeholder (Section 3.2(5)).
6. Context payload: comments included by default or fetched separately; size bound / pagination for large Projects (Section 5.1).
7. Import record: cloud-audited vs. local-only (Section 5.2).
8. Conversion: original local Project linked vs. copied vs. replaced; failure handling for a resource upload (Section 5.2).
9. Sync-back: via existing endpoints vs. deferred read-only import (Section 5.2).
10. Notification for @ mentions: none now vs. a future phase (Section 4.3) — and, if none now, how the "Mentioned me" filter is discovered by the user.

Each open question must name who can resolve it (owner, IAM operator, database operator, S3 operator, or a later design revision) and what is blocked if it is unresolved.

### 6.2 Delivery — design only, then STOP

Deliver one design document, in `/Users/weizhang/Desktop/VegentUpstream/` (location confirmed by the designer and stated in the header; do not create a second copy elsewhere), containing: architecture and scope (with changes from backend v2), full DDL for `project_comments` and `comment_mentions` (and any Context-related table/field changes, with a justification for each), frozen API contract for comments, member cascade, Context, import, and conversion (Sections 3–5), frozen permission matrix (including identity checks per endpoint), visibility and revoked-cache rules (including Team removal vs. Project removal), concurrency and idempotency rules, audit rules, test plan mapped to acceptance IDs (without writing test code), open questions (Section 6.1), changelog v2 → v2-additions, and status header **Version, Date, Status: DRAFT — NOT APPROVED**.

After delivering the design document, **STOP**. Do not write code, migrations, seed scripts, packages, or tests. Do not create AWS resources (Lambda, Gateway, RDS, S3 bucket), migrate a pilot database, seed a pilot Team/Project, commit, or push. Owner reviews the design, asks for changes if needed, and gives explicit approval before any implementation is authorized. A design document is not an approval, and approval of identity v1.1 / C03 is not approval of Team Work backend implementation.

**End of backend design request v2. Design comments, identity-consistent member cascade, Project Context API, and import support, then stop for owner review.**
