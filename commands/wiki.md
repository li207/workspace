---
title: Wiki Knowledge Base
description: Team knowledge base with auto-extraction from completed tasks
user-invocable: true
args:
  - name: command
    description: Natural language wiki command
    type: string
    required: false
---

Manage wiki knowledge base. Config: `~/.claude/workspace-path.txt` → WIKI_DIR

**Timezone: All dates must be calculated in PST (America/Los_Angeles).**

## Command: {{command}}

**Intents:** create/add/new/write | list/show/browse | open/read/view | edit/update/revise | search/find/grep | harvest/extract/gather | move/recategorize | delete/remove | review/refresh/rebuild | help

## Path Configuration

Read `~/.claude/workspace-path.txt` to get:
- `WIKI_DIR` — wiki article storage (e.g., `~/projects/team-wiki/`)
- `WORKSPACE_DATA_DIR` — task data (needed for HARVEST)

If `WIKI_DIR` is not set, tell the user to run `./bootstrap.sh` or add `WIKI_DIR=...` to `~/.claude/workspace-path.txt`.

## Data Layout

```
WIKI_DIR/
├── wiki-index.md                    # Auto-generated table of contents
├── how-to/
│   └── {kebab-case-name}.md
├── architecture/
│   └── {kebab-case-name}.md
├── troubleshooting/
│   └── {kebab-case-name}.md
├── onboarding/
│   └── {kebab-case-name}.md
├── reference/
│   └── {kebab-case-name}.md
└── uncategorized/
    └── {kebab-case-name}.md
```

## Operations

**CREATE** → Parse title, optional `category: {name}`, optional `tags: tag1, tag2`. Auto-detect category from title if not specified. Generate kebab-case filename from title. Create article from template. Regenerate `wiki-index.md`.

**Category auto-detection from title:**
```
"how to|guide|steps|tutorial"          → how-to
"architecture|design|system|diagram"   → architecture
"fix|debug|error|troubleshoot"         → troubleshooting
"setup|install|onboard|getting started" → onboarding
"api|reference|config|spec"            → reference
(default)                              → uncategorized
```

**Filename generation:** Title → lowercase → remove leading "how to"/"a"/"the" → replace non-alphanumeric with hyphens → collapse consecutive hyphens → trim. Max ~60 chars. If file exists, append `-2`, `-3`, etc.

**Article template:**
```markdown
# {Article title}
- **category**: {category}
- **created**: YYYY-MM-DD
- **updated**: YYYY-MM-DD
- **tags**: [{parsed tags}]
- **source-task**: manual
- **status**: draft

## Summary
{Brief overview — ask user or generate from title}

## Content
{Main article body — ask user for content or create placeholder}

## See Also
- {Related links will go here}
```

**LIST** → Read `wiki-index.md` and display. If a category is specified (e.g., `/wiki list how-to`), filter to that category. Show: title, category, status, last updated.

**OPEN** → Resolve article by name, partial match, or filename. Read and display the full article content. Search across all category folders if needed.

**EDIT** → Resolve article. Make requested changes. Update `updated` date. Regenerate `wiki-index.md` if metadata changed.

**SEARCH** → Search across all `WIKI_DIR/{category}/*.md` files for keyword matches. Check title (# heading), tags, summary, and content. Display matching articles with relevant context snippets. Case-insensitive matching.

**HARVEST** → Batch-extract wiki articles from completed tasks:
1. Read `WORKSPACE_DATA_DIR` from config
2. Scan all `WORKSPACE_DATA_DIR/archive/*/` folders
3. For each archived task, compute wiki-worthiness score:

**Wiki-worthiness scoring:**

| Signal | Points | Check |
|--------|--------|-------|
| PLAN.md has >= 3 detailed steps | +3 | Count step entries under `## Steps` |
| PROGRESS.md Accomplishments >= 3 entries | +2 | Count `[YYYY-` timestamped lines in Accomplishments |
| Tags include architecture/design | +2 | Check task.md tags field |
| Bug fix with investigation notes | +3 | Title has fix/debug/error + docs/ or logs/ has files |
| PROGRESS.md has Decisions entries | +2 | Decisions section has content beyond "None" |
| docs/ folder has content | +2 | Files exist in docs/ |
| Task duration >= 3 days | +1 | created vs completed date difference |
| Priority p0 or p1 | +1 | task.md priority field |
| **Threshold** | **>= 4** | |

4. Present candidates (score >= 4) as numbered list:
```
Wiki-worthy tasks found:

1. [Score: 7] "fix auth timeout" → "How to Debug Authentication Timeouts" (troubleshooting)
2. [Score: 5] "implement caching" → "Caching Layer Architecture" (architecture)
3. [Score: 4] "setup staging env" → "Staging Environment Setup Guide" (onboarding)

Create articles? (all / 1,3 / skip)
```

5. For selected tasks, extract content:
   - **Title**: Rephrase task title as knowledge article
   - **Category**: Auto-detect from task type/tags
   - **Summary**: From PROGRESS.md final summary or task context
   - **Content**: Steps from PLAN.md, decisions from PROGRESS.md, pitfalls from resolved blockers
   - **Tags**: Inherit from task.md
   - **source-task**: task-id (links back to archive)
   - **status**: draft

6. Create articles in appropriate category folders
7. Regenerate `wiki-index.md`

**MOVE** → Resolve article. Move file from current category folder to target category folder. Update `category` field in article metadata. Regenerate `wiki-index.md`.

**DELETE** → Resolve article. Confirm with user. Delete file. Regenerate `wiki-index.md`.

**REVIEW** → Full scan and rebuild:
1. Scan all category folders (`how-to/`, `architecture/`, etc.) for `.md` files
2. Read metadata (title, category, status, updated, tags) from each article
3. Regenerate `wiki-index.md` from scratch
4. Display stats: total articles, by category, draft vs published, recently updated

**HELP** → Read `modules/wiki/README.md` via Task tool

## wiki-index.md Generation

Regenerate (not append) after: create, edit, move, delete, harvest. Build by scanning all `WIKI_DIR/{category}/*.md` files and reading their metadata.

**wiki-index.md template:**
```markdown
# Wiki Index

> Last updated: YYYY-MM-DD HH:MM PST
> Total articles: N | Published: N | Drafts: N

## How-To Guides
- [[{Article Title}]] — {filename} ({status}, updated {date})

## Architecture
- [[{Article Title}]] — {filename} ({status}, updated {date})

## Troubleshooting
- [[{Article Title}]] — {filename} ({status}, updated {date})

## Onboarding
- [[{Article Title}]] — {filename} ({status}, updated {date})

## Reference
- [[{Article Title}]] — {filename} ({status}, updated {date})

## Uncategorized
- [[{Article Title}]] — {filename} ({status}, updated {date})

---
*Regenerated by `/wiki review`. Browse in Obsidian for best experience.*
```

Categories with no articles show `(empty)` instead of article list.

## Cross-Linking

- **Internal**: `[[Article Title]]` for wiki-to-wiki links
- **External**: `[text](url)` for web resources
- **Task refs**: Link to `WORKSPACE_DATA_DIR/archive/{task-id}/PROGRESS.md`

## Paths
- Articles: `WIKI_DIR/{category}/{filename}.md`
- Index: `WIKI_DIR/wiki-index.md`
- Archive (for harvest): `WORKSPACE_DATA_DIR/archive/{task-id}/`

**Errors:** No config → run bootstrap | No article found → suggest search | Ambiguous match → ask clarification | Empty wiki → suggest create or harvest
