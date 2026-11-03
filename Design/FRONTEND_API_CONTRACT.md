# Vegent Team Work Frontend API Contract

Generated from runtime schema. Contract: **2.1-r3**. Local candidate only; owner-environment gates remain open. This is an API handoff, not a frontend implementation or second design.

## Endpoint header/version/body table

All rows use Bearer. K means a required UUIDv4 Idempotency-Key. Context hash and entity versions are different domains.

| ID | Method/path | K | If-Match | Body |
| --- | --- | --- | --- | --- |
| E02 | `GET /api/teams/{team_id}/projects/{project_id}/members` | no | none | no body |
| E03 | `POST /api/teams/{team_id}/projects/{project_id}/members` | yes | root Project.version; required | MemberAdd |
| E04 | `DELETE /api/teams/{team_id}/projects/{project_id}/members/{project_member_id}` | yes | root Project.version; required | no body |
| E05 | `POST /api/teams/{team_id}/projects/{project_id}/ownership-transfer` | yes | root Project.version; required | OwnerTransfer |
| E06 | `POST /api/teams/{team_id}/projects/{project_id}/comments` | yes | none | CommentCreate |
| E07 | `GET /api/teams/{team_id}/projects/{project_id}/comments` | no | none | no body |
| E08 | `GET /api/teams/{team_id}/projects/{project_id}/comments/{comment_id}` | no | none | no body |
| E09 | `PUT /api/teams/{team_id}/projects/{project_id}/comments/{comment_id}` | yes | Comment.version; required | CommentEdit |
| E10 | `DELETE /api/teams/{team_id}/projects/{project_id}/comments/{comment_id}` | yes | Comment.version; required | no body |
| E11 | `GET /api/teams/{team_id}/projects/{project_id}/context` | no | shared context_version (64 lowercase hex; quotes accepted); conditional | no body |
| E12 | `POST /api/teams/{team_id}/projects/{project_id}/imports` | yes | none | ImportCreate |
| E13 | `POST /api/teams/{team_id}/conversions` | yes | none | ConversionCreate |
| E14 | `GET /api/teams/{team_id}/conversions/{conversion_id}` | no | none | no body |
| E15 | `POST /api/teams/{team_id}/conversions/{conversion_id}/items/{item_id}/upload-authorizations` | yes | ConversionSession.version; required | UploadCreate |
| E16 | `POST /api/teams/{team_id}/conversions/{conversion_id}/commit` | yes | ConversionSession.version; required | required empty JSON object {} |
| E17 | `POST /api/teams/{team_id}/projects/{project_id}/resources/{resource_id}/download-authorizations` | yes | none | DownloadCreate |
| E18 | `GET /api/teams/{team_id}/projects` | no | none | no body |
| E19 | `GET /api/teams/{team_id}/dashboard` | no | none | no body |
| E20 | `POST /api/teams/{team_id}/projects` | yes | none | ProjectCreate |
| E21 | `GET /api/teams/{team_id}/categories` | no | none | no body |
| E22 | `POST /api/teams/{team_id}/categories` | yes | none | CategoryCreate |
| E23 | `PUT /api/teams/{team_id}/categories/{category_id}` | yes | Category.version; required | CategoryPatch |
| E24 | `DELETE /api/teams/{team_id}/categories/{category_id}` | yes | Category.version; required | required LifecycleBody with confirm:true |
| E25 | `GET /api/teams/{team_id}/projects/{project_id}` | no | none | no body |
| E26 | `PUT /api/teams/{team_id}/projects/{project_id}` | yes | Project.version; required | ProjectPatch |
| E27 | `POST /api/teams/{team_id}/projects/{project_id}/subprojects` | yes | Project.version; required | ChildCreate |
| E28 | `GET /api/teams/{team_id}/projects/{project_id}/subprojects` | no | none | no body |
| E29 | `POST /api/teams/{team_id}/projects/{project_id}/archive` | yes | Project.version; required | required empty JSON object {} |
| E30 | `POST /api/teams/{team_id}/projects/{project_id}/unarchive` | yes | Project.version; required | required empty JSON object {} |
| E31 | `DELETE /api/teams/{team_id}/projects/{project_id}` | yes | Project.version; required | required LifecycleBody with confirm:true |
| E32 | `GET /api/teams/{team_id}/projects/{project_id}/tasks` | no | none | no body |
| E33 | `POST /api/teams/{team_id}/projects/{project_id}/tasks` | yes | none | TaskCreate |
| E34 | `PUT /api/teams/{team_id}/projects/{project_id}/tasks/{task_id}` | yes | Task.version; required | TaskPatch |
| E35 | `PUT /api/teams/{team_id}/projects/{project_id}/tasks/{task_id}/status` | yes | Task.version; required | TaskStatus |
| E36 | `POST /api/teams/{team_id}/projects/{project_id}/tasks/{task_id}/archive` | yes | Task.version; required | required empty JSON object {} |
| E37 | `POST /api/teams/{team_id}/projects/{project_id}/tasks/{task_id}/unarchive` | yes | Task.version; required | required empty JSON object {} |
| E38 | `DELETE /api/teams/{team_id}/projects/{project_id}/tasks/{task_id}` | yes | Task.version; required | required LifecycleBody with confirm:true |
| E39 | `PUT /api/teams/{team_id}/projects/{project_id}/progress` | yes | Project.version; required | ProgressPatch |
| E40 | `GET /api/teams/{team_id}/projects/{project_id}/progress-events` | no | none | no body |
| E41 | `GET /api/teams/{team_id}/projects/{project_id}/prs` | no | none | no body |
| E42 | `POST /api/teams/{team_id}/projects/{project_id}/prs/sync` | yes | Project.version; required | PRSync |
| E43 | `GET /api/teams/{team_id}/projects/{project_id}/resources` | no | none | no body |
| E44 | `POST /api/teams/{team_id}/projects/{project_id}/resource-upload-authorizations` | yes | none | UploadCreate |
| E45 | `GET /api/teams/{team_id}/uploads/{upload_id}` | no | none | no body |
| E46 | `POST /api/teams/{team_id}/uploads/{upload_id}/part-authorizations` | yes | UploadState.version; required | PartAuthorization |
| E47 | `POST /api/teams/{team_id}/uploads/{upload_id}/complete` | yes | UploadState.version; required | UploadComplete |
| E48 | `POST /api/teams/{team_id}/uploads/{upload_id}/cancel` | yes | UploadState.version; required | CancelBody |
| E49 | `POST /api/teams/{team_id}/projects/{project_id}/resources/{resource_id}/archive` | yes | Resource.entity_version (not its logical version); required | required empty JSON object {} |
| E50 | `POST /api/teams/{team_id}/projects/{project_id}/resources/{resource_id}/unarchive` | yes | Resource.entity_version (not its logical version); required | required empty JSON object {} |
| E51 | `DELETE /api/teams/{team_id}/projects/{project_id}/resources/{resource_id}` | yes | Resource.entity_version (not its logical version); required | required LifecycleBody with confirm:true |
| E52 | `GET /api/teams/{team_id}/projects/{project_id}/resources/{resource_id}/versions` | no | none | no body |
| E53 | `GET /api/teams/{team_id}/projects/{project_id}/context-items` | no | none | no body |
| E54 | `POST /api/teams/{team_id}/projects/{project_id}/context-items` | yes | none | ContextItemCreate |
| E55 | `PUT /api/teams/{team_id}/projects/{project_id}/context-items/{item_id}` | yes | ContextItem.version; required | ContextItemPatch |
| E56 | `DELETE /api/teams/{team_id}/projects/{project_id}/context-items/{item_id}` | yes | ContextItem.version; required | required LifecycleBody with confirm:true |
| E57 | `GET /api/teams/{team_id}/dashboard/activity` | no | none | no body |
| E58 | `GET /api/teams/{team_id}/projects/{project_id}/context/text` | no | shared context_version (64 lowercase hex; quotes accepted); required | no body |
| E59 | `POST /api/teams/{team_id}/conversions/{conversion_id}/items` | yes | ConversionSession.version; required | ConversionItem |
| E60 | `POST /api/teams/{team_id}/conversions/{conversion_id}/seal` | yes | ConversionSession.version; required | required empty JSON object {} |
| E61 | `POST /api/teams/{team_id}/conversions/{conversion_id}/prepare` | yes | ConversionSession.version; required | required empty JSON object {} |
| E62 | `POST /api/teams/{team_id}/conversions/{conversion_id}/cancel` | yes | ConversionSession.version; required | CancelBody |
| E63 | `GET /api/teams/{team_id}/projects/{project_id}/activity` | no | none | no body |
## Client protocol notes

