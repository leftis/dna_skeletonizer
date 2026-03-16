# Universal DNA Skeletonizer (TOON 2.0)

The Universal DNA Skeletonizer is a high-performance utility designed to extract the architectural essence of a codebase into a high-density, sigil-based format called TOON (Token-Oriented Object Notation). This format is specifically optimized for Large Language Models (LLMs), enabling them to process complex, multi-folder projects while consuming minimal tokens.

## Core Features

* **Recursive Context Discovery**: Automatically identifies sub-projects, microservices, or modules within a repository and treats each as a distinct context.
* **Automatic Stack Detection**: Detects frameworks and platforms including Shopify Extensions, Ruby on Rails, Scrapy (Python), Node.js, Go, and Rust.
* **Per-Folder Scoped Symbol Extraction**: Executes universal-ctags on a per-directory basis to ensure symbol accuracy and prevent path collisions in mono-repos or multi-service workspaces.
* **Token-Dense Sigil Format**: Utilizes the TOON 2.0 specification to maximize context window availability by removing redundant prose, spaces, and indentation.
* **Multi-Manifest Parsing**: Extracts dependency metadata from Gemfile, package.json, requirements.txt, scrapy.cfg, and various .toml files.

## High-Density Sigil Specification (TOON 2.0)

The output uses a system of sigils to communicate hierarchy and data types to the LLM:

* **§** : Folder / Context Start
* **!** : Manifest / Dependency List
* **~** : File Header
* **>** : Symbol (Format: Kind:Name)

## Prerequisites

* **Universal Ctags**: Required for cross-language symbol extraction. Ensure you are using Universal Ctags rather than the legacy Exuberant Ctags.
* **Tree**: Required for directory mapping.
* **Standard POSIX Utilities**: Requires AWK and Grep (compatible with both MacOS/BSD and Linux/GNU).

## Installation and Usage

1. Save the `dna.sh` script to your project root.
2. Grant execution permissions: `chmod +x dna.sh`.
3. Run the script on a target directory:
   ```bash
   ./dna.sh .