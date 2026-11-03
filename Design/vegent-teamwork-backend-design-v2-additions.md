---
sidebar_position: 1
---

# Vegent Team Work Backend — Complete Project Context and Identity Consistency

**Version:** 2.1-additions, revision 3 (HTTP contract 2.1-r3)  
**Date:** 2026-11-03 (America/New_York)  
**Status:** IMPLEMENTED LOCAL CANDIDATE — feedback remediation; owner-environment gates remain open  
**Review pass:** Implementation feedback audit, 2026-11-03; current corrections in Section20 and Verification/IMPLEMENTATION_FEEDBACK_RESPONSE.md  
**Product decision owner:** Rudy; **requesting owner / deployment operator:** Wei  
**Authoritative document:** `/Users/weizhang/Desktop/VegentUpstream/TeamWork/Design/vegent-teamwork-backend-design-v2-additions.md`

The owner explicitly authorized implementation and testing on 2026-11-03 without intermediate approval questions. AWS/account/network/bucket/database-instance provisioning remains owner-managed. The historical design-review gates below describe the review baseline; this approval supersedes the design-only stop for service development, isolated testing and candidate packaging. No production migration, seed or deployment is performed by this task. Approval of identity 1.1/C03 is not Team Work approval. Revision 2 supersedes revision 1 in place; no second design copy is delivered.

Project Context is the complete shared Project record, not Personal Agent memory or a prompt summary. A personal preference such as “Rudy prefers concise summaries” stays in personal memory. A Project record such as “background=delegation pilot, tasks=review/API/testing, progress=in_review with a member-written note” is Context. Sessions execute locally; there is no automatic transcript/tool/private-memory synchronization. User-posted discussion is retained under the owner's warn-only rule (§7), with the explicit exclusion conflict recorded in Q-CONTENT rather than a false DLP guarantee.

## 1. Governing evidence and precedence

### 1.1 Inputs read

Request originals are stored byte-for-byte in `/Users/weizhang/Desktop/VegentUpstream/TeamWork/Requirements/`; request filenames in the table are relative to that directory. Read `TeamWork/README.md` first for the delivery map. The design remains the single authoritative contract in Design/.

| Source | Read / authority |
| --- | --- |
| `vegent-teamwork-backend-design-optimization-requirements-en-2026-11-03.md` | All sections; SHA256 `5688da7ca0d2e3f8780aaa0ef1b17a12a895de4245f8b703bec4b1c4bc0d4266`. Abbreviated **O** below; latest owner decisions override older conflicts. |
| `vegent-teamwork-backend-design-request-v2-en-2026-11-03.md` | Entire Request2/3; SHA256 `bba6ad4a8e618714e1d59048868029eb038f1710459ff98f8b020b5bdea46fae`. Abbreviated **B**. |
| `vegent-project-context-refactor-design-request-en-2026-11-03.md` | Entire Request3/3, including restored Context terminology and §5 no-data-migration rule; SHA256 `91185887d58adcd31789c1e88d19d32d1ab5353af535604aa545085892b64835`. Abbreviated **C**. Local-code inventory/refactoring is the separate core task, not claimed completed here. |
| `vegent-teamwork-frontend-design-request-v2-en-2026-11-03.md` | Entire supplied Request1/3; SHA256 `60adbfe0054e1638ba8c2713a1dbdb3b41e5326d15589175d8d1f977c171b4b3`. Abbreviated **F**. This supplied file still contains older layout/percent prescriptions; O explicitly withdraws them. Only outcome/permission/cache/import acceptance needs inform this backend. No UI layout is frozen here. |
| Backend v2 dated2026-11-02 | Not separately supplied. B§1 summarizes it; O now freezes hierarchy, states, progress and mandatory baseline APIs. This document reconciles those into a complete fresh cloud schema, rather than inventing a read of the missing original. Narrow residual comparison/deployment unknowns are listed individually in §15. |
| Actual identity source | `/Users/weizhang/Desktop/VegentSupport/identity-development/`; reviewed User/Team/membership/audit/auth/session/removal contracts. User IDs INT; Team/membership IDs BIGINT; active membership epoch and null-audit-actor restriction retained. No existing Team Work tables/code were verified in that identity source. |
| Preserved identity candidate | `/Users/weizhang/Desktop/VegentUpstream/vegent-auth-backend/Lambda/vegent-identity.zip`, SHA256 `f650db857cf6b234ba8a6c6f43f85ee5674f9fb992da2b3493a394735e9b74d7`. Immutable during design; an output artifact, not another implementation tree. |

**One authoritative future implementation tree:** `/Users/weizhang/Desktop/VegentSupport/identity-development/`. Approved Team Work code would be added there under `app/teamwork/`. The separately organized `vegent-auth-backend/Lambda/` and `vegent-auth-backend/MySQL/` directories contain preserved unqualified identity candidate artifacts only; do not edit extracted packages or create another source tree there. New candidates require a new manifest/requalification and must not overwrite the preserved identity candidate silently.

### 1.2 Conflict resolutions already decided

| Older statement | Owner resolution applied in revision 2 |
| --- | --- |
| B§1/F§3 two-level grouping | O§5: Category → root Project → SubProject; standalone roots may have children; no fourth level. |
| B§5.1/C§3.2/F§3–4 derived percentage | O§6: removed. Six explicit qualitative states, member-written note and factual four-state task counts only. No ratio, score, progress bar value or percentage-sort API. |
| C§3.2 optional comments/decisions/PRs/members | O§4: all are shared Context, including explicit open questions. Comments use the full paginated collection, not an excluded/default-off field. |
| Revision 1 semantic content rejection | O§8: retain code/diff/manual discussion, warn on possible secrets, tolerate warning-validator failure; structural mention/schema bounds still apply. |
| Revision 1 file/count/Context/capacity quotas | O§9: withdrawn. S3 limits and paginated transport facts only; no product cap on total Context, Projects, members, tasks or selected files. |
| Revision 1 Dashboard/archive/delete placeholders | O§10–11: fully specified below, using one shared aggregation implementation. |
| C§5 no local Memory migration | Retained as given. No local-data backfill, alias, dual-write or compatibility migration. Future installation of new cloud tables is schema provisioning, not migration of unused local Memory data. |
| F layout/tab/chart prescriptions | O header: withdrawn as backend constraints. Backend supplies outcomes and technical DTOs, not screen placement. |

## 2. Baseline reconciliation before dependent contracts (B00)

Everything in this section is a **frozen proposed fresh schema/API contract** for owner approval, not a claim that production tables were inspected. Exact installation compatibility/revision is B00-D; no baseline data backfill is assumed. Where the original absent baseline leaves an actual authorization ambiguity, only the dependent contract is marked blocked, not the entire foundation.

### 2.1 Tables, fields, enums and source

Physical types and complete DDL are in §4. All IDs are signed BIGINT except identity User references INT; times DATETIME(6) UTC; entity versions start at1. Name columns VARCHAR(255) are an explicit proposed schema capacity, not a universal MySQL limit; Approval of this design would accept that proposed field choice; no prior acceptance is claimed. Exceeding that stored field gives422 `FIELD_STORAGE_LIMIT`, never a new total-Project/Context limit. Long shared text is LONGTEXT, with transport fragmentation (§9).

| B00 item | Reconciled table / key fields | Exact state/rule | Source and revision 1 resolution |
| --- | --- | --- | --- |
| B00-CAT | `categories(id,team_id,name,created_by_user_id,version,created_at,updated_at,deleted_at)` | One category level; null category=No Category; creation order `(created_at,id)`; no Category parent. Category author soft-deletes the label without testing/revealing hidden Project occupancy; references remain internal and linked roots appear in No Category. Any T creates; category author edits/deletes, never gains Project access. | B§1, F§3.2/3.4 outcomes; O§3/5. Replace provisional `project_categories` name with `categories`. Original Nov2 authority comparison is B00-C, not asserted verified. |
| B00-PROJECT | `projects`, root or child; fields in §4 | lifecycle=`active\|archived\|deleted`; ownership=`assigned\|unassigned`, orthogonal; published_at is a visibility fence, not a fourth lifecycle. | O§5/11; B§1; C§4. Revision 1 missing lifecycle fixed. |
| B00-HIERARCHY | `parent_project_id`, `node_depth`, parent composite FK | root depth0; child depth1 referencing root depth0 in same Team. No child-of-child; category and owner are inherited, not copied into child grant state. | O§5 supersedes two-level assumption. |
| B00-MEMBERS | `project_members` only on roots; identity `team_membership_id` binding | active/removed history, one active grant per root/User; no SubProject grant rows/list/management. | O§5/12, B§3. Exact membership inheritance added. |
| B00-TASK | `project_tasks`, task status independent of lifecycle | `todo\|in_progress\|blocked\|done`; any state→any other state is explicit, versioned, never changes qualitative progress automatically. Archive retains status. | O§6/10, F§4.1 outcomes settle state/count mapping. |
| B00-TASK-AUTH | task creator/driver/assignee identity references | Any P creates; driver defaults creator of task; driver/C edits details/assignment; driver, assignee or C changes status; C deletes; driver/C archives. Targets must have current G. | B§5.2 refers to unspecified driver rules; F§4.1 says member task actions. This precise proposed matrix is **blocked on B00-T** for original-baseline authority confirmation, not left unspecified. Counts/DTO states are not blocked. |
| B00-PROGRESS | `projects.progress_status`, note/author/time; `project_progress_events` | exactly `not_started\|in_progress\|blocked\|in_review\|completed\|on_hold`; any P changes any state/note explicitly; history preserved. | O§6 supersedes all numeric formulas and revision 1 deferral. |
| B00-PRS | `project_prs`, `project_pr_reviewers` | mirror status=`open\|merged\|closed`; external content stays at provider; reviewer IDs nullable when mapping unknown. No external create/merge/close API. | O§4/10, F§4.1. Provider credentials/mapping are B00-PR deployment inputs, not missing count formulas. |
| B00-RESOURCES | `project_resources`, immutable `project_resource_versions`, `resource_uploads` | metadata MySQL; bytes only S3; staged→verified→published via upload protocol; logical archive/delete retains object references. | O§9 replaces2 MiB proxy/20-file restriction. |
| B00-COMMENTS | comments/revisions/mentions | active/edited/deleted, one-level replies, former-member chips; full paginated Context collection; warnings only. | O§4/7/8, B§4. |
| B00-DECISIONS | `project_context_items(kind='decision')` and revisions | proposed/accepted/superseded/withdrawn; typed fields, not inferred text. Author or C edits/status; preserve history. | O§4.1 requires explicit representation; C§3.2 allows typed entries. Selected dedicated typed table avoids coercing decisions into4,000-character comments. |
| B00-QUESTIONS | same table, kind=`open_question` | open/answered/closed; explicit question and answer fields; open count in Context/Dashboard. Author or C edits/status. | O§4.1; not an inferred “?” or task-state alias. |
| B00-DASH | shared projection over visible published nodes | Every node contributes own task/PR/comment facts exactly once; no parent roll-up of child tasks. Team totals sum nodes once, distinguish root and child counts. | O§5.3/10. No hidden Project aggregate or percentage. |
| B00-DELETE | lifecycle deleted with prior status, batch ID/time/actor | creator-only, confirm=true, expected version,204; repeat deleted404, no public restore/hard delete; retain S3/history. | O§11; full API, not placeholder. |
| B00-ARCHIVE | lifecycle archived; derived `archived_by_parent` DTO flag | parent lifecycle is an inherited read/write fence; child own archive state is retained, so unarchiving parent never unarchives an independently archived child. Orphan read-only. | O§5/11; preserves independent child archives without inventing another lifecycle. |

A root's `creator_user_id` is the current accountable owner. `created_by_user_id` is immutable creation provenance. A SubProject's effective creator is always the root's current creator; its own `created_by_user_id` records the member who created it and conveys no member-management power.

### 2.2 Dependent-contract links

| Contract | Baseline inputs used | Resolution / blocked status |
| --- | --- | --- |
| Comment/member authorization | B00-PROJECT/HIERARCHY/MEMBERS/COMMENTS | Fully specified §3/7; I01 integration remains separately gated. |
| Context fields and version | All B00 rows, identity live display data | Fully specified §9; literal secret-free guarantee conflict Q-CONTENT is disclosed. |
| Dashboard/list/detail | TASK states, PROGRESS, PRS, QUESTIONS, lifecycle, self-only node scope | Fully specified §10; unknown reviewer mapping yields an explicit availability flag, not invented assignments. |
| Task writes / post-import explicit actions | B00-TASK-AUTH | **Blocked on B00-T** authority confirmation; exact proposed DTO/permission already defined. |
| Schema installation / future migration predecessor | Fresh schema, current deployed schema and Alembic revision | **Blocked on B00-D** deployment inventory; no fabricated down_revision/backfill. |
| Category author permissions | B00-CAT | **Blocked on B00-C** comparison with absent original baseline; proposed creator-based policy otherwise precise. |
| Provider sync | PRS metadata/schema | **Blocked on B00-PR** connector/identity-map configuration, not Dashboard shape. |

## 3. Identity consistency, inheritance and ownership

### 3.1 Exact predicates

`A(actor)` verifies the existing identity JWT, User active/fully registered and current token_version. `T(actor,team)` additionally requires active Team and active direct identity Team membership. Global System Admin alone is not T.

`root(project)` is parent_project_id for a child, otherwise its own id. `G(user,root)` is a valid grant: active User, active identity Team membership and active root project_members row bound to that exact identity membership ID. Temporary login lock/password unlock does not remove a membership or transfer ownership; needs_registration blocks the actor's authentication, not another person's grant/history label. `P(actor,node)=A+T+G(root(node))`, with published node/root and no effective deletion. `C=P and assigned root creator`; `PA=P and current identity Team Admin`.

Only roots store memberships. Every child query joins its root grant. No child member table, enrolment, independent count or separate picker exists. `GET .../projects/{child}/members` is not a child-list facility: return409 `INHERITED_MEMBERSHIP` with the authorized root member-list reference. Child DTOs name membership_source_project_id; mention pickers/navigation use that root endpoint. No frontend layout is implied.

All Project projections, reviewer mappings where applicable, authors' membership flags, assignee flags, counts and picker results join identity at read time. A Team rejoin has a new epoch and never revives an old root grant. History labels remain stored snapshots; current active/former status is derived. No roster copy, cached ACL or JWT role grant is introduced.

### 3.2 Visibility and lifecycle gates

401 invalid session;403 `TEAM_ACCESS_DENIED` for absent/inactive/nonmember Team;404 `PROJECT_NOT_FOUND` for nonexistent/deleted/unpublished/nonmember node. A child's deleted parent also means404. Visible but forbidden action403. Wrong-Project child ID404. Ineligible add/mention target422 without cross-Team detail. Stale version409 with current authorized entity data; rate429 only from approved deployment policy; database/storage503. Generic error envelope `{error:{code,message,request_id,current?}}`, no raw body/secret/URL/input echo.

Authorize before resource-specific conflict/data disclosure. For progress stale409, `current` includes version/status/note author/time and the note TextValue. Delete has an explicit exception to normal idempotency replay: a new request against an already-deleted Project returns404 even if it reuses the successful delete key (O§11.3). Domain operation is still not repeated.

For a visible effective orphan, mutations of tasks/comments/members/progress/PR/resource/info/archive/unarchive/delete return409 `OWNERSHIP_REQUIRED`; only explicit transfer is allowed. For an archived node, ordinary writes return409 `PROJECT_ARCHIVED`; unarchive is allowed by C. A child of an archived root cannot unarchive itself (`PARENT_ARCHIVED`). Transfers on archived Projects are deferred until unarchived, except orphan recovery transfer is the explicit exception needed to recover an archived-and-orphaned root; no other content/member changes occur.

Cache behavior: only a previously fetched Project can become grey after an authenticated backend Project404. Never-fetched IDs are not listed. Team403 suppresses the entire Team, not a per-Project removal claim. Paginated/filter omission alone is not revocation. VPN failure,429,503 and other transient failure keep stale data unreachable, never relabel it revoked. Root revocation also makes cached children unavailable. Local sessions remain usable and no cloud response retracts bytes/responses already delivered.

### 3.3 Cascades: preferred integration and explicit fallback

**I01 remains NOT APPROVED.** Preferred design: extract `remove_member_in_transaction` from the current independently decorated identity service and execute identity removal, root grant removal and all affected node history/revisions in the same MySQL transaction. No token or identity schema change; other Teams and refresh tokens remain available. Lock involved Users ascending → Team → roots ascending → children ascending → domain rows → operation/audit. Existing global identity guard precedes these where required. No S3/provider call while domain locks are held.

Identity Team removal updates every active root grant for the target, including roots with archived children. Children have no grants to update, but receive Project history/audit events and revised Context metadata for the inherited loss. Use actual remover and one UTC timestamp; one `project_member_removed` audit per affected node plus the identity audit. Retain task assignee ID/name; unfinished tasks derive `assignee_membership_status='former_member'` and `requires_reassignment=true`. Never silently reassign/delete tasks. Retain comments/replies/mention labels; removed people lose picker/new-feed/write access. Creator removal marks the root ownership unassigned with loss time and makes every child read-only. Any failure rolls the entire operation back; no 204 on partial cascade. Deleted retained nodes receive no member-facing response; metadata/history may be repaired without exposing them.

**If I01 is withheld:** retain unchanged identity deletion and use identical read-time joins on every Team Work request, plus the named audited `reconcile_teamwork_memberships` operator job. Visible access/membership consistency is immediate at each post-commit authorization boundary; physical Project rows can remain stale until repair. The job follows identity removed_at/remover provenance but logs its actual operator as executor, repairs roots/children/idempotent history under locks, and never grants access. Owner-supplied schedule and measured backlog determine latency; **no bounded repair latency is claimed until approved and verified**. Q-RECON records target schedule/alert responsibility. New mutations refuse stale grants before any write even during backlog. This fallback provides visible consistency, not the atomic-data guarantee; owner must explicitly choose its acceptance profile.

Creator identity deactivation also yields effective unassigned ownership immediately from live grant predicates, without a read doing a domain write. Persist repair via approved integration/job; loss time comes from identity removal/deactivation audit evidence. Missing historical loss evidence is an operator integrity case, not an invented timestamp. Password unlock alone never orphans a Project.

Project-only removal is C-only on roots, targets scoped project_members.id, preserves creator self-removal guard and changes no global token/other-root grant. Re-add inserts a fresh row bound to current identity epoch. Root changes affect all descendants by join, never fan-out grants.

### 3.4 Ownership and System Admin decisions

Assigned root: C transfers to another current G member. Orphaned root: PA transfers to another current G member. Version/idempotency and old/new actor/history audit are mandatory; endpoint never enrols a new target. Root creator changes are inherited by children for display/authority without rewriting copied owner fields.

**I02 remains NOT APPROVED:** no global System Admin Project bypass, inspection route or audit-content API is mounted. Identity's original System Admin Team/user visibility stays unchanged. Support uses request IDs, redacted operational metrics and an explicitly approved operator review; no project data is returned through ordinary endpoints to nonmembers. An audited special inspection endpoint would require separate I02 approval and a revised contract before implementation; it is not silently included here.

**Operator enrolment exception remains NOT APPROVED:** proposed incident recovery may explicitly enrol a target only with owner incident approval, actual operator User identity and enrolment/ownership audit. Without that exception, an operator can transfer only to an already eligible member. A zero-member orphan remains read-only, not auto-assigned; normal creator-only flows cannot bootstrap a memberless orphan, so it remains blocked pending an explicit exception approval. No public restore/recovery endpoint is added.

## 4. Complete proposed cloud schema

These definitions are the canonical21-table additive DDL, implemented by tw_001–tw_008 and tested on isolated MySQL8.4.13. They are not a claim of installed target tables or authorization to run production SQL. Every table uses InnoDB/utf8mb4/utf8mb4_unicode_ci; UTC timestamps are set explicitly on writes. Existing identity tables are referenced, not redefined. No local Memory data/table is imported. All deletions retain references unless a later approved operator retention procedure applies.

### 4.1 Foundation and hierarchy