All62 new routes require application Bearer authentication; bootstrap remains the existing IAM-only identity route. No new endpoint, token claim, role, restore/enrolment permission or public documentation route is added. IDs are positive safe JSON integers; User IDs, identity Team membership IDs and Project membership IDs are separate domains that can contain the same numeric value. Use the exact named field/path, never infer provenance from the integer.

Team Work uses cursor-only pagination; unknown/duplicate query keys and page= return422. Booleans are literal true/false strings. A page can be shorter than limit because the transport target is1 MiB. Follow has_more/next_cursor until complete. Cursors are signed and route/filter/scope-bound; INVALID_CURSOR422 means restart that traversal. Identity signing-secret rotation invalidates cursors, with up to five-minute cache overlap across environments. Do not turn an invalid cursor or failed fetch into a revoked-all cache update.

Team list pages are fresh per-request observations, not a pinned whole-Team snapshot across requests. Mutable sorting can move an item across a cursor. Before marking an omitted cached Project grey, verify its qualified detail endpoint returns an application PROJECT_NOT_FOUND/NOT_FOUND404; an unknown-route/Gateway404 with a different body is a configuration failure, not revocation; failures/401/403/409/422/503 or incomplete traversal are not evidence that every cached Project was revoked. Never invent a server tombstone for a never-fetched Project. The actual frontend grey-cache implementation/test remains a separate handoff.

