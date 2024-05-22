# Budget Buddy CLI Tool

This is a simple tool meant to make local development easier. It downloads all repositories, builds them, and containerizes them for you, rather than having to do all that work manually. It also can start up all of the services in the correct order with the correct environment variables.

### Prerequisites

Make sure you have the following installed on your machine:

- Node.js
- npm
- Git
- Maven
- Docker

## Setup

### 1. Install dependencies

`npm i`

### 2. Build the project

`npm run build`

### 3. Link the command to your npm
`npm link`

## Usage

### Commands

#### 1. `buddy build`

```
Usage: buddy build [options]

Clone all repositories

Options:
  -a, --all   Clones all repositories, skips asking which ones to clone.
  -h, --help  display help for comman
```

#### 2. `buddy clean`

```
Usage: buddy clean [options]

Remove all repositories

Options:
  -h, --help  display help for command
```