```sql
CREATE TABLE categories (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 team_id BIGINT NOT NULL,
 name VARCHAR(255) NOT NULL,
 created_by_user_id INT NOT NULL,
 version BIGINT NOT NULL DEFAULT 1,
 created_at DATETIME(6) NOT NULL,
 updated_at DATETIME(6) NOT NULL,
 deleted_at DATETIME(6) NULL,
 active_name VARCHAR(255) GENERATED ALWAYS AS
   (CASE WHEN deleted_at IS NULL THEN name ELSE NULL END) STORED,
 UNIQUE KEY uq_category_active_name(team_id,active_name),
 UNIQUE KEY uq_category_team(id,team_id),
 KEY idx_category_order(team_id,created_at,id),
 FOREIGN KEY(team_id) REFERENCES teams(id),
 FOREIGN KEY(created_by_user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE projects (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 team_id BIGINT NOT NULL,
 parent_project_id BIGINT NULL,
 node_depth TINYINT NOT NULL DEFAULT 0,
 parent_depth_guard TINYINT NOT NULL DEFAULT 0,
 category_id BIGINT NULL,
 name VARCHAR(255) NOT NULL,
 background LONGTEXT NOT NULL,
 goals LONGTEXT NOT NULL,
 source_created_at DATETIME(6) NULL,
 created_by_user_id INT NOT NULL,
 created_by_name VARCHAR(100) NOT NULL,
 creator_user_id INT NULL,
 creator_name_snapshot VARCHAR(100) NULL,
 ownership_state VARCHAR(20) NULL,
 ownership_lost_at DATETIME(6) NULL,
 status VARCHAR(20) NOT NULL DEFAULT 'active',
 deleted_from_status VARCHAR(20) NULL,
 deletion_batch_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NULL,
 deleted_at DATETIME(6) NULL,
 deleted_by_user_id INT NULL,
 delete_reason LONGTEXT NULL,
 progress_status VARCHAR(20) NOT NULL DEFAULT 'not_started',
 progress_note LONGTEXT NOT NULL,
 progress_note_author_id INT NOT NULL,
 progress_note_author_name VARCHAR(100) NOT NULL,
 progress_note_updated_at DATETIME(6) NOT NULL,
 version BIGINT NOT NULL DEFAULT 1,
 context_revision BIGINT NOT NULL DEFAULT 1,
 published_at DATETIME(6) NULL,
 lifecycle_updated_at DATETIME(6) NOT NULL,
 membership_updated_at DATETIME(6) NOT NULL,
 ownership_updated_at DATETIME(6) NOT NULL,
 created_at DATETIME(6) NOT NULL,
 updated_at DATETIME(6) NOT NULL,
 last_activity_at DATETIME(6) NOT NULL,
 UNIQUE KEY uq_project_parent_type(id,team_id,node_depth),
 UNIQUE KEY uq_project_team(id,team_id),
 KEY idx_project_list(team_id,parent_project_id,status,last_activity_at,id),
 KEY idx_project_category(team_id,category_id,created_at,id),
 KEY idx_project_owner(team_id,creator_user_id,ownership_state,id),
 FOREIGN KEY(team_id) REFERENCES teams(id),
 FOREIGN KEY(category_id,team_id) REFERENCES categories(id,team_id),
 FOREIGN KEY(parent_project_id,team_id,parent_depth_guard) REFERENCES projects(id,team_id,node_depth),
 FOREIGN KEY(created_by_user_id) REFERENCES users(id),
 FOREIGN KEY(creator_user_id) REFERENCES users(id),
 FOREIGN KEY(progress_note_author_id) REFERENCES users(id),
 FOREIGN KEY(deleted_by_user_id) REFERENCES users(id),
 CHECK(parent_depth_guard=0),
 CHECK((node_depth=0 AND parent_project_id IS NULL AND creator_user_id IS NOT NULL
        AND ownership_state IS NOT NULL AND ownership_state IN ('assigned','unassigned'))
    OR (node_depth=1 AND parent_project_id IS NOT NULL AND category_id IS NULL
        AND creator_user_id IS NULL AND creator_name_snapshot IS NULL
        AND ownership_state IS NULL AND ownership_lost_at IS NULL)),
 CHECK(node_depth=1 OR
   (ownership_state='assigned' AND ownership_lost_at IS NULL) OR
   (ownership_state='unassigned' AND ownership_lost_at IS NOT NULL)),
 CHECK(status IN ('active','archived','deleted')),
 CHECK(progress_status IN ('not_started','in_progress','blocked','in_review','completed','on_hold')),
 CHECK(version>=1 AND context_revision>=1),
 CHECK((status='deleted' AND deleted_at IS NOT NULL AND deleted_by_user_id IS NOT NULL
        AND deleted_from_status IN ('active','archived') AND deletion_batch_id IS NOT NULL)
    OR (status<>'deleted' AND deleted_at IS NULL AND deleted_by_user_id IS NULL
        AND deleted_from_status IS NULL AND deletion_batch_id IS NULL AND delete_reason IS NULL))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_members (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 project_id BIGINT NOT NULL,
 team_id BIGINT NOT NULL,
 root_depth_guard TINYINT NOT NULL DEFAULT 0,
 user_id INT NOT NULL,
 team_membership_id BIGINT NOT NULL,
 status VARCHAR(20) NOT NULL DEFAULT 'active',
 added_by_user_id INT NOT NULL,
 added_by_name_snapshot VARCHAR(100) NOT NULL,
 joined_at DATETIME(6) NOT NULL,
 removed_by_user_id INT NULL,
 removed_at DATETIME(6) NULL,
 removal_reason VARCHAR(40) NULL,
 active_user_id INT GENERATED ALWAYS AS
   (CASE WHEN status='active' THEN user_id ELSE NULL END) STORED,
 UNIQUE KEY uq_project_active_member(project_id,active_user_id),
 KEY idx_project_member_cascade(team_id,user_id,status,project_id,id),
 KEY idx_project_member_epoch(team_membership_id,status,project_id),
 FOREIGN KEY(project_id,team_id,root_depth_guard) REFERENCES projects(id,team_id,node_depth),
 FOREIGN KEY(user_id) REFERENCES users(id),
 FOREIGN KEY(team_membership_id) REFERENCES team_members(id),
 FOREIGN KEY(added_by_user_id) REFERENCES users(id),
 FOREIGN KEY(removed_by_user_id) REFERENCES users(id),
 CHECK(root_depth_guard=0),
 CHECK(status IN ('active','removed')),
 CHECK((status='active' AND removed_at IS NULL AND removed_by_user_id IS NULL AND removal_reason IS NULL)
    OR (status='removed' AND removed_at IS NOT NULL AND removed_by_user_id IS NOT NULL AND removal_reason IS NOT NULL))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_tasks (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 project_id BIGINT NOT NULL,
 title VARCHAR(255) NOT NULL,
 description LONGTEXT NOT NULL,
 status VARCHAR(20) NOT NULL DEFAULT 'todo',
 lifecycle_status VARCHAR(20) NOT NULL DEFAULT 'active',
 created_by_user_id INT NOT NULL,
 created_by_name_snapshot VARCHAR(100) NOT NULL,
 driver_user_id INT NOT NULL,
 driver_name_snapshot VARCHAR(100) NOT NULL,
 assignee_user_id INT NULL,
 assignee_name_snapshot VARCHAR(100) NULL,
 version BIGINT NOT NULL DEFAULT 1,
 created_at DATETIME(6) NOT NULL,
 updated_at DATETIME(6) NOT NULL,
 UNIQUE KEY uq_task_project(project_id,id),
 KEY idx_task_counts(project_id,lifecycle_status,status,id),
 FOREIGN KEY(project_id) REFERENCES projects(id),
 FOREIGN KEY(created_by_user_id) REFERENCES users(id),
 FOREIGN KEY(driver_user_id) REFERENCES users(id),
 FOREIGN KEY(assignee_user_id) REFERENCES users(id),
 CHECK(status IN ('todo','in_progress','blocked','done')),
 CHECK(lifecycle_status IN ('active','archived','deleted')),
 CHECK(version>=1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_progress_events (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 project_id BIGINT NOT NULL,
 project_version BIGINT NOT NULL,
 event_type VARCHAR(20) NOT NULL,
 actor_user_id INT NOT NULL,
 actor_name_snapshot VARCHAR(100) NOT NULL,
 old_status VARCHAR(20) NOT NULL,
 new_status VARCHAR(20) NOT NULL,
 old_note LONGTEXT NOT NULL,
 new_note LONGTEXT NOT NULL,
 created_at DATETIME(6) NOT NULL,
 KEY idx_progress_history(project_id,created_at,id),
 FOREIGN KEY(project_id) REFERENCES projects(id),
 FOREIGN KEY(actor_user_id) REFERENCES users(id),
 CHECK(event_type IN ('progress_changed','archived','unarchived')),
 CHECK(old_status IN ('not_started','in_progress','blocked','in_review','completed','on_hold')),
 CHECK(new_status IN ('not_started','in_progress','blocked','in_review','completed','on_hold'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_activity_events (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 project_id BIGINT NOT NULL,
 event_type VARCHAR(50) NOT NULL,
 actor_user_id INT NOT NULL,
 actor_name_snapshot VARCHAR(100) NOT NULL,
 object_type VARCHAR(40) NOT NULL,
 object_id BIGINT NULL,
 object_version BIGINT NULL,
 safe_detail JSON NOT NULL,
 created_at DATETIME(6) NOT NULL,
 KEY idx_project_activity(project_id,created_at,id),
 FOREIGN KEY(project_id) REFERENCES projects(id),
 FOREIGN KEY(actor_user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

The composite depth FK prevents a child from referencing another child, including a self-cycle; no application-only “third level” promise is made. It also prevents child membership rows. Services still verify the identity epoch's Team/User match and forbid reparenting an existing node. Child category/owner are derived from the root on reads. Parent lifecycle cascades plus read-time parent status defend against historic stale child state.

Tasks count all nondeleted rows, including retained archived tasks, by their exact four work states. A task status transition never updates progress_status or progress_note. No synthetic “completion percentage” is stored anywhere.

### 4.2 PR, resource and upload metadata

```sql
CREATE TABLE project_prs (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 project_id BIGINT NOT NULL,
 provider VARCHAR(20) NOT NULL,
 repository_ref VARCHAR(255) NOT NULL,
 external_pr_id VARCHAR(255) NOT NULL,
 title LONGTEXT NOT NULL,
 url LONGTEXT NOT NULL,
 branch LONGTEXT NOT NULL,
 status VARCHAR(20) NOT NULL,
 reviewer_mapping_complete BOOLEAN NOT NULL DEFAULT FALSE,
 synced_at DATETIME(6) NOT NULL,
 version BIGINT NOT NULL DEFAULT 1,
 UNIQUE KEY uq_pr_external(project_id,provider,repository_ref,external_pr_id),
 UNIQUE KEY uq_pr_project(project_id,id),
 KEY idx_pr_counts(project_id,status,id),
 FOREIGN KEY(project_id) REFERENCES projects(id),
 CHECK(provider IN ('github','stash')),
 CHECK(status IN ('open','merged','closed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_pr_reviewers (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 pr_id BIGINT NOT NULL,
 external_reviewer_id VARCHAR(255) NOT NULL,
 user_id INT NULL,
 display_name VARCHAR(255) NOT NULL,
 is_current BOOLEAN NOT NULL DEFAULT TRUE,
 updated_at DATETIME(6) NOT NULL,
 UNIQUE KEY uq_pr_reviewer(pr_id,external_reviewer_id),
 KEY idx_review_me(user_id,pr_id),
 FOREIGN KEY(pr_id) REFERENCES project_prs(id),
 FOREIGN KEY(user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_resources (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 project_id BIGINT NOT NULL,
 name LONGTEXT NOT NULL,
 status VARCHAR(20) NOT NULL DEFAULT 'active',
 created_by_user_id INT NOT NULL,
 current_version BIGINT NOT NULL DEFAULT 0,
 entity_version BIGINT NOT NULL DEFAULT 1,
 created_at DATETIME(6) NOT NULL,
 updated_at DATETIME(6) NOT NULL,
 UNIQUE KEY uq_resource_project(project_id,id),
 KEY idx_resource_list(project_id,status,id),
 FOREIGN KEY(project_id) REFERENCES projects(id),
 FOREIGN KEY(created_by_user_id) REFERENCES users(id),
 CHECK(status IN ('active','archived','deleted'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_resource_versions (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 resource_id BIGINT NOT NULL,
 resource_version BIGINT NOT NULL,
 name LONGTEXT NOT NULL,
 media_type VARCHAR(255) NOT NULL,
 size_bytes BIGINT NOT NULL,
 checksum_algorithm VARCHAR(32) NULL,
 checksum_type VARCHAR(20) NULL,
 checksum_value TEXT CHARACTER SET ascii COLLATE ascii_bin NULL,
 uploaded_by_user_id INT NOT NULL,
 uploader_name_snapshot VARCHAR(100) NOT NULL,
 s3_object_key VARCHAR(1024) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
 s3_version_id VARCHAR(1024) CHARACTER SET ascii COLLATE ascii_bin NULL,
 created_at DATETIME(6) NOT NULL,
 UNIQUE KEY uq_resource_version(resource_id,resource_version),
 FOREIGN KEY(resource_id) REFERENCES project_resources(id),
 FOREIGN KEY(uploaded_by_user_id) REFERENCES users(id),
 CHECK(size_bytes>=0),
 CHECK(checksum_type IS NULL OR checksum_type IN ('FULL_OBJECT','COMPOSITE'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

Only backend-generated immutable keys are stored. Lists/Context never expose these internal columns or raw S3 version IDs. The checksum DTO preserves algorithm/type: a multipart composite checksum/ETag is not represented as a full-file SHA256. PR title/branch are metadata; the backend does not download PR code/diffs. Unknown reviewer mappings are explicit, not guessed by matching a display name. PR reviewer rows are retained: sync marks absent provider reviewers is_current=false and current ones true in one per-PR transaction. Current DTOs/counts/filter joins use is_current=true; Team removal changes derived membership flags without deleting review history. Do not grant runtime DELETE merely to replace a reviewer list. Driver/reviewer targets never grant membership.

### 4.3 Comments, structured mentions and revisions

```sql
CREATE TABLE project_comments (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 project_id BIGINT NOT NULL,
 task_id BIGINT NULL,
 pr_id BIGINT NULL,
 resource_id BIGINT NULL,
 parent_comment_id BIGINT NULL,
 author_user_id INT NOT NULL,
 author_project_member_id BIGINT NOT NULL,
 author_name_snapshot VARCHAR(100) NOT NULL,
 author_role_snapshot VARCHAR(20) NOT NULL,
 content TEXT NOT NULL,
 status VARCHAR(20) NOT NULL DEFAULT 'active',
 version BIGINT NOT NULL DEFAULT 1,
 created_at DATETIME(6) NOT NULL,
 updated_at DATETIME(6) NOT NULL,
 edited_at DATETIME(6) NULL,
 deleted_at DATETIME(6) NULL,
 deleted_by_user_id INT NULL,
 UNIQUE KEY uq_comment_project(project_id,id),
 KEY idx_comment_page(project_id,created_at,id),
 KEY idx_comment_author(project_id,author_user_id,created_at,id),
 KEY idx_comment_parent(project_id,parent_comment_id,created_at,id),
 KEY idx_comment_task(project_id,task_id,created_at,id),
 KEY idx_comment_pr(project_id,pr_id,created_at,id),
 KEY idx_comment_resource(project_id,resource_id,created_at,id),
 FOREIGN KEY(project_id) REFERENCES projects(id),
 FOREIGN KEY(author_user_id) REFERENCES users(id),
 FOREIGN KEY(author_project_member_id) REFERENCES project_members(id),
 FOREIGN KEY(deleted_by_user_id) REFERENCES users(id),
 FOREIGN KEY(project_id,parent_comment_id) REFERENCES project_comments(project_id,id),
 FOREIGN KEY(project_id,task_id) REFERENCES project_tasks(project_id,id),
 FOREIGN KEY(project_id,pr_id) REFERENCES project_prs(project_id,id),
 FOREIGN KEY(project_id,resource_id) REFERENCES project_resources(project_id,id),
 CHECK(status IN ('active','edited','deleted')),
 CHECK(author_role_snapshot IN ('creator','member')),
 CHECK(CHAR_LENGTH(content) BETWEEN 1 AND 4000 AND OCTET_LENGTH(content)<=16384),
 CHECK((task_id IS NOT NULL)+(pr_id IS NOT NULL)+(resource_id IS NOT NULL)<=1),
 CHECK((status='deleted' AND deleted_at IS NOT NULL AND deleted_by_user_id IS NOT NULL)
    OR (status<>'deleted' AND deleted_at IS NULL AND deleted_by_user_id IS NULL)),
 CHECK(version>=1)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE comment_mentions (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 comment_id BIGINT NOT NULL,
 mentioned_user_id INT NOT NULL,
 mentioned_name_snapshot VARCHAR(100) NOT NULL,
 status VARCHAR(20) NOT NULL DEFAULT 'active',
 changed_version BIGINT NOT NULL,
 created_at DATETIME(6) NOT NULL,
 updated_at DATETIME(6) NOT NULL,
 UNIQUE KEY uq_comment_user_mention(comment_id,mentioned_user_id),
 KEY idx_mentions_me(mentioned_user_id,status,comment_id),
 FOREIGN KEY(comment_id) REFERENCES project_comments(id),
 FOREIGN KEY(mentioned_user_id) REFERENCES users(id),
 CHECK(status IN ('active','removed'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_comment_revisions (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 comment_id BIGINT NOT NULL,
 version BIGINT NOT NULL,
 actor_user_id INT NOT NULL,
 status VARCHAR(20) NOT NULL,
 content TEXT NOT NULL,
 mentions_snapshot JSON NOT NULL,
 created_at DATETIME(6) NOT NULL,
 UNIQUE KEY uq_comment_revision(comment_id,version),
 FOREIGN KEY(comment_id) REFERENCES project_comments(id),
 FOREIGN KEY(actor_user_id) REFERENCES users(id),
 CHECK(status IN ('active','edited','deleted'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_context_items (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 project_id BIGINT NOT NULL,
 kind VARCHAR(20) NOT NULL,
 title VARCHAR(255) NOT NULL,
 context_text LONGTEXT NOT NULL,
 body LONGTEXT NOT NULL,
 answer LONGTEXT NULL,
 state VARCHAR(20) NOT NULL,
 author_user_id INT NOT NULL,
 author_name_snapshot VARCHAR(100) NOT NULL,
 decided_at DATETIME(6) NULL,
 version BIGINT NOT NULL DEFAULT 1,
 deleted_at DATETIME(6) NULL,
 created_at DATETIME(6) NOT NULL,
 updated_at DATETIME(6) NOT NULL,
 KEY idx_context_items(project_id,kind,state,id),
 FOREIGN KEY(project_id) REFERENCES projects(id),
 FOREIGN KEY(author_user_id) REFERENCES users(id),
 CHECK((kind='decision' AND state IN ('proposed','accepted','superseded','withdrawn'))
    OR (kind='open_question' AND state IN ('open','answered','closed')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_context_item_revisions (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 item_id BIGINT NOT NULL,
 version BIGINT NOT NULL,
 actor_user_id INT NOT NULL,
 snapshot JSON NOT NULL,
 created_at DATETIME(6) NOT NULL,
 UNIQUE KEY uq_context_item_revision(item_id,version),
 FOREIGN KEY(item_id) REFERENCES project_context_items(id),
 FOREIGN KEY(actor_user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

Author membership on a SubProject refers to a root grant; services verify the root/author match. Creation/edit/delete and mention/revision changes are one transaction. Revisions are app INSERT-only; normal GET/Context returns current content or tombstone, never old content. Comment deletion preserves internal original text/history and emits `content:"[deleted]"`, empty mentions; replies remain. No warning-match substring is stored in logs or a warning side table.

### 4.4 Operations, conversion and transport state

```sql
CREATE TABLE teamwork_mutation_keys (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 actor_user_id INT NOT NULL,
 operation_key CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
 request_hash CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
 method_path VARCHAR(255) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
 response_ref JSON NOT NULL,
 response_status SMALLINT NOT NULL,
 created_at DATETIME(6) NOT NULL,
 expires_at DATETIME(6) NULL,
 UNIQUE KEY uq_mutation_actor_key(actor_user_id,operation_key),
 KEY idx_mutation_expiry(expires_at,id),
 FOREIGN KEY(actor_user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_import_receipts (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 project_id BIGINT NOT NULL,
 imported_by_user_id INT NOT NULL,
 local_import_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
 context_version CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
 imported_at DATETIME(6) NOT NULL,
 UNIQUE KEY uq_import_actor_id(imported_by_user_id,local_import_id),
 FOREIGN KEY(project_id) REFERENCES projects(id),
 FOREIGN KEY(imported_by_user_id) REFERENCES users(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_conversion_sessions (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 team_id BIGINT NOT NULL,
 created_by_user_id INT NOT NULL,
 client_conversion_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
 mode VARCHAR(20) NOT NULL,
 existing_parent_id BIGINT NULL,
 status VARCHAR(20) NOT NULL DEFAULT 'planning',
 version BIGINT NOT NULL DEFAULT 1,
 plan_digest CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
 committed_project_id BIGINT NULL,
 sealed_actor_team_membership_id BIGINT NULL,
 created_at DATETIME(6) NOT NULL,
 updated_at DATETIME(6) NOT NULL,
 expires_at DATETIME(6) NULL,
 UNIQUE KEY uq_conversion_actor_client(created_by_user_id,client_conversion_id),
 FOREIGN KEY(team_id) REFERENCES teams(id),
 FOREIGN KEY(created_by_user_id) REFERENCES users(id),
 FOREIGN KEY(existing_parent_id) REFERENCES projects(id),
 FOREIGN KEY(committed_project_id) REFERENCES projects(id),
 FOREIGN KEY(sealed_actor_team_membership_id) REFERENCES team_members(id),
 CHECK(mode IN ('root','subproject')),
 CHECK((mode='root' AND existing_parent_id IS NULL) OR (mode='subproject' AND existing_parent_id IS NOT NULL)),
 CHECK(status IN ('planning','sealed','preparing','ready','committed','failed','cancelled','expired'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE project_conversion_items (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 conversion_id BIGINT NOT NULL,
 client_item_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
 kind VARCHAR(20) NOT NULL,
 node_key CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
 payload JSON NOT NULL,
 request_hash CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
 prepared_object_id BIGINT NULL,
 validated_team_membership_id BIGINT NULL,
 created_at DATETIME(6) NOT NULL,
 UNIQUE KEY uq_conversion_item(conversion_id,client_item_id),
 KEY idx_conversion_plan(conversion_id,kind,id),
 FOREIGN KEY(conversion_id) REFERENCES project_conversion_sessions(id),
 FOREIGN KEY(validated_team_membership_id) REFERENCES team_members(id),
 CHECK(validated_team_membership_id IS NULL OR kind='member'),
 CHECK(kind IN ('node','task','member','resource'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE resource_uploads (
 id BIGINT NOT NULL AUTO_INCREMENT PRIMARY KEY,
 team_id BIGINT NOT NULL,
 project_id BIGINT NULL,
 conversion_id BIGINT NULL,
 conversion_item_id BIGINT NULL,
 resource_id BIGINT NULL,
 actor_user_id INT NOT NULL,
 client_upload_id CHAR(36) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
 name LONGTEXT NOT NULL,
 media_type VARCHAR(255) NOT NULL,
 declared_size BIGINT NOT NULL,
 declared_sha256 CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
 upload_kind VARCHAR(20) NOT NULL,
 status VARCHAR(20) NOT NULL DEFAULT 'pending',
 object_key VARCHAR(1024) CHARACTER SET ascii COLLATE ascii_bin NOT NULL,
 multipart_id LONGTEXT NULL,
 part_manifest_sealed_at DATETIME(6) NULL,
 verification_cursor INT NOT NULL DEFAULT 0,
 verified_part_count INT NOT NULL DEFAULT 0,
 verified_size_bytes BIGINT NOT NULL DEFAULT 0,
 part_manifest_hash CHAR(64) CHARACTER SET ascii COLLATE ascii_bin NULL,
 completion_authorized_at DATETIME(6) NULL,
 verified_object_version VARCHAR(1024) CHARACTER SET ascii COLLATE ascii_bin NULL,
 verified_checksum JSON NULL,
 version BIGINT NOT NULL DEFAULT 1,
 created_at DATETIME(6) NOT NULL,
 updated_at DATETIME(6) NOT NULL,
 expires_at DATETIME(6) NULL,
 last_url_expires_at DATETIME(6) NULL,
 UNIQUE KEY uq_upload_actor_client(actor_user_id,client_upload_id),
 KEY idx_upload_cleanup(status,expires_at,id),
 FOREIGN KEY(team_id) REFERENCES teams(id),
 FOREIGN KEY(project_id) REFERENCES projects(id),
 FOREIGN KEY(conversion_id) REFERENCES project_conversion_sessions(id),
 FOREIGN KEY(conversion_item_id) REFERENCES project_conversion_items(id),
 FOREIGN KEY(resource_id) REFERENCES project_resources(id),
 FOREIGN KEY(actor_user_id) REFERENCES users(id),
 CHECK((project_id IS NOT NULL)+(conversion_id IS NOT NULL)=1),
 CHECK(declared_size>=0),
 CHECK(upload_kind IN ('single_put','multipart')),
 CHECK(status IN ('pending','uploading','verifying','awaiting_completion','verified','published','failed','cancelled','expired')),
 CHECK(verification_cursor BETWEEN 0 AND 10000 AND verified_part_count BETWEEN 0 AND 10000),
 CHECK(verified_size_bytes>=0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE resource_upload_parts (
 upload_id BIGINT NOT NULL,
 part_number INT NOT NULL,
 expected_size BIGINT NOT NULL,
 checksum_algorithm VARCHAR(32) NULL,
 expected_checksum TEXT CHARACTER SET ascii COLLATE ascii_bin NULL,
 observed_etag VARCHAR(255) CHARACTER SET ascii COLLATE ascii_bin NULL,
 observed_size BIGINT NULL,
 observed_checksum JSON NULL,
 verified_at DATETIME(6) NULL,
 created_at DATETIME(6) NOT NULL,
 PRIMARY KEY(upload_id,part_number),
 FOREIGN KEY(upload_id) REFERENCES resource_uploads(id),
 CHECK(part_number BETWEEN 1 AND 10000),
 CHECK(expected_size>=0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
```

Conversion payload rows contain only schema-checked shared DTOs, not arbitrary JSON bags. The whole plan is not held in one JSON row or one request, and no 20-file/1,000-task/member cap exists. Publication is fenced by the root's published_at, as specified in §8. It is not a lifecycle status. Resource parts use the actual S3 part-number range, not a product quota.

No guessed per-user rate policy is carried forward. Team Work emits no application429; owner ingress/Gateway admission configuration and measured method rate/burst settings are mandatory pilot gates, not assumed installed controls. Operation-key expiry remains nullable with no automatic key purge. New upload/conversion intents require explicit positive expiry settings (STAGING_POLICY_REQUIRED503 when missing); legacy NULL-expiry staging is quarantined until an approved age-policy sweep. No undocumented24-hour default is introduced.

## 5. Hierarchy and lifecycle state machines

### 5.1 Root/child behavior

Any T creates a root; the server sets its creator and enrols that actor using the current identity epoch. Any P may create a SubProject under an active, assigned root. Parent must be a root in the same Team; a child cannot be a parent, be moved to another root, or carry its own members/category/owner. Its actual creating member is creation provenance only.

The selected listing design is **parent summaries plus a paginated SubProject-list endpoint**. Root list entries include a count/reference, never an unbounded embedded child collection. `GET .../projects/{root}/subprojects` returns child summaries, by last activity descending, creation descending, id descending. Root lists in category mode sort category creation ascending/id ascending (No Category last), then root last activity descending, creation descending/id descending. Time mode sorts roots by creation descending/id descending. Children remain grouped under their root in either mode; standalone roots are in No Category, not hidden.

Each child owns its background/goals/tasks/progress/PRs/resources/comments/decisions/questions/Context. It inherits only Team, category label, membership, owner and parent lifecycle/ownership fence. It does not copy parent work data. Creating a child does not grant the creating member authority to manage root members.

### 5.2 Creator-only lifecycle actions

Choose creator-only archive/unarchive/delete. No System Admin lifecycle exception is introduced. Authentication/visibility first; effective orphan→409 OWNERSHIP_REQUIRED before a write; deleted/invisible→404. A global administrator without P has no normal Project access or mutation authority.

| Current state / action | Exact result |
| --- | --- |
| active assigned, archive by C | Set own status archived; audit and progress event with unchanged qualitative state/note; version/context revision advance. |
| archived assigned, archive by C |200 unchanged/no duplicate event; no invented status transition. |
| archived assigned, unarchive by C | Set own status active; restore prior qualitative state/note/tasks/members (they were frozen, never reset); audit/event/version. |
| active assigned, unarchive by C |200 unchanged/no duplicate event. |
| child with archived root, unarchive |409 PARENT_ARCHIVED; root must be unarchived first. |
| active or archived assigned, delete by C | Require confirm=true, expected version and key; set deleted, old status, actor/time/reason metadata and deletion batch;204. |
| deleted, any member get/archive/delete retry |404, including same-key retry after successful delete; no response implying a new deletion. |
| active/archived effective orphan, any normal write |409 OWNERSHIP_REQUIRED, except explicit authorized ownership transfer. |

**Parent cascades use a visibility/state fence, not copied child status rows.** Archiving a root makes every nondeleted child effectively archived/read-only immediately. Child own status remains active or independently archived. Unarchiving the root reactivates only children whose own state was active. Deleting a root makes all children effectively deleted/invisible immediately, regardless of their own status. This avoids unbounded child fan-out while providing one atomic lifecycle effect. Audit the affected nondeleted child count; child history reads include the relevant inherited lifecycle event with its root source reference, without duplicating the discussion/task collections.

Effective child lifecycle is deleted if root or child deleted; else archived if root or child archived; else active. `archived_by_parent` is a derived boolean, not a mutable authority. An independently archived child never changes its parent. A child's effective owner/orphan state always comes from root.

Archived nodes allow reads, Context/import and historical counts, but no info/task/progress/comment/member/PR-sync/resource writes. Unarchive and the narrow orphan ownership recovery are explicit exceptions. Progress status/note do not change automatically on archive, task completion, PR merge or comment posting.

Delete is soft only. S3 objects, comment revisions, progress/history and audit rows remain. No member restore or hard-delete route exists. Approved operator restore validates Team/root grants, prior lifecycle and deletion batch; restoring a root restores the inherited fence only, not independently deleted children. It must not revive old membership epochs or reset identity bootstrap. Retention/purge/restore operation approval is Q-RETENTION.

## 6. Common wire types and complete DTO registry

All JSON request DTOs reject unknown keys. `ID` is a positive safe integer≤2^53−1, matching the identity numeric-ID contract; database counters approaching that bound stop issuance with 409 rather than emit lossy IDs. `Time` is UTC ISO8601 Z, serialized by the new typed DTO layer with aware UTC datetimes; do not rely on the existing identity renderer, which recognizes only its existing timestamp keys. `UUID` is canonical lowercase UUIDv4. Nullability and omission differ for patch DTOs. Headers and queries are not accepted as JSON body keys. `hash64` is exactly64 lowercase hexadecimal SHA256 characters; `int` means nonnegative integer unless an explicitly positive index/version is stated. Names trim to nonempty; ordinary text preserves user content after the declared LF/NFC normalization.

`TextValue = {inline:string|null, ref:TextRef|null}` has exactly one nonnull alternative. `TextRef={kind:string,object_id:ID,field:string,resource_version:int|null,context_version:hash64,utf8_bytes:int,href:string}` is an authenticated version-checked continuation for a large DB text field, not a file/S3 capability (§9). Ordinary short text uses inline. This gives access to a complete field without forcing it into one Lambda response. `Page<T>={items:T[],next_cursor:string|null,has_more:boolean,projection_version:string|null}`; page length is transport-adaptive, not a total-collection quota.

| DTO | Complete fields / semantics |
| --- | --- |
| ActorDisplay | `user_id:ID, name:string, membership_status:active\|former_member`; names may be historical snapshots. |
| CategoryRef | `id:ID, name:string, created_at:Time, version:int`; null means No Category, including a retired label. |
| Category | CategoryRef plus `team_id:ID, created_by:ActorDisplay, updated_at:Time`; never hidden Project counts. |
| TaskCounts | `total:int,todo:int,in_progress:int,blocked:int,done:int`; counts nondeleted own tasks including archived tasks. `total` equals the sum; no ratio field. |
| PRCounts | `open:int,merged:int,closed:int,reviewer_mapping_complete:boolean`. Current-user reviewing count is a separate ViewerFacts field, not shared Context. |
| Counts | `tasks:TaskCounts, prs:PRCounts, resources:int, comments:int, open_questions:int, members:int, subprojects:int`; comments include tombstones; viewer mention counts exclude deleted comments and are not unread. |
| ViewerFacts | `open_prs_reviewing_me:int,reviewer_mapping_complete:boolean,mentioned_me_count:int,is_creator:boolean`; actor-specific facts for dashboard/list/detail only, excluded from Context/shared version. |
| Progress | `status:enum6,note:TextValue,author:ActorDisplay,updated_at:Time,project_version:int`; enum6 is exactly §2.1. |
| Ownership | `state:assigned\|unassigned,creator:ActorDisplay,lost_at:Time\|null,source_project_id:ID`; historical owner retained when lost. |
| Capabilities | `can_import:boolean,import_disabled_reason:string\|null,can_convert:boolean,convert_disabled_reason:string\|null,can_edit_info:boolean,can_manage_members:boolean,can_archive:boolean,can_unarchive:boolean,can_delete:boolean,read_only_reason:string\|null`; computed per actor, never grants. Cloud existing Projects have can_convert=false/ALREADY_TEAM_PROJECT. |
| ParentRef | `id:ID,name:string,href:string`; same-Team authorized root reference, null for a root. |
| SharedProjectSummary | `id:ID,team_id:ID,team_name:string,scope:"team",node_kind:project\|subproject,parent_project_id:ID\|null,parent:ParentRef\|null,membership_source_project_id:ID,category:CategoryRef\|null,name:string,creator:ActorDisplay,created_by:ActorDisplay,created_at:Time,source_created_at:Time\|null,updated_at:Time,last_activity_at:Time,status:active\|archived,own_status:active\|archived,archived_by_parent:boolean,ownership:Ownership,progress:Progress,counts:Counts,version:int,context_version:hash64,subprojects:{count:int,href:string\|null}`. Deleted nodes have no member DTO. Root counts do not include child tasks/PRs/comments. |
| ProjectSummary | SharedProjectSummary plus `capabilities:Capabilities,viewer:ViewerFacts`; actor overlays never enter shared Context or its hash. |
| ProjectDetail | ProjectSummary plus `background:TextValue,goals:TextValue,subproject_page:Page<ProjectSummary>\|null,sections:{tasks:string,prs:string,resources:string,comments:string,members:string,progress_history:string,decisions:string,open_questions:string,context:string}`. Child members path points to root. **Project detail is the Project Dashboard**; no duplicate `/projects/{id}/dashboard` endpoint. |
| Member | `project_member_id:ID,user_id:ID,name:string,email:string,project_role:creator\|member,joined_at:Time,added_by:ActorDisplay,membership_status:"active"`; only G. MemberPage optionally supports exact user_id search for chip navigation. |
| Task | `id:ID,project_id:ID,title:string,description:TextValue,status:enum4,lifecycle_status:active\|archived,created_by:ActorDisplay,driver:ActorDisplay,assignee:ActorDisplay\|null,assignee_membership_status:active\|former_member\|null,requires_reassignment:boolean,version:int,created_at:Time,updated_at:Time,comment_count:int,comments_href:string`. Deleted task content is retained but omitted from lists/Context. |
| ProgressEvent | `id:ID,project_id:ID,source_project_id:ID,type:progress_changed\|archived\|unarchived,actor:ActorDisplay,old_status:enum6,new_status:enum6,old_note:TextValue,new_note:TextValue,project_version:int,created_at:Time,inherited:boolean`. |
| PR | `id:ID,project_id:ID,provider:github\|stash,repository_ref:string,external_pr_id:string,title:TextValue,url:string,branch:TextValue,status:open\|merged\|closed,reviewers:{user_id:ID\|null,name:string,membership_status:active\|former_member\|external}[],reviewer_mapping_complete:boolean,synced_at:Time,version:int,comment_count:int,comments_href:string`. No PR body/diff. |
| Resource | `id:ID,project_id:ID,name:TextValue,media_type:string,size_bytes:int,version:int,entity_version:int,status:active\|archived,created_by:ActorDisplay,uploader:ActorDisplay,updated_at:Time,checksum:Checksum\|null,download_ref:{resource_id:ID,version:int,href:string},comment_count:int,comments_href:string`. No bucket/key/raw S3 version/URL. |
| Checksum | `algorithm:string,type:FULL_OBJECT\|COMPOSITE,value:string`; server-attested, never label an ETag as SHA256. |
| CommentAuthor | `user_id:ID,name:string,role_at_creation:creator\|member,current_project_role:creator\|member\|null,membership_status:active\|former_member`. |
| Mention | `user_id:ID,name:string,membership_status:active\|former_member,render_as:member_chip\|former_member_chip,navigation:{type:"project_members",project_id:ID,user_id:ID}\|null`; current chip uses root roster, former chip navigation=null. |
| Comment | `id:ID,project_id:ID,task_id:ID\|null,pr_id:ID\|null,resource_id:ID\|null,parent_comment_id:ID\|null,author:CommentAuthor,content:string,status:active\|edited\|deleted,version:int,mentions:Mention[],created_at:Time,updated_at:Time,edited_at:Time\|null,is_edited:boolean,deleted_at:Time\|null,is_deleted:boolean`. Tombstones use content="[deleted]", mentions=[]; no prior revision text. |
| Warning | `type:possible_secret\|validator_unavailable,message:string`; fixed generic safe message, no match text/offset/hash. Returned only to author on relevant mutations/replay, not a public warning inventory. |
| ContextItem | `id:ID,project_id:ID,kind:decision\|open_question,title:string,context:TextValue,body:TextValue,answer:TextValue\|null,status:decision enum4 or question enum3,author:ActorDisplay,decided_at:Time\|null,version:int,created_at:Time,updated_at:Time`. Open count is state=open, never inferred punctuation. |
| Activity | `id:ID,project_id:ID,project_name:string,parent_project_id:ID\|null,actor:ActorDisplay,type:string,object:{type:string,id:ID\|null,version:int\|null,href:string\|null},time:Time,inherited:boolean`; no secret-bearing text snippet or hidden-node activity. |
| Operation | `idempotency_replayed:boolean,committed_version:int\|null`; no URL/body cache. |
| Mutation<T> | `{data:T,operation:Operation,warnings:Warning[]}`. Non-discussion mutations return warnings=[];204 has no body. |

Request registry (every field; `?` means optional, not nullable unless specified):

| Request | Fields |
| --- | --- |
| CategoryCreate / CategoryPatch | create `{name:string}`; patch `{name?:string}`. Trim name, reject empty; DB name bound§2.1; duplicate active name409. |
| ProjectCreate | `{name:string,category_id:ID\|null,background:string,goals:string}`; required background/goals, no arbitrary metadata; creator/membership set by server; initial progress not_started/note empty. |
| ChildCreate | `{name:string,background:string,goals:string}` only; no category/member/creator override. |
| ProjectPatch | `{name?:string,category_id?:ID\|null,background?:string,goals?:string}`; C changes name/category, any P may change background/goals; child cannot supply category. Mixed unauthorized field rejects whole request403. |
| LifecycleBody | archive/unarchive `{}`; delete `{confirm:true,reason?:string}`. False/missing confirmation422; a supplied reason is restricted deletion-domain text, not a member-visible or operational-log field. Only Project deletion persists it in projects.delete_reason; other soft-delete endpoints record reason_supplied only unless their table explicitly defines a reason store. |
| MemberAdd / OwnerTransfer | `{user_id:ID}` / `{new_creator_user_id:ID}`; root-only. |
| TaskCreate | `{title:string,description:string,assignee_user_id?:ID\|null}`; driver defaults actor, work state todo; no client creator/driver privilege override. |
| TaskPatch / TaskStatus | patch `{title?:string,description?:string,driver_user_id?:ID,assignee_user_id?:ID\|null}`; status `{status:enum4}`. Assignment targets must have current G. |
| ProgressPatch | `{status?:enum6,note?:string}`; at least one key; omitted note preserves it. Status not derived from counts; no percentage accepted. |
| CommentCreate / CommentEdit | create `{content:string,task_id?:ID\|null,pr_id?:ID\|null,resource_id?:ID\|null,parent_comment_id?:ID\|null}`; edit `{content:string}` only; no client mentions array. |
| ContextItemCreate/Patch | create `{kind:decision\|open_question,title:string,context:string,body:string,status:matching enum,answer?:string\|null,decided_at?:Time\|null}`; patch any of title/context/body/status/answer/decided_at, kind immutable. Accepted decision requires decided_at; answered question requires nonempty answer. |
| ImportCreate | `{local_import_id:UUID,context_version:hash64}`; no local Project path/session/device identifier. |
| UploadCreate | `{client_upload_id:UUID,name:string,media_type:string,size_bytes:int,sha256?:hash64\|null,resource_id?:ID\|null}`; display basename, size nonnegative/within actual S3 object capacity; existing version upload allowed to original-uploader/C. |
| PartAuthorization | `{parts:[{part_number:int,size_bytes:int,checksum_sha256:hash64}]}` (part checksum is required in revision3); can be repeated in transport batches; S3 physical part-number/size constraints apply, no total file-count quota. |
| UploadComplete | `{phase:verify\|authorize\|confirm,manifest_cursor?:string}`; single PUT uses confirm only. Multipart phases/checkpoints are §8.1. Never accept arbitrary client bucket/key/version/uploadId, ETags or completion XML as proof. |
| DownloadCreate | `{version:int}`; pinned logical version; authorizes separate ephemeral download envelope. |
| PRSync | `{provider:github\|stash,repository_ref:string,external_pr_ids?:string[]}`; all provider-side pages fetched in resumable sync operation if necessary; no provider token/URL supplied as an SSRF target. Only configured provider/repository identifiers resolve to allowlisted HTTPS hosts; redirects cannot escape that allowlist. |
| ConversionCreate | `{client_conversion_id:UUID,mode:root\|subproject,existing_parent_id?:ID}`; subproject mode requires existing active assigned Team root and current P, never creates an orphan child. |
| ConversionItem | `{client_item_id:UUID,node_key:UUID,kind:node\|task\|member\|resource,payload:matching typed object}`; node payload=ProjectCreate for the sole root node; child node payload=ChildCreate plus required parent_node_key in root mode (or the existing parent from the session in subproject mode). Both node kinds allow progress_status?:enum6, progress_note?:string, source_created_at?:Time. Task payload=TaskCreate plus status?:enum4; member={user_id:ID} on root only; resource={name,media_type,size_bytes,sha256?}. No session/chat/code/diff/arbitrary metadata/local path. |
| ConversionControl | seal/prepare/commit `{}`; cancel uses CancelBody; no silent plan mutation after seal. |
| CancelBody | `{reason?:string}` for conversion/upload cancellation; no persistent raw-reason storage is promised for cancellation; record reason_supplied:boolean only in safe audit, never echo raw text into logs. Project deletion uses the distinct stored LifecycleBody reason. |

`ContextItem`/discussion text accepts arbitrary user-written text under warn-only rules. Conversion is a strict explicit export DTO and never reads local execution stores. Schema/routing validation does not claim to semantically recognize every disguised secret or transcript embedded in a string (Q-CONTENT).

## 7. Frozen comments, mentions and warn-only discussion contract

### 7.1 Wire grammar, parsing and storage

Typing @ opens the existing root member endpoint with name/email search. Selecting a result generates `@[Display Name](user:23)`; users are never asked to type or understand wire tokens. Plain `@name` has no mention semantics. A literal opener is `\@[` in decoded text (`\\@[` in a JSON source string). Odd preceding backslash parity escapes the opener; even parity leaves it parseable. Rendering removes the one escaping slash and treats the entire escaped token-like span as ordinary text.

A token uses1–100 Unicode display characters, excluding `[`/`]`/CR/LF, and a positive base10 identity User ID with no sign, decimal point, leading zero or whitespace. Reject unescaped malformed token-like openers for the whole request with 422 `INVALID_MENTION`, no partial rows and no malformed input echo. Rejected examples: `@[Name](user:abc)`, `@[Name](user:)`, `@[Name](user:0)`, `@[Name](user:-2)`, `@[Name](user:023)`, `@[Name](user:2.0)`, `@[Name](user: 23)`, an unclosed bracket/parenthesis, empty/overlong/bracketed/newline label, or missing `(user:...)` following an unescaped `@[`. These are structural errors, not semantic censorship. Plain ordinary @ and escaped examples remain valid arbitrary discussion.

Before commit, parse decoded LF/NFC text, deduplicate by user ID, validate current G against the node's root and canonicalize new token labels from the current User display name. For canonical new labels, use NFC(current display_name), replace `[`/`]` with fullwidth `［`/`］`, replace CR/LF with a space, and trim surrounding whitespace. If that yields empty or more than 100 Unicode scalar values, apply the same transformation to identity user_name (the existing bounded stable field). Reject an impossible invalid fallback as a service-integrity503, never trust the supplied label. Existing immutable token labels are not recanonicalized on edit. Never identify someone by label. At most10 distinct mentioned users and20 occurrences; content1–4,000 Unicode characters and≤16,384 UTF-8 bytes, whitespace-only invalid. These are **owner-frozen O§7 bounds**, not pilot guesses. Recheck bounds after canonical substitution. New invalid/former/non-Team/other-root mentions422 atomically; no client mentions array is accepted.

Reject lone Unicode surrogates before normalization; a character means a Unicode scalar value, not a UTF-16 code unit or grapheme cluster. Apply normalization and token validation in that order on backend and consumer. A rename does not rewrite existing discussion on GET. On an actual author edit, currently eligible users are canonicalized to their current label in both text and the structured mention snapshot; revisions retain the prior text. Former-token retention is matched by (User ID, exact token label, occurrence ordinal bounded by the immediately prior version), not unchanged adjacent prose. Editing surrounding prose does not create a new mention. Additional copies, changed IDs/labels and reintroduction after removal are422. Without an edit-operation provenance protocol, the server cannot infer a user's copy/move gesture from two otherwise valid strings; it enforces observable token identity/count and does not claim perfect position provenance. Former chips must remain immutable in the client editor. No membership is granted by a token.

| Decoded content | Required result |
| --- | --- |
| `Please review @[Chen Chang](user:23)` | One structured user23 mention; chip Chen Chang (canonicalized to current display label at creation). |
| `Please review @Chen Chang` | No relation, ordinary text. |
| `Please review \@[Chen Chang](user:23)` | No relation; display `@[Chen Chang](user:23)` as ordinary text, not a chip. |
| `Please review @[Chen Chang](user:abc)` |422 INVALID_MENTION; no comment/mention/revision/audit mutation. |

The Comment DTO includes structured Mention objects and canonical content. The consumer renders from these IDs and token positions, not by fetching a profile using a name. Current chips navigate to the **root Project member list** with the selected user ID; no separate member profile page is assumed. Former chips preserve original label, are not clickable and never initiate a current-member lookup. An unknown/unmatched structured ID is rendered inert, never as an active member chip. A child uses exactly its parent's picker/list; no child roster API.

“Mentioned me” means current visible Project nodes where a current `comment_mentions` relation has mentioned_user_id=actor and status=active, comment not deleted, and the actor currently has P. It is not unread. Another active user's ID can filter within an already-visible node only; it cannot expose another node. Removing a member changes access/candidate flags, not historical text. A new comment cannot mention them; explicitly re-adding later can restore current eligibility without rewriting historical labels.

### 7.2 Persistence, warnings, replies, edit/delete

Any code, diff, pasted discussion, transcript-like passage, HTML-looking text or other user-selected comment text is supported within the structural schema/mention/length bounds. Store it, never execute it; clients escape raw HTML/URLs appropriately and may render code blocks as inert text. No content rejection code or secret-detector503 is permitted for comments, progress notes or other discussion fields.

Best-effort local pattern detection produces only generic warnings:

```json
{"warnings":[{"type":"possible_secret","message":"This comment appears to contain a credential or token. Consider removing it."}]}
```

A detector exception/unavailability returns `validator_unavailable` with “Secret-pattern checking was unavailable; review before sharing.” and **the write still commits**. No external scanner/LLM is silently added. There is no complete DLP guarantee, warning approval, automatic deletion, dropped text or log of the matching substring. A normal DB failure can still fail the operation; the client retains its draft and retries with the same operation key. A validator failure alone must never lose the comment. Warnings do not contain text/offsets or create a later public warning side channel. A repeated actor-owned operation can return generic warning types, not stored secret snippets.

Replies remain flat, one level, parent must be a nondeleted root in the same node; inherit its zero/one task/PR/resource link. Reply-to-reply or mismatching anchor422. Author edits only, with comment version; creator cannot rewrite another person's words. Edited DTO always has is_edited=true and edited_at; no public revision-diff endpoint. Author or C soft-deletes while node writable; old content/revisions remain restricted, normal APIs and Context emit tombstone only. Existing replies survive root deletion. Deleted roots cannot receive replies/edits (409 COMMENT_DELETED). Newest-first creation/id keyset; AND-combined filters for task/pr/resource/author/mentioned/parent; edits do not move chronology.

### 7.3 Complete-Context exclusion conflict, stated explicitly

O§4.2 and C§3.2 exclude private session/credential/code-diff sources from Context, while O§4.1/8 require complete shared discussion and prohibit rejecting a user-posted secret/code/transcript-like passage. Both cannot be interpreted as an absolute guarantee that **arbitrary user-authored text** contains no secret/diff. This design follows the new owner decisions: no automatic extraction from session/private-memory/credential stores; strict DTO whitelisting; full user-authored discussion retained, with warn-only semantics. Context therefore can contain user-posted code/discussion and an undetected pasted secret. It never fetches private data or resource bytes to construct Context.

Q-CONTENT asks Rudy to confirm that structural source exclusion, rather than impossible perfect semantic exclusion of manual text, is the intended boundary. It blocks claiming absolute secret-free export/that acceptance criterion, not comment posting or the decided warn-only behavior. If a stricter outbound-redaction review is desired, it requires an explicitly approved new export policy; this design does not silently censor stored comments/progress notes or claim all source statements are simultaneously guaranteed.

## 8. Direct S3 resources and all-or-nothing conversion

### 8.1 Direct upload protocol and honest single-use semantics

File bytes never pass through Lambda. Authorize a current P upload (or current T/session owner conversion upload) through a JSON endpoint. Check declared resource name/type against the owner media policy, allowed action and optional quota. There is no 2 MiB/20-file/product object cap. Resource files are not scanned as comment text; S3 privacy, scoped authorization, optional owner media/quota policy and no Context inlining govern them. Warn-only discussion is not a public-file permission.

`UploadAuthorization={upload_id,version,state,mode,single_put:SignedRequest|null,multipart:{part_authorization_href,complete_href}|null,expires_at:Time|null}`. `SignedRequest={url,method,headers:{string:string},expires_at:Time}`. These envelopes are ephemeral/private/no-store. They are the only exception where S3 URL-encoded host/key/upload identity is necessarily visible to the authorized transport client; no separate bucket/key/version fields appear, and URLs never enter Context/list/log/error/idempotency storage. A presigned URL is a bearer capability, not a permanent link.

Backend generates a unique object key and persists an actor/node-bound upload intent before issuing transport authorization. For a single PUT, sign required headers including `If-None-Match:*` and supplied checksum where available. Do not delete that key while an issued capability can still be used. This yields **one immutable object creation and one metadata publication**, not a fictitious one-use URL: AWS explicitly permits URL reuse until expiry. Later PUT against an existing key fails its condition; an exact retry verifies the existing object. Multipart part URLs may be reused for the same signed part; only a backend-authorized conditional completion request can create the final immutable object; the client sends that signed completion directly to S3 (§8.1). Q-S3 records this required interpretation of O's “single-use”.

Multipart is supported now: initiate server-side, authorize parts in paginated batches, upload parts directly to S3, then backend ListParts verification, backend-authorized direct S3 completion and backend HEAD verification, in resumable phases. The client never chooses the key/raw uploadId, and no 10,000-part array must be sent in one Lambda body. Logical upload_id maps to internal multipart ID. Each part's expected number/size/checksum binding is recorded; backend paginates S3 ListParts and validates all declared parts. S3-supported checksum algorithm/type/value is retained. Do not treat ETag or a composite multipart checksum as full-file SHA256. If an expected full SHA256 was declared, use an actually matching supported verification path. If the chosen multipart/checksum mode cannot verify that full digest without proxying bytes, reject the incompatible declaration before signing with 422 CHECKSUM_MODE_UNSUPPORTED. The client must explicitly revise its request to a supported mode or omit the optional full digest; a sealed conversion requires a new plan/session rather than silently changing its digest. Retain the server-attested supported checksum on completion. Never label a composite result as the declared full digest.

**Multipart completion cannot be promised within one Lambda request.** AWS states that [CompleteMultipartUpload may take minutes and can carry an error in an HTTP200 response](https://docs.aws.amazon.com/AmazonS3/latest/API/API_CompleteMultipartUpload.html). Therefore do not block the 15-second service waiting for S3 assembly, freeze a live background thread after returning, or silently add a worker/queue/service. E47 has these exact client-driven phases:

1. `verify`: atomically seal the declared part manifest so no new part authorizations can be issued. Previously signed part URLs retain their documented capability window. Walk ListParts outside SQL locks in deadline-bounded pages, persist observed part ETags/sizes/checksums plus verification_cursor/count/bytes in short authorized transactions, and return action=continue_verification until exhausted. Part numbers must be consecutive from1, every declared part present exactly once, sizes match declaration, non-final part minimums hold, and total bytes equal declared_size. Missing/inconsistent parts409; do not publish or silently omit them. Freeze a canonical manifest hash after complete verification. Clients may retry verify; recorded bindings are immutable and drift is409 UPLOAD_CONFLICT, requiring cancellation/new intent.
2. `authorize`: current actor/action permission, manifest state and digest must still match. Return a page of the sealed CompletionPart manifest and a fresh short-lived SigV4 POST request for this exact backend-created multipart upload with required If-None-Match:*. Manifest pagination is bound to upload ID plus immutable part_manifest_sealed_at/part_manifest_hash, not the mutable Upload.version that authorization bookkeeping can advance; each request still checks current V; no whole-manifest request through Lambda. The client gathers all pages, checks the hash and uses its SDK/XML serializer to send the exact sorted manifest directly to S3. It must parse the full S3 response body, not trust HTTP200 alone; network timeout means unknown result, not success. Only this explicit authorization response may contain the completion capability/part ETags; never an ordinary status/list/Context response. [SDK presigning](https://docs.aws.amazon.com/boto3/latest/reference/services/s3/client/generate_presigned_url.html) must explicitly use s3v4 so required conditional headers are signed; pinned-SDK presign/manifest/CORS behavior is qualified in T33 before release. Do not handwrite an alternative signing protocol if the pinned SDK cannot support the contract.
3. `confirm`: ignore client claims of S3 success. HEAD the immutable backend-selected key (with checksums/pinned object version where supported), check actual size and required checksum, then reauthorize in SQL and publish exactly once. A complete object after a lost response can be confirmed without reassembling; an absent/in-progress object returns409 UPLOAD_NOT_READY with retryable state. Persist no client-provided version/URL as proof. A new authorized completion envelope may be issued by authorize if the previous one expired; it never bypasses the frozen manifest or current permission.

Each successful E47 step uses its own K and current Upload V; uncertain retry uses the same K, then GET current UploadState before the next phase. A matching K replay returns current safe state and can regenerate a capability only after fresh authorization; it does not restart already completed network work. The Lambda's own deadline governs verification-page work only, not a product part/file limit. Single PUT skips verify/authorize and uses confirm after upload. Conversion uploads stop at verified until conversion publication; ordinary Project uploads become published only with resource metadata. No Lambda invocation must stay alive while the client completes S3 assembly.

After direct upload and the applicable completion phases, network verification is outside SQL locks; the service then locks/rechecks current P/T, session/intent version, size/checksum/object identity and writes resource/version metadata in a short transaction. Permission loss rejects publication even if a private object already exists. Resource ownership for every version/lifecycle write means the immutable original uploader `project_resources.created_by_user_id` or current C; it never silently switches to the uploader of the latest version. Recheck that specific action permission on each upload authorization/part/verify/authorize/confirm call, including after creator transfer. Resource.created_by uses the first immutable version uploader snapshot when the original User is former; Resource.uploader names the selected version uploader. Existing-resource version upload is original-uploader/C only; any P may create a new resource. New version does not overwrite prior immutable bytes. Each version stores its own display name, type, size, checksum, uploader and time; current resource name is a convenience mirror updated only when publishing a version. Version-list/download/text projection uses the pinned version metadata, never the latest name for all old versions. Resource metadata archive/delete is original-uploader/C, soft only; prior versions/S3 references remain under retention.

### 8.2 Actual platform limits and downloads

As consulted 2026-11-03, [S3 multipart specifications](https://docs.aws.amazon.com/AmazonS3/latest/userguide/qfacts.html) document maximum object48.8 TiB,10,000 parts, part5 MiB–5 GiB with no minimum for the final part, and1,000 parts per ListParts response. These are platform facts to revalidate against deployed support, not invented quotas. Use multipart whenever a single PUT cannot represent the object, and allow resumable parts below that boundary. Actual S3/network errors map to `STORAGE_LIMIT_EXCEEDED`/`UPLOAD_CONFLICT`/503 safely; do not claim unlimited physical object size. No product file-count or aggregate storage quota exists unless Rudy later approves one with a numeric policy/error.

Download: `POST .../resources/{id}/download-authorizations` with pinned logical version checks current P and returns `DownloadAuthorization={resource_id,version,request:SignedRequest}` for short-lived GET. Do not stream arbitrary resource bytes through Lambda or store the URL in Context. TTL and URL/session retention are required owner-supplied security configuration, not guessed defaults. Backend calls made after revocation are denied. An authorization already issued is usable until its effective expiry, and an already-started S3 transfer may finish.

**Q-S3 security boundary:** S3 cannot consult current MySQL membership on every later direct GET, and a presigned URL is not individually revoked by a SQL removal. Thus literal denial of a later S3 request using a previously issued still-valid URL cannot be promised. Owner must accept authorization-at-issuance with a measured short TTL, or approve a different delivery gateway/revocation design. This is explicitly not hidden behind “already authorized”; no claim of native instant URL revocation/single-use is made. [AWS presigned URL behavior](https://docs.aws.amazon.com/AmazonS3/latest/userguide/using-presigned-url.html) and [conditional writes](https://docs.aws.amazon.com/AmazonS3/latest/userguide/conditional-writes.html) support this distinction.

### 8.3 Conversion with explicitly selected SubProjects

Linked copy retained: original local Project/sessions remain local; cloud gets a distinct Team node and local consumer stores the link only after publication. Local ownership enforcement belongs to the local consumer; server verifies Team/create authority and plan policy, not an invented local-owner proof/key/claim.

Root conversion optionally includes **explicitly selected** immediate children. Unselected children/files are never inferred. Independent child conversion requires its parent already be an active assigned Team root where converter has P; no automatic parent creation or child without a Team parent. Root initial membership is selected from current Team users and includes converter/creator; child selection has no members/category/creator override. Child authority/owner derive from root, including an existing parent in child mode.

Conversion can carry selected qualitative progress status/note; the cloud author is the converter, with a new server write time. The new Team node has its own created_at; optional source_created_at is self-reported source provenance stored in projects.source_created_at and returned as nullable metadata, not a claim that a cloud row existed earlier. Normal ProjectCreate/ChildCreate never accept it; absence remains NULL. Source lifecycle/roles are not copied: new nodes start active and assigned under the applicable root.

The conversion plan is appended as typed item records across as many transport requests as needed, then sealed by a canonical ordered digest. At seal, resolve and persist the actor epoch in project_conversion_sessions.sealed_actor_team_membership_id and each selected root member epoch in project_conversion_items.validated_team_membership_id. The implicit creator is included in this validation, even if not supplied as a member item. In subproject mode the actor epoch is pinned, while the full inherited roster is live-derived from the existing root, not cloned into the plan. Prepare/commit require those same active epoch IDs and include them in the sealed digest; a remove/rejoin between seal and prepare cannot silently bind a new epoch. User IDs alone are not proof of a sealed grant. No whole-plan2 MiB/1,000-task/100-member/20-file quota. Each resource obtains its own direct upload authorization and verification. Task drafts may preserve explicit four-state status, but driver/assignee mappings must target the selected/inherited current grant set. Conversion excludes local session/chat/tool/code/diff payload fields, local paths, arbitrary metadata and unselected files. Personal comments/decisions/questions are not silently copied: this revision's strict selected conversion DTO is name/background/goals/tasks/progress/resource descriptors and explicit selected child nodes, not an unchecked full local object. Incoming unsupported local discussion history is rejected structurally, not scanned/censored as a comment.

**Unbounded plan preparation and one publication fence:** a large plan cannot be materialized in one 15-second request. After seal, the owner-controlled client invokes resumable prepare batches. They create private staging Project/root-member/task/resource rows with root published_at=null; these rows are never visible through Project/member/Context/Dashboard routes. Prepared row IDs are internal and natural item IDs prevent duplicates. No file bytes enter SQL. In root mode, preparation may set each child published_at to its preparation time, while the root stays NULL: reads require both timestamps, so the whole tree remains invisible. Commit updates only the root publication fence, not an unbounded set of child rows. An independent child has its own NULL published_at until commit and must also have its existing root published. All prepared child events/resources remain hidden by the same predicate.

Commit rechecks plan digest, all item preparation, all selected-resource verification, current Team/parent/member eligibility and identity epoch bindings under Team/root/session locks using set-based EXISTS checks. If any changed/missing item is found,409 and no visible node. It atomically sets exactly one publication timestamp (new root in root mode, new child in subproject mode), committed session and safe audits; no partial visible root/child tree, no resource silently omitted. A required member epoch change requires a new explicitly reviewed plan/session rather than silently restoring a stale grant. Publication-state fencing is orthogonal to lifecycle and is not a fourth lifecycle status.

This updates revision 1's single-request materialization to multi-request **invisible preparation plus atomic publication**, preserving its all-or-nothing public guarantee without arbitrary collection caps. Any failed/missing selected upload prevents commit. An abandoned session may be cancelled; private staging/object cleanup follows approved retention. Same client_conversion_id/digest recovers a committed result once, even after operation-key retention; changed plan409. Every CV and associated upload operation, including status reads, authorization regeneration and cancellation, rechecks current T and the session actor; subproject mode additionally rechecks P(existing parent), with writable active/assigned parent required for mutations. After commit, every session/upload/replay path revealing the resulting Project or resources also requires current P(result), and no new plan/preparation/upload mutation is allowed. This common gate applies to E14–E16, E45–E48 and E59–E62 even where a row abbreviates it.

### 8.4 Storage races and cleanup

SQL and S3 are not a distributed transaction. Timeout after PUT/complete may leave an object without metadata; retry HEAD/ListParts and intent identity, never duplicate publication. No S3 network call runs while domain locks are held. Owner policies prevent overwriting/deleting verified in-flight keys; otherwise resource commit is blocked by Q-STORAGE configuration.

`cleanup_teamwork_staging` is an approved operator job, real actor and audit. It first makes expired/cancelled sessions noncommittable in SQL, then aborts multipart/deletes only exact uncommitted object/version identities outside those locks, then records outcome. Never clean a committed Project/reference or act before outstanding capability expiry plus the owner's quiescence policy. Late writes are found by repeated complete prefix/intent inventory sweeps, not a one-time first-page scan. Batch sizes are runner work units, not file/project quotas. Keep identities until approved retention allows purge. Schedule/backlog SLOs and expiry values are Q-RETENTION/Q-STORAGE, not a fabricated24-hour default. No new cleanup Lambda or bucket is created by this design.

## 9. Complete Project Context, coherence and import

### 9.1 Field/storage/read/write/import/conversion map

Select **the full paginated comment collection by default** (O§4.1 option a). The manifest includes a first page and the authenticated continuation reference; callers import all pages, including tombstones. No include-comments opt-in and no comment omission/summary substitution. Parent Context includes SubProject summaries and links to their independent complete Context, never duplicates their work collections. A child imports independently; root import does not automatically recurse into child work unless the local user explicitly selects those separate Contexts.

`ContextManifest={schema_version:"2.1-r3",project:ContextProject,context_version:hash64,observed_at:Time,sections:{section:Collection},import_mode:"read_only_context"}`.
`ContextProject` includes SharedProjectSummary plus background/goals. Context SubProject items are SharedProjectSummary, never ProjectSummary; no viewer/capabilities are nested into a shared page. `Collection={items:typed[],next_cursor:string|null,has_more:boolean,href:string}`; section names are tasks, subprojects, members, prs, resources, decisions, open_questions, comments, progress_history and activity. A child has an empty subprojects section and an inherited members section sourced from the root. There is no child member-management/list HTTP API; Context is a snapshot of its inherited display data. `ContextPage={schema_version,project_id,context_version,section,items,next_cursor,has_more}`.

| Context field / type | MySQL source / byte rule | Read / write | Import / conversion |
| --- | --- | --- | --- |
| id/name/scope/team name/category/parent/creator/created_by/created_at/source_created_at/status/ownership | projects + categories + identity display snapshots/current eligible labels; effective root fields derived | P reads; C name/category/lifecycle; member creates child; inheritance fixed | Import yes; conversion creates new IDs/time/owner/scope, optional source creation provenance, no copied grants |
| background/goals: TextValue | projects.background/goals LONGTEXT, full text via inline or fragments | P reads/writes while writable | Import full; explicit conversion node DTO |
| tasks: Collection<Task> | own nondeleted project_tasks, no parent task duplication | P reads; task driver/assignee/C matrix B00-T | Import yes; explicit task drafts/mapped current members only |
| subprojects: Collection<SharedProjectSummary> | immediate nondeleted child rows/current effective state | P reads; P creates, root C lifecycle | Import summaries; independent selected child import/explicit conversion only |
| progress: Progress | projects status/note/author/time; append-only progress events | P reads; **any P** explicit write; archive/orphan frozen | Import yes; selected qualitative fields on conversion; no numeric substitute |
| task_counts: TaskCounts / last_activity_at | shared projection, own tasks and relevant shared lifecycle/member activity | P reads; never client-edited counts | Import yes; recompute from selected cloud tasks, never import count grants |
| members: Collection<Member> | root grants joined to current identity epochs/User labels, added-by/joined time | P reads; root C manages | Import display only; selected initial root members freshly checked, inherited child members never supplied |
| prs: Collection<PR> | mirror/reviewer tables, synced_at; no provider content | P reads/manual sync through configured provider | Import metadata; not copied implicitly by conversion DTO; register/sync separately after publication |
| resources: Collection<Resource> | logical metadata/versions, uploader/time/checksum/backend download path; **bytes only S3** | P reads/new upload; original-uploader/C metadata/version changes | Import metadata/ref, bytes not automatic; explicitly selected conversion files direct-uploaded |
| decisions: Collection<ContextItem> | typed decision rows/revisions with title/context/body/status/time/author | P creates/reads; author or C edits/status with version/history | Import full current data; not silently copied by strict initial conversion DTO |
| open_questions: Collection<ContextItem> | typed question rows, status=`open\|answered\|closed` and answer; no inferred text | P creates/reads; author or C edits | Import full; new conversion starts empty unless later explicit normal actions add entries |
| comments: Collection<Comment> | own full current comment rows/relations, edited label/time, deleted tombstones | P reads/posts; author edits, author/C delete | **Import complete paginated collection**; personal discussion history not silently converted |
| progress_history/activity | own events plus authorized inherited lifecycle/member/owner references | P reads; service appends only | Import yes; no private revision originals/audit secrets |

No file bytes, raw S3 identities/capabilities, personal-memory data, local credentials/paths, session objects, execution logs or tool/source-provider payloads are automatically accessed by the serializer. Root/child member role labels are descriptive only. Restrictions on manually authored discussion are exactly §7.3/Q-CONTENT, not a hidden outbound content blocker.

### 9.2 Actor-independent version

`context_version=SHA256(canonical(schema_version,node_id,node_context_revision,team_id/current_team_name,parent_id/current_parent_name,effective_lifecycle/effective_category/effective_owner,root grant epoch set,eligible User IDs/current display names/emails,shared aggregate inputs,immediate_child_shared_digests))`. Use a stable canonical sort by IDs and explicit NULL representation. Include the relevant shared root fields only; parent comment/task edits do not invalidate a child's independent work Context. Category/Team rename and valid-member display changes do invalidate affected versions through actual display data. A root includes ordered `(child_id,child_shared_digest)` for every visible nondeleted immediate child because Context contains their summaries/versions; a child includes only the parent reference/shared inherited fields, never the parent Context hash. This is acyclic: child edits can invalidate the parent summary-containing Context, but an unrelated parent task/comment edit does not invalidate the child. Context child summaries contain no actor overlays.

Use current eligible User display_name when nonempty, else user_name; former authors/owners/assignees use their retained creation/assignment snapshots. Never fetch an unrelated former User’s newly edited private profile to decorate historical Context. No requesting actor ID, requester epoch, token_version, viewer mention count, reviewing-me count, capabilities or observed_at enters this hash or shared Context fields, including nested SubProject summaries. Two authorized members receive comparable identical versions/shared data. Unrelated User/profile edits do not change it. Current actor authorization is checked separately on every request. Every projection carries the same shared version to disambiguate unchanged child entity version versus changed inherited member/lifecycle display.

Use a per-request REPEATABLE READ projection session. Resolve immutable node→root IDs using a separate preflight lookup with no retained entity data, then in the new RR session lock current actor User, Team, root and node in order using shared current reads and revalidate A/T/P. Only after those checks establish the first nonlocking consistent-read snapshot; no earlier ordinary SELECT in that RR session may pin an obsolete snapshot. All projected collections/hash inputs come from that one snapshot. No preflight result grants access. Shared lock order prevents domain mutations/removal crossing the request authorization boundary; nonlocking snapshot queries provide coherent content/labels/aggregates. Identity global engine's READ COMMITTED default is not changed. Never hold one database transaction across client page requests or claim a snapshot remains open in a warm Lambda.

Each continuation supplies Context hash If-Match; reauthorize/recompute and return409 `CONTEXT_CHANGED` on drift. Cursor includes node/section/filter/order/last ID and expected hash; tampering/scope mismatch422. If-None-Match is an optional quoted Context hash only on the initial manifest request (no section/cursor). Return304 only after current authorization and a matching hash; continuations always use H and return their page or409, never a cache304 without cached page data. Read creates no domain row or audit event. A read-only Context hash is not an authentication token or grant.

### 9.2.1 Exact revision and snapshot invalidation rules

A successful own-node shared-content mutation (Project info, task, progress, PR mirror, committed resource metadata, comment, decision/question, lifecycle or ownership/member history) increments projects.version and context_revision once and updates updated_at/last_activity_at in the same transaction. Also increment the affected entity's own version. A no-op/idempotent replay increments neither. Root member/lifecycle/ownership changes additionally advance their specific shared timestamps; children inherit those values/hash inputs without fan-out version writes. Creating/deleting a child changes root structural revision; editing a child's own work does not touch root task counts or stored root activity, but its digest changes the parent summary-containing Context hash. Identity/category/Team display changes are derived hash inputs, not writes performed by GET. Import receipts, download authorization, staging/verification checkpoints, warning generation, safe audits and idempotency bookkeeping do not change shared Project progress/activity/revisions until a domain publication occurs.

For a coherent Team list/Dashboard, use SQL visibility joins/grouped aggregates/keyset pages, not Python materialization of every Project/task/comment or one query per row. Aggregates and items in one response share one RR observation. Ordinary live list cursors do not promise a stable whole-Team snapshot across requests; observed_at and per-node context_version identify that distinction. Context continuations do require H and restart on drift. No cross-endpoint formula or cache may return different shared facts at the same node hash.

### 9.3 No aggregate size cap, bounded transport and no livelock

There is no total Context byte/row/task/member/comment limit and no CONTEXT_EXPORT_LIMIT error. Collections are fetched to exhaustion. A positive `limit` query is a page hint, not a maximum collection size or reason to reject large Projects. The server reduces a page to a physical response envelope budget and returns a continuation; no row is silently omitted.

[Lambda synchronous invocation](https://docs.aws.amazon.com/lambda/latest/dg/gettingstarted-limits.html) currently limits ordinary request/response payloads to 6 MB (AWS uses1024-based units); owner Gateway integration also has its own actual limit. Implementation measures the **serialized proxy envelope**, not just character count, against the lesser effective deployed transport limit. A1 MiB response target is a transport packing profile below that envelope, not a Context/export limit. It may change without changing the complete logical collection. Input envelope over the actual transport limit is 413 `PAYLOAD_TOO_LARGE`; callers send more plan/page requests instead of exceeding a single request.

A large single LONGTEXT field is returned as a TextRef and retrieved through the version-checked text continuation endpoint using SQL substring reads/UTF-8-safe chunks, not by loading it all into one response. Full import reconstructs it. LONGTEXT's physical capacity is 4,294,967,295 bytes; actual DB packet/network configuration can impose a lower single-write bound and must be recorded by the database operator. Comment fields have the separate owner-frozen4,000-character limit. Other VARCHAR storage capacities are declared schema choices, not falsely advertised as global platform limits. Strict SQL mode prevents truncation. No total Context is rejected because it exceeds one page.

If a page changes version, discard partial assembly and retry from the first page with jittered exponential backoff; client performs at most three immediate restart attempts (1/2/4-second base delays), then pauses import with `CONTEXT_CHANGING` and preserves the last complete local snapshot/draft. User can retry later; no infinite background restart loop, automatic partial import or total-size rejection. This is a client retry policy, not a Project size quota or promise of a stable export during endless concurrent edits. Future durable snapshots would require a separate explicitly approved export operation, not a hidden write during GET.

### 9.4 Import receipt and local boundaries

Any P can import an active or archived node's complete Context into local scope. Import is a historical **read-only Context import**; no automatic progress/task/comment upload or transcript sharing. Explicit later ordinary mutations require fresh P and the corresponding driver/assignee/creator checks/version/key. Local Project/session execution and Personal Agent memory remain outside this backend.

After all pages/large text are assembled under one version and committed locally, POST a receipt with random local_import_id and Context version. Current P/version checked again; receipt/audit are atomic. Receipt records no local path, session ID or device identity and grants no access. Same natural actor/import ID with different node/version409; exact authorized replay returns own receipt. Failed receipt does not roll back a local copy. If access is lost, cached cloud link becomes unavailable under the grey rule while local sessions keep working. No local Memory migration or compatibility shim is designed.

## 10. Dashboard/list/detail and shared aggregate consistency

### 10.1 One projection implementation

`project_projection(node,RR_snapshot)` builds shared status/qualitative progress/task/PR/resource/comment/open-question/member counts and current Context hash; `viewer_facts(actor,node)` adds only the explicitly actor-scoped facts. The same builder is used by list, detail (the Project Dashboard), Team Dashboard items and Context. No endpoint has its own denominator/count definition, stale materialized roster or cached ACL.

A node counts **only its own** task/PR/comment/resource/question rows; children count independently. Root and child member count are the same inherited root count. Team aggregates enumerate each visible node exactly once: no double-counted child tasks through a parent roll-up. `total_visible_projects` includes roots+children, with separate root/subproject counts; distributions are labelled by node count. Task counts include all nondeleted own tasks, archived task rows included. PR counts are exact open/merged/closed rows. Comments include deleted tombstones in total, but mention count excludes deleted comments/removed relations. Open questions count kind=open_question/state=open/deleted_at=NULL. Resource count is nondeleted committed logical resources (not uploaded versions). For each open PR, only is_current=true reviewer rows participate; a mapped actor reviewer is counted once regardless of duplicate provider identities. `reviewer_mapping_complete=false` if any counted-scope open PR has unresolved reviewer data; `open_prs_reviewing_me`/`open_reviewing_me` then means the known mapped count (a lower bound), not a verified complete zero. Consumers show that explicit incompleteness. An empty PR set is complete with zero; no reviewer IDs are fabricated. The shared PRCounts flag and actor overlay use the same scope.

Child last_activity_at is the maximum of own content activity and inherited root membership/ownership/lifecycle change times; parent ordinary task/comment changes do not appear as child activity. Parent task/PR completion never updates a child's qualitative status or the parent's qualitative status. All six-status changes are explicit P actions and append progress event plus safe audit, old/new status/note author/time/version.

### 10.2 Queries and stable sort

List/Dashboard share normalized filters: `category_id` positive ID or `none`; `status=active|archived|all` (default active); `progress_status=enum6` optional; `blocked=true|false` tests own blocked task count (qualitative blocked uses progress_status separately); `needs_pr_review=true|false` tests current review assignment on open PRs; `mentioned_me=true|false` tests active own mention relations; `created_by_me=true|false` uses effective creator; `q` literal server-side substring across node name/own task title/current eligible member name or email; `view=category|time`. All combine with AND **after** current visibility restriction. Trim q; empty q means absent; escape `%`, `_` and backslash so search is literal under utf8mb4_unicode_ci, never a regex or interpolated SQL expression. A category_id filter must name a nonretired category containing at least one root visible to this actor (otherwise422 INVALID_FILTER, identical for hidden/unknown labels); retired roots match none. No cross-Team category details are returned. Missing flag means no filter; false is its complement among visible nodes. needs_pr_review tests known mapped assignments only; reviewer_mapping_complete exposes incomplete mapping rather than claiming an unknown assignment does not exist. Invalid enums/IDs/cursor422; no hidden object existence feedback.

Root-list entries expose parent summary and child-list href/count, not a truncated unbounded child array. Category sort: category creation/id ascending, No Category last; inside group root last_activity_at descending, created_at descending/id descending. Time sort: root created_at descending/id descending. SubProject list: own effective activity descending, creation/id descending. Applying a work filter includes a root group if root or any visible child matches; `self_matches:boolean` plus `matching_subproject_count` distinguish a container from a matching own node. The child list applies the same filters, so users can retrieve every matching summary. Team aggregate totals count matching nodes, not unmatched container rows. Query scope/filter fingerprint is bound to cursors.

No hidden Projects are included before filtering/pagination/counts. Team403 returns no partial aggregate or zero-count success. Category list includes only labels with at least one actor-visible root, with no private Project occupancy count. Empty/inaccessible labels are omitted even for their author; a create response still returns its new label for immediate use. Retired categories are grouped under No Category without testing hidden occupancy.

### 10.3 Complete Dashboard DTO

`TeamDashboard={team_id:ID,scope:"team",filters:FilterEcho,observed_at:Time,aggregates:TeamAggregates,projects:Page<GroupEntry>,recent_activity:Page<Activity>}`.

`FilterEcho` has exactly the normalized optional fields in §10.2 (null for absent flags) plus view. `GroupEntry={category:CategoryRef|null,project:ProjectSummary,self_matches:boolean,matching_subproject_count:int,subprojects_href:string}`; items follow the stable grouping order. The projects endpoint returns `ProjectList={team_id,filters,observed_at,projects:Page<GroupEntry>}` with the same fields/order/visibility, not a competing summary shape.

`TeamAggregates={total_visible_projects:int,root_projects:int,subprojects:int,created_by_me:int,by_category:[{category:CategoryRef|null,total:int,roots:int,subprojects:int}],by_progress_status:{not_started:int,in_progress:int,blocked:int,in_review:int,completed:int,on_hold:int},by_lifecycle:{active:int,archived:int},tasks:TaskCounts,prs:{open:int,merged:int,closed:int,open_reviewing_me:int,reviewer_mapping_complete:boolean},comments:{total:int,mentioning_me:int},open_questions:int}`.

`created_by_me` means current effective creator, not the member who happened to create a SubProject. No read/unread model or percentage-like aggregate exists. Recent activity includes latest progress and comment events plus safe lifecycle/reference events, with node/actor/type/time and pagination, never hidden content. `GET /dashboard/activity` supplies subsequent activity pages with the same filters; parent/child identical inherited event IDs are deduplicated in Team activity, not multiplied into “work done”.

Project detail **is** Project Dashboard. It returns ProjectDetail including complete facts/progress and a first page of child summaries plus continuation. It has no separate overlapping `/projects/{id}/dashboard` route. Same shared Context version implies identical shared counts/progress/last activity between endpoints; different RR observation versions can differ legitimately and are identified. Viewer-specific review/mention counts and capability flags are labelled overlays and excluded from shared version comparison. There is no cache TTL used to excuse differing shared numbers at the same version.

## 11. Endpoint-by-endpoint frozen contract

### 11.1 Common headers, queries, results and errors

All routes are private-stage `/api`. `R=/api/teams/{team_id}/projects/{project_id}`, `CV=/api/teams/{team_id}/conversions/{conversion_id}`, `U=/api/teams/{team_id}/uploads/{upload_id}` below are **literal path expansions**, not additional endpoints. `root_id`/`child_id` in a path are the corresponding Project IDs. All child-capable R routes resolve actual parent and inherited P/C before proceeding.

Bearer/401 applies to every route. E01 retains identity 1.1 response/error/header behavior unchanged; the new Team Work error/DTO registry below applies to E02–E63. Team403 and node404, entity-scope404, action403, read-only/state/version409, structural422, transport413, approved rate429 and unavailable503 are the frozen common failures. Rows below add specific failures; they do not suppress common errors. No failed auth/current-access check returns stale cached body/URL. Domain writes and their audits are atomic except the explicitly separated S3 I/O phases.

`K`=required Idempotency-Key UUIDv4 on mutations; `V`=If-Match quoted integer of the named entity; `H`=If-Match shared Context hash on Context continuation/text checks; E12 submits context_version in its body, not a separate header. Missing/malformed required header422. Identical committed K is handled after fresh access check but before applying a new stale-version check; no old comment/Project content or URL is replayed after access loss. Deleted Project404 has priority even over a matching prior delete key. Empty patch422; unchanged scalar updates are200/no new event.

`Q`=limit positive integer page hint/cursor optional, no hard total cap; all lists return Page<T>. Task query adds status(enum4), lifecycle_status=active|archived|all(default all nondeleted), assignee_user_id optional. PR sync adds optional continuation query bound to the original normalized request and server mirror operation; a resumed step uses current returned Project version/new step K. PR query adds status=open|merged|closed|all(default all), reviewing_me optional, sort=open_first|recent(default open_first; then synced_at/id descending). Resource query adds status=active|archived|all(default all nondeleted), sorts updated_at/id descending. Item query adds kind/status; progress history/activity newest-first(time,id). Comment query adds task_id/pr_id/resource_id/author_user_id/mentioned_user_id/parent_comment_id and order=newest|oldest(default newest); combine AND. Member query adds search(name/email literal), user_id exact; joined_at/id ascending, creator highlighted but not a permission-sort shortcut. Scope/filter/order fingerprints bind cursors; mismatch422.

`Receipt={receipt_id,project_id,local_import_id,context_version,imported_at}`. `ConversionSession={id,client_conversion_id,team_id,mode,existing_parent_id,status,version,plan_digest,counts:{nodes,tasks,members,resources,verified_resources,prepared_items},next_prepare_cursor,committed_project_id:null|ID,created_at,updated_at,expires_at:null|Time}`; committed IDs require current P. `ConversionItemResult={id,client_item_id,node_key,kind,session_version}`. `PreparationResult={session:ConversionSession,prepared:int,next_cursor:null|string}`. `SyncResult={state:running|completed,continuation:null|string,updated_prs:int,project_version:int}`. `UploadState={upload_id:ID,client_upload_id:UUID,state:pending|uploading|verifying|awaiting_completion|verified|published|failed|cancelled|expired,version:int,declared_size:int,verified_size:int|null,verified_parts:int,manifest_hash:hash64|null,checksum:Checksum|null,resource_id:ID|null,resource_version:int|null}`. `CompletionPart={part_number:int,etag:string,checksum:Checksum|null}`. `UploadCompletion={upload:UploadState,action:continue_verification|complete_s3|done,manifest:Page<CompletionPart>|null,manifest_hash:hash64|null,request:SignedRequest|null}`; manifest/request appear only in an authorized E47 authorize response. The manifest hash is SHA256 of canonical sorted `(part_number,etag,checksum algorithm/type/value)` tuples; no raw bucket/key/upload ID is a separate field. For a conversion intent before commit, UploadState.resource_id/resource_version are always null even if preparation has internal rows; after publication they require current P(result). `PartAuthorizationPage={upload_id,items:[{part_number,request:SignedRequest}],next_cursor:null|string,has_more:boolean}`. `ResourceVersionPage` items use Resource fields for the pinned logical version. All these fields are typed by the registry/common types; null fields never imply an access grant.

| E | Method/path | Permission / exact request & headers | Transaction/audit | Response / extra failures | Tests |
| --- | --- | --- | --- | --- | --- |
| E01 | DELETE `/api/teams/{team_id}/members/{member_id}` | Original identity authority and guards, member_id=identity row; existing identity headers unchanged | I01 atomic helper+cascade, or explicitly chosen fallback§3.3 |204 existing; rollback/no partial204; no global token revocation | T01,T07–T10 |
| E02 | GET `R/members` | P, root only; Q+member query | Live root/identity join; no domain audit |200 Page<Member>; child409 INHERITED_MEMBERSHIP with root link | T03,T05,T20 |
| E03 | POST `R/members` | C, root only; MemberAdd,K,V(Project) | Fresh epoch binding/new row/revision/member audit |201 Mutation<Member>;422 ineligible,409 active duplicate/child | T03,T10 |
| E04 | DELETE `R/members/{project_member_id}` | C/root; K,V(Project), no body | Soft remove/history/derived task flags/root shared revision/audit |204;403 creator self-removal;404 cross-root ID; child409 | T07,T10 |
| E05 | POST `R/ownership-transfer` | C, or PA when effective orphan; root only; OwnerTransfer,K,V(Project) | Current target G; owner/history/audit, children inherit |200 Mutation<ProjectDetail>;422 target not already G; child409 inherited authority | T11 |
| E06 | POST `R/comments` | P/writable; CommentCreate,K | Link/root reply/mentions/content/revision/events/key atomic; warn-only |201 Mutation<Comment>;422 malformed/ineligible mention/anchor;409 deleted parent | T16–T23 |
| E07 | GET `R/comments` | P; Q+comment query | Current/history projection; no audit |200 Page<Comment>, tombstones; deleted omitted for mention filter | T18,T21,T24 |
| E08 | GET `R/comments/{comment_id}` | P; scoped child ID | Read/no audit |200 Comment, including tombstone;404 cross-node | T21,T24 |
| E09 | PUT `R/comments/{comment_id}` | P+author; CommentEdit,K,V(Comment) | Revision/mention/event/key atomic; warnings never veto |200 Mutation<Comment>;403 other author,409 deleted/stale | T17,T19,T22,T23 |
| E10 | DELETE `R/comments/{comment_id}` | P+author or C; K,V(Comment) | Soft delete/revision/event/audit |204; replies remain;409 stale/deleted root edits not permitted | T21,T23 |
| E11 | GET `R/context` | P; section?,cursor?,limit?; H required after first page | RR current shared projection; no domain write/audit |200 ContextManifest/Page, or304 only after authorization;409 CONTEXT_CHANGED | T25–T29 |
| E12 | POST `R/imports` | P; ImportCreate,K; submitted hash validated | Own receipt+audit/key; no local write |201 Mutation<Receipt>,200 authorized replay;409 source version/natural-ID conflict | T30 |
| E13 | POST `/api/teams/{team_id}/conversions` | T; ConversionCreate,K; child mode also P(existing root) | Own session/start audit/key |201 Mutation<ConversionSession>;422 hierarchy,409 reused ID changed request | T35,T36 |
| E14 | GET `CV` | T+session actor; committed also P(result) | Read/no audit |200 ConversionSession;404 other actor/result access lost | T35,T37 |
| E15 | POST `CV/items/{item_id}/upload-authorizations` | T+session actor; resource item only; UploadCreate,K,V(Session) | Intent+audit → out-of-lock S3 authorization |201 Mutation<UploadAuthorization>;409 plan/member/state; never proxy file body | T31–T37 |
| E16 | POST `CV/commit` | T+session actor; ConversionControl{},K,V(Session); existing root P if child mode | Set-based revalidation + atomic publication fence/session/audit/key |201 Mutation<ProjectDetail>,200 current-P replay;409 CONVERSION_NOT_READY/PLAN_MEMBERS_CHANGED | T35–T38 |
| E17 | POST `R/resources/{resource_id}/download-authorizations` | P; DownloadCreate,K; exact logical version | Short current check→out-of-lock presign; safe authorization audit |200 Mutation<DownloadAuthorization>;404 version missing; Q-S3 lifetime caveat | T32,T34 |
| E18 | GET `/api/teams/{team_id}/projects` | T then P(root/children); §10 filter/Q | One visible-node RR projection; no audit |200 ProjectList, no hidden aggregates | T04,T12–T15 |
| E19 | GET `/api/teams/{team_id}/dashboard` | T then P per matched node; same filter/Q, activity cursor? | Shared projection/counts+viewer facts; no audit |200 TeamDashboard; Team403 no partial/zero-count success | T12–T15 |
| E20 | POST `/api/teams/{team_id}/projects` | T; ProjectCreate,K | Root+server creator grant/progress provenance/audit/key atomic |201 Mutation<ProjectDetail>; no client role/creator override | T02,T03 |
| E21 | GET `/api/teams/{team_id}/categories` | T; Q; at least one visible root per returned category | SQL-paged visible labels only; actor-bound cursor, creation/id ascending; no audit |200 Page<Category>, no private occupancy counts; empty/inaccessible labels omitted | T02,T13 |
| E22 | POST `/api/teams/{team_id}/categories` | T; CategoryCreate,K | Category/audit/key |201 Mutation<Category>;409 duplicate active name; B00-C authority review | T02 |
| E23 | PUT `/api/teams/{team_id}/categories/{category_id}` | T+category author; CategoryPatch,K,V(Category) | Label version/audit; Context hash derives updated category display |200 Mutation<Category>;403 other author; B00-C | T02,T27 |
| E24 | DELETE `/api/teams/{team_id}/categories/{category_id}` | T+category author; LifecycleBody(confirm=true),K,V(Category) | Retire label/reference metadata; no hidden-occupancy query; audit |204; no Project deletion/regrant; B00-C | T02,T13 |
| E25 | GET `R` | P; optional subproject cursor/limit | Shared RR projection; no audit |200 ProjectDetail = Project Dashboard | T04,T12–T15 |
| E26 | PUT `R` | P writable, C for name/category; ProjectPatch,K,V(Project) | Allowed fields/revision/audit/key; no partial mixed-field update |200 Mutation<ProjectDetail>;403 field authority,422 child category | T02,T15 |
| E27 | POST `R/subprojects` | P(parent), parent root active/assigned; ChildCreate,K,V(parent Project) | New child/current provenance, no member copies; parent structural revision/event |201 Mutation<ProjectDetail child>;422 fourth-level attempt | T03–T06 |
| E28 | GET `R/subprojects` | P, root only; Q+same work filters | Child summaries sorted§5/10; no audit |200 Page<ProjectSummary>; child422 NOT_PARENT_PROJECT | T04,T13 |
| E29 | POST `R/archive` | C; LifecycleBody{},K,V(Project) | Own lifecycle fence/child affected count/progress event/audit |200 Mutation<ProjectDetail>; same archived no-op; deleted404 | T05,T06 |
| E30 | POST `R/unarchive` | C; LifecycleBody{},K,V(Project) | Restore own state/fence, audit/progress event |200 Mutation<ProjectDetail>; child409 PARENT_ARCHIVED; orphan409 | T05,T06 |
| E31 | DELETE `R` | C; LifecycleBody confirm=true,K,V(Project) | Soft-delete own/descendant effective fence; reason ref/affected count/audit |204; already-deleted404 even same key; no S3/history purge | T06,T39 |
| E32 | GET `R/tasks` | P; Q+task query | Current scoped task/assignee projection; no audit |200 Page<Task> | T14,T40 |
| E33 | POST `R/tasks` | P; TaskCreate,K | Driver=actor, eligible optional assignee/task/event/audit/key |201 Mutation<Task>;422 bad assignee; B00-T | T40 |
| E34 | PUT `R/tasks/{task_id}` | Driver/C; TaskPatch,K,V(Task) | Recheck targets/root/child scope/version; no progress auto-change |200 Mutation<Task>;403 authority; B00-T | T40 |
| E35 | PUT `R/tasks/{task_id}/status` | Driver/assignee/C; TaskStatus,K,V(Task) | Explicit enum4 transition/event/audit; parent qualitative unchanged |200 Mutation<Task>;409 stale; B00-T | T14,T40 |
| E36 | POST `R/tasks/{task_id}/archive` | Driver/C; {},K,V(Task) | Task lifecycle only; shared task counts retain archived task |200 Mutation<Task>; B00-T | T40 |
| E37 | POST `R/tasks/{task_id}/unarchive` | Driver/C; {},K,V(Task) | Restore task lifecycle/status unchanged |200 Mutation<Task>; B00-T | T40 |
| E38 | DELETE `R/tasks/{task_id}` | C; confirm=true,K,V(Task) | Task soft delete/history/retained anchors, no progress auto-change |204; B00-T | T40 |
| E39 | PUT `R/progress` | **Any P** writable; ProgressPatch,K,V(Project) | old/new note/status progress event + audit + Project version |200 Mutation<Progress>; stale409 includes current Progress; never detector503 | T14,T22,T41 |
| E40 | GET `R/progress-events` | P; Q | Own progress history; inherited lifecycle activity is a safe Activity reference, not copied root note |200 Page<ProgressEvent>; no audit | T05,T41 |
| E41 | GET `R/prs` | P; Q+PR query | Mirror metadata/current reviewer flags; no audit |200 Page<PR>, mapping availability explicit | T15,T42 |
| E42 | POST `R/prs/sync` | P writable; PRSync,K,V(Project), continuation? query | Provider I/O outside locks; resumable pages, reauthorize per commit, audit metadata |200 Mutation<SyncResult>;503 connector unavailable; no external PR write | T42 |
| E43 | GET `R/resources` | P; Q+resource query | Published metadata only; no audit |200 Page<Resource>; no URL/key/raw version | T31,T34 |
| E44 | POST `R/resource-upload-authorizations` | P writable; UploadCreate,K; original-uploader/C for existing resource | Intent/audit/key then presign outside locks |201 Mutation<UploadAuthorization>;422 owner media/storage policy | T31–T34 |
| E45 | GET `U` | Current actor owns intent and P(node) or T(own conversion) | Read logical state; no audit |200 UploadState;404 inaccessible; no raw multipart/key | T31,T37 |
| E46 | POST `U/part-authorizations` | Same current upload authority/writable; PartAuthorization,K,V(Upload) | Persist required part binding; SDK presign outside lock; paginated batch |200 Mutation<PartAuthorizationPage>;422 actual S3 part bounds | T32,T33 |
| E47 | POST `U/complete` | Same current action authority; UploadComplete,K,V(Upload) | Deadline-bounded ListParts checkpoints or scoped direct-completion authorization or HEAD→fresh locked publication; safe audit/key per phase |200 Mutation<UploadCompletion>;409 UPLOAD_NOT_READY/checksum/size/state,422 bad phase,503 provider; no blocking S3 assembly in Lambda | T31–T38 |
| E48 | POST `U/cancel` | Same current upload authority; reason?,K,V(Upload) | Make intent nonpublishable/audit; out-of-lock abort cleanup |200 Mutation<UploadState>; published409 | T33,T38 |
| E49 | POST `R/resources/{resource_id}/archive` | P+original-uploader/C writable; {},K,V(Resource entity) | Metadata lifecycle only/audit/key |200 Mutation<Resource>; bytes retained | T34,T39 |
| E50 | POST `R/resources/{resource_id}/unarchive` | Same authority; {},K,V(Resource entity) | Metadata active/version/audit |200 Mutation<Resource> | T34 |
| E51 | DELETE `R/resources/{resource_id}` | P+original-uploader/C writable; confirm=true,K,V(Resource entity) | Logical soft-delete/version/audit; retained file versions/history |204; no S3 physical deletion | T34,T39 |
| E52 | GET `R/resources/{resource_id}/versions` | P; Q | Logical historical version metadata, no key/URL; no audit |200 ResourceVersionPage | T34 |
| E53 | GET `R/context-items` | P; Q+kind/status; deleted omitted | Typed decision/question projection; no audit |200 Page<ContextItem> | T25,T43 |
| E54 | POST `R/context-items` | P writable; ContextItemCreate,K | Item/revision/event/audit/key + generic warnings |201 Mutation<ContextItem> | T22,T43 |
| E55 | PUT `R/context-items/{item_id}` | P+author/C; ContextItemPatch,K,V(Item) | Immutable kind; full revision/event/audit/key, warning-only text |200 Mutation<ContextItem>;422 state/body mismatch | T43 |
| E56 | DELETE `R/context-items/{item_id}` | P+author/C; confirm=true,K,V(Item) | Soft-delete/revision/audit/history |204; question count updates coherently | T43 |
| E57 | GET `/api/teams/{team_id}/dashboard/activity` | T then P; Q+same normalized work filters | Visible immutable activity/time-id keyset; no audit |200 Page<Activity>, no hidden title/event | T12,T15 |
| E58 | GET `R/context/text` | P; kind/object_id/field/resource_version?/offset/limit; H required | Whitelisted same-node DB text chunks under RR/current hash; no write/audit |200 TextChunk,409 CONTEXT_CHANGED;422 bad scope/offset | T28 |
| E59 | POST `CV/items` | T+own session planning, existing-parent P if needed; ConversionItem,K,V(Session) | One immutable client item/hash per record, session version/counts |201 Mutation<ConversionItemResult>;409 changed natural item,422 graph/DTO | T35,T36 |
| E60 | POST `CV/seal` | Same authority; {},K,V(Session) | Validate whole typed graph/hash/references then seal; no visible Project |200 Mutation<ConversionSession>;422 no root/fourth-level/child members | T35,T36 |
| E61 | POST `CV/prepare` | Same authority; {},K,V(Session), cursor? | Resumable invisible row preparation keyed by plan item; no publication |200 Mutation<PreparationResult>;409 plan/state/epoch drift | T36–T38 |
| E62 | POST `CV/cancel` | Same authority; reason?,K,V(Session) | Cancel unpublished plan/audit; staged cleanup separately |200 Mutation<ConversionSession>; committed409 | T38 |
| E63 | GET `R/activity` | P; Q | Own and relevant inherited safe lifecycle/ownership/member event references; no root discussion copy |200 Page<Activity> | T05,T15 |

`TextChunk={project_id:ID,context_version:hash64,kind:string,object_id:ID,field:string,resource_version:int|null,offset:int,text:string,next_offset:int|null,complete:boolean}`. Offset is a zero-based **Unicode scalar character index**, not a UTF-8 byte or UTF-16 index; limit is a positive character-count hint. Read with parameterized MySQL SUBSTRING(column,offset+1,count), then shrink the character count to the serialized envelope budget. next_offset=offset+CHAR_LENGTH(returned text); it is null at completion. Negative/out-of-range offsets422; offset equal to field length returns empty/complete. TextRef.utf8_bytes is metadata, not the offset unit. Every TextRef embeds its context_version so a consumer of a Progress mutation, stale409, historical-resource page or ordinary list can supply H without guessing a separate snapshot; the server still recomputes/reauthorizes before each fragment. Consumers concatenate text in order without renormalizing stored fragments; mismatched version/scope restarts the field/Context. Q cannot request an unbounded result in one frame.

The exact E58 whitelist is: `project`→background/goals/progress_note (object_id=node ID); `task`→description; `pr`→title/branch; `resource`→name; `context_item`→context/body/answer; `progress_event`→old_note/new_note. For every non-project kind, the selected record must belong to this same node and be currently included in its ordinary authorized projection. Context-item DTO context maps internally to context_text. For resource.name, resource_version is required and selects project_resource_versions by (resource_id,resource_version); it must be a retained published version of a nondeleted currently accessible logical resource, never an upload intent. For other kinds resource_version must be absent/null; a progress event uses only this node's events. Field/kind selection maps to static ORM columns, never unvalidated SQL identifiers. Nullable absent text has no TextRef. Deleted items, comment revision originals, context-item revision originals, parent note bodies, delete_reason, conversion payloads, S3 identities and arbitrary columns are not addressable. PR url is server-canonicalized from a configured provider host/repository identifier/PR ID and returned as a normal bounded string, never a fetched body or a user-supplied SSRF target. T28 verifies the whole whitelist and all rejected internal fields.

E27/E28 are the dedicated child create/list operations. A child's detail/update/archive/unarchive/delete/Context/PR/task/resource/comment APIs are the same R endpoints with child ID and inherited P/C. E02–E05 never become child-member management endpoints; E05 transfer is root-only. No fourth-level creation or reparent endpoint exists. E25 replaces any implied duplicate Project-Dashboard route. All extra categories/task/PR/resource/context-item routes above are explicit, not “base integration” placeholders.

## 12. Bounds, idempotency, audit and operational facts

| Item | Classification / source | Exact behavior |
| --- | --- | --- |
| Three hierarchy levels / no fourth | Owner O§5 | Structural422; FK depth guard also prevents it. |
| Comment1–4,000 chars/16,384 UTF-8 bytes,10 users/20 tokens, mention label1–100 | Owner O§7 |422 structural/INVALID_MENTION; no truncation. Not a semantic content block. |
| Task/Project/member/file/Context totals | Owner O§9 | No hard product cap, score or CONTEXT_EXPORT_LIMIT. Batch/paging/preparation continue until complete. |
| S3 object/part/count bounds | Platform, official §8.2 reference | Respect actual service limits; multipart support, safe storage error, not a2 MiB product rule. |
| Request/response frame | Platform Lambda6 MB and actual Gateway bound, §9.3 |413 if one actual request cannot fit; outgoing pages/text fragments are packed, not total-export rejected.1 MiB is a response-work target only. |
| LONGTEXT / VARCHAR storage | MySQL type capacity, [storage requirements](https://dev.mysql.com/doc/refman/8.4/en/storage-requirements.html) and selected §4 schema | LONGTEXT<2^32 bytes; chosen VARCHAR255 names/provider fields declare a schema field capacity, not a universal MySQL maximum. Verify deployed packet/strict-mode configuration; FIELD_STORAGE_LIMIT422, never silent truncation. |
| Rate limits | No owner numeric policy supplied | Withdraw revision 1's30/120/5 windows and100-Project/member gates. Only actual infrastructure throttling yields429 until an explicitly approved policy exists. |
| Operation-key lifetime | Q-RETENTION, no guessed 24-hour policy | Null expiry retains keys; bounded cleanup only after approved retention. Natural conversion/import IDs remain unique. |
| Conversion/upload lifetime and URL TTL | Q-STORAGE/RETENTION, owner security configuration | No guessed 24-hour session or long-lived URL. URL effective expiry is constrained by configured short TTL and underlying signer credentials. Missing signing policy blocks authorization503, not file size. |
| Context restart attempts/backoff | Defined client protocol safety, §9.3 | Three immediate attempts then pause/manual retry; no livelock, no partial import, no collection quota. |
| Operator batch size | Execution work unit | Configurable page/checkpoint, never rejects a Team/Project for having more rows. No unverified wall-clock success/SLA claim. |

Every mutation owns a SQL transaction unless explicitly split around external I/O. Helpers never independently commit. Canonical method/path/body/version hash and actor+UUID key serialize duplicate operations. Same K changed request409; matching committed K first reauthorizes, then resolves a safe current response by ID/version, not a stored raw body. A deleted comment replay is a tombstone; lost Project access404. Signed URL replay regenerates an authorized short-lived envelope, never reads it from SQL. Delete-Project404 exception is explicit. No automatic retry after uncertain COMMIT; client retains draft and retries same K. Deadlock/known rolled-back lock timeout may retry once; then409 STATE_CONFLICT. External provider/S3 uncertainties use durable intent and verification, not a second visible mutation.

Writes lock involved existing Users ascending, Team, root, node/children stable order, child row, operation reference and audit. Root membership/lifecycle and creator transfer use the root shared-field timestamps/revisions. Read helpers use fresh identity joins; no late User lock after root/node. Discover referenced User IDs before ordered locks; recheck root ownership/targets afterward and restart the whole transaction if that preflight set changed, rather than acquiring an out-of-order User lock. Large set-based cascade timeout rolls back/503 under I01, never truncates to 100 Projects or returns partial204. Fallback behavior is §3.3 and requires its own explicit owner acceptance.

Domain success audit commits with the change using existing identity audit_logs and a real actor. No null actor for new Team Work actions, raw request/secret/body/URL in safe audit metadata, or fabricated admin. Preserve full discussion/progress text in its domain history, not operational logs. A delete reason is retained only in projects.delete_reason as restricted domain data with an audit reference `{project_id,field:"delete_reason"}` when supplied, not echoed into logs/Activity or returned by member routes. A child independently deleted has its own reason; parent deletion is referenced through the root batch. Operator restore is blocked on Q-RETENTION, including approval of restricted historical-reason preservation before clearing any deletion field; no restore implementation or additional history store is authorized now. Never copy the reason into ordinary audit JSON. Actions include category/project/subproject creation/edit, lifecycle changes with affected-child count, root membership removal/inherited effect, transfer, progress change, task change, comment/revision, context-item change, import receipt, upload metadata, conversion publication and cleanup. Generic Activity contains only references/counts/actor/time; progress history contains legitimate member-written note versions, not derived replacement summaries.

GET/list/Context/text/activity reads create no domain audit or write. Download/upload authorization is an explicit operation that can record safe actor/resource/version/expiry, never actual URL. Logger/error tracing suppresses bodies/authorization/query capabilities/SQL params/S3 exception details. No read/unread, notification, typing or presence state is stored. Future IM can reuse stable comment/author/root-reply/mention/revision IDs with separately approved delivery/channel tables.

## 13. Concrete implementation instructions

The owner approved source implementation under the selected profile in Section18. The file/transaction/contract instructions below govern the delivered implementation. Historical future-tense verification gates describe the original review plan; Section19 and Verification/REPORT.md record executed checks and remaining owner-environment qualification.

### 13.1 Dependency order and schema installation plan

1. **Decision gate:** approve this revision and I01/fallback, I02, operator-enrolment, B00 narrow items and Q-S3/Q-CONTENT interpretations. Record policy values only where needed; do not treat old identity C03 as this approval.
2. **Inventory:** in the single source tree named §1, verify identity model/types/removal/transaction behavior and preserved unqualified candidate checksum. Database operator confirms whether the target has only identity tables or actual Team Work objects. B00-D blocks any SQL installation predecessor/backfill assumption. No local Memory migration is performed or proposed.
3. **Schema/models first:** review fresh DDL in §4 and exact field/state matrix. Future migration files under `migrations/versions/`, in dependency order: `tw_001_categories_projects.py`, `tw_002_root_members_tasks.py`, `tw_003_progress_activity.py`, `tw_004_pr_mirrors.py`, `tw_005_resources_versions.py`, `tw_006_comments_mentions_revisions.py`, `tw_007_context_items_revisions.py`, `tw_008_operations_imports_conversion_uploads.py`. Actual down_revision comes from the operator-verified installed schema, not a guessed 0007. If an existing Team Work schema conflicts, stop for a reviewed mapping; do not invent backfill or local compatibility code.
4. **Transactions/permissions/projection:** implement root resolution, epoch joins, lifecycle fence, entity-version protocol and a shared RR projection/aggregate function before routers. Prove child grants cannot drift. Separate viewer overlays from shared Context/hash.
5. **Hierarchy/lifecycle/member integration:** root and child CRUD, parent fences, identity removal helper only after I01, fallback reconciler if chosen, explicit ownership transfer and narrowly approved operator recovery. No membership copies; no automatic owner.
6. **Tasks/progress/Context items:** apply exact four/six states, approved B00-T driver authority and immutable human note history. Implement author/C typed decision/question CRUD and exact open counts; no percentage schema or automatic transition.
7. **Comments:** frozen DTO/grammar/escaping/former-edit rule, current root picker, transactions/revisions, warn-only detector fallback, safe rendering flags and manual mention filter. Never gate commit on warning availability.
8. **S3/resources/conversion:** durable upload intents, direct PUT/multipart authorization/verification, metadata versions/download authorization, typed paged plan/seal/private preparation/atomic publication. SDK calls outside SQL locks. Explicitly selected children/files only; no count caps.
9. **Context/Dashboard/API:** wire shared projection, complete comment-inclusive sections, transport fragments, version/backoff, root/child list grouping, filter definitions, aggregate consistency, and receipt. Match all E01–E63 rows/DTOs; no “integration placeholder” or duplicate Project Dashboard.
10. **Qualification/handoff:** unit/static → isolated exact-MySQL/races → actual private API/S3/checksum/TTL/runtime tests. Missing environment=BLOCKED, not PASS. Requalify a new combined candidate, preserve old candidate. Give frontend/local tasks this technical contract/version, not layout prescriptions or credentials.

No actual migration/test/package/script is written in this design revision. Later approved installations run once through an authorized operator runner, never on Lambda import/cold start. Rollback keeps additive schema/history, disables new routes as explicit unavailable (not misleading authenticated404), and requires reconciliation before re-enable after an older removal behavior. Soft-delete restoration/purge stays operator-only under approved retention.

The logical migration grouping is exact: tw_001 creates categories/projects; tw_002 project_members/project_tasks; tw_003 project_progress_events/project_activity_events; tw_004 project_prs/project_pr_reviewers; tw_005 project_resources/project_resource_versions; tw_006 project_comments/comment_mentions/project_comment_revisions; tw_007 project_context_items/project_context_item_revisions; tw_008 teamwork_mutation_keys/project_import_receipts/project_conversion_sessions/project_conversion_items/resource_uploads/resource_upload_parts, in that order. All names/types/checks/FKs are §4, not invented by an implementation agent. Add metadata model imports only after dependencies exist. The operator runner's existing single-migration lease and approval adapter remain in use; no concurrent migrations. For an approved isolated target, the future command is `uv run alembic -c migrations/alembic.ini upgrade head` with the existing verified operator adapter/approval; run it only after B00-D and design approval, never from this review or on Lambda startup. Schema.sql remains a review representation, not a second installation mechanism.

### 13.2 File-by-file service contracts

Paths below are all relative to `/Users/weizhang/Desktop/VegentSupport/identity-development/`. Minimal package markers have no side effects. Allowed libraries: locked Python/FastAPI/Pydantic/SQLAlchemy/SDK primitives and local identity Actor/auth/session/models/audit helpers. No reference-source imports, local session/private-memory/executor code, SSO/provider credential pass-through or roster-copy cache. All comments/docs English; product branding Vegent/Verizon.

| File | Exact entry points / ownership | Data/lock/error contract |
| --- | --- | --- |
| `app/teamwork/models/{category,project,membership,task,progress,activity}.py` | `Category,Project,ProjectMember,ProjectTask,ProjectProgressEvent,ProjectActivityEvent(Base)` | Full §4 fields/keys/checks; no runtime queries/ACL/seed. Root/child depth and root-only membership enforced by composite FK. |
| `app/teamwork/models/{pr,resource,comment,context_item,operation,conversion,upload}.py` | Respectively `ProjectPR/ProjectPRReviewer`, `ProjectResource/ProjectResourceVersion`, `ProjectComment/CommentMention/ProjectCommentRevision`, `ProjectContextItem/ProjectContextItemRevision`, `TeamworkMutationKey/ProjectImportReceipt`, `ProjectConversionSession/ProjectConversionItem`, `ResourceUpload/ResourceUploadPart`, all subclassing existing Base | No generic ORM dumping, file bytes, roster clone, warning snippets or stored presigned URLs. |
| `app/teamwork/schemas/{common,category,project,membership,task,progress,pr,resource,upload,comment,context,context_item,conversion,dashboard,activity,operation}.py` | Registry §6/9/11, closed enums and presence-aware patches | Unknown fields422; future schema names are precise DTOs, not arbitrary dictionaries. Server-generated actor/owner/Team role not accepted. |
| `app/teamwork/errors.py`, `app/teamwork/http.py` | `TeamworkError(code:str,status_code:int,*,current:SafeCurrentDTO\|None=None)`; `teamwork_error_response(request:Request,error:TeamworkError)->JSONResponse`; `mutation_response(data:T,operation:Operation,warnings:list[Warning])->Mutation[T]` | New subclass handler registered in app/main.py for new Team Work errors only. Existing identity error_response discards current; do not rely on it for required stale409 data. Serialize only already-authorized typed current, no input/SQL/object key echo. Keep identity error behavior unchanged. |
| `app/teamwork/permissions.py` | `resolve_root(node_id:int,*,db:Session)->Project`; `require_team(actor:Actor,team_id:int,*,db:Session)->TeamGrant`; `require_project(actor:Actor,team_id:int,node_id:int,action:Action,*,db:Session)->ProjectGrant`; `eligible_members(root_id:int,*,db:Session)->Select` | A/T/G/P/C/PA exactly §3; no identity SystemAdmin bypass;403 Team/404 node/403 action; orphan/archive gates. |
| `app/teamwork/transactions.py` | `read_projection_session()->ContextManager[Session]`; `write_session()->ContextManager[Session]` | RR read/current auth; RC writes, ordered locks; no import-time DB or cross-request open transaction. |
| `app/teamwork/operations.py` | `begin_operation(actor:Actor,key:UUID,request:CanonicalRequest,*,db:Session)->OperationState`; `complete_operation(state:OperationState,ref:ResponseRef,*,db:Session)->None` | Caller commits; current auth before key replay,409 changed hash; current safe projection, no raw body/URL cache. Nullable expiry uses owner policy only. |
| `app/teamwork/services/categories.py` | `list_categories(actor:Actor,team_id:int,query:PageQuery,*,db:Session)->Page[Category]`; `create_category(actor:Actor,team_id:int,body:CategoryCreate,operation:OperationInput,*,db:Session)->Category`; `patch_category(actor:Actor,team_id:int,category_id:int,body:CategoryPatch,expected_version:int,operation:OperationInput,*,db:Session)->Category`; `retire_category(actor:Actor,team_id:int,category_id:int,body:LifecycleBody,expected_version:int,operation:OperationInput,*,db:Session)->None` | T then author guard; lock actor User→Team→category→operation/audit;422 schema,403 nonauthor,409 duplicate/version,404 scoped category. No hidden-project occupancy query or grant. |
| `app/teamwork/services/projects.py` | `create_project(actor:Actor,team_id:int,body:ProjectCreate,operation:OperationInput,*,db:Session)->ProjectDetail`; `create_subproject(actor:Actor,team_id:int,parent_id:int,body:ChildCreate,expected_version:int,operation:OperationInput,*,db:Session)->ProjectDetail`; `update_project(actor:Actor,team_id:int,node_id:int,body:ProjectPatch,expected_version:int,operation:OperationInput,*,db:Session)->ProjectDetail`; `change_lifecycle(actor:Actor,team_id:int,node_id:int,action:LifecycleAction,body:LifecycleBody,expected_version:int,operation:OperationInput,*,db:Session)->ProjectDetail\|None` | Root/child structure, creator-only lifecycle, parent fence, no reparent/fourth level; no SQL fan-out grants.404 deleted/409 read-only/version; audit/history/counts. |
| `app/teamwork/services/members.py` | `list_members(actor:Actor,team_id:int,root_id:int,query:MemberQuery,*,db:Session)->Page[Member]`; `add_member(actor:Actor,team_id:int,root_id:int,user_id:int,expected_version:int,operation:OperationInput,*,db:Session)->Member`; `remove_member(actor:Actor,team_id:int,root_id:int,member_id:int,expected_version:int,operation:OperationInput,*,db:Session)->None`; `transfer_owner(actor:Actor,team_id:int,root_id:int,target_user_id:int,expected_version:int,operation:OperationInput,*,db:Session)->ProjectDetail` | Root-only, exact current identity epoch, fresh row on re-add, creator guard; no child list/mutation; target current G for transfer. |
| `app/services/team_members.py` (I01) and `app/teamwork/services/cascade.py` | Extract `remove_member_in_transaction(actor:Actor,team_id:int,member_id:int,*,db:Session,now:datetime)->MembershipRemoval`; `cascade_team_removal(removal:MembershipRemoval,*,db:Session)->CascadeResult` under original transaction owner | Preserve identity guards/path/token semantics, mark root grants, child inherited history, former assignee flags/orphan; failure rolls back all. No decorated independent commit. |
| `app/teamwork/services/tasks.py` | `create_task(actor:Actor,team_id:int,node_id:int,body:TaskCreate,operation:OperationInput,*,db:Session)->Task`; `patch_task(actor:Actor,team_id:int,node_id:int,task_id:int,body:TaskPatch,expected_version:int,operation:OperationInput,*,db:Session)->Task`; `change_task_status(actor:Actor,team_id:int,node_id:int,task_id:int,body:TaskStatus,expected_version:int,operation:OperationInput,*,db:Session)->Task`; `change_task_lifecycle(actor:Actor,team_id:int,node_id:int,task_id:int,action:LifecycleAction,body:LifecycleBody,expected_version:int,operation:OperationInput,*,db:Session)->Task\|None` | B00-T approved matrix; four work states; immutable driver/assignee provenance; no qualitative auto-change, no removal access bypass. |
| `app/teamwork/services/progress.py` | `update_progress(actor:Actor,team_id:int,node_id:int,body:ProgressPatch,expected_version:int,operation:OperationInput,*,db:Session)->Progress`; `list_progress_events(actor:Actor,team_id:int,node_id:int,query:PageQuery,*,db:Session)->Page[ProgressEvent]` | Any P; note/status independent of counts; append old/new values and author/time; stale409 returns current Progress. Warnings cannot veto. |
| `app/teamwork/services/comments.py` | `create_comment(actor:Actor,team_id:int,node_id:int,body:CommentCreate,operation:OperationInput,*,db:Session)->Comment`; `list_comments(actor:Actor,team_id:int,node_id:int,query:CommentQuery,*,db:Session)->Page[Comment]`; `get_comment(actor:Actor,team_id:int,node_id:int,comment_id:int,*,db:Session)->Comment`; `edit_comment(actor:Actor,team_id:int,node_id:int,comment_id:int,body:CommentEdit,expected_version:int,operation:OperationInput,*,db:Session)->Comment`; `delete_comment(actor:Actor,team_id:int,node_id:int,comment_id:int,expected_version:int,operation:OperationInput,*,db:Session)->None` | Project/root/anchor/mention/version/revision atomic; author edit, author/C delete, tombstones/replies; current G and safe DTOs. No body-content rejection or detector503. |
| `app/teamwork/mentions.py` | `parse_mentions(content:str)->list[MentionToken]`; `validate_mentions(tokens:list[MentionToken],grant:ProjectGrant,previous_version:CommentVersion\|None,*,db:Session)->CanonicalMentions` | §7 exact grammar/escaping/position/grandfather policy; structural422, zero partial rows; no separately trusted client array. |
| `app/teamwork/warnings.py` | `discussion_warnings(text:str)->list[Warning]` | Bounded local pattern pass, no network; catch failure and return validator_unavailable; never throw a commit-veto error or log a matching value. |
| `app/teamwork/services/context_items.py` | `create_item(actor:Actor,team_id:int,node_id:int,body:ContextItemCreate,operation:OperationInput,*,db:Session)->ContextItem`; `patch_item(actor:Actor,team_id:int,node_id:int,item_id:int,body:ContextItemPatch,expected_version:int,operation:OperationInput,*,db:Session)->ContextItem`; `delete_item(actor:Actor,team_id:int,node_id:int,item_id:int,body:LifecycleBody,expected_version:int,operation:OperationInput,*,db:Session)->None`; `list_items(actor:Actor,team_id:int,node_id:int,query:ContextItemQuery,*,db:Session)->Page[ContextItem]` | Typed decisions/questions and revisions; author/C edits; explicit state/count, no text inference or percent equivalent. |
| `app/teamwork/projection.py` | `project_projection(grant:ProjectGrant,*,db:Session)->SharedProjection`; `viewer_facts(actor:Actor,grant:ProjectGrant,*,db:Session)->ViewerFacts`; `context_version(projection:SharedProjection)->str` | One builder for list/detail/Dashboard/Context; own-node sums, root inherited membership, actor-free hash; no per-endpoint formulas/cache. |
| `app/teamwork/services/dashboard.py` | `team_dashboard(actor:Actor,team_id:int,filters:ProjectFilters,query:PageQuery,*,db:Session)->TeamDashboard`; canonical list/detail/activity signatures §13.3 | Visibility before every aggregate/filter, full fixed DTO, no parent double count, same-version equality; viewer overlays labelled. |
| `app/teamwork/services/context.py` | Canonical `get_context` and `read_text_fragment` signatures are §13.3; do not create a shorter conflicting overload; `record_import(actor:Actor,team_id:int,node_id:int,body:ImportCreate,operation:OperationInput,*,db:Session)->Receipt` | Full comments/default sections, measured envelope chunks, no total cap;409 restart/backoff contract, every page current auth, no read audit/write. Receipt current version/natural key, no local path/session grant. |
| `app/teamwork/services/storage.py` | Canonical authorize_upload/authorize_parts/complete_upload/cancel_upload/get_upload/authorize_download signatures are §13.3; no alternate overload without team_id/body/version | Durable intent, current auth→out-of-lock SDK/direct completion authorization→fresh locked verification; S3 platform bounds/checksum type, no body proxy/arbitrary key; Q-S3 caveat enforced, no URL cache. |
| `app/teamwork/services/conversion.py` | `start_conversion(actor:Actor,team_id:int,body:ConversionCreate,operation:OperationInput,*,db:Session)->ConversionSession`; session methods and explicit signatures below (§13.3) | Unbounded typed item plan, selected children/files, existing parent rule, invisible resumable rows then atomic publication. No partial visible Project or silently dropped file. Reauthorize committed results. |
| `app/teamwork/services/resources.py` | `list_resources(actor:Actor,team_id:int,node_id:int,query:ResourceQuery,*,db:Session)->Page[Resource]`; `list_versions(actor:Actor,team_id:int,node_id:int,resource_id:int,query:PageQuery,*,db:Session)->ResourceVersionPage`; `change_resource_lifecycle(actor:Actor,team_id:int,node_id:int,resource_id:int,action:LifecycleAction,body:LifecycleBody,expected_version:int,operation:OperationInput,*,db:Session)->Resource\|None` | P, original-uploader/C for writes; root/node/resource locks;404 scope,409 archive/version,403 writer authority. Soft metadata only, no S3 delete or URLs in lists. |
| `app/teamwork/services/prs.py` | `list_prs(actor:Actor,team_id:int,node_id:int,query:PRQuery,*,db:Session)->Page[PR]`; `sync_prs(actor:Actor,team_id:int,node_id:int,body:PRSync,expected_version:int,operation:OperationInput,continuation:str\|None)->SyncResult` | P/writable; approved connector only; provider reads outside locks then fresh root/node authorization and metadata/audit transaction. Signed continuation binds actor/node/body/operation; only backend-owned mirror fields, no external PR writes.503 missing connector,422 unapproved repository/provider,409 state/version. |
| `app/teamwork/api/{categories,projects,members,tasks,progress,comments,context,context_items,dashboard,resources,conversions,prs}.py` | E01–E63 exact bindings to DTO/query/header/service contracts | Routers adapt HTTP only, no SQL or commit, no extra provider/IM/admin route; private bearer authentication and safe errors. |
| `scripts/teamwork_{reconcile,ownership_recover,staging_cleanup}.py` | Approved operator context + real actor; keyset/checkpoint jobs | No public dispatcher/automatic admin enrolment or unapproved restore/purge. Reconcile grant/orphan provenance; cleanup beyond capability expiry; restore cannot reanimate stale epochs. |
| `app/teamwork/config.py`, `app/main.py` integration | Typed owner storage/policy settings; explicit new router allowlist | No default bucket/credentials/retention/quota; missing required signing config503; requalify new package; original identity candidate unchanged. |

All service ID/version/DTO/operation parameters and returns are typed explicitly above or in the single canonical §13.3 registry; implement those signatures without alternate abbreviated overloads. List helpers never authorize after fetching all hidden rows. Models/services must not import UI components, local Memory stores or session execution machinery.

Permission actions in permissions.py are a closed `Action` enum: READ, IMPORT, CREATE_SUBPROJECT, EDIT_INFO, MANAGE_MEMBERS, TRANSFER_OWNERSHIP, WRITE_WORK, ARCHIVE, UNARCHIVE, DELETE. require_project always revalidates A/T/G and effective root/node visibility. READ and IMPORT allow archived/orphaned reads; IMPORT permits only the receipt write. CREATE_SUBPROJECT/EDIT_INFO/WRITE_WORK require active assigned nodes; MANAGE_MEMBERS additionally requires C and a root; TRANSFER_OWNERSHIP uses assigned C or orphan PA, root only, with the explicit archived-orphan exception. ARCHIVE/UNARCHIVE/DELETE require C and their exact §5 state/no-op rules. For EDIT_INFO, name/category field authority is checked in projects.py after the helper; background/goals are P-writable. Driver/assignee, comment author and original-resource-uploader guards are scoped entity checks after require_project, never a way to bypass P. Read-style Team queries use the same factored G/visibility SQL predicate before filtering/aggregating; they do not throw404 once for every hidden row. Other resource-specific failures are §11.

### 13.3 Companion entry points and implementation verification

Signatures below complete the services in §13.2. `OperationInput` contains the UUID key and canonical method/path/body/header hash; it never contains a password, capability or cached body. `PageQuery` and named query DTOs are exactly §11.1. `LifecycleAction` is archive/unarchive/delete; unsupported entity/action combinations422. Each synchronous service with a db parameter participates in its caller-owned transaction. Capture projection inputs once per response and reuse them for DTO fields and hash; never compute a TextRef hash from a second inconsistent set of queries. Current-user authorization must be rechecked in that transaction, not trusted from the earlier FastAPI dependency alone. External-I/O orchestration owns separate short sessions internally and must not receive an already-open domain transaction.

- `services/conversion.py`: `get_conversion(actor:Actor,team_id:int,session_id:int,*,db:Session)->ConversionSession`; `append_item(actor:Actor,team_id:int,session_id:int,body:ConversionItem,expected_version:int,operation:OperationInput,*,db:Session)->ConversionItemResult`; `seal_plan(actor:Actor,team_id:int,session_id:int,expected_version:int,operation:OperationInput,*,db:Session)->ConversionSession`; `prepare_batch(actor:Actor,team_id:int,session_id:int,cursor:str|None,expected_version:int,operation:OperationInput,*,db:Session)->PreparationResult`; `commit_conversion(actor:Actor,team_id:int,session_id:int,expected_version:int,operation:OperationInput,*,db:Session)->ProjectDetail`; `cancel_conversion(actor:Actor,team_id:int,session_id:int,reason:str|None,expected_version:int,operation:OperationInput,*,db:Session)->ConversionSession`. Lock User/Team/existing root before session, prepared nodes then item/upload/operation rows; no late eligibility User lock. Validate every source/target/node_key and epoch, no prepared IDs in public status.409 plan/state/member drift,422 schema/graph,404 owner/scope/access.
- `services/storage.py`: `get_upload(actor:Actor,team_id:int,upload_id:int,*,db:Session)->UploadState`; `authorize_upload(actor:Actor,target:UploadTarget,body:UploadCreate,operation:OperationInput)->UploadAuthorization`; `authorize_parts(actor:Actor,team_id:int,upload_id:int,body:PartAuthorization,expected_version:int,operation:OperationInput)->PartAuthorizationPage`; `complete_upload(actor:Actor,team_id:int,upload_id:int,body:UploadComplete,expected_version:int,operation:OperationInput)->UploadCompletion`; `cancel_upload(actor:Actor,team_id:int,upload_id:int,reason:str|None,expected_version:int,operation:OperationInput)->UploadState`; `authorize_download(actor:Actor,team_id:int,node_id:int,resource_id:int,version:int,operation:OperationInput)->DownloadAuthorization`. UploadTarget is a closed union of `(team_id,node_id)` or `(team_id,session_id,item_id,expected_session_version)`; never a key/URL. User/Team/root/node or session before intent/part/resource locks. Checkpoint verification before the request deadline; authorize client-direct S3 completion rather than blocking on assembly. Recheck original-uploader/C authority after external I/O; missing policy503, invalid field/checksum mode422, state/checksum409, missing/inaccessible entity404.
- `services/dashboard.py`: `list_projects(actor:Actor,team_id:int,filters:ProjectFilters,query:PageQuery,*,db:Session)->ProjectList`; `project_detail(actor:Actor,team_id:int,node_id:int,query:PageQuery,*,db:Session)->ProjectDetail`; `list_activity(actor:Actor,team_id:int,node_id:int|None,filters:ProjectFilters,query:PageQuery,*,db:Session)->Page[Activity]`. A null node is the Team stream; bind filters/node to cursor; never project private rows before P. GET has no audit/operation key; common401/403/404/422/429/503 apply.
- `services/context.py`: `get_context(actor:Actor,team_id:int,node_id:int,section:ContextSection|None,cursor:str|None,expected_hash:str|None,query:PageQuery,*,db:Session)->ContextManifest|ContextPage`; `read_text_fragment(actor:Actor,team_id:int,node_id:int,ref:TextSelector,offset:int,limit:int,expected_hash:str,*,db:Session)->TextChunk`. TextSelector is exactly E58's static whitelist, not an arbitrary TextRef URL. RR plus current authorization precedes output;409 CONTEXT_CHANGED,422 cursor/selector/offset.

The typed §13.2 signatures are authoritative; §13.3 supplies the longer companion signatures rather than competing overloads. All comment services return Comment, not an already wrapped Mutation; the HTTP adapter wraps all successful mutation DTOs once with Operation/warnings. Run best-effort discussion warnings without giving a detector failure permission to veto the committed write. Model file braces expand to separate files in the written order, with the exact class-to-file mapping in that table. Schema files contain the named registry classes; API files expose only the listed E routes, using dependency-injected current Actor. No worker runs or connector call occurs on import. Register the new subclass error handler and router allowlist explicitly in app/main.py; preserve all original identity routes, public-auth admission, disabled public docs and no-store behavior. OpenAPI inventory can be generated programmatically in isolated tests; do not enable a public /docs or /openapi.json endpoint for that check.

Review in dependency order (§13.1). Before moving from models to services, compare all 21 CREATE TABLE definitions and identity reference types against model metadata on isolated exact MySQL; prove negative CHECK/FK/epoch examples, not SQLite. Before routers, exercise each service's authorized/scoped/error/rollback path; then assert the deployed OpenAPI method/path/body/header/response inventory equals E01–E63 (E01 remains the existing identity route). Service tests use transaction races and injected failures rather than snapshots that repeat implementation text. T01–T46 remain planned until approved implementation; environment-dependent checks remain BLOCKED.

The release handoff contains the new candidate manifest, exact schema-install revision/checksum, contract `2.1-r3`, E/DTO/Context-section map, redacted acceptance evidence, owner-provided private base URL/stage, S3 transport/TTL/checksum settings, DNS/VPN requirements and rollback/reconciliation profile. It never contains JWT keys, database/provider credentials, user passwords, raw invite/unlock/refresh tokens or presigned URLs. Wei supplies actual infrastructure values; this service design does not create or prescribe his AWS resources.

### 13.4 Ordered verification gates and future test commands

These are future commands and files, **not executed tests or authored test code**. Run from the single source tree in §1 after implementation approval. The developer creates the named meaningful test modules during the implementation task; the isolated test configuration must identify its disposable MySQL database and refuse the pilot/production database. No SQLite substitution is accepted for CHECK/FK/locking/rollback evidence. No script in this document executes SQL now.

| Order / dependency | Action and concrete future files | Verification before proceeding |
| --- | --- | --- |
| G0 — before any source edit | Record explicit design approval and selected §15 I01/fallback/I02/I03 decisions; compare the preserved auth candidate hash. | No unapproved identity helper, support access, operator enrolment or stronger S3 guarantee inferred from silence. Unresolved deployment values can be supplied later; they do not require creating AWS infrastructure to write service code. |
| G1 — G0 | Confirm source tree, identity types and actual migration head; map each §4 table to exactly one logical §13.1 migration and its model class; a logical migration can create multiple related tables. | B00-D inventory is a prerequisite to applying migrations. No guessed predecessor, source-tree copy, SQL-on-cold-start or existing local Memory backfill. |
| G2 — G1 | Create models/closed DTOs/errors/transactions/permissions before dependent services. | `uv run ruff check app/teamwork tests/teamwork`; `uv run pytest tests/teamwork/test_schema_and_permissions.py -q` — component assertions for T03,T05,T10,T11,T44 on isolated exact MySQL. Reject invalid depth/Team/epoch/uniqueness and exercise permission state gates; do not mark the full HTTP acceptance cases passed before G6. |
| G3 — G2 | Build each service in §13.2–13.3, then its router; identity helper only if I01 chosen. | `uv run pytest tests/teamwork/test_identity_cascade.py tests/teamwork/test_work_and_lifecycle.py -q` — service assertions for T02–T11,T39–T43. Inject mid-cascade failures; assert before/after rows, actual actor/time, no partial204 and no global refresh revocation. Preferred and fallback profiles are separate configurations, not simultaneously claimed guarantees. |
| G4 — G3 | Frozen mentions/comment revisions/warnings, shared Context and Dashboard projections. | `uv run pytest tests/teamwork/test_comments_and_mentions.py tests/teamwork/test_context_and_dashboard.py -q` — T04,T12–T30,T43. Two-actor hash comparison, parent/child invalidation, stale409 current payload, text-selector denial, large complete paging and detector outage are required. |
| G5 — G3/G4 | Direct transfer, checkpointed part verification/direct S3 completion/HEAD confirmation, resource versions and conversion staging/publication. | `uv run pytest tests/teamwork/test_storage_and_conversion.py -q` — T31–T38. Local controlled tests prove state/rollback; real owner S3 evidence is separately required for signing, conditional writes, checksum modes, CORS, TTL and slow completion. A mock cannot mark those acceptance assertions PASS. |
| G6 — G2–G5 | Wire explicit routers/new error serializer/new UTC DTOs; preserve existing identity auth/role/token/bootstrap behavior. | `uv run pytest tests/unit tests/acceptance tests/verification tests/teamwork/test_http_contract.py -q` — T01,T46 plus original identity regression. Programmatically compare E02–E63 OpenAPI definitions and E01 preserved binding. All transaction suites use MySQL. |
| G7 — G6 | Reproducible new combined candidate; static package, dependency, English/branding and secret-boundary checks. | Record build/dependency/CA/schema checksums and safe scan findings. No tests, operator credentials, environment, requirement/design files or reference checkout in the Lambda ZIP. Full secret values must never appear in scan output. T01/T26/T46. |
| G8 — G7 and owner-provided isolated service/database/S3 access | Run actual private API and storage/runtime qualification, then produce the §13.5 delivery. Wei configures AWS and creates the database. | T45 with real requests/expired capability tests, exact engine/DDL, timeout/concurrency/load and rollback; unavailable environment is BLOCKED. Every applicable T01–T46 has evidence; nonselected I01/I02 profiles are explicitly NOT SELECTED, never falsely PASS. No automatic pilot migration or deployment follows test success. |

Each test module stores redacted request method/path/header names, status/error/DTO assertions, row IDs/version/count transitions, and rollback evidence. Do not save Bearer tokens, S3 capabilities, raw discussion/secrets or complete source/user payloads as fixtures/logs. Preserve owner-entered drafts on retry. A test report identifies the selected integration profile and environment; this document contains a plan only.

### 13.5 Runtime inputs, signing, least privilege and clean delivery

This is a Lambda-service/database-script contract. Wei owns account, routing, API Gateway, network, bucket and database creation. No Terraform/CDK/CloudFormation, VPC/account identifiers or database-instance provisioning are prerequisites for code authoring. Deployment qualification still needs actual owner-supplied access/configuration. Missing required storage configuration yields a safe503 for affected storage operations; unrelated local work/identity must remain available.

| Exact service input | Source / resolver | Required behavior |
| --- | --- | --- |
| Existing identity secret/database/TLS/Actor settings | Existing identity configuration, Wei | Reuse without changing claims, password policy, bootstrap or identity tables; no application DDL credentials. |
| `VEGENT_TEAMWORK_S3_BUCKET`, `VEGENT_TEAMWORK_S3_PREFIX` | Wei supplies owned private bucket/nonempty dedicated prefix | Internal SDK configuration only; no user-chosen key/bucket. Every object key generated uniquely and never reused. No public ACL. |
| `AWS_REGION` | Lambda execution environment / Wei for operator runs | SDK region must match the configured bucket/signing environment; never guess an account/region in the design. |
| `VEGENT_TEAMWORK_URL_TTL_SECONDS` | Wei/security owner under Q-S3/Q-STORAGE | Required owner-selected capability TTL in1–900seconds with no default; effective expiry also respects signer credentials. The code ceiling mitigates exposure and does not implement native revocation. T32–T34 qualify actual behavior. |
| `VEGENT_TEAMWORK_ALLOWED_MEDIA_TYPES` | Rudy approves policy; Wei supplies JSON list of exact MIME strings | Required for upload authorization; parse/validate and reject disallowed type422 without sniffing resource bytes through Lambda. This is an owner policy, not a file-size quota. |
| `VEGENT_TEAMWORK_PROVIDER_CONFIG_SECRET_ID` | Provider owner/Wei supplies secret reference if PR sync enabled | Secret contains approved HTTPS host/repository mapping, mandatory Team IDs, optional narrowed Project IDs, reviewer mapping and credentials; credentials fetched only server-side. Missing connector503 on sync, no provider token in request DTO or runtime logs. |
| `VEGENT_TEAMWORK_UPLOAD_EXPIRY_SECONDS`, `VEGENT_TEAMWORK_CONVERSION_EXPIRY_SECONDS` | Wei under Q-RETENTION policy; required for new staging | Positive owner values required; missing policy503. No default lifetime. Legacy NULL-expiry staging is quarantined and needs an explicit age-policy sweep; committed history remains retained. |

Cursor implementation is explicit: `encode_cursor(payload:CursorPayload)->str` and `decode_cursor(value:str,expected_scope:CursorScope)->CursorPayload` in `app/teamwork/cursors.py`. Canonical JSON binds route/Team/node/section/filter/order/last key/hash as applicable. HMAC-SHA256 uses a domain-separated derived key from the existing server signing secret, `HMAC-SHA256(SECRET_KEY, UTF8("Vegent TeamWork cursor signing v1"))`; use constant-time verification and URL-safe Base64. It is a transport integrity tag, never a JWT/ACL. Context cursor inputs omit actor identity; Team/viewer-filter cursors bind actor ID. Rotate/change-secret invalidates cursors with422 so callers restart; no GET inserts a cursor record. Never accept a cursor as authorization or interpolate its fields as raw SQL.

Runtime database grants: SELECT/INSERT/UPDATE on current mutable Team Work tables as needed; SELECT/INSERT only on append-only comment/context/progress/activity history, receipts and identity audit. No ALTER/DROP, no history UPDATE/DELETE and no runtime hard delete. Retained reviewer rows use is_current rather than DELETE. Operator migrations/cleanup/reconciliation/restore use separately approved credentials, real mapped actor, exact target database and existing trusted operator adapter; scripts cannot infer an approval from an environment flag. Restore/enrolment/purge implementations remain blocked until their specific §15 approval. The rollback procedure keeps additive tables/history and switches to the prior qualified alias only under the chosen reconciliation profile; no unattended downgrade deletes data.

After implementation/qualification, deliver **only** these runtime/operator artifacts in TeamWork (none are generated during this design review): `Lambda/vegent-identity-teamwork.zip`, `Lambda/manifest.json`, `MySQL/schema.sql`, `MySQL/operator-tools.zip`, and `DEPLOYMENT_GUIDE.md`. The Lambda candidate contains existing identity plus Team Work routes in one service; it is not a second live identity store/service. MySQL/schema.sql represents the 21 additive Team Work tables for review; the approved single operator runner applies the verified migration chain, so do not also execute that reference SQL. Keep the existing auth-only candidate in vegent-auth-backend unchanged for comparison/rollback qualification. The future guide lists exact install/test/seed-free verification/release/rollback commands and honest acceptance status; no cloud Team/Project seed is assumed.

Keep only README.md, Design/ and Requirements/ at this design-only gate. Do not create empty Lambda/MySQL directories, fake archives, deployment instructions claiming a built package, a second design copy or placeholder implementation files. Development/test/build intermediates stay in the single support source tree. All current review deliverables are inside TeamWork.

## 14. Planned acceptance and requirement traceability

This table is the original acceptance plan. Source implementation and isolated MySQL execution are now authorized and recorded in Section19 and Verification/REPORT.md. Environment-dependent acceptance remains **BLOCKED pending the owner environment**, not PASS/skip-to-green. Unit parsing/packing mocks cannot certify actual S3 behavior, IAM/revocation or Lambda performance.

| Test | Planned assertion / redacted evidence |
| --- | --- |
| T01 | New typed Team Work UTC/error/current adapters plus identity JWT/User/Team/API regression and unchanged original candidate; no new identity schema/claims. |
| T02 | Any T creates category/root, exact proposed category permissions/name validation; no hidden occupancy disclosure or UI-layout dependency. |
| T03 | Composite depth/root-membership FKs reject fourth level, cross-Team parent and child grant rows; all root/child membership projections identical. |
| T04 | Parent/child list grouping/order/search/filter/keyset and standalone No Category; no unbounded child embedding/hidden node/count. |
| T05 | Parent archive fence instantly makes child read-only; root unarchive preserves independently archived children; child archive independent; no root progress-note copy into child history. |
| T06 | Creator-only archive/unarchive no-op/state/version/audit/progress events; root delete children404, confirm required, repeat delete404, no member restore/S3 purge. |
| T07 | Team removal across active/archived roots+children, same actor/time and per-node audit; other Teams/tokens unaffected. |
| T08 | Inject cascade failure: all preferred identity/domain changes roll back, never partial204; large family no 100-Project quota or truncation. |
| T09 | I01-not-approved profile: unchanged identity removal, immediate live-join denial on every projection, audited repair with measured/not-invented backlog latency. |
| T10 | Removed→Team-rejoined epoch does not resurrect root/child grant; repeated root re-add/removal preserves history; scoped member IDs and creator self-removal guard. |
| T11 | Identity-inactive creator orphans root/children, temporary password unlock does not; explicit transfer rules, no nonmember/global-admin bypass; denied enrolment exception leaves zero-member orphan read-only. |
| T12 | Team Dashboard aggregates count visible matching nodes only and own task/PR facts once; Team403 has no zero-count success/partial leak. |
| T13 | Category/time sort, matched child root container versus matching-node totals, typed filter AND semantics, no hidden category/project statistics. |
| T14 | Exactly four task states and six qualitative states; changes independent; no numeric percent/score/ratio/sort field anywhere; all facts match at same shared version. |
| T15 | Project list/detail/Dashboard/Context share count builder/version; viewer overlays explicit; profile changes by unrelated User do not change shared Context version. |
| T16 | Valid/plain/escaped/malformed exact mention examples; tokens parsed/deduplicated/current root eligibility, canonical label and owner-frozen bounds. |
| T17 | Invalid/former/non-Team/newly copied/reintroduced/retargeted former mention rejected structurally; grandfather position rule consistent; atomic rollback. |
| T18 | Search by name/email, creator highlighted, current chip root-member navigation, former chip inert/original label, no child member list. |
| T19 | Rename does not mutate history on reads; an active mention gets current canonical label on author edit; former tokens retain exact identity/label/count despite prose edits, with no new copy/retarget/reintroduction; no mention grant. |
| T20 | Mentioned-me exact current relation/nondeleted/current P; no unread/read receipt, cross-node mention filter or new feed for removed user. |
| T21 | Flat reply/root-anchor rule, author-only edit, creator delete but not rewrite; edited flag/time, retained replies/deleted tombstone/empty mentions and no public revision contents. |
| T22 | Code/diffs/manual transcript-like/HTML text persist; secret pattern warns with no matched text; detector failure commits with validator_unavailable, never503/input loss. Apply progress-note warning too. |
| T23 | Concurrent comment edit/version and duplicate-key races; no duplicate/revision loss; replay after delete/revocation never resurrects old text/access. |
| T24 | Newest-first/oldest control, filter scope/cursor validation and deleted mention exclusion; no array/text divergence. |
| T25 | Context contains complete default comments/tombstones, decisions, typed open questions, own child Context, full text refs, all required metadata/storage/permission fields. |
| T26 | No automatic session/private-memory/tool/credential source access, no file bytes/S3 key/presigned URL in Context/list; Q-CONTENT test does not falsely assert perfect semantic DLP. |
| T27 | Equal shared Context versions/data for two authorized members; eligible member display/category/Team/parent name/owner and included child-summary changes invalidate correctly; nested shared summaries omit actor overlays; unrelated requester/profile/token changes excluded. |
| T28 | Project beyond old256 KiB/5,000-row/member caps fully traversable; oversized field fragmented by Unicode character offsets, exact E58 whitelist rejects internal/revision/S3 columns; measured envelope fits actual transport; no total Context rejection/truncation. |
| T29 | Concurrent content edit gives409/restart; bounded jitter/backoff then paused import, no livelock/partial import; authorization before 304 and each text/page. |
| T30 | Own UUID receipt/natural key/current version; local snapshot survives failed receipt; no local path/session/device grant; node/child independent import. |
| T31 | Authorized direct S3 transfer never carries bytes through Lambda; no 2 MiB/20-file cap; owner media policy applied, no public/list capability. |
| T32 | Conditional immutable object creation and duplicate finalization once; presigned URL reusable fact is not hidden; new auth after removal denied, existing capability TTL boundary explicitly qualified. |
| T33 | Multipart physical part limits/paginated parts/checksum type; verify/authorize/confirm checkpoints survive restart, direct S3 completion beyond 15 seconds never blocks Lambda, HTTP200-with-error is not treated as success, pinned SigV4 conditional headers and full manifest are checked; retries, completion conflict and cancellation, no ETag-as-SHA false claim. |
| T34 | P/version-scoped short download authorization; original-uploader/C authorization stays stable across new uploader/creator transfer, historical version name/metadata/text remain pinned; no raw key/version in DTOs, original-uploader/C resource lifecycle retains S3 versions; actual TTL/network behavior proven by owner environment. |
| T35 | Seal persists actor/member epoch IDs; remove/rejoin between seal/prepare/commit409 with no new grant. Root conversion linked copy and explicit selected children only; independent child requires existing Team root/P; no local-owner proof or automatic missing-parent creation. |
| T36 | Plan >one frame/resources>20/tasks>1,000 prepared in batches with no product caps; all rows private until one publication fence; driver/member/category/epoch revalidation. |
| T37 | Revoke Team/parent during upload/prepare/commit and Project after commit; no stale result exposure, no partial visible Project, correct natural-key recovery. |
| T38 | S3 success/SQL failure/unknown response/late upload races; missing selected resource prevents publication; cleanup never deletes committed data or still-valid capability targets. |
| T39 | Soft delete/history/object retention and approved operator restore (no stale grant revival); no hard-delete frontend route or unapproved enrolment. |
| T40 | Exact proposed B00-T driver/assignee/C task matrix, status version conflict and active target check; task archive/count scope independent of progress. |
| T41 | Any P updates qualitative status/note, creator correction new event/version, stale409 shows current note/status/author; archived/orphaned frozen. |
| T42 | PR mirror-only metadata/sync/out-of-lock provider operations; unknown reviewer mapping availability, no external create/merge/close or fetched PR code. |
| T43 | Typed decisions/questions state/revision/permission/history and open count; no inferred punctuation, consistent Dashboard/detail/Context. |
| T44 | Exact-engine fresh DDL/FKs/checks/indexes/append-only grants, one runner, no cold-start install/backfill/unused-Memory migration; required deployed-baseline collision gate. |
| T45 | Actual owner private API/IAM/S3/packet/body/runtime and worst-case cascade/plan performance; BLOCKED until real evidence, no mocked success or invented limits. |
| T46 | All E01–E63 routes/DTOs/headers/errors match frontend/core handoff; source/package boundaries, English branding, no IM/notification/automatic sync or duplicate source tree. |

### Requirement → contract → acceptance

| Optimization requirement | Revised section / baseline | API / DTO / DDL | Tests |
| --- | --- | --- | --- |
| O1 complete foundation, no B00 catch-all | §§1–2,4 | Full fresh category/project/task/member/PR/resource/history schema; narrow B00 items§15 | T01–T04,T40,T44 |
| O2.1 complete Context | §9 | E11/E58, ContextManifest/sections, comment/context-item tables | T25–T29 |
| O2.2/O5 third level/inherited membership | §§3–6 | E27/E28 plus child R endpoints; composite depth/root-only grant keys | T03–T06,T35 |
| O2.3/O7 frozen mention mechanism | §7 | E02/E06–E10, Mention/Comment DTO, structured relations/revisions | T16–T24 |
| O2.4/O8 warn-only | §§7,12 | warnings/Comment/Progress; no semantic rejection branch | T22,T23,T41 |
| O2.5/O9 no arbitrary caps/direct S3 | §§8–9,12 | E15/E17/E44–E48/E58–E61, upload/part/staging schema | T28,T31–T38 |
| O2.6/O10 mandatory Dashboard | §10 | E18/E19/E25/E57, TeamDashboard/ProjectList/Detail | T12–T15 |
| O3 every baseline field/type/rule/source | §2/4 | All physical definitions, explicit driver ambiguity B00-T | T02–T04,T40,T44 |
| O4.1 complete field storage/read/write/share | §9.1 | Context map, comments/decision/question/progress/resources | T25,T26,T43 |
| O4.2 exclusions / source boundaries | §7.3/9 | Strict source/DTO exclusion; disclosed Q-CONTENT | T26 |
| O4.3 actor-free version/coherent pagination | §9.2–9.3 | E11/E58, shared hash/RR/fragment/retry protocol | T15,T27–T29 |
| O5.1 SubTicket independent review Context | §§5,9 | Child own tasks/PR/comments; independent E11/PR routes | T03,T25,T42 |
| O5.2 no separate child members / own CRUD / group | §§3,5,11 | Root E02–E05 only; E27/E28 and shared child R | T03–T06,T18 |
| O5.3 aggregate/subproject conversion rule | §§8.3,10 | Self-only counts, explicit selected child plan, existing-parent independent child | T12–T15,T35,T36 |
| O6 progress percent removal/any P/history | §§2,4–6 | E39/E40, ProgressPatch/events, exact six/four enums | T14,T41 |
| O7.2 examples/escaping/bounds/navigation | §7.1 | Token grammar/table/DTOs/root picker | T16–T20 |
| O7.3 replies/edit/delete label | §7.2 | E06–E10, edited_at/is_edited/tombstones | T21,T24 |
| O8 detector outage/no DLP/resource distinction | §7.2–7.3/8 | Warn-only author response, no file-content proxy scan | T22,T26,T31 |
| O9.1 parts/download/identity/cleanup | §8 | Resource upload intents/parts/logical refs; Q-S3 disclosed | T31–T38 |
| O9.2 unlimited logical Context | §9.3 | Full traversal/TextRef/physical frame, no export cap | T28,T29 |
| O9.3 justify all remaining bounds | §12 | Owner-frozen mention limits/platform constraints, no invented rate/session lifetime | T14,T28,T33,T45 |
| O10.1 filters/DTO/sort/errors | §10–11 | E18/E19/E25/E57, complete Dashboard registry | T04,T12–T15 |
| O10.2 visible aggregates / activity | §10.3 | TeamAggregates/Activity/Page; no unread/percent | T12–T15,T20 |
| O10.3 consistent numbers | §10.1 | One shared projection and version; viewer overlays separate | T15,T27 |
| O11 archive/unarchive/delete/orphan | §3/5 | E05/E29–E31; soft states/fence/history/confirmation | T05–T11,T39 |
| O12 I01/I02/enrolment/fallback/cascade | §3/15 | Existing identity DELETE integration choice, no implicit bypass | T07–T11 |
| O13 import/linked copy/explicit subprojects | §8.3/9.4 | E12–E16/E59–E62; receipt/natural keys/publication | T30,T35–T38 |
| O14 all endpoint checklists | §11 | E01–E63 exact request/response/permission/header/error map | T46 |
| O14.2 genuinely open items only | §15 | Named resolver/blocked work, decided rules not reopened | T46 |
| O14.3 one revision 2/changelog/STOP | §§1,16–17 | Single authoritative document, no implementation artifacts | T01,T46 |

## 15. Decision register / remaining deployment inputs

**Execution update:** Section18 resolves B00-C/B00-T, I01/I02/I03 and the Q-S3/Q-CONTENT interpretation for this implementation. Those historical register entries are no longer source-development blockers. B00-D still blocks applying SQL to an uninspected target; provider/storage/operator/retention/performance values remain owner-environment inputs. No fallback, enrolment, restore or purge profile was selected.

The decisions in O§2/6/7 are **not reopened**: complete Context, third hierarchy level/inherited membership, six qualitative states/no percentage, warn-only comments, frozen mention bounds, no arbitrary resource/Context quotas and fully designed Dashboard/lifecycle are applied. This register contains only unresolved baseline comparisons, integration permissions and actual platform/operational ambiguities.

| ID | Actual unknown / proposed safe behavior until resolved | Named resolver | Blocked work / scope |
| --- | --- | --- | --- |
| B00-D | Original Nov2 full baseline/target DB schema/install revision not supplied or inspected. §2/4 define a new fresh proposed contract, not an installed mapping. No historic/local Memory backfill assumed. | Rudy supplies baseline if comparison needed; Wei/database operator verifies installed schema/revision | Actual schema installation/migration predecessor or occupied-table mapping. Does not defer enums/progress/Dashboard design. |
| B00-C | Original baseline category modification authority not known; proposed category-author rule/label retirement is frozen§2/11 and reveals no private occupancy. | Rudy | Activation of category mutation authority until accepted as baseline resolution. |
| B00-T | Original task-driver authority unspecified in supplied B/F; exact proposed driver/assignee/C matrix is frozen, counts/states settled by O. | Rudy | Task write authority validation/activation, not state/count schema or qualitative progress. |
| B00-PR | Approved provider hosts/repository connector credentials and reviewer identity mapping not supplied. | Rudy/provider owner; Wei configures execution access | Actual PR sync/reviewer mapping qualification. DTO/count definitions are frozen and unavailable mapping is explicit. |
| I01 | Explicit approval of existing identity helper extraction and same-transaction cascade, or acceptance of the visible-consistent reconciliation fallback§3.3. | Rudy; Wei confirms operational profile | Identity source change/new candidate qualification; no implication from C03. |
| I02 | Whether to introduce any global-admin nonmember support inspection route. Not approved; none is present in this API inventory. | Rudy | Special inspection route; ordinary P-only APIs remain as specified. Support is approved operator review until a new explicit contract exists. |
| I03 | Incident-specific operator enrolment exception for a zero-member orphan. Not approved; transfer only to an already eligible member otherwise. | Rudy and actual mapped incident operator | Enrolment recovery exception. No routine admin/operator membership authority. |
| Q-RECON | Chosen fallback schedule, real operator mapping, measured repair/backlog SLO and alerts. Visible joins are immediate; physical repair latency unverified. | Wei/operator, Rudy accepts SLO | Claim of a maximum physical-repair delay/fallback operational acceptance. |
| Q-S3 | Literal single-use URL and immediate post-SQL-revocation direct S3 denial are not native presign guarantees. Proposed supported contract is unique intent/conditional immutable creation/one publication, plus current checks at issuance and bounded capability TTL. | Rudy accepts precise semantics; Wei/S3 security operator supplies TTL/policy | Storage security acceptance of capability reuse/revocation window. If literal stronger behavior is mandatory, a different gateway must be separately approved. |
| Q-STORAGE | Exact bucket/prefix/KMS/private client route/CORS/immutable-object grants, signer TTL, upload expiry/cleanup quiescence and supported checksum mode not supplied. | Wei/S3 operator | Real direct transfer/multipart/cleanup qualification; no guessed bucket/keys/lifetime. These are configuration inputs, not invented product caps. |
| Q-CONTENT | Complete warn-only user-authored discussion can contain a pasted secret/diff; absolute semantic secret-free Context cannot simultaneously be promised (§7.3). Proposed structural source exclusion is explicit. | Rudy/security owner | Absolute-exclusion acceptance wording/export safety claim. The decided warn-only posting behavior is not reopened or blocked by detector failure. |
| Q-RETENTION | Deleted content/revisions/audits/session/operation/staged-object retention and approved restore/purge procedure not supplied. Keep data; no automatic expiry or frontend hard delete. | Rudy/privacy owner and Wei/DB/S3 operators | Purge/expiry automation, incident restore execution and privacy operational sign-off. |
| Q-QUOTA | No owner storage/count/rate quota exists. No default product limit is added. | Rudy only if later imposing a policy | Any later quota enforcement needs its numeric/error contract; current design remains without it. |

This is not an approval request to execute now. Any resolution changing schema/API/security updates this same document and requires approval before implementation. Do not pretend a platform limitation is fixed by a configuration placeholder.

## 16. Revision 1 → revision 2 changelog

| Optimization section | Withdrawn/replaced revision 1 rule | Revision 2 replacement / location |
| --- | --- | --- |
| O1/3 | Foundation deferred globally to B00; tables/driver/task/progress/lifecycle not reconciled | §2 reconciles every field/state/source and narrow remaining comparisons; §4 complete proposed fresh schema; source tree versus artifact distinguished§1. |
| O2.1/4 | Comments excluded and no include option, optional decisions/questions | §9 complete paginated Context includes default full comments/tombstones, typed decisions/questions, history and independent child data. |
| O2.2/5 | Category→Project only; every Project separately enrolled | §3–5 three levels with root-only membership rows, no fourth level via composite FK; own child Context/PR/work fields; root list plus separate child pages. |
| O2.3/7 | Mention grammar proposed but picker/navigation/escaping/malformed/moved-former cases incomplete | §7 frozen token/examples/parity/malformed list/position rule/DTO/root navigation; owner-fixed bounds and no separate mentions array. |
| O2.4/8 | CONTENT_NOT_ALLOWED rejection; detector outage503/total write failure | §7 any discussion content, generic author warning, validator_unavailable yet successful write; HTML/code inert, no semantic censorship/DLP claim. |
| O2.5/9.1 |2 MiB Lambda byte proxy,20-file cap/no multipart | §8 direct S3 single/multipart, actual service bounds, ephemeral authorization endpoints and verified pinned metadata; unlimited logical resource count. |
| O9.1 | Simplistic single-use/immediate revoke claim implicit | §8/15 document actual AWS URL reuse/TTL semantics, conditional creation versus capability, Q-S3 owner decision instead of invented guarantee. |
| O9.2/4.3 |256 KiB export/16 MiB assembly/5,000-row rejection; limited roster | §9 unbounded complete logical export, adaptive transport pages/text fragments, no CONTEXT_EXPORT_LIMIT; coherent RR/actor-free hash and finite backoff/pause. |
| O9.3 |100 Projects/Team,100 members,30 comments/min,120 reads/min,5 conversions/hour, guessed 24-hour windows | Removed as product policies. §12 separates owner mention limits, platform facts, physical schema fields, transport work units and owner-supplied retention/security settings. |
| O6 | Derived progress percent from task completion | §2/4/6/10 six member-updated states, human note/history and exact four-state factual counts. No numeric substitute, ranking or status auto-transition. |
| O10 | E18/E19/E20 “base integration” placeholders, unknown aggregates | §6/10/11 full DTO/filter/sort/query/permission/error contracts, shared projection, visible-node-only aggregation, per-node counts and actor overlay distinction. |
| O11 | Archive/delete/orphan incomplete/no exact confirmation/restore semantics | §5 explicit creator-only lifecycle/no-op/unarchive, parent effective fence, confirm=true soft delete, repeat404, retained S3/history and operator-only restore. |
| O12 | Preferred integration/exception could be assumed | §3/15 separate pending I01/I02/I03, honest read-time/follow-up fallback latency, no implicit SystemAdmin or operator enrolment. |
| O13 | Parent/child conversion unspecified and whole plan in one capped JSON/commit request | §8 typed item pages, explicit selected children, existing Team parent required for independent child, invisible preparation then one publication fence; linked copy/no local ownership overclaim. |
| C§5 | Local unused Memory refactor might acquire an unnecessary data migration | §1/13 no local migration/backfill/compatibility shim; fresh cloud schema provisioning distinguished. |
| F versus O | Older layout/chart percentages and two-level grouping could dictate backend | §1 precedence; frontend outcome/error/cache/import needs only, no layout constraints; current model/DTOs are backend contract for consumers. |
| Revision 2 cross-check | Shared child summaries could otherwise carry actor overlays; Team/parent rename or child-summary changes could escape a narrow version formula; delete reason/source provenance lacked explicit storage mapping | §§4/6/8/9/11–13 align explicit source_created_at/delete_reason storage, ParentRef, shared/viewer DTO separation, acyclic child-summary hashes, character-index text whitelist, complete service ownership/signatures and publication/CV authorization fences. |
| Pre-implementation audit (this follow-up) | Ephemeral eligibility checks had no stored sealed member epochs; resource ownership/latest-uploader and old-version names were ambiguous; multipart completion could block a 15-second Lambda; stale409/UTC adapters were not mapped to existing identity limitations | §§4/6/8/9/11/13 now pin actor/member epochs, retain per-version names, fix original-uploader/C authority, checkpoint verification and authorize client-direct S3 completion, carry TextRef hash/version, preserve reviewer rows, define error/UTC adapters/revision bumps/cursor signing and G0–G8 tests. E47 request/response changes are explicit; no implementation consumer has been approved. |
| Delivery organization (this follow-up) | Four request originals beside the design folder; no reading entry; auth candidate path predated its organized folder | README.md + Design/ + Requirements/, originals moved byte-for-byte; §1 records current auth-candidate location and future TeamWork artifact map. No auth artifact or source changed. |
| O14 | API/implementation/test handoff incomplete | §11 E01–E63 with complete registry, §13 ordered files/signatures, §14 T01–T46+requirement mapping, §15 named actual unknowns; single in-place draft and STOP. |

The change to multi-request invisible conversion preparation and inherited lifecycle fences is deliberate: unlimited logical collections cannot be guaranteed to fit a single Lambda request. Public publication/cascade access semantics remain atomic/current; no partially visible Project or duplicated child ACL is introduced. Exact engine/performance qualification remains required, not claimed measured.

## 17. Historical design-only completion and stop (superseded by Section18)

- [x] Version 2.1-additions, revision 2; one authoritative English design updated in place, DRAFT — NOT APPROVED.
- [x] All newly supplied requests read; old percent/layout/hierarchy conflicts resolved by the latest optimization decisions, not silently inherited.
- [x] Reconciled baseline precedes dependent contracts; exact proposed types/states/storage/permission/share rules are supplied; remaining baseline comparisons are specific B00 items.
- [x] Complete Context with full comments, inherited SubProjects, qualitative progress, warn-only discussion, direct multipart S3 and full Dashboard/lifecycle APIs are defined.
- [x] Frozen mention and concrete implementation instructions, migration logical order (no authored migration), endpoint/DTO/DDL links and acceptance mapping are part of this single document.
- [ ] I01/I02/I03, narrow B00 comparisons and genuine platform/retention/security inputs remain pending as named in§15. No implemented/production-ready approval is asserted.
- [x] No source/migration/test/package/seed/AWS/pilot database/commit/push work performed in this revision; no local Memory migration designed.

**Earlier document-only verification (2026-11-03, before this follow-up audit):** Markdown table widths and code-fence closure checked; the JSON example parsed; 21 proposed SQL table definitions statically checked for referenced-column existence and matching FK types (including existing identity ID types); E01–E63 and T01–T46 inventories/reference coverage checked; four input SHA256 values and the preserved identity ZIP hash unchanged; one design document in the delivery directory; no forbidden legacy branding or non-English prose found. Cross-checks corrected DTO/storage/permission/version/publication/text-transport inconsistencies described in §16. These are document checks only: no SQL, service test, migration or deployment was executed. Environment acceptance remains BLOCKED as specified in §14.

**Follow-up pre-implementation audit completed (2026-11-03):** Rechecked the four unchanged input documents against §§2–15 and the existing identity auth/session/main/migration interfaces. Corrected sealed conversion epoch storage, original-uploader authority, version-pinned resource metadata/text, retained reviewer rows, slow multipart completion and checkpoints, typed stale409/UTC adapters, revision invalidation, canonical service signatures, migration dependency mapping, permission actions, cursor signing, test execution gates and compact delivery paths. Static document checks passed for 21 proposed SQL tables/62 foreign-key mappings, E01–E63, T01–T46, Markdown/JSON/local links and English/branding. All four request hashes and both observed copies of the preserved auth ZIP match the recorded baseline. Requirements originals moved unchanged; delivery now has README.md, one Design document and four Requirements originals (six files). No service, SQL or AWS test was executed; these checks do not qualify runtime behavior. §15 choices and actual-environment acceptance remain explicit prerequisites to execution/release.

**Readiness verdict:** The revised contract and ordered implementation instructions are ready for owner review. Implementation is not yet authorized. Approval must select the relevant §15 integration/security policies; deployment values are supplied by Wei when needed, and do not require the implementer to provision AWS or create the database. Do not convert a BLOCKED/NOT SELECTED test into PASS or treat this review as production acceptance.

**STOP for owner review of revision 2.** Only explicit approval of this Team Work design and the relevant named integration decisions authorizes a later implementation task. Identity1.1/C03 and the existence of a design document do not authorize it.

## 18. Execution authorization and selected profile

Owner instruction: implement the design, complete development and tests, and report completion without intermediate approval questions (2026-11-03). Approved baseline SHA256 before this record: `f6c153542fa7eae5532ce7c1ba4f2c9ba355657d574032d4f57e93c4c66758d4`. Select I01 atomic identity-removal helper/cascade; I02 ordinary P-only access with no nonmember support endpoint; I03 no operator enrolment bypass. Adopt the explicit B00-C category-author and B00-T driver/assignee/creator matrices. Use the documented S3 authorization-at-issuance/expiry semantics and structural source exclusion plus warn-only discussion. Deleted history is retained; no unapproved purge/restore is introduced. Missing owner deployment values remain runtime configuration/real-environment qualification items rather than barriers to source development. Existing source predecessor0007 is inspected; actual target schema remains operator-verified before installation. Local tests use a disposable MySQL database only.

Implementation consistency correction: task creator and membership added-by displays need immutable name snapshots when those actors become former members. Added project_tasks.created_by_name_snapshot and project_members.added_by_name_snapshot (VARCHAR100 NOT NULL) to the fresh schema; no permission/API scope change. These are filled at creation, never inferred from a former actor’s current profile.


## 19. Historical revision2 implementation record — superseded by Section20

Status: **implementation complete; local verification candidate; AWS qualification pending**. The explicit implementation instruction in Section18 authorizes this record and the delivered source/artifacts. Historical design-review stop statements do not describe the current execution status. No AWS resources, production schema/data, pilot seed, deployment, commit or push were changed. The original auth-only candidate remains unchanged.

### 19.1 Delivered behavior and consistency corrections

- One combined Lambda exposes the existing30 identity routes plus62 new Team Work routes. E01 remains the existing identity membership-removal route; the complete E01–E63 contract is preserved. The21 additive ORM table column sets match the SQL executed on isolated MySQL8.4.13. The migration chain uses the inspected source predecessor0007 and headtw_008; the owner must inspect the actual installed target before applying it.
- I01 is implemented with one original identity transaction and Team Work cascade; a cascade exception rolls back identity membership, Project grants and domain/audit changes together. Live User/Team/epoch joins continue to deny stale grants. No global-admin private inspection or operator enrolment bypass exists. Fallback acceptance is NOT SELECTED; the reconciler is supplied for reviewed repair/rollback operations.
- Added immutable task-creator and membership-added-by name snapshots described in Section18, consistently across DDL/models/migrations/serializers. No identity schema or JWT claim change was introduced. Root membership remains the only grant store; children inherit it.
- Closed request/response models are split between input modules and `schemas/responses.py`; resource/dashboard/activity/operation modules re-export the concrete shared output classes, avoiding duplicate DTO definitions. API Context-item bindings are in `api/context_items.py`. API transport glue in `api/execution.py` validates headers/query/body/output, orders transaction locks and wraps mutations once. It is not a public dispatcher or additional endpoint.
- Canonical `OperationInput` contains method/path, normalized body **and normalized query**, plus expected version, and is actor+UUID scoped. External network orchestrators return `(data, operation)` internally; the HTTP adapter emits the unchanged Mutation envelope. Pending intent rows with an empty response reference are resumable, not completed replays. PR sync stores safe protocol metadata only, never provider bodies or URLs.
- `paging.py` contains signed bounded transport and SQL keyset paging; LONGTEXT fields are deferred and read through the static text whitelist/Unicode fragments. Database-session-local read caches and batched statistics avoid repeated projection work; they never survive a request or act as authorization. Project detail reuses one shared projection. No total collection/file/Project quota was added.
- Added `VEGENT_TEAMWORK_ENABLED`, default false, for schema alignment/maintenance. With false, authenticated Team Work routes return503 and identity remains usable; the original seven-table identity path remains supported. Enabling it also enables I01 on Team removal. Reconcile any membership changes made while that integration was disabled before reenabling; maintenance/rollback is described in DEPLOYMENT_GUIDE.md.
- PR connector configuration is server-side and fail-closed: required `team_ids`, optional `project_ids`, approved HTTPS host/repository mapping, token and optional reviewer_map. This binds configured repository access to its actual Team instead of exposing all configured repositories to any Project member. No external PR mutation or provider credential API was added.
- Storage transport chooses resumable multipart for files without full-object SHA256 at100 MiB and above, including sizes below5 GiB; this is a transport threshold, not a quota. Declared SHA256 uses single PUT within its physical ceiling; multipart uses verified part/composite checksums. Verification rejects duplicate/nonadvancing provider part pages, and completion is client-direct conditional S3 POST followed by fresh-authorized HEAD confirmation. The locked SDK signs the required conditional header locally; actual S3 acceptance is still blocked on the owner environment.
- Operator jobs require `verify_teamwork_approval` with exact operation/scope/actor/expiry/database **host/port/name**; migration approvals also require host/port and fail closed when an old adapter omits them. No permissive adapter is shipped. Cleanup retains committed object references, waits for capability expiry plus explicit quiescence, and repeats late-arrival sweeps. Restore, retained-history purge and zero-member orphan enrolment remain outside this selected release.

These are implementation consistency details within the approved contract. The snapshot additions correct missing historical-display storage; provider binding and operator target binding enforce the existing scoped authorization requirement. No new public endpoint or product policy is introduced. This record is the changelog for these corrections; they are not silent code divergence.

### 19.2 Evidence and release gate

The local regression command is `uv run pytest tests/unit tests/acceptance tests/teamwork tests/verification -q`; the separate real-Lambda benchmark is excluded from this local command and remains fail-closed/BLOCKED without its real owner adapter. Lint/format checks cover app/tests/scripts/migrations/handler. Real isolated MySQL tests cover constraints, negative permission paths, epochs, transaction races/rollback, comments/mentions, coherent Context/Dashboard, qualitative progress/tasks, resources, staging and migrations. Large traversal/preparation tests exceed5,000 and1,000 tasks respectively. Controlled provider/S3 doubles prove application state and out-of-transaction I/O only. A local AL2023 Lambda Python3.12 x86_64 image checks native dependencies/import and unauthenticated handler execution without network access. See Verification/REPORT.md and results.json for final counts, commands, digests and T01–T46 coverage; do not infer full cloud acceptance from local success.

The delivery layout now includes the actual Lambda candidate, additive review SQL, operator workspace archive, generated OpenAPI and English deployment guide under TeamWork. Development/tests/build intermediates remain in the single support workspace. The original four requests and auth-only ZIP remain byte-identical to their recorded baseline hashes. AWS private ingress/IAM/TLS/managed logs, target-engine support, live S3/checksum/CORS/expiry behavior, enterprise provider compatibility, real Lambda load/benchmark and frontend/local integration remain explicit qualification work for the owner environment. No automatic deployment follows this completion record.


## 20. Revision3 implementation-feedback remediation — 2026-11-03

Authority: the owner requested honest, comprehensive review of the supplied implementation feedback and corrections to applicable code. This authorizes local fixes/tests/repackaging, not deployment, production SQL, pilot seed, frontend implementation or invented policy sign-off. HTTP contract is now `2.1-r3`; method/path inventory remains E01–E63 (62 new +30 identity routes). The21-table DDL and migration headtw_008 are unchanged. The original Nov2 requirements file cited by the reviewer was not found in the supplied workspace; comparisons to its exact text are reviewer quotations, not a claimed independent read. The four actual supplied requests remain unchanged.

### 20.1 Correction/change ledger

| Feedback / old behavior | Revision3 implementation / governing instruction |
| --- | --- |
| P0-1: SDK ceiling permitted TTL up to604800seconds | `config.storage_config` now rejects TTL>900. Actual owner TTL remains required and unselected. `storage.authorize_download` rechecks both Project and logical Resource after signing before delivery. This mitigates capability exposure; it cannot revoke an issued S3 URL. Archive is read-only, not read/download revocation. No bytes proxy or speculative credential rotation is added. |
| P0-2: effective archive was mistaken for node-own state | `projects.change_lifecycle` compares row.status. Parent-first child archive persists independently; child unarchive stays fenced by an archived parent. |
| P0-3: Team-wide Category labels / unbound cursor | E21 now SQL-filters labels to actor-visible roots and binds actor to cursor. Hidden/unknown filter IDs both422. Author-only category writes/retirement remain unchanged. |
| P0-4/P1-8/P1-9: success-only/inaccurate errors in OpenAPI | `app/teamwork/openapi.py:install_openapi` publishes typed ErrorEnvelope/current unions, operation error responses,62-row header/version/body table, UUIDv4/If-Match constraints, paging/TextRef and capability/import/sync/conversion contracts. No public docs endpoint is enabled. |
| P0-5: complete entity materialization before paging | `dashboard.filtered_nodes` uses SQL visibility/AND predicates; list/subproject/activity/PR routes keyset-page in SQL; Team aggregate facts are SQL grouped counts. Only the page is projected. PR reviewer/comment metadata is batch-prefetched. Shared Context hash work still depends on the included root/member/child record; no fake constant-time or real-Lambda SLA is claimed. Ingress admission remains a mandatory owner gate. |
| P0-6: unqualified pool/timeouts | Retain pool_size1/max_overflow0 for the standard single-event Mangum deployment with sequential nonoverlapping sessions. Do not transplant this profile to a concurrent HTTP server/Web Function. Keep real-RDS latency/lock/connection and2× pilot-scale tests open rather than blindly increasing connections/timeouts. |
| P0-7: claim that only comment DELETE replays204 | Code inspection and a seven-kind matrix show six non-Project DELETEs already store a none/204 ref and replay204 within authorized enclosing scope. Project delete404 is the explicit existing privacy exception. The client contract now explains uncertain DELETE handling; no historical body cache is introduced. |
| P0-8: guide-only reconcile-before-enable | `permissions.require_team` detects stale active Project rows bound to removed/mismatched Team epochs and fails503 TEAMWORK_RECONCILIATION_REQUIRED per Team until audited repair. Wrong flag re-enablement cannot silently serve those rows. Actor without Team access still gets403. |
| P1-1/P2-1: adjacent-prose restriction / stale active mention label | Token-identity/count retention replaces surrounding-segment equality. Active canonical label and structured mention snapshot are refreshed together on edit; history is retained. |
| P1-3: fabricated prepare replay count / mixed PR sync version | E61 stores its committed batch count in safe response_ref and reuses it. PR sync replays its original safe protocol result/version together. Ordinary mutation replay remains an authorized current projection of the original effect, not byte-identical historical content; see§12 and the Section18 execution profile. |
| P1-4/P1-5: page/version trap / nonmember reviewer map | Sync contract explicitly requires fresh K and returned current V per page, with per-page commits and partial/incomplete state until completed. Sync maps only current eligible root members; other IDs become external with mapping_complete=false and their external name. |
| P1-6/P1-7: NULL-expiry staging / outcome audit lost after approval expiry | New staging requires positive owner expiry. Legacy NULL rows require explicit cleanup age. Cleanup fences expired conversion-only sessions too, locks Teams/current session/upload rows, retains every committed reference and emits intent audit before network I/O. A narrowly bound audit-only completion helper records outcome against that committed intent even after the original grant expires; each new batch still requires a current approval. |
| P2-4: inconsistent warn-only field coverage | Explicit shared field registry includes task description and nested typed conversion payload fields. Messages say possible-secret hint (4 patterns only); no warning persistence, DLP guarantee or file-byte scan. |
| P2-8(l)/(o)/(p)/(q) | Preflight authorizes before mention parsing, locks only actor/creator/actually referenced IDs, and prepares at most50 plan objects without reloading/revalidating all payloads each time; full graph is checked at seal/commit and pinned epochs are checked on every batch. Multipart part SHA256 is required and signed. Task action permission is checked before rich VERSION_CONFLICT current output. |

P2-2's proposed5TiB cap is **not applied**: the current [AWS S3 limits](https://docs.aws.amazon.com/AmazonS3/latest/userguide/qfacts.html) document approximately48.8TiB, consistent with10,000×5GiB parts. Imposing5TiB as a platform fact would introduce an outdated, arbitrary cap. Declaration boundary tests use a storage double and are not real capacity acceptance. For the required part-checksum transport see [AWS multipart checksum requirements](https://docs.aws.amazon.com/AmazonS3/latest/userguide/mpuoverview.html).

P2-7's Team-name hash input is retained because team_name is actual shared Context/header content (§6 registry/§9.1); omitting it could pair a current header with a stale ETag. Root-own counts/last activity, tombstone totals, category display-retirement, completion-order resource versions, fence deletion, retained key history and dedicated prefix-wide IAM scope remain deliberate existing choices, documented in the detailed response. Numeric User/Team-membership/Project-membership IDs can coincide: field/path domains are explicit, but an integer has no provenance; falsely promising every wrong-namespace integer returns404 is impossible without a new ID protocol.

### 20.2 Exact implementation and handoff additions

Add `app/teamwork/openapi.py` after closed response models and before main's final router/schema setup; `install_openapi(app)->None` installs a lazy, cached generator only. It imports locked FastAPI/Pydantic/local DTOs and reads the packaged endpoint inventory; no network, migrations or new routes. Add typed VersionCurrent/ResourceVersionCurrent/InheritedMembersCurrent/ApplicationError/ErrorEnvelope models there. Extend inventory tests to validate errors/header rules and all generated references.

`paging.sql_page(...,row_mode=False,key_values=None,prepare_rows=None)` supports compound SQL keys without unpaged entity hydration. `services/dashboard.filtered_nodes(actor,team_id,filters,*,db)` returns normalized filters and a SQL Select of visible matching node facts; `categories.visible_categories` uses a visible-root subquery; neither creates domain rows. `prs.list_prs` prefetches only the candidate page's reviewers/comment counts. `conversion.preparation_items(session_id,*,db)` selects the next50 unprepared items in sealed order; `_validate_preparation` validates pinned epochs plus selected batch targets, and commit still validates the complete graph. `execution._preflight(e,actor,ids,body)` reads only after current scope authorization, then the writer obtains ordered User locks and reauthorizes. No target User lock is acquired late under a root lock.

`teamwork_operator.record_cleanup_outcome(context,approval,actor,action,team_id,upload_id)` accepts only the two cleanup outcome actions, exact actor/database target and an existing matching committed intent audit. It is not a fresh permission to delete storage. `teamwork_staging_cleanup.cleanup(...,conversion_after_id=0)` adds a separate conversion cursor/counter; the CLI accepts --conversion-after-id. No runtime role gets object deletion permissions. `VEGENT_TEAMWORK_LEGACY_STAGING_MAX_AGE_SECONDS` is an explicit operator-only policy; absence with live legacy NULL staging fails closed. Retained SQL history is never purged.

Generated `Design/FRONTEND_API_CONTRACT.md` is derived from the runtime schema/registry and provides client protocol notes; it is not a second independent design or a frontend implementation. `Verification/IMPLEMENTATION_FEEDBACK_RESPONSE.md` answers every checklist item and P2 subitem, including counter-evidence and unresolved owner gates. Deployment guide and manifest bind the final candidate to its exact source/tests/schema/OpenAPI and evidence.

### 20.3 Remaining gates — do not label pilot reliability achieved

Actual TTL selection/residual-window acceptance and live issue→remove→GET→expiry checks; actual per-principal/IP/method admission and Gateway rate/burst/error mapping; target-RDS engine/performance at2× actual pilot scale; live S3 versioning/CORS/checksum/conditional/slow-completion/late-arrival proof; enterprise provider compatibility; real1,024MB Lambda/bcrypt benchmark; deployed rollback/reconcile and frontend/local-snapshot/grey-cache/retry integration; and retained-data policy/operator mapping still need owner-environment evidence. No owner value/sign-off is fabricated. Local test counts and measurements are recorded in results.json, with Team Work versus identity/regression counts separated. No deployment, production migration, seed or frontend production code follows these fixes.


**Owner workload clarification (same remediation turn):** most resources are small development design documents and implementation plans. Prioritize the existing single-PUT/small-file/version/download/retry path in qualification. Multipart is retained compatibility rather than an expansion target; no new product size quota or additional large-file feature is authorized by this clarification. Batch projection prefetch is request-local under the existing RR snapshot/User+Team shared locks, never a cross-request ACL cache. Page statistics, eligible member inputs, child metadata and short note previews are batched; the shared Context hash still observes its required complete root/member/child record. Actual maximum-scale RDS/Lambda qualification remains open.
