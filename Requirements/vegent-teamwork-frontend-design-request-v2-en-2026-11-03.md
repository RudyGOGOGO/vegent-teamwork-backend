# Design Request 1/3: Team Work Frontend — Dashboard, Project Detail Page, Comments, Local vs. Team Projects

> To: Work-computer agent (Vegent frontend designer)
> From: Rudy, owner
> Workspace: `/Users/weizhang/Desktop/VegentUpstream`
> Companion documents (same delivery, design only):
> - Design Request 2/3: Team Work backend + identity consistency
> - Design Request 3/3: Vegent Project refactor — Project Context, import, conversion
> - Mock v2: `vegent-teamwork-frontend-mock-v2.html` (visual mock only, not production code, not a design approval)
> Task: **Propose the Team Work frontend design v2, fixing the UI/UX problems in mock v1, and deliver a design document only. Do NOT implement production frontend code yet.**
>
> Send this entire document to the agent as the instruction. Do not shorten it, because the dashboard, detail-page, comment, and local-vs-Team rules are part of the instruction.

## 1. Background — why v1 UI/UX is not good enough

Mock v1 proved the data model (Categories, Projects, tasks, PRs, resources) but its UI is not professional:

- The main screen is a top row of buttons (New Project, New Category, Team Members) plus a stack of cards. It gives the user no dashboard, no sense of where they stand across multiple Projects, and no way to see progress, creation time, and blockers at a glance.
- The Project detail view is the same card stack, just longer. It is not a separate, navigable page with a clear information hierarchy and clear actions.
- There is no in-Project discussion. Members cannot ask a clarification, point at a task or PR, or @ a colleague — so the Project's complete information is missing, and there is no foundation for a future IM feature.
- Local Projects and Team Work Projects look the same, so the user cannot tell at a glance whether a Project is theirs alone or shared, or whether it can be imported into a local session or converted to Team Work.

This v2 design must fix all four, in Vegent's own frontend, as a core feature — not as a plugin, not as a separate app.

## 2. Design principles (inherited, mandatory)

1. **Core, not plugin.** Team Work lives in Vegent's main routing, layout, sidebar, and design system, consuming the same core auth context as login/identity/member management.
2. **Login is optional, local is default.** If the backend is not configured or unreachable, Team Work login and Team Work actions are greyed out and disabled with a reason ("not configured" vs. "unreachable — connect to company network or VPN"), while startup and normal local task execution continue unaffected. A backend check must never block startup, navigation, or a local task.
3. **Backend enforces, frontend reflects.** The frontend may disable a button a user cannot use, but the backend is the security boundary. Every permission-sensitive action must still be checked by the backend.
4. **No backend change in this task.** If this frontend design needs a backend endpoint, field, or permission that backend design v2 does not provide, list it as an open question — do not invent it.
5. **No production code yet.** Deliver the design document only, then STOP for owner review. The mock v2 in this delivery is a visual reference, not a code base to copy blindly.

## 3. Main screen — a real dashboard, not a button row + card stack

The Team Work main screen must be split into distinct, named components. The designer must name each component, state what data it shows, what interaction it offers, and what happens when the backend is unreachable (greyed-out, Section 2, rule 2).

### 3.1 Component A — Overview dashboard strip (top, always visible)

Purpose: in one glance, tell the user where they stand across all their Projects.

Required content (from backend Dashboard / list endpoints — designer must map each number to an endpoint, not invent a calculation):

- Totals: Projects I am a member of, Projects I created, tasks open / done, PRs open needing review, blocked tasks, comments mentioning me (unread count, if the backend provides it — see Design Request 2/3, otherwise list it as an open question).
- Progress distribution: an interactive visualization, not a single number. Minimum: a bar / donut showing tasks by status (todo / in_progress / blocked / done) across all my Projects, and a per-Project progress chart (horizontal bars, one per Project, with percent, created date, and last activity). Clicking a bar or segment must filter the Project list below to that subset (for example, click "blocked" → list shows only Projects with blocked tasks).
- Time view: a timeline axis showing Projects by creation time (and, where available, last activity time), so the user can see which Projects are new, which are stale, and which are active. Hover must show Project name, creator, progress, and last activity; click must open that Project's detail page.

