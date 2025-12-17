# Claude Code Agents

A comprehensive collection of 30 specialized agents for Claude Code, designed to supercharge your development workflow with expert assistance across multiple domains.

## What are Claude Code Agents?

Claude Code agents are specialized AI assistants that can be invoked to handle specific types of tasks with focused expertise. Each agent has:

- **Specialized knowledge** in a particular domain
- **Restricted tool access** for security and efficiency
- **Optimized prompts** for consistent, high-quality results
- **Clear responsibilities** following the single-responsibility principle

## Agent Collection (30 Agents)

### Security & Quality Assurance
- **security-guardian** - Security reviews, vulnerability assessments, and OWASP compliance
- **ambiguity-guardian** - Manages uncertainties and preserves multiple valid perspectives
- **bug-hunter** - Systematic debugging with hypothesis-driven approach
- **test-coverage** - Test analysis, gap identification, and comprehensive test planning
- **post-task-cleanup** - Codebase hygiene after task completion

### Architecture & Design
- **zen-architect** - Ruthlessly simple architecture design and code review
- **database-architect** - Database design, optimization, and migration planning
- **design-system-architect** - Design system creation and management
- **api-contract-designer** - API design following OpenAPI/REST best practices
- **layout-architect** - Layout and structure design
- **component-designer** - Component architecture and design
- **responsive-strategist** - Responsive design strategies
- **modular-builder** - Builds self-contained, regeneratable modules
- **subagent-architect** - Designs new specialized agents

### Analysis & Knowledge Management
- **analysis-engine** - Multi-mode analysis (DEEP, SYNTHESIS, TRIAGE)
- **knowledge-archaeologist** - Traces evolution of ideas and concepts over time
- **concept-extractor** - Extracts structured knowledge from documents
- **insight-synthesizer** - Discovers revolutionary connections between concepts
- **pattern-emergence** - Detects emergent patterns from diverse perspectives
- **content-researcher** - Researches and analyzes content files
- **graph-builder** - Constructs multi-perspective knowledge graphs

### Implementation & Integration
- **performance-optimizer** - Code and system performance analysis and optimization
- **integration-specialist** - External service integration and dependency management
- **amplifier-cli-architect** - Hybrid code/AI architecture expertise
- **contract-spec-author** - Creates formal contract and implementation specs
- **module-intent-architect** - Translates natural language to module specifications

### Specialized Skills
- **animation-choreographer** - Animation design and implementation
- **art-director** - Visual and artistic direction
- **voice-strategist** - Voice and tone strategy
- **visualization-architect** - Data visualization and interactive graphics

## Quick Start

### Installation

**Option 1: Install all agents globally (recommended)**
```bash
./install.sh --global
```

**Option 2: Install to current project only**
```bash
./install.sh --project
```

**Option 3: Selective installation**
```bash
./install.sh --global --selective
```

**Option 4: Update existing agents**
```bash
./install.sh --global --update --backup
```

### Usage Examples

Once installed, agents are available in Claude Code:

#### List available agents
```
/agents
```

#### Automatic agent selection
Claude Code automatically selects appropriate agents based on your task:

```
User: "Review this authentication code for security vulnerabilities"
Claude: [Automatically invokes security-guardian agent]
```

#### Manual agent invocation
You can also explicitly request an agent:

```
User: "Use the database-architect agent to design a user schema"
```

## Installation Options

### Command Line Options

```
Usage: ./install.sh [OPTIONS]

Options:
    -g, --global            Install agents globally (~/.claude/agents)
    -p, --project           Install agents to current project (.claude/agents)
    -s, --selective         Choose which agents to install
    -u, --update            Update existing agents
    -b, --backup            Create backup before installation
    -l, --list              List all available agents
    -h, --help              Show help message
```

### Examples

**List all available agents:**
```bash
./install.sh --list
```

**Install with backup:**
```bash
./install.sh --global --backup
```

**Selective installation with update:**
```bash
./install.sh --project --selective --update
```

## Agent Details

### Security Guardian
**Purpose**: Pre-deployment security checks, vulnerability assessment, authentication review

**When to use**:
- Before production deployments
- After adding features that handle user data
- When integrating payment processing
- For periodic security reviews

**Tools**: Grep, Read, WebFetch, Bash

