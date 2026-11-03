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