The dashboard must be interactive, not a static image: filter, hover, and click must work, and the numbers must update when the Project list filter changes. A static screenshot of a chart is not a dashboard design.

### 3.2 Component B — View switcher and filters (below the dashboard, above the list)

- **View switcher (mandatory, two modes):**
  - **By Category:** grouped by Category (max 2 levels: Category → Project), Categories in creation order, Projects inside a Category by last activity descending, then creation descending.
  - **By Time:** grouped / sorted by time — for example, a timeline or time-sectioned list (This week / Last week / Earlier, or by creation month — designer must pick one and state it), with creation time and last activity time visible on each row. Standalone Projects (no Category) must appear in the By Time view in time order, not hidden.
- **Filters (minimum):** All / My Projects / Created by me / Blocked / Needs PR review / Mentioned me (comments). Plus a text search by Project name, task title, or member name (designer must state whether search is client-side over the fetched list or server-side, and what happens with a large list).
- **Team selector:** if the user belongs to multiple Teams, the main screen must show which Team is selected and must not mix Projects from different Teams in one view. Switching Teams refetches that Team's data.

### 3.3 Component C — Project list, as an interactive visualization (not a card stack)

Each Project row / item must be a compact, scannable visualization, not a generic card with a paragraph:

- Left: Project name, Category (or "No Category"), creator, creation time.
- Middle: progress visualization — a progress bar with percent, plus a small task-status breakdown (for example, 17 done / 25 total, 2 blocked, with blocked in a warning colour).
- Right: open PR count (with a "needs review" indicator if the user is a reviewer), member count / avatars (initials, not photos unless Vegent already uses them), last activity time, and a status tag (active / archived / blocked).
- Interaction: click row → detail page (Section 4). Hover → preview tooltip with background/goals excerpt, next blocked task, and most recent comment. Right-click / overflow menu → actions by role (edit, manage members, archive — creator only where applicable; otherwise disabled with a reason, not hidden silently where the rule matters).
- **Revoked Project (grey, cached-only):** a Project the creator removed the user from appears grey, disabled, with only cached name/Category and a "No longer accessible" label, and a "Remove from my list" action (local cache only). No fresh tasks, PRs, resources, or comments are shown for it. A Project the user never fetched never appears. A failed fetch must not mark cached Projects as revoked — it must show the unreachable state (Section 2, rule 2).

### 3.4 Component D — Create and Team actions (not a top button row)

- "New Category" and "New Project" must live in a clear, persistent place — for example, a primary action area in the Team Work header or sidebar, with a consistent label and icon — not as three unrelated buttons floating above a card stack. The design must state where they live, what dialog/form each opens, and what validation / duplicate-name / permission errors look like.
- "Team Members" must not be a top-level button competing with Create actions. Team roster belongs in its own section (Team view, from the auth/member design), linked from the Team Work header, with a clear label ("Team: Verizon Family — members"). The main screen's job is Projects and progress, not roster management.
- Empty states: no Projects yet, no Projects in a filter, no Category yet — each with a distinct, helpful empty state and a single next action (create a Project, clear the filter, create a Category), not a blank page.

## 4. Project detail page — a separate page, with a clear hierarchy

The Project detail must be a **separate, navigable page** (its own route, back navigation to the main screen, deep-linkable by Project id), not a longer card stack on the main screen.

### 4.1 Layout (designer must propose one layout and justify it)

Proposed structure (designer may adapt it, but must keep the same information hierarchy and must state the adaptation):

