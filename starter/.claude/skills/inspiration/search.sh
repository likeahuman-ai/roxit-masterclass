#!/usr/bin/env bash
# cosmos-inspo: search cosmos.so for visual inspiration.
# Usage: search.sh "<query>" [count]
#   count: 1..80 (default 24)
# Outputs (stdout): compact summary with image URLs Claude can cite.
# Side effects: writes /tmp/cosmos-inspo/<timestamp>-<slug>/{results.json,index.html,summary.json}
# and opens the HTML gallery in browser (macOS).

set -euo pipefail

QUERY="${1:-}"
COUNT="${2:-24}"

if [[ -z "$QUERY" ]]; then
  echo "ERROR: query required. Usage: search.sh \"<query>\" [count]" >&2
  exit 1
fi
if ! [[ "$COUNT" =~ ^[0-9]+$ ]]; then COUNT=24; fi
if (( COUNT < 1 )); then COUNT=1; fi
if (( COUNT > 80 )); then COUNT=80; fi

TS=$(date '+%Y-%m-%d-%H%M%S')
SLUG=$(printf '%s' "$QUERY" | tr '[:upper:]' '[:lower:]' | sed -E 's/[^a-z0-9]+/-/g; s/^-+//; s/-+$//' | cut -c1-40)
# COSMOS_OUT_DIR env var overrides default output location (used by /moodboard)
OUT_DIR="${COSMOS_OUT_DIR:-/tmp/cosmos-inspo/${TS}-${SLUG}}"
mkdir -p "$OUT_DIR"
# COSMOS_NO_OPEN=1 suppresses opening the browser (useful for batch runs)

API='https://api.cosmos.so/graphql?q=SearchGlobalElements'
GQL='query SearchGlobalElements($searchTerm: String!, $origin: SearchOrigin, $pageCursor: String) { searchElements(searchTerm: $searchTerm, searchOrigin: $origin, meta: {pageSize: '"$COUNT"', pageCursor: $pageCursor}) { items { __typename id shareUrl originalClusterId generatedCaption { text } source { url author { username fullName } } ... on MediaElementTile { media { __typename url width height ... on AnimatedImage { video { url } } } } ... on WebsiteElementTile { websiteTitle: title websiteDescription: description media { url width height } } ... on ProductElementTile { productTitle: name productBrand: brand media { url width height } } } meta { count nextPageCursor } } }'

PAYLOAD=$(jq -n --arg q "$QUERY" --arg gql "$GQL" '{operationName:"SearchGlobalElements", variables:{searchTerm:$q, origin:"SEARCH_BOX", pageCursor:null}, query:$gql}')

RAW=$(curl -sS -X POST "$API" \
  -H 'content-type: application/json' \
  -H 'origin: https://www.cosmos.so' \
  -H 'referer: https://www.cosmos.so/' \
  -H 'x-client-name: cosmos-web' \
  -H 'accept: application/graphql-response+json,application/json;q=0.9' \
  --data-raw "$PAYLOAD")

echo "$RAW" > "$OUT_DIR/results.json"

if echo "$RAW" | jq -e '.errors' >/dev/null 2>&1; then
  echo "ERROR from cosmos.so:" >&2
  echo "$RAW" | jq '.errors' >&2
  exit 3
fi

ITEM_COUNT=$(echo "$RAW" | jq '.data.searchElements.items | length')
TOTAL=$(echo "$RAW" | jq '.data.searchElements.meta.count')

