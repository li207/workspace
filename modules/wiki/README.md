# Wiki Module - Team Knowledge Base

A knowledge base that grows naturally from completed tasks. Articles are auto-extracted from archived work, turning investigation notes, plans, and decisions into reusable documentation.

## Overview

The `/wiki` command manages a structured knowledge base stored in a separate directory (`~/projects/team-wiki/`). Articles are organized by category, written in markdown with `[[wiki-links]]` for internal references and `[text](url)` for external links. The wiki starts personal but is structured to grow into a team resource.

## Quick Start
```bash
/wiki create how to deploy to staging, category: how-to
/wiki list
/wiki search deploy
/wiki harvest                  # Extract articles from completed tasks
/wiki review                   # Regenerate wiki-index.md
```

## Data Layout

```
~/projects/team-wiki/                    # WIKI_DIR (separate folder)
├── wiki-index.md                        # Auto-generated table of contents
├── how-to/
│   └── deploy-to-staging.md             # Descriptive kebab-case filenames
├── architecture/
│   └── auth-system-overview.md
├── troubleshooting/
│   └── database-timeout-diagnosis.md
├── onboarding/
│   └── new-engineer-setup.md
├── reference/
│   └── api-endpoints-cheatsheet.md
└── uncategorized/
    └── useful-git-commands.md
```

## Categories

| Category | Purpose | Keyword Triggers |
|----------|---------|-----------------|
| `how-to` | Step-by-step guides and tutorials | how to, guide, steps, tutorial |
| `architecture` | System design and architecture decisions | architecture, design, system, diagram |
| `troubleshooting` | Debugging guides and fix documentation | fix, debug, error, troubleshoot |
| `onboarding` | Setup guides and getting-started docs | setup, install, onboard, getting started |
| `reference` | Quick-reference material and specs | api, reference, config, spec |
| `uncategorized` | Articles that don't fit other categories | (default) |

### Category Auto-Detection

When creating an article, the category is auto-detected from the title using keyword matching:

```
Title contains "how to|guide|steps|tutorial"      → how-to
Title contains "architecture|design|system|diagram" → architecture
Title contains "fix|debug|error|troubleshoot"       → troubleshooting
Title contains "setup|install|onboard|getting started" → onboarding
Title contains "api|reference|config|spec"          → reference
(no match)                                          → uncategorized
```

User can override auto-detection by specifying `category: {name}` explicitly.

## Intents

| Intent | Aliases | Description |
|--------|---------|-------------|
| **CREATE** | create, add, new, write | Create a new wiki article |
| **LIST** | list, show, browse | Display articles from wiki-index.md |
| **OPEN** | open, read, view | Open and display an article |
| **EDIT** | edit, update, revise | Modify an existing article |
| **SEARCH** | search, find, grep | Search articles by keyword |
| **HARVEST** | harvest, extract, gather | Batch-extract articles from completed tasks |
| **MOVE** | move, recategorize | Move article to a different category |
| **DELETE** | delete, remove | Delete a wiki article |
| **REVIEW** | review, refresh, rebuild | Regenerate wiki-index.md |
| **HELP** | help | Show this documentation |

## Article Template

```markdown
# {Article title}
- **category**: {category}
- **created**: YYYY-MM-DD
- **updated**: YYYY-MM-DD
- **tags**: [tag1, tag2]
- **source-task**: {task-id or "manual"}
- **status**: draft | published

## Summary
{1-2 sentence overview}

## Content
{Main article body}

## See Also
- [[Related Article]]
- [External resource](https://...)
```

## Filename Convention

Filenames are derived from the article title using kebab-case:

1. Convert title to lowercase
2. Remove articles and filler words at the start ("how to", "a", "the")
3. Replace spaces and special characters with hyphens
4. Remove consecutive hyphens
5. Trim to a reasonable length (max ~60 chars)

**Examples:**
- "How to Deploy to Staging" → `deploy-to-staging.md`
- "Authentication System Overview" → `authentication-system-overview.md`
- "Fix: Database Timeout Under Load" → `database-timeout-under-load.md`

**Collision handling:** If a file with the same name exists, append a number: `deploy-to-staging-2.md`.

## Operations

