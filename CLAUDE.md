# BEMA Podcast Archive Project - Instructions for AI Agents

## Project Overview
This project archives the BEMA Discipleship podcast (https://www.bemadiscipleship.com/episodes) into a structured local repository with transcripts, presentations, and summaries. The ultimate goal is to create a book-formatted summary organized by thematic chapters rather than strict episode boundaries.

## Directory Structure

### Per Season
```
season-N/
├── transcripts/
│   ├── -01-What-Is-BEMA.md
│   ├── 000-Introductory-Lesson.md
│   ├── 001-Trust-the-Story.md
│   └── ...
├── presentations/          (only episodes with presentations)
│   ├── 001-Trust-the-Story.pdf
│   ├── 003-Master-the-Beast.pdf
│   └── ...
├── -01-What-Is-BEMA.md     (episode summaries)
├── 000-Introductory-Lesson.md
├── 001-Trust-the-Story.md
└── ...
```

### Book Output
```
history/
└── chapter-NN.md
```

## File Naming Convention

**CRITICAL**: Episode numbers must sort naturally in filesystem order:
- Episode -1 → `-01` (prefix with dash, zero-pad)
- Episode 0 → `000` (three digits)
- Episode 1 → `001` (three digits)
- Episode 42 → `042` (three digits)
- Episode 123 → `123` (three digits)

Format: `NNN-Episode-Title.ext` (dash-separated, no spaces)

Example: `-01-What-Is-BEMA.md` sorts before `000-Introductory-Lesson.md`

## Workflow for Each Episode

1. **Navigate to episode page**: `https://www.bemadiscipleship.com/{episode_number}`
   - Note: Can also use `https://www.bemadiscipleship.com/episodes/{episode_number}`

2. **Extract episode metadata**:
   - Season number
   - Episode number (including negative episodes)
   - Episode title
   - Transcript URL (usually Google Docs link)
   - Presentation PDF URL (if available - not all episodes have presentations)
   - Check the episode page for a link like "Presentation (PDF)" or similar

3. **Download transcript** (use a subagent for this process):
   - Download HTML from Google Docs published link using curl
   - Convert HTML to markdown using markdownify Python library
   - Extract and preserve metadata header:
     - Episode title (make bold: `**BEMA N: Title (Year)**`)
     - Transcription Status section
     - Release dates
     - Transcription Volunteers names
   - Add horizontal rule (`---`) after metadata
   - Extract transcript starting from first speaker dialogue
   - Replace non-breaking spaces (`\xa0`) with regular spaces
   - Make all speaker names bold using regex:
     - Pattern: `^(\w+(?:\s+\w+)?:)` → `**$1**` (matches 1-2 words before colon at start of paragraph)
     - This captures any speaker name (hosts and guests)
   - Save as: `season-N/transcripts/NNN-Title.md`
   - Preserve all dialogue verbatim

4. **Download presentation** (if available):
   - Check the episode page for a presentation PDF link
   - Not all episodes have presentations - skip this step if none exists
   - If found, download PDF from S3 or provided link
   - Save as: `season-N/presentations/NNN-Title.pdf`
   - Use curl with `-L` flag for redirects

5. **Create episode summary**:
   - Use a general-purpose subagent to read the transcript
   - Generate comprehensive markdown summary including:
     - Main themes and key concepts
     - Theological insights
     - Hebrew/Greek terms with definitions
     - Literary patterns
     - Practical applications
     - Recommended resources
     - Study questions
   - Save as: `season-N/NNN-Title.md`

## Book Creation Process (Seasons 1-4)

**Use Opus 4.5 model for this phase**

### Phase 1: Outline Creation
1. Read all episode summaries from seasons 1-4
2. Identify natural thematic groupings
3. Create chapter structure based on CONTENT, not episodes
   - Topics often span multiple episodes
   - Group related concepts together
   - Consider narrative flow and pedagogical progression
4. Save outline for review

### Phase 2: Chapter Writing
1. For each chapter in the outline:
   - Delegate to an Opus 4.5 subagent
   - Provide relevant episode summaries
   - Instruct to write cohesive chapter prose
   - Focus on book-style narrative (not episode summaries)
   - **Scripture citations**: When referencing Scripture, quote it directly and include reference in parentheses
     - Example: Jesus prayed "that they may be one, as we are one" (John 17:22)
     - Use appropriate translation (ESV, NIV, NRSV as contextually appropriate)
2. Save as: `history/chapter-NN.md`
3. Use two-digit chapter numbers (01, 02, etc.)

## Technical Notes

### Web Scraping
- Main episodes page: `https://www.bemadiscipleship.com/episodes`
- Individual episode: `https://www.bemadiscipleship.com/{N}` or `https://www.bemadiscipleship.com/episodes/{N}`
- Transcripts are hosted on Google Docs (published links)
- Presentations (when available) are in AWS S3: `bemadiscipleship.s3.us-east-2.amazonaws.com`
- Not all episodes have presentation PDFs - check episode page for availability

### Episode Numbering
- Episode -1 exists (introductory content)
- Episode 0 exists (cultural context)
- Regular episodes start at 1
- 496 total episodes across 9 seasons
- Season 1-4 are the initial focus for book creation

### Agent Strategy
- Use general-purpose agents for episode summarization
- Use Opus 4.5 agents for book outline and chapter writing
- Haiku agents acceptable for repetitive download tasks
- Preserve context about thematic connections between episodes

## Quality Standards

### Transcripts
- Preserve speaker names and structure
- Keep formatting readable
- Include all content (don't truncate)

### Summaries
- Comprehensive but concise
- Well-formatted markdown
- Include study questions
- Preserve Hebrew/Greek terminology
- Note connections to other episodes

### Book Chapters
- Cohesive narrative prose
- Natural thematic flow
- Not just episode summaries stitched together
- Pedagogically sound progression
- Chapter-level introductions and conclusions

## Current Status

As of this writing:
- ✅ Folder structure created for Season 1
- ✅ Episode 001 transcript downloaded and processed (with metadata and bold speakers)
- ✅ Episode 001 presentation downloaded
- ✅ Episode 001 summary created
- ✅ Episode 002 transcript downloaded and processed
- ✅ Episode 002 summary created (no presentation available)
- ⏳ Awaiting user review before continuing

## Next Steps

1. Process remaining Season 1 episodes (including -1 and 0)
2. Process Seasons 2-4
3. Create book outline
4. Write book chapters