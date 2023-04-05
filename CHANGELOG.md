# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).

## [Unreleased]

### Added
- Allow conditional rendering (#26)

### Changed
- Requires `require "blueprint/html"` to use `Blueprint::HTML` module

## [0.1.0] - 2023-03-27

### Added
- Basic html builder
- Allow element attributes
- Allow rendering blueprints
- Allow NamedTuple attributes
- Add `doctype` util
- Transform attribute names
- Handle boolean attributes
- Escape content
- Add `comment` util
- Add `whitespace` util
- Allow custom component registration
- Allow custom element registration