- **Header (fixed):** Project name, Category / No Category, creator, creation time, status, member avatars, progress percent + bar, and primary actions by role (Edit, Manage members, Import to local session, Convert — see Sections 5 and Design Request 3/3).
- **Tabs / sections (minimum):** Overview | Tasks | PRs | Resources | Comments | Members. Each tab must state its data source, its actions by role, and its empty state. Tabs must not duplicate the same data in three places with different numbers.
  - **Overview:** background/goals (full text), progress visualization (task-status chart, progress over time if the backend provides activity history — otherwise list it as an open question), key facts (creation time, creator, member count, PR open count, resource count), and recent activity (latest progress events + latest comments, with links to their tabs).
  - **Tasks:** task list with status, assignee, updated time, filter by status/assignee, create / status-change / archive actions by Project member, with 409 handling for concurrent status changes (show current data, ask to re-apply, never silently overwrite).
  - **PRs:** PR list for review, open first, with title, URL (external, GitHub/Stash), branch, status, reviewers, synced time, and manual Sync action. No Create/Merge/Close PR actions (mirror only).
  - **Resources:** file list (name, type, size, version, uploader, updated time) with download via backend permission check (never a direct S3 URL), upload for members, delete/archive for creator or uploader (per backend v2), and image/figure preview where feasible.
  - **Comments:** see Section 6 — this tab must be a first-class tab, not a footnote at the bottom of Overview.
  - **Members:** member list with creator vs. member distinction, joined time, added-by, and creator-only add/remove actions with the exact consequence copy (removed member loses Project access on next fetch, keeps local access, history remains, rejoin only by creator re-adding).

### 4.2 Operations must be intuitive, not buried

- Every action must be reachable in at most two clicks from the detail page, with its permission state visible (enabled, or disabled with a reason — for example, "Only the Project creator can manage members").
- Editing Project info, tasks, and progress must show a base-version conflict path (409 → show current data, ask to re-apply), not a silent overwrite and not a generic error.
- Navigation must be consistent: back to main screen preserves the previous filter/view (By Category vs. By Time, and the selected Team), so the user does not lose their place.

## 5. Local vs. Team Work Projects — effective visual distinction (mandatory)

This is a core UX requirement, not a badge detail. The user must be able to tell, at a glance, in the sidebar, in the list, and on the detail page, whether a Project is:

- **Local Project (personal):** a collection of the user's own sessions, with Project Context (see Design Request 3/3), owned by the user alone, not shared, not visible to any Team. Visual treatment: a "Local" badge, a personal icon, and a clear note that it is not shared. Actions offered: open local sessions, edit Project Context, and — if the user chooses — **Convert to Team Work Project** (see Design Request 3/3 for what is shared and what is not).
- **Team Work Project (shared):** a Project in a Team, with Team members, shared Project Context, tasks, PRs, resources, and comments. Visual treatment: a "Team · {Team name}" badge, Team icon, member avatars, and a clear note that it is shared with the listed members. Actions offered: **Import to local session** (see Section 5.1), open Team Dashboard, manage members (creator only).

The two types must never be mixed in one list without a badge and a filter. A filter "Local / Team / All" is required on the main screen (and, where applicable, in the sidebar).

### 5.1 Import to local session (UI requirement — backend and Project refactor in Requests 2/3 and 3/3)

- On a Team Work Project detail page, a primary action "Import to local session" (or "Open in my local Vegent" — designer must pick one label and use it consistently) must be offered to any Project member.
- Import must create (or link to) a local Project / local session scope with the Team Project's **Project Context** (background, goals, tasks, progress, resource metadata — see Design Request 3/3 for the exact shared set), so the user can immediately start work: write code, review a PR, or continue a task, in their local Vegent.
- Import must **not** import other members' session transcripts, tool outputs, or execution content. The UI copy must state this clearly on the import confirmation, so the user does not expect to see another member's chat history.
- After import, the local Project must show its Team origin (Team name, Team Project name, and a link back to the Team Project Dashboard), and must offer a "Sync progress / tasks / comments to Team Project" action (for members, when reachable) — or, if sync is not in scope for this design, the design must list it as a separate, named follow-up, not as an implied feature.
- If the user is removed from the Team Project after import, the local Project and its local sessions remain usable locally, but Team sync and Team Dashboard access become grey / unavailable (Section 2, rule 2, and the grey rule in Section 3.3).