### Zen Architect
**Purpose**: Analysis-first development with ruthless simplicity

**Modes**:
- **ANALYZE**: Break down problems and design solutions
- **ARCHITECT**: System design and module specification
- **REVIEW**: Code quality assessment

**Tools**: All tools available

### Database Architect
**Purpose**: Database design, query optimization, migration planning

**When to use**:
- Designing new schemas
- Optimizing slow queries
- Planning data migrations
- Choosing between SQL/NoSQL

**Tools**: Grep, Read, WebFetch, Bash

### Bug Hunter
**Purpose**: Systematic bug tracking and resolution

**When to use**:
- Encountering errors or exceptions
- Test failures
- Unexpected behavior
- Performance issues

**Tools**: All tools available

### Performance Optimizer
**Purpose**: Profile and optimize code performance

**When to use**:
- Slow API endpoints
- High memory usage
- CPU-intensive operations
- Database query optimization

**Tools**: All tools available

### Integration Specialist
**Purpose**: External service integration and dependency management

**When to use**:
- Connecting to external APIs
- Setting up MCP servers
- Managing dependencies
- Third-party service integration

**Tools**: All tools available

### API Contract Designer
**Purpose**: Design clean, minimal API contracts

**When to use**:
- Creating new REST/GraphQL APIs
- Refactoring existing endpoints
- Standardizing API patterns
- API versioning strategies

**Tools**: Grep, Read, WebFetch, Bash

## Creating Custom Agents

You can create your own agents by adding markdown files to `agents/` directory:

```markdown
---
name: my-custom-agent
description: When to use this agent and what it does
tools: Grep, Read, Write, Edit
model: sonnet
---

# My Custom Agent

You are a specialized agent that...

## Your Expertise
- Area 1
- Area 2

## How You Work
1. Step 1
2. Step 2
```

See [docs/creating-agents.md](docs/creating-agents.md) for detailed instructions.

## Directory Structure

```
claude-code-agents/
├── agents/              # 30 agent definition files (.md)
├── docs/                # Documentation
├── examples/            # Usage examples
├── install.sh           # Installation script
├── README.md           # This file
├── LICENSE             # MIT License
└── .gitignore          # Git ignore rules
```

## Configuration

### Global Installation
Agents installed to `~/.claude/agents/` are available to all projects.

### Project Installation
Agents installed to `.claude/agents/` in your project directory are only available within that project and can be version controlled.

### Priority
When agent names conflict, project-level agents take priority over global agents.

## Requirements

- **Claude Code** - Latest version recommended
- **Bash** - For running the installation script
- **Git** - For cloning the repository

## Best Practices

1. **Start with global installation** - Make agents available everywhere
2. **Use backup option** - Protect existing customizations
3. **Selective installation** - Choose only agents you need for better performance
4. **Update regularly** - Keep agents current with improvements
5. **Read agent descriptions** - Understand when to use each agent

## Troubleshooting

### Agents not appearing in Claude Code
```bash
# Verify installation location
ls ~/.claude/agents/

# Check file permissions
chmod 644 ~/.claude/agents/*.md

# Restart Claude Code
```

### Installation script permission denied
```bash
chmod +x install.sh
```

### Backup restore
```bash
# Backups are created with timestamp
ls -la ~/.claude/agents.backup.*

# Restore from backup
cp -r ~/.claude/agents.backup.20250101_120000/* ~/.claude/agents/
```

## Contributing

Contributions are welcome! To add new agents:

1. Fork the repository
2. Create an agent definition in `agents/`
3. Test thoroughly
4. Submit a pull request

## License

MIT License - See [LICENSE](LICENSE) file for details.

## Resources

- [Claude Code Documentation](https://code.claude.com/docs)
- [Sub-agents Guide](https://code.claude.com/docs/en/sub-agents.md)
- [Creating Custom Agents](docs/creating-agents.md)

## Acknowledgments

This collection represents specialized expertise across:
- Software architecture and design
- Security and quality assurance
- Performance optimization
- Knowledge management
- Integration patterns
- Testing strategies

Each agent embodies best practices and domain expertise refined through practical application.

## Support

For issues, questions, or suggestions:
- Open an issue on GitHub
- Check the documentation in `docs/`
- Review example usage in `examples/`

---

**Made with Claude Code** - Supercharge your development workflow with specialized AI agents!
