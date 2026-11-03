# Vegent Team Work Backend

**Contract2.1-r3 feedback-remediation candidate. Local verification is recorded in Verification/REPORT.md; owner review/configuration and real-environment gates remain open.** One combined Lambda extends the existing identity service and uses the same MySQL database. Wei manages the actual AWS resources and database instance. This task has not provisioned AWS, migrated/seeded a pilot database or deployed the service.

Start with [the deployment guide](DEPLOYMENT_GUIDE.md), then [verification evidence](Verification/REPORT.md) and the [point-by-point feedback response](Verification/IMPLEMENTATION_FEEDBACK_RESPONSE.md). The [authoritative design and implementation instructions](Design/vegent-teamwork-backend-design-v2-additions.md) remain authoritative; the [generated OpenAPI](Design/openapi.json) is its typed HTTP handoff. Historical design-only gates are superseded by the owner's implementation instruction recorded in Section18.

```text
TeamWork/
  README.md
  DEPLOYMENT_GUIDE.md
  Lambda/
    vegent-identity-teamwork.zip
    manifest.json
  MySQL/
    schema.sql
    operator-tools.zip
  Design/
    vegent-teamwork-backend-design-v2-additions.md
    openapi.json
    FRONTEND_API_CONTRACT.md
  Requirements/
    [four unchanged owner request documents]
  Verification/
    REPORT.md
    IMPLEMENTATION_FEEDBACK_RESPONSE.md
    results.json
```

The service implements Category → Project → SubProject, epoch-bound inherited membership, qualitative progress, tasks, comments/mentions/revisions, PR mirrors, direct S3 resource versioning, full Context/text paging, Dashboard, lifecycle and explicit import/conversion. Local session execution and Personal Agent memory remain local. No notification/IM system, implicit synchronization, private inspection bypass or operator enrolment is introduced.

The Lambda archive is the deployable runtime. The operator archive contains source, locked dependencies and ordered migrations; its review SQL must not be installed a second time alongside Alembic. Development/tests/build intermediates stay in the single support workspace at `/Users/weizhang/Desktop/VegentSupport/identity-development/`. No duplicate source checkout is placed in this delivery folder.

The original auth-only archives are preserved unchanged. The new candidate needs its own AWS/network/storage/performance qualification. The S3 URL ceiling is900seconds with a required actual owner value; it does not implement native immediate revocation. New staging requires explicit expiry configuration. Ingress admission/throttling, target-RDS timing and actual frontend/local import tests are not certified by local tests. All maintained documents and comments are English and use Vegent / Verizon branding. Requirements originals are unchanged review evidence.