### 5.2 Convert personal Project to Team Work Project (UI requirement)

- On a Local Project detail page, an action "Convert to Team Work Project" must be offered to the owner, opening a dialog: select Team, select Category (or No Category), select initial members from the Team roster, and confirm what will be shared (Project Context only — background, goals, tasks, progress, resource metadata — with local files uploaded to S3 via the backend, see Design Request 3/3) and what will **not** be shared (session transcripts, tool outputs, execution content, local-only file contents that are not uploaded as resources).
- After conversion, the Project must appear in Team Work with a Team badge, and the local Project must show its Team origin (or become the linked local copy — designer must pick one model and state it, with a reason).

## 6. Comments — in-Project discussion, as a foundation for future IM

Although Team Work v2 does **not** support IM (instant messaging), members must be able to discuss a Project in the Project itself, and comments must be treated as complete Project information, not as an afterthought.

### 6.1 What a comment is

- A comment belongs to a Project, and optionally to a specific task, PR, or resource (designer must state the attachment model: Project-level only, or Project + task/PR/resource-level, with a reason).
- A comment has: author, content (text, with Markdown or rich-text only if Vegent already supports it — do not invent a new editor), creation time, edited time (if editing is allowed — designer must state whether editing is allowed, by whom, and whether edit history is shown), parent comment (for replies — designer must state whether replies are threaded or flat, with a reason), and mentions (see Section 6.2).
- Comments are stored in the database (MySQL, see Design Request 2/3), not in S3, not in a session transcript, and not in a local file. A comment's file attachment, if any, is a Project resource, not part of the comment body.

### 6.2 @ mentions — intuitive, clear, and filterable

- Typing `@` in the comment composer must open a member picker (Project members only, searchable by name, with the creator highlighted where relevant). Selecting a member inserts a mention that is rendered as a highlighted, clickable chip (name + avatar initials), not as plain text.
- A mentioned member must be able to find mentions of themselves: a "Mentioned me" filter in the Comments tab and, where the main screen supports it, a "Mentioned me" filter / count in the dashboard (Section 3.1). Clicking a mention must navigate to that member's profile / roster entry where Vegent already provides one, or to the Project member list — designer must state which, not leave it as a dead link.
- Mentions must be stored as structured data (mentioned user ids), not only as `@name` text, so that a member rename does not break the mention and so that the "Mentioned me" filter remains correct. The design must state this storage rule (backend detail in Design Request 2/3, frontend rendering here).
- A comment that @-mentions a non-member, a removed member, or a non-Team member must be handled explicitly: either the mention is rejected with a clear error, or it is rendered as plain text with a "not a Project member" note — designer must pick one and state it. A mention must never grant access to a non-member.

### 6.3 Comment display — intuitive and clear

- Comments must be displayed chronologically (newest first or oldest first — designer must pick one as the default and state it, with a sort control), with a clear visual hierarchy: author avatar/initials, author name, role in Project (creator vs. member), time, content, mentions highlighted, and — where attached — a link to the task / PR / resource the comment is about.
- Clarification use case must be first-class: a comment asking for clarification on a task or PR must be visibly linked to that task/PR, and the task/PR detail must show its comments (or a comment count with a link to the Comments tab filtered to that item) — so a clarification is not lost in a flat Project comment list.
- Actions by role: any Project member can post a comment; only the author (or the Project creator, if the design proposes it — state it) can edit/delete their own comment, with edit history or a "edited" label where applicable. A removed member cannot post new comments; their existing comments remain with their name (and, where the design proposes it, a "former member" label), because comments are Project history.
- Empty state: a Project with no comments must show a helpful empty state ("No comments yet — ask a clarification, @ a member, or note a decision here") with a single "Write a comment" action, not a blank tab.
- No IM promise: the design must not present comments as real-time chat, typing indicators, presence, or read receipts. If a future IM feature is mentioned, it must be labelled as a future phase that will build on this comment model, not as a current feature.