### Errors and versions

Known application errors use ErrorEnvelope={error:{code,message,request_id,current?}}, including422; FastAPI detail[] is not emitted. See operation responses for possible statuses/current types. TEAM_ACCESS_DENIED403 includes unknown Team; PROJECT_NOT_FOUND and NOT_FOUND are404. INHERITED_MEMBERSHIP409 includes current.members_href. TEAMWORK_NOT_ENABLED503 is maintenance; TEAMWORK_RECONCILIATION_REQUIRED503 requires audited repair; STAGING_POLICY_REQUIRED/STORAGE_NOT_CONFIGURED/PROVIDER_NOT_CONFIGURED503 require configuration. Other storage/provider/DB503 may be transient. Preserve the draft; version-conflict current is a permitted current projection, not a replacement for the user's edits.

Every mutation requires canonical lowercase UUIDv4 Idempotency-Key. Reuse it only for an uncertain retry of the same normalized method/path/body/query/version. Ordinary replay returns a current authorized projection of the original committed effect; it does not reexecute that effect or return a stored historical body. Access loss remains404/403, and an add later removed can replay404. E61 prepared is its original committed batch count with current session state. E42 replay preserves its original safe sync protocol result/version together. Operation.committed_version describes the original operation, not necessarily the current DTO version. Keys are retained without a24-hour expiry/purge guarantee; do not reuse UUIDs later.

Entity If-Match is a quoted positive integer from the correct version basis in the table. Context If-Match is64 lowercase hex, raw or quoted; it is not an entity version. If-None-Match is supported only on the initial Context manifest without section/cursor, after current authorization; successful unchanged response is304 with no body. A malformed value is422; an out-of-date value is409. Project member operations use root Project.version, not a membership version. Resource lifecycle uses entity_version, not the logical resource version.

### Delete/body matrix

E04 Project-member and E10 comment DELETE consume no body. E24 Category, E31 Project, E38 task, E51 resource and E56 Context-item DELETE require LifecycleBody with confirm:true. Archive/unarchive, seal, prepare and commit endpoints marked empty in the table require {}. Six non-Project DELETE kinds replay204 for the same committed key within an authorized enclosing scope. Project delete remains404 even with the same key; after an uncertain DELETE treat that as probable success, not proof of original nonexistence, and reconcile without resurrecting data.

### TextRef and complete imports

TextValue is {inline,ref}; fields are not plain strings. Long text is a TextRef with kind/object_id/field/resource_version/context_version/utf8_bytes/href. Up to2,048 characters are inline; resolve ref.href with If-Match=context_version and Unicode-character offset/limit, following next_offset until complete. A fragment is at most131,072 characters. This is a transport bound, not a total Context quota. Do not request internal/revision/S3 fields through the static selector.

Context contains all10 own-node sections, including comments/tombstones, not file bytes. The first manifest contains short section pages, not complete collections. Traverse every section and TextRef at one hash; CONTEXT_CHANGED409 restarts the whole collection with bounded jitter/backoff, then pause/preserve the draft after three immediate attempts. Child Context is independent: a root contains child summaries/links, not an automatic recursive import of unselected child work or file bytes.