### CREATE
Parse title, optional category override, and tags. Auto-detect category from title keywords. Generate kebab-case filename. Create article from template in `WIKI_DIR/{category}/{filename}.md`. Regenerate `wiki-index.md`.

### LIST
Read and display `wiki-index.md`. Show articles grouped by category with title, status, and last updated date. Support filtering: `/wiki list how-to` shows only that category.

### OPEN
Resolve article by name, partial match, or path. Read and display the article content.

### EDIT
Resolve article, open for editing. Update the `updated` date in metadata. Regenerate `wiki-index.md` if metadata changed.

### SEARCH
Search across all articles for keyword matches in title, content, tags, and summary. Display matching articles with context snippets. Case-insensitive.

### HARVEST
Batch-extract wiki articles from completed tasks in `WORKSPACE_DATA_DIR/archive/`:

1. Scan all `archive/*/` folders
2. Score each task for wiki-worthiness (see scoring below)
3. Present candidates scoring >= 4 as a numbered list with proposed title, category, and outline
4. User selects which to create (all, specific numbers, or skip)
5. For each selected: generate article draft from task content
6. Created articles have `status: draft` and `source-task: {task-id}`
7. Regenerate `wiki-index.md`

### MOVE
Move an article from one category to another:
1. Resolve article
2. Move file to new category folder
3. Update `category` in article metadata
4. Regenerate `wiki-index.md`

### DELETE
Resolve article, confirm deletion, remove file. Regenerate `wiki-index.md`.

### REVIEW
Full scan and rebuild:
1. Scan all category folders for `.md` files
2. Read metadata from each article
3. Regenerate `wiki-index.md` from scratch
4. Report: total articles, by category, by status (draft/published), recently updated

### HELP
Read and display `modules/wiki/README.md`.

## Wiki-Worthiness Scoring

Used by HARVEST and the DONE hook to identify tasks worth extracting into wiki articles.

| Signal | Points | How to Check |
|--------|--------|-------------|
| PLAN.md has >= 3 detailed steps | +3 | Count `## Steps` entries with sub-bullets |
| PROGRESS.md Accomplishments >= 3 entries | +2 | Count timestamped entries in Accomplishments |
| Tags include architecture/design | +2 | Check task.md tags |
| Bug fix with investigation notes | +3 | Task title has fix/debug keywords + docs/ or logs/ has content |
| PROGRESS.md has Decisions entries | +2 | Check Decisions section is non-empty |
| docs/ folder has content | +2 | Check for files in docs/ |
| Task duration >= 3 days | +1 | Compare created vs completed dates |
| Priority p0 or p1 | +1 | Check task.md priority |
| **Threshold** | **>= 4** | Suggest wiki article |

## Content Extraction Strategy

When extracting a wiki article from a completed task:

### Title Transformation
Rephrase the task title as knowledge:
- "fix auth timeout" → "How to Debug Authentication Timeouts"
- "implement caching layer" → "Caching Layer Architecture"
- "investigate memory leak" → "Troubleshooting Memory Leaks"
- "setup staging environment" → "Staging Environment Setup Guide"

### Content Sources
| Source | What to Extract |
|--------|----------------|
| PLAN.md → Steps | Step-by-step procedure (becomes article body) |
| PLAN.md → Design | Architecture details and technical decisions |
| PROGRESS.md → Accomplishments | Key outcomes and what worked |
| PROGRESS.md → Decisions | Decision rationale (becomes decision log) |
| PROGRESS.md → Blockers (resolved) | Common pitfalls and how to avoid them |
| PROGRESS.md → Notes | Additional context and observations |
| task.md → Tags | Inherited as article tags |
| task.md → Context | Background information for Summary |
| docs/ | Supporting documentation and diagrams |

### Extraction Template
```markdown
# {Rephrased title}
- **category**: {auto-detected}
- **created**: {today}
- **updated**: {today}
- **tags**: [{inherited from task}]
- **source-task**: {task-id}
- **status**: draft

## Summary
{Derived from task context + final progress summary}

## Content

### Background
{From task.md Context}

### Steps
{From PLAN.md Steps — reformatted as a guide}

### Key Decisions
{From PROGRESS.md Decisions section}

### Common Pitfalls
{From resolved blockers in PROGRESS.md}

## See Also
- Source task: [{task title}](../workspace-data/archive/{task-id}/PROGRESS.md)
```