## 7. Design document — what to deliver, and how it will be judged

Deliver one design document, in `/Users/weizhang/Desktop/VegentUpstream/` (location confirmed by the designer and stated in the header; do not create a second copy elsewhere), containing:

1. Navigation, layout, and component map for the main screen (Section 3) and the detail page (Section 4), with a diagram or a precise component/route map.
2. Dashboard visualization design: what charts, what data, what interactions (filter, hover, click), and what happens when data is missing or the backend is unreachable.
3. View switcher and sorting design: By Category vs. By Time, with the exact sort rules and the empty-state design for each view.
4. Detail-page design: tabs/sections, information hierarchy, actions by role, and navigation (including back-navigation preserving filter/view).
5. Local vs. Team distinction design: badges, filters, sidebar treatment, import and conversion flows (Sections 5.1–5.2), with the exact copy for what is shared and what is not.
6. Comment design: composer with @ picker, display hierarchy, attachment to task/PR/resource, Mentioned-me filter, edit/delete rules, and empty state (Section 6).
7. Permission matrix (frontend reflection): for each screen and action, who sees it, who can use it, and what the backend returns if the frontend check is bypassed. Must match backend design v2 and Design Request 2/3.
8. API usage map: for each screen, the exact backend endpoint(s), request/response fields used, and fields explicitly not used or not shown.
9. Acceptance cases: dashboard at-a-glance, By Category vs. By Time, detail-page navigation, creator-only member management, grey revoked Project, backend-not-configured / unreachable greyed-out actions, local-mode non-blocking, comment @ mention and Mentioned-me filter, import to local session, convert personal to Team — each with steps and expected UI state, without writing production code.
10. Open questions and risks, with evidence and a named resolver. Never invent an answer, a route, a component, or a backend field to fill a gap.
11. Changelog v1 → v2 (what changed from mock v1 and why) and status header: Version, Date, Status: **DRAFT — NOT APPROVED**, and the stop gate from Section 8.

The design will be judged on: (a) the main screen is a dashboard + visualization, not a button row + card stack; (b) the detail page is a separate, navigable page with a clear hierarchy; (c) comments are first-class, with @ mentions and a Mentioned-me filter; (d) Local vs. Team Projects are unmistakably distinguished, with import and conversion flows that state what is shared and what is not; (e) login and Team Work never block local work, and unavailable backend actions are greyed out, not hidden or blocking.

## 8. Delivery, status, and next gate

Deliver the design document only. After delivering it, **STOP**.

Status remains DRAFT — NOT APPROVED. Do not write production frontend code, change routes or state, add components, or change backend code on the basis of this design alone. Do not commit, push, or deploy.

The owner will then do one of the following, and only one of them authorizes the next step:

- Approve the design explicitly, with any changes recorded, and that approval authorizes a separate frontend implementation task (in parallel with the Team Work backend implementation, against a frozen API contract); or
- Return the design for correction, with specific items to fix, in which case revise the design under the same stop rule; or
- Authorize a further narrow design question, named explicitly, to resolve a specific open question.

If any requirement in this document conflicts with backend design v2, Design Request 2/3, Design Request 3/3, Vegent's actual frontend, or the inspected code, do not resolve it silently. List it as an open question, with the frontend path, the backend section, and the code evidence, and stop for owner decision on that item.

**End of frontend design request v2. Design a dashboard-led Team Work frontend, with a separate Project detail page, first-class comments with @ mentions, and a clear Local vs. Team distinction, then stop for owner review.**
