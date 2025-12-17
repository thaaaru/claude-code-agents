#!/bin/bash

# Claude Code Agents - Installation Script
# Supports backup, selective installation, and updates

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
AGENTS_DIR="${SCRIPT_DIR}/agents"

# Default installation target
INSTALL_TARGET=""

# Functions
print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Claude Code Agents Installer${NC}"
    echo -e "${BLUE}================================${NC}\n"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_error() {
    echo -e "${RED}✗${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}⚠${NC} $1"
}

print_info() {
    echo -e "${BLUE}ℹ${NC} $1"
}

show_help() {
    cat << EOF
Usage: ./install.sh [OPTIONS]

Options:
    -g, --global            Install agents globally (~/.claude/agents)
    -p, --project           Install agents to current project (.claude/agents)
    -s, --selective         Choose which agents to install
    -u, --update            Update existing agents
    -b, --backup            Create backup before installation
    -l, --list              List all available agents
    -h, --help              Show this help message

Examples:
    ./install.sh --global               # Install all agents globally
    ./install.sh --project --selective  # Selectively install to project
    ./install.sh -g -b                  # Install globally with backup
    ./install.sh --list                 # List available agents

EOF
}

list_agents() {
    echo -e "\n${BLUE}Available Agents (30 total):${NC}\n"

    local count=1
    for agent in "${AGENTS_DIR}"/*.md; do
        local name=$(basename "$agent" .md)
        local desc=$(grep "^description:" "$agent" | sed 's/description: //' | sed 's/^["'\'']//' | sed 's/["'\'']$//')

        printf "${GREEN}%2d.${NC} %-30s\n" "$count" "$name"
        if [ -n "$desc" ]; then
            echo "    ${desc:0:70}..."
        fi
        echo ""
        ((count++))
    done
}

create_backup() {
    local target_dir=$1

    if [ ! -d "$target_dir" ]; then
        print_info "No existing agents to backup in $target_dir"
        return 0
    fi

    local backup_dir="${target_dir}.backup.$(date +%Y%m%d_%H%M%S)"

    print_info "Creating backup at $backup_dir"
    cp -r "$target_dir" "$backup_dir"
    print_success "Backup created successfully"
}

select_agents() {
    local agents=()
    local count=1

    echo -e "\n${BLUE}Select agents to install:${NC}"
    echo -e "${YELLOW}Enter numbers separated by spaces (e.g., 1 3 5 10), or 'all' for all agents${NC}\n"

    for agent in "${AGENTS_DIR}"/*.md; do
        local name=$(basename "$agent" .md)
        printf "${GREEN}%2d.${NC} %s\n" "$count" "$name"
        agents+=("$agent")
        ((count++))
    done

    echo ""
    read -p "Enter your selection: " selection

    if [ "$selection" = "all" ]; then
        echo "${agents[@]}"
    else
        local selected_agents=()
        for num in $selection; do
            if [ "$num" -ge 1 ] && [ "$num" -le "${#agents[@]}" ]; then
                selected_agents+=("${agents[$((num-1))]}")
            fi
        done
        echo "${selected_agents[@]}"
    fi
}

check_agent_exists() {
    local target_dir=$1
    local agent_name=$2

    if [ -f "${target_dir}/${agent_name}" ]; then
        return 0
    else
        return 1
    fi
}

install_agent() {
    local source_file=$1
    local target_dir=$2
    local update_mode=$3
    local agent_name=$(basename "$source_file")

    # Create target directory if it doesn't exist
    mkdir -p "$target_dir"

    local target_file="${target_dir}/${agent_name}"

    if check_agent_exists "$target_dir" "$agent_name"; then
        if [ "$update_mode" = "true" ]; then
            print_warning "Updating: $agent_name"
            cp "$source_file" "$target_file"
            print_success "Updated: $agent_name"
        else
            print_info "Skipping (already exists): $agent_name"
        fi
    else
        cp "$source_file" "$target_file"
        print_success "Installed: $agent_name"
    fi
}

determine_install_target() {
    if [ -n "$INSTALL_TARGET" ]; then
        echo "$INSTALL_TARGET"
        return
    fi

    echo -e "\n${BLUE}Where would you like to install the agents?${NC}\n"
    echo "  1) Global - Available to all projects (~/.claude/agents)"
    echo "  2) Project - Current project only (.claude/agents)"
    echo ""
    read -p "Enter your choice (1 or 2): " choice

    case $choice in
        1)
            echo "$HOME/.claude/agents"
            ;;
        2)
            echo "./.claude/agents"
            ;;
        *)
            print_error "Invalid choice. Exiting."
            exit 1
            ;;
    esac
}

main() {
    local selective=false
    local update=false
    local backup=false
    local list_only=false

    # Parse command line arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -g|--global)
                INSTALL_TARGET="$HOME/.claude/agents"
                shift
                ;;
            -p|--project)
                INSTALL_TARGET="./.claude/agents"
                shift
                ;;
            -s|--selective)
                selective=true
                shift
                ;;
            -u|--update)
                update=true
                shift
                ;;
            -b|--backup)
                backup=true
                shift
                ;;
            -l|--list)
                list_only=true
                shift
                ;;
            -h|--help)
                show_help
                exit 0
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done

    print_header

    # List only mode
    if [ "$list_only" = true ]; then
        list_agents
        exit 0
    fi

    # Verify agents directory exists
    if [ ! -d "$AGENTS_DIR" ]; then
        print_error "Agents directory not found: $AGENTS_DIR"
        exit 1
    fi

    # Determine installation target
    local target_dir=$(determine_install_target)
    print_info "Installation target: $target_dir"

    # Create backup if requested
    if [ "$backup" = true ]; then
        create_backup "$target_dir"
    fi

    # Select agents to install
    local agents_to_install
    if [ "$selective" = true ]; then
        agents_to_install=($(select_agents))
    else
        agents_to_install=("${AGENTS_DIR}"/*.md)
    fi

    # Check if any agents were selected
    if [ ${#agents_to_install[@]} -eq 0 ]; then
        print_error "No agents selected for installation"
        exit 1
    fi

    # Install agents
    echo -e "\n${BLUE}Installing agents...${NC}\n"
    local installed_count=0
    local updated_count=0
    local skipped_count=0

    for agent in "${agents_to_install[@]}"; do
        if [ -f "$agent" ]; then
            local agent_name=$(basename "$agent")
            if check_agent_exists "$target_dir" "$agent_name" && [ "$update" = false ]; then
                print_info "Skipping (already exists): $agent_name"
                ((skipped_count++))
            else
                install_agent "$agent" "$target_dir" "$update"
                if check_agent_exists "$target_dir" "$agent_name"; then
                    ((updated_count++))
                else
                    ((installed_count++))
                fi
            fi
        fi
    done

    # Summary
    echo -e "\n${BLUE}Installation Summary:${NC}"
    echo -e "  ${GREEN}New installations:${NC} $installed_count"
    if [ "$update" = true ]; then
        echo -e "  ${YELLOW}Updated:${NC} $updated_count"
    fi
    if [ $skipped_count -gt 0 ]; then
        echo -e "  ${BLUE}Skipped:${NC} $skipped_count"
    fi

    echo -e "\n${GREEN}Installation complete!${NC}"
    echo -e "\nTo verify installation, run: ${BLUE}ls $target_dir${NC}"
    echo -e "Or in Claude Code, use: ${BLUE}/agents${NC}\n"
}

# Run main function
main "$@"