# Compact JSON summary for downstream skills/agents
echo "$RAW" | jq --arg q "$QUERY" --arg dir "$OUT_DIR" '{
  query: $q,
  out_dir: $dir,
  total: .data.searchElements.meta.count,
  next_cursor: .data.searchElements.meta.nextPageCursor,
  items: [
    .data.searchElements.items[] | {
      id,
      type: .__typename,
      caption: ((.generatedCaption.text // .websiteTitle // .productTitle // "") | gsub("<n>";"") | gsub("</n>";"")),
      image: (.media.url // null),
      video: (.media.video.url // null),
      width: (.media.width // null),
      height: (.media.height // null),
      share_url: .shareUrl,
      cluster_id: .originalClusterId,
      source_url: (.source.url // null),
      source_author: (.source.author.username // .source.author.fullName // null)
    }
  ]
}' > "$OUT_DIR/summary.json"

# Build HTML gallery
HTML="$OUT_DIR/index.html"
QUERY_ESC=$(printf '%s' "$QUERY" | sed 's/&/\&amp;/g; s/</\&lt;/g; s/>/\&gt;/g')
QUERY_URI=$(printf '%s' "$QUERY" | jq -sRr @uri)

cat > "$HTML" <<HTML_HEAD
<!doctype html>
<html lang="en"><head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>cosmos · ${QUERY_ESC}</title>
<style>
  :root { color-scheme: dark; }
  * { box-sizing: border-box; }
  body { margin: 0; background: #0a0a0a; color: #e8e8e8; font: 14px/1.5 -apple-system, BlinkMacSystemFont, "Inter", sans-serif; }
  header { padding: 24px 24px 16px; border-bottom: 1px solid #1a1a1a; position: sticky; top: 0; background: rgba(10,10,10,.92); backdrop-filter: blur(8px); z-index: 10; }
  header h1 { margin: 0 0 4px; font-size: 18px; font-weight: 500; letter-spacing: -0.01em; }
  header .meta { color: #888; font-size: 12px; }
  header .meta a { color: #aaa; text-decoration: none; }
  header .meta a:hover { color: #fff; }
  .grid { columns: 4 280px; column-gap: 12px; padding: 16px 24px 64px; }
  @media (max-width: 720px) { .grid { columns: 2 160px; column-gap: 8px; padding: 12px; } }
  figure { break-inside: avoid; margin: 0 0 12px; position: relative; border-radius: 6px; overflow: hidden; background: #141414; }
  figure img, figure video { width: 100%; height: auto; display: block; }
  figure figcaption { position: absolute; inset: auto 0 0 0; padding: 12px; background: linear-gradient(transparent, rgba(0,0,0,.9)); font-size: 12px; line-height: 1.45; color: #ddd; opacity: 0; transition: opacity .15s; pointer-events: none; }
  figure:hover figcaption { opacity: 1; }
  figure a.src { position: absolute; top: 8px; right: 8px; padding: 4px 8px; background: rgba(0,0,0,.7); color: #fff; font-size: 11px; text-decoration: none; border-radius: 4px; opacity: 0; transition: opacity .15s; }
  figure:hover a.src { opacity: 1; }
  figcaption .hi { color: #fff; font-weight: 500; }
</style>
</head><body>
<header>
  <h1>cosmos · ${QUERY_ESC}</h1>
  <div class="meta">${ITEM_COUNT} of ${TOTAL} results · <a href="https://www.cosmos.so/search?q=${QUERY_URI}" target="_blank">open on cosmos.so</a></div>
</header>
<div class="grid">
HTML_HEAD

# Render each figure. Build raw caption with <n>...</n>, then escape & re-insert spans.
echo "$RAW" | jq -r '
  def htmlEscape:
    gsub("&"; "&amp;")
    | gsub("<(?!/?n>)"; "&lt;")
    | gsub("(?<!<)/?n>"; "/n>");
  .data.searchElements.items[]
  | (.media.url // "") as $img
  | (.media.video.url // "") as $vid
  | (.shareUrl // "") as $share
  | ((.generatedCaption.text // .websiteTitle // .productTitle // "")) as $rawcap
  | if ($img == "" and $vid == "") then empty
    else
      "<figure>"
      + (if $vid != "" then
          "<video src=\"" + $vid + "\" autoplay loop muted playsinline></video>"
         else
          "<img loading=\"lazy\" src=\"" + $img + "\" alt=\"\">"
         end)
      + (if $share != "" then "<a class=\"src\" href=\"" + $share + "\" target=\"_blank\">↗</a>" else "" end)
      + (if $rawcap != "" then
          "<figcaption>"
          + ( $rawcap
              | gsub("&"; "AMP")
              | gsub("<n>"; "NS")
              | gsub("</n>"; "NE")
              | gsub("<"; "&lt;")
              | gsub(">"; "&gt;")
              | gsub("AMP"; "&amp;")
              | gsub("NS"; "<span class=\"hi\">")
              | gsub("NE"; "</span>")
            )
          + "</figcaption>"
         else "" end)
      + "</figure>"
    end
' >> "$HTML"

echo "</div></body></html>" >> "$HTML"

# stdout summary for Claude
echo "🌌 cosmos-inspo · \"$QUERY\""
echo "   $ITEM_COUNT shown of $TOTAL total · $OUT_DIR"
echo "   gallery: $HTML"
echo "   summary: $OUT_DIR/summary.json"
echo ""
echo "Top references:"
jq -r '.items[:8][] | "• " + (.caption // "(no caption)" | .[0:140]) + "\n  ↗ " + .share_url + (if .image then "\n  🖼  " + .image else "" end)' "$OUT_DIR/summary.json"

if [[ "${COSMOS_NO_OPEN:-}" != "1" ]] && command -v open >/dev/null 2>&1; then
  open "$HTML" >/dev/null 2>&1 || true
fi
