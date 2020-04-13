# Makefile for repo-checkout action

# Setup roots
WORKSPACE_ROOT := $(CURDIR)/../../..
PROJECT_ROOT := $(CURDIR)
DEVENV_ROOT := $(WORKSPACE_ROOT)/tools/devenv

# Main makefile suite - defs
include $(DEVENV_ROOT)/main.mk

# Default target is stubbed
default: stub

# Main makefile suite - rules
include $(DEVENV_ROOT)/rules.mk