Persist an immutable local snapshot before requesting an import receipt. Key it by a new local_import_id UUID plus cloud Team/node/contract/context_version, containing all collected metadata/text and local application state. Receipt is an actor-scoped version claim, not server proof of traversal, local application, a cloud snapshot or a backup. Receipt failure does not delete the local snapshot. Import again creates a new snapshot/UUID and preserves the prior one; compare its stored hash to a freshly authorized manifest to detect divergence. Lost local data cannot be restored from a receipt; refetch/import explicitly. No GET imports endpoint or local path/device/session capability is included. Archived/orphaned Project reads/imports are permitted; can_import is independent of write-disabled reasons. The backend protocol collector test is not a browser/local-core integration test.

### PR sync and conversion

Owner supplies repository_ref values out-of-band. Sync failure503 leaves stored PR mirrors readable. Noneligible or unmapped reviewer IDs remain external with reviewer_mapping_complete=false and their external name; reviewers never grant membership. Sync commits one provider page per request, not an atomic repository snapshot. Each continuation requires a fresh key and If-Match equal to the previous returned project_version; on an intervening write re-read the Project version and retry the same continuation with a new request key/version. Explicit external_pr_ids uses one ID per call. Running/continuation means incomplete sync; continue to completed or display partial/interrupted state with per-PR synced_at. A failed page leaves earlier pages; do not label them one coherent provider snapshot. No external PR create/merge/close/diff operation exists.

Conversion is planning->sealed->preparing->ready->committed. Prepare processes at most50 selected plan items, uses the current session version plus its seal-guard cursor and a fresh key, and repeats until ready; commit then publishes once. The cursor is not an offset. No prepared row is visible before publication. Sealed actor/member epoch drift returns409 PLAN_MEMBERS_CHANGED and requires cancel/restart; no reseal endpoint exists. Selected resources must be verified; no implicit children/files or local ownership proof is inferred. New staging requires positive owner-selected expiry values; no default/no-expiry policy is silently chosen. Legacy NULL-expiry staging is quarantined for the reviewed operator sweep.

### Resource capabilities and warnings

Direct S3 capabilities are deliberately excluded from list/Context. Authorization replay reuses its intent/effect and can issue a newly authorized URL/expiry; it is not byte-identical URL replay. Actual owner TTL is required in1–900seconds; the code ceiling is not a selected owner value or immediate revocation. Existing URLs can survive membership/resource/Project loss until expiry. Archive preserves read/download access. Do not proxy file bytes through Lambda or automatically rotate credentials to imply otherwise.

Single PUT handles small files and a declared full-object SHA256 within its physical ceiling. Without declared full-object SHA256, multipart starts at100MiB. Multipart requires each part's lowercase hex checksum_sha256; the signed PUT requires the returned checksum header. The client must include all part checksums in ordered completion XML, inspect the S3 response body even on HTTP200, then request HEAD-based confirmation. Composite SHA256 is not full-file SHA256 and ETag is not a hash substitute. The current S3 object ceiling follows10,000×5GiB parts; no obsolete5TiB product cap is imposed. Live S3/CORS/checksum/slow-completion/expiry acceptance remains pending.

Possible-secret hint (4 patterns only) is warn-only for top-level content/note/context/body/answer/background/goals/description/progress_note and those fields in a typed conversion payload. It is not DLP, does not scan resource bytes and is not persisted. Warning failure cannot veto a committed write. Task/PR/comment changes do not auto-update qualitative progress; parent counts/last activity are own-node only, Team totals count matching roots+children once. Comment totals include tombstones; task totals include archived nondeleted tasks. Category retirement is display-only movement to No Category with retained internal references.

### Required owner handoff and remaining gates

The primary resource workload is small design documents and implementation plans. Prioritize the conditional single-PUT/HEAD-confirm/version/download/retry path; multipart is retained compatibility rather than a new enhancement target.

No Team Work application limiter/429 is implemented. Owner ingress admission and Gateway method/stage throttling are mandatory before pilot reliance, with stricter E17/E42/E18/E19/E57 buckets and evidenced rate/burst values. Gateway method buckets alone are not per-user limits; owner must qualify the actual principal/IP control and429 response shape. Reserved concurrency is not admission. No provisioned throttle or latency guarantee is assumed.

Hand off qualified URL/stage/VPN/DNS requirements, this contract version, actual media types, URL TTL, upload/conversion expiries, repository_ref values and error/admission settings without credentials or capabilities. No configuration-discovery endpoint is added to the frozen62-route inventory. Real AWS/RDS/S3/provider/performance and browser/local-snapshot/grey-cache/retry integration remain explicitly pending. Read the deployment guide and feedback response before pilot qualification.
