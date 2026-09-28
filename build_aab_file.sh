#!/bin/bash
# =============================================================================
# build_aab_file.sh — Build an Android App Bundle (.aab) for Google Play release
# Project: rngjff (com.bco.random_name)
# =============================================================================

set -e  # Exit immediately on any error

# ── Colors for output ────────────────────────────────────────────────────────
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# ── Navigate to project root (same directory as this script) ─────────────────
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$SCRIPT_DIR"

echo -e "${CYAN}========================================${NC}"
echo -e "${CYAN}  Building AAB for Google Play Release  ${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# ── Step 1: Verify Flutter is available ──────────────────────────────────────
echo -e "${YELLOW}[1/5] Checking Flutter installation...${NC}"
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}Error: Flutter is not installed or not in PATH.${NC}"
    exit 1
fi
flutter --version
echo ""

# ── Step 2: Verify signing key exists ────────────────────────────────────────
echo -e "${YELLOW}[2/5] Verifying signing configuration...${NC}"
KEY_PROPERTIES="$SCRIPT_DIR/android/key.properties"
if [ ! -f "$KEY_PROPERTIES" ]; then
    echo -e "${RED}Error: android/key.properties not found.${NC}"
    echo -e "${RED}Please create key.properties with your keystore details.${NC}"
    exit 1
fi

# Read storeFile path from key.properties and verify it exists
STORE_FILE=$(grep 'storeFile=' "$KEY_PROPERTIES" | cut -d'=' -f2)
if [ ! -f "$STORE_FILE" ]; then
    echo -e "${RED}Error: Keystore file not found at: $STORE_FILE${NC}"
    exit 1
fi
echo -e "${GREEN}✓ Signing configuration verified.${NC}"
echo ""

# ── Step 3: Clean previous builds ───────────────────────────────────────────
echo -e "${YELLOW}[3/5] Cleaning previous build artifacts...${NC}"
flutter clean
echo -e "${GREEN}✓ Clean complete.${NC}"
echo ""

# ── Step 4: Get dependencies ────────────────────────────────────────────────
echo -e "${YELLOW}[4/5] Fetching dependencies...${NC}"
flutter pub get
echo -e "${GREEN}✓ Dependencies fetched.${NC}"
echo ""

# ── Step 5: Build the AAB ───────────────────────────────────────────────────
echo -e "${YELLOW}[5/5] Building release AAB...${NC}"
flutter build appbundle --release

echo ""
echo -e "${CYAN}========================================${NC}"
echo -e "${GREEN}  ✓ BUILD SUCCESSFUL${NC}"
echo -e "${CYAN}========================================${NC}"
echo ""

# ── Locate and display the output path ──────────────────────────────────────
AAB_PATH="$SCRIPT_DIR/build/app/outputs/bundle/release/app-release.aab"
if [ -f "$AAB_PATH" ]; then
    AAB_SIZE=$(du -h "$AAB_PATH" | cut -f1)
    echo -e "${GREEN}AAB file:${NC} $AAB_PATH"
    echo -e "${GREEN}Size:${NC}     $AAB_SIZE"
else
    echo -e "${YELLOW}AAB file expected at:${NC} $AAB_PATH"
fi

echo ""
echo -e "${CYAN}Upload this .aab file to Google Play Console.${NC}"
