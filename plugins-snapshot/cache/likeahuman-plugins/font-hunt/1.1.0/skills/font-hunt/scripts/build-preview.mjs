#!/usr/bin/env node
/**
 * build-preview.mjs
 *
 * Assembles the font-hunt HTML specimen board from the synthesised candidate YAML.
 *
 * Usage:
 *   node build-preview.mjs <candidates.json> <output.html>
 */

import { readFileSync, writeFileSync } from 'node:fs';
import { fileURLToPath } from 'node:url';
import { dirname, join } from 'node:path';

const __dirname = dirname(fileURLToPath(import.meta.url));
const SKILL_ROOT = join(__dirname, '..');

const TEMPLATE_PATH = join(SKILL_ROOT, 'references', 'specimen-template.html');
const STYLES_PATH = join(SKILL_ROOT, 'assets', 'preview-styles.css');

const [, , candidatesPath, outputPath] = process.argv;
if (!candidatesPath || !outputPath) {
  console.error('Usage: build-preview.mjs <candidates.json> <output.html>');
  process.exit(1);
}

const data = JSON.parse(readFileSync(candidatesPath, 'utf8'));
const template = readFileSync(TEMPLATE_PATH, 'utf8');
const styles = readFileSync(STYLES_PATH, 'utf8');

const slug = (s) => String(s).toLowerCase().replace(/[^a-z0-9]+/g, '-').replace(/^-|-$/g, '');
const escapeHtml = (s) => String(s ?? '')
  .replace(/&/g, '&amp;')
  .replace(/</g, '&lt;')
  .replace(/>/g, '&gt;')
  .replace(/"/g, '&quot;');
const escapeAttr = (s) => escapeHtml(s).replace(/'/g, '&#39;');
// Strip single/double quotes from font names before embedding in CSS-inside-HTML-attr context.
// Font names never legitimately contain quotes; this prevents broken style="" attributes.
const cssFontName = (s) => String(s ?? '').replace(/['"]/g, '').trim();
const displayUrl = (u) => {
  try { return new URL(u).hostname.replace(/^www\./, ''); } catch { return u; }
};

const pickCopy = (pool, i) => pool[i % pool.length] ?? pool[0] ?? '';

function renderSection(candidate, opts = {}) {
  if (!candidate) return '';
  const { displayCopy, headingCopy, bodyCopy, wildcard = false } = opts;
  const fontFamily = cssFontName(candidate.name);
  const fontFamilyAttr = escapeAttr(fontFamily);
  const risksBlock = candidate.risks
    ? `<p class="fh-risks">Risks: ${escapeHtml(candidate.risks)}</p>`
    : '';
  const cls = wildcard ? 'fh-section fh-section--wildcard' : 'fh-section';
  return `
  <section class="${cls}" data-font="${fontFamilyAttr}" id="fh-${slug(fontFamily)}">
    <div class="fh-specimen">
      <div class="fh-hero" style="font-family: '${fontFamilyAttr}', serif;">${escapeHtml(candidate.name)}</div>
      <div class="fh-display" style="font-family: '${fontFamilyAttr}', serif;">${escapeHtml(displayCopy)}</div>
      <div class="fh-heading" style="font-family: '${fontFamilyAttr}', serif;">${escapeHtml(headingCopy)}</div>
      <div class="fh-body" style="font-family: '${fontFamilyAttr}', serif;">${escapeHtml(bodyCopy)}</div>
      <div class="fh-glyphs" style="font-family: '${fontFamilyAttr}', serif;">
        abcdefghijklmnopqrstuvwxyz<br>
        ABCDEFGHIJKLMNOPQRSTUVWXYZ<br>
        0123456789 ij IJ é è ê ë ñ ß ü ç ø æ œ &ldquo;&rdquo; &lsquo;&rsquo; &amp; @
      </div>
    </div>
    <aside class="fh-meta">
      <div class="fh-meta-row"><span class="fh-label">Foundry</span><span>${escapeHtml(candidate.foundry)}</span></div>
      <div class="fh-meta-row"><span class="fh-label">License</span><span>${escapeHtml(candidate.license)}</span></div>
      <div class="fh-meta-row"><span class="fh-label">Tier</span><span>${escapeHtml(candidate.source_tier)}</span></div>
      <div class="fh-meta-row"><span class="fh-label">Character</span><span>${escapeHtml(candidate.character)}</span></div>
      <div class="fh-meta-row"><span class="fh-label">Source</span><a href="${escapeAttr(candidate.url)}" target="_blank" rel="noopener">${escapeHtml(displayUrl(candidate.url))}</a></div>
      <p class="fh-why">${escapeHtml(candidate.why)}</p>
      ${risksBlock}
      <button class="fh-copy" data-css="${escapeAttr(candidate.css ?? '')}">Copy @font-face</button>
    </aside>
  </section>`;
}

const copyPool = data.copy ?? { display: [''], heading: [''], body: [''] };
let sectionIndex = 0;
const sections = [];

for (const pairing of data.pairings ?? []) {
  sections.push(renderSection(pairing.heading, {
    displayCopy: pickCopy(copyPool.display, sectionIndex),
    headingCopy: pickCopy(copyPool.heading, sectionIndex),
    bodyCopy: pickCopy(copyPool.body, sectionIndex),
  }));
  sectionIndex++;
  sections.push(renderSection(pairing.body, {
    displayCopy: pickCopy(copyPool.display, sectionIndex),
    headingCopy: pickCopy(copyPool.heading, sectionIndex),
    bodyCopy: pickCopy(copyPool.body, sectionIndex),
  }));
  sectionIndex++;
}

for (const wild of data.wildcards ?? []) {
  sections.push(renderSection(wild, {
    displayCopy: pickCopy(copyPool.display, sectionIndex),
    headingCopy: pickCopy(copyPool.heading, sectionIndex),
    bodyCopy: pickCopy(copyPool.body, sectionIndex),
    wildcard: true,
  }));
  sectionIndex++;
}

const fontLinkTags = [
  ...(data.pairings ?? []).flatMap(p => [p.heading?.font_link_tag, p.body?.font_link_tag]),
  ...(data.wildcards ?? []).map(w => w?.font_link_tag),
].filter(Boolean);
const uniqueFontLinks = [...new Set(fontLinkTags)].join('\n  ');

const inlineScript = `
(function() {
  const sections = document.querySelectorAll('.fh-section');
  if ('IntersectionObserver' in window) {
    const io = new IntersectionObserver((entries) => {
      for (const e of entries) {
        if (e.isIntersecting) {
          e.target.classList.add('fh-visible');
          io.unobserve(e.target);
        }
      }
    }, { threshold: 0.15 });
    sections.forEach(s => io.observe(s));
  } else {
    sections.forEach(s => s.classList.add('fh-visible'));
  }

  document.querySelectorAll('.fh-copy').forEach(btn => {
    btn.addEventListener('click', async () => {
      const css = btn.dataset.css || '';
      try {
        await navigator.clipboard.writeText(css);
        const original = btn.textContent;
        btn.textContent = 'Copied';
        btn.classList.add('fh-copied');
        setTimeout(() => {
          btn.textContent = original;
          btn.classList.remove('fh-copied');
        }, 1600);
      } catch (err) {
        console.warn('Clipboard write failed:', err);
      }
    });
  });

  let currentIdx = 0;
  const sectionArray = Array.from(sections);
  document.addEventListener('keydown', (e) => {
    if (e.target.matches('input, textarea')) return;
    if (e.key === 'j' || e.key === 'J') {
      currentIdx = Math.min(currentIdx + 1, sectionArray.length - 1);
      sectionArray[currentIdx].scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
    if (e.key === 'k' || e.key === 'K') {
      currentIdx = Math.max(currentIdx - 1, 0);
      sectionArray[currentIdx].scrollIntoView({ behavior: 'smooth', block: 'start' });
    }
    if (e.key === 'c' || e.key === 'C') {
      const current = sectionArray[currentIdx];
      const btn = current?.querySelector('.fh-copy');
      if (btn) btn.click();
    }
  });
})();
`;

// Pre-compute values once so we don't stringify twice.
const briefVal = escapeHtml(data.brief ?? '');
const dateVal = escapeHtml(data.date ?? new Date().toISOString().slice(0, 10));
const agentsVal = escapeHtml((data.agents_ran ?? []).join(' · '));
const blocklistVal = escapeHtml(data.blocklist_summary ?? '');
const sourcesVal = escapeHtml((data.sources_rotated ?? []).join(' · '));
const sectionsVal = sections.join('\n');

// Function-replacement form avoids $& / $1 / $$ interpolation traps in user-supplied text.
const html = template
  .replace(/\{\{brief\}\}/g, () => briefVal)
  .replace(/\{\{date\}\}/g, () => dateVal)
  .replace(/\{\{agents_ran\}\}/g, () => agentsVal)
  .replace(/\{\{blocklist_summary\}\}/g, () => blocklistVal)
  .replace(/\{\{sources_rotated\}\}/g, () => sourcesVal)
  .replace(/\{\{font_links\}\}/g, () => uniqueFontLinks)
  .replace(/\{\{inline_styles\}\}/g, () => styles)
  .replace(/\{\{sections\}\}/g, () => sectionsVal)
  .replace(/\{\{inline_script\}\}/g, () => inlineScript);

writeFileSync(outputPath, html, 'utf8');
console.log(`Written: ${outputPath}`);