## wiki-index.md Template

```markdown
# Wiki Index

> Last updated: YYYY-MM-DD HH:MM PST
> Total articles: N | Published: N | Drafts: N

## How-To Guides
- [[Deploy to Staging]] — deploy-to-staging.md (published, updated Feb 15)

## Architecture
- [[Auth System Overview]] — auth-system-overview.md (published, updated Feb 10)

## Troubleshooting
- [[Database Timeout Diagnosis]] — database-timeout-diagnosis.md (draft, updated Feb 12)

## Onboarding
- [[New Engineer Setup]] — new-engineer-setup.md (published, updated Jan 20)

## Reference
- [[API Endpoints Cheatsheet]] — api-endpoints-cheatsheet.md (published, updated Feb 1)

## Uncategorized
(empty)

---
*Regenerated by `/wiki review`. Browse in Obsidian for best experience.*
```

## Cross-Linking Patterns

### Internal Links (Wiki Links)
Use `[[Article Title]]` for linking between wiki articles:
```markdown
See [[Deploy to Staging]] for the full deployment guide.
```

### External Links (Markdown Links)
Use standard markdown for external resources:
```markdown
See [Kubernetes docs](https://kubernetes.io/docs/) for reference.
```

### Task References
Link back to source tasks:
```markdown
Source: [Fix auth timeout](../workspace-data/archive/abc123/PROGRESS.md)
```

## Obsidian Integration

The `~/projects/team-wiki/` directory works as a standalone Obsidian vault:
- `wiki-index.md` is the entry point
- `[[wiki-links]]` enable graph view navigation
- Category folders appear as folder structure
- Tags are searchable via Obsidian tag search
- Article metadata renders as frontmatter-style headers

## DONE Hook Integration

When `/task done` is called and `WIKI_DIR` is configured:
1. Score the completed task for wiki-worthiness
2. If score >= 4, suggest creating a wiki article
3. Present: proposed title, category, and brief outline
4. User options: accept (creates draft), skip, or "later" (noted for next harvest)
5. If accepted: create article with `status: draft`, link to source task

## Growth Path: Personal to Team

### Phase 1: Personal (current)
- Single user, local folder, no git
- Focus on capturing knowledge from completed tasks

### Phase 2: Version Controlled
- `git init` in wiki directory
- Track changes, enable rollback
- `scripts/sync.sh` auto-syncs if `.git` exists

### Phase 3: Team Wiki
- Push to shared repository
- Multiple contributors
- Review workflow for article quality
- Shared Obsidian vault or web-based viewer

## Configuration

The wiki path is stored in `~/.claude/workspace-path.txt`:
```
WIKI_DIR=/Users/username/projects/team-wiki
```

Set during `./bootstrap.sh` or manually edited.

## Error Handling

| Error | Resolution |
|-------|-----------|
| No WIKI_DIR configured | Run `./bootstrap.sh` or add `WIKI_DIR=...` to `~/.claude/workspace-path.txt` |
| Article not found | Show similar matches, suggest search |
| Category doesn't exist | Create the category folder automatically |
| Duplicate filename | Append number: `filename-2.md` |
| Empty wiki | Suggest `/wiki create` or `/wiki harvest` |

## Natural Language Examples

### Creating Articles
```bash
/wiki create how to deploy to staging
/wiki create auth system overview, category: architecture, tags: auth, security
/wiki new debugging database timeouts
/wiki write API reference for user endpoints
```

### Browsing
```bash
/wiki list
/wiki list how-to
/wiki show architecture articles
/wiki browse troubleshooting
```

### Searching
```bash
/wiki search deploy
/wiki find authentication
/wiki grep timeout
```

### Harvesting
```bash
/wiki harvest                    # Scan all archived tasks
/wiki extract                    # Same as harvest
```

### Managing
```bash
/wiki move deploy-to-staging to onboarding
/wiki delete old-article
/wiki edit deploy-to-staging     # Update existing article
/wiki review                     # Rebuild wiki-index.md
```
