#!/bin/bash
# =====================================================
# Radixa Website — One-Command Cloudflare Deploy
# Usage: ./deploy.sh "your commit message"
#        ./deploy.sh           (uses auto timestamp)
# =====================================================

set -e  # Exit on any error

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

PROJECT_NAME="radixa-website"
BRANCH="main"

echo ""
echo -e "${BLUE}🚀 Radixa Website — Cloudflare Deploy${NC}"
echo "────────────────────────────────────────"

# Step 1: Commit message
COMMIT_MSG="${1:-"deploy: update $(date '+%Y-%m-%d %H:%M')"}"
echo -e "${YELLOW}📝 Commit message: ${COMMIT_MSG}${NC}"
echo ""

# Step 2: Git add + commit + push
echo -e "${BLUE}[1/3] Pushing to GitHub...${NC}"
git add -A

# Check if there's anything to commit
if git diff --staged --quiet; then
  echo -e "${YELLOW}⚠  No changes to commit — deploying current code${NC}"
else
  git commit -m "$COMMIT_MSG"
  git push origin "$BRANCH"
  echo -e "${GREEN}✅ GitHub push done${NC}"
fi

echo ""

# Step 3: Deploy to Cloudflare Pages
echo -e "${BLUE}[2/3] Deploying to Cloudflare Pages...${NC}"
npx wrangler pages deploy . \
  --project-name "$PROJECT_NAME" \
  --branch "$BRANCH" \
  --commit-dirty=true 2>&1 | grep -E "(Uploading|Deployed|Deployment complete|Error|✨|🌎)"

echo ""

# Step 4: Done
echo -e "${GREEN}[3/3] ✅ Deploy complete!${NC}"
echo "────────────────────────────────────────"
echo -e "${GREEN}🌐 Live at: https://radixa.in${NC}"
echo -e "${BLUE}📦 Dashboard: https://dash.cloudflare.com${NC}"
echo ""
